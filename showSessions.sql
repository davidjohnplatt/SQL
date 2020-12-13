SET PAGESIZE 24

SELECT inst_id,username,count(*) sessions 
  FROM gv$session 
 GROUP BY inst_id,username 
 ORDER BY username,inst_id;
exit
