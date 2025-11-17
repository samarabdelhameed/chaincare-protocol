import { motion } from 'framer-motion';
import { ReactNode, useState } from 'react';
import { Loader2 } from 'lucide-react';

interface NeonButtonProps {
  children: ReactNode;
  onClick?: () => void | Promise<void>;
  className?: string;
  disabled?: boolean;
  variant?: 'primary' | 'secondary' | 'success';
}

export function NeonButton({
  children,
  onClick,
  className = '',
  disabled = false,
  variant = 'primary'
}: NeonButtonProps) {
  const [loading, setLoading] = useState(false);

  const handleClick = async () => {
    if (onClick) {
      setLoading(true);
      try {
        await onClick();
      } finally {
        setLoading(false);
      }
    }
  };

  const variantStyles = {
    primary: 'from-[#00F5A0] to-[#FF00E5]',
    secondary: 'from-[#1A1A2E] to-[#2A2A3E]',
    success: 'from-[#FFD600] to-[#00F5A0]'
  };

  return (
    <motion.button
      className={`neon-button bg-gradient-to-r ${variantStyles[variant]} ${className} ${
        disabled ? 'opacity-50 cursor-not-allowed' : ''
      }`}
      onClick={handleClick}
      disabled={disabled || loading}
      whileHover={{ scale: disabled ? 1 : 1.05 }}
      whileTap={{ scale: disabled ? 1 : 0.95 }}
      transition={{ duration: 0.2, type: 'spring', stiffness: 400 }}
    >
      {loading ? (
        <motion.div
          animate={{ rotate: 360 }}
          transition={{ duration: 1, repeat: Infinity, ease: 'linear' }}
        >
          <Loader2 className="inline-block" />
        </motion.div>
      ) : (
        children
      )}
    </motion.button>
  );
}
