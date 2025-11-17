# 🔐 ChainCARE zk-SNARK Circuits

Zero-knowledge proof circuits for privacy-preserving medication compliance verification.

## 📋 Overview

This directory contains Circom circuits and scripts for generating zk-SNARK proofs that verify medication compliance without revealing patient identity or sensitive health data.

## 🚀 Quick Start

### Prerequisites

```bash
# Install Circom
npm install -g circom

# Install snarkjs
npm install -g snarkjs
```

### Generate Proof

```bash
cd zk
npm install
npm run build
npm run generate-proof
```

## 📁 Structure

```
zk/
├── circuits/            # Circom circuit files
│   └── med_hash.circom # Medication hash verification circuit
├── scripts/            # Proof generation scripts
├── build/              # Compiled circuits
└── package.json
```

## 🔧 Circuit Details

### `med_hash.circom`

Verifies that a medication hash matches expected value without revealing:
- Patient identity
- Medication details
- Timestamp specifics

**Inputs**:
- `med_hash` - Hash of medication data
- `secret` - Secret key for verification

**Outputs**:
- `proof` - Groth16 zk-proof
- `public_signals` - Public verification signals

## 🔐 Proof Generation

1. Patient takes medication
2. Frontend generates hash of medication data
3. Circuit generates zk-proof
4. Proof submitted to `ZKCamera::submit_proof()`
5. Contract verifies proof on-chain

## 🛠️ Tools

- **Circom 2.0** - Circuit language
- **snarkjs** - Proof generation (Groth16)
- **wasm** - WebAssembly compilation

## 📝 License

MIT License - See [../LICENSE](../LICENSE)

