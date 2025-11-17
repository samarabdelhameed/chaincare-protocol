#!/bin/bash

# Deploy script that reads MNEMONIC from environment variable
# Usage: MNEMONIC="your phrase" ./deploy-with-mnemonic.sh

set -e

# Load .env (excluding MNEMONIC)
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | grep -v '^MNEMONIC=' | xargs)
fi

# Check for MNEMONIC in environment
if [ -z "$MNEMONIC" ]; then
  echo "❌ Error: MNEMONIC not found!"
  echo ""
  echo "Please set MNEMONIC as environment variable:"
  echo "  export MNEMONIC='your twelve word mnemonic phrase here'"
  echo "  ./deploy-with-mnemonic.sh"
  echo ""
  echo "Or add it to .env file:"
  echo "  echo 'MNEMONIC=your phrase' >> .env"
  echo "  ./deploy-all.sh"
  exit 1
fi

echo "🚀 Starting deployment with MNEMONIC from environment..."
echo "📝 Address: $ADDRESS"
echo "🌐 RPC: $RPC_URL"
echo ""

# Export MNEMONIC for deploy-all.sh
export MNEMONIC

# Run deployment
exec ./deploy-all.sh

