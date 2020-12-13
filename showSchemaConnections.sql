SET LINE 200
SET VERIFY OFF

COLUMN osuser FORMAT A20
COLUMN machine FORMAT A20

define program = '%ATTP2G41%'

SELECT sid,serial#,schemaname,osuser,machine
  FROM v$session 
 WHERE schemaname LIKE '&program';
