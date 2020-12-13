SET PAGESIZE 24

SELECT inst_id,username,count(*) sessions 
  FROM gv$session 
 WHERE status = 'ACTIVE'
   AND username LIKE 'QP_%'
 GROUP BY inst_id,username 
 ORDER BY inst_id,username;
exit
