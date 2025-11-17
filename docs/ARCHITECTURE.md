# 🏗️ ChainCARE Protocol Architecture

## Overview

ChainCARE is built on a modular, plugin-based architecture that integrates seamlessly with the Polkadot ecosystem. This document provides a detailed technical overview of the system architecture, contract interactions, and data flows.

---

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         CHAINCARE PROTOCOL                                │
│                      (Polkadot Ecosystem Integration)                      │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                              USER LAYER                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                  │
│  │  Patient    │    │   Doctor    │    │   Family    │                  │
│  │   (PWA)     │    │   (PWA)     │    │   (PWA)     │                  │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘                  │
│         │                  │                  │                           │
│         └──────────────────┴──────────────────┘                           │
│                              │                                           │
│                              ▼                                           │
│                    ┌──────────────────┐                                   │
│                    │  Polkadot-js     │                                   │
│                    │   Extension      │                                   │
│                    │   (Wallet)       │                                   │
│                    └────────┬─────────┘                                   │
│                             │                                             │
└─────────────────────────────┼─────────────────────────────────────────────┘
                              │
┌─────────────────────────────┼─────────────────────────────────────────────┐
│                             │          BLOCKCHAIN LAYER                    │
├─────────────────────────────┼─────────────────────────────────────────────┤
│                             │                                             │
│                             ▼                                             │
│              ┌──────────────────────────────────────┐                     │
│              │      Polkadot Network                 │                     │
│              │      (Astar Shibuya → Mainnet)       │                     │
│              └──────────────┬───────────────────────┘                     │
│                             │                                             │
│                             ▼                                             │
│      ┌────────────────────────────────────────────────┐                  │
│      │         ink! Smart Contracts (4.2)              │                  │
│      │                                                  │                  │
│      │  ┌──────────────────────────────────────────┐  │                  │
│      │  │          CareSpace Factory                │  │                  │
│      │  │  • Creates patient care spaces            │  │                  │
│      │  │  • Manages plugin installations           │  │                  │
│      │  │  • Links to Health-SBT & Treasury         │  │                  │
│      │  └────┬─────────────┬───────────────┬────────┘  │                  │
│      │       │             │               │            │                  │
│      │       ▼             ▼               ▼            │                  │
│      │  ┌─────────┐  ┌──────────┐  ┌──────────────┐   │                  │
│      │  │Health-SBT│  │Care      │  │   Plugins    │   │                  │
│      │  │          │  │Treasury  │  │   System     │   │                  │
│      │  │• Mint    │  │          │  │              │   │                  │
│      │  │• Verify  │  │• Deposit │  │ ┌──────────┐ │   │                  │
│      │  │• SBT     │  │• Yield   │  │ │Med       │ │   │                  │
│      │  └─────────┘  │• Claim   │  │ │Reminder  │ │   │                  │
│      │               └──────────┘  │ └──────────┘ │   │                  │
│      │                             │ ┌──────────┐ │   │                  │
│      │                             │ │ZKCamera  │ │   │                  │
│      │                             │ │(zk-SNARK)│ │   │                  │
│      │                             │ └──────────┘ │   │                  │
│      │                             │ ┌──────────┐ │   │                  │
│      │                             │ │Step      │ │   │                  │
│      │                             │ │Counter   │ │   │                  │
│      │                             │ │(Oracle)  │ │   │                  │
│      │                             │ └──────────┘ │   │                  │
│      │                             │ ┌──────────┐ │   │                  │
│      │                             │ │Governance│ │   │                  │
│      │                             │ │(DAO)     │ │   │                  │
│      │                             │ └──────────┘ │   │                  │
│      │                             └──────────────┘   │                  │
│      └────────────────────────────────────────────────┘                  │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────┼─────────────────────────────────────────────┐
│                             │          ORACLE & IoT LAYER                 │
├─────────────────────────────┼─────────────────────────────────────────────┤
│                             │                                             │
│                             ▼                                             │
│      ┌─────────────────────────────────────────────────┐                 │
│      │           External Data Sources                  │                 │
│      │                                                  │                 │
│      │  ┌─────────────┐  ┌──────────────┐             │                 │
│      │  │   NFC Tag   │  │  BLE Sensor  │             │                 │
│      │  │ (Med Box)   │  │  (Med Box)   │             │                 │
│      │  └──────┬──────┘  └──────┬───────┘             │                 │
│      │         │                │                      │                 │
│      │         └────────┬───────┘                      │                 │
│      │                  │                              │                 │
│      │                  ▼                              │                 │
│      │         ┌─────────────────┐                     │                 │
│      │         │  Raspberry Pi   │                     │                 │
│      │         │     Oracle      │                     │                 │
│      │         │                 │                     │                 │
│      │         │ • Reads BLE     │                     │                 │
│      │         │ • Signs data    │                     │                 │
│      │         │ • Submits txn   │                     │                 │
│      │         └────────┬────────┘                     │                 │
│      │                  │                              │                 │
│      │                  ▼                              │                 │
│      │         ┌─────────────────┐                     │                 │
│      │         │  Google Fit API │                     │                 │
│      │         │  (Step Counter) │                     │                 │
│      │         └─────────────────┘                     │                 │
│      └─────────────────────────────────────────────────┘                 │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────┼─────────────────────────────────────────────┐
│                             │          zk-SNARK LAYER                      │
├─────────────────────────────┼─────────────────────────────────────────────┤
│                             │                                             │
│                             ▼                                             │
│      ┌─────────────────────────────────────────────────┐                 │
│      │         Zero-Knowledge Proof System             │                 │
│      │                                                  │                 │
│      │  ┌──────────────────────────────────────────┐  │                 │
│      │  │           Circom Circuits                 │  │                 │
│      │  │                                           │  │                 │
│      │  │  • med_hash.circom                        │  │                 │
│      │  │  • patient_verification.circom            │  │                 │
│      │  │                                           │  │                 │
│      │  │  Compiled via snarkjs                     │  │                 │
│      │  └───────────────┬───────────────────────────┘  │                 │
│      │                  │                              │                 │
│      │                  ▼                              │                 │
│      │  ┌──────────────────────────────────────────┐  │                 │
│      │  │      Proof Generation (PWA)               │  │                 │
│      │  │                                           │  │                 │
│      │  │  1. Patient takes silhouette photo        │  │                 │
│      │  │  2. PWA generates zk-proof                │  │                 │
│      │  │  3. Submits proof + hash to contract      │  │                 │
│      │  └───────────────┬───────────────────────────┘  │                 │
│      │                  │                              │                 │
│      │                  ▼                              │                 │
│      │  ┌──────────────────────────────────────────┐  │                 │
│      │  │      On-Chain Verification                │  │                 │
│      │  │                                           │  │                 │
│      │  │  ZKCamera::submit_proof()                 │  │                 │
│      │  │  • Verifies proof                         │  │                 │
│      │  │  • Mints CompliantDayNFT                  │  │                 │
│      │  └──────────────────────────────────────────┘  │                 │
│      └─────────────────────────────────────────────────┘                 │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
```

---

## Contract Interaction Flow

### 1. Patient Onboarding Flow

```
Doctor                    PWA                  Polkadot-js           Contracts
  │                        │                       │                    │
  │── Create CareSpace ───►│                       │                    │
  │                        │── Connect Wallet ────►│                    │
  │                        │                       │── Sign Tx ────────►│
  │                        │                       │                    │── CareSpace::new()
  │                        │                       │                    │── Health-SBT::mint()
  │                        │                       │                    │── Treasury::deposit()
  │                        │◄── Events ────────────┼◄── Tx Hash ───────│
  │◄── Success ────────────│                       │                    │
```

### 2. Daily Medication Compliance Flow

```
NFC Tag          PWA           Oracle          Polkadot-js       Contracts
  │               │              │                 │                 │
  │── Tap ───────►│              │                 │                 │
  │               │── BLE ──────►│                 │                 │
  │               │              │── Sign ────────►│                 │
  │               │              │                 │── Submit ──────►│
  │               │              │                 │                 │── MedReminder::check_in()
  │               │              │                 │                 │── Emit MedTaken event
  │               │              │                 │◄── Tx Hash ──────│
  │               │◄── Success ──┼◄── Success ─────┼                 │
```

### 3. zk-Proof Verification Flow

```
Patient         PWA              zk Circuit        Polkadot-js       Contracts
  │              │                   │                 │                 │
  │── Photo ────►│                   │                 │                 │
  │              │── Generate ──────►│                 │                 │
  │              │    proof          │                 │                 │
  │              │                   │◄── proof ───────│                 │
  │              │── Submit ──────────────────────────►│                 │
  │              │                                        │── Submit ────►│
  │              │                                        │                 │── ZKCamera::submit_proof()
  │              │                                        │                 │── Verify proof
  │              │                                        │                 │── Mint CompliantDayNFT
  │              │                                        │◄── Tx Hash ────│
  │◄── Success ──┼◄── Success ───────────────────────────┼                 │
```

### 4. Yield Distribution Flow

```
Cron Job         Oracle          Polkadot-js       Contracts
  │                 │                 │                 │
  │── Trigger ─────►│                 │                 │
  │                 │── Submit ──────►│                 │
  │                 │                 │── Submit ──────►│
  │                 │                 │                 │── Treasury::distribute_yield()
  │                 │                 │                 │── Calculate compliance
  │                 │                 │                 │── Update balances
  │                 │                 │◄── Tx Hash ──────│
  │                 │◄── Success ─────┼                 │
```

### 5. Claim Yield Flow

```
Patient         PWA              Polkadot-js       Contracts
  │              │                   │                 │
  │── Claim ────►│                   │                 │
  │              │── Connect ───────►│                 │
  │              │                   │── Sign ────────►│
  │              │                   │                 │── Treasury::claim()
  │              │                   │                 │── Transfer yield
  │              │                   │◄── Tx Hash ─────│
  │◄── Success ──┼◄── Success ───────┼                 │
```

---

## Data Structures

### CareSpace Storage

```rust
pub struct CareSpace {
    owner: AccountId,                    // Doctor/admin address
    name: String,                        // CareSpace identifier
    patient: AccountId,                  // Patient wallet address
    treasury: AccountId,                 // CareTreasury contract address
    sbt: AccountId,                      // Health-SBT contract address
    plugins: Mapping<String, AccountId>, // Plugin name → contract address
}
```

### Health-SBT Token

```rust
pub struct Token {
    metadata: String,  // JSON: {diagnosis, meds, target_steps, ...}
    issued: u64,      // Timestamp when minted
}
```

### Treasury Balance

```rust
pub struct CareTreasury {
    admin: AccountId,
    daily_rate: u128,                    // Per-mil (e.g., 20 = 0.002% daily)
    balances: Mapping<AccountId, u128>, // Patient → accumulated yield
    total_deposits: u128,
}
```

### Compliance Day NFT

```rust
pub struct CompliantDay {
    patient: AccountId,
    date: u64,          // Unix timestamp
    med_proof: Option<[u8; 32]>,  // Hash of medication proof
    step_proof: Option<u32>,      // Steps achieved
    zk_proof: Option<[u8; 64]>,   // zk-SNARK proof hash
}
```

---

## Security Considerations

### 1. Smart Contract Security
- **Access Control**: Only authorized addresses can mint SBTs, modify treasury
- **Overflow Protection**: Using `checked_add` for arithmetic operations
- **Reentrancy**: No external calls before state updates

### 2. zk-SNARK Security
- **Trusted Setup**: Using Groth16 with public parameters
- **Proof Verification**: On-chain verification prevents fake proofs
- **Privacy**: Patient data never stored on-chain, only proofs

### 3. Oracle Security
- **Signature Verification**: Oracle signs all data submissions
- **Rate Limiting**: Prevents oracle spam attacks
- **Whitelist**: Only authorized oracles can submit data

### 4. Frontend Security
- **Wallet Integration**: Uses Polkadot-js extension (never stores private keys)
- **HTTPS Only**: PWA requires secure context
- **Input Validation**: All user inputs validated before submission

---

## Performance Optimization

### 1. Gas Optimization
- **Batch Operations**: Multiple plugin calls in single transaction
- **Storage Optimization**: Using `Mapping` instead of `Vec` where possible
- **Event Filtering**: Only emit essential events

### 2. Frontend Optimization
- **Code Splitting**: Lazy load components
- **Caching**: Cache contract ABIs and metadata
- **PWA**: Offline support for reading cached data

### 3. Oracle Optimization
- **Batching**: Batch multiple data points into single transaction
- **Caching**: Cache API responses (Google Fit, etc.)
- **Retry Logic**: Automatic retry on network failures

---

## Future Enhancements

### Planned Features
1. **Multi-Chain Support**: Deploy on Moonbeam, Acala, other parachains
2. **Cross-Chain Messaging**: XCM for inter-parachain communication
3. **Advanced Analytics**: ML-based compliance prediction
4. **Insurance Integration**: Direct integration with health insurance companies
5. **Research Data Marketplace**: Patients can sell anonymized health data

### Scalability Improvements
1. **Layer 2**: Consider off-chain computation for complex analytics
2. **State Channels**: For high-frequency IoT updates
3. **Parachain**: Native ChainCARE parachain for maximum performance

---

## Integration Points

### External Services
- **Google Fit API**: Step count data
- **Subscan API**: Transaction history and analytics
- **Polkaholic**: Alternative block explorer
- **IPFS**: Metadata storage (future)

### Polkadot Ecosystem
- **Astar Network**: Primary deployment target
- **Polkadot-js**: Wallet and API integration
- **ink!**: Smart contract framework
- **XCM**: Cross-chain messaging (future)

---

<div align="center">

**For more details, see the [main README](../README.md)**

</div>

