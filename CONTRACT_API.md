# 📚 ChainCARE Protocol - Smart Contract API Documentation

Complete API reference for all ChainCARE Protocol smart contracts.

---

## 📋 Table of Contents

- [CareSpace Contract](#carespace-contract)
- [Health-SBT Contract](#health-sbt-contract)
- [CareTreasury Contract](#caretreasury-contract)
- [MedReminder Plugin](#medreminder-plugin)
- [ZKCamera Plugin](#zkcamera-plugin)
- [StepCounter Plugin](#stepcounter-plugin)
- [Governance Plugin](#governance-plugin)
- [Events Reference](#events-reference)
- [Error Codes](#error-codes)

---

## 🏗️ CareSpace Contract

**Contract Name**: `care_space`  
**Purpose**: Factory contract that creates and manages patient care spaces, installs plugins, and links to Health-SBT and Treasury contracts.

### Constructor

| Function | Parameters | Description |
|----------|-----------|-------------|
| `new` | `owner: AccountId`<br>`name: String`<br>`patient: AccountId`<br>`treasury: AccountId`<br>`sbt: AccountId` | Creates a new CareSpace instance. Links to treasury and SBT contracts. |

### Messages

| Message | Parameters | Returns | Description | Access Control |
|---------|-----------|---------|-------------|----------------|
| `install_plugin` | `name: String`<br>`account: AccountId` | - | Installs a plugin contract into this CareSpace. Emits `PluginInstalled` event. | Owner only |
| `get_plugin` | `name: String` | `Option<AccountId>` | Returns the contract address of an installed plugin by name. | Public |
| `who_is_patient` | - | `AccountId` | Returns the patient's wallet address for this CareSpace. | Public |

### Events

| Event | Fields | Description |
|-------|--------|-------------|
| `PluginInstalled` | `name: String`<br>`account: AccountId` | Emitted when a plugin is successfully installed. |

### Storage

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

---

## 🎫 Health-SBT Contract

**Contract Name**: `health_sbt`  
**Purpose**: Soul-Bound Token (SBT) for patient health identity. Non-transferable, on-chain health record.

### Constructor

| Function | Parameters | Description |
|----------|-----------|-------------|
| `new` | `owner: AccountId` | Creates a new Health-SBT contract. Owner can mint SBTs. |

### Messages

| Message | Parameters | Returns | Description | Access Control |
|---------|-----------|---------|-------------|----------------|
| `mint` | `to: AccountId`<br>`metadata: String` | `Result<(), Error>` | Mints a Health-SBT to the specified account. Metadata is JSON string containing diagnosis, medications, etc. Emits `Minted` event. | Owner only |
| `owner_of` | `account: AccountId` | `Option<Token>` | Returns the SBT token data (metadata + issued timestamp) for an account. Returns `None` if account doesn't have an SBT. | Public |
| `is_holder` | `account: AccountId` | `bool` | Checks if an account holds a Health-SBT. | Public |

### Events

| Event | Fields | Description |
|-------|--------|-------------|
| `Minted` | `to: AccountId`<br>`metadata: String` | Emitted when a Health-SBT is minted. |

### Error Codes

| Error | Description |
|-------|-------------|
| `Unauthorised` | Caller is not the contract owner. |
| `AlreadyExists` | Account already has a Health-SBT. |

### Token Structure

```rust
pub struct Token {
    metadata: String,  // JSON: {"diagnosis": "Type-2", "meds": [...], "target_steps": 6000}
    issued: u64,      // Unix timestamp when SBT was minted
}
```

### Example Metadata JSON

```json
{
  "diagnosis": "Type-2 Diabetes",
  "medications": [
    {"name": "Metformin", "dose": "500mg", "frequency": "twice daily"}
  ],
  "target_steps": 6000,
  "care_plan_duration": 30
}
```

---

## 💰 CareTreasury Contract

**Contract Name**: `care_treasury`  
**Purpose**: DeFi treasury that manages deposits, calculates yield, and distributes rewards to compliant patients.

### Constructor

| Function | Parameters | Description |
|----------|-----------|-------------|
| `new` | `admin: AccountId`<br>`daily_rate: u128` | Creates a new treasury. `daily_rate` is per-mil (e.g., 20 = 0.002% daily ≈ 0.73% yearly). |

### Messages

| Message | Parameters | Returns | Description | Access Control |
|---------|-----------|---------|-------------|----------------|
| `deposit` | - (payable) | - | Deposits funds into the treasury. Caller must send value with transaction. Emits `Deposited` event. | Public (payable) |
| `distribute_yield` | `compliant_patients: Vec<AccountId>` | - | Distributes daily yield to compliant patients. Calculates: `daily_pool = balance * daily_rate / 1_000_000`, then splits equally among patients. | Admin only |
| `claim` | - | `Result<(), Error>` | Patient claims their accumulated yield. Transfers balance to caller. Emits `YieldPaid` event. | Public |
| `balance_of` | `account: AccountId` | `u128` | Returns the accumulated (unclaimed) yield balance for an account. | Public |

### Events

| Event | Fields | Description |
|-------|--------|-------------|
| `Deposited` | `from: AccountId`<br>`amount: u128` | Emitted when funds are deposited. |
| `YieldPaid` | `to: AccountId`<br>`amount: u128` | Emitted when a patient claims yield. |

### Error Codes

| Error | Description |
|-------|-------------|
| `ZeroClaim` | Patient has no yield to claim (balance is 0). |
| `TransferFailed` | Failed to transfer yield to patient (should not happen). |

### Yield Calculation Formula

```
daily_pool = treasury_balance * daily_rate / 1_000_000
yield_per_patient = daily_pool / total_compliant_patients
```

**Example**: 
- Treasury balance: 1000 DOT
- Daily rate: 20 (0.002% daily)
- Compliant patients: 10
- Daily pool: 1000 * 20 / 1_000_000 = 0.02 DOT
- Yield per patient: 0.02 / 10 = 0.002 DOT

---

## 💊 MedReminder Plugin

**Contract Name**: `med_reminder`  
**Purpose**: Tracks medication compliance by recording check-in timestamps.

### Constructor

| Function | Parameters | Description |
|----------|-----------|-------------|
| `new` | `med_id: String` | Creates a new medication reminder instance for a specific medication ID. |

### Messages

| Message | Parameters | Returns | Description | Access Control |
|---------|-----------|---------|-------------|----------------|
| `check_in` | `timestamp: u64` | - | Records a medication check-in. Updates `last_taken` timestamp. Emits `MedTaken` event. | Public |
| `last_taken` | - | `u64` | Returns the timestamp of the last medication check-in. | Public |
| `med_id` | - | `String` | Returns the medication ID this reminder is tracking. | Public |

### Events

| Event | Fields | Description |
|-------|--------|-------------|
| `MedTaken` | `med_id: String`<br>`timestamp: u64` | Emitted when patient checks in for medication. |

### Storage

```rust
pub struct MedReminder {
    med_id: String,      // Medication identifier (e.g., "metformin_500mg")
    last_taken: u64,    // Unix timestamp of last check-in
}
```

---

## 📷 ZKCamera Plugin

**Contract Name**: `zk_camera`  
**Purpose**: Verifies zero-knowledge proofs for medication compliance without revealing patient privacy.

### Constructor

| Function | Parameters | Description |
|----------|-----------|-------------|
| `new` | `admin: AccountId` | Creates a new ZK Camera instance. Admin can submit proofs. |

### Messages

| Message | Parameters | Returns | Description | Access Control |
|---------|-----------|---------|-------------|----------------|
| `submit_proof` | `patient: AccountId`<br>`proof_bytes: Vec<u8>`<br>`timestamp: u64` | `Result<(), Error>` | Submits a zk-SNARK proof for patient compliance. Stores proof and timestamp. Emits `ProofSubmitted` event. | Admin only |
| `verify_proof` | `patient: AccountId` | `bool` | Checks if a proof exists for a patient. | Public |
| `get_proof` | `patient: AccountId` | `Option<ZkProof>` | Returns the stored proof data for a patient. | Public |

### Events

| Event | Fields | Description |
|-------|--------|-------------|
| `ProofSubmitted` | `patient: AccountId`<br>`timestamp: u64` | Emitted when a zk-proof is successfully submitted. |

### Error Codes

| Error | Description |
|-------|-------------|
| `Unauthorised` | Caller is not the admin. |

### Proof Structure

```rust
pub struct ZkProof {
    proof_bytes: Vec<u8>,  // Serialized zk-SNARK proof (Groth16)
    timestamp: u64,        // Unix timestamp when proof was generated
}
```

---

## 👟 StepCounter Plugin

**Contract Name**: `step_counter`  
**Purpose**: Tracks daily step counts via oracle submissions. Used for fitness compliance verification.

### Constructor

| Function | Parameters | Description |
|----------|-----------|-------------|
| `new` | `admin: AccountId`<br>`daily_target: u64` | Creates a new step counter. `daily_target` is the minimum steps required per day (e.g., 6000). |

### Messages

| Message | Parameters | Returns | Description | Access Control |
|---------|-----------|---------|-------------|----------------|
| `submit_oracle` | `patient: AccountId`<br>`steps: u64`<br>`date: u64` | `Result<(), Error>` | Oracle submits step count data for a patient. Updates patient's step count. Emits `StepsRecorded` event. | Admin (Oracle) only |
| `get_steps` | `patient: AccountId` | `u64` | Returns the current step count for a patient. | Public |
| `is_target_met` | `patient: AccountId` | `bool` | Checks if patient has met their daily step target. | Public |
| `daily_target` | - | `u64` | Returns the daily step target. | Public |

### Events

| Event | Fields | Description |
|-------|--------|-------------|
| `StepsRecorded` | `patient: AccountId`<br>`steps: u64`<br>`date: u64` | Emitted when oracle submits step data. |

### Error Codes

| Error | Description |
|-------|-------------|
| `Unauthorised` | Caller is not the oracle admin. |

---

## 🗳️ Governance Plugin

**Contract Name**: `governance`  
**Purpose**: DAO-style governance for treatment plan modifications and treasury spending proposals.

### Constructor

| Function | Parameters | Description |
|----------|-----------|-------------|
| `new` | `admin: AccountId` | Creates a new governance instance. Admin can create proposals. |

### Messages

| Message | Parameters | Returns | Description | Access Control |
|---------|-----------|---------|-------------|----------------|
| `create_proposal` | `description: String` | `Result<u64, Error>` | Creates a new governance proposal. Returns proposal ID. Emits `ProposalCreated` event. | Admin only |
| `vote` | `id: u64`<br>`vote: bool` | `Result<(), Error>` | Votes on a proposal. `true` = for, `false` = against. Each account can vote once. Emits `Voted` event. | Public |
| `get_proposal` | `id: u64` | `Option<Proposal>` | Returns proposal details including votes. | Public |
| `has_voted` | `id: u64`<br>`voter: AccountId` | `bool` | Checks if an account has voted on a proposal. | Public |

### Events

| Event | Fields | Description |
|-------|--------|-------------|
| `ProposalCreated` | `id: u64`<br>`description: String` | Emitted when a new proposal is created. |
| `Voted` | `id: u64`<br>`voter: AccountId`<br>`vote: bool` | Emitted when someone votes. |

### Error Codes

| Error | Description |
|-------|-------------|
| `Unauthorised` | Caller is not the admin (for `create_proposal`). |
| `AlreadyVoted` | Account has already voted on this proposal. |
| `NotFound` | Proposal ID does not exist. |
| `Inactive` | Proposal is no longer active. |

### Proposal Structure

```rust
pub struct Proposal {
    description: String,    // Proposal text (e.g., "Change Metformin dose to 1000mg")
    votes_for: u64,        // Number of "for" votes
    votes_against: u64,    // Number of "against" votes
    active: bool,          // Whether proposal is still active
}
```

---

## 📡 Events Reference

### All Events Summary

| Contract | Event | Fields | When Emitted |
|----------|-------|--------|--------------|
| **CareSpace** | `PluginInstalled` | `name`, `account` | Plugin installed |
| **Health-SBT** | `Minted` | `to`, `metadata` | SBT minted |
| **CareTreasury** | `Deposited` | `from`, `amount` | Funds deposited |
| **CareTreasury** | `YieldPaid` | `to`, `amount` | Yield claimed |
| **MedReminder** | `MedTaken` | `med_id`, `timestamp` | Medication check-in |
| **ZKCamera** | `ProofSubmitted` | `patient`, `timestamp` | zk-proof submitted |
| **StepCounter** | `StepsRecorded` | `patient`, `steps`, `date` | Steps recorded |
| **Governance** | `ProposalCreated` | `id`, `description` | Proposal created |
| **Governance** | `Voted` | `id`, `voter`, `vote` | Vote cast |

### Listening to Events

Using Polkadot.js API:

```typescript
const contract = await api.query.contracts.contractInfoOf(contractAddress);
// Listen to events
api.query.system.events((events) => {
  events.forEach((record) => {
    const { event } = record;
    if (event.section === 'contracts') {
      // Handle contract event
    }
  });
});
```

---

## ⚠️ Error Codes

### Common Errors Across Contracts

| Error | Contract(s) | Description |
|-------|-------------|-------------|
| `Unauthorised` | All | Caller does not have permission |
| `NotFound` | Governance | Resource does not exist |
| `AlreadyExists` | Health-SBT | Resource already exists |
| `ZeroClaim` | CareTreasury | No balance to claim |
| `TransferFailed` | CareTreasury | Transfer operation failed |
| `AlreadyVoted` | Governance | Account already voted |
| `Inactive` | Governance | Proposal is inactive |

---

## 🔗 Contract Interaction Examples

### Complete Patient Journey

See [README.md](./README.md#example-patient-journey-on-chain-only) for a complete on-chain sequence example.

### Quick Examples

#### Mint Health-SBT
```rust
health_sbt::mint(patient_account, r#"{"diagnosis": "Type-2"}"#)
```

#### Check-in Medication
```rust
med_reminder::check_in(1712345678) // Unix timestamp
```

#### Submit zk-Proof
```rust
zk_camera::submit_proof(patient_account, proof_bytes, timestamp)
```

#### Deposit to Treasury
```rust
care_treasury::deposit() // With value attached
```

#### Distribute Yield
```rust
care_treasury::distribute_yield([patient1, patient2, patient3])
```

#### Claim Yield
```rust
care_treasury::claim()
```

#### Create Governance Proposal
```rust
governance::create_proposal("Change medication dose to 1000mg")
```

#### Vote on Proposal
```rust
governance::vote(proposal_id, true) // true = for, false = against
```

---

## 📝 Notes

- All timestamps are Unix timestamps (seconds since epoch)
- All amounts are in native token units (e.g., DOT, SBY)
- `AccountId` is a 32-byte Substrate account identifier
- `String` is UTF-8 encoded
- `Vec<u8>` is a byte array
- All contracts use ink! 4.2

---

**For deployment instructions, see [README.md](./README.md#quick-start)**

