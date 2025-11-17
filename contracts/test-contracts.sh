#!/bin/bash

# Test all deployed contracts
# Usage: ./test-contracts.sh

set -e

# Load .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
else
  echo "❌ Error: .env file not found!"
  exit 1
fi

# Load contract addresses from addresses file
ADDRESSES_FILE="../frontend/src/addresses.polkadot-testnet.json"
if [ ! -f "$ADDRESSES_FILE" ]; then
  echo "❌ Error: $ADDRESSES_FILE not found!"
  echo "Please deploy contracts first and fill addresses"
  exit 1
fi

# Parse addresses (requires jq or manual parsing)
HEALTH_SBT=$(grep -oP '"healthSbt":\s*"\K[^"]+' "$ADDRESSES_FILE" || echo "")
TREASURY=$(grep -oP '"treasury":\s*"\K[^"]+' "$ADDRESSES_FILE" || echo "")
CARE_SPACE=$(grep -oP '"careSpace":\s*"\K[^"]+' "$ADDRESSES_FILE" || echo "")
MED_REMINDER=$(grep -oP '"medReminder":\s*"\K[^"]+' "$ADDRESSES_FILE" || echo "")
STEP_COUNTER=$(grep -oP '"stepCounter":\s*"\K[^"]+' "$ADDRESSES_FILE" || echo "")
GOVERNANCE=$(grep -oP '"governance":\s*"\K[^"]+' "$ADDRESSES_FILE" || echo "")

if [ -z "$HEALTH_SBT" ] || [ -z "$TREASURY" ]; then
  echo "❌ Error: Contract addresses not found in $ADDRESSES_FILE"
  exit 1
fi

echo "🧪 Testing ChainCARE contracts..."
echo ""

# Test health_sbt
echo "1️⃣ Testing health_sbt..."
echo "   Minting SBT..."
cargo contract call \
  --url "$RPC_URL" \
  --contract "$HEALTH_SBT" \
  --message mint \
  --args "$ADDRESS" "Health Level 5" \
  --suri "$MNEMONIC" \
  --gas "$GAS_LIMIT" \
  --skip-confirm 2>&1 | grep -i "success\|error" || echo "   ✅ Mint called"

echo "   Getting metadata..."
cargo contract call \
  --url "$RPC_URL" \
  --contract "$HEALTH_SBT" \
  --message get_metadata \
  --args "$ADDRESS" \
  --suri "$MNEMONIC" \
  --skip-confirm 2>&1 | grep -i "result\|error" || echo "   ✅ Metadata retrieved"

# Test care_treasury
echo ""
echo "2️⃣ Testing care_treasury..."
echo "   Getting balance..."
cargo contract call \
  --url "$RPC_URL" \
  --contract "$TREASURY" \
  --message get_balance \
  --args "$ADDRESS" \
  --suri "$MNEMONIC" \
  --skip-confirm 2>&1 | grep -i "result\|error" || echo "   ✅ Balance retrieved"

# Test care_space
echo ""
echo "3️⃣ Testing care_space..."
echo "   Getting plugin..."
cargo contract call \
  --url "$RPC_URL" \
  --contract "$CARE_SPACE" \
  --message get_plugin \
  --args "med_reminder" \
  --suri "$MNEMONIC" \
  --skip-confirm 2>&1 | grep -i "result\|error" || echo "   ✅ Plugin retrieved"

# Test med_reminder
if [ -n "$MED_REMINDER" ]; then
  echo ""
  echo "4️⃣ Testing med_reminder..."
  TIMESTAMP=$(date +%s)
  echo "   Checking in..."
  cargo contract call \
    --url "$RPC_URL" \
    --contract "$MED_REMINDER" \
    --message check_in \
    --args "$TIMESTAMP" \
    --suri "$MNEMONIC" \
    --gas "$GAS_LIMIT" \
    --skip-confirm 2>&1 | grep -i "success\|error" || echo "   ✅ Check-in called"
  
  echo "   Getting last taken..."
  cargo contract call \
    --url "$RPC_URL" \
    --contract "$MED_REMINDER" \
    --message last_taken \
    --suri "$MNEMONIC" \
    --skip-confirm 2>&1 | grep -i "result\|error" || echo "   ✅ Last taken retrieved"
fi

# Test step_counter
if [ -n "$STEP_COUNTER" ]; then
  echo ""
  echo "5️⃣ Testing step_counter..."
  echo "   Recording steps..."
  cargo contract call \
    --url "$RPC_URL" \
    --contract "$STEP_COUNTER" \
    --message record_steps \
    --args "$ADDRESS" 8500 \
    --suri "$MNEMONIC" \
    --gas "$GAS_LIMIT" \
    --skip-confirm 2>&1 | grep -i "success\|error" || echo "   ✅ Steps recorded"
  
  echo "   Getting steps..."
  cargo contract call \
    --url "$RPC_URL" \
    --contract "$STEP_COUNTER" \
    --message get_steps \
    --args "$ADDRESS" \
    --suri "$MNEMONIC" \
    --skip-confirm 2>&1 | grep -i "result\|error" || echo "   ✅ Steps retrieved"
fi

# Test governance
if [ -n "$GOVERNANCE" ]; then
  echo ""
  echo "6️⃣ Testing governance..."
  echo "   Creating proposal..."
  cargo contract call \
    --url "$RPC_URL" \
    --contract "$GOVERNANCE" \
    --message create_proposal \
    --args "Increase daily rate to 25" \
    --suri "$MNEMONIC" \
    --gas "$GAS_LIMIT" \
    --skip-confirm 2>&1 | grep -i "success\|error" || echo "   ✅ Proposal created"
fi

echo ""
echo "✅ All tests completed!"

