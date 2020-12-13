SET LINE 150
SET HEADING OFF
SET PAGESIZE 0

SELECT 'sqlplus ' || username || '/' || username
  FROM dba_users 
 WHERE username LIKE '%READ' 
 ORDER BY username
/

