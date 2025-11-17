#!/bin/bash

# Helper script to verify contracts on Subscan
# Usage: ./verify-on-subscan.sh CONTRACT_NAME EXTRINSIC_HASH [NETWORK]

set -e

CONTRACT_NAME="$1"
EXTRINSIC_HASH="$2"
NETWORK="$3"

if [ -z "$CONTRACT_NAME" ] || [ -z "$EXTRINSIC_HASH" ]; then
  echo "Usage: $0 <CONTRACT_NAME> <EXTRINSIC_HASH> [NETWORK]"
  echo "Example: $0 health_sbt 0x123...abc paseo"
  exit 1
fi

# Load .env
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# Detect network if not provided
if [ -z "$NETWORK" ]; then
  if [ ! -z "$RPC_URL" ]; then
    if echo "$RPC_URL" | grep -qi "paseo"; then
      NETWORK="paseo"
    elif echo "$RPC_URL" | grep -qi "shibuya"; then
      NETWORK="shibuya"
    elif echo "$RPC_URL" | grep -qi "polkadot"; then
      NETWORK="polkadot"
    elif echo "$RPC_URL" | grep -qi "westend"; then
      NETWORK="westend"
    else
      NETWORK="polkadot"  # default
    fi
  else
    NETWORK="polkadot"  # default
  fi
fi

# Get Subscan URL based on network
case "$NETWORK" in
  paseo)
    SUBSCAN_BASE="https://paseo.subscan.io"
    ;;
  shibuya)
    SUBSCAN_BASE="https://shibuya.subscan.io"
    ;;
  polkadot|polkadot-testnet)
    SUBSCAN_BASE="https://polkadot.subscan.io"
    ;;
  westend)
    SUBSCAN_BASE="https://westend.subscan.io"
    ;;
  *)
    SUBSCAN_BASE="https://polkadot.subscan.io"  # default
    ;;
esac

CONTRACT_FILE="target/ink/$CONTRACT_NAME/$CONTRACT_NAME.contract"

if [ ! -f "$CONTRACT_FILE" ]; then
  echo "❌ Error: $CONTRACT_FILE not found!"
  exit 1
fi

echo "🔍 Verifying $CONTRACT_NAME on Subscan ($NETWORK)..."
echo ""
echo "1️⃣ Open Subscan:"
echo "   $SUBSCAN_BASE/extrinsic/$EXTRINSIC_HASH"
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
echo "✅ After verification, update addresses file for $NETWORK network"

