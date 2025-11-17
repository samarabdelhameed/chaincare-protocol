#[cfg(test)]
mod tests {
    use super::*;
    use ink::env::test;

    #[ink::test]
    fn test_deposit() {
        let accounts = ink::env::test::default_accounts::<ink::env::DefaultEnvironment>();
        let mut treasury = CareTreasury::new(accounts.alice, 20); // 0.002% daily
        
        ink::env::test::set_caller::<ink::env::DefaultEnvironment>(accounts.bob);
        ink::env::test::set_value_transferred::<ink::env::DefaultEnvironment>(1000);
        
        treasury.deposit();
        
        // Check that deposit was recorded (balance_of checks accumulated yield, not deposits)
        // In a real test, we'd check events or internal state
    }

    #[ink::test]
    fn test_distribute_yield() {
        let accounts = ink::env::test::default_accounts::<ink::env::DefaultEnvironment>();
        let mut treasury = CareTreasury::new(accounts.alice, 20);
        
        // Deposit funds
        ink::env::test::set_caller::<ink::env::DefaultEnvironment>(accounts.bob);
        ink::env::test::set_value_transferred::<ink::env::DefaultEnvironment>(1000);
        treasury.deposit();
        
        // Distribute yield
        ink::env::test::set_caller::<ink::env::DefaultEnvironment>(accounts.alice);
        let compliant_patients = vec![accounts.bob, accounts.charlie];
        treasury.distribute_yield(compliant_patients);
        
        // Check balances (simplified - in real test would check actual balances)
        let balance = treasury.balance_of(accounts.bob);
        assert!(balance > 0);
    }

    #[ink::test]
    fn test_claim() {
        let accounts = ink::env::test::default_accounts::<ink::env::DefaultEnvironment>();
        let mut treasury = CareTreasury::new(accounts.alice, 20);
        
        // Setup: deposit and distribute yield
        ink::env::test::set_caller::<ink::env::DefaultEnvironment>(accounts.bob);
        ink::env::test::set_value_transferred::<ink::env::DefaultEnvironment>(1000);
        treasury.deposit();
        
        ink::env::test::set_caller::<ink::env::DefaultEnvironment>(accounts.alice);
        treasury.distribute_yield(vec![accounts.bob]);
        
        // Claim
        ink::env::test::set_caller::<ink::env::DefaultEnvironment>(accounts.bob);
        let result = treasury.claim();
        
        assert!(result.is_ok());
        // After claim, balance should be 0
        assert_eq!(treasury.balance_of(accounts.bob), 0);
    }

    #[ink::test]
    fn test_claim_zero_balance() {
        let accounts = ink::env::test::default_accounts::<ink::env::DefaultEnvironment>();
        let mut treasury = CareTreasury::new(accounts.alice, 20);
        
        ink::env::test::set_caller::<ink::env::DefaultEnvironment>(accounts.bob);
        let result = treasury.claim();
        
        assert_eq!(result, Err(Error::ZeroClaim));
    }
}

