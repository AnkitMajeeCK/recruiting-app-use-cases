/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-05-2025
 * @last modified by  : Ankit Majee
**/
public class ResumeGeneratorHelper {

    /**
    * @description Method to create and return a System Admin User
    * @author Ankit Majee | 08-05-2025 
    * @param uniqueKey 
    * @return User 
    **/
    public static User createSystemAdminUser(String uniqueKey) {
        User systemAdmin = new User(
            FirstName = 'System',
            LastName = 'Admin',
            Alias = 'sys' + uniqueKey.right(3),
            Email = 'sysadmin' + uniqueKey + '@test.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            UserName = 'sysadmin' + uniqueKey + '@test.com'
        );
        insert systemAdmin;
        return systemAdmin;
    }


    /**
    * @description Method to create and return a Standard User
    * @author Ankit Majee | 08-05-2025 
    * @param uniqueKey 
    * @return User 
    **/
    public static User createStandardUser(String uniqueKey) {
        User standardUser = new User(
            FirstName = 'Standard',
            LastName = 'User',
            Alias = 'std' + uniqueKey.right(3),
            Email = 'stduser' + uniqueKey + '@test.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            UserName = 'std' + uniqueKey + '@test.com'
        );
        insert standardUser;
        return standardUser;
    }

    
    /**
    * @description Method to create and return a single Candidate
    * @author Ankit Majee | 08-05-2025 
    * @param firstName 
    * @param lastName 
    * @return Candidate__c 
    **/
    public static Candidate__c createCandidate(String firstName, String lastName) {
        Candidate__c candidate = new Candidate__c(
            First_Name__c = firstName,
            Last_Name__c = lastName,
            Status__c = 'New'
        );
        insert candidate;
        return candidate;
    }

    
    /**
    * @description Method to create and return multiple candidates for bulk testing
    * @author Ankit Majee | 08-05-2025 
    * @param count 
    * @return List<Candidate__c> 
    **/
    public static List<Candidate__c> createCandidates(Integer count) {
        List<Candidate__c> candidates = new List<Candidate__c>();
        for (Integer numberName = 0; numberName < count; numberName++) {
            candidates.add(new Candidate__c(
                First_Name__c = 'Test' + numberName,
                Last_Name__c = 'Candidate' + numberName,
                Status__c = 'New'
            ));
        }
        insert candidates;
        return candidates;
    }
}
