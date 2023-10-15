/**
 * Class to test APP_StubProvider and if it recognizes same methods with different characteristics
 */

public without sharing class StubExample 
{
    public class StubExampleException extends Exception {}

    String helloMessage;
    Boolean isTrue = false;

    public Integer integerGeneratorUniqueMethod()
    {
        return Integer.valueOf((Math.random() * 1000));
    }

    public void getAnException()
    {
        throw new StubExampleException('You always have an Exception throwed by this method');
    }

    public Boolean getItsTrue()
    {
        return this.isTrue;
    }

    public String getItsTrue(String trueString)
    {
        return trueString;
    }

    public Boolean getItsTrue(Boolean itsReallyTrue)
    {
        return itsReallyTrue;
    }
}