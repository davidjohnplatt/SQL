SET LINE 132
SET PAGESIZE 0
COLUMN username FORMAT A23
COLUMN sql_text FORMAT A80

SELECT a.username, b.executions, b.sql_text
  FROM v$session a, v$sqlarea b
 WHERE a.sql_address=b.address
   AND username NOT LIKE 'SYS%'
 ORDER BY b.executions;
