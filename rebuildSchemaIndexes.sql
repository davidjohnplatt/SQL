SET SERVEROUTPUT ON SIZE 1000000 
SPOOL xeq.sql
    
DECLARE 

projectName            VARCHAR2(10)     := 'BELLNHL41';
targetTB               VARCHAR2(20)     := 'BELLNHL41B';
runLive                BOOLEAN          := TRUE;
objectOK               BOOLEAN          := TRUE;
sqlCmd                 VARCHAR2(256); 
tableName              dba_tables.table_name%TYPE;
columnName             dba_tab_columns.column_name%TYPE;



CURSOR segment_cursor IS 
  SELECT  segment_name,segment_type
    FROM dba_segments
   WHERE owner = 'QP_'||projectName||'_ADMIN'
     AND segment_type = 'INDEX'
    ORDER BY segment_name;

BEGIN
FOR i IN segment_cursor LOOP
--    tStamp ('index - '||i.segment_name);
      sqlCmd := 'alter index QP_'||projectName||'_ADMIN.'||i.segment_name||' rebuild tablespace '||targetTB;
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
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
SPOOL OFF;
show errors
exit

