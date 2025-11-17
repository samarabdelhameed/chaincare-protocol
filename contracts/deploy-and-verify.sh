#!/usr/bin/env bash

# Complete deployment and verification script for ChainCARE contracts
# This script will deploy all contracts and provide verification instructions

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | grep -v '^$' | xargs)
else
  echo -e "${RED}❌ Error: .env file not found!${NC}"
  exit 1
fi

# Check if MNEMONIC is set and not default
if [ -z "$MNEMONIC" ] || [ "$MNEMONIC" = "your twelve word mnemonic phrase here" ]; then
  echo -e "${RED}❌ Error: MNEMONIC not set in .env file!${NC}"
  echo -e "${YELLOW}Please add your real MNEMONIC to .env file${NC}"
  echo -e "${YELLOW}Example: MNEMONIC=\"word1 word2 word3 ... word12\"${NC}"
  exit 1
fi

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     🚀 ChainCARE Contracts Deployment & Verification      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📝 Network: $NETWORK${NC}"
echo -e "${BLUE}🌐 RPC: $RPC_URL${NC}"
echo -e "${BLUE}👤 Address: $ADDRESS${NC}"
echo ""

# Function to get Subscan URL based on network
get_subscan_url() {
  local rpc_url="$RPC_URL"
  local network="$NETWORK"
  
  # Detect network from RPC URL if NETWORK not set
  if [ -z "$network" ]; then
    if echo "$rpc_url" | grep -qi "paseo"; then
      network="paseo"
    elif echo "$rpc_url" | grep -qi "shibuya"; then
      network="shibuya"
    elif echo "$rpc_url" | grep -qi "polkadot"; then
      network="polkadot"
    elif echo "$rpc_url" | grep -qi "westend"; then
      network="westend"
    else
      network="polkadot"  # default
    fi
  fi
  
  # Return appropriate Subscan URL
  case "$network" in
    paseo)
      echo "https://paseo.subscan.io"
      ;;
    shibuya)
      echo "https://shibuya.subscan.io"
      ;;
    polkadot|polkadot-testnet)
      echo "https://polkadot.subscan.io"
      ;;
    westend)
      echo "https://westend.subscan.io"
      ;;
    *)
      echo "https://polkadot.subscan.io"  # default
      ;;
  esac
}

SUBSCAN_BASE=$(get_subscan_url)
echo -e "${BLUE}🔍 Subscan Explorer: $SUBSCAN_BASE${NC}"
echo ""

# Variables to store addresses and extrinsic hashes
HEALTH_SBT_ADDR=""
HEALTH_SBT_HASH=""
TREASURY_ADDR=""
TREASURY_HASH=""
CARE_SPACE_ADDR=""
CARE_SPACE_HASH=""
MED_REMINDER_ADDR=""
MED_REMINDER_HASH=""
STEP_COUNTER_ADDR=""
STEP_COUNTER_HASH=""
ZK_CAMERA_ADDR=""
ZK_CAMERA_HASH=""
GOVERNANCE_ADDR=""
GOVERNANCE_HASH=""

# Function to deploy a contract
deploy_contract() {
  local CONTRACT_NAME=$1
  local CONTRACT_DIR=$2
  local CONSTRUCTOR=$3
  shift 3
  local ARGS=("$@")
  
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${YELLOW}📦 Deploying: $CONTRACT_NAME${NC}"
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  cd "$CONTRACT_DIR"
  
  # Build the command
  CMD="cargo contract instantiate --url \"$RPC_URL\" --suri \"$MNEMONIC\" --constructor $CONSTRUCTOR --gas \"$GAS_LIMIT\" --skip-confirm"
  
  # Add arguments if provided
  if [ ${#ARGS[@]} -gt 0 ]; then
    CMD="$CMD --args"
    for arg in "${ARGS[@]}"; do
      CMD="$CMD \"$arg\""
    done
  fi
  
  echo -e "${BLUE}Running: cargo contract instantiate...${NC}"
  
  # Execute deployment
  OUTPUT=$(eval $CMD 2>&1)
  
  # Extract contract address and extrinsic hash
  CONTRACT_ADDR=$(echo "$OUTPUT" | grep -oE 'Contract [^ ]+' | head -1 | awk '{print $2}' || echo "")
  EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oE 'Extrinsic hash: [^ ]+' | head -1 | awk '{print $3}' || echo "")
  
  if [ -z "$CONTRACT_ADDR" ]; then
    echo -e "${RED}❌ Failed to deploy $CONTRACT_NAME${NC}"
    echo "$OUTPUT"
    cd - > /dev/null
    exit 1
  fi
  
  echo -e "${GREEN}✅ Deployed successfully!${NC}"
  echo -e "${GREEN}   📍 Contract: $CONTRACT_ADDR${NC}"
  echo -e "${GREEN}   🔗 Extrinsic: $EXTRINSIC_HASH${NC}"
  echo ""
  echo -e "${BLUE}🔍 Verify on Subscan:${NC}"
  echo -e "${BLUE}   $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH${NC}"
  echo ""
  
  cd - > /dev/null
  
  # Return values via echo
  echo "$CONTRACT_ADDR|$EXTRINSIC_HASH"
}

# 1. Deploy health_sbt
echo -e "${BLUE}🏥 Deploying health_sbt...${NC}"
RESULT=$(deploy_contract "health_sbt" "health_sbt" "new" "$HEALTH_SBT_ADMIN")
HEALTH_SBT_ADDR=$(echo "$RESULT" | tail -1 | cut -d'|' -f1)
HEALTH_SBT_HASH=$(echo "$RESULT" | tail -1 | cut -d'|' -f2)

# 2. Deploy care_treasury
echo -e "${BLUE}💰 Deploying care_treasury...${NC}"
RESULT=$(deploy_contract "care_treasury" "care_treasury" "new" "$TREASURY_ADMIN" "$TREASURY_DAILY_RATE")
TREASURY_ADDR=$(echo "$RESULT" | tail -1 | cut -d'|' -f1)
TREASURY_HASH=$(echo "$RESULT" | tail -1 | cut -d'|' -f2)

# 3. Deploy care_space (needs health_sbt and treasury addresses)
echo -e "${BLUE}🏠 Deploying care_space...${NC}"
RESULT=$(deploy_contract "care_space" "care_space" "new" \
  "$CARE_SPACE_OWNER" \
  "$CARE_SPACE_NAME" \
  "$CARE_SPACE_PATIENT" \
  "$TREASURY_ADDR" \
  "$HEALTH_SBT_ADDR")
CARE_SPACE_ADDR=$(echo "$RESULT" | tail -1 | cut -d'|' -f1)
CARE_SPACE_HASH=$(echo "$RESULT" | tail -1 | cut -d'|' -f2)

# 4. Deploy med_reminder
echo -e "${BLUE}💊 Deploying med_reminder...${NC}"
RESULT=$(deploy_contract "med_reminder" "plugins/med_reminder" "new" "$MED_REMINDER_MED_ID")
MED_REMINDER_ADDR=$(echo "$RESULT" | tail -1 | cut -d'|' -f1)
MED_REMINDER_HASH=$(echo "$RESULT" | tail -1 | cut -d'|' -f2)

# 5. Deploy step_counter
echo -e "${BLUE}👟 Deploying step_counter...${NC}"
RESULT=$(deploy_contract "step_counter" "plugins/step_counter" "new" "$STEP_COUNTER_ADMIN" "$STEP_COUNTER_DAILY_TARGET")
STEP_COUNTER_ADDR=$(echo "$RESULT" | tail -1 | cut -d'|' -f1)
STEP_COUNTER_HASH=$(echo "$RESULT" | tail -1 | cut -d'|' -f2)

# 6. Deploy zk_camera
echo -e "${BLUE}📷 Deploying zk_camera...${NC}"
RESULT=$(deploy_contract "zk_camera" "plugins/zk_camera" "new" "$ZK_CAMERA_ADMIN")
ZK_CAMERA_ADDR=$(echo "$RESULT" | tail -1 | cut -d'|' -f1)
ZK_CAMERA_HASH=$(echo "$RESULT" | tail -1 | cut -d'|' -f2)

# 7. Deploy governance
echo -e "${BLUE}🏛️ Deploying governance...${NC}"
RESULT=$(deploy_contract "governance" "plugins/governance" "new" "$GOVERNANCE_ADMIN")
GOVERNANCE_ADDR=$(echo "$RESULT" | tail -1 | cut -d'|' -f1)
GOVERNANCE_HASH=$(echo "$RESULT" | tail -1 | cut -d'|' -f2)

# Save addresses to JSON file
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}💾 Saving addresses to JSON file...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

ADDRESSES_FILE="../frontend/src/addresses.polkadot-testnet.json"
cat > "$ADDRESSES_FILE" << EOF
{
  "careSpace": "$CARE_SPACE_ADDR",
  "healthSbt": "$HEALTH_SBT_ADDR",
  "treasury": "$TREASURY_ADDR",
  "medReminder": "$MED_REMINDER_ADDR",
  "stepCounter": "$STEP_COUNTER_ADDR",
  "zkCamera": "$ZK_CAMERA_ADDR",
  "governance": "$GOVERNANCE_ADDR"
}
EOF

echo -e "${GREEN}✅ Addresses saved to: $ADDRESSES_FILE${NC}"
echo ""

# Print summary
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ DEPLOYMENT COMPLETED SUCCESSFULLY          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 Contract Addresses:${NC}"
echo -e "   health_sbt:    $HEALTH_SBT_ADDR"
echo -e "   care_treasury: $TREASURY_ADDR"
echo -e "   care_space:    $CARE_SPACE_ADDR"
echo -e "   med_reminder:  $MED_REMINDER_ADDR"
echo -e "   step_counter:  $STEP_COUNTER_ADDR"
echo -e "   zk_camera:     $ZK_CAMERA_ADDR"
echo -e "   governance:    $GOVERNANCE_ADDR"
echo ""

# Create verification instructions file
VERIFY_FILE="VERIFICATION_INSTRUCTIONS.md"
cat > "$VERIFY_FILE" << EOF
# 🔍 Contract Verification Instructions

## Deployed Contracts

| Contract | Address | Extrinsic Hash |
|----------|---------|----------------|
| health_sbt | $HEALTH_SBT_ADDR | $HEALTH_SBT_HASH |
| care_treasury | $TREASURY_ADDR | $TREASURY_HASH |
| care_space | $CARE_SPACE_ADDR | $CARE_SPACE_HASH |
| med_reminder | $MED_REMINDER_ADDR | $MED_REMINDER_HASH |
| step_counter | $STEP_COUNTER_ADDR | $STEP_COUNTER_HASH |
| zk_camera | $ZK_CAMERA_ADDR | $ZK_CAMERA_HASH |
| governance | $GOVERNANCE_ADDR | $GOVERNANCE_HASH |

## Verification Steps for Each Contract

### 1. health_sbt
- **Subscan Link**: $SUBSCAN_BASE/extrinsic/$HEALTH_SBT_HASH
- **Contract File**: \`target/ink/health_sbt/health_sbt.contract\`
- **Steps**:
  1. Open the Subscan link above
  2. Find the \`contracts.Instantiated\` event
  3. Copy the contract address
  4. Go to the contract page and click "Verify & Publish"
  5. Upload: \`target/ink/health_sbt/health_sbt.contract\`
  6. Runtime: ink! 5.0
  7. Click Verify

### 2. care_treasury
- **Subscan Link**: $SUBSCAN_BASE/extrinsic/$TREASURY_HASH
- **Contract File**: \`target/ink/care_treasury/care_treasury.contract\`

### 3. care_space
- **Subscan Link**: $SUBSCAN_BASE/extrinsic/$CARE_SPACE_HASH
- **Contract File**: \`target/ink/care_space/care_space.contract\`

### 4. med_reminder
- **Subscan Link**: $SUBSCAN_BASE/extrinsic/$MED_REMINDER_HASH
- **Contract File**: \`target/ink/med_reminder/med_reminder.contract\`

### 5. step_counter
- **Subscan Link**: $SUBSCAN_BASE/extrinsic/$STEP_COUNTER_HASH
- **Contract File**: \`target/ink/step_counter/step_counter.contract\`

### 6. zk_camera
- **Subscan Link**: $SUBSCAN_BASE/extrinsic/$ZK_CAMERA_HASH
- **Contract File**: \`target/ink/zk_camera/zk_camera.contract\`

### 7. governance
- **Subscan Link**: $SUBSCAN_BASE/extrinsic/$GOVERNANCE_HASH
- **Contract File**: \`target/ink/governance/governance.contract\`

## Quick Verification Commands

For each contract, you can use the following command to get the verification link:

\`\`\`bash
# Example for health_sbt
echo "$SUBSCAN_BASE/extrinsic/$HEALTH_SBT_HASH"
\`\`\`

## Next Steps

1. ✅ Verify each contract on Subscan using the links above
2. ✅ Test contract functions using \`./test-contracts.sh\`
3. ✅ Update frontend to use the deployed addresses
EOF

echo -e "${BLUE}📄 Verification instructions saved to: $VERIFY_FILE${NC}"
echo ""
echo -e "${YELLOW}⚠️  NEXT STEPS:${NC}"
echo -e "   1. Verify each contract on Subscan (see $VERIFY_FILE)"
echo -e "   2. Run ./test-contracts.sh to test all functions"
echo -e "   3. Frontend addresses are already updated in $ADDRESSES_FILE"
echo ""
echo -e "${GREEN}🎉 All done! Happy deploying! 🚀${NC}"
