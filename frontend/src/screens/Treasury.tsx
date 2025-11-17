import { motion } from 'framer-motion';
import { Coins, TrendingUp, Gift, ArrowLeft, DollarSign } from 'lucide-react';
import { useState } from 'react';
import { GlassCard3D } from '../components/GlassCard3D';
import { NeonButton } from '../components/NeonButton';
import { useTxn } from '../contexts/TxnContext';

interface TreasuryProps {
  onBack: () => void;
}

export function Treasury({ onBack }: TreasuryProps) {
  const [balance] = useState(1234.56);
  const [pendingRewards] = useState(89.23);
  const { showTxn } = useTxn();

  const handleClaim = async () => {
    showTxn('pending', 'Claiming your rewards...');
    await new Promise(resolve => setTimeout(resolve, 2000));

    const success = Math.random() > 0.2;
    if (success) {
      showTxn(
        'success',
        `Successfully claimed ${pendingRewards} DOT!`,
        '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef'
      );
    } else {
      showTxn('error', 'Failed to claim rewards. Please try again.');
    }
  };

  const rewardHistory = [
    { id: '1', type: 'Step Goal', amount: 50, date: '2 hours ago' },
    { id: '2', type: 'Med Adherence', amount: 75, date: '1 day ago' },
    { id: '3', type: 'Weekly Streak', amount: 100, date: '3 days ago' },
    { id: '4', type: 'zk-Proof Submit', amount: 25, date: '5 days ago' },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#0F0F1A] via-[#1A1A2E] to-[#0F0F1A] p-6">
      <div className="max-w-4xl mx-auto">
        <motion.button
          className="flex items-center gap-2 text-white/60 hover:text-white mb-6 transition-colors"
          onClick={onBack}
          whileHover={{ x: -5 }}
        >
          <ArrowLeft size={20} />
          Back to Dashboard
        </motion.button>

        <motion.div
          className="mb-8"
          initial={{ y: -20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
        >
          <h1 className="text-4xl font-bold gradient-text mb-2">
            Treasury
          </h1>
          <p className="text-white/60">Manage your health rewards and earnings</p>
        </motion.div>

        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ type: 'spring', stiffness: 100 }}
          className="mb-8"
        >
          <GlassCard3D className="bg-gradient-to-br from-[#FFD600]/20 to-[#00F5A0]/20 text-center py-12">
            <motion.div
              className="inline-flex items-center justify-center w-24 h-24 rounded-full bg-gradient-to-br from-[#FFD600] to-[#00F5A0] mb-6"
              animate={{
                scale: [1, 1.1, 1],
                rotateY: [0, 360],
              }}
              transition={{
                scale: { duration: 2, repeat: Infinity },
                rotateY: { duration: 3, repeat: Infinity, ease: 'linear' },
              }}
              style={{ transformStyle: 'preserve-3d' }}
            >
              <Coins size={48} className="text-white" />
            </motion.div>

            <h2 className="text-6xl font-bold gradient-text mono mb-2">
              {balance.toFixed(2)}
            </h2>
            <p className="text-white/60 text-xl">DOT Balance</p>

            <div className="flex items-center justify-center gap-2 mt-4">
              <TrendingUp className="text-[#00F5A0]" size={20} />
              <span className="text-[#00F5A0] font-semibold">
                +12.5% this week
              </span>
            </div>
          </GlassCard3D>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <GlassCard3D className="bg-gradient-to-br from-[#00F5A0]/10 to-transparent">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-xl font-bold text-white">Pending Rewards</h3>
              <Gift className="text-[#FFD600]" size={24} />
            </div>

            <div className="text-4xl font-bold text-[#FFD600] mono mb-4">
              {pendingRewards.toFixed(2)} DOT
            </div>

            <NeonButton
              onClick={handleClaim}
              variant="success"
              className="w-full"
            >
              Claim Rewards
            </NeonButton>
          </GlassCard3D>

          <GlassCard3D>
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-white/60">Total Earned</span>
                <span className="font-bold text-white mono">2,567.89 DOT</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-white/60">Rewards Claimed</span>
                <span className="font-bold text-[#00F5A0] mono">1,234.56 DOT</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-white/60">Weekly Avg</span>
                <span className="font-bold text-[#FFD600] mono">156.78 DOT</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-white/60">Yield Rate</span>
                <span className="font-bold text-white mono">8.5% APY</span>
              </div>
            </div>
          </GlassCard3D>
        </div>

        <motion.div
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.3 }}
        >
          <GlassCard3D>
            <h3 className="text-xl font-bold text-white mb-6 flex items-center gap-2">
              <DollarSign className="text-[#FFD600]" />
              Reward History
            </h3>

            <div className="space-y-4">
              {rewardHistory.map((reward, index) => (
                <motion.div
                  key={reward.id}
                  className="flex items-center justify-between p-4 rounded-xl glass-morphism"
                  initial={{ x: -20, opacity: 0 }}
                  animate={{ x: 0, opacity: 1 }}
                  transition={{ delay: index * 0.1 }}
                  whileHover={{ scale: 1.02 }}
                >
                  <div className="flex items-center gap-4">
                    <motion.div
                      className="w-12 h-12 rounded-xl bg-gradient-to-br from-[#00F5A0] to-[#FFD600] flex items-center justify-center"
                      animate={{ rotateY: [0, 180, 360] }}
                      transition={{ duration: 3, repeat: Infinity, delay: index * 0.3 }}
                      style={{ transformStyle: 'preserve-3d' }}
                    >
                      <Coins size={24} className="text-white" />
                    </motion.div>

                    <div>
                      <h4 className="font-semibold text-white">{reward.type}</h4>
                      <p className="text-white/60 text-sm">{reward.date}</p>
                    </div>
                  </div>

                  <div className="text-right">
                    <div className="text-xl font-bold text-[#00F5A0] mono">
                      +{reward.amount}
                    </div>
                    <div className="text-white/60 text-sm">DOT</div>
                  </div>
                </motion.div>
              ))}
            </div>
          </GlassCard3D>
        </motion.div>

        <motion.div
          className="mt-6"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5 }}
        >
          <GlassCard3D className="bg-gradient-to-br from-[#FF00E5]/10 to-[#00F5A0]/10">
            <div className="flex items-center gap-4">
              <TrendingUp className="text-[#00F5A0]" size={32} />
              <div className="flex-1">
                <h3 className="font-bold text-white mb-1">Staking Available</h3>
                <p className="text-white/60 text-sm">
                  Stake your DOT to earn additional yield rewards
                </p>
              </div>
              <NeonButton variant="secondary" className="text-sm py-2 px-6">
                Stake Now
              </NeonButton>
            </div>
          </GlassCard3D>
        </motion.div>
      </div>
    </div>
  );
}
