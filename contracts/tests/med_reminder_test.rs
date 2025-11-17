#[cfg(test)]
mod tests {
    use super::*;
    use ink::env::test;

    #[ink::test]
    fn test_check_in() {
        let mut med_reminder = MedReminder::new("metformin_500mg".to_string());
        
        let timestamp = 1712345678;
        med_reminder.check_in(timestamp);
        
        assert_eq!(med_reminder.last_taken(), timestamp);
    }

    #[ink::test]
    fn test_last_taken_initial() {
        let med_reminder = MedReminder::new("metformin_500mg".to_string());
        
        assert_eq!(med_reminder.last_taken(), 0);
    }

    #[ink::test]
    fn test_med_id() {
        let med_id = "metformin_500mg".to_string();
        let med_reminder = MedReminder::new(med_id.clone());
        
        assert_eq!(med_reminder.med_id(), med_id);
    }
}

