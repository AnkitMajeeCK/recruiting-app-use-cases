/**
 * @description       : Sample Account Trigger which demonstrates how to use the          Trigger-Framework-Extension
 *                      here the execute method lies in the parent class of AccountTriggerHandler which is the ExtendedTriggerHandler
 * @author            : Mainak Gupta
 * @group             : 
 * @last modified on  : 07-23-2025
 * @last modified by  : Ankit Majee
**/
trigger AccountTrigger on Account (before insert, before update,after insert,after update) {
  new AccountTriggerHandler().execute();
}