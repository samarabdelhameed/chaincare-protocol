# 🚀 دليل التشغيل السريع - ChainCARE Protocol

## تشغيل المشروع بالكامل

لتشغيل جميع مكونات المشروع (Frontend + Oracle) في ملف واحد:

```bash
./start.sh
```

هذا الملف سيقوم بـ:
- ✅ التحقق من المتطلبات (Node.js, Python, Rust)
- ✅ تثبيت dependencies تلقائياً إذا لم تكن موجودة
- ✅ تشغيل Frontend على http://localhost:5173
- ✅ تشغيل Oracle (إذا كان Python متوفراً وتم إعداد الإعدادات)

## إيقاف جميع الخدمات

```bash
./stop.sh
```

أو اضغط `Ctrl+C` في الطرفية التي تشغل `start.sh`

## المكونات

### Frontend
- **المسار**: `frontend/`
- **البورت**: `5173` (افتراضي Vite)
- **اللوجات**: `logs/frontend.log`

### Oracle
- **المسار**: `oracle/`
- **المتطلبات**: Python 3.8+ و `substrate-interface`, `bleak`
- **اللوجات**: `logs/oracle.log`
- **ملاحظة**: يحتاج إعداد `RPC_URL` و `MNEMONIC` كمتغيرات بيئة أو ملف `oracle/config.json`

## المتطلبات

- **Node.js**: v18+ (لـ Frontend)
- **npm**: (يأتي مع Node.js)
- **Python 3.8+**: (اختياري - للـ Oracle)
- **Rust/Cargo**: (اختياري - لبناء العقود)

## استكشاف الأخطاء

### Frontend لا يعمل
```bash
cd frontend
npm install
npm run dev
```

### Oracle لا يعمل
```bash
cd oracle
pip3 install -r requirements.txt
# تأكد من إعداد RPC_URL و MNEMONIC
python3 oracle.py
```

### عرض اللوجات
```bash
# Frontend
tail -f logs/frontend.log

# Oracle
tail -f logs/oracle.log
```

## ملاحظات

- جميع العمليات تعمل في الخلفية (background)
- ملف `.chaincare_pids` يحتوي على معرفات العمليات
- يمكنك إيقاف جميع الخدمات باستخدام `./stop.sh`

