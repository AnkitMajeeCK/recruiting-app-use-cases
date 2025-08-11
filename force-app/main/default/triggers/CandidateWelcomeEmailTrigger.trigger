/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 07-23-2025
 * @last modified by  : Ankit Majee
**/
trigger CandidateWelcomeEmailTrigger on Candidate__c (after insert) {
    new CandidateWelcomeEmailTriggerHandler().execute();
}
