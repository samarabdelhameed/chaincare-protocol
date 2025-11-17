import { motion } from 'framer-motion';
import { QRCodeSVG } from 'qrcode.react';
import { useState } from 'react';

interface QRGlassProps {
  value: string;
  size?: number;
}

export function QRGlass({ value, size = 256 }: QRGlassProps) {
  const [rotation, setRotation] = useState({ x: 0, y: 0 });

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const centerX = rect.width / 2;
    const centerY = rect.height / 2;

    const rotateX = ((y - centerY) / centerY) * 15;
    const rotateY = ((x - centerX) / centerX) * 15;

    setRotation({ x: -rotateX, y: rotateY });
  };

  const handleMouseLeave = () => {
    setRotation({ x: 0, y: 0 });
  };

  return (
    <motion.div
      className="glass-card-3d p-8 inline-block cursor-pointer"
      onMouseMove={handleMouseMove}
      onMouseLeave={handleMouseLeave}
      animate={{
        rotateX: rotation.x,
        rotateY: rotation.y,
      }}
      transition={{ type: 'spring', stiffness: 300, damping: 20 }}
      style={{
        transformStyle: 'preserve-3d',
      }}
    >
      <div
        className="bg-white p-4 rounded-xl"
        style={{ transform: 'translateZ(20px)' }}
      >
        <QRCodeSVG
          value={value}
          size={size}
          level="H"
          includeMargin={false}
        />
      </div>
    </motion.div>
  );
}
