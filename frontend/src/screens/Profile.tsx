import { motion } from 'framer-motion';
import { User, Award, Download, Settings, ArrowLeft, Shield, Activity } from 'lucide-react';
import { useState } from 'react';
import { GlassCard3D } from '../components/GlassCard3D';
import { QRGlass } from '../components/QRGlass';
import { NeonButton } from '../components/NeonButton';

interface ProfileProps {
  address: string;
  onBack: () => void;
}

export function Profile({ address, onBack }: ProfileProps) {
  const [showQR, setShowQR] = useState(false);

  const achievements = [
    { id: '1', name: '7-Day Streak', icon: '🔥', earned: true },
    { id: '2', name: '10K Steps', icon: '👟', earned: true },
    { id: '3', name: 'Perfect Week', icon: '⭐', earned: true },
    { id: '4', name: 'Early Bird', icon: '🌅', earned: false },
    { id: '5', name: 'Night Owl', icon: '🦉', earned: false },
    { id: '6', name: 'Healthy Habit', icon: '💪', earned: true },
  ];

  const healthMetrics = [
    { label: 'Total Steps', value: '287,542', change: '+12%' },
    { label: 'Med Adherence', value: '94%', change: '+3%' },
    { label: 'Active Days', value: '45', change: '+8%' },
    { label: 'zk-Proofs', value: '23', change: '+5%' },
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
            Profile
          </h1>
          <p className="text-white/60">Your health identity and achievements</p>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
          <GlassCard3D className="lg:col-span-2">
            <div className="flex items-start gap-6">
              <motion.div
                className="w-24 h-24 rounded-2xl bg-gradient-to-br from-[#00F5A0] to-[#FF00E5] flex items-center justify-center flex-shrink-0"
                animate={{ rotateY: [0, 360] }}
                transition={{ duration: 5, repeat: Infinity, ease: 'linear' }}
                style={{ transformStyle: 'preserve-3d' }}
              >
                <User size={48} className="text-white" />
              </motion.div>

              <div className="flex-1">
                <h2 className="text-2xl font-bold text-white mb-2">
                  Health SBT Holder
                </h2>
                <p className="text-white/60 mb-4 font-mono text-sm">
                  {address}
                </p>

                <div className="flex items-center gap-4 mb-4">
                  <div className="flex items-center gap-2">
                    <Shield className="text-[#00F5A0]" size={20} />
                    <span className="text-sm text-white/80">Level 5 Verified</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Activity className="text-[#FFD600]" size={20} />
                    <span className="text-sm text-white/80">87 Health Score</span>
                  </div>
                </div>

                <div className="flex gap-3">
                  <NeonButton
                    onClick={() => setShowQR(!showQR)}
                    variant="secondary"
                    className="text-sm py-2 px-4"
                  >
                    <Download size={16} className="inline mr-2" />
                    Export SBT
                  </NeonButton>

                  <NeonButton variant="secondary" className="text-sm py-2 px-4">
                    <Settings size={16} className="inline mr-2" />
                    Settings
                  </NeonButton>
                </div>
              </div>
            </div>
          </GlassCard3D>

          <GlassCard3D className="bg-gradient-to-br from-[#FFD600]/20 to-[#00F5A0]/20">
            <div className="text-center">
              <motion.div
                className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gradient-to-br from-[#FFD600] to-[#00F5A0] mb-4"
                animate={{ rotate: [0, 360] }}
                transition={{ duration: 3, repeat: Infinity, ease: 'linear' }}
              >
                <Award size={32} className="text-white" />
              </motion.div>

              <div className="text-4xl font-bold gradient-text mono mb-2">
                {achievements.filter(a => a.earned).length}
              </div>
              <div className="text-white/60 text-sm">Achievements Earned</div>
            </div>
          </GlassCard3D>
        </div>

        {showQR && (
          <motion.div
            className="mb-8 flex justify-center"
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0, opacity: 0 }}
          >
            <div>
              <QRGlass value={address} size={220} />
              <motion.p
                className="text-center text-white/60 text-sm mt-4"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.3 }}
              >
                Scan to verify Health SBT
              </motion.p>
            </div>
          </motion.div>
        )}

        <GlassCard3D className="mb-8">
          <h3 className="text-xl font-bold text-white mb-6 flex items-center gap-2">
            <Activity className="text-[#00F5A0]" />
            Health Metrics
          </h3>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {healthMetrics.map((metric, index) => (
              <motion.div
                key={metric.label}
                className="text-center p-4 rounded-xl glass-morphism"
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: index * 0.1 }}
                whileHover={{ scale: 1.05 }}
              >
                <div className="text-2xl font-bold gradient-text mono mb-1">
                  {metric.value}
                </div>
                <div className="text-white/60 text-xs mb-2">{metric.label}</div>
                <div className="text-[#00F5A0] text-xs font-semibold">
                  {metric.change}
                </div>
              </motion.div>
            ))}
          </div>
        </GlassCard3D>

        <GlassCard3D>
          <h3 className="text-xl font-bold text-white mb-6 flex items-center gap-2">
            <Award className="text-[#FFD600]" />
            Achievements
          </h3>

          <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
            {achievements.map((achievement, index) => (
              <motion.div
                key={achievement.id}
                className={`p-6 rounded-xl text-center cursor-pointer transition-smooth ${
                  achievement.earned
                    ? 'glass-morphism'
                    : 'bg-white/5 opacity-40'
                }`}
                initial={{ scale: 0, opacity: 0 }}
                animate={{ scale: 1, opacity: achievement.earned ? 1 : 0.4 }}
                transition={{ delay: index * 0.1, type: 'spring', stiffness: 200 }}
                whileHover={achievement.earned ? { scale: 1.1, y: -5 } : {}}
              >
                <motion.div
                  className="text-5xl mb-3"
                  animate={
                    achievement.earned
                      ? { rotate: [0, -10, 10, 0] }
                      : {}
                  }
                  transition={{ duration: 2, repeat: Infinity }}
                >
                  {achievement.icon}
                </motion.div>
                <div className={`text-sm font-semibold ${
                  achievement.earned ? 'text-white' : 'text-white/40'
                }`}>
                  {achievement.name}
                </div>
              </motion.div>
            ))}
          </div>
        </GlassCard3D>
      </div>
    </div>
  );
}
