public with sharing class TriggerDonationHelperHandler
{
    public static List<Installment_Manager__c> installmentList = new List<Installment_Manager__c>();
    public static Integer dateIncreament = 0;
    public static Boolean flag = false;

    public static void createInstallmentCall( Id parameterId,Date parameterDate,
                                              Decimal parameterAmount,Integer dateCount, Decimal installmentCount)
    {
        for(Integer iterator =0; iterator <installmentCount; iterator++)
        {
            Installment_Manager__c singleInstallment  = new Installment_Manager__c() ;
            singleInstallment.Donation_Manager__c = parameterId;
            singleInstallment.Installment_Date__c = parameterDate.addMonths( 0 + dateIncreament);
            singleInstallment.Installment_Amount__c = parameterAmount;
            installmentList.add(singleInstallment);
            dateIncreament = dateIncreament+dateCount;
        }
    }

        public static void createDonationInstallment(List<Opportunity> newDonationList)
        {
            System.debug('Trigger.New Opportunity'+newDonationList);
        
            for (Opportunity opportunityInstance : newDonationList)
            {
                System.debug('26: Counter'+dateIncreament);
                if(opportunityInstance.Amount > 0 || opportunityInstance.Amount!=null)
                {
                System.debug('29:Counter'+dateIncreament);

                    if (opportunityInstance.Payment_Frequency__c == 'Monthly')
                    {
                        // dateIncreament = 0;
                        System.debug('Monthly debug'+opportunityInstance.Payment_Frequency__c);
                        TriggerDonationHelperHandler.createInstallmentCall(opportunityInstance.Id,
                        opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,(1),
                        opportunityInstance.number_of_installments__c);
                    }
                    else if(opportunityInstance.Payment_Frequency__c == 'Quarterly')
                    {
                    //    dateIncreament = 0;
                        System.debug('Quarterly debug'+opportunityInstance.Payment_Frequency__c);

                       TriggerDonationHelperHandler.createInstallmentCall( opportunityInstance.Id,
                       opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,3,opportunityInstance.number_of_installments__c);
                    }
                    else if(opportunityInstance.Payment_Frequency__c == 'Half Yearly')
                    {
                    //    dateIncreament = 0;
                        System.debug('Half Yearly debug'+opportunityInstance.Payment_Frequency__c);

                       TriggerDonationHelperHandler.createInstallmentCall(  opportunityInstance.Id,
                       opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,6,opportunityInstance.number_of_installments__c);

                    }
                    else
                    {
                        System.debug('One time debug ' +opportunityInstance);
                        TriggerDonationHelperHandler.createInstallmentCall( opportunityInstance.Id,
                        opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,0,opportunityInstance.number_of_installments__c);
                    }

                System.debug('63 :Counter'+dateIncreament);}

                else
                {
                    System.debug('Debug for Amount =0 || Null ');
                }
            }
            
            //Try to insert InstallmentList if Installment not Debug Exception.
            try
            {
                if (installmentList.size() > 0 || installmentList != Null )
                {
                    System.debug('75:Before Insert installment list '+installmentList);
                    flag =true;
                    
                    insert installmentList;
                    
                    System.debug('77:After Insert installment list '+installmentList);
                }
            }
            catch (Exception ex)
            {
                System.debug('Exception--- ' + ex);
            }
        }

    public static void createInstallmentForUpdatedAmount(Map<Id,Opportunity> oldTriggerMap,Map<Id,Opportunity> newTriggerMap)
    {
        List<Id> opportunityIdList = new List<Id>();
        List<Id> completeAllAtOnce = new List<Id>();

        List<Opportunity> newChildDonationList = new List<Opportunity>();

        for(Id opportunityId : newTriggerMap.keySet())
        {
            if( newTriggerMap.get(opportunityId).Complete_all_Installments_at_Once__c == true)
            {
                completeAllAtOnce.add(opportunityId);
            }
        }

        List<Installment_Manager__c> installmentsUpdateList  = [
                                                                SELECT Id,
                                                                       Donation_Manager__c,
                                                                       Amount_Paid__c,
                                                                       Paid_Amount__c,
                                                                       Installment_Status__c,
                                                                       Installment_Amount__c
                                                                FROM Installment_Manager__c
                                                                WHERE (Donation_Manager__c IN :completeAllAtOnce)
                                                                AND   (Installment_Status__c IN ('Pending' ,'Open') )
                                                                ];

        if (!installmentsUpdateList.isEmpty())
        {
            TriggerDonationHelperHandler.updateInstallmentAtOnce(installmentsUpdateList);
        }
}

    public static void updateInstallmentAtOnce(List<Installment_Manager__c> installmentsUpdateList)
    {
        List<Installment_Manager__c> updatedInstallmentList = new List<Installment_Manager__c>();

        for (Installment_Manager__c installmentIterator : installmentsUpdateList)
        {
            installmentIterator.Paid_Amount__c = installmentIterator.Installment_Amount__c;
            installmentIterator.Amount_Paid__c = true;
            updatedInstallmentList.add(installmentIterator);
        }

        Database.update(updatedInstallmentList);
    }
}
