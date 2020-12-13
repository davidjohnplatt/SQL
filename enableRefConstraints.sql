SET SERVEROUTPUT ON SIZE 1000000
DECLARE

cmdString       VARCHAR(256);

CURSOR drive_cursor IS
  SELECT table_name,constraint_name,constraint_type
    FROM user_constraints
   WHERE constraint_type = 'R';

BEGIN
  FOR i IN drive_cursor LOOP
    cmdString := 'ALTER TABLE '||i.table_name||' ENABLE CONSTRAINT '||i.constraint_name;
    dbms_output.put_line (cmdString);
    EXECUTE IMMEDIATE cmdString;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line (SQLERRM);
END;
/
