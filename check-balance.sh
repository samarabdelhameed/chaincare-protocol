#!/bin/bash

# Load .env
source .env 2>/dev/null || export $(cat .env | grep -v '^#' | xargs)

ADDRESS="${ADDRESS:-5EeMfMp8ZaY49ygQZfTBNB5aDtKtR88DMDmPXxAL3ZAWVzQy}"
RPC_URL="${RPC_URL:-wss://westend-rpc.polkadot.io}"

echo "🔍 Checking balance for address: $ADDRESS"
echo "🌐 RPC: $RPC_URL"
echo ""

# Convert RPC URL to HTTP for curl
HTTP_RPC=$(echo "$RPC_URL" | sed 's/wss:/https:/' | sed 's/ws:/http:/')

# Use Polkadot.js Apps API or direct RPC call
echo "📊 Checking balance via Polkadot.js Apps..."
echo ""
echo "🌐 Open this URL in your browser to check balance:"
echo "   https://polkadot.js.org/apps/?rpc=${RPC_URL//\//%2F}#/accounts"
echo ""
echo "   Or search for your address: $ADDRESS"
echo ""
echo "💡 Alternative: Use Westend Faucet to get tokens:"
echo "   https://faucet.polkadot.io/"
echo ""
