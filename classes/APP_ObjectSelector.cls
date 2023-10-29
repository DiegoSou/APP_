public inherited sharing virtual class APP_ObjectSelector 
{   
    protected String query {get;set;}
    protected String resultLimit {get;set;}
    protected String orderField {get;set;}
    protected List<WhereClause> conditions = new List<WhereClause>();

    protected Boolean openClause = false;
    protected Boolean closeClause = false;

    /**
     * defines an object and it fields to return
     */
    public virtual APP_ObjectSelector search(String objname, String fields)
    {
        query = 'select ' + fields.trim() + ' from ' + objname.trim();

        return this;
    }

    /**
     * next "where condition" starts with '('
     */
    public virtual APP_ObjectSelector withOpenClause()
    {
        resetClauses();
        
        this.openClause = true;

        return this;
    }

    /**
     * next "where condition" ends with ')'
     */
    public virtual APP_ObjectSelector withCloseClause()
    {
        resetClauses();
        
        this.closeClause = true;

        return this;
    }

    /**
     * reset clauses
     */
    public virtual void resetClauses()
    {
        this.openClause = false;
        this.closeClause = false;
    }

    /**
     * add an "and condition" to query
     */
    public virtual APP_ObjectSelector andCondition(String field, String typeCompare, Object value)
    {
        String separator = (conditions.size() > 0) ? 'and' : '';
        conditions.add(new WhereClause(separator, field, typeCompare, convertValueToString(value), openClause, closeClause));
        
        resetClauses();

        return this;
    }
    public virtual APP_ObjectSelector andCondition(String field, String typeCompare, Object value, Boolean convertValueToString)
    {
        String separator = (conditions.size() > 0) ? 'and' : '';
        String valueStr = convertValueToString ? convertValueToString(value) : (String) value;

        conditions.add(new WhereClause(separator, field, typeCompare, valueStr, openClause, closeClause));
        
        resetClauses();

        return this;
    }

    /**
     * add an "or condition" to query
     */
    public virtual APP_ObjectSelector orCondition(String field, String typeCompare, Object value)
    {
        String separator = (conditions.size() > 0) ? 'or' : '';
        conditions.add(new WhereClause(separator, field, typeCompare, convertValueToString(value), openClause, closeClause));

        resetClauses();
        
        return this;
    }
    public virtual APP_ObjectSelector orCondition(String field, String typeCompare, Object value, Boolean convertValueToString)
    {
        String separator = (conditions.size() > 0) ? 'or' : '';
        String valueStr = convertValueToString ? convertValueToString(value) : (String) value;

        conditions.add(new WhereClause(separator, field, typeCompare, valueStr, openClause, closeClause));

        resetClauses();
        
        return this;
    }

    /**
     * sets the order field of query results
     */
    public virtual APP_ObjectSelector orderBy(String field)
    {
        this.orderField = String.valueOf(field);

        return this;
    }

    /**
     * sets the limit of query results
     */
    public virtual APP_ObjectSelector setLimit(Integer n)
    {
        this.resultLimit = String.valueOf(n);

        return this;
    }

    /**
     * calls Database.query
     */
    public List<SObject> query()
    {
        // conditions
        if (conditions.size() > 0)
        {
            this.query += ' where ';
    
            for(WhereClause condition : conditions)
            {
                this.query += ' ' + condition.toString();
            }
        }

        // order
        if (this.orderField != null && this.orderField != '')
        {
            this.query += ' ORDER BY ' + this.orderField;
        }

        // limit
        if (this.resultLimit != null && this.resultLimit != '')
        {
            this.query += ' LIMIT ' + this.resultLimit;
        }

        // query
        System.debug(this.query);
        return Database.query(this.query);
    }

    /**
     * convert values passed in where conditions
     */
    protected String convertValueToString(Object o)
    {
        String retorno = '';

        if(o instanceof List<String>)
        {
            retorno += '(';
            for(String str : (List<String>) o) {retorno += '\'' +(String) str + '\',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof Set<String>)
        {
            retorno += '(';
            for(String str : (Set<String>) o) {retorno += '\'' +(String) str + '\',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof Set<Id>)
        {
            retorno += '(';
            for(String str : (Set<Id>) o) {retorno += '\'' + (String) str + '\',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof List<Id>)
        {
            retorno += '(';
            for(String str : (List<Id>) o) {retorno += '\'' +(String) str + '\',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof List<Decimal>)
        {
            retorno += '(';
            for(Decimal str : (List<Decimal>) o) {retorno += str + ',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof Set<Integer>)
        {
            retorno += '(';
            for(Integer str : (Set<Integer>) o) {retorno += str + ',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof String) {retorno += '\''+o+'\'';}
        else if(o instanceof Decimal) {retorno += ''+o+'';}
        else if(o instanceof Datetime) 
        {
            if(String.valueOf(o).contains('00:00:00')) {retorno = ((Datetime) o).formatGMT('yyyy-MM-dd');}
            else {retorno = ((Datetime) o).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');}
        }
        else if(o instanceof List<Date>)
        {
            retorno += '(';
            for(Date dateValue : (List<Date>) o) {retorno += '' +string.valueOf(dateValue) + ',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof Boolean) {retorno = String.valueOf(o);}
        
        if(o == null) { retorno = 'null'; }
        if(retorno == '()') { retorno = '(null)'; }
            
        return retorno;
    }

    //
    //  WhereClause
    // 

    private class WhereClause
    {
        private String separator;
        private String field;
        private String typeCompare;
        private String value;
        private Boolean openClause;
        private Boolean closeClause;

        public WhereClause(String separator, String field, String typeCompare, String value, Boolean openClause, Boolean closeClause)
        {
            this.separator = separator;
            this.typeCompare = typeCompare;
            this.field = field;
            this.value = value;
            this.openClause = openClause;
            this.closeClause = closeClause;
        }

        public override String toString()
        {
            if (this.openClause)
            {
                return separator + ' (' + field + ' ' + typeCompare + ' ' + value;
            }
            if (this.closeClause)
            {
                return separator + ' ' + field + ' ' + typeCompare + ' ' + value + ')';
            }

            return separator + ' ' + field + ' ' + typeCompare + ' ' + value;
        }
    }
}