#!/bin/bash

# Deploy and Verify ChainCARE contracts on Paseo Testnet
# Usage: ./deploy-and-verify-paseo.sh

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if .env exists
if [ ! -f "contracts/.env" ]; then
  echo -e "${RED}❌ Error: contracts/.env file not found!${NC}"
  echo "   Please create it with Paseo settings"
  exit 1
fi

# Load .env
cd contracts
if [ -f .env ]; then
  # Read MNEMONIC specially to handle spaces
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ "$line" =~ ^MNEMONIC= ]]; then
      export "$line"
    elif [[ ! "$line" =~ ^# ]] && [[ ! -z "$line" ]]; then
      export "$line" 2>/dev/null || true
    fi
  done < .env
fi
cd ..

# Force Paseo settings
RPC_URL="wss://rpc.ibp.network/paseo"
GAS="${GAS_LIMIT:-1000000000000}"
ADDRESS="${ADDRESS:-5EeMfMp8ZaY49ygQZfTBNB5aDtKR88DMDmPXxAL3ZAWVzQy}"

# Check required variables
if [ -z "$MNEMONIC" ]; then
  echo -e "${RED}❌ Error: MNEMONIC not set in .env file!${NC}"
  exit 1
fi

echo -e "${BLUE}🚀 Deploying ChainCARE contracts to Paseo Testnet...${NC}"
echo -e "${BLUE}📝 Address: $ADDRESS${NC}"
echo -e "${BLUE}🌐 RPC: $RPC_URL${NC}"
echo ""

# Use arrays instead of associative arrays for compatibility
HEALTH_SBT_ADDR=""
CARE_TREASURY_ADDR=""
CARE_SPACE_ADDR=""
MED_REMINDER_ADDR=""
STEP_COUNTER_ADDR=""
ZK_CAMERA_ADDR=""
GOVERNANCE_ADDR=""

HEALTH_SBT_EXT=""
CARE_TREASURY_EXT=""
CARE_SPACE_EXT=""
MED_REMINDER_EXT=""
STEP_COUNTER_EXT=""
ZK_CAMERA_EXT=""
GOVERNANCE_EXT=""

# Function to deploy contract
deploy_contract() {
  local name=$1
  local dir=$2
  local constructor_args=$3
  local addr_var=$4
  local ext_var=$5
  
  echo -e "${YELLOW}📦 Deploying $name...${NC}"
  cd contracts/$dir
  
  # Build first
  cargo contract build --release > /dev/null 2>&1 || true
  
  # Deploy
  local output=$(cargo contract instantiate \
    --url "$RPC_URL" \
    --suri "$MNEMONIC" \
    --constructor new \
    $constructor_args \
    --gas "$GAS" \
    --skip-confirm 2>&1)
  
  local addr=$(echo "$output" | grep -o 'Contract[[:space:]]*[^[:space:]]*' | sed 's/Contract[[:space:]]*//' | head -1)
  if [ -z "$addr" ]; then
    addr=$(echo "$output" | grep -oE '0x[a-fA-F0-9]{64}' | head -1)
  fi
  local ext_hash=$(echo "$output" | grep -oE 'Extrinsic hash:[[:space:]]*[^[:space:]]*' | sed 's/Extrinsic hash:[[:space:]]*//' | head -1)
  if [ -z "$ext_hash" ]; then
    ext_hash=$(echo "$output" | grep -oE '0x[a-fA-F0-9]{64}' | head -1)
  fi
  
  if [ -z "$addr" ]; then
    echo -e "${RED}❌ Failed to deploy $name${NC}"
    echo "$output"
    cd ../..
    return 1
  fi
  
  eval "$addr_var='$addr'"
  eval "$ext_var='$ext_hash'"
  
  echo -e "${GREEN}✅ $name: $addr${NC}"
  cd ../..
  return 0
}

# 1. Deploy health_sbt
deploy_contract "health_sbt" "health_sbt" "--args ${HEALTH_SBT_ADMIN:-$ADDRESS}" "HEALTH_SBT_ADDR" "HEALTH_SBT_EXT"

# 2. Deploy care_treasury
deploy_contract "care_treasury" "care_treasury" "--args ${TREASURY_ADMIN:-$ADDRESS} ${TREASURY_DAILY_RATE:-20}" "CARE_TREASURY_ADDR" "CARE_TREASURY_EXT"

# 3. Deploy care_space
deploy_contract "care_space" "care_space" "--args ${CARE_SPACE_OWNER:-$ADDRESS} ${CARE_SPACE_NAME:-CareSpace#1} ${CARE_SPACE_PATIENT:-$ADDRESS} $CARE_TREASURY_ADDR $HEALTH_SBT_ADDR" "CARE_SPACE_ADDR" "CARE_SPACE_EXT"

# 4. Deploy med_reminder
deploy_contract "med_reminder" "plugins/med_reminder" "--args ${MED_REMINDER_MED_ID:-med_001}" "MED_REMINDER_ADDR" "MED_REMINDER_EXT"

# 5. Deploy step_counter
deploy_contract "step_counter" "plugins/step_counter" "" "STEP_COUNTER_ADDR" "STEP_COUNTER_EXT"

# 6. Deploy zk_camera
deploy_contract "zk_camera" "plugins/zk_camera" "" "ZK_CAMERA_ADDR" "ZK_CAMERA_EXT"

# 7. Deploy governance
deploy_contract "governance" "plugins/governance" "" "GOVERNANCE_ADDR" "GOVERNANCE_EXT"

# Save addresses
ADDRESSES_FILE="frontend/src/addresses.paseo.json"
mkdir -p frontend/src

cat > "$ADDRESSES_FILE" <<EOF
{
  "network": "paseo",
  "rpcUrl": "$RPC_URL",
  "contracts": {
    "healthSbt": "$HEALTH_SBT_ADDR",
    "careTreasury": "$CARE_TREASURY_ADDR",
    "careSpace": "$CARE_SPACE_ADDR",
    "medReminder": "$MED_REMINDER_ADDR",
    "stepCounter": "$STEP_COUNTER_ADDR",
    "zkCamera": "$ZK_CAMERA_ADDR",
    "governance": "$GOVERNANCE_ADDR"
  }
}
EOF

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📋 Contract Addresses:${NC}"
printf "   %-15s %s\n" "health_sbt:" "$HEALTH_SBT_ADDR"
printf "   %-15s %s\n" "care_treasury:" "$CARE_TREASURY_ADDR"
printf "   %-15s %s\n" "care_space:" "$CARE_SPACE_ADDR"
printf "   %-15s %s\n" "med_reminder:" "$MED_REMINDER_ADDR"
printf "   %-15s %s\n" "step_counter:" "$STEP_COUNTER_ADDR"
printf "   %-15s %s\n" "zk_camera:" "$ZK_CAMERA_ADDR"
printf "   %-15s %s\n" "governance:" "$GOVERNANCE_ADDR"
echo ""
echo -e "${BLUE}📁 Addresses saved to: $ADDRESSES_FILE${NC}"
echo ""

# Verification instructions
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔍 Verification Instructions:${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}For each contract, verify on Subscan or Polkaholic:${NC}"
echo ""

# Subscan URL for Paseo
SUBSCAN_BASE="https://paseo.subscan.io"
POLKAHOLIC_BASE="https://polkaholic.io"

[ ! -z "$HEALTH_SBT_ADDR" ] && echo -e "${GREEN}health_sbt:${NC}" && echo "   Address: $HEALTH_SBT_ADDR" && echo "   Extrinsic: $HEALTH_SBT_EXT" && [ ! -z "$HEALTH_SBT_EXT" ] && echo "   Subscan: $SUBSCAN_BASE/extrinsic/$HEALTH_SBT_EXT" && echo "   Polkaholic: $POLKAHOLIC_BASE/tx/$HEALTH_SBT_EXT" && echo "   Contract file: contracts/target/ink/health_sbt/health_sbt.contract" && echo ""
[ ! -z "$CARE_TREASURY_ADDR" ] && echo -e "${GREEN}care_treasury:${NC}" && echo "   Address: $CARE_TREASURY_ADDR" && echo "   Extrinsic: $CARE_TREASURY_EXT" && [ ! -z "$CARE_TREASURY_EXT" ] && echo "   Subscan: $SUBSCAN_BASE/extrinsic/$CARE_TREASURY_EXT" && echo "   Polkaholic: $POLKAHOLIC_BASE/tx/$CARE_TREASURY_EXT" && echo "   Contract file: contracts/target/ink/care_treasury/care_treasury.contract" && echo ""
[ ! -z "$CARE_SPACE_ADDR" ] && echo -e "${GREEN}care_space:${NC}" && echo "   Address: $CARE_SPACE_ADDR" && echo "   Extrinsic: $CARE_SPACE_EXT" && [ ! -z "$CARE_SPACE_EXT" ] && echo "   Subscan: $SUBSCAN_BASE/extrinsic/$CARE_SPACE_EXT" && echo "   Polkaholic: $POLKAHOLIC_BASE/tx/$CARE_SPACE_EXT" && echo "   Contract file: contracts/target/ink/care_space/care_space.contract" && echo ""
[ ! -z "$MED_REMINDER_ADDR" ] && echo -e "${GREEN}med_reminder:${NC}" && echo "   Address: $MED_REMINDER_ADDR" && echo "   Extrinsic: $MED_REMINDER_EXT" && [ ! -z "$MED_REMINDER_EXT" ] && echo "   Subscan: $SUBSCAN_BASE/extrinsic/$MED_REMINDER_EXT" && echo "   Polkaholic: $POLKAHOLIC_BASE/tx/$MED_REMINDER_EXT" && echo "   Contract file: contracts/target/ink/med_reminder/med_reminder.contract" && echo ""
[ ! -z "$STEP_COUNTER_ADDR" ] && echo -e "${GREEN}step_counter:${NC}" && echo "   Address: $STEP_COUNTER_ADDR" && echo "   Extrinsic: $STEP_COUNTER_EXT" && [ ! -z "$STEP_COUNTER_EXT" ] && echo "   Subscan: $SUBSCAN_BASE/extrinsic/$STEP_COUNTER_EXT" && echo "   Polkaholic: $POLKAHOLIC_BASE/tx/$STEP_COUNTER_EXT" && echo "   Contract file: contracts/target/ink/step_counter/step_counter.contract" && echo ""
[ ! -z "$ZK_CAMERA_ADDR" ] && echo -e "${GREEN}zk_camera:${NC}" && echo "   Address: $ZK_CAMERA_ADDR" && echo "   Extrinsic: $ZK_CAMERA_EXT" && [ ! -z "$ZK_CAMERA_EXT" ] && echo "   Subscan: $SUBSCAN_BASE/extrinsic/$ZK_CAMERA_EXT" && echo "   Polkaholic: $POLKAHOLIC_BASE/tx/$ZK_CAMERA_EXT" && echo "   Contract file: contracts/target/ink/zk_camera/zk_camera.contract" && echo ""
[ ! -z "$GOVERNANCE_ADDR" ] && echo -e "${GREEN}governance:${NC}" && echo "   Address: $GOVERNANCE_ADDR" && echo "   Extrinsic: $GOVERNANCE_EXT" && [ ! -z "$GOVERNANCE_EXT" ] && echo "   Subscan: $SUBSCAN_BASE/extrinsic/$GOVERNANCE_EXT" && echo "   Polkaholic: $POLKAHOLIC_BASE/tx/$GOVERNANCE_EXT" && echo "   Contract file: contracts/target/ink/governance/governance.contract" && echo ""

echo -e "${BLUE}Steps to verify:${NC}"
echo "   1. Open $SUBSCAN_BASE or $POLKAHOLIC_BASE"
echo "   2. Search for contract address or extrinsic hash"
echo "   3. Click 'Verify & Publish' on contract page"
echo "   4. Upload the .contract file from target/ink/CONTRACT_NAME/"
echo "   5. Select Runtime: ink! 5.0 (or latest)"
echo "   6. Click Verify"
echo ""
echo -e "${BLUE}🌐 View contracts on Polkadot.js Apps:${NC}"
RPC_ENCODED=$(echo "$RPC_URL" | sed 's|://|%3A%2F%2F|g' | sed 's|/|%2F|g')
echo "   https://polkadot.js.org/apps/?rpc=$RPC_ENCODED#/contracts"
echo ""

