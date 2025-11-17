import { createContext, useContext, useState, ReactNode } from 'react';
import { TxnModal, TxnStatus } from '../components/TxnModal';

interface TxnContextType {
  showTxn: (status: TxnStatus, message?: string, txHash?: string) => void;
  closeTxn: () => void;
}

const TxnContext = createContext<TxnContextType | undefined>(undefined);

export function TxnProvider({ children }: { children: ReactNode }) {
  const [isOpen, setIsOpen] = useState(false);
  const [status, setStatus] = useState<TxnStatus>('pending');
  const [message, setMessage] = useState<string>('');
  const [txHash, setTxHash] = useState<string>('');

  const showTxn = (newStatus: TxnStatus, newMessage?: string, newTxHash?: string) => {
    setStatus(newStatus);
    setMessage(newMessage || '');
    setTxHash(newTxHash || '');
    setIsOpen(true);
  };

  const closeTxn = () => {
    setIsOpen(false);
  };

  return (
    <TxnContext.Provider value={{ showTxn, closeTxn }}>
      {children}
      <TxnModal
        isOpen={isOpen}
        status={status}
        message={message}
        txHash={txHash}
        onClose={closeTxn}
      />
    </TxnContext.Provider>
  );
}

export function useTxn() {
  const context = useContext(TxnContext);
  if (!context) {
    throw new Error('useTxn must be used within TxnProvider');
  }
  return context;
}
