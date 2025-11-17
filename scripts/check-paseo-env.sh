#!/bin/bash

# Check Paseo Testnet environment setup
# Usage: ./check-paseo-env.sh

set -e

echo "🔍 Checking Paseo Testnet Environment Setup..."
echo ""

# Check if .env exists in contracts directory
if [ ! -f "contracts/.env" ]; then
  echo "❌ Error: contracts/.env file not found!"
  echo "   Please create it following PASEO_SETUP.md"
  exit 1
fi

# Load .env
cd contracts
source .env 2>/dev/null || export $(cat .env | grep -v '^#' | xargs)
cd ..

echo "✅ .env file found"
echo ""

# Check RPC_URL
echo "📡 Checking RPC_URL..."
if [ -z "$RPC_URL" ]; then
  echo "❌ RPC_URL is not set"
  exit 1
fi

if [ "$RPC_URL" != "wss://ws.paseo.ara.io" ]; then
  echo "⚠️  Warning: RPC_URL is set to: $RPC_URL"
  echo "   Expected: wss://ws.paseo.ara.io"
else
  echo "✅ RPC_URL is correct: $RPC_URL"
fi
echo ""

# Check VITE_WS_URL
echo "🌐 Checking VITE_WS_URL..."
if [ -z "$VITE_WS_URL" ]; then
  echo "⚠️  Warning: VITE_WS_URL is not set"
else
  if [ "$VITE_WS_URL" != "wss://ws.paseo.ara.io" ]; then
    echo "⚠️  Warning: VITE_WS_URL is set to: $VITE_WS_URL"
    echo "   Expected: wss://ws.paseo.ara.io"
  else
    echo "✅ VITE_WS_URL is correct: $VITE_WS_URL"
  fi
fi
echo ""

# Check MNEMONIC
echo "🔑 Checking MNEMONIC..."
if [ -z "$MNEMONIC" ]; then
  echo "❌ MNEMONIC is not set"
  exit 1
fi

WORD_COUNT=$(echo "$MNEMONIC" | wc -w | tr -d ' ')
if [ "$WORD_COUNT" -lt 12 ]; then
  echo "⚠️  Warning: MNEMONIC should be 12 words (found $WORD_COUNT)"
else
  echo "✅ MNEMONIC is set ($WORD_COUNT words)"
fi
echo ""

# Check ADDRESS
echo "📍 Checking ADDRESS..."
if [ -z "$ADDRESS" ]; then
  echo "⚠️  Warning: ADDRESS is not set"
else
  echo "✅ ADDRESS: $ADDRESS"
fi
echo ""

# Check NETWORK
echo "🌍 Checking NETWORK..."
if [ "$NETWORK" != "paseo" ]; then
  echo "⚠️  Warning: NETWORK is set to: $NETWORK"
  echo "   Expected: paseo"
else
  echo "✅ NETWORK is correct: $NETWORK"
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Summary:"
echo ""
echo "   RPC URL: $RPC_URL"
echo "   Network: ${NETWORK:-not set}"
echo "   Address: ${ADDRESS:-not set}"
echo ""
echo "🌐 Test connection:"
RPC_ENCODED=$(echo "$RPC_URL" | sed 's|://|%3A%2F%2F|g' | sed 's|/|%2F|g')
echo "   https://polkadot.js.org/apps/?rpc=$RPC_ENCODED#/accounts"
echo ""
echo "💰 Get PAS tokens:"
echo "   https://faucet.paseo.io"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

