#[cfg(test)]
mod tests {
    use super::*;
    use ink::env::test;

    #[ink::test]
    fn test_mint_sbt() {
        let accounts = ink::env::test::default_accounts::<ink::env::DefaultEnvironment>();
        let mut health_sbt = HealthSbt::new(accounts.alice);
        
        let metadata = r#"{"diagnosis": "Type-2 Diabetes"}"#.to_string();
        let result = health_sbt.mint(accounts.bob, metadata.clone());
        
        assert!(result.is_ok());
        assert!(health_sbt.is_holder(accounts.bob));
        
        let token = health_sbt.owner_of(accounts.bob).unwrap();
        assert_eq!(token.metadata, metadata);
    }

    #[ink::test]
    fn test_mint_unauthorized() {
        let accounts = ink::env::test::default_accounts::<ink::env::DefaultEnvironment>();
        let mut health_sbt = HealthSbt::new(accounts.alice);
        
        ink::env::test::set_caller::<ink::env::DefaultEnvironment>(accounts.bob);
        let metadata = r#"{"diagnosis": "Type-2"}"#.to_string();
        let result = health_sbt.mint(accounts.charlie, metadata);
        
        assert_eq!(result, Err(Error::Unauthorised));
    }

    #[ink::test]
    fn test_mint_duplicate() {
        let accounts = ink::env::test::default_accounts::<ink::env::DefaultEnvironment>();
        let mut health_sbt = HealthSbt::new(accounts.alice);
        
        let metadata = r#"{"diagnosis": "Type-2"}"#.to_string();
        health_sbt.mint(accounts.bob, metadata.clone()).unwrap();
        
        let result = health_sbt.mint(accounts.bob, metadata);
        assert_eq!(result, Err(Error::AlreadyExists));
    }
}

