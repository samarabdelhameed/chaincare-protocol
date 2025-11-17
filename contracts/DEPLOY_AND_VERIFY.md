# 🚀 خطة النشر والتحقق والاختبار الكاملة

## 📋 العنوان: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`

---

## ✅ المرحلة 1: النشر (Deploy)

### الخطوات:

1. **أضيفي MNEMONIC إلى `.env`**:
   ```bash
   cd contracts
   # افتحي .env وأضيفي:
   MNEMONIC=your twelve word mnemonic phrase here
   ```

2. **تأكدي من وجود DOT Testnet tokens**:
   - افتحي: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.polkadot.io#/accounts
   - تأكدي من وجود 0.1 DOT على الأقل

3. **ابدئي النشر بالترتيب**:

### B1. نشر `health_sbt` (أولاً)

```bash
cd contracts/health_sbt
source ../.env
cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$HEALTH_SBT_ADMIN" \
  --gas "$GAS_LIMIT" \
  --skip-confirm
```

**انسخي:**
- Contract Address (مثلاً: `5Go...health_sbt`)
- Extrinsic Hash (مثلاً: `0x123...abc`)

---

### B2. نشر `care_treasury`

```bash
cd ../care_treasury
source ../.env
cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$TREASURY_ADMIN" "$TREASURY_DAILY_RATE" \
  --gas "$GAS_LIMIT" \
  --skip-confirm
```

---

### B3. نشر `care_space` (يحتاج health_sbt + treasury)

```bash
cd ../care_space
source ../.env
cargo contract instantiate \
  --url "$RPC_URL" \
  --suri "$MNEMONIC" \
  --constructor new \
  --args "$CARE_SPACE_OWNER" "$CARE_SPACE_NAME" "$CARE_SPACE_PATIENT" "$TREASURY" "$HEALTH_SBT" \
  --gas "$GAS_LIMIT" \
  --skip-confirm
```

**استبدلي:**
- `$TREASURY` → عنوان care_treasury من B2
- `$HEALTH_SBT` → عنوان health_sbt من B1

---

### B4-B7. نشر باقي العقود

```bash
# med_reminder
cd ../plugins/med_reminder
source ../../.env
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$MED_REMINDER_MED_ID" --gas "$GAS_LIMIT" --skip-confirm

# step_counter
cd ../step_counter
source ../../.env
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$STEP_COUNTER_ADMIN" "$STEP_COUNTER_DAILY_TARGET" --gas "$GAS_LIMIT" --skip-confirm

# zk_camera
cd ../zk_camera
source ../../.env
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$ZK_CAMERA_ADMIN" --gas "$GAS_LIMIT" --skip-confirm

# governance
cd ../governance
source ../../.env
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$GOVERNANCE_ADMIN" --gas "$GAS_LIMIT" --skip-confirm
```

---

## ✅ المرحلة 2: التحقق (Verify) على Subscan

بعد كل `instantiate`:

1. **انسخي Extrinsic Hash** من النتيجة
2. **افتحي Subscan**: https://polkadot.subscan.io/extrinsic/EXTRINSIC_HASH
3. **ابحثي عن event `contracts.Instantiated`** → انسخي **Contract Address**
4. **اضغطي على العنوان** → صفحة الـ contract
5. **اضغطي "Verify & Publish"**:
   - **Runtime**: ink! 5.0
   - **Upload**: `contracts/target/ink/CONTRACT_NAME/CONTRACT_NAME.contract`
   - **اضغطي Verify**

**✅ Verified** = نجح التحقق

---

## ✅ المرحلة 3: الاختبار (Test Functions)

بعد النشر والتحقق، اختبري كل function:

### T1. اختبار `health_sbt`

```bash
# Mint SBT
cargo contract call \
  --url "$RPC_URL" \
  --contract HEALTH_SBT_ADDRESS \
  --message mint \
  --args PATIENT_ADDRESS "Health Level 5" \
  --suri "$MNEMONIC" \
  --gas "$GAS_LIMIT" \
  --skip-confirm

# Get metadata
cargo contract call \
  --url "$RPC_URL" \
  --contract HEALTH_SBT_ADDRESS \
  --message get_metadata \
  --args PATIENT_ADDRESS \
  --suri "$MNEMONIC" \
  --skip-confirm
```

---

### T2. اختبار `care_treasury`

```bash
# Deposit
cargo contract call \
  --url "$RPC_URL" \
  --contract TREASURY_ADDRESS \
  --message deposit \
  --args 1000000000000 \
  --suri "$MNEMONIC" \
  --gas "$GAS_LIMIT" \
  --skip-confirm

# Get balance
cargo contract call \
  --url "$RPC_URL" \
  --contract TREASURY_ADDRESS \
  --message get_balance \
  --args YOUR_ADDRESS \
  --suri "$MNEMONIC" \
  --skip-confirm
```

---

### T3. اختبار `care_space`

```bash
# Install plugin
cargo contract call \
  --url "$RPC_URL" \
  --contract CARE_SPACE_ADDRESS \
  --message install_plugin \
  --args "med_reminder" MED_REMINDER_ADDRESS \
  --suri "$MNEMONIC" \
  --gas "$GAS_LIMIT" \
  --skip-confirm

# Get plugin
cargo contract call \
  --url "$RPC_URL" \
  --contract CARE_SPACE_ADDRESS \
  --message get_plugin \
  --args "med_reminder" \
  --suri "$MNEMONIC" \
  --skip-confirm
```

---

### T4. اختبار `med_reminder`

```bash
# Check in
cargo contract call \
  --url "$RPC_URL" \
  --contract MED_REMINDER_ADDRESS \
  --message check_in \
  --args $(date +%s) \
  --suri "$MNEMONIC" \
  --gas "$GAS_LIMIT" \
  --skip-confirm

# Get last taken
cargo contract call \
  --url "$RPC_URL" \
  --contract MED_REMINDER_ADDRESS \
  --message last_taken \
  --suri "$MNEMONIC" \
  --skip-confirm
```

---

### T5. اختبار `step_counter`

```bash
# Record steps
cargo contract call \
  --url "$RPC_URL" \
  --contract STEP_COUNTER_ADDRESS \
  --message record_steps \
  --args PATIENT_ADDRESS 8500 \
  --suri "$MNEMONIC" \
  --gas "$GAS_LIMIT" \
  --skip-confirm

# Get steps
cargo contract call \
  --url "$RPC_URL" \
  --contract STEP_COUNTER_ADDRESS \
  --message get_steps \
  --args PATIENT_ADDRESS \
  --suri "$MNEMONIC" \
  --skip-confirm
```

---

### T6. اختبار `governance`

```bash
# Create proposal
cargo contract call \
  --url "$RPC_URL" \
  --contract GOVERNANCE_ADDRESS \
  --message create_proposal \
  --args "Increase daily rate to 25" \
  --suri "$MNEMONIC" \
  --gas "$GAS_LIMIT" \
  --skip-confirm

# Vote
cargo contract call \
  --url "$RPC_URL" \
  --contract GOVERNANCE_ADDRESS \
  --message vote \
  --args 0 true \
  --suri "$MNEMONIC" \
  --gas "$GAS_LIMIT" \
  --skip-confirm
```

---

## 📝 جمع العناوين

بعد النشر، املئي `frontend/src/addresses.polkadot-testnet.json`:

```json
{
  "careSpace": "5Go...care_space",
  "healthSbt": "5Go...health_sbt",
  "treasury": "5Go...care_treasury",
  "medReminder": "5Go...med_reminder",
  "stepCounter": "5Go...step_counter",
  "zkCamera": "5Go...zk_camera",
  "governance": "5Go...governance"
}
```

---

## 🧪 Checklist لكل Contract:

- [ ] ✅ Deployed (instantiate success)
- [ ] ✅ Verified on Subscan
- [ ] ✅ Tested all functions
- [ ] ✅ Address saved in addresses.polkadot-testnet.json

---

**ابدئي بـ `health_sbt` وابعتي "تمام" بعد كل خطوة!** 🚀

