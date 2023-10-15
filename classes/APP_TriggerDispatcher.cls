/**
 * Class for assign handlers to each context
 *
 * Trigger system variables still accessible for handlers, and values depends on context, of course
 * 
 * Intentionally virtual, so you can extend funcionallity to make specific-tratative dispatchers
 * or some stuff like that
 */

public virtual class APP_TriggerDispatcher
{
    public class APP_TriggerDispatcherException extends Exception {}
    
    /**
     * predefined context map
     */
    private final Map<String, APP_TriggerHandlerIterator> contextHandlers = new Map<String, APP_TriggerHandlerIterator>
    {
        'BEFORE_INSERT' => null,
        'BEFORE_UPDATE' => null,
        'BEFORE_DELETE' => null,
        'AFTER_INSERT' => null,
        'AFTER_UPDATE' => null,
        'AFTER_DELETE' => null,
        'AFTER_UNDELETE' => null
    };
    
    public APP_TriggerDispatcher addHandlerInContext(String context, String handlerName)
    {
        context = context.toUpperCase();

        initialize(context);
        assign(context, handlerName);
        
        return this;
    }

    /**
     * init context
     */
    private void initialize(String context)
    {   
        if (!contextHandlers.containsKey(context)) 
        {
            throw new APP_TriggerDispatcherException('Invalid context - ' + context);
        }
        
        if (contextHandlers.get(context) == null) 
        {
			contextHandlers.put(context, new APP_TriggerHandlerIterator());
        }
    }

    /**
     * add new handler in context
     */
    private void assign(String context, String handlerName)
    {
        Object handlerInstance = Type.forName(handlerName).newInstance();

        if (!(handlerInstance instanceOf APP_ITriggerHandler))
        {
            throw new APP_TriggerDispatcherException(handlerName + ' must implement APP_ITriggerHandler');
        }

        contextHandlers.get(context).add((APP_ITriggerHandler) handlerInstance);
    }
    
    /**
     * execute enqueued handlers by context
     */
	public void execute(System.TriggerOperation triggerEvent) 
    {
        String context = triggerEvent.name();

        if (contextHandlers.get(context) == null)
        {
            return;
        }

        while (contextHandlers.get(context).hasNext())
        {
        	contextHandlers.get(context).next().handle();
        }
    }
}