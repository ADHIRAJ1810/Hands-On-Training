public with sharing class TriggerDonationHelperHandler
{
    public static List<Installment_Manager__c> installmentList = new List<Installment_Manager__c>();
    public static Integer dateIncreament = 0;

    public static List<Id> opportunityIdList = new List<Id>();
    public static List<Opportunity> newChildDonationList = new List<Opportunity>();


    public static void createDonationInstallment(List<Opportunity> newDonationList)
    {
        System.debug('Trigger New List : ' + newDonationList);

        for (Opportunity opportunityInstance : newDonationList)
        {
            if(opportunityInstance.Amount > 0 || opportunityInstance.Amount!=null)
            {
                if (opportunityInstance.Payment_Frequency__c == 'Monthly')
                {
                    for(Integer iterator =0;iterator < opportunityInstance.number_of_installments__c ; iterator++)
                    {
                        Installment_Manager__c singleInstallment = new Installment_Manager__c();
                        singleInstallment.Donation_Manager__c = opportunityInstance.Id;
                        singleInstallment.Installment_Date__c = opportunityInstance.CloseDate.addMonths(0+dateIncreament);
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
                        singleInstallment.Installment_Date__c = opportunityInstance.CloseDate.addMonths(0+dateIncreament);
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
                        singleInstallment.Installment_Date__c = opportunityInstance.CloseDate.addMonths(0+dateIncreament);
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
                        singleInstallment.Installment_Date__c = opportunityInstance.CloseDate;
                        singleInstallment.Installment_Amount__c = opportunityInstance.Amount_per_Installment__c;
                        installmentList.add(singleInstallment);
                    }
                }
            }
            else
            {
                System.debug('Debug for Amount =0 || Null ');
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

    public static void createInstallmentForUpdatedAmount(Map<Id,Opportunity> oldTriggerMap,Map<Id,Opportunity> newTriggerMap)
    {
        for(Id opportunityId : newTriggerMap.keySet())
        {
            Opportunity oldOpportunityObject = oldTriggerMap.get(opportunityId);
            Opportunity newOpportunityObject = newTriggerMap.get(opportunityId);

            if(newOpportunityObject.Amount != oldOpportunityObject.Amount || 
            newOpportunityObject.Payment_Frequency__c != oldOpportunityObject.Payment_Frequency__c ||
            newOpportunityObject.Years__c != oldOpportunityObject.Years__c)
            {
                opportunityIdList.add(opportunityId);
                newChildDonationList.add(newOpportunityObject);
            }
        }
        System.debug(newChildDonationList);
        List<Installment_Manager__c> installmentsDeleteList  = [
                                                                  SELECT Id, Donation_Manager__c 
                                                                  FROM Installment_Manager__c 
                                                                  WHERE Donation_Manager__c IN :opportunityIdList
                                                                ];

        if ( !installmentsDeleteList.isEmpty() ) 
        {
           System.debug(installmentsDeleteList);
           Database.delete(installmentsDeleteList);
           TriggerDonationHelperHandler.createDonationInstallment(newChildDonationList);
           System.debug(newChildDonationList);
        }
        else
        {
           TriggerDonationHelperHandler.createDonationInstallment(newChildDonationList);
           System.debug(newChildDonationList);
        }
    }
}
