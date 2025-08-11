/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 07-24-2025
 * @last modified by  : Ankit Majee
**/
trigger CandidateResumeGeneratorTrigger on Candidate__c (after update) {
    new CandidateResumeGeneratorHandler().execute();
}