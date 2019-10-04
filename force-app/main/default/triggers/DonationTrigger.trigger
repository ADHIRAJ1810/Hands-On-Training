/**
 * @File Name          : DonationTrigger.trigger
 * @Description        : Fires when Insert and Update Records
 * @Author             : Adhiraj
**/
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