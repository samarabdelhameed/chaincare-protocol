import { motion, AnimatePresence } from 'framer-motion';
import { Pill, Check, Clock, ArrowLeft, Nfc } from 'lucide-react';
import { useState } from 'react';
import { GlassCard3D } from '../components/GlassCard3D';
import { NeonButton } from '../components/NeonButton';
import { useTxn } from '../contexts/TxnContext';

interface MedReminderProps {
  onBack: () => void;
}

interface Medication {
  id: string;
  name: string;
  dosage: string;
  time: string;
  taken: boolean;
}

export function MedReminder({ onBack }: MedReminderProps) {
  const { showTxn } = useTxn();
  const [medications, setMedications] = useState<Medication[]>([
    { id: '1', name: 'Aspirin', dosage: '100mg', time: '08:00 AM', taken: false },
    { id: '2', name: 'Vitamin D', dosage: '2000 IU', time: '08:00 AM', taken: false },
    { id: '3', name: 'Omega-3', dosage: '1000mg', time: '12:00 PM', taken: true },
    { id: '4', name: 'Magnesium', dosage: '400mg', time: '08:00 PM', taken: false },
  ]);
  const [scanning, setScanning] = useState(false);

  const handleMarkTaken = async (id: string, name: string) => {
    showTxn('pending', `Recording ${name} intake...`);

    await new Promise(resolve => setTimeout(resolve, 2000));

    const success = Math.random() > 0.1;

    if (success) {
      setMedications(prev =>
        prev.map(med => med.id === id ? { ...med, taken: true } : med)
      );

      showTxn(
        'success',
        `${name} marked as taken! +25 DOT reward earned.`,
        '0xmed' + id + '1234567890abcdef1234567890abcdef1234567890abcdef'
      );
    } else {
      showTxn('error', 'Failed to record medication. Please try again.');
    }
  };

  const handleNFCScan = async () => {
    setScanning(true);
    showTxn('pending', 'Ready to scan NFC tag...');

    await new Promise(resolve => setTimeout(resolve, 1500));

    const success = Math.random() > 0.1;

    if (success) {
      const unverifiedMed = medications.find(m => !m.taken);
      if (unverifiedMed) {
        setMedications(prev =>
          prev.map(med => med.id === unverifiedMed.id ? { ...med, taken: true } : med)
        );
        showTxn(
          'success',
          `NFC Verified! ${unverifiedMed.name} recorded successfully.`,
          '0xnfc' + unverifiedMed.id + '567890abcdef1234567890abcdef123456'
        );
      }
    } else {
      showTxn('error', 'NFC scan failed. Please try again.');
    }

    setScanning(false);
  };

  const pendingMeds = medications.filter(m => !m.taken);
  const takenMeds = medications.filter(m => m.taken);

  return (
    <motion.div
      className="min-h-screen bg-gradient-to-br from-[#0F0F1A] via-[#1A1A2E] to-[#0F0F1A] p-6"
      initial={{ x: '100%' }}
      animate={{ x: 0 }}
      exit={{ x: '-100%' }}
      transition={{ type: 'spring', stiffness: 300, damping: 30 }}
    >
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
            Medication Reminder
          </h1>
          <p className="text-white/60">Track and verify your daily medications</p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <GlassCard3D>
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text mono mb-2">
                {pendingMeds.length}
              </div>
              <div className="text-white/60 text-sm">Pending</div>
            </div>
          </GlassCard3D>

          <GlassCard3D>
            <div className="text-center">
              <div className="text-3xl font-bold text-[#00F5A0] mono mb-2">
                {takenMeds.length}
              </div>
              <div className="text-white/60 text-sm">Completed</div>
            </div>
          </GlassCard3D>

          <GlassCard3D>
            <div className="text-center">
              <div className="text-3xl font-bold text-[#FFD600] mono mb-2">
                {Math.round((takenMeds.length / medications.length) * 100)}%
              </div>
              <div className="text-white/60 text-sm">Adherence</div>
            </div>
          </GlassCard3D>
        </div>

        <div className="space-y-4">
          <AnimatePresence>
            {medications.map((med, index) => (
              <motion.div
                key={med.id}
                initial={{ x: -50, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                exit={{ x: 50, opacity: 0 }}
                transition={{ delay: index * 0.1 }}
              >
                <GlassCard3D
                  className={`${
                    med.taken ? 'bg-[#00F5A0]/5' : ''
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-4 flex-1">
                      <motion.div
                        className={`w-16 h-16 rounded-2xl flex items-center justify-center ${
                          med.taken
                            ? 'bg-[#00F5A0]/20'
                            : 'bg-gradient-to-br from-[#FF00E5] to-[#C700B3]'
                        }`}
                        animate={
                          med.taken
                            ? {}
                            : { rotateY: [0, 30, -30, 0] }
                        }
                        transition={{ duration: 2, repeat: Infinity }}
                        style={{ transformStyle: 'preserve-3d' }}
                      >
                        <Pill
                          size={32}
                          className={med.taken ? 'text-[#00F5A0]' : 'text-white'}
                        />
                      </motion.div>

                      <div className="flex-1">
                        <h3
                          className={`text-xl font-bold mb-1 ${
                            med.taken ? 'text-white/40 line-through' : 'text-white'
                          }`}
                        >
                          {med.name}
                        </h3>
                        <div className="flex items-center gap-4 text-sm">
                          <span className="text-white/60">{med.dosage}</span>
                          <span className="flex items-center gap-1 text-white/60">
                            <Clock size={14} />
                            {med.time}
                          </span>
                        </div>
                      </div>
                    </div>

                    <div>
                      {med.taken ? (
                        <motion.div
                          className="w-12 h-12 rounded-xl bg-[#00F5A0] flex items-center justify-center"
                          initial={{ scale: 0, rotate: -180 }}
                          animate={{ scale: 1, rotate: 0 }}
                          transition={{ type: 'spring', stiffness: 200 }}
                        >
                          <Check size={24} className="text-white" />
                        </motion.div>
                      ) : (
                        <NeonButton
                          onClick={() => handleMarkTaken(med.id, med.name)}
                          variant="success"
                          className="text-sm py-2 px-6"
                        >
                          Mark Taken
                        </NeonButton>
                      )}
                    </div>
                  </div>
                </GlassCard3D>
              </motion.div>
            ))}
          </AnimatePresence>
        </div>

        <motion.div
          className="mt-8"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5 }}
        >
          <GlassCard3D className="bg-gradient-to-br from-[#00F5A0]/10 to-[#FFD600]/10">
            <div className="flex items-center gap-4">
              <motion.div
                className="w-12 h-12 rounded-xl bg-[#FFD600]/20 flex items-center justify-center flex-shrink-0"
                animate={scanning ? { scale: [1, 1.2, 1] } : {}}
                transition={{ duration: 0.5, repeat: scanning ? Infinity : 0 }}
              >
                <Nfc className="text-[#FFD600]" size={24} />
              </motion.div>
              <div className="flex-1">
                <h3 className="font-bold text-white mb-1">
                  NFC Verification Available
                </h3>
                <p className="text-white/60 text-sm">
                  {scanning ? 'Hold device near NFC tag...' : 'Scan medication bottle with NFC for instant verification'}
                </p>
              </div>
              <NeonButton
                onClick={handleNFCScan}
                disabled={scanning}
                variant="secondary"
                className="text-sm py-2 px-6"
              >
                {scanning ? 'Scanning...' : 'Scan NFC'}
              </NeonButton>
            </div>
          </GlassCard3D>
        </motion.div>
      </div>
    </motion.div>
  );
}
