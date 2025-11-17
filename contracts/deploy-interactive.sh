#!/bin/bash

# Interactive deployment script that prompts for MNEMONIC securely

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     🚀 ChainCARE Interactive Deployment Script            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Load .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | grep -v '^$' | xargs)
else
  echo -e "${RED}❌ Error: .env file not found!${NC}"
  exit 1
fi

# Check if MNEMONIC is already set and valid
if [ -n "$MNEMONIC" ] && [ "$MNEMONIC" != "your twelve word mnemonic phrase here" ]; then
  echo -e "${GREEN}✅ MNEMONIC found in .env file${NC}"
  echo -e "${YELLOW}Using address: $ADDRESS${NC}"
  echo ""
  read -p "Continue with this MNEMONIC? (y/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Deployment cancelled.${NC}"
    exit 0
  fi
else
  echo -e "${YELLOW}⚠️  MNEMONIC not found in .env file${NC}"
  echo -e "${BLUE}Please enter your 12-word mnemonic phrase:${NC}"
  echo -e "${RED}(This will be used for deployment only, not saved)${NC}"
  echo ""
  read -p "Mnemonic: " MNEMONIC
  echo ""
  
  if [ -z "$MNEMONIC" ]; then
    echo -e "${RED}❌ Error: MNEMONIC cannot be empty!${NC}"
    exit 1
  fi
  
  # Count words
  WORD_COUNT=$(echo "$MNEMONIC" | wc -w | tr -d ' ')
  if [ "$WORD_COUNT" -ne 12 ]; then
    echo -e "${RED}❌ Error: MNEMONIC must be exactly 12 words (got $WORD_COUNT)${NC}"
    exit 1
  fi
  
  export MNEMONIC
fi

echo -e "${BLUE}📝 Network: $NETWORK${NC}"
echo -e "${BLUE}🌐 RPC: $RPC_URL${NC}"
echo -e "${BLUE}👤 Address: $ADDRESS${NC}"
echo ""
echo -e "${YELLOW}⚠️  This will deploy 7 contracts to Polkadot Testnet${NC}"
echo -e "${YELLOW}⚠️  Make sure you have at least 0.1 DOT in your account${NC}"
echo ""
read -p "Ready to deploy? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${YELLOW}Deployment cancelled.${NC}"
  exit 0
fi

echo ""
echo -e "${GREEN}🚀 Starting deployment...${NC}"
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
  
  echo -e "${BLUE}⏳ Deploying...${NC}"
  
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
  
  cd - > /dev/null
}

# 1. Deploy health_sbt
deploy_contract "health_sbt" "health_sbt" "new" "$HEALTH_SBT_ADMIN"

# 2. Deploy care_treasury
deploy_contract "care_treasury" "care_treasury" "new" "$TREASURY_ADMIN" "$TREASURY_DAILY_RATE"

# 3. Deploy care_space
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
echo -e "${YELLOW}💾 Saving addresses...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if frontend directory exists
if [ -d "../frontend/src" ]; then
  ADDRESSES_FILE="../frontend/src/addresses.polkadot-testnet.json"
else
  ADDRESSES_FILE="addresses.polkadot-testnet.json"
fi

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

# Create verification instructions
VERIFY_FILE="VERIFICATION_INSTRUCTIONS.md"
cat > "$VERIFY_FILE" << EOF
# 🔍 Contract Verification Instructions

Generated: $(date)

## Deployed Contracts

| Contract | Address | Extrinsic Hash |
|----------|---------|----------------|
| health_sbt | \`${ADDRESSES[health_sbt]}\` | \`${EXTRINSICS[health_sbt]}\` |
| care_treasury | \`${ADDRESSES[care_treasury]}\` | \`${EXTRINSICS[care_treasury]}\` |
| care_space | \`${ADDRESSES[care_space]}\` | \`${EXTRINSICS[care_space]}\` |
| med_reminder | \`${ADDRESSES[med_reminder]}\` | \`${EXTRINSICS[med_reminder]}\` |
| step_counter | \`${ADDRESSES[step_counter]}\` | \`${EXTRINSICS[step_counter]}\` |
| zk_camera | \`${ADDRESSES[zk_camera]}\` | \`${EXTRINSICS[zk_camera]}\` |
| governance | \`${ADDRESSES[governance]}\` | \`${EXTRINSICS[governance]}\` |

## Verification Steps

For each contract, follow these steps:

1. Open the Subscan link for the extrinsic
2. Find the \`contracts.Instantiated\` event
3. Copy the contract address
4. Go to the contract page
5. Click "Verify & Publish"
6. Upload the corresponding \`.contract\` file from \`target/ink/CONTRACT_NAME/\`
7. Select Runtime: **ink! 5.0**
8. Click Verify

## Subscan Links

### 1. health_sbt
- **Extrinsic**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[health_sbt]}
- **Contract File**: \`target/ink/health_sbt/health_sbt.contract\`

### 2. care_treasury
- **Extrinsic**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[care_treasury]}
- **Contract File**: \`target/ink/care_treasury/care_treasury.contract\`

### 3. care_space
- **Extrinsic**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[care_space]}
- **Contract File**: \`target/ink/care_space/care_space.contract\`

### 4. med_reminder
- **Extrinsic**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[med_reminder]}
- **Contract File**: \`target/ink/med_reminder/med_reminder.contract\`

### 5. step_counter
- **Extrinsic**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[step_counter]}
- **Contract File**: \`target/ink/step_counter/step_counter.contract\`

### 6. zk_camera
- **Extrinsic**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[zk_camera]}
- **Contract File**: \`target/ink/zk_camera/zk_camera.contract\`

### 7. governance
- **Extrinsic**: https://polkadot.subscan.io/extrinsic/${EXTRINSICS[governance]}
- **Contract File**: \`target/ink/governance/governance.contract\`

## Next Steps

1. ✅ Verify all contracts on Subscan
2. ✅ Test contract functions
3. ✅ Update frontend configuration
EOF

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ DEPLOYMENT COMPLETED!                      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 Contract Addresses:${NC}"
echo ""
echo -e "   ${YELLOW}health_sbt:${NC}    ${ADDRESSES[health_sbt]}"
echo -e "   ${YELLOW}care_treasury:${NC} ${ADDRESSES[care_treasury]}"
echo -e "   ${YELLOW}care_space:${NC}    ${ADDRESSES[care_space]}"
echo -e "   ${YELLOW}med_reminder:${NC}  ${ADDRESSES[med_reminder]}"
echo -e "   ${YELLOW}step_counter:${NC}  ${ADDRESSES[step_counter]}"
echo -e "   ${YELLOW}zk_camera:${NC}     ${ADDRESSES[zk_camera]}"
echo -e "   ${YELLOW}governance:${NC}    ${ADDRESSES[governance]}"
echo ""
echo -e "${BLUE}📄 Verification instructions: $VERIFY_FILE${NC}"
echo ""
echo -e "${YELLOW}⚠️  NEXT STEPS:${NC}"
echo -e "   1. Open $VERIFY_FILE for verification links"
echo -e "   2. Verify each contract on Subscan"
echo -e "   3. Test contracts using ./test-contracts.sh"
echo ""
echo -e "${GREEN}🎉 Happy deploying! 🚀${NC}"
