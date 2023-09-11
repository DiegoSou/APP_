public virtual without sharing class APP_TriggerDispatcher
{
    public class APP_TriggerDispatcherException extends Exception {}
    
    protected Map<String, APP_TriggerHandlerIterator> contextHandlers = new Map<String, APP_TriggerHandlerIterator>
    {
        'BEFORE_INSERT' => null,
        'BEFORE_UPDATE' => null,
        'BEFORE_DELETE' => null,
        'AFTER_INSERT' => null,
        'AFTER_UPDATE' => null,
        'AFTER_DELETE' => null,
        'AFTER_UNDELETE' => null
    };
    
    // adiciona uma handler no contexto
    public APP_TriggerDispatcher addHandlerInContext(String context, String handlerName)
    {
        // converte para maiúsculo
        context = context.toUpperCase();
        
        // se o nome do contexto for escrito incorretamente
        if (!contextHandlers.containsKey(context)) 
        {
            throw new APP_TriggerDispatcherException('Contexto inválido - ' + context);
        }
        
        // se o mapeamento não tiver sido iniciado ainda
        if (contextHandlers.get(context) == null) 
        {
            contextHandlers.put(context, new APP_TriggerHandlerIterator());
        }
        
        // cria a instancia da handler
        Object handlerInstance = Type.forName(handlerName).newInstance();
        
        // se a handler não possui o método handle()
        if (!(handlerInstance instanceof APP_ITriggerHandler)) 
        {
            throw new APP_TriggerDispatcherException(handlerName + ' não implementa a interface APP_ITriggerHandler');
        }
        
        // adiciona no contexto
        contextHandlers.get(context).add((APP_ITriggerHandler) handlerInstance);
        
        return this;
    }
    
    // executa cada handler
	public void run(System.TriggerOperation triggerEvent) 
    {
        if (contextHandlers.get(triggerEvent.name()) == null) return;
        
        while (contextHandlers.get(triggerEvent.name()).hasNext())
        {
            contextHandlers.get(triggerEvent.name()).next()?.handle();
        }
    }
}
