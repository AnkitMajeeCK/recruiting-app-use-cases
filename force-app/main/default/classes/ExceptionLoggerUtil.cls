/**
 * @description       : Utility to log exceptions into Exception_Log__c for batch jobs and other flows.
 * @author            : Ankit Majee
 * @last modified on  : 08-03-2025
 * @last modified by  : Ankit Majee
**/
public class ExceptionLoggerUtil {

    /**
     * @description Logs an exception to the Exception_Log__c custom object.
     * @param ex The exception that occurred.
     * @param flowName The name of the batch class or flow where the exception occurred.
     * @param relatedRecordId (Optional) ID of the related record if applicable.
     */
    public static void logExceptionBatchClass(Exception ex, String flowName, String relatedRecordId) {
        if (ex == null || String.isBlank(flowName)) {
            return;
        }

        Exception_Log__c log = new Exception_Log__c();
        log.Exception_Message__c = sanitizeMessage(ex.getMessage());
        log.Flow_Name__c = flowName;
        log.Related_Record_Id__c = relatedRecordId;
        log.Start_Time__c = System.now();
        log.Timestamp__c = System.now();
        log.Status__c = 'Failed';
        log.User__c = UserInfo.getUserId();

        try {
            Database.insert(log, AccessLevel.USER_MODE);
        } catch (Exception ignore) {
            throw ignore;
        }
    }

    
    /**
    * @description 
    * @author Ankit Majee | 08-03-2025 
    * @param msg 
    * @return String 
    **/
    private static String sanitizeMessage(String msg) {
        if (String.isBlank(msg)) {
            return 'No message provided';
        }
        return msg.length() > 255 ? msg.substring(0, 255) : msg;
    }
}