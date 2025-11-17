# 📸 Smart Contract Screenshots

This directory should contain screenshots demonstrating the ChainCARE Protocol smart contracts deployed and running on Polkadot testnets.

## 📋 Required Screenshots

### 1. Contract Deployment
- Screenshot of contract instantiation on Polkadot.js Apps
- Shows contract address and deployment transaction

### 2. Health-SBT Minting
- Screenshot showing `mint()` transaction
- Event emission: `Minted { to, metadata }`
- Transaction hash visible

### 3. Medication Reminder Check-in
- Screenshot of `MedReminder::check_in()` call
- Event: `MedTaken { med_id, timestamp }`
- Shows successful transaction

### 4. zk-Proof Submission
- Screenshot of `ZKCamera::submit_proof()` transaction
- Event: `ProofSubmitted { patient, timestamp }`
- Proof verification status

### 5. Treasury Operations
- Screenshot of `CareTreasury::deposit()` transaction
- Screenshot of `CareTreasury::distribute_yield()` call
- Screenshot of `CareTreasury::claim()` with yield transfer
- Event: `YieldPaid { to, amount }`

### 6. Governance Voting
- Screenshot of `Governance::create_proposal()` transaction
- Screenshot of `Governance::vote()` calls
- Event: `Voted { id, voter, vote }`
- Proposal status display

### 7. Step Counter Oracle
- Screenshot of `StepCounter::submit_oracle()` transaction
- Event: `StepsRecorded { patient, steps, date }`
- Shows oracle signature verification

### 8. Dashboard Integration
- Screenshot of frontend showing on-chain data
- Real-time event updates
- Patient compliance dashboard

## 🎯 How to Take Screenshots

### Using Polkadot.js Apps

1. Navigate to deployed contract on [Polkadot.js Apps](https://polkadot.js.org/apps)
2. Connect wallet (Polkadot.js Extension)
3. Execute contract message
4. Wait for transaction confirmation
5. Take screenshot showing:
   - Transaction hash
   - Events emitted
   - Contract state changes
   - Gas fees

### Using Block Explorer

1. Open transaction on [Subscan](https://subscan.io) or [Polkaholic](https://polkaholic.io)
2. Screenshot showing:
   - Transaction details
   - Events log
   - Contract interaction
   - Status: Success ✅

## 📝 Screenshot Naming Convention

```
<contract_name>_<function_name>_<network>_<date>.png

Examples:
- health_sbt_mint_paseo_20241201.png
- med_reminder_check_in_shibuya_20241201.png
- care_treasury_claim_paseo_20241201.png
- governance_vote_paseo_20241201.png
```

## 🔗 Testnet Links

### Paseo Testnet
- **Polkadot.js Apps**: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.ibp.network%2Fpaseo#/contracts
- **Explorer**: Polkaholic (if available)

### Astar Shibuya
- **Polkadot.js Apps**: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.shibuya.astar.network#/contracts
- **Explorer**: https://shibuya.subscan.io

### Polkadot Testnet
- **Polkadot.js Apps**: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.polkadot.io#/contracts
- **Explorer**: https://polkadot.subscan.io

## ✅ Checklist

Before submission, ensure you have:

- [ ] Contract deployment screenshots (all contracts)
- [ ] At least one transaction screenshot per contract
- [ ] Event emission visible in screenshots
- [ ] Transaction hash visible
- [ ] Network name visible (Paseo/Shibuya/Polkadot)
- [ ] Frontend integration screenshots
- [ ] Dashboard showing on-chain data

## 📤 Adding Screenshots

1. Take screenshots using the methods above
2. Save with proper naming convention
3. Add to this directory
4. Update this README with actual screenshot filenames

---

**Note**: Screenshots should be high-quality (at least 1920x1080) and clearly show all relevant information.

