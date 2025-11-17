#!/bin/bash

# Deploy ChainCARE contracts to Astar Shibuya Testnet
# Usage: ./deploy-shibuya.sh YOUR_MNEMONIC YOUR_ADDRESS

set -e

MNEMONIC="$1"
ADDRESS="$2"

if [ -z "$MNEMONIC" ] || [ -z "$ADDRESS" ]; then
  echo "Usage: $0 <MNEMONIC> <YOUR_ADDRESS>"
  exit 1
fi

RPC_URL="wss://rpc.shibuya.astar.network"
GAS="1000000000000"

echo "🚀 Deploying ChainCARE contracts to Shibuya..."
echo "📝 Address: $ADDRESS"
echo ""

# 1. Deploy health_sbt (needed by care_space)
echo "1️⃣ Deploying health_sbt..."
cd contracts/health_sbt
HEALTH_SBT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$ADDRESS" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
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
  --args "$ADDRESS" "20" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
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
  --args "$ADDRESS" "CareSpace#1" "$ADDRESS" "$TREASURY" "$HEALTH_SBT" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
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
  --args "med_001" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
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
  --args "$ADDRESS" "10000" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
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
  --args "$ADDRESS" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
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
  --args "$ADDRESS" \
  --gas "$GAS" \
  --skip-confirm 2>&1 | grep -oP 'Contract\s+\K[^\s]+' || echo "")
echo "✅ governance: $GOVERNANCE"
cd ../../..

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

