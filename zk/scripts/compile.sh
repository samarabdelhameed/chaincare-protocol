#!/bin/bash
set -e
cd "$(dirname "$0")/.."
echo "🔧 Compiling zk circuit..."
circom circuits/med_hash.circom --r1cs --wasm --sym
snarkjs groth16 setup med_hash.r1cs powersOfTau28_hez_final_10.ptau med_hash_0000.zkey
snarkjs zkey export verification_key med_hash_0000.zkey verification_key.json
echo "✅ zk circuit ready"
