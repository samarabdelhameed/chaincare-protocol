import { motion } from 'framer-motion';
import { TrendingUp, Award, Footprints, ArrowLeft, Bluetooth } from 'lucide-react';
import { useState } from 'react';
import { GlassCard3D } from '../components/GlassCard3D';
import { CircularProgress3D } from '../components/CircularProgress3D';
import { NeonButton } from '../components/NeonButton';
import { LineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';

interface StepCounterProps {
  onBack: () => void;
}

export function StepCounter({ onBack }: StepCounterProps) {
  const [steps] = useState(7542);
  const goal = 10000;
  const progress = Math.min((steps / goal) * 100, 100);

  const weeklyData = [
    { day: 'Mon', steps: 8234 },
    { day: 'Tue', steps: 6821 },
    { day: 'Wed', steps: 9456 },
    { day: 'Thu', steps: 7123 },
    { day: 'Fri', steps: 8901 },
    { day: 'Sat', steps: 10234 },
    { day: 'Sun', steps: 7542 },
  ];

  const stats = [
    { label: 'Distance', value: '5.8', unit: 'km' },
    { label: 'Calories', value: '342', unit: 'kcal' },
    { label: 'Active Time', value: '87', unit: 'min' },
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
            Step Counter
          </h1>
          <p className="text-white/60">Track your daily activity and earn rewards</p>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <GlassCard3D className="flex flex-col items-center justify-center py-8">
            <CircularProgress3D
              progress={progress}
              size={240}
              strokeWidth={24}
              showValue={false}
            />

            <motion.div
              className="text-center mt-4"
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.3 }}
            >
              <div className="text-5xl font-bold gradient-text mono mb-2">
                {steps.toLocaleString()}
              </div>
              <div className="text-white/60 mb-1">of {goal.toLocaleString()} steps</div>
              <div className="text-[#FFD600] font-bold text-xl">
                {(goal - steps).toLocaleString()} to go!
              </div>
            </motion.div>
          </GlassCard3D>

          <div className="space-y-6">
            {stats.map((stat, index) => (
              <motion.div
                key={stat.label}
                initial={{ x: 50, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                transition={{ delay: index * 0.1 }}
              >
                <GlassCard3D>
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="text-white/60 text-sm mb-1">{stat.label}</div>
                      <div className="text-3xl font-bold gradient-text mono">
                        {stat.value}
                        <span className="text-xl text-white/60 ml-1">{stat.unit}</span>
                      </div>
                    </div>
                    <TrendingUp className="text-[#00F5A0]" size={32} />
                  </div>
                </GlassCard3D>
              </motion.div>
            ))}
          </div>
        </div>

        <motion.div
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.3 }}
        >
          <GlassCard3D className="mb-6">
            <h3 className="text-xl font-bold text-white mb-4 flex items-center gap-2">
              <Footprints className="text-[#FFD600]" />
              Weekly Progress
            </h3>

            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={weeklyData}>
                  <XAxis
                    dataKey="day"
                    stroke="rgba(255, 255, 255, 0.3)"
                    style={{ fontSize: '12px' }}
                  />
                  <YAxis
                    stroke="rgba(255, 255, 255, 0.3)"
                    style={{ fontSize: '12px' }}
                  />
                  <Tooltip
                    contentStyle={{
                      backgroundColor: 'rgba(26, 26, 46, 0.9)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: 'white',
                    }}
                  />
                  <Line
                    type="monotone"
                    dataKey="steps"
                    stroke="#00F5A0"
                    strokeWidth={3}
                    dot={{ fill: '#00F5A0', r: 6 }}
                    activeDot={{ r: 8, fill: '#FFD600' }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </GlassCard3D>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <GlassCard3D className="bg-gradient-to-br from-[#FFD600]/10 to-[#00F5A0]/10">
            <div className="flex items-center gap-4">
              <motion.div
                className="w-16 h-16 rounded-2xl bg-gradient-to-br from-[#FFD600] to-[#00F5A0] flex items-center justify-center"
                animate={{ rotate: [0, 360] }}
                transition={{ duration: 3, repeat: Infinity, ease: 'linear' }}
              >
                <Award size={32} className="text-white" />
              </motion.div>
              <div className="flex-1">
                <h3 className="font-bold text-white mb-1">Daily Goal Bonus</h3>
                <p className="text-white/60 text-sm">Complete 10,000 steps to earn 50 DOT</p>
              </div>
            </div>
          </GlassCard3D>

          <GlassCard3D>
            <div className="flex items-center gap-4">
              <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-[#FF00E5] to-[#C700B3] flex items-center justify-center">
                <Bluetooth size={32} className="text-white" />
              </div>
              <div className="flex-1">
                <h3 className="font-bold text-white mb-1">Sync Fitness Band</h3>
                <p className="text-white/60 text-sm mb-2">Connect wearable device</p>
                <NeonButton variant="secondary" className="text-sm py-2 px-4 w-full">
                  Connect Device
                </NeonButton>
              </div>
            </div>
          </GlassCard3D>
        </div>
      </div>
    </div>
  );
}
