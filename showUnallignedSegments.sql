SET PAGESIZE 0
SET LINE 120

COLUMN owner FORMAT a25
COLUMN segment_name FORMAT a30

SPOOL ON

SELECT owner,segment_name,segment_type,tablespace_name 
  FROM dba_segments 
 WHERE owner like 'QP_%_ADMIN'
   AND tablespace_name NOT LIKE SUBSTR(owner,4,LENGTH(owner) - 9)||'%';

SPOOL off

