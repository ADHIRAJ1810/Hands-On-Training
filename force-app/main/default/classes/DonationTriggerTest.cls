@isTest
public with sharing class DonationTriggerTest 
{
    public static Integer numberOfDonations =5;

    @isTest
    public static void createDonation()
    {
        
        System.Test.startTest();
        List<Opportunity> donationList = TestDataFactory.generateDonation();
		List<Installment_Manager__c> installmentList = [ 
                                                        SELECT  Id,
                                                                Donation_Manager__c
                                                        FROM    Installment_Manager__c
                                                        WHERE   Installment_Manager__c.Installment_Amount__c =:1000 	
                                                        ];

        System.assertEquals(12,installmentList.size());

        System.Test.stopTest();
    }

    @isTest
    public static void createAndUpdateDonation()
    {
        Decimal updateAmount =200;
        System.Test.startTest();

        List<Opportunity> donationList = TestDataFactory.generateDonation();
        Opportunity newDonation2 = [SELECT Id,Amount,Payment_Frequency__c FROM Opportunity 
                                          WHERE Payment_Frequency__c='Monthly' LIMIT 1];
        newDonation2.Amount = updateAmount;
        newDonation2.Payment_Frequency__c = 'One Time';
        Update newDonation2;

        List<Installment_Manager__c> installmentList = [SELECT  Id,
                                                                Donation_Manager__c
                                                        FROM    Installment_Manager__c
                                                        WHERE   Installment_Manager__c.Installment_Amount__c =:200 	
                                                        ];
     
        System.assertEquals(1,installmentList.size());

        System.Test.stopTest();

    }

    @isTest
    public static void updateAllatOnceDonation()
    {

        Integer updateAmount =500;
        System.Test.startTest();
        List<Opportunity> donationList3 = TestDataFactory.generateDonation();

        List<Opportunity> fetchDonation = [SELECT Id,Amount,Payment_Frequency__c FROM Opportunity 
                                          WHERE Payment_Frequency__c='One Time' LIMIT 1];

        fetchDonation[0].Complete_all_Installments_at_Once__c =true;
        fetchDonation[0].Mass_Donation_Amount__c = updateAmount;
        update fetchDonation;
        
        List<Opportunity> fetchDonation2 = [SELECT Id,Amount FROM Opportunity 
                                           WHERE Mass_Donation_Amount__c = :500];

        System.assertEquals(500,fetchDonation[0].Mass_Donation_Amount__c);
        System.Test.stopTest();
    }
}