/**
 * @description       : This is the test class of Job Posting Controller
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-05-2025
 * @last modified by  : Ankit Majee
**/
@isTest
public class JobPostingControllerTest {
    
    @isTest
    static void testFetchActiveJobsAdminProfile() {
        JobPostingTestHelper.createMockJobPostings();
        User adminUser = JobPostingTestHelper.createSysAdminUser();
        insert adminUser;


        System.runAs(adminUser) {

            List<Position__c> fetchedJobPostings = JobPostingController.getActiveJobPostings();
            
            System.assertEquals(1, fetchedJobPostings.size(), 'There should be 1 active job posting');
            System.assertEquals('Active Job 1', fetchedJobPostings[0].Name, 'The job posting should be "Active Job 1"');
        }
    }
    
    @isTest
    static void testFetchActiveJobsStandardUserProfile() {
        JobPostingTestHelper.createMockJobPostings(); 
        User standardUser = JobPostingTestHelper.createStandardUser();
        insert standardUser;


        System.runAs(standardUser) {
            try {
                List<Position__c> fetchedJobPostings = JobPostingController.getActiveJobPostings();
                System.assertEquals(0, fetchedJobPostings.size(), 'Standard user should not have read access to job postings');
            } catch (Exception e) {
                System.assert(true, 'An exception was thrown, confirming lack of access to Position__c.');
                System.assert(e instanceof System.AuraHandledException, 'Expected an AuraHandledException.');
            }
        }
    }
    
    @isTest
    static void testFetchInactiveJobsAdminProfile() {
        JobPostingTestHelper.createMockJobPostings();
        User adminUser = JobPostingTestHelper.createSysAdminUser();
        insert adminUser;

        System.runAs(adminUser) {
            List<Position__c> fetchedJobPostings = JobPostingController.getActiveJobPostings();
            System.assertEquals(1, fetchedJobPostings.size(), 'There should be only 1 active job posting');
            System.assertNotEquals('Inactive Job 1', fetchedJobPostings[0].Name, 'Inactive jobs should not be included');
        }
    }
}
