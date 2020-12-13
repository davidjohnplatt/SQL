SET PAGESIZE 0
SET LINE 120

COLUMN owner FORMAT a20
COLUMN segment_name FORMAT a30

SELECT owner,segment_name,segment_type,tablespace_name 
  FROM dba_segments 
 WHERE tablespace_name = 'BELL41';
