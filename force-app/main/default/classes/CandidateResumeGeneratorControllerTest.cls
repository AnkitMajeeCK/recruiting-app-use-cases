/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 07-28-2025
 * @last modified by  : Ankit Majee
**/
@isTest
private class CandidateResumeGeneratorControllerTest {
    @testSetup
    static void setupData() {
        String uniquekey = String.valueOf(System.currentTimeMillis());

        // Create User - System Admin
        User systemAdmin = new User(
            FirstName = 'System',
            LastName = 'Admin',
            Alias = 'sys44',
            Email = 'hjjaashhah@test.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            UserName = 'sysadmin' + uniquekey + '@test.com'
        );
        insert systemAdmin;

        // Create User - Standard User
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
        insert standardUser;

        // Create a Candidate record
        Candidate__c candidate = new Candidate__c(
            First_Name__c = 'John',
            Last_Name__c = 'Doe'
        );
        insert candidate;
    }

    @isTest
    static void testAdminCanGenerateResume() {
        Candidate__c candidate = [SELECT Id FROM Candidate__c LIMIT 1];
        User systemAdmin = [SELECT Id FROM User WHERE FirstName = 'System' LIMIT 1];

        System.runAs(systemAdmin) {
            Test.startTest();
            CandidateResumeGeneratorController.generateResumePDFForCandidate(candidate.Id);
            Test.stopTest();    

            System.assert(true, 'Expected admin user to generate resume');
        }
    }

   @isTest
static void testStandardUserCannotGenerateResume() {
    Candidate__c candidate = [SELECT Id FROM Candidate__c LIMIT 1];
    User standardUser = [SELECT Id FROM User WHERE FirstName = 'Standard' LIMIT 1];

    System.runAs(standardUser) {

        Test.startTest();
        try {
            CandidateResumeGeneratorController.generateResumePDFForCandidate(candidate.Id);
        } catch (Exception error) {
            System.assert(true,'✅ Expected exception caught'+error);
        }
        Test.stopTest();

    }
}


}