/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-03-2025
 * @last modified by  : Ankit Majee
**/
global with sharing class JobApplicationStatusUpdateScheduler implements Schedulable {
    
    
    /**
    * @description 
    * @author Ankit Majee | 08-03-2025 
    * @param sc 
    **/
    global void execute(SchedulableContext sc) {
        ApplicantStatusUpdateBatch batchJob = new ApplicantStatusUpdateBatch();
        Database.executeBatch(batchJob, 200);
    }
    
}