# 🔮 ChainCARE Oracle

Oracle service for submitting step counter data to ChainCARE smart contracts.

## 📋 Overview

The oracle reads step count data from external sources (Google Fit API, fitness trackers) and submits it to the `StepCounter` smart contract on Polkadot.

## 🚀 Quick Start

```bash
cd oracle
pip install -r requirements.txt
python oracle.py
```

## 📁 Structure

```
oracle/
├── oracle.py           # Main oracle script
├── requirements.txt    # Python dependencies
└── config.json         # Configuration (API keys, contract addresses)
```

## 🔧 Configuration

Create `config.json`:

```json
{
  "rpc_url": "wss://rpc.ibp.network/paseo",
  "contract_address": "5FLSigC9HGRKVhB9F7RSwF7q8v9i3kvePkdXh8X5VWseuZWZ",
  "oracle_account": "your_account_mnemonic",
  "google_fit_api_key": "your_api_key"
}
```

## 🔐 Security

- Oracle uses mnemonic for signing transactions
- **Never commit** `config.json` with real credentials
- Use environment variables for production

## 📊 Data Sources

### Google Fit API
- Reads daily step count
- Authenticates via OAuth2
- Fetches data for registered patients

### Manual Input
- Can accept manual step count submissions
- Validates data before on-chain submission

## 🔄 Workflow

1. Oracle polls data sources (every hour)
2. Validates step count data
3. Signs transaction with oracle account
4. Submits to `StepCounter::submit_oracle()`
5. Emits `StepsRecorded` event

## 🛠️ Requirements

- Python 3.8+
- `substrate-interface` - Substrate RPC client
- `google-api-python-client` - Google Fit API

## 📝 License

MIT License - See [../LICENSE](../LICENSE)

