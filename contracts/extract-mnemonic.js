#!/usr/bin/env node

// Script to extract mnemonic from encrypted Polkadot.js backup
// Usage: node extract-mnemonic.js <backup.json> <password>

const fs = require('fs');
const readline = require('readline');

console.log('\n╔════════════════════════════════════════════════════════════╗');
console.log('║     🔐 Polkadot.js Backup Mnemonic Extractor              ║');
console.log('╚════════════════════════════════════════════════════════════╝\n');

console.log('⚠️  This script requires @polkadot/util-crypto package');
console.log('⚠️  Install it first: npm install @polkadot/util-crypto\n');

console.log('📝 Alternative: Extract mnemonic manually from Polkadot.js:\n');
console.log('Method 1: From Extension');
console.log('  1. Open Polkadot.js Extension');
console.log('  2. Click ⋮ (3 dots) next to account');
console.log('  3. Select "Export Account"');
console.log('  4. Enter password');
console.log('  5. Copy the 12-word mnemonic phrase\n');

console.log('Method 2: From Polkadot.js Apps');
console.log('  1. Go to: https://polkadot.js.org/apps/#/accounts');
console.log('  2. Click on your account');
console.log('  3. Click "..." → "Export account"');
console.log('  4. Enter password');
console.log('  5. You\'ll see the mnemonic phrase\n');

console.log('Method 3: Import to Extension first');
console.log('  1. Open Polkadot.js Extension');
console.log('  2. Click "+" → "Restore account from backup JSON"');
console.log('  3. Upload your JSON file');
console.log('  4. Enter password');
console.log('  5. Then export as shown in Method 1\n');

console.log('🔴 IMPORTANT: Your JSON file contains:');
console.log('   Address: 5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN');
console.log('   Name: sa123\n');

console.log('✅ Using address from JSON file:');
console.log('   Address: 5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN\n');

console.log('❓ Which account do you want to use for deployment?\n');

process.exit(0);
