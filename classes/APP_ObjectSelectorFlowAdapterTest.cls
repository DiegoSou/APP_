@IsTest
private class APP_ObjectSelectorFlowAdapterTest 
{
    @IsTest
    static void getRecordsTest()
    {
        APP_ObjectSelectorFlowAdapter.Input config = new APP_ObjectSelectorFlowAdapter.Input();

        config.objectApiName = 'Opportunity';
        config.objectFields = 'Id, Name';
        config.filters = 'Name :: = :: Test Opportunity :: String,'
                        +'Probability :: = :: 50 :: Decimal,'
                        +'StageName :: = ::  :: String';

        config.skipNull = true;

        APP_ObjectSelectorFlowAdapter.getRecords(new List<APP_ObjectSelectorFlowAdapter.Input>{config});
    }
}