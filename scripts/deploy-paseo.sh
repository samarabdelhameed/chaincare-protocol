#!/bin/bash

# Deploy ChainCARE contracts to Paseo Testnet
# Usage: ./deploy-paseo.sh

set -e

# Check if .env exists
if [ ! -f "contracts/.env" ]; then
  echo "❌ Error: contracts/.env file not found!"
  echo "   Please create it following PASEO_SETUP.md"
  exit 1
fi

# Load .env from contracts directory
cd contracts
source .env 2>/dev/null || export $(cat .env | grep -v '^#' | xargs)
cd ..

# Check required variables
if [ -z "$RPC_URL" ]; then
  echo "❌ Error: RPC_URL not set in .env file!"
  exit 1
fi

if [ -z "$MNEMONIC" ]; then
  echo "❌ Error: MNEMONIC not set in .env file!"
  exit 1
fi

if [ -z "$ADDRESS" ]; then
  echo "❌ Error: ADDRESS not set in .env file!"
  exit 1
fi

RPC_URL="${RPC_URL:-wss://ws.paseo.ara.io}"
GAS="${GAS_LIMIT:-1000000000000}"
ADDRESS="${ADDRESS:-5EeMfMp8ZaY49ygQZfTBNB5aDtKR88DMDmPXxAL3ZAWVzQy}"

echo "🚀 Deploying ChainCARE contracts to Paseo Testnet..."
echo "📝 Address: $ADDRESS"
echo "🌐 RPC: $RPC_URL"
echo ""

# 1. Deploy health_sbt (needed by care_space)
echo "1️⃣ Deploying health_sbt..."
cd contracts/health_sbt
HEALTH_SBT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "${HEALTH_SBT_ADMIN:-$ADDRESS}" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
if [ -z "$HEALTH_SBT" ]; then
  echo "❌ Failed to deploy health_sbt"
  exit 1
fi
echo "✅ health_sbt: $HEALTH_SBT"
cd ../..

# 2. Deploy care_treasury (needed by care_space)
echo ""
echo "2️⃣ Deploying care_treasury..."
cd contracts/care_treasury
TREASURY=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "${TREASURY_ADMIN:-$ADDRESS}" "${TREASURY_DAILY_RATE:-20}" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
if [ -z "$TREASURY" ]; then
  echo "❌ Failed to deploy care_treasury"
  exit 1
fi
echo "✅ care_treasury: $TREASURY"
cd ../..

# 3. Deploy care_space
echo ""
echo "3️⃣ Deploying care_space..."
cd contracts/care_space
CARE_SPACE=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "${CARE_SPACE_OWNER:-$ADDRESS}" "${CARE_SPACE_NAME:-CareSpace#1}" "${CARE_SPACE_PATIENT:-$ADDRESS}" "$TREASURY" "$HEALTH_SBT" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
if [ -z "$CARE_SPACE" ]; then
  echo "❌ Failed to deploy care_space"
  exit 1
fi
echo "✅ care_space: $CARE_SPACE"
cd ../..

# 4. Deploy med_reminder
echo ""
echo "4️⃣ Deploying med_reminder..."
cd contracts/plugins/med_reminder
MED_REMINDER=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "${MED_REMINDER_MED_ID:-med_001}" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
if [ -z "$MED_REMINDER" ]; then
  echo "❌ Failed to deploy med_reminder"
  exit 1
fi
echo "✅ med_reminder: $MED_REMINDER"
cd ../../..

# 5. Deploy step_counter
echo ""
echo "5️⃣ Deploying step_counter..."
cd contracts/plugins/step_counter
STEP_COUNTER=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
if [ -z "$STEP_COUNTER" ]; then
  echo "❌ Failed to deploy step_counter"
  exit 1
fi
echo "✅ step_counter: $STEP_COUNTER"
cd ../../..

# 6. Deploy zk_camera
echo ""
echo "6️⃣ Deploying zk_camera..."
cd contracts/plugins/zk_camera
ZK_CAMERA=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
if [ -z "$ZK_CAMERA" ]; then
  echo "❌ Failed to deploy zk_camera"
  exit 1
fi
echo "✅ zk_camera: $ZK_CAMERA"
cd ../../..

# 7. Deploy governance
echo ""
echo "7️⃣ Deploying governance..."
cd contracts/plugins/governance
GOVERNANCE=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
if [ -z "$GOVERNANCE" ]; then
  echo "❌ Failed to deploy governance"
  exit 1
fi
echo "✅ governance: $GOVERNANCE"
cd ../../..

# Save addresses to JSON file
echo ""
echo "📝 Saving contract addresses..."
cat > frontend/src/addresses.paseo.json <<EOF
{
  "network": "paseo",
  "rpcUrl": "$RPC_URL",
  "contracts": {
    "healthSbt": "$HEALTH_SBT",
    "careTreasury": "$TREASURY",
    "careSpace": "$CARE_SPACE",
    "medReminder": "$MED_REMINDER",
    "stepCounter": "$STEP_COUNTER",
    "zkCamera": "$ZK_CAMERA",
    "governance": "$GOVERNANCE"
  }
}
EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Deployment Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Contract Addresses:"
echo "   health_sbt:    $HEALTH_SBT"
echo "   care_treasury: $TREASURY"
echo "   care_space:    $CARE_SPACE"
echo "   med_reminder:  $MED_REMINDER"
echo "   step_counter:  $STEP_COUNTER"
echo "   zk_camera:     $ZK_CAMERA"
echo "   governance:    $GOVERNANCE"
echo ""
echo "📁 Addresses saved to: frontend/src/addresses.paseo.json"
echo ""
echo "🌐 View on Polkadot.js Apps:"
RPC_ENCODED=$(echo "$RPC_URL" | sed 's|://|%3A%2F%2F|g' | sed 's|/|%2F|g')
echo "   https://polkadot.js.org/apps/?rpc=$RPC_ENCODED#/contracts"
echo ""

