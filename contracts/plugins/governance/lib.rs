#![cfg_attr(not(feature = "std"), no_std, no_main)]

#[ink::contract]
mod governance {
    use ink::storage::Mapping;
    use ink::prelude::vec::Vec;
    use ink::prelude::string::String;
    use parity_scale_codec::{Decode, Encode};
    use scale_info::TypeInfo;

    #[ink(storage)]
    pub struct Governance {
        admin: AccountId,
        descriptions: Mapping<u64, String>,
        votes_for: Mapping<u64, u64>,
        votes_against: Mapping<u64, u64>,
        active: Mapping<u64, bool>,
        next_id: u64,
        votes: Mapping<(u64, AccountId), bool>,
    }

    #[derive(Decode, Encode, Debug, PartialEq, Clone)]
    #[cfg_attr(feature = "std", derive(TypeInfo))]
    pub struct Proposal {
        description: String,
        votes_for: u64,
        votes_against: u64,
        active: bool,
    }

    #[ink(event)]
    pub struct ProposalCreated { id: u64, description: String }

    #[ink(event)]
    pub struct Voted { id: u64, voter: AccountId, vote: bool }

    #[derive(Debug, PartialEq, Encode, Decode)]
    #[cfg_attr(feature = "std", derive(TypeInfo))]
    pub enum Error {
        Unauthorised,
        AlreadyVoted,
        NotFound,
        Inactive,
    }

    impl Governance {
        #[ink(constructor)]
        pub fn new(admin: AccountId) -> Self {
            Self {
                admin,
                descriptions: Mapping::new(),
                votes_for: Mapping::new(),
                votes_against: Mapping::new(),
                active: Mapping::new(),
                next_id: 1,
                votes: Mapping::new(),
            }
        }

        #[ink(message)]
        #[allow(clippy::arithmetic_side_effects)]
        pub fn create_proposal(&mut self, description: String) -> Result<u64, Error> {
            if self.env().caller() != self.admin {
                return Err(Error::Unauthorised);
            }
            let id = self.next_id;
            self.next_id += 1;
            self.descriptions.insert(id, &description.clone());
            self.votes_for.insert(id, &0);
            self.votes_against.insert(id, &0);
            self.active.insert(id, &true);
            self.env().emit_event(ProposalCreated { id, description });
            Ok(id)
        }

        #[ink(message)]
        #[allow(clippy::arithmetic_side_effects)]
        pub fn vote(&mut self, id: u64, vote: bool) -> Result<(), Error> {
            let caller = self.env().caller();
            if self.votes.contains((id, caller)) {
                return Err(Error::AlreadyVoted);
            }
            if !self.descriptions.contains(id) {
                return Err(Error::NotFound);
            }
            let is_active = self.active.get(id).unwrap_or(false);
            if !is_active {
                return Err(Error::Inactive);
            }
            
            if vote {
                let current = self.votes_for.get(id).unwrap_or(0);
                self.votes_for.insert(id, &(current + 1));
            } else {
                let current = self.votes_against.get(id).unwrap_or(0);
                self.votes_against.insert(id, &(current + 1));
            }
            
            self.votes.insert((id, caller), &true);
            self.env().emit_event(Voted { id, voter: caller, vote });
            Ok(())
        }

        #[ink(message)]
        pub fn get_proposal(&self, id: u64) -> Option<Proposal> {
            let description = self.descriptions.get(id)?;
            let votes_for = self.votes_for.get(id).unwrap_or(0);
            let votes_against = self.votes_against.get(id).unwrap_or(0);
            let active = self.active.get(id).unwrap_or(false);
            Some(Proposal {
                description,
                votes_for,
                votes_against,
                active,
            })
        }

        #[ink(message)]
        pub fn has_voted(&self, id: u64, voter: AccountId) -> bool {
            self.votes.contains((id, voter))
        }
    }
}
