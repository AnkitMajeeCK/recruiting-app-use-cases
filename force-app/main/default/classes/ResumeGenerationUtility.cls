/**
 * @description       : This is the util class to handel the resume generation logic and attachment to candidate records.
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-10-2025
 * @last modified by  : Ankit Majee
**/
public with sharing class ResumeGenerationUtility {

    /**
    * @description Generate resume PDF as attachment and link it to Candidate.
    * @author Ankit Majee | 07-25-2025 
    * @param candidate 
    **/
    public static void generateResumePDFAsAttachment(Candidate__c candidate) {
        try {
            PageReference pdfPage = Page.ResumeGenerator;
            pdfPage.getParameters().put('id', candidate.Id);
            Blob pdfBlob;
            
            // Check if it's running in test context
            if (!Test.isRunningTest()) {
                pdfBlob = pdfPage.getContentAsPDF();
            } else {
                pdfBlob = Blob.valueOf('TEST');
            }

            // Create ContentVersion to save PDF as Salesforce File
            ContentVersion candidateResumeFile = new ContentVersion();
            candidateResumeFile.Title = 'Candidate_Resume_' + candidate.First_Name__c + '_' + candidate.Last_Name__c;
            candidateResumeFile.PathOnClient = candidateResumeFile.Title + '.pdf';  // Required
            candidateResumeFile.VersionData = pdfBlob;
            candidateResumeFile.IsMajorVersion = true;

            // Insert ContentVersion (Salesforce File)
            Database.insert(candidateResumeFile,true,AccessLevel.USER_MODE);

            // Query ContentVersion to get ContentDocumentId
            candidateResumeFile = [SELECT Id, ContentDocumentId 
                                    FROM ContentVersion 
                                    WHERE Id = :candidateResumeFile.Id
                                    WITH SECURITY_ENFORCED
                                    LIMIT 1
                                    ];

            // Create ContentDocumentLink to associate the file with the Candidate record
            ContentDocumentLink candidateDocumentLinking = new ContentDocumentLink();
            candidateDocumentLinking.ContentDocumentId = candidateResumeFile.ContentDocumentId;
            candidateDocumentLinking.LinkedEntityId = candidate.Id;
            candidateDocumentLinking.ShareType = 'V';  // Viewer permission
            candidateDocumentLinking.Visibility = 'AllUsers';
            
            // Insert ContentDocumentLink to link the file to the Candidate
            if (Schema.sObjectType.Candidate__c.isUpdateable()) {
                Database.insert(candidateDocumentLinking,true,AccessLevel.USER_MODE);
            }

        } catch (Exception err) {
            logException(err);
        }
    }

    /**
    * @description Helper method to log exceptions into custom Exception_Log__c object.
    * @author Ankit Majee | 07-25-2025
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
