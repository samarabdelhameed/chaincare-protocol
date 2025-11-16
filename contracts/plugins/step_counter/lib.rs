#![cfg_attr(not(feature = "std"), no_std, no_main)]

#[ink::contract]
mod step_counter {
    use ink::storage::Mapping;
    use ink::prelude::vec::Vec;
    use parity_scale_codec::{Decode, Encode};
    use scale_info::TypeInfo;

    #[ink(storage)]
    pub struct StepCounter {
        admin: AccountId,
        steps: Mapping<AccountId, u64>,
        daily_target: u64,
    }

    #[ink(event)]
    pub struct StepsRecorded {
        patient: AccountId,
        steps: u64,
        date: u64,
    }

    #[derive(Debug, PartialEq, Encode, Decode)]
    #[cfg_attr(feature = "std", derive(TypeInfo))]
    pub enum Error {
        Unauthorised,
    }

    impl StepCounter {
        #[ink(constructor)]
        pub fn new(admin: AccountId, daily_target: u64) -> Self {
            Self {
                admin,
                steps: Mapping::new(),
                daily_target,
            }
        }

        #[ink(message)]
        pub fn submit_oracle(&mut self, patient: AccountId, steps: u64, date: u64) -> Result<(), Error> {
            if self.env().caller() != self.admin {
                return Err(Error::Unauthorised);
            }
            self.steps.insert(patient, &steps);
            self.env().emit_event(StepsRecorded {
                patient,
                steps,
                date,
            });
            Ok(())
        }

        #[ink(message)]
        pub fn get_steps(&self, patient: AccountId) -> u64 {
            self.steps.get(patient).unwrap_or(0)
        }

        #[ink(message)]
        pub fn is_target_met(&self, patient: AccountId) -> bool {
            self.get_steps(patient) >= self.daily_target
        }

        #[ink(message)]
        pub fn daily_target(&self) -> u64 {
            self.daily_target
        }
    }
}
