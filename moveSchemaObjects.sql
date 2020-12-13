SET SERVEROUTPUT ON SIZE 1000000 
SET LINE 250
SPOOL xeq.sql
    
DECLARE 

projectName            VARCHAR2(20)     := 'BELLTV4414';
sourceTB               VARCHAR2(20)     := 'BELLTV414';
targetTB               VARCHAR2(20)     := 'BELLTV4414';
runLive                BOOLEAN          := FALSE;
objectOK               BOOLEAN          := TRUE;
sqlCmd                 VARCHAR2(1000); 
tableName              dba_tables.table_name%TYPE;
columnName             dba_tab_columns.column_name%TYPE;



CURSOR segment_cursor (project VARCHAR2,tb VARCHAR2) IS 
  SELECT  segment_name,segment_type
    FROM dba_segments
   WHERE owner = 'QP_'||project||'_ADMIN'
     AND tablespace_name = sourceTB
   ORDER BY segment_type DESC;

BEGIN
  FOR i IN segment_cursor(projectName,sourceTB) LOOP
    IF i.segment_type = 'TABLE' THEN
  --  tStamp ('table - '||i.segment_name);
      sqlCmd := 'alter table QP_'||projectName||'_ADMIN.'||i.segment_name||' move tablespace '||targetTB;
      objectOK := TRUE;
    ELSIF i.segment_type = 'INDEX' THEN
--    tStamp ('index - '||i.segment_name);
      sqlCmd := 'alter index QP_'||projectName||'_ADMIN.'||i.segment_name||' rebuild tablespace '||targetTB;
      objectOK := TRUE;
    ELSIF i.segment_type = 'LOBSEGMENT' THEN
--    tStamp ('LOB - '||i.segment_name);
      BEGIN
        SELECT table_name,column_name
          INTO tableName,columnName
          FROM dba_lobs
         WHERE segment_name = i.segment_name;
      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line('InLineSelect - '||SQLERRM);
      END;
      sqlCmd := 'ALTER TABLE  QP_'||projectName||'_ADMIN.'||tableName||' MOVE LOB (' ||columnName||') STORE AS (TABLESPACE '||targetTB||')';
      objectOK := TRUE;
    ELSE
      sqlCmd := i.segment_name||' - Object type '||i.segment_type||' not supported by utility';
      objectOK := FALSE;
    END IF;
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

