/**
* @description       : Test class for CandidateTriggerHandler logic
* @author            : Ankit Majee
* @last modified on  : 08-06-2025
* @last modified by  : Ankit Majee
**/
@isTest
public with sharing class CandidateWelcomeEmailTriggerHandlerTest {

    @TestSetup
    static void makeData() {
        User adminUser = WelcomeEmailHelper.createSystemAdmin();
        insert adminUser;

        User restrictedUser = WelcomeEmailHelper.createStandardUser();
        insert restrictedUser;
    }

    @isTest
    static void testWelcomeEmailAdmin() {
        Candidate__c candidate = WelcomeEmailHelper.createCandidateWithEmail('john.doe@example.com');
        
        User adminUser = [SELECT Id FROM User WHERE Alias = 'sys44' LIMIT 1];
        System.runAs(adminUser) {
            Test.startTest();
            insert candidate;
            Test.stopTest();
        }

        List<Contact> contactList = [SELECT Id, Email FROM Contact WHERE Email = :candidate.Email__c];
        System.assertEquals(1, contactList.size(), 'Exactly one Contact should be created');
        
        List<EmailMessage> emailMessages = [SELECT ToAddress, Subject FROM EmailMessage WHERE ToAddress = :candidate.Email__c];
        System.assertEquals(1, emailMessages.size(), 'One email should be sent');
        System.assertEquals('Update on your Job Application', emailMessages[0].Subject, 'Email subject should match');
    }


    @isTest
    static void testBulkInsertByAdmin() {
        List<Candidate__c> candidateList = WelcomeEmailHelper.createBulkCandidates(10);
        
        User adminUser = [SELECT Id FROM User WHERE Alias = 'sys44' LIMIT 1];
        System.runAs(adminUser) {
            Test.startTest();
            insert candidateList;
            Test.stopTest();
        }

        List<Contact> contacts = [
            SELECT Id, Email FROM Contact WHERE Email LIKE 'bulk%@example.com'
        ];
        System.assertEquals(10, contacts.size(), '10 Contacts should be created for bulk candidates');
        
        List<EmailMessage> emails = [
            SELECT Id, ToAddress, Subject FROM EmailMessage WHERE ToAddress LIKE 'bulk%@example.com'
        ];
        System.assertEquals(10, emails.size(), '10 welcome emails should be sent');
        
        for (EmailMessage email : emails) {
            System.assertEquals('Update on your Job Application', email.Subject, 'Each email should have correct subject');
        }
    }

    @isTest
    static void testAdminUserWithoutEmail() {
        Candidate__c candidate = WelcomeEmailHelper.createCandidateWithoutEmail();
        
        Boolean exceptionThrown = false;
        User adminUser = [SELECT Id FROM User WHERE Alias = 'sys44' LIMIT 1];
        System.runAs(adminUser) {
            Test.startTest();
            try {
                insert candidate;
            } catch (DmlException e) {
                exceptionThrown = true;
            }
            Test.stopTest();
        }

        System.assertEquals(true, exceptionThrown, 'Insert should fail when Email__c is null');
    }

    @isTest
    static void testStandardUserWithEmail() {
        Candidate__c candidate = WelcomeEmailHelper.createCandidateWithEmail('restricted.user@example.com');
        
        User restrictedUser = [SELECT Id FROM User WHERE Alias = 'std6545' LIMIT 1];
        
        Boolean exceptionThrown = false;
        System.runAs(restrictedUser) {
            Test.startTest();
            try {
                insert candidate;
            } catch (DmlException e) {
                exceptionThrown = true;
            }
            Test.stopTest();
        }

        System.assertEquals(true, exceptionThrown, 'Candidate should not have access');
    }
}
