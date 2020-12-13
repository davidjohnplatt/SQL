COLUMN  percentused FORMAT 999.9

SELECT name,
       total_mb,
       total_mb - free_mb used_mb,
       free_mb,
       (total_mb - free_mb) / total_mb * 100 percentused 
  FROM v$asm_diskgroup;
