public class TestDataFactory 
/**
* @description :Creating All Possible Opportunities
* @author Adhiraj N B | 10/4/2019 
* @return String 
**/
{
    public static String status='Open';
    public static String contactId;
    public static Decimal amountDonate;
    public static String payment_frequency ='Half Yearly';
    public static Integer years =1;
    public static Date donationDate = System.today();
    public static String demoNames ='Test';
    public static Id saveId;
    public static List<Opportunity> donationList = new List<Opportunity>();

    public static List<Opportunity> generateDonation()
    {
        for(Integer i=0;i<4;i++) 
        {
            Opportunity newDonation = new Opportunity();
            newDonation.Name = demoNames;
            newDonation.StageName=status;
            newDonation.CloseDate = donationDate;
            if(i==0)
            {
	            newDonation.Payment_Frequency__c = payment_frequency;
                newDonation.Amount = 6000;
            }
            else if(i==1)
            {
                newDonation.Payment_Frequency__c = 'Monthly';
                newDonation.Amount = 12000;
            }
            else if(i==2)
            {
                newDonation.Payment_Frequency__c = 'Quarterly';
                newDonation.Amount = 12000;
            }
            else if(i==3)
            {
                newDonation.Payment_Frequency__c = 'One Time';
               	newDonation.Amount = 500; 
            }
            newDonation.Years__c = years;
            newDonation.Complete_all_Installments_at_Once__c =false;
            donationList.add(newDonation);
        }
        insert donationList;        
        return donationList;
    }
}