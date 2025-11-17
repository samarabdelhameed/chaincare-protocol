#!/bin/bash
# This script will use MNEMONIC from environment or .env
set -e

# Load .env
source .env 2>/dev/null || true

# Check for MNEMONIC
if [ -z "$MNEMONIC" ]; then
  echo "❌ MNEMONIC not found!"
  echo ""
  echo "Please set it as:"
  echo "  export MNEMONIC='your phrase'"
  echo "  ./run-deploy.sh"
  exit 1
fi

echo "🚀 Deploying all contracts..."
./deploy-all.sh
