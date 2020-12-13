SET SERVEROUTPUT ON SIZE 1000000

DECLARE

seqName                     VARCHAR2(50)          := 'META_CONTENT_SEQ';
increment                   NUMBER                := 2000;

seqNo                       NUMBER                := 0;
sqlCmd                      VARCHAR2(1000);

BEGIN
  sqlCmd := 'ALTER SEQUENCE '||seqName||' INCREMENT BY '||increment;
  dbms_output.put_line (sqlCmd);

  sqlCmd := 'SELECT '||seqName||'.NEXTVAL INTO seqNo FROM DUAL';
  dbms_output.put_line (sqlCmd);
  EXECUTE IMMEDIATE sqlCmd;

  sqlCmd := 'ALTER SEQUENCE '||seqName||' INCREMENT BY 1';
  dbms_output.put_line (sqlCmd);

  dbms_output.put_line (seqName||' = '||seqNo);
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line (SQLERRM);
END;
/
