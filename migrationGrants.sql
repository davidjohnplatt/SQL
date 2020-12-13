SET LINE 250
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

project       VARCHAR2(20)                   := 'SIRIUSXM41';
tableName     user_tables.table_name%TYPE    := 'CT_JAN';
sqlCmd        VARCHAR2(4096);

CURSOR table_cursor IS
  SELECT table_name
    FROM user_tables
   WHERE table_name NOT LIKE '%QRTZ%'
     AND table_name not like 'DR$%'
     AND table_name not like 'MLOG%';

CURSOR column_cursor (tableN  VARCHAR2) IS
  SELECT column_name
    FROM user_tab_columns
   WHERE table_name = tableN;

BEGIN
--FOR i IN table_cursor LOOP
--   sqlCmd := 'GRANT SELECT ON '||i.table_name||' TO QP_'||project||'_ADMIN';
--   dbms_output.put_line(sqlCmd);
--   EXECUTE IMMEDIATE sqlCmd;
--   sqlCmd := 'INSERT INTO '||i.table_name||' SELECT * from qp_siriusxm32_admin.'||i.table_name||';';
--   dbms_output.put_line(sqlCmd);
--END LOOP;
  sqlCmd := 'INSERT INTO '||tableName||'(';
  FOR j in column_cursor (tableName) LOOP
     sqlCmd := sqlCmd||j.column_name||',';
  END LOOP;
  sqlCmd := SUBSTR(sqlCmd,1,Length(sqlCmd) - 1);
  sqlCmd := sqlCmd||') SELECT * FROM '||tableName||';';
  dbms_output.put_line(sqlCmd);
EXCEPTION
  WHEN OTHERS THEN
     dbms_output.put_line(SQLERRM);
END;
/
