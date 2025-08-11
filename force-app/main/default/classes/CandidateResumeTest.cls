/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-05-2025
 * @last modified by  : Ankit Majee
**/
@isTest
private class CandidateResumeTest {

    @testSetup
    static void setupData() {
        String uniqueKey = String.valueOf(System.currentTimeMillis());

        // Create Users using the helper class
        User systemAdmin = ResumeGeneratorHelper.createSystemAdminUser(uniqueKey);
        User standardUser = ResumeGeneratorHelper.createStandardUser(uniqueKey);

        // Create a Candidate record
        Candidate__c candidate = ResumeGeneratorHelper.createCandidate('John', 'Doe');

        // Create test candidate records for bulk testing
        List<Candidate__c> candidates = ResumeGeneratorHelper.createCandidates(10);
    }

    @isTest
    static void testResumeStatusUpdateWithAdmin() {
        Candidate__c candidateToUpdate = [SELECT Id, Status__c FROM Candidate__c WHERE Last_Name__c = 'Doe' LIMIT 1];
        User systemAdmin = [SELECT Id FROM User WHERE FirstName = 'System' LIMIT 1];

        System.runAs(systemAdmin) {
            candidateToUpdate.Status__c = 'Selected for Interview';

            Test.startTest();
            update candidateToUpdate;
            Test.stopTest();

            Candidate__c updatedCandidate = [SELECT Id, Status__c FROM Candidate__c WHERE Id = :candidateToUpdate.Id];
            System.assertEquals('Selected for Interview', updatedCandidate.Status__c, 'Expected status to be updated to "Selected for Interview"');
        }
    }

    @isTest
    static void testResumeStatusUpdateWithStandardUser() {
        Candidate__c candidateToUpdate = [SELECT Id, Status__c FROM Candidate__c WHERE Last_Name__c = 'Doe' LIMIT 1];
        User standardUser = [SELECT Id FROM User WHERE FirstName = 'Standard' LIMIT 1];

        System.runAs(standardUser) {
            try {
                candidateToUpdate.Status__c = 'Selected for Interview';
                Test.startTest();
                update candidateToUpdate;
                Test.stopTest();
                // If no exception is thrown, the assertion fails
                System.assert(false, 'Expected an exception for insufficient permissions, but none was thrown.');
            } catch (Exception e) {
                // If an exception is caught, the assertion passes
                System.assert(true, 'Expected permission error for updating status: ' + e.getMessage());
            }
        }
    }

    @isTest
    static void testAdminCanGenerateResume() {
        Candidate__c candidate = [SELECT Id FROM Candidate__c WHERE Last_Name__c = 'Doe' LIMIT 1];
        User systemAdmin = [SELECT Id FROM User WHERE FirstName = 'System' LIMIT 1];

        System.runAs(systemAdmin) {
            Test.startTest();
            CandidateResumeGeneratorController.generateResumePDFForCandidate(candidate.Id);
            Test.stopTest();    
            // Assert no exceptions were thrown
            System.assert(true, 'Expected admin user to generate resume without error.');
        }
    }

    @isTest
    static void testStandardUserCannotGenerateResume() {
        Candidate__c candidate = [SELECT Id FROM Candidate__c WHERE Last_Name__c = 'Doe' LIMIT 1];
        User standardUser = [SELECT Id FROM User WHERE FirstName = 'Standard' LIMIT 1];

        System.runAs(standardUser) {
            Test.startTest();
            try {
                CandidateResumeGeneratorController.generateResumePDFForCandidate(candidate.Id);
                // If no exception is thrown, the assertion fails
                System.assert(false, 'Expected an exception for insufficient permissions, but none was thrown.');
            } catch (Exception error) {
                // If an exception is caught, the assertion passes
                System.assert(true, 'Expected exception caught: ' + error.getMessage());
            }
            Test.stopTest();
        }
    }

    @isTest
    static void testBulkResumeGenerationByAdmin() {
        User adminUser = [SELECT Id FROM User WHERE FirstName = 'System' LIMIT 1];
        List<Candidate__c> candidates = [SELECT Id FROM Candidate__c WHERE Last_Name__c != 'Doe'];

        System.runAs(adminUser) {
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(candidates);
            ssc.setSelected(candidates);

            CandidateResumeBulkController controller = new CandidateResumeBulkController(ssc);

            Test.startTest();
            controller.generateBulkResumes();
            Test.stopTest();

            // Assert no exceptions were thrown
            System.assert(true, 'Bulk resume generation ran without exception for admin.');
        }
    }

    @isTest
    static void testQueueableExecutionAsAdmin() {
        User adminUser = [SELECT Id FROM User WHERE FirstName = 'System' LIMIT 1];
        List<Candidate__c> candidates = [SELECT Id FROM Candidate__c WHERE Last_Name__c != 'Doe' LIMIT 2];

        System.runAs(adminUser) {
            Test.startTest();
            ResumeGenerationQueueable job = new ResumeGenerationQueueable(new List<Id>{ candidates[0].Id, candidates[1].Id });
            System.enqueueJob(job);
            Test.stopTest();
            // Assert that the job executed successfully
            System.assert(true, 'Queueable job executed successfully.');
        }
    }
}
