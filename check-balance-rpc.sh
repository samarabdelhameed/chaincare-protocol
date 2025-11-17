#!/bin/bash

ADDRESS="5EeMfMp8ZaY49ygQZfTBNB5aDtKtR88DMDmPXxAL3ZAWVzQy"
RPC_HTTP="https://westend-rpc.polkadot.io"

echo "🔍 Checking balance for: $ADDRESS"
echo ""

# Use RPC call to get account info
RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "system_accountNextIndex",
    "params": ["'$ADDRESS'"],
    "id": 1
  }' \
  $RPC_HTTP 2>/dev/null)

if [ $? -eq 0 ]; then
  echo "✅ Connected to Westend RPC"
  echo ""
  echo "📊 For detailed balance, please visit:"
  echo "   https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Fwestend-rpc.polkadot.io#/accounts"
  echo ""
  echo "   Search for: $ADDRESS"
  echo ""
else
  echo "⚠️  Could not connect to RPC"
  echo ""
  echo "📊 Please check balance manually at:"
  echo "   https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Fwestend-rpc.polkadot.io#/accounts"
fi

echo ""
echo "💡 If you need tokens, get them from:"
echo "   https://faucet.polkadot.io/"
echo "   (Select Westend Testnet)"
