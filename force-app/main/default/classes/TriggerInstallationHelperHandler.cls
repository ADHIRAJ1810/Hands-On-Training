public with sharing class TriggerInstallationHelperHandler 
{
    public List<Id> parentIdList = new List<Id>();

    public static void updateDonationStatus(List<Installment_Manager__c> installationList)
    {
        for (Installment_Manager__c installmentInstance : installationList) 
        {
            parentIdList.add(installmentInstance.Donation_Manager__c);
        }

        Set<Opportunity> donationToUpdateSet = new Set<Opportunity>[SELECT Id,StageName FROM Opportunity WHERE Id = :parentIdList ]

        Set<Installment_Manager__c> installmentSet = new Set<Installment_Manager__c>;

        for(Opportunity opportunityInstace : donationToUpdateSet)
        {
            
        }
    }
}
