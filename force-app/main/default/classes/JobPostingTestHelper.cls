/**
 * @description       : Helper class for setting up test data for JobPostingController.
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-05-2025
 * @last modified by  : Ankit Majee
**/
@isTest
public class JobPostingTestHelper {

     /**
     * @description       : Creates a System Administrator user for testing.
     * @author            : Ankit Majee | 08-05-2025
     * @return User       : The new User object for a System Administrator.
     **/
    public static User createSysAdminUser() {    
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        User userObj = new User(
            FirstName = 'Sys',
            LastName = 'Admin',
            Email = 'sysadmin' + DateTime.now().getTime() + '@test.com',
            Username = 'sysadmin' + DateTime.now().getTime() + '@test.com',
            Alias = 'sysadm',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = sysAdminProfile.Id
        );
        return userObj;
    }

    /**
     * @description       : Creates a Standard User for testing.
     * @author            : Ankit Majee | 08-05-2025
     * @return User       : The new User object for a Standard User.
     **/
    public static User createStandardUser() {
        Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User userObj = new User(
            FirstName = 'Standard',
            LastName = 'User',
            Email = 'stduser' + DateTime.now().getTime() + '@test.com',
            Username = 'stduser' + DateTime.now().getTime() + '@test.com',
            Alias = 'stdusr',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = standardUserProfile.Id
        );
        return userObj;
    }
    
    /**
     * @description       : Creates mock data for `Position__c` records, both active and inactive.
     * @author            : Ankit Majee | 08-05-2025
     * @return List<Position__c> : Returns a list of Position__c records.
     **/
    public static List<Position__c> createMockJobPostings() {
        List<Position__c> jobPostings = new List<Position__c>();

        // Create active job posting
        Position__c activeJob = new Position__c(
            Name = 'Active Job 1',
            Status__c = 'Active',
            Location__c = 'New York',
            Functional_Area__c = 'Engineering',
            Number_of_Open_Position__c = 5,
            Open_Date__c = Date.today()
        );
        jobPostings.add(activeJob);

        // Create inactive job posting
        Position__c inactiveJob = new Position__c(
            Name = 'Inactive Job 1',
            Status__c = 'Inactive',
            Location__c = 'San Francisco',
            Functional_Area__c = 'Sales',
            Number_of_Open_Position__c = 0,
            Open_Date__c = Date.today().addDays(-30)
        );
        jobPostings.add(inactiveJob);

        // Insert records
        insert jobPostings;

        return jobPostings;
    }

}
