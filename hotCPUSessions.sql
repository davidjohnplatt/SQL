SET SERVEROUTPUT ON SIZE 1000000

DECLARE

topCPUkount                 NUMBER;

CURSOR cpuCursor (cKount  NUMBER) IS
  SELECT *
    FROM gv$sqlarea
   WHERE cpu_time > cKount;

FUNCTION topCPU RETURN NUMBER IS
num NUMBER;
BEGIN
  SELECT MAX(cpu_time)
    INTO num
    FROM gv$sqlarea;
  RETURN num;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;

FUNCTION getUser(uid    NUMBER)  RETURN VARCHAR2 IS
str VARCHAR2(30);
BEGIN
  SELECT username
    INTO str
    FROM dba_users
   WHERE user_id = uid;
  RETURN str;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;

BEGIN
  topCPUkount := topCPU;
  dbms_output.put_line('Top CPU Count = '||topCPUkount);
  FOR i IN cpuCursor (topCPUkount * .80)  LOOP
    dbms_output.put_line('--------');
    dbms_output.put_line('Last Active = '||TO_CHAR(i.last_active_time,'YYYY-MM-DD HH:MI'));
    dbms_output.put_line(getUser(i.parsing_user_id));
    dbms_output.put_line(i.sql_text);
  END LOOP;
  
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
