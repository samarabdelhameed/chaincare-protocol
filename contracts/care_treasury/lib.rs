#![cfg_attr(not(feature = "std"), no_std, no_main)]

#[ink::contract]
mod care_treasury {
    use ink::storage::Mapping;
    use ink::prelude::vec::Vec;
    use parity_scale_codec::{Decode, Encode};
    use scale_info::TypeInfo;

    #[ink(storage)]
    pub struct CareTreasury {
        admin: AccountId,
        daily_rate: u128, // 2% yearly ≈ 0.0055% daily (represented as per-mil)
        balances: Mapping<AccountId, u128>,
        total_deposits: u128,
    }

    #[ink(event)]
    pub struct Deposited { from: AccountId, amount: u128 }

    #[ink(event)]
    pub struct YieldPaid { to: AccountId, amount: u128 }

    #[derive(Debug, PartialEq, Encode, Decode)]
    #[cfg_attr(feature = "std", derive(TypeInfo))]
    pub enum Error {
        ZeroClaim,
        TransferFailed,
    }

    impl CareTreasury {
        #[ink(constructor)]
        pub fn new(admin: AccountId, daily_rate: u128) -> Self {
            Self {
                admin,
                daily_rate,
                balances: Mapping::new(),
                total_deposits: 0,
            }
        }

        #[ink(message, payable)]
        #[allow(clippy::arithmetic_side_effects)]
        pub fn deposit(&mut self) {
            let caller = self.env().caller();
            let amount = self.env().transferred_value();
            let current = self.balances.get(caller).unwrap_or(0);
            self.balances.insert(caller, &(current + amount));
            self.total_deposits += amount;
            self.env().emit_event(Deposited { from: caller, amount });
        }

        #[ink(message)]
        #[allow(clippy::arithmetic_side_effects)]
        pub fn distribute_yield(&mut self, compliant_patients: Vec<AccountId>) {
            assert_eq!(self.env().caller(), self.admin);
            let total_compliant = compliant_patients.len() as u128;
            if total_compliant == 0 { return; }
            let daily_pool = self.env().balance() * self.daily_rate / 1_000_000;
            for patient in compliant_patients {
                let due = daily_pool / total_compliant;
                let current = self.balances.get(patient).unwrap_or(0);
                self.balances.insert(patient, &(current + due));
            }
        }

        #[ink(message)]
        pub fn claim(&mut self) -> Result<(), Error> {
            let caller = self.env().caller();
            let due = self.balances.get(caller).unwrap_or(0);
            if due == 0 { return Err(Error::ZeroClaim); }
            self.balances.insert(caller, &0);
            self.env().transfer(caller, due).map_err(|_| Error::TransferFailed)?;
            self.env().emit_event(YieldPaid { to: caller, amount: due });
            Ok(())
        }

        #[ink(message)]
        pub fn balance_of(&self, account: AccountId) -> u128 {
            self.balances.get(account).unwrap_or(0)
        }
    }
}
