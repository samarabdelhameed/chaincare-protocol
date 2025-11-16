#![cfg_attr(not(feature = "std"), no_std, no_main)]

#[ink::contract]
mod med_reminder {
    use ink::prelude::string::String;

    #[ink(storage)]
    pub struct MedReminder {
        med_id: String,
        last_taken: u64,
    }

    #[ink(event)]
    pub struct MedTaken { med_id: String, timestamp: u64 }

    impl MedReminder {
        #[ink(constructor)]
        pub fn new(med_id: String) -> Self {
            Self { med_id, last_taken: 0 }
        }

        #[ink(message)]
        pub fn check_in(&mut self, timestamp: u64) {
            self.last_taken = timestamp;
            self.env().emit_event(MedTaken {
                med_id: self.med_id.clone(),
                timestamp,
            });
        }

        #[ink(message)]
        pub fn last_taken(&self) -> u64 {
            self.last_taken
        }

        #[ink(message)]
        pub fn med_id(&self) -> String {
            self.med_id.clone()
        }
    }
}

