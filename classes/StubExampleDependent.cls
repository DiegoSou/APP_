/**
 * Class which is suppose to depend StubExample for works correctly
 * But in unit tests we doesn't trigger associated classes directly
 * So, you handle method calls with a stub provider class
 */

/**
 * The main objective by StubExampleDependentTest is actually 
 * verify if it really calls your dependency and do it
 * just once for each call by own methods
 */

public without sharing class StubExampleDependent 
{
    @TestVisible
    private StubExample mustBeStubbed;

    public StubExampleDependent(StubExample dependencyExample)
    {
        this.mustBeStubbed = dependencyExample;
    }

    public Integer dependentIntegerGeneratorUniqueMethod()
    {
        return mustBeStubbed.integerGeneratorUniqueMethod();
    }

    public void dependentGetAnException()
    {
        mustBeStubbed.getAnException();
    }

    public Boolean dependentGetItsTrue()
    {
        return mustBeStubbed.getItsTrue();
    }

    public String dependentGetItsTrue(String trueString)
    {
        return mustBeStubbed.getItsTrue(trueString);
    }

    public Boolean dependentGetItsTrue(Boolean itsReallyTrue)
    {
        return mustBeStubbed.getItsTrue(itsReallyTrue);
    }
}