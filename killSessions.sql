SET SERVEROUTPUT ON SIZE 1000000
DECLARE

userString          VARCHAR2(30)  := 'QP_BELLTV414_ADMIN';
bString             VARCHAR2(255)  := 'ALTER SYSTEM KILL SESSION ';
mString             VARCHAR2(255);

CURSOR drive_cursor IS
  SELECT username,sid,serial#,osuser,program
    FROM v$session
   WHERE username = userString;


BEGIN
--EXECUTE IMMEDIATE 'ALTER USER '||userString||' ACCOUNT LOCK';
  FOR i IN drive_cursor loop
     mString := bString||''''||i.sid||','||i.serial#||''''||' IMMEDIATE;';
     DBMS_OUTPUT.PUT_LINE(mString);
--   EXECUTE IMMEDIATE mString;
  END LOOP;
END;
/

