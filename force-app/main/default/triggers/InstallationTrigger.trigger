trigger InstallationTrigger on Installment_Manager__c (after update) 
{
    if (Trigger.isAfter)
    {
        if( Trigger.isUpdate )
        {
            TriggerInstallationHelper.isAfterUpdateMethod(Trigger.old);
        }
    }
}