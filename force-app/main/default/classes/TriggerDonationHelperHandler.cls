/**
 * @File Name          : TriggerDonationHelperHandler.cls
 * @Description        : Actual Logic perfoming for Trigger
 * @Author             : Adhiraj N B
 * @Group              : 
 * @Last Modified By   : Adhiraj N B
 * @Last Modified On   : 10/4/2019, 10:20:35 AM
**/
public with sharing class TriggerDonationHelperHandler
{
    public static List<Installment_Manager__c> installmentList = new List<Installment_Manager__c>();
    public static Integer dateIncreament = 0;
    public static Boolean avoidRecursionFlag = false;

    /**
    * @description : Method Accepting parameters from createDonationInstallment
                    and Creating the Installments.
    * @author Adhiraj N B | 10/4/2019 
    * @param parameterId 
    * @param parameterDate 
    * @param parameterAmount 
    * @param dateCount 
    * @param installmentCount 
    * @return void 
    **/
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

    /**
    * @description : Insertion of Installments in DB.
    * @author Adhiraj N B | 10/4/2019 
    * @param newDonationList 
    * @return void 
    **/
    public static void createDonationInstallment(List<Opportunity> newDonationList)
    {
        avoidRecursionFlag = true;
        //dateIncreament = 0;
        for (Opportunity opportunityInstance : newDonationList)
        {
            if(opportunityInstance.Amount > 0 || opportunityInstance.Amount!=null)
            {
                if (opportunityInstance.Payment_Frequency__c == 'Monthly')
                {
                    TriggerDonationHelperHandler.createInstallmentCall(opportunityInstance.Id,
                    opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,(1),
                    opportunityInstance.number_of_installments__c);
                }
                else if(opportunityInstance.Payment_Frequency__c == 'Quarterly')
                {
                    TriggerDonationHelperHandler.createInstallmentCall( opportunityInstance.Id,
                    opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,3,opportunityInstance.number_of_installments__c);
                }
                else if(opportunityInstance.Payment_Frequency__c == 'Half Yearly')
                {
                    TriggerDonationHelperHandler.createInstallmentCall(  opportunityInstance.Id,
                    opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,6,opportunityInstance.number_of_installments__c);
                }
                else
                {
                    TriggerDonationHelperHandler.createInstallmentCall( opportunityInstance.Id,
                    opportunityInstance.CloseDate,(Decimal)opportunityInstance.Amount_per_Installment__c,0,opportunityInstance.number_of_installments__c);
                }
            }
            else
            {
                System.debug('Debug for Amount =0 || Null ');
            }
        }
        
        //Try to insert InstallmentList if not Debug Exception.
        try
        {
            if (installmentList.size() > 0 || installmentList != Null )
            {
                insert installmentList;
            }
        }
        catch (Exception ex)
        {
            System.debug('Exception--- ' + ex);
        }
    }


    /**
    * @description : For updated data deleting old Installments and Creating new accordingly.
    * @author Adhiraj N B | 10/4/2019 
    * @param oldTriggerMap 
    * @param newTriggerMap 
    * @return void 
    **/
    public static void createInstallmentForUpdatedAmount(Map<Id,Opportunity> oldTriggerMap,Map<Id,Opportunity> newTriggerMap)
    {
        List<Id> completeAllAtOnce = new List<Id>();
        List<Opportunity> newChildDonationList = new List<Opportunity>();
        List<Id> opportunityIdList = new List<Id>();

        if(avoidRecursionFlag == false)
        {
            for(Id opportunityId : newTriggerMap.keySet())
            {
                if( 
              ( newTriggerMap.get(opportunityId).Amount != oldTriggerMap.get(opportunityId).Amount ||
                newTriggerMap.get(opportunityId).Payment_Frequency__c != oldTriggerMap.get(opportunityId).Payment_Frequency__c ||
                newTriggerMap.get(opportunityId).Years__c != oldTriggerMap.get(opportunityId).Years__c ) &&
                newTriggerMap.get(opportunityId).Complete_all_Installments_at_Once__c == false )
                {
                    opportunityIdList.add(opportunityId);
                    newChildDonationList.add(newTriggerMap.get(opportunityId));
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


        }
        else
        {
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


    }


    /**
    * @description : For mass donation Installment should Update Accordingly
    * @author Adhiraj N B | 10/4/2019 
    * @param installmentsUpdateList 
    * @return void 
    **/
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
