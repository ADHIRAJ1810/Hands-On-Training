public with sharing class TriggerDonationHelperHandler
{
    public static List<Installment_Manager__c> installmentList = new List<Installment_Manager__c>();
    public static Integer dateIncreament = 0;

    public static void createInstallmentCall( Installment_Manager__c singleInstallment, Id parameterId,Date parameterDate,
                                              Decimal parameterAmount,Integer dateCount, Decimal installmentCount)
    {
        for(Integer iterator =0; iterator <installmentCount; iterator++)
        {
            singleInstallment.Donation_Manager__c = parameterId;
            singleInstallment.Installment_Date__c = parameterDate.addMonths( 0 + dateCount);
            singleInstallment.Installment_Amount__c = parameterAmount;
            installmentList.add(singleInstallment);
            dateCount = dateCount;
        }
    }

        public static void createDonationInstallment(List<Opportunity> newDonationList)
        {
            Installment_Manager__c singleInstallment;

            for (Opportunity opportunityInstance : newDonationList)
            {
                if(opportunityInstance.Amount > 0 || opportunityInstance.Amount!=null)
                {
                    if (opportunityInstance.Payment_Frequency__c == 'Monthly')
                    {
                        dateIncreament = 0;

                        TriggerDonationHelperHandler.createInstallmentCall(singleInstallment = new Installment_Manager__c(),opportunityInstance.Id,
                        opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,(dateIncreament+1),
                        opportunityInstance.number_of_installments__c);
                    }
                    else if(opportunityInstance.Payment_Frequency__c == 'Quarterly')
                    {
                       dateIncreament = 0;

                       TriggerDonationHelperHandler.createInstallmentCall(singleInstallment = new Installment_Manager__c(), opportunityInstance.Id,
                       opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,dateIncreament+3,opportunityInstance.number_of_installments__c);
                    }
                    else if(opportunityInstance.Payment_Frequency__c == 'Half Yearly')
                    {
                       dateIncreament = 0;

                       TriggerDonationHelperHandler.createInstallmentCall( singleInstallment = new Installment_Manager__c(), opportunityInstance.Id,
                       opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,dateIncreament+6,opportunityInstance.number_of_installments__c);

                    }
                    else
                    {
                        TriggerDonationHelperHandler.createInstallmentCall(singleInstallment, opportunityInstance.Id,
                        opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,0,opportunityInstance.number_of_installments__c);
                    }
                }
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
                    System.debug('Before Insert installment list '+installmentList);
                    Database.insert(installmentList);
                    System.debug('After Insert installment list '+installmentList);
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
            if( (newTriggerMap.get(opportunityId).Amount != oldTriggerMap.get(opportunityId).Amount ||
                newTriggerMap.get(opportunityId).Payment_Frequency__c != oldTriggerMap.get(opportunityId).Payment_Frequency__c ||
                newTriggerMap.get(opportunityId).Years__c != oldTriggerMap.get(opportunityId).Years__c ) &&
                newTriggerMap.get(opportunityId).Complete_all_Installments_at_Once__c == false)
            {
                opportunityIdList.add(opportunityId);
                newChildDonationList.add(newTriggerMap.get(opportunityId));
            }

            else if( (newTriggerMap.get(opportunityId).Amount == oldTriggerMap.get(opportunityId).Amount ||
                newTriggerMap.get(opportunityId).Payment_Frequency__c == oldTriggerMap.get(opportunityId).Payment_Frequency__c ||
                newTriggerMap.get(opportunityId).Years__c == oldTriggerMap.get(opportunityId).Years__c ) &&
                newTriggerMap.get(opportunityId).Complete_all_Installments_at_Once__c == true)
            {
                completeAllAtOnce.add(opportunityId);
            }
        }

        List<Installment_Manager__c> installmentsDeleteList  = [
                                                                  SELECT Id, Donation_Manager__c
                                                                  FROM Installment_Manager__c
                                                                  WHERE Donation_Manager__c IN :opportunityIdList
                                                                ];

        if ( !installmentsDeleteList.isEmpty() )
        {
           Database.delete(installmentsDeleteList);
           TriggerDonationHelperHandler.createDonationInstallment(newChildDonationList);
        }
        else
        {
           TriggerDonationHelperHandler.createDonationInstallment(newChildDonationList);
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
