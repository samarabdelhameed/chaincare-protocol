#!/usr/bin/env bash

source .env

while IFS='=' read -r contract addr; do
  if [ -z "$contract" ] || [ -z "$addr" ]; then
    continue
  fi
  
  echo "🔍 Verifying $contract on Subscan..."
  
  # Contract files are in target/ink regardless of source location
  contract_file="contracts/target/ink/$contract/$contract.contract"
  
  if [ ! -f "$contract_file" ]; then
    echo "  ⚠️  Contract file not found: $contract_file"
    continue
  fi
  
  curl -X POST https://westend.subscan.io/api/contract/verify \
    -H "Content-Type: multipart/form-data" \
    -F "address=$addr" \
    -F "runtime=ink! 5.0" \
    -F "file=@$contract_file" 2>&1 | head -20
  
  echo "✅ $contract verified"
  echo ""
done < scripts/addresses.log
