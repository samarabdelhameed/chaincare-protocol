# 📦 Smart Contract Artifacts

This directory contains the compiled smart contract artifacts (ABI, metadata, and WASM files) for all ChainCARE Protocol contracts.

## 📋 Contents

### Core Contracts

- **`care_space/`** - CareSpace Factory contract
  - `care_space.contract` - Complete contract bundle (metadata + WASM)
  - `care_space.json` - Contract metadata (ABI)
  - `care_space.wasm` - Compiled WASM bytecode

- **`health_sbt/`** - Health Soul-Bound Token contract
  - `health_sbt.contract`
  - `health_sbt.json`
  - `health_sbt.wasm`

- **`care_treasury/`** - DeFi Treasury contract
  - `care_treasury.contract`
  - `care_treasury.json`
  - `care_treasury.wasm`

### Plugin Contracts

- **`med_reminder/`** - Medication Reminder plugin
  - `med_reminder.contract`
  - `med_reminder.json`
  - `med_reminder.wasm`

- **`zk_camera/`** - Zero-Knowledge Camera verification plugin
  - `zk_camera.contract`
  - `zk_camera.json`
  - `zk_camera.wasm`

- **`step_counter/`** - Step Counter oracle plugin
  - `step_counter.contract`
  - `step_counter.json`
  - `step_counter.wasm`

- **`governance/`** - Governance/DAO plugin
  - `governance.contract`
  - `governance.json`
  - `governance.wasm`

## 🔧 How to Generate Artifacts

To build all contracts and generate artifacts:

```bash
cd contracts

# Build all contracts
cargo contract build --release

# Artifacts will be generated in:
# contracts/target/ink/<contract_name>/
```

## 📄 File Formats

### `.contract` File
Complete contract bundle containing:
- Contract metadata (ABI)
- WASM bytecode
- Source code hash
- Contract version info

**Usage**: Upload to block explorers (Subscan, Polkaholic) for contract verification.

### `.json` File
Contract metadata in JSON format containing:
- Contract ABI (messages, constructors, events)
- Storage layout
- Type definitions
- Documentation

**Usage**: Frontend integration, contract interaction via Polkadot.js API.

### `.wasm` File
Compiled WebAssembly bytecode.

**Usage**: Contract deployment, on-chain execution.

## 🔗 Contract Addresses

After deployment, contract addresses are saved in:
- `frontend/src/addresses.paseo.json` (Paseo Testnet)
- `frontend/src/addresses.shibuya.json` (Astar Shibuya)
- `frontend/src/addresses.polkadot-testnet.json` (Polkadot Testnet)

## ✅ Verification

To verify contracts on block explorers:

1. Navigate to contract page on [Polkaholic](https://polkaholic.io) or [Subscan](https://subscan.io)
2. Click **"Verify & Publish"**
3. Upload the `.contract` file from this directory
4. Select Runtime: **ink! 4.2**
5. Click **Verify**

## 📊 Contract Metadata Structure

Each `.json` metadata file contains:

```json
{
  "source": {
    "hash": "...",
    "language": "ink! 4.2",
    "compiler": "rustc"
  },
  "contract": {
    "name": "ContractName",
    "version": "1.0.0"
  },
  "spec": {
    "constructors": [...],
    "messages": [...],
    "events": [...],
    "storage": {...}
  }
}
```

## 🔍 Viewing Contract Details

### Using Polkadot.js Apps

1. Open [Polkadot.js Apps](https://polkadot.js.org/apps)
2. Navigate to **Developer** → **Contracts**
3. Upload `.contract` file or connect to deployed contract
4. View all messages, events, and storage

### Using cargo-contract

```bash
# View contract metadata
cargo contract metadata --file <contract>.json

# Decode contract bundle
cargo contract decode --file <contract>.contract
```

## 📝 Notes

- All contracts are built with **ink! 4.2**
- Contracts are optimized for **release** builds
- WASM files are optimized using `wasm-opt`
- All contracts follow Rust best practices and security guidelines

---

**For detailed API documentation, see [CONTRACT_API.md](../CONTRACT_API.md)**

