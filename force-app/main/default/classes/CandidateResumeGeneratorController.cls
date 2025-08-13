/**
 * @description       : Controller class responsible for generating resume PDF attachments for Candidate__c records.
 *                      Can be used in both Visualforce and backend logic to trigger PDF generation.
 * @author            : Ankit Majee
 * @group             : Recruitment
 * @last modified on  : 08-11-2025
 * @last modified by  : Ankit Majee
**/
public with sharing class CandidateResumeGeneratorController {

    /**
    * @description The Candidate record for which resume is to be generated.
    **/
    public Candidate__c candidate { get; private set; }

    /**
    * @description Constructor for Visualforce StandardController usage.
    * @param stdController The standard controller for the Candidate__c record.
    **/
    public CandidateResumeGeneratorController(ApexPages.StandardController stdController) {
        this.candidate = (Candidate__c)stdController.getRecord();
    }

    /**
    * @description Constructor that accepts a Candidate__c record directly.
    * @param candidate The candidate record to be used in resume generation.
    **/
    public CandidateResumeGeneratorController(Candidate__c candidate) {
        this.candidate = candidate;
    }

    /**
    * @description Generates a resume PDF for the candidate and attaches it to their record.
    **/
    public void generateResumePDFAsAttachment() {
        if (candidate != null && candidate.Id != null) {
            try {
                ResumeGenerationUtility.generateResumePDFAsAttachment(candidate);
            } catch (Exception errorLog) {
                logException(errorLog);
            }
        } else {
            logException(new NullPointerException('Candidate record is null or has no ID. Cannot generate resume.'));
        }
    }

    /**
    * @description Static utility method to generate a resume PDF attachment for a given Candidate__c by ID. 
                    checking for the null in candidateIds and handling exception if found using custom exception log.
    * @param candidateId The Id of the Candidate__c record.
    **/
    public static void generateResumePDFForCandidate(Id candidateId) {
        if (candidateId == null) {
            logException(new NullPointerException('Candidate Id is null. Cannot generate resume.'));
            return;
        }

        try {
            Candidate__c candidateSelected = [
                SELECT Id, First_Name__c, Last_Name__c 
                FROM Candidate__c 
                WHERE Id = :candidateId
                WITH USER_MODE
                LIMIT 1
            ];

            CandidateResumeGeneratorController ctrl = new CandidateResumeGeneratorController(candidateSelected);
            ctrl.generateResumePDFAsAttachment();

        } catch (Exception errorLog) {
            logException(errorLog);
        }
    }

    /**
    * @description Helper method to log exceptions into custom Exception_Log__c object.
    * @param error The exception instance to be logged.
    **/
    private static void logException(Exception error) {
      
            Exception_Log__c log = new Exception_Log__c();
            log.Exception_Message__c = error.getMessage();
            log.Status__c = 'Error';
            log.Start_Time__c = System.now();
            log.OwnerId = UserInfo.getUserId();

            Database.insert(log, true, AccessLevel.USER_MODE);
       
    }
}
