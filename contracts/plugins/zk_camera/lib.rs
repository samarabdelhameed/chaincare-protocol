#![cfg_attr(not(feature = "std"), no_std, no_main)]

#[ink::contract]
mod zk_camera {
    use ink::storage::Mapping;
    use ink::prelude::vec::Vec;
    use parity_scale_codec::{Decode, Encode};
    use scale_info::TypeInfo;

    #[ink(storage)]
    pub struct ZkCamera {
        admin: AccountId,
        proof_bytes: Mapping<AccountId, Vec<u8>>,
        timestamps: Mapping<AccountId, u64>,
    }

    #[derive(Decode, Encode, Debug, PartialEq, Clone)]
    #[cfg_attr(feature = "std", derive(TypeInfo))]
    pub struct ZkProof {
        proof_bytes: Vec<u8>,
        timestamp: u64,
    }

    #[ink(event)]
    pub struct ProofSubmitted {
        patient: AccountId,
        timestamp: u64,
    }

    #[derive(Debug, PartialEq, Encode, Decode)]
    #[cfg_attr(feature = "std", derive(TypeInfo))]
    pub enum Error {
        Unauthorised,
    }

    impl ZkCamera {
        #[ink(constructor)]
        pub fn new(admin: AccountId) -> Self {
            Self {
                admin,
                proof_bytes: Mapping::new(),
                timestamps: Mapping::new(),
            }
        }

        #[ink(message)]
        pub fn submit_proof(&mut self, patient: AccountId, proof_bytes: Vec<u8>, timestamp: u64) -> Result<(), Error> {
            if self.env().caller() != self.admin {
                return Err(Error::Unauthorised);
            }
            self.proof_bytes.insert(patient, &proof_bytes);
            self.timestamps.insert(patient, &timestamp);
            self.env().emit_event(ProofSubmitted { patient, timestamp });
            Ok(())
        }

        #[ink(message)]
        pub fn verify_proof(&self, patient: AccountId) -> bool {
            self.proof_bytes.contains(patient)
        }

        #[ink(message)]
        pub fn get_proof(&self, patient: AccountId) -> Option<ZkProof> {
            let proof_bytes = self.proof_bytes.get(patient)?;
            let timestamp = self.timestamps.get(patient)?;
            Some(ZkProof { proof_bytes, timestamp })
        }
    }
}
