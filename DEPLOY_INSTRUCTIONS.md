# 🚀 تعليمات نشر العقود على Astar Shibuya Testnet

## 📋 المتطلبات

1. حساب على Shibuya مع SBY tokens (من [Faucet](https://faucet.astar.network/))
2. `cargo-contract` مثبت
3. جميع العقود مبنية (`cargo contract build`)

---

## 🔑 الخطوة A: التحضير

### A1. إنشاء حساب على Shibuya
- افتحي: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.shibuya.astar.network#/accounts
- أنشئي حساب جديد واحفظي الـ **mnemonic**
- انسخي الـ **Address** (مثلاً: `5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY`)

### A2. الحصول على SBY tokens
- افتحي: https://faucet.astar.network/
- اختاري **Shibuya** → أدخلي الـ address → اطلبي **50 SBY**

---

## 📝 الخطوة B: نشر العقود (بالترتيب)

### B1. نشر `health_sbt` (أولاً - مطلوب للعقود الأخرى)

```bash
cd contracts/health_sbt
cargo contract instantiate \
  --url wss://rpc.shibuya.astar.network \
  --suri "YOUR_MNEMONIC_HERE" \
  --constructor new \
  --args YOUR_ADDRESS \
  --gas 1000000000000 \
  --skip-confirm
```

**انسخي Contract Address** من النتيجة (مثلاً: `5Go...health_sbt`)

---

### B2. نشر `care_treasury`

```bash
cd ../care_treasury
cargo contract instantiate \
  --url wss://rpc.shibuya.astar.network \
  --suri "YOUR_MNEMONIC_HERE" \
  --constructor new \
  --args YOUR_ADDRESS 20 \
  --gas 1000000000000 \
  --skip-confirm
```

**ملاحظة:** `20` = daily_rate (0.002% يومياً)

---

### B3. نشر `care_space` (يحتاج health_sbt و treasury)

```bash
cd ../care_space
cargo contract instantiate \
  --url wss://rpc.shibuya.astar.network \
  --suri "YOUR_MNEMONIC_HERE" \
  --constructor new \
  --args YOUR_ADDRESS "CareSpace#1" YOUR_ADDRESS TREASURY_ADDRESS HEALTH_SBT_ADDRESS \
  --gas 1000000000000 \
  --skip-confirm
```

**استبدلي:**
- `TREASURY_ADDRESS` → عنوان care_treasury من B2
- `HEALTH_SBT_ADDRESS` → عنوان health_sbt من B1

---

### B4. نشر `med_reminder`

```bash
cd ../plugins/med_reminder
cargo contract instantiate \
  --url wss://rpc.shibuya.astar.network \
  --suri "YOUR_MNEMONIC_HERE" \
  --constructor new \
  --args "med_001" \
  --gas 1000000000000 \
  --skip-confirm
```

---

### B5. نشر `step_counter`

```bash
cd ../step_counter
cargo contract instantiate \
  --url wss://rpc.shibuya.astar.network \
  --suri "YOUR_MNEMONIC_HERE" \
  --constructor new \
  --args YOUR_ADDRESS 10000 \
  --gas 1000000000000 \
  --skip-confirm
```

**ملاحظة:** `10000` = daily_target (عدد الخطوات اليومي)

---

### B6. نشر `zk_camera`

```bash
cd ../zk_camera
cargo contract instantiate \
  --url wss://rpc.shibuya.astar.network \
  --suri "YOUR_MNEMONIC_HERE" \
  --constructor new \
  --args YOUR_ADDRESS \
  --gas 1000000000000 \
  --skip-confirm
```

---

### B7. نشر `governance`

```bash
cd ../governance
cargo contract instantiate \
  --url wss://rpc.shibuya.astar.network \
  --suri "YOUR_MNEMONIC_HERE" \
  --constructor new \
  --args YOUR_ADDRESS \
  --gas 1000000000000 \
  --skip-confirm
```

---

## ✅ الخطوة C: التحقق على Subscan

بعد كل `instantiate`:
1. انسخي **extrinsic hash** من النتيجة (مثلاً: `0x123...abc`)
2. افتحي: https://shibuya.subscan.io/extrinsic/0x123...abc
3. ابحثي عن event `contracts.Instantiated` → انسخي **Contract Address**
4. اضغطي على العنوان → صفحة الـ contract
5. اضغطي **"Verify & Publish"**:
   - **Runtime**: ink! 5.0
   - **Upload**: ملف `.contract` من `contracts/target/ink/CONTRACT_NAME/CONTRACT_NAME.contract`
   - اضغطي **Verify**

---

## 📝 الخطوة D: جمع العناوين

بعد نشر كل contract، املئي ملف `frontend/src/addresses.shibuya.json`:

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

## 🧪 بعد كل contract:

**ابعتي "تمام" + 3 screenshots:**
1. ✅ Terminal بعد الأمر (instantiate success)
2. ✅ صفحة Subscan للـ contract (✅ Verified)
3. ✅ العنوان مكتوب في `addresses.shibuya.json`

---

**ابدئي بـ `health_sbt` وابعتي "تمام" لما تخلصيه!** 🚀

