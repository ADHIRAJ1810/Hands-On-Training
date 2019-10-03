@isTest
public with sharing class DonationTriggerTest 
{
    public static Integer numberOfDonations =5;
    public static Integer actualInstallments;
    public static Integer expectedInstallments=10;

    @isTest
    public static void checkInstallmentCount()
    {
        //Create 5 records of Donations
        System.Test.startTest();

        List<Opportunity> newDonationGenerateList = TestDataFactory.generateDonation(numberOfDonations);

        // actualInstallments = TestDataFactory.getInstallmentCount(5000);

        // System.assertEquals(expectedInstallments,actualInstallments);

        System.Test.stopTest();
    }

    @isTest
    public static void updatedInstallmentCountCheck()
    {
        Integer updateAmount =1000;
        System.Test.startTest();

        List<Opportunity> newDonationGenerateList = TestDataFactory.generateDonation(1);
        //TestDataFactory.getInstallmentCount(5000);

        List<Opportunity> updatedDonationList = TestDataFactory.updateDonation(newDonationGenerateList,updateAmount);
        //System.assertEquals(2,TestDataFactory.getInstallmentCount(1000));

        System.Test.stopTest();

    }

    @isTest
    public static void updateAllatOnceCheck()
    {

        Integer updateAmount =1000;
        System.Test.startTest();

        List<Opportunity> newDonationGenerateList = TestDataFactory.generateDonation(1);
        List<Opportunity> newDonationUpdateList = new List<Opportunity>();

        for (Opportunity opportunityInstance: newDonationGenerateList) 
        {
            opportunityInstance.Complete_all_Installments_at_Once__c =true;
            newDonationUpdateList.add(opportunityInstance);
        }

        update newDonationUpdateList;

        System.assertEquals('Completed',newDonationUpdateList[0].StageName);
        System.Test.stopTest();
    }
}
