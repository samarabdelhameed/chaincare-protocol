import { motion } from 'framer-motion';
import { Wallet, ArrowRight, Shield } from 'lucide-react';
import { useState } from 'react';
import { NeonButton } from '../components/NeonButton';
import { GlassCard3D } from '../components/GlassCard3D';
import { web3Accounts, web3Enable, web3FromAddress } from '@polkadot/extension-dapp';

interface WalletConnectProps {
  onConnect: (address: string, signer: any) => void;
}

export function WalletConnect({ onConnect }: WalletConnectProps) {
  const [error, setError] = useState<string>('');

  const handleConnect = async () => {
    try {
      setError('');

      const extensions = await web3Enable('ChainCARE');

      if (extensions.length === 0) {
        setError('Please install Polkadot.js extension');
        window.open('https://polkadot.js.org/extension/', '_blank');
        return;
      }

      const accounts = await web3Accounts();

      if (accounts.length === 0) {
        setError('No accounts found. Please create an account in Polkadot.js extension');
        return;
      }

      const account = accounts[0];
      const injector = await web3FromAddress(account.address);

      onConnect(account.address, injector.signer);
    } catch (err) {
      setError('Failed to connect wallet. Please try again.');
      console.error(err);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-6 bg-gradient-to-br from-[#0F0F1A] via-[#1A1A2E] to-[#0F0F1A]">
      <motion.div
        className="w-full max-w-md"
        initial={{ opacity: 0, y: 50 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <GlassCard3D className="text-center">
          <motion.div
            className="mx-auto w-24 h-24 rounded-full bg-gradient-to-br from-[#00F5A0] to-[#FF00E5] flex items-center justify-center mb-6"
            animate={{
              rotateY: [0, 360],
            }}
            transition={{
              duration: 3,
              repeat: Infinity,
              ease: 'linear',
            }}
            style={{ transformStyle: 'preserve-3d' }}
          >
            <Wallet size={40} className="text-white" />
          </motion.div>

          <h1 className="text-4xl font-bold gradient-text mb-4">
            Connect Wallet
          </h1>

          <p className="text-white/60 mb-8">
            Connect your Polkadot wallet to access ChainCARE healthcare platform
          </p>

          <div className="space-y-4 mb-8">
            <div className="flex items-center gap-3 text-left">
              <Shield className="text-[#00F5A0] flex-shrink-0" size={24} />
              <span className="text-white/80">Secure blockchain authentication</span>
            </div>
            <div className="flex items-center gap-3 text-left">
              <Shield className="text-[#00F5A0] flex-shrink-0" size={24} />
              <span className="text-white/80">Privacy-first health data</span>
            </div>
            <div className="flex items-center gap-3 text-left">
              <Shield className="text-[#00F5A0] flex-shrink-0" size={24} />
              <span className="text-white/80">Earn rewards for healthy habits</span>
            </div>
          </div>

          <NeonButton onClick={handleConnect} className="w-full mb-4">
            Connect Polkadot Wallet
            <ArrowRight className="inline-block ml-2" size={20} />
          </NeonButton>

          <NeonButton
            onClick={() => onConnect('5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY', null)}
            variant="secondary"
            className="w-full"
          >
            Continue with Demo Account
          </NeonButton>

          {error && (
            <motion.div
              className="mt-4 p-4 rounded-lg bg-[#FF00E5]/10 border border-[#FF00E5]/30"
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ type: 'spring', stiffness: 300 }}
            >
              <p className="text-[#FF00E5] text-sm">{error}</p>
            </motion.div>
          )}
        </GlassCard3D>

        <motion.p
          className="text-center text-white/40 text-sm mt-6"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5 }}
        >
          Don't have Polkadot.js? Install it from the extension store
        </motion.p>
      </motion.div>
    </div>
  );
}
