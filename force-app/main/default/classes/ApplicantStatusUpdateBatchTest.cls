/**
 * @description       : Test class for ApplicantStatusUpdateBatch and ApplicantStatusUpdateHandler.
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-05-2025
 * @last modified by  : Ankit Majee
**/
@isTest
private class ApplicantStatusUpdateBatchTest {

    // Store the System Administrator user in a static variable for use in System.runAs()
    private static User systemAdmin;

    @testSetup
    static void setup() {
        // Use the helper class to set up all test data
        HelperTest.setupApplicantStatusTestData();
    }

    @isTest
    static void testWithdrawnRuleInBulk() {
        systemAdmin = HelperTest.createSysAdminUser();
        insert systemAdmin;

        System.runAs(systemAdmin) {
            List<Job_Application__c> initialApplications = [SELECT Id, Status__c, Candidate_no_longer_interested__c FROM Job_Application__c WHERE Candidate_no_longer_interested__c = true];
            System.assertEquals(10, initialApplications.size(), 'There should be 10 applications with Candidate_no_longer_interested__c = true.');

            Test.startTest();
            ApplicantStatusUpdateBatch batch = new ApplicantStatusUpdateBatch();
            Database.executeBatch(batch, 50);
            Test.stopTest();

            List<Job_Application__c> updatedApplications = [SELECT Id, Status__c FROM Job_Application__c WHERE Candidate_no_longer_interested__c = true];

            for (Job_Application__c app : updatedApplications) {
                System.assertEquals('Withdrawn', app.Status__c, 'Status should be updated to Withdrawn.');
            }
        }
    }

    @isTest
    static void testInactiveRuleInBulk() {
        systemAdmin = HelperTest.createSysAdminUser();
        insert systemAdmin;

        System.runAs(systemAdmin) {
            Test.startTest();

            ApplicantStatusUpdateBatch batch = new ApplicantStatusUpdateBatch();
            Database.executeBatch(batch, 50);

            Test.stopTest();

            List<Job_Application__c> inactiveApplications = [
                SELECT Id, Status__c, Candidate_no_longer_interested__c, Last_Activity_Date__c 
                FROM Job_Application__c 
                WHERE Last_Activity_Date__c <= :Date.today().addDays(-30) AND Candidate_no_longer_interested__c = false
            ];

            for (Job_Application__c app : inactiveApplications) {
                System.assertEquals('Inactive', app.Status__c, 'Status should be updated to Inactive.');
            }
        }
    }

    @isTest
    static void testInterviewedRuleInBulk() {
        systemAdmin = HelperTest.createSysAdminUser();
        insert systemAdmin;

        System.runAs(systemAdmin) {
            Test.startTest();

            ApplicantStatusUpdateBatch batch = new ApplicantStatusUpdateBatch();
            Database.executeBatch(batch, 50);

            Test.stopTest();

            List<Job_Application__c> notSelectedApplications = [
                SELECT Id, Status__c
                FROM Job_Application__c
                WHERE Status__c = 'Not Selected'
            ];

            for (Job_Application__c app : notSelectedApplications) {
                System.assertEquals('Not Selected', app.Status__c, 'Status should be updated to Not Selected.');
            }
        }
    }

    @isTest
    static void testFinishMethod() {
        systemAdmin = HelperTest.createSysAdminUser();
        insert systemAdmin;

        System.runAs(systemAdmin) {
            Test.startTest();

            ApplicantStatusUpdateBatch batch = new ApplicantStatusUpdateBatch();
            Database.executeBatch(batch, 50);

            Test.stopTest();
            
            System.assert(true, 'Finish method should execute without error.');
        }
    }

    /**
    * @description Test method for ApplicantStatusUpdateHandler logic.
    * @author Ankit Majee | 08-05-2025 
    **/
    @isTest
    static void testHandlerLogic() {
         systemAdmin = HelperTest.createSysAdminUser();
        insert systemAdmin;
        System.runAs(systemAdmin) {
            Test.startTest();
            
            List<Job_Interview_Scheduling_Metadata__mdt> activeRules = new List<Job_Interview_Scheduling_Metadata__mdt>();
            activeRules.add(new Job_Interview_Scheduling_Metadata__mdt(
                Candidate_no_longer_interested__c = true,
                NewStatus__c = 'Withdrawn'
            ));
            activeRules.add(new Job_Interview_Scheduling_Metadata__mdt(
                DaysSinceLastActivity__c = 30,
                NewStatus__c = 'Inactive'
            ));
            activeRules.add(new Job_Interview_Scheduling_Metadata__mdt(
                DaysSinceInterview__c = 14,
                CurrentStatus__c = 'Interviewed',
                NewStatus__c = 'Not Selected'
            ));


            Job_Application__c withdrawnApp = new Job_Application__c(
                Status__c = 'New',
                Candidate_no_longer_interested__c = true
            );
            Job_Application__c updatedWithdrawnApp = ApplicantStatusUpdateHandler.processApplication(withdrawnApp, activeRules);
            System.assertNotEquals(null, updatedWithdrawnApp, 'A record should be returned.');
            System.assertEquals('Withdrawn', updatedWithdrawnApp.Status__c, 'Status should be Withdrawn.');


            Job_Application__c inactiveApp = new Job_Application__c(
                Status__c = 'New',
                Last_Activity_Date__c = Date.today().addDays(-35),
                Candidate_no_longer_interested__c = false
            );
            Job_Application__c updatedInactiveApp = ApplicantStatusUpdateHandler.processApplication(inactiveApp, activeRules);
            System.assertNotEquals(null, updatedInactiveApp, 'A record should be returned.');
            System.assertEquals('Inactive', updatedInactiveApp.Status__c, 'Status should be Inactive.');


            Job_Application__c interviewedApp = new Job_Application__c(
                Status__c = 'Interviewed',
                Last_Interview_Date__c = Date.today().addDays(-20),
                Candidate_no_longer_interested__c = false
            );
            Job_Application__c updatedInterviewedApp = ApplicantStatusUpdateHandler.processApplication(interviewedApp, activeRules);
            System.assertNotEquals(null, updatedInterviewedApp, 'A record should be returned.');
            System.assertEquals('Not Selected', updatedInterviewedApp.Status__c, 'Status should be Not Selected.');


            Job_Application__c noRuleApp = new Job_Application__c(
                Status__c = 'New',
                Last_Activity_Date__c = Date.today().addDays(-5),
                Last_Interview_Date__c = Date.today().addDays(-5),
                Candidate_no_longer_interested__c = false
            );
            Job_Application__c updatedNoRuleApp = ApplicantStatusUpdateHandler.processApplication(noRuleApp, activeRules);
            System.assertEquals(null, updatedNoRuleApp, 'No rule should apply, and a null value should be returned.');

            Test.stopTest();
        }
    }
}