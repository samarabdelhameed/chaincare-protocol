#!/bin/bash

# Deploy ChainCARE contracts using .env file
# Make sure to add your MNEMONIC to .env file first!

set -e

# Load .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
else
  echo "❌ Error: .env file not found!"
  echo "Please create .env file from .env.example"
  exit 1
fi

# Check if MNEMONIC is set
if [ -z "$MNEMONIC" ]; then
  echo "❌ Error: MNEMONIC not set in .env file!"
  echo "Please add your MNEMONIC to .env file"
  exit 1
fi

echo "🚀 Deploying ChainCARE contracts to $NETWORK..."
echo "📝 Address: $ADDRESS"
echo "🌐 RPC: $RPC_URL"
echo ""

# 1. Deploy health_sbt
echo "1️⃣ Deploying health_sbt..."
cd health_sbt
HEALTH_SBT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$HEALTH_SBT_ADMIN" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
echo "✅ health_sbt: $HEALTH_SBT"
cd ..

# 2. Deploy care_treasury
echo ""
echo "2️⃣ Deploying care_treasury..."
cd care_treasury
TREASURY=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$TREASURY_ADMIN" "$TREASURY_DAILY_RATE" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
echo "✅ care_treasury: $TREASURY"
cd ..

# 3. Deploy care_space
echo ""
echo "3️⃣ Deploying care_space..."
cd care_space
CARE_SPACE=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$CARE_SPACE_OWNER" "$CARE_SPACE_NAME" "$CARE_SPACE_PATIENT" "$TREASURY" "$HEALTH_SBT" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
echo "✅ care_space: $CARE_SPACE"
cd ..

# 4. Deploy med_reminder
echo ""
echo "4️⃣ Deploying med_reminder..."
cd plugins/med_reminder
MED_REMINDER=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$MED_REMINDER_MED_ID" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
echo "✅ med_reminder: $MED_REMINDER"
cd ../..

# 5. Deploy step_counter
echo ""
echo "5️⃣ Deploying step_counter..."
cd plugins/step_counter
STEP_COUNTER=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$STEP_COUNTER_ADMIN" "$STEP_COUNTER_DAILY_TARGET" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
echo "✅ step_counter: $STEP_COUNTER"
cd ../..

# 6. Deploy zk_camera
echo ""
echo "6️⃣ Deploying zk_camera..."
cd plugins/zk_camera
ZK_CAMERA=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$ZK_CAMERA_ADMIN" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
echo "✅ zk_camera: $ZK_CAMERA"
cd ../..

# 7. Deploy governance
echo ""
echo "7️⃣ Deploying governance..."
cd plugins/governance
GOVERNANCE=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$GOVERNANCE_ADMIN" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
echo "✅ governance: $GOVERNANCE"
cd ../..

echo ""
echo "✅ All contracts deployed!"
echo ""
echo "📋 Addresses:"
echo "  careSpace:    $CARE_SPACE"
echo "  healthSbt:    $HEALTH_SBT"
echo "  treasury:     $TREASURY"
echo "  medReminder:  $MED_REMINDER"
echo "  stepCounter:  $STEP_COUNTER"
echo "  zkCamera:     $ZK_CAMERA"
echo "  governance:   $GOVERNANCE"
echo ""
echo "📝 Update frontend/src/addresses.polkadot-testnet.json with these addresses"

