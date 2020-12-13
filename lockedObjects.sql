SET SERVEROUTPUT ON SIZE 1000000

DECLARE

kount           NUMBER   := 0;
objectName dba_objects.object_name%TYPE;
objectType dba_objects.object_type%TYPE;
schemaOwner dba_objects.owner%TYPE;

CURSOR lock_cursor IS
  SELECT *
    FROM gv$locked_object;

BEGIN
  FOR i IN lock_cursor LOOP
    kount := kount + 1;
    SELECT owner,object_name,object_type
      INTO schemaOwner,objectName,objectType
      FROM dba_objects
     WHERE object_id = i.object_id;
   dbms_output.put_line(i.inst_id||'    '||RPAD(schemaOwner,20)||' ' || objectName ||' '||objectType);
 END LOOP;
   dbms_output.put_line('Locked Object Count = '||kount);
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
exit
