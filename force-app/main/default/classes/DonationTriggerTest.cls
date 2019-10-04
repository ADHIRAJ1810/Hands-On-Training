/**
 * @File Name          : DonationTriggerTest.cls
 * @Description        : 
 * @Author             : Adhiraj N B
 * @Group              : 
 * @Last Modified By   : Adhiraj N B
 * @Last Modified On   : 10/4/2019, 10:11:28 AM
**/
@isTest
public with sharing class DonationTriggerTest 
{
    public static Integer numberOfDonations =5;
	
	/**
	* @description :Creating Opportunity
	* @author Adhiraj N B | 10/4/2019 
	* @return void 
	**/
	@testSetup static void setup() 
    {
        Opportunity setupOpportunity = new Opportunity();
        setupOpportunity.Name = 'Setup';
        setupOpportunity.StageName='Open';
        setupOpportunity.CloseDate = System.today();
        setupOpportunity.Payment_Frequency__c = 'Half Yearly';
        setupOpportunity.Amount = 6000;
        setupOpportunity.Years__c = 1;
        setupOpportunity.Complete_all_Installments_at_Once__c =false;
        insert setupOpportunity;
    }
    
    
    /**
    * @description : Creating Opportunity through TDF
    * @author Adhiraj N B | 10/4/2019 
    * @return void 
    **/
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

    
    /**
    * @description :Updating the Opportunity from Setup method
    * @author Adhiraj N B | 10/4/2019 
    * @return void 
    **/
    @isTest
    public static void createAndUpdateDonation()
    {
        Decimal updateAmount =200;
        System.Test.startTest();
		
        Opportunity thisOpportunityUpdate = [SELECT Id,Amount,Payment_Frequency__c 
                                             FROM Opportunity
                                             WHERE Name='Setup' LIMIT 1];
        thisOpportunityUpdate.Amount = updateAmount;
        thisOpportunityUpdate.Payment_Frequency__c = 'One Time';
        Update thisOpportunityUpdate;

        List<Installment_Manager__c> installmentList = [SELECT  Id,
                                                                Donation_Manager__c
                                                        FROM    Installment_Manager__c
                                                        WHERE   Installment_Manager__c.Installment_Amount__c =:200 	
                                                        ];
     
        System.assertEquals(1,installmentList.size());

        System.Test.stopTest();

    }


    /**
    * @description :Testing method mass donation
    * @author Adhiraj N B | 10/4/2019 
    * @return void 
    **/
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