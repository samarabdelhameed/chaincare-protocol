#!/usr/bin/env bash

set -e

# Load .env from contracts directory or root
if [ -f "contracts/.env" ]; then
  source contracts/.env
elif [ -f ".env" ]; then
  source .env
else
  echo "❌ Error: .env file not found"
  exit 1
fi

echo "🔨 Building all contracts..."
# Build contracts in root directory
for c in care_space health_sbt care_treasury; do
  if [ -d "contracts/$c" ]; then
    echo "  Building $c..."
    cd contracts/$c
    cargo contract build --release --quiet
    cd ../..
  fi
done

# Build contracts in plugins directory
for c in med_reminder step_counter zk_camera governance flipper; do
  if [ -d "contracts/plugins/$c" ]; then
    echo "  Building $c..."
    cd contracts/plugins/$c
    cargo contract build --release --quiet
    cd ../../..
  fi
done

# Use Shibuya if Paseo RPC is set (Paseo doesn't support contracts yet)
if echo "$RPC_URL" | grep -q "paseo\|ibp.network/paseo"; then
  echo "⚠️  Paseo doesn't support contracts API yet. Switching to Shibuya Testnet..."
  RPC_URL="wss://rpc.shibuya.astar.network"
  NETWORK="shibuya"
fi

echo "📡 Deploying to ${NETWORK:-network}..."
echo "🌐 RPC: $RPC_URL"
echo "👤 Address: $ADDRESS"
echo ""

# Check if addresses.log exists and backup if it does
if [ -f "scripts/addresses.log" ] && [ -s "scripts/addresses.log" ]; then
  echo "⚠️  Found existing addresses.log, backing up..."
  cp scripts/addresses.log "scripts/addresses.log.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Clear addresses.log
> scripts/addresses.log

echo "🚀 Starting deployment..."
echo ""

# 1. Deploy health_sbt first (needed by care_space)
echo "  → health_sbt"
cd contracts/health_sbt
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "${HEALTH_SBT_ADMIN:-$ADDRESS}" \
  --gas "${GAS_LIMIT:-1000000000000}" \
  --skip-confirm 2>&1)

HEALTH_SBT=$(echo "$OUTPUT" | grep -oE 'Contract\s+[0-9A-Za-z]{48}' | awk '{print $2}' || echo "")
if [ -n "$HEALTH_SBT" ]; then
  echo "    ✅ health_sbt = $HEALTH_SBT"
  echo "health_sbt=$HEALTH_SBT" >> ../../scripts/addresses.log
else
  echo "    ❌ Failed to deploy health_sbt"
  echo "$OUTPUT" > deploy.log
  exit 1
fi
cd ../..

# 2. Deploy care_treasury (needed by care_space)
echo "  → care_treasury"
cd contracts/care_treasury
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "${TREASURY_ADMIN:-$ADDRESS}" "${TREASURY_DAILY_RATE:-20}" \
  --gas "${GAS_LIMIT:-1000000000000}" \
  --skip-confirm 2>&1)

TREASURY=$(echo "$OUTPUT" | grep -oE 'Contract\s+[0-9A-Za-z]{48}' | awk '{print $2}' || echo "")
if [ -n "$TREASURY" ]; then
  echo "    ✅ care_treasury = $TREASURY"
  echo "care_treasury=$TREASURY" >> ../../scripts/addresses.log
else
  echo "    ❌ Failed to deploy care_treasury"
  echo "$OUTPUT" > deploy.log
  exit 1
fi
cd ../..

# 3. Deploy care_space (needs treasury and health_sbt addresses)
echo "  → care_space"
cd contracts/care_space
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "${CARE_SPACE_OWNER:-$ADDRESS}" "${CARE_SPACE_NAME:-CareSpace#1}" "${CARE_SPACE_PATIENT:-$ADDRESS}" "$TREASURY" "$HEALTH_SBT" \
  --gas "${GAS_LIMIT:-1000000000000}" \
  --skip-confirm 2>&1)

CARE_SPACE=$(echo "$OUTPUT" | grep -oE 'Contract\s+[0-9A-Za-z]{48}' | awk '{print $2}' || echo "")
if [ -n "$CARE_SPACE" ]; then
  echo "    ✅ care_space = $CARE_SPACE"
  echo "care_space=$CARE_SPACE" >> ../../scripts/addresses.log
else
  echo "    ❌ Failed to deploy care_space"
  echo "$OUTPUT" > deploy.log
  exit 1
fi
cd ../..

# 4. Deploy plugin contracts
for c in med_reminder step_counter zk_camera governance flipper; do
  if [ -d "contracts/plugins/$c" ]; then
    cd contracts/plugins/$c
    echo "  → $c"
    
    # Build args based on contract type
    ARGS=""
    case $c in
      med_reminder)
        ARGS="${MED_REMINDER_MED_ID:-med_001}"
        ;;
      step_counter)
        ARGS="${STEP_COUNTER_ADMIN:-$ADDRESS} ${STEP_COUNTER_DAILY_TARGET:-10000}"
        ;;
      zk_camera)
        ARGS="${ZK_CAMERA_ADMIN:-$ADDRESS}"
        ;;
      governance)
        ARGS="${GOVERNANCE_ADMIN:-$ADDRESS}"
        ;;
      flipper)
        ARGS="false"
        ;;
    esac
    
    OUTPUT=$(cargo contract instantiate \
      --url "$RPC_URL" \
      --suri "$MNEMONIC" \
      --constructor new \
      --args $ARGS \
      --gas "${GAS_LIMIT:-1000000000000}" \
      --skip-confirm 2>&1)
    
    ADDR=$(echo "$OUTPUT" | grep -oE 'Contract\s+[0-9A-Za-z]{48}' | awk '{print $2}' || echo "")
    if [ -n "$ADDR" ]; then
      echo "    ✅ $c = $ADDR"
      echo "$c=$ADDR" >> ../../../scripts/addresses.log
    else
      echo "    ⚠️  $c: Could not extract address"
      echo "$OUTPUT" > deploy.log
    fi
    cd ../../..
  fi
done

echo ""
echo "🎉 All contracts deployed successfully!"
echo ""
echo "📋 Contract addresses saved to: scripts/addresses.log"
echo ""
cat scripts/addresses.log
echo ""
echo "🔗 View on Polkadot.js Apps:"
echo "   https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.shibuya.astar.network#/contracts"
echo ""
echo "🔍 View on Subscan:"
echo "   https://shibuya.subscan.io"
echo ""
echo "✅ Next steps:"
echo "   1. Update oracle/oracle.py with med_reminder address"
echo "   2. Update frontend/src/addresses.shibuya.json"
echo "   3. Test the frontend with real addresses"
