# 🚀 ChainCARE Deployment Scripts

Scripts for deploying and managing ChainCARE smart contracts on Polkadot testnets.

## 📁 Scripts

### Deployment Scripts

- **`deploy-paseo.sh`** - Deploy to Paseo Testnet
- **`deploy-shibuya.sh`** - Deploy to Astar Shibuya Testnet
- **`deploy-polkadot-testnet.sh`** - Deploy to Polkadot Testnet
- **`deploy-and-verify-paseo.sh`** - Deploy and verify on Paseo

### Utility Scripts

- **`check-paseo-env.sh`** - Check Paseo environment setup

## 🚀 Usage

### Deploy to Paseo

```bash
cd scripts
./deploy-and-verify-paseo.sh
```

### Deploy to Shibuya

```bash
./deploy-shibuya.sh
```

## ⚙️ Configuration

Scripts use environment variables from `contracts/.env`:

```bash
RPC_URL=wss://rpc.ibp.network/paseo
MNEMONIC="your twelve word mnemonic phrase"
ADDRESS=your_account_address
```

## 📝 Prerequisites

- `cargo-contract` installed
- Contracts built (`cargo contract build`)
- Testnet tokens (from faucet)
- Polkadot.js Extension or mnemonic

## 🔐 Security

- **Never commit** `.env` files with real mnemonics
- Use testnet accounts only
- Verify contract addresses after deployment

## 📊 Output

Scripts save deployed contract addresses to:
- `frontend/src/addresses.paseo.json`
- `frontend/src/addresses.shibuya.json`
- `frontend/src/addresses.polkadot-testnet.json`

## 📝 License

MIT License - See [../LICENSE](../LICENSE)

