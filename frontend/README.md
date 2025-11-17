# 🎨 ChainCARE Frontend

React + TypeScript Progressive Web App (PWA) for ChainCARE Protocol.

## 🚀 Quick Start

```bash
cd frontend
npm install
npm run dev
```

Open `http://localhost:3000`

## 📁 Structure

```
frontend/
├── src/
│   ├── components/      # Reusable UI components
│   │   ├── CircularProgress3D.tsx
│   │   ├── GlassCard3D.tsx
│   │   ├── NeonButton.tsx
│   │   ├── QRGlass.tsx
│   │   ├── SuccessConfetti.tsx
│   │   └── TxnModal.tsx
│   ├── screens/         # Page components
│   │   ├── Dashboard.tsx
│   │   ├── Governance.tsx
│   │   ├── LandingPage.tsx
│   │   ├── MedReminder.tsx
│   │   ├── Onboarding.tsx
│   │   ├── Profile.tsx
│   │   ├── StepCounter.tsx
│   │   ├── Treasury.tsx
│   │   ├── WalletConnect.tsx
│   │   └── ZKCamera.tsx
│   ├── contexts/        # React contexts
│   │   └── TxnContext.tsx
│   └── utils/           # Utilities (Polkadot integration)
├── package.json
└── vite.config.ts
```

## 🛠️ Tech Stack

- **Framework**: React 18 + TypeScript
- **Build Tool**: Vite
- **UI**: TailwindCSS + Framer Motion
- **Blockchain**: Polkadot.js API
- **PWA**: Service Workers (offline support)

## 📱 Features

- ✅ Wallet connection (Polkadot.js Extension)
- ✅ Health-SBT minting
- ✅ Medication reminder with NFC/BLE
- ✅ zk-Proof submission
- ✅ Step counter integration
- ✅ Treasury yield claiming
- ✅ Governance voting
- ✅ Real-time dashboard

## 🔧 Configuration

### Network Configuration

Contract addresses are stored in:
- `src/addresses.paseo.json` - Paseo Testnet
- `src/addresses.shibuya.json` - Astar Shibuya
- `src/addresses.polkadot-testnet.json` - Polkadot Testnet

### Environment Variables

Create `.env` file:
```bash
VITE_WS_URL=wss://rpc.ibp.network/paseo
VITE_NETWORK=paseo
```

## 📦 Build for Production

```bash
npm run build
```

Output: `dist/` directory

## 🧪 Development

```bash
# Start dev server
npm run dev

# Lint
npm run lint

# Type check
npm run type-check
```

## 📱 PWA Features

- Offline support
- Installable on mobile/desktop
- Service worker caching
- Push notifications (future)

## 🔗 Integration

### Polkadot.js Extension

The app requires Polkadot.js Extension for wallet connection:
- Install: [Chrome Extension](https://polkadot.js.org/extension/)
- Connect wallet on first load
- Sign transactions for on-chain operations

### Contract Interaction

All contract interactions use:
- `@polkadot/api` - Substrate RPC client
- `@polkadot/extension-dapp` - Wallet extension integration

## 📝 License

MIT License - See [../LICENSE](../LICENSE)

