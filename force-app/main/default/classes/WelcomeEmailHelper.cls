/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-05-2025
 * @last modified by  : Ankit Majee
**/
public class WelcomeEmailHelper {
    
    // Helper methods for creating mock data
    
    /**
    * @description 
    * @author Ankit Majee | 08-05-2025 
    * @return User 
    **/
    public static User createSystemAdmin() {
        String uniquekey = String.valueOf(System.currentTimeMillis());
        User systemAdmin = new User(
            FirstName = 'System',
            LastName = 'Admin',
            Alias = 'sys44',
            Email = 'sysssadmin@test.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            UserName = 'sysadmin' + uniquekey + '@test.com'
        );
        return systemAdmin;
    }

    /**
    * @description 
    * @author Ankit Majee | 08-05-2025 
    * @return User 
    **/
    public static User createStandardUser() {
        String uniquekey = String.valueOf(System.currentTimeMillis());
        User standardUser = new User(
            FirstName = 'Standard',
            LastName = 'User',
            Alias = 'std6545',
            Email = 'stdsd@test.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            UserName = 'std' + uniquekey + '@test.com'
        );
        return standardUser;
    }

    /**
    * @description 
    * @author Ankit Majee | 08-05-2025 
    * @param email 
    * @return Candidate__c 
    **/
    public static Candidate__c createCandidateWithEmail(String email) {
        // Don't set the Id manually here
        Candidate__c candidate = new Candidate__c(
            First_Name__c = 'John7',
            Last_Name__c = 'Doe4',
            Email__c = email
        );
        return candidate;
    }

    /**
    * @description 
    * @author Ankit Majee | 08-05-2025 
    * @return Candidate__c 
    **/
    public static Candidate__c createCandidateWithoutEmail() {
        Candidate__c candidate = new Candidate__c(
            First_Name__c = 'Jane5',
            Last_Name__c = 'Doe6',
            Email__c = null
        );
        return candidate;
    }

    /**
    * @description 
    * @author Ankit Majee | 08-05-2025 
    * @param count 
    * @return List<Candidate__c> 
    **/
    public static List<Candidate__c> createBulkCandidates(Integer count) {
        List<Candidate__c> bulkCandidates = new List<Candidate__c>();
        for (Integer place = 0; place < count; place++) {
            bulkCandidates.add(new Candidate__c(
                First_Name__c = 'BulkFirst' + place,
                Last_Name__c = 'BulkLast' + place,
                Email__c = 'bulk' + place + '@example.com'
            ));
        }
        return bulkCandidates;
    }
}
