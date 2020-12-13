SET LINE 132
SET PAGESIZE 30

COLUMN member FORMAT A50

SELECT lf.group#,lf.status,lf.member 
  FROM v$logfile lf
 ORDER BY group#;

SELECT group#,thread#,sequence#,bytes,members,archived,status
  FROM v$log
 ORDER BY  group#,thread#,sequence#;

SELECT 'ALTER DATABASE DROP LOGFILE GROUP '|| group#||';'
  FROM v$log
 WHERE status = 'INACTIVE'
   AND group# < 30
 ORDER BY  group#;

exit
