@IsTest
public without sharing class APP_StubProvider implements System.StubProvider
{
    public class APP_StubProviderException extends Exception {}

    List<MethodCall> methodCalls = new List<MethodCall>();
    Type objectType;

    /** 
     * Define sobjectType to stub 
     */
    public APP_StubProvider(Type objectType)
    {
        this.objectType = objectType;
    }

    /**
     * Track methods
     */
    public APP_StubProvider trackMethod(MethodCall toTrack)
    {
        this.methodCalls.add(toTrack);

        return this;
    }
    public APP_StubProvider trackMethods(List<MethodCall> toTrack)
    {
        this.methodCalls.addAll(toTrack);

        return this;
    }

    /**
     * Generate stub based on sobjectType
     */
    public Object generateStub()
    {
        return Test.createStub(this.objectType, this);
    }

    /**
     * Triggers when any method from generated stub is called 
     */
    public Object handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName,
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames,
        List<Object> listOfArgs)
    { 
        MethodCall calledMethod = new MethodCall(stubbedMethodName, returnType, listOfParamTypes, listOfParamNames);

        for(MethodCall trackedMethod : this.methodCalls)
        {
            if (!trackedMethod.compareTo(calledMethod)) 
            {
                continue;
            }

            return trackedMethod.handleCall();
        }

        return null; // Not tracked method response
    }

    //
    // Method call wrapper
    //

    public class MethodCall
    {
        /**
         * name of method
         */
        String methodName;
        
        /**
         * return type of method
         */
        Type returnType;

        /**
         * return value of method
         */
        Object returnValue;

        /**
         * list of parameter types 
         */
        List<Type> listOfParamTypes;

        /**
         * list of parameter names
         */
        List<String> listOfParamNames;

        /**
         * if the method throws an Exception
         */
        Boolean throwsException = false;

        /**
         * message of exception
         */
        String exceptionMessage = '';

        /**
         * type of exception
         */
        Type exceptionType;

        /**
         * number of times the method was called
         */
        Integer countCalls = 0;

        /**
         * if the method name is unique in the stub class
         */
        Boolean simpleCompare;

        //
        // constructors
        //

        /**
         * constructor to identify a method call by method name
         */
        public MethodCall(String methodName)
        {
            this.methodName = methodName;

            this.simpleCompare = true;
        }

        /**
         * constructor to identify a method call by method arguments
         * | methodName: String
         * | returnType: Type
         * | listOfParamTypes: List<Type>
         * | listOfParamNames: List<String>
         */
        public MethodCall(String methodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames)
        {
            this.methodName = methodName;
            this.returnType = returnType;
            this.listOfParamTypes = listOfParamTypes;
            this.listOfParamNames = listOfParamNames;

            this.simpleCompare = false;
        }

        //
        // public methods
        //

        public MethodCall withReturnValue(Object returnValue)
        {
            this.returnValue = returnValue;

            return this;
        }

        public MethodCall withThrowException(Type exceptionType, String exceptionMessage)
        {
            this.throwsException = true;

            this.exceptionMessage = exceptionMessage;
            this.exceptionType = exceptionType;
            
            return this;
        }

        public Object handleCall()
        {
            this.countCalls++;

            if (this.throwsException)
            {
                Exception exc = (Exception) this.exceptionType.newInstance();
                exc.setMessage(this.exceptionMessage);

                throw exc;
            }

            return this.returnValue;
        }

        public Boolean compareTo(MethodCall anotherMethodCall)
        {
            if (this.simpleCompare)
            {
                return this.compareByName(anotherMethodCall);
            }
            else
            {
                return this.compareByArgs(anotherMethodCall);
            }
        }

        //
        // private comparators
        //

        private Boolean compareByName(MethodCall anotherMethodCall)
        {
            return (this.methodName == anotherMethodCall.methodName);
        }

        private Boolean compareByArgs(MethodCall anotherMethodCall)
        {
            if (this.methodName != anotherMethodCall.methodName)
            {
                return false;
            }

            if (this.returnType.getName() != anotherMethodCall.returnType.getName())
            {
                return false;
            }

            if (String.join(this.listOfParamNames, ',') != String.join(anotherMethodCall.listOfParamNames, ','))
            {
                return false;
            }

            for(Integer i=0; i<this.listOfParamTypes.size(); i++)
            {
                try
                {
                    if (this.listOfParamTypes[i].getName() != anotherMethodCall.listOfParamTypes[i].getName())
                    {
                        return false;
                    }
                }
                catch(Exception e)
                {
                    return false;
                }
            }

            return true;
        }
    }
}