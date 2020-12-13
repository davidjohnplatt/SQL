SET LINE 150
SET HEADING OFF
SET PAGESIZE 0

SELECT username,account_status,default_tablespace,temporary_tablespace 
  FROM dba_users 
 WHERE username LIKE '%ADMIN' 
 ORDER BY username
/

