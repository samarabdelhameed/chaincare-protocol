import { useState, useEffect } from 'react';
import { AnimatePresence } from 'framer-motion';
import { TxnProvider } from './contexts/TxnContext';
import { LandingPage } from './screens/LandingPage';
import { SplashScreen } from './screens/SplashScreen';
import { Onboarding } from './screens/Onboarding';
import { WalletConnect } from './screens/WalletConnect';
import { Dashboard } from './screens/Dashboard';
import { MedReminder } from './screens/MedReminder';
import { StepCounter } from './screens/StepCounter';
import { ZKCamera } from './screens/ZKCamera';
import { Treasury } from './screens/Treasury';
import { Governance } from './screens/Governance';
import { Profile } from './screens/Profile';

type Screen =
  | 'landing'
  | 'splash'
  | 'onboarding'
  | 'wallet'
  | 'dashboard'
  | 'meds'
  | 'steps'
  | 'camera'
  | 'treasury'
  | 'governance'
  | 'profile';

function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('landing');
  const [walletAddress, setWalletAddress] = useState<string>('');
  const [walletSigner, setWalletSigner] = useState<any>(null);

  useEffect(() => {
    const saved = localStorage.getItem('chaincare_wallet');
    const visited = localStorage.getItem('chaincare_visited');
    if (saved) {
      setWalletAddress(saved);
      setCurrentScreen('dashboard');
    } else if (visited) {
      setCurrentScreen('splash');
    }
  }, []);

  const handleWalletConnect = (address: string, signer: any) => {
    setWalletAddress(address);
    setWalletSigner(signer);
    localStorage.setItem('chaincare_wallet', address);
    setCurrentScreen('dashboard');
  };

  const handleDisconnect = () => {
    setWalletAddress('');
    setWalletSigner(null);
    localStorage.removeItem('chaincare_wallet');
    setCurrentScreen('wallet');
  };

  const handleNavigate = (screen: string) => {
    setCurrentScreen(screen as Screen);
  };

  const handleBack = () => {
    setCurrentScreen('dashboard');
  };

  return (
    <TxnProvider>
      <div className="min-h-screen bg-[#0F0F1A]">
        <AnimatePresence mode="wait">
          {currentScreen === 'landing' && (
            <LandingPage
              key="landing"
              onGetStarted={() => {
                localStorage.setItem('chaincare_visited', 'true');
                setCurrentScreen('splash');
              }}
            />
          )}

          {currentScreen === 'splash' && (
            <SplashScreen
              key="splash"
              onComplete={() => setCurrentScreen('onboarding')}
            />
          )}

          {currentScreen === 'onboarding' && (
            <Onboarding
              key="onboarding"
              onComplete={() => {
                localStorage.setItem('chaincare_onboarded', 'true');
                setCurrentScreen('wallet');
              }}
            />
          )}

          {currentScreen === 'wallet' && (
            <WalletConnect
              key="wallet"
              onConnect={handleWalletConnect}
            />
          )}

        {currentScreen === 'dashboard' && walletAddress && (
          <Dashboard
            key="dashboard"
            address={walletAddress}
            onNavigate={handleNavigate}
            onDisconnect={handleDisconnect}
          />
        )}

        {currentScreen === 'meds' && (
          <MedReminder
            key="meds"
            onBack={handleBack}
          />
        )}

        {currentScreen === 'steps' && (
          <StepCounter
            key="steps"
            onBack={handleBack}
          />
        )}

        {currentScreen === 'camera' && (
          <ZKCamera
            key="camera"
            onBack={handleBack}
          />
        )}

        {currentScreen === 'treasury' && (
          <Treasury
            key="treasury"
            onBack={handleBack}
          />
        )}

        {currentScreen === 'governance' && (
          <Governance
            key="governance"
            onBack={handleBack}
          />
        )}

        {currentScreen === 'profile' && walletAddress && (
          <Profile
            key="profile"
            address={walletAddress}
            onBack={handleBack}
          />
        )}
        </AnimatePresence>
      </div>
    </TxnProvider>
  );
}

export default App;
