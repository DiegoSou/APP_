@IsTest
private class StubExampleDependentTest extends APP_TestContext
{

    //
    // you decide if stub whole class at once or do it separately in test methods
    //

    /**
     public static void stubExampleStub() 
     {
         APP_StubProvider.MethodCall getAnException = new APP_StubProvider.MethodCall('getAnException')
         .withThrowException(StubExample.StubExampleException.class, 'throws stubbed exception type');
         
         APP_StubProvider.MethodCall integerGeneratorUniqueMethod = new APP_StubProvider.MethodCall('integerGeneratorUniqueMethod')
         .withReturnValue(1234);

         APP_StubProvider.MethodCall getItsTrueWithoutParams = new APP_StubProvider.MethodCall('getItsTrue', new List<Type>())
         .withReturnValue(true);

         APP_StubProvider.MethodCall getItsTrueWithStringParams = new APP_StubProvider.MethodCall('getItsTrue', new List<Type>{String.class})
         .withReturnValue('this is a string return from stub');

         APP_StubProvider.MethodCall getItsTrueWithBooleanParams = new APP_StubProvider.MethodCall('getItsTrue', new List<Type>{Boolean.class})
         .withReturnValue(false);
 
         registerStubs(StubExample.class, new List<APP_StubProvider.MethodCall>
             {
                 getAnException,integerGeneratorUniqueMethod,
                 getItsTrueWithoutParams,
                 getItsTrueWithStringParams,
                 getItsTrueWithBooleanParams
             }
         );
     }
     */

    @IsTest
    static void getAnExceptionTest()
    {   
        // GIVE

        APP_StubProvider.MethodCall getAnException = new APP_StubProvider.MethodCall('getAnException')
        .withThrowException(StubExample.StubExampleException.class, 'throws stubbed exception type');

        registerStub(StubExample.class, getAnException);
        StubExample stubbedDependency = (StubExample) getInstanceStub('StubExample');
        
        // WHEN
        
        StubExampleDependent classTested = new StubExampleDependent(stubbedDependency);
        Exception catchedException = null;

        try
        {
            classTested.dependentGetAnException();
        }
        catch(StubExample.StubExampleException e)
        {
            catchedException = e;
        }
        
        // THEN

        System.debug(catchedException);
        System.assertEquals(true, (catchedException != null), 'The exception throwed by StubExample should be instance of StubExampleException');
    }

    @IsTest
    static void integerGeneratorUniqueMethodTest() 
    {  
        // GIVE

        APP_StubProvider.MethodCall integerGeneratorUniqueMethod = new APP_StubProvider.MethodCall('integerGeneratorUniqueMethod')
        .withReturnValue(1234);
        
        registerStub(StubExample.class, integerGeneratorUniqueMethod);
        StubExample stubbedDependency = (StubExample) getInstanceStub('StubExample');

        // WHEN

        StubExampleDependent classTested = new StubExampleDependent(stubbedDependency);
        Integer generatedNumber = classTested.dependentIntegerGeneratorUniqueMethod();

        // THEN

        System.debug(generatedNumber);
        System.assertEquals(1234, generatedNumber, 'The generated number does not follow the stub return value');
    }

    @IsTest
    static void getItsTrueWithoutParamsTest()
    {   
        // GIVE

        APP_StubProvider.MethodCall getItsTrueWithoutParams = new APP_StubProvider.MethodCall('getItsTrue', new List<Type>())
        .withReturnValue(true);
        
        registerStub(StubExample.class, getItsTrueWithoutParams);
        StubExample stubbedDependency = (StubExample) getInstanceStub('StubExample'); 

        // WHEN

        StubExampleDependent classTested = new StubExampleDependent(stubbedDependency);
        Boolean methodReturn = classTested.dependentGetItsTrue();

        // THEN

        System.debug(methodReturn);
        System.assertEquals(true, methodReturn, 'The return value should be true even if the StubExample by default returns false');
    }

    @IsTest
    static void getItsTrueWithStringParamsTest()
    {   
        // GIVE

        APP_StubProvider.MethodCall getItsTrueWithStringParams = new APP_StubProvider.MethodCall('getItsTrue', new List<Type>{String.class})
        .withReturnValue('this is a string return from stub');
        
        registerStub(StubExample.class, getItsTrueWithStringParams);
        StubExample stubbedDependency = (StubExample) getInstanceStub('StubExample');

        // WHEN

        StubExampleDependent classTested = new StubExampleDependent(stubbedDependency);
        String methodReturn = classTested.dependentGetItsTrue('');

        // THEN

        System.debug(methodReturn);
        System.assertEquals('this is a string return from stub', methodReturn, 'Returned string does not follow the stub return value');
    }

    @IsTest
    static void getItsTrueWithBooleanParamsTest()
    {   
        // GIVE

        APP_StubProvider.MethodCall getItsTrueWithBooleanParams = new APP_StubProvider.MethodCall('getItsTrue', new List<Type>{Boolean.class})
        .withReturnValue(false);
        
        registerStub(StubExample.class, getItsTrueWithBooleanParams);
        StubExample stubbedDependency = (StubExample) getInstanceStub('StubExample');

        // WHEN

        StubExampleDependent classTested = new StubExampleDependent(stubbedDependency);
        Boolean methodReturn = classTested.dependentGetItsTrue(true);

        // THEN

        System.debug(methodReturn);
        System.assertEquals(false, methodReturn, 'Returned boolean does not follow the stub return value');
    }
}
