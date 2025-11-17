import { motion, AnimatePresence } from 'framer-motion';
import { Loader2, CheckCircle, XCircle, ExternalLink } from 'lucide-react';
import { useEffect } from 'react';
import { NeonButton } from './NeonButton';

export type TxnStatus = 'pending' | 'success' | 'error';

interface TxnModalProps {
  isOpen: boolean;
  status: TxnStatus;
  message?: string;
  txHash?: string;
  onClose: () => void;
}

export function TxnModal({ isOpen, status, message, txHash, onClose }: TxnModalProps) {
  useEffect(() => {
    if (isOpen && status === 'success') {
      const timer = setTimeout(() => {
        onClose();
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [isOpen, status, onClose]);

  const handleViewOnSubscan = () => {
    if (txHash) {
      window.open(`https://polkadot.subscan.io/extrinsic/${txHash}`, '_blank');
    }
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <>
          <motion.div
            className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={status !== 'pending' ? onClose : undefined}
          />

          <div className="fixed inset-0 z-50 flex items-center justify-center p-6 pointer-events-none">
            <motion.div
              className="glass-card-3d max-w-md w-full pointer-events-auto"
              initial={{ scale: 0.8, opacity: 0, y: 50 }}
              animate={{ scale: 1, opacity: 1, y: 0 }}
              exit={{ scale: 0.8, opacity: 0, y: 50 }}
              transition={{ type: 'spring', stiffness: 300, damping: 25 }}
            >
              <div className="text-center">
                {status === 'pending' && (
                  <motion.div
                    className="space-y-6"
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                  >
                    <motion.div
                      className="inline-flex items-center justify-center w-24 h-24 rounded-full bg-gradient-to-br from-[#00F5A0] to-[#FF00E5] relative"
                      animate={{
                        rotateY: [0, 360],
                      }}
                      transition={{
                        duration: 2,
                        repeat: Infinity,
                        ease: 'linear',
                      }}
                      style={{ transformStyle: 'preserve-3d' }}
                    >
                      <Loader2
                        size={48}
                        className="text-white animate-spin"
                        style={{ transform: 'translateZ(20px)' }}
                      />
                    </motion.div>

                    <div>
                      <h3 className="text-2xl font-bold text-white mb-2">
                        Processing Transaction
                      </h3>
                      <p className="text-white/60">
                        {message || 'Please wait while your transaction is being processed...'}
                      </p>
                    </div>

                    <div className="flex justify-center gap-2">
                      {[0, 1, 2].map((i) => (
                        <motion.div
                          key={i}
                          className="w-3 h-3 rounded-full bg-[#00F5A0]"
                          animate={{
                            scale: [1, 1.5, 1],
                            opacity: [0.3, 1, 0.3],
                          }}
                          transition={{
                            duration: 1.5,
                            repeat: Infinity,
                            delay: i * 0.2,
                          }}
                        />
                      ))}
                    </div>
                  </motion.div>
                )}

                {status === 'success' && (
                  <motion.div
                    className="space-y-6"
                    initial={{ opacity: 0, scale: 0.5 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ type: 'spring', stiffness: 200 }}
                  >
                    <motion.div
                      className="inline-flex items-center justify-center w-24 h-24 rounded-full bg-[#00F5A0] relative"
                      initial={{ scale: 0, rotate: -180 }}
                      animate={{ scale: 1, rotate: 0 }}
                      transition={{ type: 'spring', stiffness: 200, delay: 0.1 }}
                    >
                      <CheckCircle size={48} className="text-white" />

                      {[...Array(12)].map((_, i) => (
                        <motion.div
                          key={i}
                          className="absolute w-2 h-2 rounded-full bg-[#FFD600]"
                          style={{
                            top: '50%',
                            left: '50%',
                          }}
                          initial={{
                            x: 0,
                            y: 0,
                            scale: 0,
                            opacity: 1,
                          }}
                          animate={{
                            x: Math.cos((i * 2 * Math.PI) / 12) * 80,
                            y: Math.sin((i * 2 * Math.PI) / 12) * 80,
                            scale: [0, 1, 0],
                            opacity: [1, 1, 0],
                          }}
                          transition={{
                            duration: 1,
                            delay: i * 0.05,
                            ease: 'easeOut',
                          }}
                        />
                      ))}
                    </motion.div>

                    <div>
                      <motion.h3
                        className="text-3xl font-bold gradient-text mb-2"
                        initial={{ y: 20, opacity: 0 }}
                        animate={{ y: 0, opacity: 1 }}
                        transition={{ delay: 0.2 }}
                      >
                        Success!
                      </motion.h3>
                      <motion.p
                        className="text-white/60"
                        initial={{ y: 20, opacity: 0 }}
                        animate={{ y: 0, opacity: 1 }}
                        transition={{ delay: 0.3 }}
                      >
                        {message || 'Your transaction has been completed successfully'}
                      </motion.p>
                    </div>

                    {txHash && (
                      <motion.div
                        className="space-y-3"
                        initial={{ y: 20, opacity: 0 }}
                        animate={{ y: 0, opacity: 1 }}
                        transition={{ delay: 0.4 }}
                      >
                        <div className="p-3 rounded-lg bg-white/5 font-mono text-xs text-white/60 break-all">
                          {txHash}
                        </div>

                        <NeonButton
                          onClick={handleViewOnSubscan}
                          variant="secondary"
                          className="w-full text-sm py-3"
                        >
                          <ExternalLink className="inline-block mr-2" size={16} />
                          View on Subscan
                        </NeonButton>
                      </motion.div>
                    )}

                    <motion.button
                      className="text-white/60 hover:text-white text-sm transition-colors"
                      onClick={onClose}
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      transition={{ delay: 0.5 }}
                    >
                      Close
                    </motion.button>
                  </motion.div>
                )}

                {status === 'error' && (
                  <motion.div
                    className="space-y-6"
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1, x: [-10, 10, -10, 10, 0] }}
                    transition={{ x: { duration: 0.4 } }}
                  >
                    <motion.div
                      className="inline-flex items-center justify-center w-24 h-24 rounded-full bg-[#FF00E5] relative"
                      animate={{
                        scale: [1, 1.05, 1],
                      }}
                      transition={{
                        duration: 0.3,
                        repeat: 3,
                      }}
                    >
                      <XCircle size={48} className="text-white" />
                    </motion.div>

                    <div>
                      <h3 className="text-2xl font-bold text-[#FF00E5] mb-2">
                        Transaction Failed
                      </h3>
                      <p className="text-white/60">
                        {message || 'Something went wrong. Please try again.'}
                      </p>
                    </div>

                    <NeonButton
                      onClick={onClose}
                      variant="secondary"
                      className="w-full"
                    >
                      Try Again
                    </NeonButton>
                  </motion.div>
                )}
              </div>
            </motion.div>
          </div>
        </>
      )}
    </AnimatePresence>
  );
}
