/**
 * Ordered handler class
 */

public class AccountBeforeInsertHandler implements APP_ITriggerHandler
{
	public void handle()
    {
		List<Account> accountRecords = Trigger.new;
        
        // services
        iterateThrough(accountRecords);
    }

    /**
     * private method to manage records
     */
    private void iterateThrough(List<Account> accountRecords)
    {
        for(Account acc : accountRecords)
        {
            System.debug('First use case for ' + acc.Name);
        }
    }
}