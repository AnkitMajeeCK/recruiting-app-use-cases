/**
 * @description       : To send email when candidate record is inserted.
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-10-2025
 * @last modified by  : Ankit Majee
 **/

public with sharing class CandidateWelcomeEmailTriggerHandler extends ExtendedTriggerHandler {

    public List<Candidate__c> candidateRecords;

    
    /**
    * @description  when the class is called the constructor is called 1st automatically and candidate records are fetched.
    * @author Ankit Majee | 08-05-2025 
    **/
    public CandidateWelcomeEmailTriggerHandler() {
        this.candidateRecords = Trigger.new;
    }

    public override void afterInsert() {
    List<Contact> newContactList = createContactsFromCandidates(candidateRecords);
    if (!newContactList.isEmpty()) {
        Map<String, String> emailToContactIdMap = insertContactsAndMapEmails(newContactList);
        updateCandidatesWithContactIds(emailToContactIdMap, candidateRecords);
    }
    sendWelcomeEmail(candidateRecords);
    }

    /**
    * @description Method to create contact records from candidate records.
    * @author Ankit Majee | 08-10-2025 
    * @param candidates 
    * @return List<Contact> 
    **/
    private List<Contact> createContactsFromCandidates(List<Candidate__c> candidates) {
        List<Contact> contacts = new List<Contact>();
        for (Candidate__c candidate : candidates) {
            if (String.isNotBlank(candidate.Email__c) && String.isNotBlank(candidate.First_Name__c) && String.isNotBlank(candidate.Last_Name__c)) {
                contacts.add(new Contact(
                    FirstName = candidate.First_Name__c,
                    LastName = candidate.Last_Name__c,
                    Email = candidate.Email__c
                ));
            }
        }
        return contacts;
    }

    /**
    * @description Method to insert contacts and return a map of emails to IDs.
    * @author Ankit Majee | 08-10-2025 
    * @param newContacts 
    * @return Map<String, String> 
    **/
    private Map<String, String> insertContactsAndMapEmails(List<Contact> newContacts) {
        Map<String, String> emailToContactIdMap = new Map<String, String>();
        Database.insert(newContacts, true, AccessLevel.USER_MODE);
        for (Contact contact : newContacts) {
            emailToContactIdMap.put(contact.Email, contact.Id);
        }
        return emailToContactIdMap;
    }

    /**
    * @description Method to update candidate records with contact IDs.
    * @author Ankit Majee | 08-10-2025 
    * @param emailToContactIdMap 
    * @param candidates 
    **/
    private void updateCandidatesWithContactIds(Map<String, String> emailToContactIdMap, List<Candidate__c> candidates) {
        List<Candidate__c> updatedCandidates = new List<Candidate__c>();
        for (Candidate__c candidate : candidates) {
            if (emailToContactIdMap.containsKey(candidate.Email__c)) {
                updatedCandidates.add(new Candidate__c(
                    Id = candidate.Id,
                    Contact__c = emailToContactIdMap.get(candidate.Email__c)
                ));
            }
        }
        if (!updatedCandidates.isEmpty()) {
            Database.update(updatedCandidates, true, AccessLevel.USER_MODE);
        }
    }


    /**
     * @description : Sending Emails Automatically.
     * @param candidateList 
     **/
    private static void sendWelcomeEmail(List<Candidate__c> candidateList) {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> emailTemplateList = getWelcomeEmailTemplate();

        if (emailTemplateList.size() > 0) {
            for (Candidate__c candidate : candidateList) {
                Messaging.SingleEmailMessage email = prepareEmail(candidate, emailTemplateList[0].Id);
                if (email != null) {
                    emailsToSend.add(email);
                }
            }
        }

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }

    /**
     * @description : Template Retrieval and Rendering
     * @return List<EmailTemplate>
     **/
    private static List<EmailTemplate> getWelcomeEmailTemplate() {
        return [
            SELECT Id
            FROM EmailTemplate
            WHERE DeveloperName = 'CandidateWelcomeEmailTemplate'
            WITH SYSTEM_MODE
            LIMIT 1
        ];
    }

    /**
     * @description : Prepare the email based on the candidate and template
     * @param candidate 
     * @param templateId 
     * @return Messaging.SingleEmailMessage
     **/
    private static Messaging.SingleEmailMessage prepareEmail(Candidate__c candidate, Id templateId) {
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(
            templateId,
            candidate.Contact__c,
            candidate.Id
        );

        email.setWhatId(candidate.Id);
        email.setToAddresses(new List<String>{candidate.Email__c});
        email.setTargetObjectId(candidate.Contact__c);
        email.setSaveAsActivity(true);

        return email;
    }
}
