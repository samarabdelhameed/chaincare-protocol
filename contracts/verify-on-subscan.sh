#!/bin/bash

# Helper script to verify contracts on Subscan
# Usage: ./verify-on-subscan.sh CONTRACT_NAME EXTRINSIC_HASH

set -e

CONTRACT_NAME="$1"
EXTRINSIC_HASH="$2"

if [ -z "$CONTRACT_NAME" ] || [ -z "$EXTRINSIC_HASH" ]; then
  echo "Usage: $0 <CONTRACT_NAME> <EXTRINSIC_HASH>"
  echo "Example: $0 health_sbt 0x123...abc"
  exit 1
fi

# Load .env
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

CONTRACT_FILE="target/ink/$CONTRACT_NAME/$CONTRACT_NAME.contract"

if [ ! -f "$CONTRACT_FILE" ]; then
  echo "❌ Error: $CONTRACT_FILE not found!"
  exit 1
fi

echo "🔍 Verifying $CONTRACT_NAME on Subscan..."
echo ""
echo "1️⃣ Open Subscan:"
echo "   https://polkadot.subscan.io/extrinsic/$EXTRINSIC_HASH"
echo ""
echo "2️⃣ Find event 'contracts.Instantiated' → Copy Contract Address"
echo ""
echo "3️⃣ Go to contract page → Click 'Verify & Publish'"
echo ""
echo "4️⃣ Upload file:"
echo "   $CONTRACT_FILE"
echo ""
echo "5️⃣ Runtime: ink! 5.0"
echo ""
echo "6️⃣ Click Verify"
echo ""
echo "✅ After verification, update addresses.polkadot-testnet.json"

