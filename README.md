#Problem Statement:

 Jen wants to donate some amount to a NGO such that she should be able to donate that amount in installments for whatever number of years (like 1 year, 2 years) and by whatever payment frequency (like one-time, quarterly, half-yearly, and monthly) she wants. The installment record should have status (Open, Pending, Completed and so on). Jen should have her contact record and the donation record should be linked to it. The number of installment records depends on the donation year and payment frequency.

Stages on the donation and installment records must be read only on the page to Jen. She should be able to pay that installment in part payments. eg: an installment of $200 can be partly paid twice as $100 / four times as $50. At the time Jen partly paid the amount, the installment should fall in partially completed stage, apart from mentioning remaining amount to be paid by her on it. Main donation records stage name should update accordingly. Also develop a functionality to select all 'Open' installments and complete them at once. An email will be sent to the user mentioning how many installments per donation were completed and the amount donated. eg : Donation Name : No. of installments completed Donation amount : Amount donated Create a report and corresponding dashboard for the donation records mentioning the amount and total number of installments which should be accessible for only standard users 
1. Develop the necessary piece of Apex code to implement a solution for the given problem statement. 
2. Develop the necessary Test code to attain the right code coverage (minimum 90% with all possible use cases). 
3. Ensure it adheres to all development best practices. 






#Set of Assumptions/Restrictions

1. Donor is going to able to negotiate payment frequency/Amount to donate/years before starting doantion only.

2. Donor has to complete installments serially(Datewise).

3. For Mass Donation, user has no installments in cancelled/Partially Completed status.
   If so: complete latest installment then go for mass doantion for remaining.

4. If all installments are pending : Complete Donation is Pending.

5. If user paid certain amount installment/Donation status: Partially Completed
   for ex:- if donor missed nth installment and directly showed up for (n+1)th installment
			he/she has to pay/donate/complete nth installment first

6. Donor cannot mass donate at the time of the First installment.
   in this case Donor is advised to use One time Payment. 

7. Whatever donations NGO is getting are not private all time.

#Precautions

1. For mass donation user has to put carefully due amount in the field.