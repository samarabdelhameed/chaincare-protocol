# 🚀 إعداد Paseo Testnet - ChainCARE Protocol

## Paseo Testnet (Official Community Testnet)
**موقع:** https://paseo.io  
**Faucet:** https://faucet.paseo.io  
**RPC:** `wss://ws.paseo.ara.io`

---

## ✅ الخطوة 1: إنشاء ملف `.env`

في مجلد `contracts/` أنشئي ملف `.env` بالضبط بهذا المحتوى:

```bash
# Paseo Testnet (Official Community Testnet)

RPC_URL=wss://ws.paseo.ara.io

MNEMONIC="draw pony want either subject giant join develop problem solution describe trigger"

GAS_LIMIT=1000000000000

VITE_WS_URL=wss://ws.paseo.ara.io

ADDRESS=5EeMfMp8ZaY49ygQZfTBNB5aDtKR88DMDmPXxAL3ZAWVzQy

NETWORK=paseo

HEALTH_SBT_ADMIN=5EeMfMp8ZaY49ygQZfTBNB5aDtKR88DMDmPXxAL3ZAWVzQy
TREASURY_ADMIN=5EeMfMp8ZaY49ygQZfTBNB5aDtKR88DMDmPXxAL3ZAWVzQy
CARE_SPACE_OWNER=5EeMfMp8ZaY49ygQZfTBNB5aDtKR88DMDmPXxAL3ZAWVzQy
CARE_SPACE_PATIENT=5EeMfMp8ZaY49ygQZfTBNB5aDtKR88DMDmPXxAL3ZAWVzQy
CARE_SPACE_NAME="CareSpace#1"
TREASURY_DAILY_RATE=20
MED_REMINDER_MED_ID="med_001"
```

**ملاحظة مهمة:** 
- استبدلي الـ `MNEMONIC` بmnemonic الخاص بك
- استبدلي `ADDRESS` بعنوان المحفظة الخاص بك

---

## ✅ الخطوة 2: الحصول على PAS Tokens

### العنوان المستخدم:
```
5EeMfMp8ZaY49ygQZfTBNB5aDtKR88DMDmPXxAL3ZAWVzQy
```

### الخطوات:
1. افتحي: **https://faucet.paseo.io**
2. أدخلي العنوان أعلاه
3. اطلبي **10 PAS** → تيجي في ثواني

---

## ✅ الخطوة 3: التحقق من الإعداد

### التحقق من ملف `.env`:
```bash
cd contracts
dotenv -- echo $RPC_URL
# يجب أن يطبع: wss://ws.paseo.ara.io
```

### التحقق من الرصيد:
```bash
# من المجلد الرئيسي
./check-balance.sh
```

أو افتحي في المتصفح:
```
https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Fws.paseo.ara.io#/accounts
```

---

## ✅ الخطوة 4: اختبار الاتصال

```bash
cd contracts
source .env
echo "RPC: $RPC_URL"
echo "Address: $ADDRESS"
echo "Network: $NETWORK"
```

---

## 📝 ملاحظات

- **Paseo** هو testnet رسمي مدعوم من Parity والمجتمع
- **RPC سريع**: `wss://ws.paseo.ara.io`
- **Faucet سهل**: https://faucet.paseo.io
- **Token**: PAS (test DOT)

---

## 🔗 روابط مفيدة

- **Paseo Website**: https://paseo.io
- **Faucet**: https://faucet.paseo.io
- **Polkadot.js Apps**: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Fws.paseo.ara.io#/accounts
- **Explorer**: https://paseo.subscan.io (إذا كان متوفر)

---

## ⚠️ تحذيرات

1. **لا ترفعي ملف `.env` للـ Git** - محمي في `.gitignore`
2. **احفظي الـ mnemonic** في مكان آمن
3. **استخدمي testnet فقط** - لا تستخدمي mainnet tokens حقيقية

---

## ✅ بعد التأكد

بعد ما تتأكدي من:
- ✅ ملف `.env` موجود ويحتوي على `RPC_URL=wss://ws.paseo.ara.io`
- ✅ Faucet يعطي PAS tokens بنجاح
- ✅ الأمر `dotenv -- echo $RPC_URL` يطبع القيمة الصحيحة

قولي **"تمام"** وهنكمل باقي الملفات (Scripts, Oracle, ZK) ونبدأ الـ Deploy على Paseo! 🚀

