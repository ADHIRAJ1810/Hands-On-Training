public with sharing class TriggerDonationHelperHandler 
{
    public static List<Installment_Manager__c> installmentList = new List<Installment_Manager__c>();
    public static Integer dateIncreament = 0;

    public static void createDonationInstallment(List<Opportunity> newDonationList)
    {
        System.debug('Trigger New List : ' + newDonationList);

        for (Opportunity opportunityInstance : newDonationList) 
        {
            if (opportunityInstance.Payment_Frequency__c == 'Monthly') 
            {
                for(Integer iterator =0;iterator < opportunityInstance.number_of_installments__c ; iterator++)
                {
                    Installment_Manager__c singleInstallment = new Installment_Manager__c();
                    singleInstallment.Donation_Manager__c = opportunityInstance.Id;
                    singleInstallment.Installment_Date__c = System.today().addMonths(0+dateIncreament);
                    singleInstallment.Installment_Amount__c = opportunityInstance.Amount_per_Installment__c;
                    installmentList.add(singleInstallment);
                    dateIncreament++;
                }
            }
            else if(opportunityInstance.Payment_Frequency__c == 'Quarterly')
            {
                for(Integer iterator =0;iterator < opportunityInstance.number_of_installments__c ; iterator++)
                {
                    Installment_Manager__c singleInstallment = new Installment_Manager__c();
                    singleInstallment.Donation_Manager__c = opportunityInstance.Id;
                    singleInstallment.Installment_Date__c = System.today().addMonths(0+dateIncreament);
                    singleInstallment.Installment_Amount__c = opportunityInstance.Amount_per_Installment__c;
                    installmentList.add(singleInstallment);
                    dateIncreament = dateIncreament+3;
                }

            }
            else if(opportunityInstance.Payment_Frequency__c == 'Half Yearly')
            {
                for(Integer iterator =0;iterator < opportunityInstance.number_of_installments__c ; iterator++)
                {

                    Installment_Manager__c singleInstallment = new Installment_Manager__c();
                    singleInstallment.Donation_Manager__c = opportunityInstance.Id;
                    singleInstallment.Installment_Date__c = System.today().addMonths(0+dateIncreament);
                    singleInstallment.Installment_Amount__c = opportunityInstance.Amount_per_Installment__c;
                    installmentList.add(singleInstallment);
                    dateIncreament = dateIncreament+6;
                }

            }
            else
            {
                for(Integer iterator =0;iterator < opportunityInstance.number_of_installments__c ; iterator++)
                {
                    Installment_Manager__c singleInstallment = new Installment_Manager__c();
                    singleInstallment.Donation_Manager__c = opportunityInstance.Id;
                    singleInstallment.Installment_Date__c = system.today();
                    singleInstallment.Installment_Amount__c = opportunityInstance.Amount_per_Installment__c;
                    installmentList.add(singleInstallment);
                }
            }
        }
        try 
        {
            if (installmentList.size() > 0 || installmentList != Null ) 
            {
                insert(installmentList);
            }
        }
        catch (Exception ex) 
        {
            System.debug('Unfortunately ' +ex+ ' occured ,hence cannot insert');
        }
        
    }
}
