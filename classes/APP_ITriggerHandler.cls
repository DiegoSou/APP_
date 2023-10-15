/**
 * Defines a simple handler class which calls single-responsability services to manage records
 */

public interface APP_ITriggerHandler 
{
    /**
     * encapsulates a chained-service tratative for trigger context records  
     */
    void handle();
}