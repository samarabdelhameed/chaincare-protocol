import { motion } from 'framer-motion';
import { useEffect, useState } from 'react';
import { Sparkles } from 'lucide-react';

interface SuccessConfettiProps {
  show: boolean;
  onComplete?: () => void;
}

export function SuccessConfetti({ show, onComplete }: SuccessConfettiProps) {
  const [particles] = useState(() =>
    Array.from({ length: 30 }, (_, i) => ({
      id: i,
      x: Math.random() * 100,
      rotation: Math.random() * 360,
      delay: Math.random() * 0.3,
      size: Math.random() * 20 + 10,
    }))
  );

  useEffect(() => {
    if (show && onComplete) {
      const timer = setTimeout(onComplete, 2000);
      return () => clearTimeout(timer);
    }
  }, [show, onComplete]);

  if (!show) return null;

  return (
    <div className="fixed inset-0 pointer-events-none z-50 overflow-hidden">
      {particles.map((particle) => (
        <motion.div
          key={particle.id}
          className="absolute"
          style={{
            left: `${particle.x}%`,
            top: '-10%',
            width: particle.size,
            height: particle.size,
          }}
          initial={{ y: 0, opacity: 1, rotate: 0 }}
          animate={{
            y: window.innerHeight + 100,
            opacity: 0,
            rotate: particle.rotation * 4,
          }}
          transition={{
            duration: 2,
            delay: particle.delay,
            ease: 'easeIn',
          }}
        >
          <Sparkles
            className="text-[#FFD600]"
            style={{
              filter: 'drop-shadow(0 0 8px #FFD600)',
            }}
          />
        </motion.div>
      ))}

      <motion.div
        className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
        initial={{ scale: 0, opacity: 0 }}
        animate={{ scale: [0, 1.2, 1], opacity: [0, 1, 1] }}
        transition={{ duration: 0.6 }}
      >
        <div className="text-6xl gradient-text text-shadow-glow font-bold">
          SUCCESS!
        </div>
      </motion.div>
    </div>
  );
}
