/**
 * @description       : Apex trigger handler class for the Candidate__c object. This class handles logic after candidate records are updated.
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-10-2025
 * @last modified by  : Ankit Majee
**/
public with sharing class CandidateResumeGeneratorHandler extends ExtendedTriggerHandler {
    List<Candidate__c> candidates = new List<Candidate__c>();
    Map<Id, Candidate__c> candidateOldMap = new Map<Id, Candidate__c>();

    /**
    * @description when the class is called the constructor is called 1st automatically and candidate new and old records are fetched.
    * @author Ankit Majee | 07-25-2025 
    **/
    public CandidateResumeGeneratorHandler() {
        this.candidates = (List<Candidate__c>) Trigger.new;
        this.candidateOldMap = (Map<Id, Candidate__c>) Trigger.oldMap;
    }

    public override void afterUpdate() {
        checkCandidateCurrentStatus();
    }

    /**
    * @description Specifically, it detects when a candidate's status changes to 'Selected for Interview' and enqueues a queueable job to generate resumes for such candidates.
    * @author Ankit Majee | 07-25-2025 
    **/
    public void checkCandidateCurrentStatus() {
        List<Candidate__c> statusChangedCandidates = new List<Candidate__c>();

        for (Candidate__c newCandidate : candidates) {
            Candidate__c oldCandidate = candidateOldMap.get(newCandidate.Id);

            if (oldCandidate.Status__c != newCandidate.Status__c &&
                newCandidate.Status__c == 'Selected for Interview') {
                statusChangedCandidates.add(newCandidate);
            }
        }

        if (!statusChangedCandidates.isEmpty()) {
            try{
                List<Id> candidateIds = new List<Id>();
                for(Candidate__c candidate : statusChangedCandidates){
                    candidateIds.add(candidate.Id);
                }
                System.enqueueJob(new ResumeGenerationQueueable(candidateIds));
            } catch(Exception ErrorLog){
                logException(ErrorLog);
            }
            
        }
    }

    /**
    * @description Helper method to log exceptions into custom Exception_Log__c object.
    * @author Ankit Majee | 08-10-2025 
    * @param error 
    **/
    private static void logException(Exception error) {
        Exception_Log__c log = new Exception_Log__c();
        log.Exception_Message__c = error.getMessage();
        log.Status__c = 'Error';
        log.Start_Time__c = System.now();
        log.OwnerId = UserInfo.getUserId();
        Database.insert(log, true,AccessLevel.USER_MODE);
    }
}