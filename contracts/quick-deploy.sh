#!/bin/bash
# Quick deploy - reads MNEMONIC from environment or prompts
set -e
source .env 2>/dev/null || true

if [ -z "$MNEMONIC" ]; then
  if [ -n "$MNEMONIC_ENV" ]; then
    MNEMONIC="$MNEMONIC_ENV"
  else
    echo "❌ MNEMONIC required. Set it as:"
    echo "   export MNEMONIC='your phrase'"
    echo "   Or add to .env: MNEMONIC=your phrase"
    exit 1
  fi
fi

export MNEMONIC
./deploy-all.sh
