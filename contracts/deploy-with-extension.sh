#!/bin/bash

# Deploy using Polkadot.js extension (no MNEMONIC needed)
# Make sure Polkadot.js extension is installed and account is available

set -e

# Load .env
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | grep -v '^MNEMONIC=' | xargs)
fi

echo "🚀 Deploying using Polkadot.js extension..."
echo "📝 Address: $ADDRESS"
echo "🌐 RPC: $RPC_URL"
echo ""
echo "⚠️  Note: This will use cargo-contract with extension"
echo "   Make sure Polkadot.js extension is unlocked"
echo ""

# For now, we still need MNEMONIC for cargo-contract
# But we can use the address directly
echo "💡 Alternative: Use polkadot.js apps to deploy"
echo "   1. Go to: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.polkadot.io#/contracts"
echo "   2. Upload & deploy contracts from there"
echo ""

# Check if we can use subkey or other tools
if command -v subkey &> /dev/null; then
  echo "✅ subkey found - can generate keys"
else
  echo "⚠️  subkey not found"
fi

echo ""
echo "📋 To deploy with cargo-contract, you still need MNEMONIC"
echo "   Or use Polkadot.js Apps web interface"


