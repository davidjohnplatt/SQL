SET SERVEROUTPUT ON SIZE 1000000 
SPOOL xeq.sql
    
DECLARE 

projectName            VARCHAR2(10)     := 'BELLNHL41';
sourceTB               VARCHAR2(20)     := 'BELLNHL41';
targetTB               VARCHAR2(20)     := 'BELLNHL41B';
runLive                BOOLEAN          := FALSE;
objectOK               BOOLEAN          := TRUE;
sqlCmd                 VARCHAR2(256); 
tableName              dba_tables.table_name%TYPE;
columnName             dba_tab_columns.column_name%TYPE;



CURSOR segment_cursor (project VARCHAR2,tb VARCHAR2) IS 
  SELECT  segment_name,segment_type
    FROM dba_segments
   WHERE tablespace_name = tb
     AND owner = 'QP_'||project||'_ADMIN'
     AND segment_type IN ('TABLE')
   ORDER BY segment_type DESC;


   

BEGIN
  FOR i IN segment_cursor(projectName,sourceTB) LOOP    
  --tStamp ('table - '||i.segment_name);
    sqlCmd := 'alter table QP_'||projectName||'_ADMIN.'||i.segment_name||' move tablespace '||targetTB;
    dbms_output.put_line(sqlCmd||';');
    objectOK := TRUE;
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
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
SPOOL OFF;
show errors
exit

