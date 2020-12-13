SET SERVEROUTPUT ON SIZE 1000000
SET LINE 250

DECLARE

project      VARCHAR2(20)                  := 'ATTP2G41';
passwd       VARCHAR2(20)                  := '_c00ldave';
instance     VARCHAR2(20)                  := 'SITS';
sqlCmd       VARCHAR2(255);

CURSOR proc_cursor IS
  SELECT DISTINCT name,type
    FROM user_source;

BEGIN
  FOR i IN proc_cursor LOOP
    IF i.type = 'PROCEDURE' THEN
      dbms_output.put_line('--     '||i.name||'    '||i.type);
      BEGIN
        sqlCmd := 'grant execute on '||i.name||' to QP_'||project||'_CRUD';
        dbms_output.put_line(sqlCmd);
        EXECUTE IMMEDIATE sqlCmd;
        sqlCmd := 'create synonym '||i.name||' for QP_'||project||'_ADMIN.'||i.name;
        dbms_output.put_line(sqlCmd);
      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line(SQLERRM);
      END;
      dbms_output.put_line('--');
      dbms_output.put_line('connect qp_'||project||'_crud/qp_'||project||'@'||instance);
    END IF;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
     dbms_output.put_line(SQLERRM);
END;
/


