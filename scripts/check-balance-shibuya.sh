#!/usr/bin/env bash

# Check balance on Shibuya Testnet
# Usage: ./check-balance-shibuya.sh

set -e

if [ -f "contracts/.env" ]; then
  source contracts/.env
elif [ -f ".env" ]; then
  source .env
fi

RPC_URL="wss://rpc.shibuya.astar.network"
ADDRESS="${ADDRESS:-5EeMfMp8ZaY49ygQfTBNB5aDtKtR88DMDmPXxAL3ZAWVzQy}"

echo "🔍 Checking balance on Shibuya Testnet..."
echo "📍 Address: $ADDRESS"
echo "🌐 RPC: $RPC_URL"
echo ""

# Use polkadot-js-api if available, or show instructions
if command -v polkadot-js-api &> /dev/null; then
  BALANCE=$(polkadot-js-api query.system.account "$ADDRESS" --ws "$RPC_URL" 2>/dev/null | grep -oE '[0-9]+' | head -1 || echo "0")
  echo "💰 Balance: $BALANCE SBY"
else
  echo "💡 To check balance, open:"
  echo "   https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.shibuya.astar.network#/accounts"
  echo ""
  echo "🔗 Get SBY tokens from:"
  echo "   https://portal.astar.network/astar/faucet"
  echo ""
  echo "⚠️  You need at least 1 SBY to deploy contracts"
fi

