# 📜 ChainCARE Smart Contracts

Smart contracts for ChainCARE Protocol built with **ink! 4.2** on Polkadot.

## 📁 Structure

```
contracts/
├── care_space/          # Factory contract for patient care spaces
├── health_sbt/          # Soul-Bound Token for health identity
├── care_treasury/        # DeFi treasury with yield distribution
└── plugins/              # Modular plugin system
    ├── med_reminder/    # Medication compliance tracking
    ├── zk_camera/       # Zero-knowledge proof verification
    ├── step_counter/    # Fitness oracle integration
    └── governance/      # DAO-style governance
```

## 🚀 Quick Start

### Build All Contracts

```bash
cd contracts
cargo contract build --release
```

### Build Specific Contract

```bash
cargo contract build --manifest-path care_space/Cargo.toml --release
```

### Run Tests

```bash
cargo test
```

## 📦 Contract Artifacts

After building, artifacts are generated in:
- `target/ink/<contract_name>/<contract_name>.contract` - Complete bundle
- `target/ink/<contract_name>/<contract_name>.json` - Metadata/ABI
- `target/ink/<contract_name>/<contract_name>.wasm` - WASM bytecode

## 🔧 Contracts Overview

### Core Contracts

#### `care_space`
Factory contract that creates and manages patient care spaces.

**Key Functions**:
- `new()` - Create new CareSpace
- `install_plugin()` - Install plugin contract
- `get_plugin()` - Get plugin address

#### `health_sbt`
Soul-Bound Token for patient health identity (non-transferable).

**Key Functions**:
- `mint()` - Mint Health-SBT to patient
- `owner_of()` - Get SBT metadata
- `is_holder()` - Check if account has SBT

#### `care_treasury`
DeFi treasury that manages deposits and distributes yield to compliant patients.

**Key Functions**:
- `deposit()` - Deposit funds (payable)
- `distribute_yield()` - Distribute daily yield
- `claim()` - Patient claims accumulated yield

### Plugin Contracts

#### `med_reminder`
Tracks medication compliance via check-in timestamps.

**Key Functions**:
- `check_in()` - Record medication taken
- `last_taken()` - Get last check-in time

#### `zk_camera`
Verifies zero-knowledge proofs for privacy-preserving compliance.

**Key Functions**:
- `submit_proof()` - Submit zk-proof
- `verify_proof()` - Verify proof exists

#### `step_counter`
Tracks daily step counts via oracle submissions.

**Key Functions**:
- `submit_oracle()` - Oracle submits step data
- `get_steps()` - Get patient's step count
- `is_target_met()` - Check if target met

#### `governance`
DAO-style governance for treatment plan modifications.

**Key Functions**:
- `create_proposal()` - Create new proposal
- `vote()` - Vote on proposal
- `get_proposal()` - Get proposal details

## 📚 Documentation

- **API Reference**: See [CONTRACT_API.md](../CONTRACT_API.md)
- **Deployment**: See [DEPLOY_AND_VERIFY.md](./DEPLOY_AND_VERIFY.md)
- **Architecture**: See [../docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md)

## 🧪 Testing

Test files are located in `tests/`:

- `tests/health_sbt_test.rs` - SBT minting tests
- `tests/care_treasury_test.rs` - Treasury operations tests
- `tests/med_reminder_test.rs` - Medication reminder tests

Run tests:
```bash
cargo test
```

## 🔐 Security

- All contracts use proper access control
- Error handling with custom error types
- Event emissions for all state changes
- No known security vulnerabilities

## 📝 License

MIT License - See [../LICENSE](../LICENSE)

