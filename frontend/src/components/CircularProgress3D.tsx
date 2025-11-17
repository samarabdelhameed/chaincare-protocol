import { motion } from 'framer-motion';
import { useEffect, useState } from 'react';

interface CircularProgress3DProps {
  progress: number;
  size?: number;
  strokeWidth?: number;
  label?: string;
  showValue?: boolean;
}

export function CircularProgress3D({
  progress,
  size = 200,
  strokeWidth = 20,
  label = '',
  showValue = true
}: CircularProgress3DProps) {
  const [displayProgress, setDisplayProgress] = useState(0);
  const radius = (size - strokeWidth) / 2;
  const circumference = radius * 2 * Math.PI;
  const offset = circumference - (displayProgress / 100) * circumference;

  useEffect(() => {
    const timer = setTimeout(() => {
      setDisplayProgress(progress);
    }, 100);
    return () => clearTimeout(timer);
  }, [progress]);

  return (
    <div className="relative inline-flex items-center justify-center perspective-container">
      <svg
        width={size}
        height={size}
        className="transform -rotate-90"
        style={{ filter: 'drop-shadow(0 0 20px rgba(0, 245, 160, 0.5))' }}
      >
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          stroke="rgba(255, 255, 255, 0.1)"
          strokeWidth={strokeWidth}
          fill="none"
        />

        <motion.circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          stroke="url(#gradient)"
          strokeWidth={strokeWidth}
          fill="none"
          strokeLinecap="round"
          initial={{ strokeDashoffset: circumference }}
          animate={{ strokeDashoffset: offset }}
          transition={{ duration: 1, ease: 'easeInOut' }}
          style={{
            strokeDasharray: circumference,
          }}
        />

        <defs>
          <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="#00F5A0" />
            <stop offset="50%" stopColor="#FFD600" />
            <stop offset="100%" stopColor="#FF00E5" />
          </linearGradient>
        </defs>
      </svg>

      <div className="absolute inset-0 flex flex-col items-center justify-center">
        {showValue && (
          <motion.div
            className="text-4xl font-bold gradient-text mono"
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.3, type: 'spring', stiffness: 200 }}
          >
            {Math.round(displayProgress)}%
          </motion.div>
        )}
        {label && (
          <div className="text-sm text-white/60 mt-2">{label}</div>
        )}
      </div>
    </div>
  );
}
