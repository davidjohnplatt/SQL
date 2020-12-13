CREATE OR REPLACE PACKAGE DBA_ADMIN.html_util AS
/*********************************************************************************
     Author: D.J. Platt
     Date:   2002.01.28
     Purpose : Creates an HTML document with table information suitable for
               inclusion into Word.
*********************************************************************************/
PROCEDURE desc_table
  (p_tab_name   IN dba_tables.table_name%TYPE,
   p_owner      IN dba_tables.OWNER%TYPE);

PROCEDURE desc_index
  (p_index_name IN dba_indexes.table_name%TYPE,
   p_owner      IN dba_indexes.OWNER%TYPE);

PROCEDURE table_indexes
  (p_table_name IN dba_indexes.table_name%TYPE,
   p_owner      IN dba_indexes.OWNER%TYPE);

PROCEDURE write_head;

PROCEDURE write_tail;

END html_util;
/
