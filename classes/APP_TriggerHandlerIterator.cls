/**
 * Manage lists of trigger handlers
 * 
 * Intentionally virtual, so you can extend funcionallity to debug by index
 * of some stuff like that
 */

public virtual class APP_TriggerHandlerIterator implements Iterator<APP_ITriggerHandler>
{
    /**
     * index of current handler
     */
    private Integer currentIndex = 0;
    
    /**
     * private handlers
     */
    private List<APP_ITriggerHandler> handlers = new List<APP_ITriggerHandler>();
    
    /**
     * has next handler
     */
    public Boolean hasNext()
    {
        return currentIndex < handlers.size();
   	}    
 
    /**
     * get next handler
     */
    public APP_ITriggerHandler next()
    {
        if(hasNext()) 
        {
            return handlers[currentIndex++];
        }
  
        System.debug('Current handler index: ' + currentIndex);
        return null;
    }
    
    /**
     * add new handler
     */
    public void add(APP_ITriggerHandler handlerInstance)
    {
		this.handlers.add(handlerInstance);   
    }
}