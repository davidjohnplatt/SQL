select    a.TABLESPACE_NAME,
 ROUND(a.BYTES/1024000) ,
ROUND(b.BYTES/1024000) ,
round(((a.BYTES-b.BYTES)/a.BYTES)*100,2) 
from
 ( select  TABLESPACE_NAME,
 sum(BYTES) BYTES
 from    dba_data_files
 group   by TABLESPACE_NAME )
 a,
 ( select  TABLESPACE_NAME,
 sum(BYTES) BYTES ,
 max(BYTES) largest
 from    dba_free_space
 group   by TABLESPACE_NAME )
 b
 where    a.TABLESPACE_NAME=b.TABLESPACE_NAME
 order by ((a.BYTES-b.BYTES)/a.BYTES) desc ;

