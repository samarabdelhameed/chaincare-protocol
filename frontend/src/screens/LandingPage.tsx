import { motion } from 'framer-motion';
import { Shield, Coins, Lock, Activity, TrendingUp, Users, ArrowRight, Check } from 'lucide-react';
import { NeonButton } from '../components/NeonButton';
import { GlassCard3D } from '../components/GlassCard3D';

interface LandingPageProps {
  onGetStarted: () => void;
}

export function LandingPage({ onGetStarted }: LandingPageProps) {
  const features = [
    {
      icon: Shield,
      title: 'Own Your Health Data',
      description: 'Your medical records secured on blockchain. You control access, not corporations.',
      gradient: 'from-[#00F5A0] to-[#00C782]',
    },
    {
      icon: Coins,
      title: 'Earn While You Heal',
      description: 'Get rewarded with DOT tokens for maintaining healthy habits and wellness goals.',
      gradient: 'from-[#FFD600] to-[#FFA500]',
    },
    {
      icon: Lock,
      title: 'Zero-Knowledge Privacy',
      description: 'Prove your health activities without revealing personal information. Privacy first.',
      gradient: 'from-[#FF00E5] to-[#C700B3]',
    },
  ];

  const benefits = [
    'Secure blockchain authentication',
    'Privacy-first health data',
    'Earn rewards for healthy habits',
    'Track medications & activities',
    'Participate in DAO governance',
    'Export SBT health credentials',
  ];

  const steps = [
    {
      number: '01',
      title: 'Connect Wallet',
      description: 'Link your Polkadot wallet or use demo account',
    },
    {
      number: '02',
      title: 'Track Health',
      description: 'Log medications, steps, and wellness activities',
    },
    {
      number: '03',
      title: 'Earn Rewards',
      description: 'Get DOT tokens for maintaining healthy habits',
    },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#0F0F1A] via-[#1A1A2E] to-[#0F0F1A]">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {Array.from({ length: 50 }).map((_, i) => (
          <motion.div
            key={i}
            className="absolute w-1 h-1 rounded-full bg-white/20"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
            }}
            animate={{
              opacity: [0.2, 0.8, 0.2],
              scale: [1, 1.5, 1],
            }}
            transition={{
              duration: 3,
              repeat: Infinity,
              delay: i * 0.05,
            }}
          />
        ))}
      </div>

      <div className="relative z-10">
        <nav className="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <motion.div
            className="flex items-center gap-3"
            initial={{ x: -20, opacity: 0 }}
            animate={{ x: 0, opacity: 1 }}
          >
            <motion.div
              className="w-12 h-12 rounded-xl bg-gradient-to-br from-[#00F5A0] to-[#FF00E5] flex items-center justify-center"
              animate={{ rotateY: [0, 360] }}
              transition={{ duration: 3, repeat: Infinity, ease: 'linear' }}
              style={{ transformStyle: 'preserve-3d' }}
            >
              <Activity size={24} className="text-white" />
            </motion.div>
            <div>
              <h1 className="text-2xl font-bold gradient-text">ChainCARE</h1>
              <p className="text-xs text-white/60">Healthcare on Polkadot</p>
            </div>
          </motion.div>

          <motion.div
            initial={{ x: 20, opacity: 0 }}
            animate={{ x: 0, opacity: 1 }}
          >
            <NeonButton onClick={onGetStarted} className="text-sm">
              Launch App
              <ArrowRight className="inline-block ml-2" size={16} />
            </NeonButton>
          </motion.div>
        </nav>

        <section className="max-w-7xl mx-auto px-6 py-20 text-center">
          <motion.div
            initial={{ y: 30, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ duration: 0.8 }}
          >
            <motion.div
              className="inline-block mb-6 px-6 py-2 rounded-full glass-morphism"
              animate={{ y: [0, -10, 0] }}
              transition={{ duration: 2, repeat: Infinity }}
            >
              <span className="text-[#00F5A0] text-sm font-semibold">
                Built on Polkadot Blockchain
              </span>
            </motion.div>

            <h2 className="text-6xl md:text-7xl font-bold mb-6 leading-tight">
              Take Control of
              <br />
              <span className="gradient-text">Your Health Data</span>
            </h2>

            <p className="text-xl text-white/70 max-w-2xl mx-auto mb-12 leading-relaxed">
              ChainCARE offers a seamless, secure experience for managing your health data.
              Earn rewards for healthy habits with zero-knowledge privacy.
            </p>

            <div className="flex flex-wrap gap-4 justify-center mb-12">
              <NeonButton onClick={onGetStarted} className="text-lg px-8 py-4">
                Get Started Now
                <ArrowRight className="inline-block ml-2" size={20} />
              </NeonButton>

              <motion.button
                className="glass-morphism px-8 py-4 rounded-xl font-semibold text-white text-lg"
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
              >
                Learn More
              </motion.button>
            </div>

            <div className="flex items-center justify-center gap-2 text-white/60">
              <span className="text-sm">Trusted by healthcare professionals</span>
              <div className="flex">
                {[...Array(5)].map((_, i) => (
                  <motion.span
                    key={i}
                    className="text-[#FFD600]"
                    initial={{ opacity: 0, scale: 0 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: i * 0.1 }}
                  >
                    ★
                  </motion.span>
                ))}
              </div>
              <span className="text-sm font-semibold text-white">4.9</span>
            </div>
          </motion.div>

          <motion.div
            className="mt-20"
            initial={{ y: 50, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.3, duration: 0.8 }}
          >
            <div className="relative max-w-5xl mx-auto">
              <div className="absolute inset-0 bg-gradient-to-r from-[#00F5A0] via-[#FFD600] to-[#FF00E5] opacity-20 blur-3xl rounded-3xl" />
              <div className="relative glass-card-3d overflow-hidden">
                <div className="aspect-video bg-gradient-to-br from-[#1A1A2E] to-[#0F0F1A] rounded-2xl flex items-center justify-center">
                  <motion.div
                    animate={{ scale: [1, 1.1, 1] }}
                    transition={{ duration: 2, repeat: Infinity }}
                  >
                    <Activity size={120} className="text-[#00F5A0] opacity-50" />
                  </motion.div>
                </div>
              </div>
            </div>
          </motion.div>
        </section>

        <section className="max-w-7xl mx-auto px-6 py-20">
          <motion.div
            className="text-center mb-16"
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
          >
            <h3 className="text-4xl font-bold text-white mb-4">
              Why Choose ChainCARE?
            </h3>
            <p className="text-white/60 text-lg">
              Benefits designed to provide a seamless, secure, and rewarding experience
            </p>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-8">
            {features.map((feature, index) => {
              const Icon = feature.icon;
              return (
                <motion.div
                  key={feature.title}
                  initial={{ y: 50, opacity: 0 }}
                  whileInView={{ y: 0, opacity: 1 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.2 }}
                >
                  <GlassCard3D className="h-full text-center">
                    <motion.div
                      className={`w-20 h-20 mx-auto mb-6 rounded-2xl bg-gradient-to-br ${feature.gradient} flex items-center justify-center`}
                      whileHover={{ rotate: 360 }}
                      transition={{ duration: 0.6 }}
                    >
                      <Icon size={40} className="text-white" />
                    </motion.div>
                    <h4 className="text-2xl font-bold text-white mb-4">
                      {feature.title}
                    </h4>
                    <p className="text-white/60 leading-relaxed">
                      {feature.description}
                    </p>
                  </GlassCard3D>
                </motion.div>
              );
            })}
          </div>
        </section>

        <section className="max-w-7xl mx-auto px-6 py-20">
          <motion.div
            className="text-center mb-16"
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
          >
            <h3 className="text-4xl font-bold text-white mb-4">How It Works</h3>
            <p className="text-white/60 text-lg">
              Get started in three simple steps
            </p>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-8">
            {steps.map((step, index) => (
              <motion.div
                key={step.number}
                initial={{ x: -50, opacity: 0 }}
                whileInView={{ x: 0, opacity: 1 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.2 }}
              >
                <div className="relative">
                  <motion.div
                    className="text-8xl font-bold gradient-text opacity-20 mb-4"
                    whileHover={{ scale: 1.1 }}
                  >
                    {step.number}
                  </motion.div>
                  <h4 className="text-2xl font-bold text-white mb-3">
                    {step.title}
                  </h4>
                  <p className="text-white/60 leading-relaxed">
                    {step.description}
                  </p>
                </div>
              </motion.div>
            ))}
          </div>
        </section>

        <section className="max-w-7xl mx-auto px-6 py-20">
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
          >
            <div className="glass-card-3d overflow-hidden">
              <div className="grid md:grid-cols-2 gap-12 items-center p-12">
                <div>
                  <h3 className="text-4xl font-bold gradient-text mb-6">
                    Simplicity, Security, and Rewards
                  </h3>
                  <p className="text-white/70 text-lg mb-8 leading-relaxed">
                    Empowering you to navigate the healthcare world with confidence,
                    privacy, and financial incentives for healthy living.
                  </p>

                  <div className="space-y-3 mb-8">
                    {benefits.map((benefit, index) => (
                      <motion.div
                        key={benefit}
                        className="flex items-center gap-3"
                        initial={{ x: -20, opacity: 0 }}
                        whileInView={{ x: 0, opacity: 1 }}
                        viewport={{ once: true }}
                        transition={{ delay: index * 0.1 }}
                      >
                        <div className="w-6 h-6 rounded-full bg-[#00F5A0] flex items-center justify-center flex-shrink-0">
                          <Check size={16} className="text-white" />
                        </div>
                        <span className="text-white/80">{benefit}</span>
                      </motion.div>
                    ))}
                  </div>

                  <NeonButton onClick={onGetStarted} className="text-lg px-8 py-4">
                    Start Your Journey
                    <ArrowRight className="inline-block ml-2" size={20} />
                  </NeonButton>
                </div>

                <motion.div
                  className="relative"
                  animate={{ y: [0, -20, 0] }}
                  transition={{ duration: 3, repeat: Infinity }}
                >
                  <div className="absolute inset-0 bg-gradient-to-br from-[#00F5A0] to-[#FF00E5] opacity-20 blur-3xl" />
                  <div className="relative grid grid-cols-2 gap-4">
                    {[Shield, Coins, Lock, Activity].map((Icon, i) => (
                      <motion.div
                        key={i}
                        className="glass-morphism p-8 rounded-2xl"
                        animate={{ rotate: [0, 5, 0, -5, 0] }}
                        transition={{ duration: 3, delay: i * 0.2, repeat: Infinity }}
                      >
                        <Icon size={48} className="text-[#00F5A0] mx-auto" />
                      </motion.div>
                    ))}
                  </div>
                </motion.div>
              </div>
            </div>
          </motion.div>
        </section>

        <section className="max-w-4xl mx-auto px-6 py-20 text-center">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
          >
            <h3 className="text-5xl font-bold gradient-text mb-6">
              Ready to Transform Your Healthcare?
            </h3>
            <p className="text-white/70 text-xl mb-10">
              Join thousands of users managing their health on the blockchain
            </p>
            <NeonButton onClick={onGetStarted} className="text-xl px-12 py-5">
              Get Started Now
              <ArrowRight className="inline-block ml-3" size={24} />
            </NeonButton>
          </motion.div>
        </section>

        <footer className="max-w-7xl mx-auto px-6 py-12 border-t border-white/10">
          <div className="flex flex-col md:flex-row items-center justify-between gap-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#00F5A0] to-[#FF00E5] flex items-center justify-center">
                <Activity size={20} className="text-white" />
              </div>
              <div>
                <h4 className="font-bold gradient-text">ChainCARE</h4>
                <p className="text-xs text-white/60">Built on Polkadot</p>
              </div>
            </div>

            <div className="text-white/60 text-sm">
              © 2025 ChainCARE. Privacy-first healthcare.
            </div>

            <div className="flex gap-4">
              <a href="#" className="text-white/60 hover:text-[#00F5A0] transition-colors">
                Docs
              </a>
              <a href="#" className="text-white/60 hover:text-[#00F5A0] transition-colors">
                GitHub
              </a>
              <a href="#" className="text-white/60 hover:text-[#00F5A0] transition-colors">
                Twitter
              </a>
            </div>
          </div>
        </footer>
      </div>
    </div>
  );
}
