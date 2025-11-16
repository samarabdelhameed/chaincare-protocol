#![cfg_attr(not(feature = "std"), no_std, no_main)]

#[ink::contract]
mod health_sbt {
    use ink::storage::Mapping;
    use ink::prelude::string::String;
    use parity_scale_codec::{Decode, Encode};
    use scale_info::TypeInfo;

    #[ink(storage)]
    pub struct HealthSbt {
        owner: AccountId,
        metadata: Mapping<AccountId, String>,
        issued: Mapping<AccountId, u64>,
    }

    #[ink(event)]
    pub struct Minted { to: AccountId, metadata: String }

    #[derive(Debug, PartialEq, Encode, Decode)]
    #[cfg_attr(feature = "std", derive(TypeInfo))]
    pub enum Error {
        Unauthorised,
        AlreadyExists,
    }

    impl HealthSbt {
        #[ink(constructor)]
        pub fn new(owner: AccountId) -> Self {
            Self {
                owner,
                metadata: Mapping::new(),
                issued: Mapping::new(),
            }
        }

        #[ink(message)]
        pub fn mint(&mut self, to: AccountId, metadata: String) -> Result<(), Error> {
            if self.env().caller() != self.owner {
                return Err(Error::Unauthorised);
            }
            if self.metadata.contains(to) {
                return Err(Error::AlreadyExists);
            }
            self.metadata.insert(to, &metadata);
            self.issued.insert(to, &self.env().block_timestamp());
            self.env().emit_event(Minted { to, metadata: metadata.clone() });
            Ok(())
        }

        #[ink(message)]
        pub fn owner_of(&self, account: AccountId) -> Option<Token> {
            let metadata = self.metadata.get(account)?;
            let issued = self.issued.get(account)?;
            Some(Token { metadata, issued })
        }

        #[ink(message)]
        pub fn is_holder(&self, account: AccountId) -> bool {
            self.metadata.contains(account)
        }
    }

    #[derive(Decode, Encode, Debug, PartialEq, Clone)]
    #[cfg_attr(feature = "std", derive(TypeInfo))]
    pub struct Token {
        metadata: String,
        issued: u64,
    }
}
