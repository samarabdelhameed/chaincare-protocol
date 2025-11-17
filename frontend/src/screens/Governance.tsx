import { motion, AnimatePresence } from 'framer-motion';
import { Vote, ThumbsUp, ThumbsDown, ArrowLeft, Users, Clock } from 'lucide-react';
import { useState } from 'react';
import { GlassCard3D } from '../components/GlassCard3D';
import { NeonButton } from '../components/NeonButton';
import { SuccessConfetti } from '../components/SuccessConfetti';

interface GovernanceProps {
  onBack: () => void;
}

interface Proposal {
  id: string;
  title: string;
  description: string;
  votesFor: number;
  votesAgainst: number;
  totalVotes: number;
  timeLeft: string;
  userVoted?: 'for' | 'against' | null;
}

export function Governance({ onBack }: GovernanceProps) {
  const [showSuccess, setShowSuccess] = useState(false);
  const [proposals, setProposals] = useState<Proposal[]>([
    {
      id: '1',
      title: 'Increase Step Goal Rewards',
      description: 'Proposal to increase daily step goal rewards from 50 DOT to 75 DOT to encourage more physical activity.',
      votesFor: 234,
      votesAgainst: 45,
      totalVotes: 279,
      timeLeft: '3 days',
      userVoted: null,
    },
    {
      id: '2',
      title: 'Add Mental Health Tracking',
      description: 'Introduce new mental wellness features including mood tracking and meditation rewards.',
      votesFor: 187,
      votesAgainst: 23,
      totalVotes: 210,
      timeLeft: '5 days',
      userVoted: null,
    },
    {
      id: '3',
      title: 'Reduce Claim Cooldown',
      description: 'Reduce reward claim cooldown period from 24 hours to 12 hours for better liquidity.',
      votesFor: 156,
      votesAgainst: 98,
      totalVotes: 254,
      timeLeft: '1 day',
      userVoted: null,
    },
  ]);

  const handleVote = async (proposalId: string, vote: 'for' | 'against') => {
    setProposals(prev =>
      prev.map(p => {
        if (p.id === proposalId) {
          return {
            ...p,
            votesFor: vote === 'for' ? p.votesFor + 1 : p.votesFor,
            votesAgainst: vote === 'against' ? p.votesAgainst + 1 : p.votesAgainst,
            totalVotes: p.totalVotes + 1,
            userVoted: vote,
          };
        }
        return p;
      })
    );

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
            Governance
          </h1>
          <p className="text-white/60">Vote on proposals to shape ChainCARE's future</p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <GlassCard3D>
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text mono mb-2">
                {proposals.length}
              </div>
              <div className="text-white/60 text-sm">Active Proposals</div>
            </div>
          </GlassCard3D>

          <GlassCard3D>
            <div className="text-center">
              <div className="text-3xl font-bold text-[#00F5A0] mono mb-2">
                {proposals.filter(p => p.userVoted).length}
              </div>
              <div className="text-white/60 text-sm">Your Votes</div>
            </div>
          </GlassCard3D>

          <GlassCard3D>
            <div className="text-center">
              <div className="text-3xl font-bold text-[#FFD600] mono mb-2">
                100
              </div>
              <div className="text-white/60 text-sm">Voting Power</div>
            </div>
          </GlassCard3D>
        </div>

        <div className="space-y-6">
          <AnimatePresence>
            {proposals.map((proposal, index) => {
              const forPercentage = (proposal.votesFor / proposal.totalVotes) * 100;
              const againstPercentage = (proposal.votesAgainst / proposal.totalVotes) * 100;

              return (
                <motion.div
                  key={proposal.id}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, x: -100 }}
                  transition={{ delay: index * 0.1 }}
                >
                  <GlassCard3D
                    hover3D={false}
                    className={proposal.userVoted ? 'bg-[#00F5A0]/5' : ''}
                  >
                    <div className="flex items-start justify-between mb-4">
                      <div className="flex-1">
                        <h3 className="text-2xl font-bold text-white mb-2">
                          {proposal.title}
                        </h3>
                        <p className="text-white/70 mb-4">{proposal.description}</p>

                        <div className="flex items-center gap-6 text-sm text-white/60">
                          <div className="flex items-center gap-2">
                            <Users size={16} />
                            {proposal.totalVotes} votes
                          </div>
                          <div className="flex items-center gap-2">
                            <Clock size={16} />
                            {proposal.timeLeft} left
                          </div>
                        </div>
                      </div>

                      <motion.div
                        className="w-16 h-16 rounded-2xl bg-gradient-to-br from-[#FF00E5] to-[#C700B3] flex items-center justify-center ml-4"
                        animate={{ rotateY: [0, 360] }}
                        transition={{ duration: 4, repeat: Infinity, ease: 'linear' }}
                        style={{ transformStyle: 'preserve-3d' }}
                      >
                        <Vote size={32} className="text-white" />
                      </motion.div>
                    </div>

                    <div className="mb-6">
                      <div className="flex items-center justify-between mb-2">
                        <div className="flex items-center gap-2">
                          <ThumbsUp className="text-[#00F5A0]" size={16} />
                          <span className="text-sm text-white/80">
                            For: {proposal.votesFor} ({forPercentage.toFixed(1)}%)
                          </span>
                        </div>
                        <div className="flex items-center gap-2">
                          <ThumbsDown className="text-[#FF00E5]" size={16} />
                          <span className="text-sm text-white/80">
                            Against: {proposal.votesAgainst} ({againstPercentage.toFixed(1)}%)
                          </span>
                        </div>
                      </div>

                      <div className="relative h-3 bg-white/10 rounded-full overflow-hidden">
                        <motion.div
                          className="absolute left-0 top-0 h-full bg-gradient-to-r from-[#00F5A0] to-[#00C782]"
                          initial={{ width: 0 }}
                          animate={{ width: `${forPercentage}%` }}
                          transition={{ duration: 1, delay: index * 0.2 }}
                        />
                        <motion.div
                          className="absolute right-0 top-0 h-full bg-gradient-to-l from-[#FF00E5] to-[#C700B3]"
                          initial={{ width: 0 }}
                          animate={{ width: `${againstPercentage}%` }}
                          transition={{ duration: 1, delay: index * 0.2 }}
                        />
                      </div>
                    </div>

                    {proposal.userVoted ? (
                      <motion.div
                        className="flex items-center justify-center gap-2 py-4 px-6 rounded-xl bg-[#00F5A0]/20 text-[#00F5A0] font-semibold"
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        transition={{ type: 'spring', stiffness: 200 }}
                      >
                        <Vote size={20} />
                        Voted {proposal.userVoted === 'for' ? 'For' : 'Against'}
                      </motion.div>
                    ) : (
                      <div className="grid grid-cols-2 gap-4">
                        <motion.button
                          className="flex items-center justify-center gap-2 py-4 px-6 rounded-xl bg-gradient-to-r from-[#00F5A0] to-[#00C782] font-semibold text-white transition-smooth"
                          onClick={() => handleVote(proposal.id, 'for')}
                          whileHover={{ scale: 1.05, y: -2 }}
                          whileTap={{ scale: 0.95 }}
                        >
                          <ThumbsUp size={20} />
                          Vote For
                        </motion.button>

                        <motion.button
                          className="flex items-center justify-center gap-2 py-4 px-6 rounded-xl bg-gradient-to-r from-[#FF00E5] to-[#C700B3] font-semibold text-white transition-smooth"
                          onClick={() => handleVote(proposal.id, 'against')}
                          whileHover={{ scale: 1.05, y: -2 }}
                          whileTap={{ scale: 0.95 }}
                        >
                          <ThumbsDown size={20} />
                          Vote Against
                        </motion.button>
                      </div>
                    )}
                  </GlassCard3D>
                </motion.div>
              );
            })}
          </AnimatePresence>
        </div>

        <motion.div
          className="mt-8"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5 }}
        >
          <GlassCard3D className="bg-gradient-to-br from-[#FFD600]/10 to-[#00F5A0]/10">
            <div className="flex items-center gap-4">
              <Vote className="text-[#FFD600]" size={32} />
              <div className="flex-1">
                <h3 className="font-bold text-white mb-1">Create Proposal</h3>
                <p className="text-white/60 text-sm">
                  Have an idea? Create your own governance proposal
                </p>
              </div>
              <NeonButton variant="secondary" className="text-sm py-2 px-6">
                New Proposal
              </NeonButton>
            </div>
          </GlassCard3D>
        </motion.div>
      </div>
    </div>
  );
}
