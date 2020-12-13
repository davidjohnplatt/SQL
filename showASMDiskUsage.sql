
SET LINE 250
COL Diskgroup FORMAT a15
COL total_mb FORMAT 999,999,999
COL free_mb FORMAT 999,999,999

SELECT name, type, total_mb, free_mb, required_mirror_free_mb, usable_file_mb
  FROM v$asm_diskgroup;