/**
 * @File Name          : TriggerDonationHelper.cls
 * @Description        : Helper Class To call Methods based on Trigger events.
 * @Author             : Adhiraj N B
 * @Group              : 
 * @Last Modified By   : Adhiraj N B
 * @Last Modified On   : 10/4/2019, 10:17:40 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/4/2019   Adhiraj N B     Initial Version
**/
public with sharing class TriggerDonationHelper 
{
    /**
    * @description :Invoking method for afterInsert
    * @author Adhiraj N B | 10/4/2019 
    * @param newDonationList 
    * @return void 
    **/
    public static void isAfterInsertMethod(List<Opportunity> newDonationList)
    {
        TriggerDonationHelperHandler.createDonationInstallment(newDonationList);
    }

    /**
    * @description :Invoking method for afterUpdate
    * @author Adhiraj N B | 10/4/2019 
    * @param oldTriggerMap 
    * @param newTriggerMap 
    * @return void 
    **/
    public static void isAfterUpdateMethod(Map<Id,Opportunity> oldTriggerMap,Map<Id,Opportunity> newTriggerMap)
    {
        TriggerDonationHelperHandler.createInstallmentForUpdatedAmount(oldTriggerMap,newTriggerMap);
    }
}
