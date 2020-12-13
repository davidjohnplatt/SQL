SET SERVEROUTPUT ON SIZE 1000000

DECLARE

project                          VARCHAR2(50)   := 'BELLTV414';
Prefix                           VARCHAR2(4)    := 'QP_';
Name                             VARCHAR2(10);
tblspcCmd                        VARCHAR2(255)  := 'CREATE TABLESPACE ';
sqlCmd                           VARCHAR2(255);
adminPass                        VARCHAR2(10)   := '_shak3r';
crudPass                         VARCHAR2(10)   := '_kkula';
readPass                         VARCHAR2(10)   := '_READ';

CURSOR diskgroup_cursor (dName   VARCHAR2) IS
  SELECT *
    FROM V$ASM_DISKGROUP
   WHERE name like dName||'%'
   ORDER BY usable_file_mb DESC;
/******************************************************************/
FUNCTION dbName RETURN STRING IS
mName                            V$DATABASE.NAME%TYPE;
BEGIN
  SELECT name
    INTO mName
    FROM v$database;
  RETURN mName;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'ERROR';
END;
/******************************************************************/
BEGIN

Name := DbName;
IF SUBSTR(Name,0,3) = 'DIT' THEN
  adminPass := '_ADMIN';
  crudPass := '_CRUD';
  Prefix := ''||Prefix;
ELSIF SUBSTR(Name,0,3) = 'SIT' THEN
  adminPass := '_c00ldave';
  crudpass := '_c00ldave';
  Prefix := ''||Prefix;
ELSIF SUBSTR(Name,0,3) = 'PER' THEN
  adminPass := '_c00ldave';
  crudpass := '_c00ldave';
  Prefix := ''||Prefix;
ELSIF SUBSTR(Name,0,3) = 'DEN' THEN
  adminPass := '_shak3r';
  crudpass := '_kkula';
  Prefix := 'DEN_';
ELSIF SUBSTR(Name,0,3) = 'MET' THEN
  adminPass := '_shak3r';
  crudpass := '_kkula';
  Prefix := 'QP_';
END IF;

IF Name IN ( 'DIT11' ) THEN
  tblspcCmd := tblspcCmd || project;
  tblspcCmd := tblspcCmd || ' datafile '||''''||'/u02/oradata/'||Name||'data/'||project||'''';
  tblspcCmd := tblspcCmd || ' size 200M autoextend on next 10M';
  tblspcCmd := tblspcCmd || ' maxsize unlimited extent management local';
  dbms_output.put_line (tblspcCmd);
  BEGIN
    EXECUTE IMMEDIATE (tblspcCmd);
  EXCEPTION
    WHEN OTHERS THEN
       dbms_output.put_line(SQLERRM);
  END;
ELSIF Name IN ( 'DIT' ) THEN
  tblspcCmd := tblspcCmd || project;
  tblspcCmd := tblspcCmd || ' datafile '||''''||'/u02/oradata/'||Name||'/'||project||'''';
  tblspcCmd := tblspcCmd || ' size 200M autoextend on next 10M';
  tblspcCmd := tblspcCmd || ' maxsize unlimited extent management local';
  dbms_output.put_line (tblspcCmd);
  BEGIN
    EXECUTE IMMEDIATE (tblspcCmd);
  EXCEPTION
    WHEN OTHERS THEN
       dbms_output.put_line(SQLERRM);
  END;
ELSE
  FOR i IN diskgroup_cursor (Name||'DATA') LOOP
    dbms_output.put_line (i.name);
    tblspcCmd := tblspcCmd || project;
    tblspcCmd := tblspcCmd || ' datafile '||''''||'+'||i.name||'''';
    tblspcCmd := tblspcCmd || ' size 200M autoextend on next 10M';
    tblspcCmd := tblspcCmd || ' maxsize unlimited extent management local';
    dbms_output.put_line (tblspcCmd);
    BEGIN
      EXECUTE IMMEDIATE (tblspcCmd);
    EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line(SQLERRM);
    END;
    EXIT;
  END LOOP;
END IF;

dbms_output.put_line ('Admin User ---');

sqlCmd := 'grant connect to '||Prefix||project||'_ADMIN identified by '||Prefix||project||adminPass;
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'alter user '||Prefix||project||'_admin default tablespace '||project||' temporary tablespace temp';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant resource to '||Prefix||project||'_admin';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant create table to '||Prefix||project||'_admin';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant create view to '||Prefix||project||'_admin';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant create materialized view to '||Prefix||project||'_admin';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant create synonym to '||Prefix||project||'_admin';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant ctxapp to '||Prefix||project||'_admin';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant analyze any to '||Prefix||project||'_admin';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

dbms_output.put_line ('Crud User ---');

sqlCmd := 'grant connect to '||Prefix||project||'_CRUD identified by '||Prefix||project||crudPass;
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'alter user '||Prefix||project||'_crud default tablespace '||project||' temporary tablespace temp';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant create synonym to '||Prefix||project||'_crud';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

dbms_output.put_line ('Read User ---');

sqlCmd := 'grant connect to '||Prefix||project||'_READ identified by '||Prefix||project||readPass;
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'alter user '||Prefix||project||'_read default tablespace '||project||' temporary tablespace temp';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

sqlCmd := 'grant create synonym to '||Prefix||project||'_read';
dbms_output.put_line (sqlCmd);
EXECUTE IMMEDIATE (sqlCmd);

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line (SQLERRM);
END;
/
exit
