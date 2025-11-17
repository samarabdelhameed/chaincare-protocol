import { motion } from 'framer-motion';
import { ReactNode } from 'react';

interface GlassCard3DProps {
  children: ReactNode;
  className?: string;
  onClick?: () => void;
  hover3D?: boolean;
}

export function GlassCard3D({ children, className = '', onClick, hover3D = true }: GlassCard3DProps) {
  return (
    <motion.div
      className={`glass-card-3d ${className}`}
      onClick={onClick}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={hover3D ? {
        scale: 1.02,
        rotateY: 5,
        rotateX: 5,
        transition: { duration: 0.3 }
      } : {}}
      whileTap={{ scale: 0.98 }}
      transition={{ duration: 0.4, ease: [0.4, 0, 0.2, 1] }}
      style={{
        transformStyle: 'preserve-3d',
      }}
    >
      {children}
    </motion.div>
  );
}
