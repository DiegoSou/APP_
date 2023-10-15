/**
 * Ordered handler class
 */

public class SecondAccountBeforeInsertHandler implements APP_ITriggerHandler
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
            System.debug('Second use case for ' + acc.Name);
        }
    }
}