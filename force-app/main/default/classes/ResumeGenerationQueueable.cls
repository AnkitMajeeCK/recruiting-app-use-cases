/**
 * @description       : 
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-05-2025
 * @last modified by  : Ankit Majee
**/
public class ResumeGenerationQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> candidateIds;

    /**
    * @description 
    * @author Ankit Majee | 08-05-2025 
    * @param candidateIds 
    **/
    public ResumeGenerationQueueable(List<Id> candidateIds) {
        this.candidateIds = candidateIds;
    }

    /**
    * @description 
    * @author Ankit Majee | 08-05-2025 
    * @param context 
    **/
    public void execute(QueueableContext context) {
        List<Candidate__c> candidates = [SELECT Id, First_Name__c, Last_Name__c 
                                         FROM Candidate__c 
                                         WHERE Id IN :candidateIds];

        for (Candidate__c candidate : candidates) {
            try {
                // Use the utility class to generate the resume
                ResumeGenerationUtility.generateResumePDFAsAttachment(candidate);
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Error generating resume for Candidate ' + candidate.Id + ': ' + e.getMessage()));
            }
        }
    }
}
