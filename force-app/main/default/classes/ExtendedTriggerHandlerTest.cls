/**
 * @description       : This test class is used to provide coverage to the ExtendedTriggerHandler class
 *                      which is used as an extention to the base TriggerHandler class and provide additional functionalities
 * @author            : Mainak Gupta
 * @group             : 
 * @last modified on  : 07-22-2025
 * @last modified by  : Ankit Majee
**/
@isTest
private class ExtendedTriggerHandlerTest {
    private static String triggerActiveState;


    private static ExtendedTriggerHandlerTest.TestEnabledHandler enabledHandler;
    private static ExtendedTriggerHandlerTest.TestDisabledHandler disabledHandler;

    static {
        enabledHandler = new ExtendedTriggerHandlerTest.TestEnabledHandler();
        disabledHandler = new ExtendedTriggerHandlerTest.TestDisabledHandler();
    }

    /**
     * @description       : TestEnabledHandler is a demo class to showcase how to extend the ExtendedTriggerHandler and enable it.
     *                    When enabled, the execute() method gets called.
     *                    It also serves as a good example of how to test the ExtendedTriggerHandler.
     *                    It tests the isTriggerEnabled() and execute() methods.
     *                    It also tests the run() method of the super class.
     * @author            : Mainak Gupta
     * @group             : 
     * @last modified on  : 07-22-2025
     * @last modified by  : Ankit Majee
    **/
    public class TestEnabledHandler extends ExtendedTriggerHandler {        
        public override Boolean isTriggerEnabled() {
            triggerActiveState = 'true';
            return true;
        }
    }

    /**
     * @description       : TestDisabledHandler is a demo class to showcase how to extend the ExtendedTriggerHandler and disable it.
     *                    When disabled, the execute() method does not get called.
     *                    It also serves as a good example of how to test the ExtendedTriggerHandler.
     *                    It tests the isTriggerEnabled() and execute() methods.
     *                    It also tests the run() method of the super class.
     * @author            : Mainak Gupta
     * @group             : 
     * @last modified on  : 07-22-2025
     * @last modified by  : Ankit Majee
    **/
    public class TestDisabledHandler extends ExtendedTriggerHandler {
        public override Boolean isTriggerEnabled() {
            triggerActiveState = 'false';
            return false;
        }
    }

    /**
    * @description : Runs the trigger in the beforeInsertMode (feature of base class TriggerHandler).
    *               The super class runs execute() of the active handler (in this case TestEnabledHandler)
    * @author Mainak Gupta | 08-20-2024 
    * @param handler 
    **/
    private static void beforeInsertMode(ExtendedTriggerHandler handler) {
        handler.setTriggerContext('before insert', true);
        handler.execute();
    }

    /**
    * @description : local variable triggerActiveState is used to toggle state of the trigger.
    *               When triggerActiveState is set to 'true', the execute() method gets called.
    *               It also serves as a good example of how to test the ExtendedTriggerHandler.
    *               It tests the isTriggerEnabled() and execute() methods.
    * @author Mainak Gupta | 08-20-2024 
    **/
    private static void resetTest() {
        triggerActiveState = null;
    }

    @IsTest
    static void checkIfTriggerIsEnabled() {

        System.runAs(new User(Id = UserInfo.getUserId())){
        
            Test.startTest();

            beforeInsertMode(enabledHandler);
            System.assertEquals('true', triggerActiveState, 'ExtendedTriggerHandler: isTriggerEnabled');
            resetTest();
            Test.stopTest();
        }
    }

    @IsTest
    static void checkIfTriggerIsDisabled() {
        
        System.runAs(new User(Id = UserInfo.getUserId())){
            Test.startTest();

            beforeInsertMode(disabledHandler);
            System.assertEquals('false', triggerActiveState, 'ExtendedTriggerHandler: isTriggerDisabled');
            resetTest();
            Test.stopTest();
        }
    }
}