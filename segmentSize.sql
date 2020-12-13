COLUMN segment_name format a30
SELECT segment_name,segment_type,bytes/1024/1024 megabytes
   FROM dba_segments
  WHERE owner = 'QP_SIRIUSXM32_ADMIN'
    AND segment_type = 'TABLE'
    AND segment_name LIKE '%'
   ORDER BY bytes/1024/1024 ASC
;
