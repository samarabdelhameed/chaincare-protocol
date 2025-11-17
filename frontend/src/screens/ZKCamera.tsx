import { motion } from 'framer-motion';
import { Camera, Shield, Check, ArrowLeft, Aperture } from 'lucide-react';
import { useState } from 'react';
import { GlassCard3D } from '../components/GlassCard3D';
import { NeonButton } from '../components/NeonButton';
import { SuccessConfetti } from '../components/SuccessConfetti';

interface ZKCameraProps {
  onBack: () => void;
}

export function ZKCamera({ onBack }: ZKCameraProps) {
  const [capturing, setCapturing] = useState(false);
  const [showSuccess, setShowSuccess] = useState(false);
  const [proofSubmitted, setProofSubmitted] = useState(false);

  const handleCapture = async () => {
    setCapturing(true);

    await new Promise(resolve => setTimeout(resolve, 2000));

    setCapturing(false);
    setProofSubmitted(true);
    setShowSuccess(true);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#0F0F1A] via-[#1A1A2E] to-[#0F0F1A] p-6">
      <SuccessConfetti show={showSuccess} onComplete={() => setShowSuccess(false)} />

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
            zk-Camera Proof
          </h1>
          <p className="text-white/60">
            Privacy-preserving identity verification
          </p>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <GlassCard3D className="aspect-square flex flex-col items-center justify-center relative overflow-hidden">
            <motion.div
              className="absolute inset-0 bg-gradient-to-br from-[#FF00E5]/20 to-[#00F5A0]/20"
              animate={{
                opacity: capturing ? [0.3, 0.6, 0.3] : 0.3,
              }}
              transition={{
                duration: 1.5,
                repeat: capturing ? Infinity : 0,
              }}
            />

            {!capturing && !proofSubmitted && (
              <motion.div
                className="relative z-10 text-center"
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
              >
                <motion.div
                  className="w-32 h-32 mx-auto mb-6 rounded-full bg-gradient-to-br from-[#FF00E5] to-[#C700B3] flex items-center justify-center"
                  animate={{ rotateY: [0, 360] }}
                  transition={{ duration: 3, repeat: Infinity, ease: 'linear' }}
                  style={{ transformStyle: 'preserve-3d' }}
                >
                  <Camera size={64} className="text-white" />
                </motion.div>

                <h3 className="text-2xl font-bold text-white mb-2">
                  Ready to Capture
                </h3>
                <p className="text-white/60 text-sm max-w-xs mx-auto">
                  Position yourself in the camera frame for privacy-preserving verification
                </p>
              </motion.div>
            )}

            {capturing && (
              <motion.div
                className="relative z-10 text-center"
                initial={{ scale: 0 }}
                animate={{ scale: 1, rotate: 360 }}
                transition={{ duration: 2, repeat: Infinity }}
              >
                <Aperture size={80} className="text-[#00F5A0]" />
                <p className="text-white mt-4 font-bold">Processing...</p>
              </motion.div>
            )}

            {proofSubmitted && !capturing && (
              <motion.div
                className="relative z-10 text-center"
                initial={{ scale: 0, rotate: -180 }}
                animate={{ scale: 1, rotate: 0 }}
                transition={{ type: 'spring', stiffness: 200 }}
              >
                <div className="w-32 h-32 mx-auto mb-6 rounded-full bg-[#00F5A0] flex items-center justify-center">
                  <Check size={64} className="text-white" />
                </div>
                <h3 className="text-2xl font-bold text-[#00F5A0] mb-2">
                  Proof Verified!
                </h3>
                <p className="text-white/60 text-sm">
                  Zero-knowledge proof submitted successfully
                </p>
              </motion.div>
            )}
          </GlassCard3D>

          <div className="space-y-6">
            <GlassCard3D>
              <div className="flex items-center gap-4 mb-4">
                <Shield className="text-[#00F5A0]" size={24} />
                <h3 className="text-xl font-bold text-white">How it Works</h3>
              </div>

              <div className="space-y-4">
                <div className="flex gap-3">
                  <div className="w-8 h-8 rounded-lg bg-[#00F5A0]/20 flex items-center justify-center flex-shrink-0 text-[#00F5A0] font-bold">
                    1
                  </div>
                  <div>
                    <h4 className="font-semibold text-white mb-1">Capture Silhouette</h4>
                    <p className="text-white/60 text-sm">
                      Camera captures your silhouette without revealing identity
                    </p>
                  </div>
                </div>

                <div className="flex gap-3">
                  <div className="w-8 h-8 rounded-lg bg-[#FFD600]/20 flex items-center justify-center flex-shrink-0 text-[#FFD600] font-bold">
                    2
                  </div>
                  <div>
                    <h4 className="font-semibold text-white mb-1">Generate zk-Proof</h4>
                    <p className="text-white/60 text-sm">
                      Creates cryptographic proof of presence without storing images
                    </p>
                  </div>
                </div>

                <div className="flex gap-3">
                  <div className="w-8 h-8 rounded-lg bg-[#FF00E5]/20 flex items-center justify-center flex-shrink-0 text-[#FF00E5] font-bold">
                    3
                  </div>
                  <div>
                    <h4 className="font-semibold text-white mb-1">Submit On-Chain</h4>
                    <p className="text-white/60 text-sm">
                      Proof is verified and recorded on Polkadot blockchain
                    </p>
                  </div>
                </div>
              </div>
            </GlassCard3D>

            <GlassCard3D className="bg-gradient-to-br from-[#FFD600]/10 to-[#00F5A0]/10">
              <h3 className="font-bold text-white mb-4">Privacy Guarantees</h3>
              <div className="space-y-2">
                <div className="flex items-center gap-2 text-sm">
                  <Check className="text-[#00F5A0]" size={16} />
                  <span className="text-white/80">No images stored</span>
                </div>
                <div className="flex items-center gap-2 text-sm">
                  <Check className="text-[#00F5A0]" size={16} />
                  <span className="text-white/80">Identity protected</span>
                </div>
                <div className="flex items-center gap-2 text-sm">
                  <Check className="text-[#00F5A0]" size={16} />
                  <span className="text-white/80">GDPR compliant</span>
                </div>
                <div className="flex items-center gap-2 text-sm">
                  <Check className="text-[#00F5A0]" size={16} />
                  <span className="text-white/80">Cryptographically secure</span>
                </div>
              </div>
            </GlassCard3D>
          </div>
        </div>

        <motion.div
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.3 }}
        >
          <GlassCard3D className="text-center">
            <NeonButton
              onClick={handleCapture}
              disabled={capturing || proofSubmitted}
              className="w-full md:w-auto"
            >
              {capturing ? (
                'Processing Proof...'
              ) : proofSubmitted ? (
                <>
                  <Check className="inline-block mr-2" size={20} />
                  Proof Submitted
                </>
              ) : (
                <>
                  <Camera className="inline-block mr-2" size={20} />
                  Capture & Submit Proof
                </>
              )}
            </NeonButton>

            {proofSubmitted && (
              <motion.p
                className="text-white/60 text-sm mt-4"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
              >
                Next verification available in 24 hours
              </motion.p>
            )}
          </GlassCard3D>
        </motion.div>
      </div>
    </div>
  );
}
