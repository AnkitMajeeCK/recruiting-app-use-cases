/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-10-2025
 * @last modified by  : Ankit Majee
**/
global class ApplicantStatusUpdateBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    private List<Job_Interview_Scheduling_Metadata__mdt> activeRules;

    /**
    * @description 
    * @author Ankit Majee | 08-04-2025 
    **/
    global ApplicantStatusUpdateBatch() {
        Map<String, Job_Interview_Scheduling_Metadata__mdt> allRules = Job_Interview_Scheduling_Metadata__mdt.getAll();
        this.activeRules = new List<Job_Interview_Scheduling_Metadata__mdt>();
        for (Job_Interview_Scheduling_Metadata__mdt rule : allRules.values()) {
            if (rule.Active__c == true) {
                activeRules.add(rule);
            }
        }
    }

    /**
    * @description 
    * @author Ankit Majee | 08-04-2025 
    * @param bc 
    * @return Database.QueryLocator 
    **/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Status__c, Last_Activity_Date__c, Last_Interview_Date__c, Candidate_no_longer_interested__c ' +
            'FROM Job_Application__c ' +
            'WHERE Status__c NOT IN (\'Withdrawn\', \'Inactive\', \'Not Selected\')'
        );
    }

    /**
    * @description 
    * @author Ankit Majee | 08-04-2025 
    * @param bc 
    * @param scope 
    **/
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Job_Application__c> appsToUpdate = new List<Job_Application__c>();

        for (SObject sObj : scope) {
            Job_Application__c app = (Job_Application__c)sObj;

            // Delegate to handler
            Job_Application__c updatedApp = ApplicantStatusUpdateHandler.processApplication(app, activeRules);

            if (updatedApp != null) {
                appsToUpdate.add(updatedApp);
            }
        }

        if (!appsToUpdate.isEmpty()) {
            try {
                Database.update(appsToUpdate,true,AccessLevel.USER_MODE);
                //update appsToUpdate;
            } catch (DmlException e) {
                ExceptionLoggerUtil.logExceptionBatchClass(e, 'ApplicantStatusUpdateBatch.execute', null);
            }
        }
    }

    /**
    * @description 
    * @author Ankit Majee | 08-04-2025 
    * @param bc 
    **/
    public void finish(Database.BatchableContext bc) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{'ankit.majee@cloudkaptan.com'});
            mail.setSubject('Job Application Status Update Batch Job Completed');
            mail.setPlainTextBody('The Job Application Status Update Batch job has completed successfully.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        } catch (Exception e) {
            ExceptionLoggerUtil.logExceptionBatchClass(e, 'ApplicantStatusUpdateBatch.finish', null);
        }
    }


    /**
    * @description Schedule this batch to run every Monday at 10 AM
    * @author Ankit Majee | 08-04-2025 
    * @param sc 
    **/
    public void execute(SchedulableContext sc) {
    String cronExp = '0 0 10 ? * MON';
    
    System.schedule('Applicant Status Update Job', cronExp, new ApplicantStatusUpdateBatch());
}
}
