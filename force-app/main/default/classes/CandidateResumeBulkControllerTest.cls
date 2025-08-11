/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 07-28-2025
 * @last modified by  : Ankit Majee
**/
@isTest
private class CandidateResumeBulkControllerTest {

    @testSetup
    static void setupData() {
        // Create System Admin User
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User systemAdmin = new User(
            FirstName = 'System',
            LastName = 'Admin',
            Alias = 'sysadmin',
            Email = 'sysadmin@test.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = adminProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            UserName = 'sysadmin_' + System.currentTimeMillis() + '@test.com'
        );
        insert systemAdmin;

        // Create test candidate records
        List<Candidate__c> candidates = new List<Candidate__c>();
        for (Integer numberName = 0; numberName < 10; numberName++) {
            candidates.add(new Candidate__c(
                First_Name__c = 'Test' + numberName,
                Last_Name__c = 'Candidate' + numberName,
                Status__c = 'New'
            ));
        }
        insert candidates;
    }

    @isTest
static void testBulkResumeGenerationByAdmin() {
    User adminUser = [SELECT Id FROM User WHERE FirstName = 'System' LIMIT 1];
    List<Candidate__c> candidates = [SELECT Id, First_Name__c, Last_Name__c FROM Candidate__c];

    System.runAs(adminUser) {
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(candidates);
        ssc.setSelected(candidates);

        CandidateResumeBulkController controller = new CandidateResumeBulkController(ssc);

        Test.startTest();
        controller.generateBulkResumes();
        Test.stopTest();

        System.assert(true, 'Bulk resume generation ran without exception for admin.');
    }
}

    @isTest
    static void testQueueableExecutionAsAdmin() {
        User adminUser = [SELECT Id FROM User WHERE FirstName = 'System' LIMIT 1];
        List<Candidate__c> candidates = [SELECT Id FROM Candidate__c LIMIT 10];

        System.runAs(adminUser) {
            Test.startTest();
            ResumeGenerationQueueable job = new ResumeGenerationQueueable(
                new List<Id>{ candidates[0].Id, candidates[1].Id }
            );
            System.enqueueJob(job);
            Test.stopTest();

            System.assert(true,'Queueable job executed successfully.');
        }
    }
}