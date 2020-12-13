SET SERVEROUTPUT ON SIZE 1000000
DECLARE

Tablespace          VARCHAR2(30)  := 'VIRGININDIA41';
User                VARCHAR2(5);
tableFound          BOOLEAN;

command             VARCHAR2(127);

CURSOR segment_cursor IS
  SELECT owner,segment_name,segment_type
    FROM dba_segments
   WHERE tablespace_name = Tablespace;
   
BEGIN

  tableFound := FALSE;
  FOR i in segment_cursor LOOP
     tableFound := TRUE;
     DBMS_OUTPUT.PUT_LINE(RPAD(i.owner,20)||'    '||RPAD(i.segment_name,40)||'     '||i.segment_type);
  END LOOP;
  
  IF tableFound THEN
    DBMS_OUTPUT.PUT_LINE('Segments found in TableSpace - skipping Delete');
  ELSE
    BEGIN
      command := 'drop tablespace '||Tablespace||' including contents and datafiles';
      EXECUTE IMMEDIATE command;
      DBMS_OUTPUT.PUT_LINE(command);
    EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END;
  END IF;
    
EXCEPTION
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
exit
