public with sharing class TriggerInstallationHelper 
{
    public static void isAfterUpdateMethod(List<Installment_Manager__c> installationsList)
    {
        TriggerInstallationHelperHandler.updateDonationStatus(installationsList);
    }
}
