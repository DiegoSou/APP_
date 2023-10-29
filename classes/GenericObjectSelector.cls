/**
 * @author Diego
 * @date 10/2023
 * 
 * @description Classe simples para realizar consultas SOQL e poder ser feita Stub para testes.
 */
public without sharing virtual class GenericObjectSelector implements IGenericObjectSelector 
{
    /** 
     * @description método para realizar consulta
     * 
     * @example
     * new GenericObjectSelector().doQuery('SELECT Id FROM Account WHERE Name = :name', new Map<String, Object>{'name'=>'Test Account'})
     */
    public List<SObject> doQuery(String queryString, Map<String, Object> bindParams)
    {
        return Database.queryWithBinds(queryString, bindParams, AccessLevel.SYSTEM_MODE);
    }
}