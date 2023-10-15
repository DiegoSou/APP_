# APP_
#### utilizando a app
> lwc: 
```
<c-call-app-service></c-call-app-service>
```
> js: 
```
import { LightningElement, api, wire } from 'lwc'; 
import { subscribe, MessageContext } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';
export default class LwcBindings extends LightningElement 
{   
    @wire(MessageContext) messageContext;
    
    connectedCallback()
    {
        subscribe(
            this.messageContext,
            CallServiceChannel,
            (call) => {
                if(call.response.from == 'action-1') { this.handleCallToAction1(call.response); }
                if(call.response.from == 'action-2') { this.handleCallToAction2(call.response); }
            },
            {}
        );
    }
    
    handleCallToAction1(response)
    {
        if(response.data)
        {
            console.log('This is my action 1 data: ' JSON.parse(response.data));
        }
        if(response.error)
        {
            console.log('Toast notification fired, and that's my action 1 error'); 
        }
    }
    
    callToAction1()
    {
        let callService = this.template.querySelector('c-call-app-service');

        callService.cmp = 'action-1';
        callService.call('Action1_Adapter', 'methodAction1', {
          param1 : 'param1value', 
          paramlist : ['item1', 'item2'],
          paramJson : JSON.stringify(['item1', 'item2']) 
        });
    }
}
```
> adapter:
```
public class Action1_Adapter extends APP_AbstractAdapter
{
    public override Map<String,String> configureMethodCatalog() 
    {
        return new Map<String,String> {
            'methodAction1' => 'Action1_Adapter.MyMethod1_ADP',
        };
    }

    public override Map<String,Object> configureParamsCatalog() 
    {
        // change
        return new Map<String, Object> {
            'methodAction1' => (new Map<String,String> { 'param1' => '', 'paramlist' => '', 'paramJson' => '' }),
        };
    }

    public class MyMethod1_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(APP_AbstractAdapter adp, String methodName, Map<String,Object> params) 
        {
            adp.setNewResponseToMethod(
                methodName, 
                new MyService().myMethod1(
                    (String) params.get('param1'),
                    (List<Object>) params.get('paramlist'),
                    (String) params.get('paramJson')
                )
            );
        }
    }
}
```
> exception
```
public without sharing class MyService
{
    public class MyServiceExcpt extends APP_UserExceptionType {}
    
    public String myMethod1(String p1, List<Object> p2, String p3)
    {
        if(p1 != null) { throw new MyServiceExcpt().exception('not put params here.', true); }
        
        return null;
    }
}
```
> trigger
```
trigger AccountTrigger on Account (
    before insert, after insert,
    before update, after update,
    before delete, after delete,
    after undelete) 
{
    (
        new APP_TriggerDispatcher()
        
        .addHandlerInContext('before_insert', 'SecondAccountBeforeInsertHandler')
        .addHandlerInContext('before_insert', 'AccountBeforeInsertHandler')
        
        .run(Trigger.operationType)
    );
}
```
> handler
```
public class SecondAccountBeforeInsertHandler implements APP_ITriggerHandler
{
    public void handle()
    {
        List<Account> newList = Trigger.new;
        
        for(Account acc : newList)
        {
            System.debug('Account ' + acc.Name);
        }
    }
}
```
