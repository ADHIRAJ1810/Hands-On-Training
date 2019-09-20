trigger DonationTrigger on Opportunity (after insert) 
{
    if (Trigger.isAfter) 
    {
        if( Trigger.isInsert )
        {
            //Passing the new Donations Created
            TriggerDonationHelper.isAfterInsertMethod(Trigger.new);
        }
    }
}