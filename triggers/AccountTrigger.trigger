trigger AccountTrigger on Account (
    before insert, after insert,
    before update, after update,
    before delete, after delete,
    after undelete) 
{
    new APP_TriggerDispatcher()
    .addHandlerInContext('before_insert', 'AccountBeforeInsertHandler')
    .addHandlerInContext('before_insert', 'SecondAccountBeforeInsertHandler')
    
    .execute(Trigger.operationType);
}

// Excecute
// Account acc = new Account(Name='test account');
// insert acc;