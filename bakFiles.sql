SELECT owner,table_name
  FROM dba_tables
 WHERE table_name LIKE '%_BAK%'
 ORDER BY owner,table_name;
