SET SERVEROUTPUT ON SIZE 1000000

DECLARE

serverNum                  NUMBER     := 3;
remainder                  NUMBER(9);
newSequence                NUMBER;
newNumber                  NUMBER;
sqlCmd                     VARCHAR2(255);

CURSOR drive_cursor IS
SELECT *
  FROM user_sequences;
/***************************************************************************/
FUNCTION getProject RETURN VARCHAR2 IS
project                   VARCHAR2(30);
BEGIN
  SELECT USER
    INTO project
    FROM DUAL;
  project := SUBSTR(project,4, INSTR(project,'_',-1) - 4);
--project := INSTR(project,'_',-1) ;
  RETURN project;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('getProject '||SQLERRM);
    RETURN 'ERROR';
END;
/***************************************************************************/
BEGIN
  FOR i IN drive_cursor LOOP
    remainder := mod(i.last_number,10);
    IF remainder = serverNum THEN
       newNumber := 0;
    ELSE
      newNumber := 10 + serverNum - remainder;
    END IF;
    newSequence := i.last_number + newNumber;
    dbms_output.put_line(RPAD(LOWER(i.sequence_name),30)||'   '||lpad(i.last_number,10)||'   '||remainder ||'  '||newNumber||'  '||newSequence);
    sqlCmd := 'DROP SEQUENCE '||LOWER(i.sequence_name);
    dbms_output.put_line(sqlCmd);
    sqlCmd := 'CREATE SEQUENCE '||LOWER(i.sequence_name)||' START WITH '||newSequence||' INCREMENT BY 10';
    dbms_output.put_line(sqlCmd);
    sqlCmd := 'GRANT SELECT ON '||LOWER(i.sequence_name)||' TO qp_'||LOWER(getProject)||'_crud';
    dbms_output.put_line(sqlCmd);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
