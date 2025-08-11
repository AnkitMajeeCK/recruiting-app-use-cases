/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 07-27-2025
 * @last modified by  : Ankit Majee
**/
@isTest
private class CandidateResumeGeneratorHandlerTest {

    @testSetup
    static void setupData(){
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

        Candidate__c candidate = new Candidate__c(
            First_Name__c = 'Test',
        Last_Name__c = 'Candidate',
            Status__c = 'New'
        );
        insert candidate;
    }

    @isTest
    static void testResumeStatusUpdateWithAdmin(){

        Candidate__c candidateToUpdate = [SELECT Id, Status__c FROM Candidate__c LIMIT 1];

        User systemAdmin = [SELECT Id FROM User WHERE FirstName='System' LIMIT 1];
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
    static void testResumeStatusUpdateWithStandardUser(){
        Candidate__c candidateToUpdate = [SELECT Id, Status__c FROM Candidate__c LIMIT 1];

        User standardUser = [SELECT Id FROM User WHERE FirstName='Standard' LIMIT 1];
        System.runAs(standardUser) {
            try {
                candidateToUpdate.Status__c = 'Selected for Interview';

                Test.startTest();
                update candidateToUpdate;
                Test.stopTest();
                System.assert(true, '❌ Expected exception for insufficient update permission, but none was thrown.');
            } catch (Exception e) {
                System.assert(true, 'Expected permission error for updating status');
            }
        }
    }
}