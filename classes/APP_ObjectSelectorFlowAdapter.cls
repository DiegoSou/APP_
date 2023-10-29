global with sharing class APP_ObjectSelectorFlowAdapter 
{
    public class Input
    {
        @InvocableVariable(label='Api name of object' required=true)
        public String objectApiName;

        @InvocableVariable(label='Fields to return' description='Separate by comma' required=true)
        public String objectFields;

        @InvocableVariable(label='Filters' description='Ex: CreatedDate :: > :: val :: Date, ...' required=false)
        public String filters;

        @InvocableVariable(label='Skip null filter values' description='Constant True/False' required=true)
        public Boolean skipNull;
    }

    public class Output
    {
        @InvocableVariable(required=true)
        @AuraEnabled
        public List<SObject> listSObjects;

        public Output(List<SObject> listSObjects)
        {
            this.listSObjects = listSObjects;
        }
    }

    //
    // Public methods
    //

    /**
     * get a list of records 
     */
    @InvocableMethod
    public static List<Output> getRecords(List<Input> inputList)
    {
        Input config = inputList[0];

        selectorInstance.search(config.objectApiName, config.objectFields);

        if (config.filters != null) 
        {
            applyFilters(config.filters, config.skipNull);  
        } 

        return getOutputResult();
    }

    //
    // Private methods
    //

    /**
     * apply a list of filters
     * Args separated by ::
     * Fields separated by ,
     * Ex: CreatedDate :: > :: val :: Date, ...
     */
    private static void applyFilters(String filters, Boolean skipNull)
    {
        for(String fieldCriteria : filters.split(','))
        {
            List<String> args = fieldCriteria.trim().split('::');
            String fieldApi = args[0].trim();
            String typeCompare = args[1].trim();
            String value = args[2].trim();
            String typeValue = args[3].trim();

            if(skipNull && isNullValue(value)) 
            { 
                continue; 
            }
            
            applyFilter(fieldApi, typeCompare, JSON.deserialize(JSON.serialize(value), Type.forName(typeValue)));
        }
    }

    /**
     * verify if the string value is null
     */
    private static Boolean isNullValue(Object value)
    {
        return (value == '' || value == null || value == 'null');
    }

    /**
     * add an "and condition" with selector instance
     */
    private static void applyFilter(String fieldApiName, String typeCompare, Object fieldValue)
    {
        selectorInstance.andCondition(fieldApiName, typeCompare, fieldValue);
    }

    /**
     * get bulkified output from selector query
     */
    private static List<Output> getOutputResult()
    {
        return new List<Output>{new Output(selectorInstance.query())};
    }

    //
    // Instances
    //

    @TestVisible
    private static APP_ObjectSelector selectorInstance
    {
        get
        {
            if (selectorInstance == null)
            {
                selectorInstance = new APP_ObjectSelector();
            }
            return selectorInstance;
        }
        set;
    }
}