import { motion } from 'framer-motion';
import { Pill, TrendingUp, Camera, Coins, Vote, User, Activity, LogOut } from 'lucide-react';
import { GlassCard3D } from '../components/GlassCard3D';

interface DashboardProps {
  address: string;
  onNavigate: (screen: string) => void;
  onDisconnect: () => void;
}

export function Dashboard({ address, onNavigate, onDisconnect }: DashboardProps) {
  const quickActions = [
    {
      id: 'meds',
      icon: Pill,
      title: 'Med Reminder',
      description: 'Track medications',
      color: '#00F5A0',
      gradient: 'from-[#00F5A0] to-[#00C782]',
    },
    {
      id: 'steps',
      icon: TrendingUp,
      title: 'Step Counter',
      description: 'Daily activity',
      color: '#FFD600',
      gradient: 'from-[#FFD600] to-[#FFA500]',
    },
    {
      id: 'camera',
      icon: Camera,
      title: 'zk-Camera',
      description: 'Privacy proof',
      color: '#FF00E5',
      gradient: 'from-[#FF00E5] to-[#C700B3]',
    },
    {
      id: 'treasury',
      icon: Coins,
      title: 'Treasury',
      description: 'Claim rewards',
      color: '#00F5A0',
      gradient: 'from-[#FFD600] to-[#00F5A0]',
    },
  ];

  const stats = [
    { label: 'Health Score', value: '87', unit: '%' },
    { label: 'Rewards Earned', value: '1,234', unit: 'DOT' },
    { label: 'Days Active', value: '45', unit: 'days' },
  ];

  return (
    <motion.div
      className="min-h-screen bg-gradient-to-br from-[#0F0F1A] via-[#1A1A2E] to-[#0F0F1A] p-6"
      initial={{ x: 0 }}
      exit={{ x: '-100%' }}
      transition={{ type: 'spring', stiffness: 300, damping: 30 }}
    >
      <motion.div
        className="max-w-6xl mx-auto"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.6 }}
      >
        <div className="flex items-center justify-between mb-8">
          <div>
            <motion.h1
              className="text-4xl font-bold gradient-text mb-2"
              initial={{ x: -20, opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              transition={{ delay: 0.2 }}
            >
              Welcome Back
            </motion.h1>
            <motion.p
              className="text-white/60 font-mono text-sm"
              initial={{ x: -20, opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              transition={{ delay: 0.3 }}
            >
              {address.slice(0, 6)}...{address.slice(-4)}
            </motion.p>
          </div>

          <div className="flex gap-3">
            <motion.button
              className="glass-morphism p-4 rounded-xl hover:scale-105 transition-transform"
              onClick={() => onNavigate('profile')}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              title="Profile"
            >
              <User className="text-[#00F5A0]" size={24} />
            </motion.button>

            <motion.button
              className="glass-morphism p-4 rounded-xl hover:scale-105 transition-transform group"
              onClick={onDisconnect}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              title="Disconnect Wallet"
            >
              <LogOut className="text-[#FF00E5] group-hover:text-[#FF00E5]" size={24} />
            </motion.button>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {stats.map((stat, index) => (
            <motion.div
              key={stat.label}
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.1 * index }}
            >
              <GlassCard3D>
                <div className="text-center">
                  <div className="text-3xl font-bold gradient-text mono mb-2">
                    {stat.value}
                    <span className="text-xl text-white/60 ml-1">{stat.unit}</span>
                  </div>
                  <div className="text-white/60 text-sm">{stat.label}</div>
                </div>
              </GlassCard3D>
            </motion.div>
          ))}
        </div>

        <h2 className="text-2xl font-bold text-white mb-6 flex items-center gap-2">
          <Activity className="text-[#00F5A0]" />
          Quick Actions
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {quickActions.map((action, index) => {
            const Icon = action.icon;
            return (
              <motion.div
                key={action.id}
                initial={{ y: 50, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.1 * index, type: 'spring', stiffness: 100 }}
              >
                <GlassCard3D
                  onClick={() => onNavigate(action.id)}
                  className="cursor-pointer text-center h-full"
                >
                  <motion.div
                    className={`w-16 h-16 mx-auto mb-4 rounded-2xl bg-gradient-to-br ${action.gradient} flex items-center justify-center`}
                    whileHover={{ rotate: 360 }}
                    transition={{ duration: 0.6 }}
                  >
                    <Icon size={32} className="text-white" />
                  </motion.div>

                  <h3 className="text-xl font-bold text-white mb-2">
                    {action.title}
                  </h3>
                  <p className="text-white/60 text-sm">{action.description}</p>
                </GlassCard3D>
              </motion.div>
            );
          })}
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <GlassCard3D onClick={() => onNavigate('governance')} className="cursor-pointer">
            <div className="flex items-center gap-4">
              <div className="w-14 h-14 rounded-xl bg-gradient-to-br from-[#FF00E5] to-[#C700B3] flex items-center justify-center flex-shrink-0">
                <Vote size={28} className="text-white" />
              </div>
              <div className="flex-1">
                <h3 className="text-xl font-bold text-white mb-1">Governance</h3>
                <p className="text-white/60 text-sm">Vote on proposals</p>
              </div>
              <motion.div
                className="text-[#00F5A0] text-3xl font-bold mono"
                animate={{ scale: [1, 1.1, 1] }}
                transition={{ duration: 2, repeat: Infinity }}
              >
                3
              </motion.div>
            </div>
          </GlassCard3D>

          <GlassCard3D className="bg-gradient-to-br from-[#00F5A0]/10 to-[#FF00E5]/10">
            <div className="text-center">
              <Activity className="mx-auto mb-3 text-[#00F5A0]" size={32} />
              <h3 className="text-xl font-bold text-white mb-2">Health SBT</h3>
              <p className="text-white/60 text-sm mb-4">Your on-chain health identity</p>
              <div className="inline-block px-4 py-2 rounded-lg bg-[#00F5A0]/20 text-[#00F5A0] font-mono text-sm">
                Level 5 Verified
              </div>
            </div>
          </GlassCard3D>
        </div>
      </motion.div>
    </motion.div>
  );
}
