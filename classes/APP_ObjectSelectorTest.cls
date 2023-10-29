@IsTest
private class APP_ObjectSelectorTest 
{
    private static APP_ObjectSelector selectorInstance = new APP_ObjectSelector();

    @IsTest
    static void queryTest()
    {
        List<String> listNames = new List<String>();
        Set<String> setNames = new Set<String>();
        Set<Id> setIds = new Set<Id>();
        List<Id> listIds = new List<Id>();
        List<Decimal> listDecimal = new List<Decimal>();
        Set<Integer> setInteger = new Set<Integer>();
        List<Date> listDate = new List<Date>();

        String strParam = '';
        Decimal decimalParam = 0.0;
        Datetime datetimeParam = Datetime.now().addDays(1);
        Boolean boolParam = false;

        selectorInstance
        .search('Account', 'Id')
        
        .withOpenClause()
        .andCondition('Name', 'IN', setNames)
        .withCloseClause()
        .andCondition('AnnualRevenue', 'IN', listDecimal)
            
        .withOpenClause()
        .orCondition('AnnualRevenue', 'IN', setInteger)
        .orCondition('CreatedDate', 'IN', listDate)
        .orCondition('Name', '=', strParam)
        .orCondition('AnnualRevenue', '=', decimalParam)
        .orCondition('CreatedDate', '>', datetimeParam)
        .orCondition('IsDeleted', '=', boolParam)
        .orCondition('Id', 'IN', setIds)
        .withCloseClause()
        .orCondition('Id', 'IN', listIds)

        .setLimit(1)
        .orderBy('Name')

        .query();
    }
}