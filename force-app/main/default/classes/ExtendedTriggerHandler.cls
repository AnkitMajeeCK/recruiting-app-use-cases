/**
 * @description       : This class demonstrates how to use the ExtendedTriggerHandler class
 *                      which is used as an extention to the base TriggerHandler class and provide additional functionalities
 * @author            : Mainak Gupta
 * @group             : 
 * @last modified on  : 07-23-2025
 * @last modified by  : Ankit Majee
**/
public virtual class ExtendedTriggerHandler extends TriggerHandler{
    /**
    * @description : This method is used to enable/disable the trigger per object. 
    *                For Example, if you want to disable the trigger for Contact object, 
    *                you just need to create a Custom MetaData/ Custom Setting record 
    *                and set value to true.
    * @author Mainak Gupta | 08-22-2024 
    * @return virtual 
    **/
    protected virtual boolean isTriggerEnabled(){
        return true;
    }
    
    /**
    * @description : This method is used to validate whether the trigger is supposed to run or not. 
    *                The logic for this is usually used for managing triggers in production 
    *                activating/deactivating triggers.
    *                This method is executed first before any other validations.
    *                Triggers are supposed to call the execute method in the trigger body via the sobject TriggerHandler which extends this class
    * @author Mainak Gupta | 08-22-2024 
    **/
    public void execute(){
        if(isTriggerEnabled()){
            run();
        }
    }
}