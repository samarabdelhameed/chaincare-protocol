#!/bin/bash

# Script to safely add MNEMONIC to .env file

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          🔐 Setup MNEMONIC for Deployment                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}⚠️  How to get your mnemonic phrase:${NC}"
echo ""
echo -e "${BLUE}Option 1: From Polkadot.js Extension${NC}"
echo "  1. Open Polkadot.js Extension"
echo "  2. Click the 3 dots next to your account"
echo "  3. Select 'Export Account'"
echo "  4. Enter password"
echo "  5. Copy the 12-word phrase"
echo ""
echo -e "${BLUE}Option 2: From Polkadot.js Apps${NC}"
echo "  1. Go to: https://polkadot.js.org/apps/#/accounts"
echo "  2. Click on your account"
echo "  3. Select 'Export' or 'Backup'"
echo "  4. Enter password"
echo "  5. Show seed phrase"
echo "  6. Copy the 12 words"
echo ""
echo -e "${RED}⚠️  NEVER share your mnemonic with anyone!${NC}"
echo ""

read -p "Do you have your 12-word mnemonic phrase ready? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${YELLOW}Please get your mnemonic first, then run this script again.${NC}"
  exit 0
fi

echo ""
echo -e "${BLUE}Please enter your 12-word mnemonic phrase:${NC}"
read -p "Mnemonic: " MNEMONIC

# Validate
if [ -z "$MNEMONIC" ]; then
  echo -e "${RED}❌ Error: MNEMONIC cannot be empty!${NC}"
  exit 1
fi

WORD_COUNT=$(echo "$MNEMONIC" | wc -w | tr -d ' ')
if [ "$WORD_COUNT" -ne 12 ]; then
  echo -e "${RED}❌ Error: MNEMONIC must be exactly 12 words (got $WORD_COUNT)${NC}"
  exit 1
fi

# Backup existing .env
if [ -f .env ]; then
  cp .env .env.backup
  echo -e "${GREEN}✅ Backed up existing .env to .env.backup${NC}"
fi

# Update .env file
if [ -f .env ]; then
  # Remove old MNEMONIC line
  sed -i.tmp '/^MNEMONIC=/d' .env
  rm -f .env.tmp
  
  # Add new MNEMONIC
  echo "" >> .env
  echo "# Mnemonic phrase for deployment (added $(date))" >> .env
  echo "MNEMONIC=\"$MNEMONIC\"" >> .env
  
  echo -e "${GREEN}✅ MNEMONIC added to .env file${NC}"
else
  echo -e "${RED}❌ Error: .env file not found!${NC}"
  exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  ✅ Setup Complete!                        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Make sure you have at least 0.1 DOT in your account"
echo "  2. Run: ./deploy-and-verify.sh"
echo ""
echo -e "${RED}⚠️  Keep your .env file secure and never commit it to git!${NC}"
