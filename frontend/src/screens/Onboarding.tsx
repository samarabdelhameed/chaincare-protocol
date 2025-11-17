import { motion, AnimatePresence } from 'framer-motion';
import { Shield, Coins, Lock, ArrowRight, ArrowLeft } from 'lucide-react';
import { useState } from 'react';
import { NeonButton } from '../components/NeonButton';

interface OnboardingProps {
  onComplete: () => void;
}

const slides = [
  {
    id: 1,
    icon: Shield,
    title: 'Own Your Health Data',
    description: 'Your health records stored securely on blockchain. You control who sees what.',
    color: '#00F5A0',
    gradient: 'from-[#00F5A0] to-[#00C782]',
  },
  {
    id: 2,
    icon: Coins,
    title: 'Earn While You Heal',
    description: 'Get rewarded with DOT tokens for maintaining healthy habits and reaching goals.',
    color: '#FFD600',
    gradient: 'from-[#FFD600] to-[#FFA500]',
  },
  {
    id: 3,
    icon: Lock,
    title: 'Zero-Knowledge Privacy',
    description: 'Prove your health activities without revealing personal information. Privacy first.',
    color: '#FF00E5',
    gradient: 'from-[#FF00E5] to-[#C700B3]',
  },
];

export function Onboarding({ onComplete }: OnboardingProps) {
  const [currentSlide, setCurrentSlide] = useState(0);

  const handleNext = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(currentSlide + 1);
    } else {
      onComplete();
    }
  };

  const handlePrev = () => {
    if (currentSlide > 0) {
      setCurrentSlide(currentSlide - 1);
    }
  };

  const slide = slides[currentSlide];
  const Icon = slide.icon;

  return (
    <div className="fixed inset-0 bg-gradient-to-br from-[#0F0F1A] via-[#1A1A2E] to-[#0F0F1A] overflow-hidden">
      <div className="absolute inset-0">
        {Array.from({ length: 30 }).map((_, i) => (
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
              delay: i * 0.1,
            }}
          />
        ))}
      </div>

      <div className="relative z-10 h-full flex flex-col items-center justify-between p-8 max-w-2xl mx-auto">
        <motion.button
          className="self-end text-white/60 hover:text-white transition-colors text-sm"
          onClick={onComplete}
          whileHover={{ scale: 1.1 }}
        >
          Skip
        </motion.button>

        <div className="flex-1 flex flex-col items-center justify-center">
          <AnimatePresence mode="wait">
            <motion.div
              key={currentSlide}
              className="flex flex-col items-center text-center"
              initial={{ opacity: 0, x: 100 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -100 }}
              transition={{ duration: 0.5 }}
            >
              <motion.div
                className={`w-40 h-40 rounded-3xl bg-gradient-to-br ${slide.gradient} flex items-center justify-center mb-8`}
                animate={{
                  rotateY: [0, 360],
                  scale: [1, 1.1, 1],
                }}
                transition={{
                  rotateY: { duration: 3, repeat: Infinity, ease: 'linear' },
                  scale: { duration: 2, repeat: Infinity },
                }}
                style={{
                  transformStyle: 'preserve-3d',
                  boxShadow: `0 20px 60px ${slide.color}40`,
                }}
              >
                <Icon size={80} className="text-white" strokeWidth={2} />
              </motion.div>

              <motion.h1
                className="text-5xl font-bold gradient-text mb-6"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 }}
              >
                {slide.title}
              </motion.h1>

              <motion.p
                className="text-xl text-white/70 max-w-lg leading-relaxed"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 }}
              >
                {slide.description}
              </motion.p>

              <motion.div
                className="mt-12"
                initial={{ opacity: 0, scale: 0.5 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.4, type: 'spring', stiffness: 200 }}
              >
                {currentSlide === 0 && (
                  <motion.div
                    className="flex gap-4"
                    animate={{ y: [0, -10, 0] }}
                    transition={{ duration: 1.5, repeat: Infinity }}
                  >
                    {[...Array(5)].map((_, i) => (
                      <motion.div
                        key={i}
                        className="w-3 h-12 rounded-full bg-[#00F5A0]"
                        animate={{
                          scaleY: [1, 1.5, 1],
                          opacity: [0.3, 1, 0.3],
                        }}
                        transition={{
                          duration: 1,
                          repeat: Infinity,
                          delay: i * 0.1,
                        }}
                      />
                    ))}
                  </motion.div>
                )}

                {currentSlide === 1 && (
                  <motion.div className="flex gap-2">
                    {[...Array(8)].map((_, i) => (
                      <motion.div
                        key={i}
                        className="text-4xl"
                        animate={{
                          y: [0, -20, 0],
                          rotate: [0, 360],
                        }}
                        transition={{
                          duration: 2,
                          repeat: Infinity,
                          delay: i * 0.1,
                        }}
                      >
                        💰
                      </motion.div>
                    ))}
                  </motion.div>
                )}

                {currentSlide === 2 && (
                  <motion.div
                    className="relative w-32 h-32"
                    animate={{ rotate: 360 }}
                    transition={{ duration: 8, repeat: Infinity, ease: 'linear' }}
                  >
                    {[...Array(12)].map((_, i) => (
                      <motion.div
                        key={i}
                        className="absolute top-1/2 left-1/2 w-4 h-4 rounded-full bg-[#FF00E5]"
                        style={{
                          transform: `rotate(${i * 30}deg) translateY(-50px)`,
                        }}
                        animate={{
                          scale: [1, 1.5, 1],
                          opacity: [0.3, 1, 0.3],
                        }}
                        transition={{
                          duration: 1.5,
                          repeat: Infinity,
                          delay: i * 0.1,
                        }}
                      />
                    ))}
                  </motion.div>
                )}
              </motion.div>
            </motion.div>
          </AnimatePresence>
        </div>

        <div className="w-full space-y-6">
          <div className="flex justify-center gap-2">
            {slides.map((_, index) => (
              <motion.button
                key={index}
                className={`h-2 rounded-full transition-all ${
                  index === currentSlide
                    ? 'w-8 bg-[#00F5A0]'
                    : 'w-2 bg-white/30'
                }`}
                onClick={() => setCurrentSlide(index)}
                whileHover={{ scale: 1.2 }}
                whileTap={{ scale: 0.9 }}
              />
            ))}
          </div>

          <div className="flex gap-4">
            {currentSlide > 0 && (
              <motion.button
                className="flex-1 py-4 px-6 rounded-xl glass-morphism font-semibold text-white transition-smooth flex items-center justify-center gap-2"
                onClick={handlePrev}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
              >
                <ArrowLeft size={20} />
                Previous
              </motion.button>
            )}

            <NeonButton
              onClick={handleNext}
              className={currentSlide === 0 ? 'w-full' : 'flex-1'}
            >
              {currentSlide === slides.length - 1 ? 'Get Started' : 'Next'}
              <ArrowRight className="inline-block ml-2" size={20} />
            </NeonButton>
          </div>
        </div>
      </div>
    </div>
  );
}
