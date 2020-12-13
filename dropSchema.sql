SET SERVEROUTPUT ON SIZE 1000000
DECLARE

Project             VARCHAR2(30)  := 'BELLTV414';
User                VARCHAR2(5);
tableFound          BOOLEAN;

dropFirst           VARCHAR2(14)  := 'drop user qp_';
dropLast            VARCHAR2(8)   := ' cascade';
command             VARCHAR2(127);

CURSOR table_cursor IS
  SELECT owner,table_name
    FROM dba_tables
   WHERE tablespace_name = Project;
   
BEGIN

  BEGIN
    User := 'admin';
    command := dropFirst||Project||'_'||User||dropLast;
    EXECUTE IMMEDIATE command;
    DBMS_OUTPUT.PUT_LINE(command);
  EXCEPTION
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END;

  BEGIN
    User := 'crud';
    command := dropFirst||Project||'_'||User||dropLast;
    EXECUTE IMMEDIATE command;
    DBMS_OUTPUT.PUT_LINE(command);
  EXCEPTION
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END;

  BEGIN
    User := 'user';
    command := dropFirst||Project||'_'||User||dropLast;
    EXECUTE IMMEDIATE command;
    DBMS_OUTPUT.PUT_LINE(command);
  EXCEPTION
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END;

  BEGIN
    User := 'read';
    command := dropFirst||Project||'_'||User||dropLast;
    EXECUTE IMMEDIATE command;
    DBMS_OUTPUT.PUT_LINE(command);
  EXCEPTION
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END;

  tableFound := FALSE;
  FOR i in table_cursor LOOP
     tableFound := TRUE;
     DBMS_OUTPUT.PUT_LINE(i.owner||'    '||i.table_name);
  END LOOP;
  
  IF tableFound THEN
    DBMS_OUTPUT.PUT_LINE('Tables Found in TableSpace - skipping Delete');
  ELSE
    BEGIN
      command := 'drop tablespace '||project||' including contents and datafiles';
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
