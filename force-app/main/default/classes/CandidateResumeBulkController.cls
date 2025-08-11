/**
 * @description       : This is the controller class to handle resume generation in bulk for selected candidates only
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-10-2025
 * @last modified by  : Ankit Majee
**/
public class CandidateResumeBulkController {
    private ApexPages.StandardSetController setCon;
    public List<Candidate__c> selectedCandidates;

    /**
    * @description 
    * @author Ankit Majee | 07-24-2025 
    * @param controller 
    **/
    public CandidateResumeBulkController(ApexPages.StandardSetController controller) {
        this.setCon = controller;
    }
    
    /**
    * @description 
    * @author Ankit Majee | 07-24-2025 
    * @return PageReference 
    **/
    public PageReference generateBulkResumes() {
        try {
            selectedCandidates = (List<Candidate__c>)setCon.getSelected();
            
            if (selectedCandidates != null && !selectedCandidates.isEmpty()) {
                List<Id> candidateIds = new List<Id>();
                for (Candidate__c candidate : selectedCandidates) {
                    candidateIds.add(candidate.Id);
                }

                System.enqueueJob(new ResumeGenerationQueueable(candidateIds));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Resume generation started for selected candidates.'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No candidates selected.'));
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
}