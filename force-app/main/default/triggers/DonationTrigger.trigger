trigger DonationTrigger on Opportunity (after update,after insert) 
{
    if (Trigger.isAfter) 
    {
        if( Trigger.isInsert )
        {
            //Passing the new Donations Created
            TriggerDonationHelper.isAfterInsertMethod(Trigger.new);
        }

        if (Trigger.isUpdate) 
        {
            TriggerDonationHelper.isAfterUpdateMethod(Trigger.oldMap,Trigger.newMap);
        }
    }

}