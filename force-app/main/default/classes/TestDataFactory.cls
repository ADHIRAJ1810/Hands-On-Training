@isTest
public class TestDataFactory 
{
    public static String status='Open';
    public static String contactId;
    public static Decimal amountDonate =5000;
    public static String payment_frequency ='Half Yearly';
    public static Integer years =1;
    public static Date donationDate = System.today();
    public static String demoNames ='Test :';

    // Cretating Doantion of Payment frequency Halfyearly with Particular contact with doantion amount 5000.
    public static List<Opportunity> generateDonation(Integer numberOfdonations)
    {
        List<Opportunity> newDonationList = new List<Opportunity>();

        for (Integer iterator =0; iterator<numberOfdonations; iterator ++) 
        {
            Opportunity newDonation = new Opportunity();
            newDonation.Name = demoNames+iterator;
            newDonation.StageName=status;
            newDonation.CloseDate = donationDate;
            newDonation.Amount = amountDonate;
            newDonation.Payment_Frequency__c = payment_frequency;
            newDonation.Years__c = years;
            newDonation.Complete_all_Installments_at_Once__c =false;
            newDonationList.add(newDonation);
        }
        Insert newDonationList;
        return newDonationList;
    }

    public static Integer getInstallmentCount(Decimal amountCheck)
    {
        List<Installment_Manager__c> installmentList = [ 
                                                SELECT  Id,
                                                        Installment_Amount__c
                                                FROM    Installment_Manager__c
                                                WHERE   Installment_Manager__c.Installment_Amount__c =:amountCheck
                                                ];
        System.debug('Installmetn with amount '+amountCheck+'has size:'+installmentList);
        return installmentList.size();
    }

    public static List<Opportunity> updateDonation(List<Opportunity> updateDonationList,Decimal updatedAmount)
    {
        List<Opportunity> updatedOpportunityList = new List<Opportunity>();

        for (Opportunity opportunityObject : updateDonationList) 
        {
           opportunityObject.Amount = updatedAmount;
           opportunityObject.Payment_Frequency__c = 'One Time';
           updatedOpportunityList.add(opportunityObject);
        }
        Update updatedOpportunityList;
        return updatedOpportunityList;
    }

}
