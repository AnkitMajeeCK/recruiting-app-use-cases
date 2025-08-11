/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-10-2025
 * @last modified by  : Ankit Majee
**/
public with sharing class JobPostingController {
    /**
    * @description 
    * @author Ankit Majee | 07-30-2025 
    * @return List<Position__c> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Position__c> getActiveJobPostings() {
        try {
            // Query active Position__c records
            List<Position__c> jobPostings = [
                SELECT Id, Name, Location__c, Functional_Area__c, Number_of_Open_Position__c, Open_Date__c 
                FROM Position__c 
                WHERE Status__c = 'Active'
                WITH USER_MODE
                LIMIT 100
            ];
            return jobPostings;
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching job postings: ' + e.getMessage());
        }
    }
}