/**
 * @description       : Handles logic for ApplicantStatusUpdateBatch
 * @author            : Ankit Majee
 * @group             : 
 * @last modified on  : 08-04-2025
 * @last modified by  : Ankit Majee
**/
public class ApplicantStatusUpdateHandler {

    /**
    * @description 
    * @author Ankit Majee | 08-04-2025 
    * @param app 
    * @param activeRules 
    * @return Job_Application__c 
    **/
    public static Job_Application__c processApplication(
        Job_Application__c app,
        List<Job_Interview_Scheduling_Metadata__mdt> activeRules
    ) {
        Date today = Date.today();

        for (Job_Interview_Scheduling_Metadata__mdt rule : activeRules) {
            if (shouldApplyWithdrawnRule(app, rule)) {
                app.Status__c = rule.NewStatus__c;
                return app;
            }
            if (shouldApplyInactiveRule(app, rule, today)) {
                app.Status__c = rule.NewStatus__c;
                return app;
            }
            if (shouldApplyInterviewedRule(app, rule, today)) {
                app.Status__c = rule.NewStatus__c;
                return app;
            }
        }
        return null;
    }

    /**
    * @description 
    * @author Ankit Majee | 08-04-2025 
    * @param app 
    * @param rule 
    * @return Boolean 
    **/
    private static Boolean shouldApplyWithdrawnRule(
        Job_Application__c app,
        Job_Interview_Scheduling_Metadata__mdt rule
    ) {
        return rule.Candidate_no_longer_interested__c && app.Candidate_no_longer_interested__c;
    }

    /**
    * @description 
    * @author Ankit Majee | 08-04-2025 
    * @param app 
    * @param rule 
    * @param today 
    * @return Boolean 
    **/
    private static Boolean shouldApplyInactiveRule(
        Job_Application__c app,
        Job_Interview_Scheduling_Metadata__mdt rule,
        Date today
    ) {
        if (rule.DaysSinceLastActivity__c != null && app.Last_Activity_Date__c != null) {
            Integer daysSinceActivity = app.Last_Activity_Date__c.daysBetween(today);
            return daysSinceActivity >= rule.DaysSinceLastActivity__c;
        }
        return false;
    }

    /**
    * @description 
    * @author Ankit Majee | 08-04-2025 
    * @param app 
    * @param rule 
    * @param today 
    * @return Boolean 
    **/
    private static Boolean shouldApplyInterviewedRule(
        Job_Application__c app,
        Job_Interview_Scheduling_Metadata__mdt rule,
        Date today
    ) {
        if (rule.DaysSinceInterview__c != null &&
            app.Last_Interview_Date__c != null &&
            app.Status__c == 'Interviewed') {
            Integer daysSinceInterview = app.Last_Interview_Date__c.daysBetween(today);
            return daysSinceInterview >= rule.DaysSinceInterview__c;
        }
        return false;
    }
}
