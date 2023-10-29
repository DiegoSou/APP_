@IsTest
public class GenericObjectSelectorTest 
{
    static GenericObjectSelector selectorInstance = new GenericObjectSelector();

    @IsTest
    static void doQueryCoverage()
    {
        selectorInstance.doQuery('SELECT Id FROM Account', new Map<String, Object>());
    } 
}