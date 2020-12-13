SET SERVEROUTPUT ON SIZE 1000000 
SPOOL xeq.sql
    
DECLARE 

projectName            VARCHAR2(10)     := 'TVB41';
sourceTB               VARCHAR2(20)     := 'ROGERSRODO41';
targetTB               VARCHAR2(20)     := 'TVB41';
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
     AND segment_type = 'INDEX';

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

