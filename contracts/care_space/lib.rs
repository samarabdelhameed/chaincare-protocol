#![cfg_attr(not(feature = "std"), no_std, no_main)]

#[ink::contract]
mod care_space {
    use ink::prelude::string::String;
    use ink::storage::Mapping;

    #[ink(storage)]
    pub struct CareSpace {
        owner: AccountId,
        name: String,
        patient: AccountId,
        treasury: AccountId,   // CareTreasury contract
        sbt: AccountId,        // HealthSBT contract
        plugins: Mapping<String, AccountId>, // name → plugin
    }

    #[ink(event)]
    pub struct PluginInstalled { name: String, account: AccountId }

    impl CareSpace {
        #[ink(constructor)]
        pub fn new(
            owner: AccountId,
            name: String,
            patient: AccountId,
            treasury: AccountId,
            sbt: AccountId,
        ) -> Self {
            Self {
                owner,
                name,
                patient,
                treasury,
                sbt,
                plugins: Mapping::new(),
            }
        }

        #[ink(message)]
        pub fn install_plugin(&mut self, name: String, account: AccountId) {
            assert_eq!(self.env().caller(), self.owner);
            self.plugins.insert(name.clone(), &account);
            self.env().emit_event(PluginInstalled { name, account });
        }

        #[ink(message)]
        pub fn get_plugin(&self, name: String) -> Option<AccountId> {
            self.plugins.get(name)
        }

        #[ink(message)]
        pub fn who_is_patient(&self) -> AccountId {
            self.patient
        }
    }
}
