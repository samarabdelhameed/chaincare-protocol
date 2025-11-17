# 🚀 نشر العقود باستخدام Polkadot.js Apps (بدون MNEMONIC)

## ✅ الطريقة الأسهل: استخدام Polkadot.js Apps

### الخطوة 1: افتحي Polkadot.js Apps

افتحي: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Frpc.polkadot.io#/contracts

### الخطوة 2: اتصل بالحساب

1. اضغطي على أيقونة Extension في المتصفح
2. اختر حسابك: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`
3. تأكدي من أن الحساب متصل

### الخطوة 3: ارفعي ونشري العقود

لكل contract:

1. اضغطي **"Upload & deploy code"**
2. ارفعي ملف `.contract` من:
   - `contracts/target/ink/CONTRACT_NAME/CONTRACT_NAME.contract`
3. املئي الـ constructor arguments
4. اضغطي **"Deploy"**
5. وقعي الـ transaction من الـ extension

---

## 📋 Constructor Arguments لكل Contract:

### health_sbt:
- `owner`: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`

### care_treasury:
- `admin`: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`
- `daily_rate`: `20`

### care_space:
- `owner`: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`
- `name`: `CareSpace#1`
- `patient`: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`
- `treasury`: (عنوان care_treasury بعد نشره)
- `sbt`: (عنوان health_sbt بعد نشره)

### med_reminder:
- `med_id`: `med_001`

### step_counter:
- `admin`: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`
- `daily_target`: `10000`

### zk_camera:
- `admin`: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`

### governance:
- `admin`: `5HjLppYRLJ1jjRT4JHhg5FnDvPRtwxcFUvLqQ34iwGuFPayN`

---

## ✅ بعد النشر:

1. انسخي **Contract Address** من كل contract
2. احفظيها في `frontend/src/addresses.polkadot-testnet.json`
3. تحققي على Subscan (اضغطي على العنوان → Verify)

---

**هذه الطريقة أسهل ولا تحتاج MNEMONIC!** 🎉


