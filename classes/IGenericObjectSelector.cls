public interface IGenericObjectSelector 
{
    List<SObject> doQuery(String queryString, Map<String, Object> bindParams);
}