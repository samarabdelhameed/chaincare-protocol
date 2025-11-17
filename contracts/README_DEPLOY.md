# 🚀 دليل النشر الكامل - ChainCARE Contracts

## ⚠️ خطوة مهمة قبل البدء:

**أضيفي MNEMONIC إلى ملف `.env`:**

```bash
cd contracts
# افتحي .env وأضيفي في النهاية:
MNEMONIC=your twelve word mnemonic phrase here
```

---

## 🎯 الطريقة السريعة (كل شيء تلقائي):

```bash
cd contracts
./deploy-all.sh
```

هذا السكريبت سينشر جميع العقود تلقائياً ويحفظ العناوين في `frontend/src/addresses.polkadot-testnet.json`

---

## 📋 الطريقة اليدوية (خطوة بخطوة):

### 1. تأكدي من وجود DOT Testnet tokens:
- افتحي: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.polkadot.io#/accounts
- تأكدي من وجود 0.1 DOT على الأقل

### 2. ابدئي النشر:

```bash
cd contracts
source .env

# 1. health_sbt
cd health_sbt
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$HEALTH_SBT_ADMIN" --gas "$GAS_LIMIT" --skip-confirm
# انسخي Contract Address و Extrinsic Hash
cd ..

# 2. care_treasury
cd care_treasury
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$TREASURY_ADMIN" "$TREASURY_DAILY_RATE" --gas "$GAS_LIMIT" --skip-confirm
# انسخي Contract Address و Extrinsic Hash
cd ..

# 3. care_space (يحتاج health_sbt + treasury)
cd care_space
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$CARE_SPACE_OWNER" "$CARE_SPACE_NAME" "$CARE_SPACE_PATIENT" "TREASURY_ADDRESS" "HEALTH_SBT_ADDRESS" --gas "$GAS_LIMIT" --skip-confirm
# استبدلي TREASURY_ADDRESS و HEALTH_SBT_ADDRESS بالعناوين من الخطوات السابقة
cd ..

# 4. med_reminder
cd plugins/med_reminder
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$MED_REMINDER_MED_ID" --gas "$GAS_LIMIT" --skip-confirm
cd ../..

# 5. step_counter
cd plugins/step_counter
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$STEP_COUNTER_ADMIN" "$STEP_COUNTER_DAILY_TARGET" --gas "$GAS_LIMIT" --skip-confirm
cd ../..

# 6. zk_camera
cd plugins/zk_camera
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$ZK_CAMERA_ADMIN" --gas "$GAS_LIMIT" --skip-confirm
cd ../..

# 7. governance
cd plugins/governance
cargo contract instantiate --url "$RPC_URL" --suri "$MNEMONIC" --constructor new --args "$GOVERNANCE_ADMIN" --gas "$GAS_LIMIT" --skip-confirm
cd ../..
```

---

## ✅ التحقق على Subscan:

بعد كل contract:

1. انسخي **Extrinsic Hash** من النتيجة
2. افتحي: https://polkadot.subscan.io/extrinsic/EXTRINSIC_HASH
3. ابحثي عن event `contracts.Instantiated` → انسخي **Contract Address**
4. اضغطي على العنوان → صفحة الـ contract
5. اضغطي **"Verify & Publish"**:
   - **Runtime**: ink! 5.0
   - **Upload**: `contracts/target/ink/CONTRACT_NAME/CONTRACT_NAME.contract`
   - **اضغطي Verify**

---

## 🧪 اختبار الـ Functions:

بعد النشر، اختبري كل contract:

```bash
cd contracts
./test-contracts.sh
```

أو يدوياً:

```bash
# Test health_sbt - Mint
cargo contract call --url "$RPC_URL" --contract HEALTH_SBT_ADDRESS --message mint --args "$ADDRESS" "Health Level 5" --suri "$MNEMONIC" --gas "$GAS_LIMIT" --skip-confirm

# Test health_sbt - Get metadata
cargo contract call --url "$RPC_URL" --contract HEALTH_SBT_ADDRESS --message get_metadata --args "$ADDRESS" --suri "$MNEMONIC" --skip-confirm

# Test med_reminder - Check in
cargo contract call --url "$RPC_URL" --contract MED_REMINDER_ADDRESS --message check_in --args $(date +%s) --suri "$MNEMONIC" --gas "$GAS_LIMIT" --skip-confirm

# Test step_counter - Record steps
cargo contract call --url "$RPC_URL" --contract STEP_COUNTER_ADDRESS --message record_steps --args "$ADDRESS" 8500 --suri "$MNEMONIC" --gas "$GAS_LIMIT" --skip-confirm
```

---

## 📝 حفظ العناوين:

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

**ملاحظة:** السكريبت `deploy-all.sh` يحفظ العناوين تلقائياً!

---

## ✅ Checklist:

- [ ] MNEMONIC مضاف في `.env`
- [ ] DOT Testnet tokens موجودة
- [ ] جميع العقود منشورة
- [ ] جميع العقود verified على Subscan
- [ ] جميع الـ functions مختبرة
- [ ] العناوين محفوظة في `addresses.polkadot-testnet.json`

---

**ابدئي الآن: أضيفي MNEMONIC ثم شغلي `./deploy-all.sh`** 🚀

