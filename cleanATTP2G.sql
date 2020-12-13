SET SERVEROUTPUT ON SIZE 1000000
SET LINE 160
SET HEADING OFF
SET PAGESIZE 0
SET FEEDBACK OFF

DECLARE
  
cmd                  VARCHAR2(256)       := '';
project              VARCHAR2(20)        := 'ATTP2G41';
schema               VARCHAR2(256)       := 'QP_'||project||'_ADMIN';

CURSOR table_cursor IS
  SELECT *
    FROM dba_tables
   WHERE owner = schema;

CURSOR view_cursor IS
  SELECT *
    FROM dba_views
   WHERE owner = schema;

CURSOR sequence_cursor IS
  SELECT *
    FROM dba_sequences
    WHERE sequence_owner = schema;

CURSOR snapshotLogs_cursor IS
  SELECT *
    FROM dba_snapshot_logs
   WHERE log_owner = schema;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Deleting Schema for '||schema);
  FOR i IN table_cursor LOOP
    cmd := 'DROP TABLE '||i.owner||'.'||i.table_name||' CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE(cmd);
    BEGIN
      EXECUTE IMMEDIATE cmd;
    EXCEPTION  
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('delete tables '||SQLERRM);
    END;
  END LOOP;
--
  FOR i IN view_cursor LOOP
    cmd := 'DROP VIEW '||i.owner||'.'||i.view_name;
    DBMS_OUTPUT.PUT_LINE(cmd);
    BEGIN
      EXECUTE IMMEDIATE cmd;
    EXCEPTION  
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('delete views '||SQLERRM);
    END;
  END LOOP;
--
  FOR i IN sequence_cursor LOOP
    cmd := 'DROP SEQUENCE '||i.sequence_owner||'.'||i.sequence_name;
    DBMS_OUTPUT.PUT_LINE(cmd);
    BEGIN
      EXECUTE IMMEDIATE cmd;
    EXCEPTION  
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('delete sequences '||SQLERRM);
    END;
  END LOOP;
--
 FOR i IN table_cursor LOOP
    cmd := 'DROP MATERIALIZED VIEW '||i.owner||'.'||i.table_name;
    DBMS_OUTPUT.PUT_LINE(cmd);
    BEGIN
      EXECUTE IMMEDIATE cmd;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('materialized views '||SQLERRM);
    END;
 END LOOP;
--
 FOR i IN snapshotLogs_cursor LOOP
    cmd := 'DROP SNAPSHOT LOG '||i.log_owner||'.'||i.master;
    DBMS_OUTPUT.PUT_LINE(cmd);
    BEGIN
      EXECUTE IMMEDIATE cmd;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('snaphot Logs '||SQLERRM);
    END;
 END LOOP;

EXCEPTION  
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
