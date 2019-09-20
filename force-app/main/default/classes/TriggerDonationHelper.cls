public with sharing class TriggerDonationHelper 
{
    public static void isAfterInsertMethod(List<Opportunity> newDonationList)
    {
        TriggerDonationHelperHandler.createDonationInstallment(newDonationList);
    }
}
