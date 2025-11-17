#!/bin/bash

# Complete deployment script for all ChainCARE contracts
# This script will deploy, verify instructions, and test all contracts

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Load .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
else
  echo -e "${RED}❌ Error: .env file not found!${NC}"
  exit 1
fi

# Check if MNEMONIC is set (from .env or environment)
if [ -z "$MNEMONIC" ]; then
  # Try to read from environment variable
  if [ -n "${MNEMONIC_ENV}" ]; then
    MNEMONIC="${MNEMONIC_ENV}"
  else
    echo -e "${RED}❌ Error: MNEMONIC not set!${NC}"
    echo -e "${YELLOW}Please set MNEMONIC as:${NC}"
    echo -e "${YELLOW}  export MNEMONIC='your phrase'${NC}"
    echo -e "${YELLOW}  Or add to .env: MNEMONIC=your phrase${NC}"
    exit 1
  fi
fi

echo -e "${GREEN}🚀 Starting ChainCARE contracts deployment to $NETWORK...${NC}"
echo -e "${GREEN}📝 Address: $ADDRESS${NC}"
echo -e "${GREEN}🌐 RPC: $RPC_URL${NC}"
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
echo -e "${GREEN}🔍 Subscan Explorer: $SUBSCAN_BASE${NC}"
echo ""

# Array to store addresses
declare -A ADDRESSES

# 1. Deploy health_sbt
echo -e "${YELLOW}1️⃣ Deploying health_sbt...${NC}"
cd health_sbt
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$HEALTH_SBT_ADMIN" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1)

HEALTH_SBT=$(echo "$OUTPUT" | grep -oP 'Contract\s+\K[^\s]+' || echo "")
EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oP 'Extrinsic hash:\s+\K[^\s]+' || echo "")

if [ -z "$HEALTH_SBT" ]; then
  echo -e "${RED}❌ Failed to deploy health_sbt${NC}"
  echo "$OUTPUT"
  exit 1
fi

ADDRESSES[health_sbt]="$HEALTH_SBT"
echo -e "${GREEN}✅ health_sbt deployed: $HEALTH_SBT${NC}"
echo -e "${GREEN}   Extrinsic: $EXTRINSIC_HASH${NC}"
echo -e "${YELLOW}   Verify at: $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH${NC}"
cd ..

# 2. Deploy care_treasury
echo ""
echo -e "${YELLOW}2️⃣ Deploying care_treasury...${NC}"
cd care_treasury
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$TREASURY_ADMIN" "$TREASURY_DAILY_RATE" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1)

TREASURY=$(echo "$OUTPUT" | grep -oP 'Contract\s+\K[^\s]+' || echo "")
EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oP 'Extrinsic hash:\s+\K[^\s]+' || echo "")

if [ -z "$TREASURY" ]; then
  echo -e "${RED}❌ Failed to deploy care_treasury${NC}"
  echo "$OUTPUT"
  exit 1
fi

ADDRESSES[treasury]="$TREASURY"
echo -e "${GREEN}✅ care_treasury deployed: $TREASURY${NC}"
echo -e "${GREEN}   Extrinsic: $EXTRINSIC_HASH${NC}"
echo -e "${YELLOW}   Verify at: $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH${NC}"
cd ..

# 3. Deploy care_space
echo ""
echo -e "${YELLOW}3️⃣ Deploying care_space...${NC}"
cd care_space
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$CARE_SPACE_OWNER" "$CARE_SPACE_NAME" "$CARE_SPACE_PATIENT" "${ADDRESSES[treasury]}" "${ADDRESSES[health_sbt]}" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1)

CARE_SPACE=$(echo "$OUTPUT" | grep -oP 'Contract\s+\K[^\s]+' || echo "")
EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oP 'Extrinsic hash:\s+\K[^\s]+' || echo "")

if [ -z "$CARE_SPACE" ]; then
  echo -e "${RED}❌ Failed to deploy care_space${NC}"
  echo "$OUTPUT"
  exit 1
fi

ADDRESSES[care_space]="$CARE_SPACE"
echo -e "${GREEN}✅ care_space deployed: $CARE_SPACE${NC}"
echo -e "${GREEN}   Extrinsic: $EXTRINSIC_HASH${NC}"
echo -e "${YELLOW}   Verify at: $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH${NC}"
cd ..

# 4. Deploy med_reminder
echo ""
echo -e "${YELLOW}4️⃣ Deploying med_reminder...${NC}"
cd plugins/med_reminder
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$MED_REMINDER_MED_ID" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1)

MED_REMINDER=$(echo "$OUTPUT" | grep -oP 'Contract\s+\K[^\s]+' || echo "")
EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oP 'Extrinsic hash:\s+\K[^\s]+' || echo "")

if [ -z "$MED_REMINDER" ]; then
  echo -e "${RED}❌ Failed to deploy med_reminder${NC}"
  echo "$OUTPUT"
  exit 1
fi

ADDRESSES[med_reminder]="$MED_REMINDER"
echo -e "${GREEN}✅ med_reminder deployed: $MED_REMINDER${NC}"
echo -e "${GREEN}   Extrinsic: $EXTRINSIC_HASH${NC}"
echo -e "${YELLOW}   Verify at: $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH${NC}"
cd ../..

# 5. Deploy step_counter
echo ""
echo -e "${YELLOW}5️⃣ Deploying step_counter...${NC}"
cd plugins/step_counter
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$STEP_COUNTER_ADMIN" "$STEP_COUNTER_DAILY_TARGET" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1)

STEP_COUNTER=$(echo "$OUTPUT" | grep -oP 'Contract\s+\K[^\s]+' || echo "")
EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oP 'Extrinsic hash:\s+\K[^\s]+' || echo "")

if [ -z "$STEP_COUNTER" ]; then
  echo -e "${RED}❌ Failed to deploy step_counter${NC}"
  echo "$OUTPUT"
  exit 1
fi

ADDRESSES[step_counter]="$STEP_COUNTER"
echo -e "${GREEN}✅ step_counter deployed: $STEP_COUNTER${NC}"
echo -e "${GREEN}   Extrinsic: $EXTRINSIC_HASH${NC}"
echo -e "${YELLOW}   Verify at: $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH${NC}"
cd ../..

# 6. Deploy zk_camera
echo ""
echo -e "${YELLOW}6️⃣ Deploying zk_camera...${NC}"
cd plugins/zk_camera
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$ZK_CAMERA_ADMIN" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1)

ZK_CAMERA=$(echo "$OUTPUT" | grep -oP 'Contract\s+\K[^\s]+' || echo "")
EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oP 'Extrinsic hash:\s+\K[^\s]+' || echo "")

if [ -z "$ZK_CAMERA" ]; then
  echo -e "${RED}❌ Failed to deploy zk_camera${NC}"
  echo "$OUTPUT"
  exit 1
fi

ADDRESSES[zk_camera]="$ZK_CAMERA"
echo -e "${GREEN}✅ zk_camera deployed: $ZK_CAMERA${NC}"
echo -e "${GREEN}   Extrinsic: $EXTRINSIC_HASH${NC}"
echo -e "${YELLOW}   Verify at: $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH${NC}"
cd ../..

# 7. Deploy governance
echo ""
echo -e "${YELLOW}7️⃣ Deploying governance...${NC}"
cd plugins/governance
OUTPUT=$(cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$GOVERNANCE_ADMIN" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1)

GOVERNANCE=$(echo "$OUTPUT" | grep -oP 'Contract\s+\K[^\s]+' || echo "")
EXTRINSIC_HASH=$(echo "$OUTPUT" | grep -oP 'Extrinsic hash:\s+\K[^\s]+' || echo "")

if [ -z "$GOVERNANCE" ]; then
  echo -e "${RED}❌ Failed to deploy governance${NC}"
  echo "$OUTPUT"
  exit 1
fi

ADDRESSES[governance]="$GOVERNANCE"
echo -e "${GREEN}✅ governance deployed: $GOVERNANCE${NC}"
echo -e "${GREEN}   Extrinsic: $EXTRINSIC_HASH${NC}"
echo -e "${YELLOW}   Verify at: $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH${NC}"
cd ../..

# Save addresses to JSON file
echo ""
echo -e "${YELLOW}📝 Saving addresses to addresses.polkadot-testnet.json...${NC}"
ADDRESSES_FILE="../frontend/src/addresses.polkadot-testnet.json"
cat > "$ADDRESSES_FILE" << EOF
{
  "careSpace": "${ADDRESSES[care_space]}",
  "healthSbt": "${ADDRESSES[health_sbt]}",
  "treasury": "${ADDRESSES[treasury]}",
  "medReminder": "${ADDRESSES[med_reminder]}",
  "stepCounter": "${ADDRESSES[step_counter]}",
  "zkCamera": "${ADDRESSES[zk_camera]}",
  "governance": "${ADDRESSES[governance]}"
}
EOF

echo -e "${GREEN}✅ All contracts deployed successfully!${NC}"
echo ""
echo -e "${GREEN}📋 Contract Addresses:${NC}"
echo "  careSpace:    ${ADDRESSES[care_space]}"
echo "  healthSbt:    ${ADDRESSES[health_sbt]}"
echo "  treasury:     ${ADDRESSES[treasury]}"
echo "  medReminder:  ${ADDRESSES[med_reminder]}"
echo "  stepCounter:  ${ADDRESSES[step_counter]}"
echo "  zkCamera:     ${ADDRESSES[zk_camera]}"
echo "  governance:   ${ADDRESSES[governance]}"
echo ""
echo -e "${YELLOW}⚠️  Next steps:${NC}"
echo "1. Verify each contract on Subscan (links above)"
echo "2. Run ./test-contracts.sh to test all functions"
echo "3. Update frontend to use these addresses"

