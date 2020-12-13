SET SERVEROUTPUT ON SIZE 1000000
SET LINE 250

DECLARE

multiplier                 NUMBER               := .05;

CURSOR drive_cursor IS
  SELECT TO_CHAR(created_datetime,'YYYYMMDD HH24') dt,COUNT(*) Kount
    FROM consumption_tracking 
   WHERE created_datetime > SYSDATE - 7
   GROUP BY TO_CHAR(created_datetime,'YYYYMMDD HH24')
   ORDER BY TO_CHAR(created_datetime,'YYYYMMDD HH24');
 
BEGIN
  FOR i IN drive_cursor LOOP
    dbms_output.put_line(i.dt||' ('||lpad(i.kount,4)||') '||rpad('*',i.kount * multiplier,'*'));
  END LOOP;
  
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/

