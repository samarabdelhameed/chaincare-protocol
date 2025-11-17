# 🚀 Paseo Testnet Setup - ChainCARE Protocol

## Paseo Testnet (Official Community Testnet)
**Website:** https://paseo.io  
**Faucet:** https://faucet.paseo.io  
**RPC:** `wss://ws.paseo.ara.io`

---

## ✅ Step 1: Create `.env` File

In the `contracts/` directory, create a `.env` file with the following content:

```bash
# Paseo Testnet (Official Community Testnet)

RPC_URL=wss://ws.paseo.ara.io

MNEMONIC="your twelve word mnemonic phrase here"

GAS_LIMIT=1000000000000

VITE_WS_URL=wss://ws.paseo.ara.io

ADDRESS=your_account_address

NETWORK=paseo

HEALTH_SBT_ADMIN=your_address
TREASURY_ADMIN=your_address
CARE_SPACE_OWNER=your_address
CARE_SPACE_PATIENT=your_address
CARE_SPACE_NAME="CareSpace#1"
TREASURY_DAILY_RATE=20
MED_REMINDER_MED_ID="med_001"
```

**Important Notes:**
- Replace `MNEMONIC` with your own mnemonic
- Replace `ADDRESS` with your wallet address

---

## ✅ Step 2: Get PAS Tokens

### Steps:
1. Open: **https://faucet.paseo.io**
2. Enter your address
3. Request **10 PAS** → tokens arrive in seconds

---

## ✅ Step 3: Verify Setup

### Verify `.env` file:
```bash
cd contracts
dotenv -- echo $RPC_URL
# Should print: wss://ws.paseo.ara.io
```

### Check Balance:
```bash
# From project root
./check-balance.sh
```

Or open in browser:
```
https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Fws.paseo.ara.io#/accounts
```

---

## ✅ Step 4: Test Connection

```bash
cd contracts
source .env
echo "RPC: $RPC_URL"
echo "Address: $ADDRESS"
echo "Network: $NETWORK"
```

---

## 📝 Notes

- **Paseo** is an official testnet supported by Parity and the community
- **Fast RPC**: `wss://ws.paseo.ara.io`
- **Easy Faucet**: https://faucet.paseo.io
- **Token**: PAS (test DOT)

---

## 🔗 Useful Links

- **Paseo Website**: https://paseo.io
- **Faucet**: https://faucet.paseo.io
- **Polkadot.js Apps**: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Fws.paseo.ara.io#/accounts
- **Explorer**: https://paseo.subscan.io (if available)

---

## ⚠️ Warnings

1. **Do not commit `.env` file to Git** - protected in `.gitignore`
2. **Save your mnemonic** in a secure place
3. **Use testnet only** - do not use real mainnet tokens

---

## ✅ After Verification

After confirming:
- ✅ `.env` file exists and contains `RPC_URL=wss://ws.paseo.ara.io`
- ✅ Faucet successfully provides PAS tokens
- ✅ Command `dotenv -- echo $RPC_URL` prints the correct value

You can proceed with deployment! 🚀
