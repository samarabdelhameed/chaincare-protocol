#!/bin/bash

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

# Array to store addresses and extrinsic hashes
declare -A ADDRESSES
declare -A EXTRINSICS

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
  CONTRACT_ADDR=$(echo "$OUTPUT" | grep -oP 'Contract\s+\K[^\s]+' | head -1 || echo "")
  EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oP 'Extrinsic hash:\s+\K[^\s]+' | head -1 || echo "")
  
  if [ -z "$CONTRACT_ADDR" ]; then
    echo -e "${RED}❌ Failed to deploy $CONTRACT_NAME${NC}"
    echo "$OUTPUT"
    cd - > /dev/null
    exit 1
  fi
  
  ADDRESSES[$CONTRACT_NAME]="$CONTRACT_ADDR"
  EXTRINSICS[$CONTRACT_NAME]="$EXTRINSIC_HASH"
  
  echo -e "${GREEN}✅ Deployed successfully!${NC}"
  echo -e "${GREEN}   📍 Contract: $CONTRACT_ADDR${NC}"
  echo -e "${GREEN}   🔗 Extrinsic: $EXTRINSIC_HASH${NC}"
  echo ""
  echo -e "${BLUE}🔍 Verify on Subscan:${NC}"
  echo -e "${BLUE}   https://polkadot.subscan.io/extrinsic/$EXTRINSIC_HASH${NC}"
  echo ""
  
  cd - > /dev/null
}

# 1. Deploy health_sbt
deploy_contract "health_sbt" "health_sbt" "new" "$HEALTH_SBT_ADMIN"

# 2. Deploy care_treasury
deploy_contract "care_treasury" "care_treasury" "new" "$TREASURY_ADMIN" "$TREASURY_DAILY_RATE"

# 3. Deploy care_space (needs health_sbt and treasury addresses)
deploy_contract "care_space" "care_space" "new" \
  "$CARE_SPACE_OWNER" \
  "$CARE_SPACE_NAME" \
  "$CARE_SPACE_PATIENT" \
  "${ADDRESSES[care_treasury]}" \
  "${ADDRESSES[health_sbt]}"

# 4. Deploy med_reminder
deploy_contract "med_reminder" "plugins/med_reminder" "new" "$MED_REMINDER_MED_ID"

# 5. Deploy step_counter
deploy_contract "step_counter" "plugins/step_counter" "new" "$STEP_COUNTER_ADMIN" "$STEP_COUNTER_DAILY_TARGET"

# 6. Deploy zk_camera
deploy_contract "zk_camera" "plugins/zk_camera" "new" "$ZK_CAMERA_ADMIN"

# 7. Deploy governance
deploy_contract "governance" "plugins/governance" "new" "$GOVERNANCE_ADMIN"

# Save addresses to JSON file
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}💾 Saving addresses to JSON file...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

ADDRESSES_FILE="../frontend/src/addresses.polkadot-testnet.json"
cat > "$ADDRESSES_FILE" << EOF
{
  "careSpace": "${ADDRESSES[care_space]}",
  "healthSbt": "${ADDRESSES[health_sbt]}",
  "treasury": "${ADDRESSES[care_treasury]}",
  "medReminder": "${ADDRESSES[med_reminder]}",
  "stepCounter": "${ADDRESSES[step_counter]}",
  "zkCamera": "${ADDRESSES[zk_camera]}",
  "governance": "${ADDRESSES[governance]}"
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
echo -e "   health_sbt:    ${ADDRESSES[health_sbt]}"
echo -e "   care_treasury: ${ADDRESSES[care_treasury]}"
echo -e "   care_space:    ${ADDRESSES[care_space]}"
echo -e "   med_reminder:  ${ADDRESSES[med_reminder]}"
echo -e "   step_counter:  ${ADDRESSES[step_counter]}"
echo -e "   zk_camera:     ${ADDRESSES[zk_camera]}"
echo -e "   governance:    ${ADDRESSES[governance]}"
echo ""

# Create verification instructions file
VERIFY_FILE="VERIFICATION_INSTRUCTIONS.md"
cat > "$VERIFY_FILE" << EOF
# 🔍 Contract Verification Instructions

## Deployed Contracts

| Contract | Address | Extrinsic Hash |
|----------|---------|----------------|
| health_sbt | ${ADDRESSES[health_sbt]} | ${EXTRINSICS[health_sbt]} |
| care_treasury | ${ADDRESSES[care_treasury]} | ${EXTRINSICS[care_treasury]} |
| care_space | ${ADDRESSES[care_space]} | ${EXTRINSICS[care_space]} |
| med_reminder | ${ADDRESSES[med_reminder]} | ${EXTRINSICS[med_reminder]} |
| step_counter | ${ADDRESSES[step_counter]} | ${EXTRINSICS[step_counter]} |
| zk_camera | ${ADDRESSES[zk_camera]} | ${EXTRINSICS[zk_camera]} |
| governance | ${ADDRESSES[governance]} | ${EXTRINSICS[governance]} |

## Verification Steps for Each Contract

### 1. health_sbt
- **Subscan Link**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[health_sbt]}
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
- **Subscan Link**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[care_treasury]}
- **Contract File**: \`target/ink/care_treasury/care_treasury.contract\`

### 3. care_space
- **Subscan Link**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[care_space]}
- **Contract File**: \`target/ink/care_space/care_space.contract\`

### 4. med_reminder
- **Subscan Link**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[med_reminder]}
- **Contract File**: \`target/ink/med_reminder/med_reminder.contract\`

### 5. step_counter
- **Subscan Link**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[step_counter]}
- **Contract File**: \`target/ink/step_counter/step_counter.contract\`

### 6. zk_camera
- **Subscan Link**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[zk_camera]}
- **Contract File**: \`target/ink/zk_camera/zk_camera.contract\`

### 7. governance
- **Subscan Link**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[governance]}
- **Contract File**: \`target/ink/governance/governance.contract\`

## Quick Verification Commands

For each contract, you can use the following command to get the verification link:

\`\`\`bash
# Example for health_sbt
echo "https://polkadot.subscan.io/extrinsic/${EXTRINSICS[health_sbt]}"
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
