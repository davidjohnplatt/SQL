SET PAGESIZE 0
SET LINE 120

COLUMN owner FORMAT a20
COLUMN segment_name FORMAT a30

SELECT owner,segment_name,segment_type,tablespace_name 
  FROM dba_segments 
 WHERE owner = 'QP_UATIPHONE41_ADMIN'
 ORDER BY segment_type,segment_name;
