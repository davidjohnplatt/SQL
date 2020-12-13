SET SERVEROUTPUT ON SIZE 1000000 
SET LINE 250
SPOOL xeq.sql
    
DECLARE 

projectName            VARCHAR2(10)     := 'OV41';
targetTB               VARCHAR2(20)     := 'OV41';
runLive                BOOLEAN          := FALSE;
objectOK               BOOLEAN          := TRUE;
sqlCmd                 VARCHAR2(256); 
buildCmd               VARCHAR2(256); 
tableName              dba_tables.table_name%TYPE;
columnName             dba_tab_columns.column_name%TYPE;



CURSOR index_cursor  IS 
  SELECT  index_name,table_name
    FROM dba_indexes
   WHERE  owner = 'QP_'||projectName||'_ADMIN'
    AND status = 'UNUSABLE'
    AND index_type = 'DOMAIN'
    ORDER BY index_name;

CURSOR column_cursor (ndx  VARCHAR2) is 
  SELECT * 
    FROM dba_ind_columns
   WHERE index_owner = 'QP_'||projectName||'_ADMIN'
     AND index_name = ndx;

BEGIN
  FOR i IN index_cursor LOOP
    sqlCmd := 'drop index QP_'||projectName||'_ADMIN.'||i.index_name;
    objectOK := TRUE;
    dbms_output.put_line(sqlCmd||';');
    IF runLive THEN
      IF objectOK THEN
        BEGIN
          EXECUTE IMMEDIATE sqlCmd;
        EXCEPTION
          WHEN OTHERS THEN
            dbms_output.put_line('Execution - '||SQLERRM);
        END;
      END IF;
    END IF;
    sqlCmd := 'CREATE INDEX QP_'||projectName||'_ADMIN.'||i.index_name||' ON QP_'||projectName||'_ADMIN.'||i.table_name||'(';
    FOR j IN column_cursor (i.index_name) LOOP
       sqlCmd := sqlCmd||j.column_name;
    END LOOP;
    sqlCmd := sqlCmd||') INDEXTYPE IS CTXSYS.CTXCAT';
    dbms_output.put_line(sqlCmd||';');
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
SPOOL OFF;
show errors
exit

