/**
 * @description       : Sample TriggerHandler to demonstrate the usage of TriggerHandler and ExtendedTriggerHandler
 *                      and their overriden method(s)
 * @author            : Mainak Gupta
 * @group             : 
 * @last modified on  : 07-21-2025
 * @last modified by  : Ankit Majee
**/
public inherited sharing class AccountTriggerHandler extends ExtendedTriggerHandler{
  private final static string ACCOUNT_TRIGGER = 'AccountTrigger';

  private Map<Id, Account> newAccountMap;
  private Map<Id, Account> oldAccountMap;
  private List<Account> newAccountList;
  private List<Account> oldAccountList;

  /**
  * @description : Constructor to typeCast sobject to Account 
  * @author Mainak Gupta | 08-22-2024 
  **/
  public AccountTriggerHandler() {
    this.newAccountMap = (Map<Id, Account>) Trigger.newMap;
    this.oldAccountMap = (Map<Id, Account>) Trigger.newMap;
    this.newAccountList = (List<Account>) Trigger.new;
    this.oldAccountList = (List<Account>) Trigger.old;
  }
  
  /**
  * @description : overriden method to determine whether trigger should run
  * @author Mainak Gupta | 08-22-2024 
  * @return boolean 
  **/
  public override boolean isTriggerEnabled(){
      return sobject_Trigger_Manager__mdt.getInstance(ACCOUNT_TRIGGER).disableTrigger__c == true ?  false : true;
  }

  /**
  * @description : overriden method to determine before Update behaviour
  * @author Mainak Gupta | 08-22-2024 
  **/
  public override void beforeUpdate() {
    for(Account accountItr : this.newAccountMap.values()){
      accountItr.Description = string.valueOf(System.now());
    } 
  }
}