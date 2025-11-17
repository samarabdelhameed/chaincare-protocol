# 🚀 Quick Start Guide - ChainCARE Protocol

## Run All Project Components

To run all project components (Frontend + Oracle) in one file:

```bash
./start.sh
```

This script will:
- ✅ Check prerequisites (Node.js, Python, Rust)
- ✅ Install dependencies automatically if not present
- ✅ Start Frontend on http://localhost:3000
- ✅ Start Oracle (if Python is available and configured)

## Stop All Services

```bash
./stop.sh
```

Or press `Ctrl+C` in the terminal running `start.sh`

## Components

### Frontend
- **Path**: `frontend/`
- **Port**: `3000` (default Vite)
- **Logs**: `logs/frontend.log`

### Oracle
- **Path**: `oracle/`
- **Requirements**: Python 3.8+ and `substrate-interface`, `bleak`
- **Logs**: `logs/oracle.log`
- **Note**: Requires `RPC_URL` and `MNEMONIC` environment variables or `oracle/config.json` file

## Prerequisites

- **Node.js**: v18+ (for Frontend)
- **npm**: (comes with Node.js)
- **Python 3.8+**: (optional - for Oracle)
- **Rust/Cargo**: (optional - for building contracts)

## Troubleshooting

### Frontend Not Working
```bash
cd frontend
npm install
npm run dev
```

### Oracle Not Working
```bash
cd oracle
pip3 install -r requirements.txt
# Make sure RPC_URL and MNEMONIC are configured
python3 oracle.py
```

### View Logs
```bash
# Frontend
tail -f logs/frontend.log

# Oracle
tail -f logs/oracle.log
```

## Notes

- All processes run in the background
- `.chaincare_pids` file contains process IDs
- You can stop all services using `./stop.sh`
