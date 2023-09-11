public virtual without sharing class APP_TriggerHandlerIterator implements Iterator<APP_ITriggerHandler>
{
    private Integer currentIndex = 0;
    
    private List<APP_ITriggerHandler> handlers
    {
        get
        {
            if (handlers == null) this.handlers = new List<APP_ITriggerHandler>();
            
            return this.handlers;
        }
        set;
    }
    
    public Boolean hasNext()
    {
        return currentIndex < handlers.size();
   	}    
 
   public APP_ITriggerHandler next()
   {
       if(hasNext()) 
       {
           return handlers[currentIndex++];
       }
       
       return null;
   } 
    
    public void add(APP_ITriggerHandler handlerInstance)
    {
		this.handlers.add(handlerInstance);   
    }
}