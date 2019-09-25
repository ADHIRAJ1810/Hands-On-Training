public with sharing class TriggerDonationHelper 
{
    public static void isAfterInsertMethod(List<Opportunity> newDonationList)
    {
        TriggerDonationHelperHandler.createDonationInstallment(newDonationList);
    }

    public static void isAfterUpdateMethod(Map<Id,Opportunity> oldTriggerMap,Map<Id,Opportunity> newTriggerMap)
    {
        TriggerDonationHelperHandler.createInstallmentForUpdatedAmount(oldTriggerMap,newTriggerMap);
    }
}
