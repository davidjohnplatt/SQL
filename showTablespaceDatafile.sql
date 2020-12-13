SET LINE 132
SET PAGESIZE 0
COLUMN file_name FORMAT A70
SELECT tablespace_name, file_name 
  FROM dba_data_files
 ORDER BY tablespace_name;

select    a.TABLESPACE_NAME,
 ROUND(a.BYTES/1024000) “Used (MB)”,
ROUND(b.BYTES/1024000) “Free (MB)”,
round(((a.BYTES-b.BYTES)/a.BYTES)*100,2) “% USED”;
from
 (
 select  TABLESPACE_NAME,
 sum(BYTES) BYTES
 from    dba_data_files
 group   by TABLESPACE_NAME
 )
 a,
 (
 select  TABLESPACE_NAME,
 sum(BYTES) BYTES ,
 max(BYTES) largest
 from    dba_free_space
 group   by TABLESPACE_NAME
 )
 b
 where    a.TABLESPACE_NAME=b.TABLESPACE_NAME
 and a.TABLESPACE_NAME like ‘%’
order      by ((a.BYTES-b.BYTES)/a.BYTES) desc ;