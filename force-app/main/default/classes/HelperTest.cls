/**
 * @description       : Helper class for setting up test data.
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-05-2025
 * @last modified by  : Ankit Majee
**/
@isTest
public class HelperTest {

    /**
    * @description Creates a new System Administrator user object, but does not insert it.
    * Handles the case where the System Administrator profile is not found.
    * @author Ankit Majee | 08-04-2025 
    * @return User The new System Administrator user object, or null if the profile is not found.
    **/
    public static User createSysAdminUser() {    
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' WITH SECURITY_ENFORCED LIMIT 1];
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
    * @description Creates and inserts 50 Job_Application__c records for test purposes.
    * @author Ankit Majee | 08-04-2025 
    **/
    public static void setupApplicantStatusTestData() {
        List<Job_Application__c> applications = new List<Job_Application__c>();

        // Create records for the Withdrawn and Inactive rules
        for (Integer position = 0; position < 30; position++) {
            applications.add(new Job_Application__c(
                Job_Title__c='Test Job',
                Status__c = 'New',
                Last_Activity_Date__c = Date.today().addDays(-35),
                Last_Interview_Date__c = null,
                Candidate_no_longer_interested__c = Math.mod(position,3) == 0
            ));
        }

        // Create records specifically for the Interviewed rule
        for (Integer position = 0; position < 20; position++) {
            applications.add(new Job_Application__c(
                Job_Title__c='Test Job',
                Status__c = 'Interviewed',
                Last_Activity_Date__c = Date.today(),
                Last_Interview_Date__c = Date.today().addDays(-20),
                Candidate_no_longer_interested__c = false
            ));
        }
        insert applications;
    }
}