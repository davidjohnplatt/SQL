CREATE OR REPLACE PACKAGE BODY DBA_ADMIN.html_util AS
/*********************************************************************************/
PROCEDURE write_head AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('<html>');
  DBMS_OUTPUT.PUT_LINE('<head>');
  DBMS_OUTPUT.PUT_LINE('<style>');
  DBMS_OUTPUT.PUT_LINE('P { page-break-after: always }');
  DBMS_OUTPUT.PUT_LINE('</style>');
  DBMS_OUTPUT.PUT_LINE('</head>');
  DBMS_OUTPUT.PUT_LINE('<body>');
  
END write_head;
/*********************************************************************************/
PROCEDURE write_tail AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('</body>');
  DBMS_OUTPUT.PUT_LINE('</html>');
END;
/*********************************************************************************/
PROCEDURE error_out(p_one IN VARCHAR2,p_two IN  VARCHAR2) AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('ERROR - '||p_one||' '||p_two);
EXCEPTION
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('ERROR - error '||SQLERRM);
     RAISE;
END error_out;
/*********************************************************************************/
FUNCTION getTableComment(p_owner       dba_tab_comments.owner%TYPE,
                         p_table_name  dba_tab_comments.table_name%TYPE)
RETURN VARCHAR2 AS
m_comment               VARCHAR2(4000);
BEGIN
  SELECT comments
    INTO m_comment
    FROM dba_tab_comments
   WHERE owner = p_owner
     AND table_name = p_table_name;
  RETURN m_comment;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     RETURN 'Table Comment Not Found';
  WHEN OTHERS THEN
     error_out('getTableComments',SQLERRM);
END getTableComment;
/*********************************************************************************/
FUNCTION getColumnComment(p_table_owner  dba_col_comments.owner%TYPE,
                          p_table_name   dba_col_comments.table_name%TYPE,
                          p_column_name  dba_col_comments.column_name%TYPE)
RETURN VARCHAR2 AS
m_comment               VARCHAR2(4000);
BEGIN
  SELECT comments
    INTO m_comment
    FROM dba_col_comments
   WHERE owner = p_table_owner
     AND table_name = p_table_name
     AND column_name = p_column_name;
  RETURN m_comment;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     RETURN 'Column Comment Not Found';
  WHEN OTHERS THEN
     error_out('getColumnComments',SQLERRM);
END getColumnComment;
/********************************************************************************/
FUNCTION getPrimaryKeyConstraint(p_owner      dba_constraints.owner%TYPE,
                                 p_table_name dba_constraints.constraint_name%TYPE)
RETURN VARCHAR2 AS
  m_constraint_name              dba_constraints.constraint_name%TYPE;
BEGIN
  SELECT constraint_name
    INTO m_constraint_name
    FROM dba_constraints
   WHERE OWNER = p_owner
     AND table_name = p_table_name
     AND constraint_type = 'P';
  RETURN m_constraint_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     RETURN 'No Primary Key';
  WHEN OTHERS THEN
     error_out('getPrimaryKeyConstraint',SQLERRM);
END getPrimaryKeyConstraint;
/*********************************************************************************/
PROCEDURE desc_table
  (p_tab_name IN dba_tables.table_name%TYPE,
   p_owner      IN dba_tables.OWNER%TYPE)
AS
--  HTML constants
  tabdef                        VARCHAR2(40) := '<table BORDER COLS=6 WIDTH="100%" >';
  tabend                        VARCHAR2(10) := '</table>';
  tr                            VARCHAR2(4) := '<tr>';
  tr_                           VARCHAR2(5) := '</tr>';
  td                            VARCHAR2(4) := '<td>';
  td_                           VARCHAR2(5) := '</td>';
  font                          VARCHAR2(16) := '<font size = -1>';
  font_                         VARCHAR2(7) := '</font>';
  bold                          VARCHAR2(7) := '<b>';
  bold_                         VARCHAR2(7) := '</b>'; 
   

  k_notnull                     VARCHAR2(9) := 'NOT NULL';


  m_table_name                  user_tables.table_name%TYPE;
  m_cons_name                   user_constraints.constraint_name%TYPE;
  m_cons_num                    NUMBER;
  m_cons_status                 user_constraints.status%TYPE;
  m_owner                       NUMBER;
  m_schema_name                 dba_tables.owner%TYPE;
  m_object                      NUMBER;

  m_string                      VARCHAR2(4000);
  m_rtable                      dba_tables.table_name%TYPE;

  i                             NUMBER;

  curr_rec                    user_tab_columns%ROWTYPE;
  m_column_name               user_tab_columns.column_name%TYPE;
  m_col_num                   NUMBER;
  m_data_type                 VARCHAR2(15);
  m_data_scale                NUMBER;
--
  CURSOR getTableColumns_cur (c_owner VARCHAR2,c_table_name  VARCHAR2) IS
       SELECT *
         FROM dba_tab_columns
        WHERE owner = c_owner
          AND table_name = c_table_name;
--
  CURSOR getConstraintCols(c_owner VARCHAR2,c_table_name VARCHAR2) IS
    SELECT *
      FROM dba_constraints
     WHERE owner = c_owner
       AND table_name = c_table_name
       AND constraint_type NOT IN ('P','R')
       AND constraint_name not like 'NN%';
--
  CURSOR getForeignKeyConstraints(c_owner VARCHAR2, c_table_name VARCHAR2) IS
    SELECT constraint_name,r_constraint_name
       FROM dba_constraints
      WHERE owner = c_owner
        AND table_name = c_table_name
        AND constraint_type = 'R'
        AND r_constraint_name IS NOT NULL;
--
  CURSOR getIndexes(c_table_name  VARCHAR2,c_schema_name VARCHAR2) IS
    SELECT index_name, uniqueness
      FROM dba_indexes
     WHERE table_name = c_table_name
       AND owner = c_schema_name;
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);

  m_table_name := UPPER(p_tab_name);
  m_schema_name := UPPER(p_owner);
  m_string := getTableComment(m_schema_name,m_table_name);
  DBMS_OUTPUT.PUT_LINE('<P><BR>');
--  <H2><A name="section1">Introduction</A></H2>
  DBMS_OUTPUT.PUT_LINE('<H2><A name="'||m_table_name||'">'||m_table_name||'</A></H2>');
  DBMS_OUTPUT.PUT_LINE(tabdef);
  DBMS_OUTPUT.PUT_LINE(tr||td||font||'Table Name'||font_||td_);
  DBMS_OUTPUT.PUT_LINE(td||m_table_name||td_||tr_);
  DBMS_OUTPUT.PUT_LINE(tr||td||font||'Table Comment'||font_||td_);
  DBMS_OUTPUT.PUT_LINE(td||font||m_string||font_||td_||tr_);
  DBMS_OUTPUT.PUT_LINE(tabend);
  DBMS_OUTPUT.PUT_LINE(tabdef);

--  OPEN tab_column_cursor;
  i:=0;
  DBMS_OUTPUT.PUT_LINE(tr||td||font||bold||'Column Name'||bold_||td_);
  DBMS_OUTPUT.PUT_LINE(td||font||bold||'Column Type'||bold_||td_);
  DBMS_OUTPUT.PUT_LINE(td||font||bold||'Constraint'||bold_||td_);
  DBMS_OUTPUT.PUT_LINE(td||font||bold||'Init Value'||bold_||td_);
  DBMS_OUTPUT.PUT_LINE(td||font||bold||'Comments'||bold_||td_||tr_);
  FOR getColumns IN getTableColumns_cur(m_schema_name,m_table_name)
  LOOP

    m_string := SUBSTR(getColumnComment(m_schema_name,m_table_name,getColumns.column_name),1,225);
       DBMS_OUTPUT.PUT_LINE(tr||td||font||getColumns.column_name||td_);
    IF getColumns.data_type = 'NUMBER' THEN
      IF getColumns.data_scale = 0 THEN
        DBMS_OUTPUT.PUT_LINE(td||font||getColumns.data_type||'('||getColumns.data_precision||')'||td_);
      ELSE
        DBMS_OUTPUT.PUT_LINE(td||font||getColumns.data_type||td_);
      END IF;
    ELSIF getColumns.data_type = 'DATE' THEN
      DBMS_OUTPUT.PUT_LINE(td||font||getColumns.data_type||td_);
    ELSE
      DBMS_OUTPUT.PUT_LINE(td||font||getColumns.data_type||'('||getColumns.data_length||')'||td_);
    END IF;
--
    IF getColumns.nullable = 'N' THEN
      DBMS_OUTPUT.PUT_LINE(td||font||k_notnull||td_);
    ELSE
      DBMS_OUTPUT.PUT_LINE(td||td_);
    END IF;
--
    DBMS_OUTPUT.PUT_LINE(td||font||getColumns.data_default||td_);
    DBMS_OUTPUT.PUT_LINE(td||font||m_string||td_);
--
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(tabend);
--
  m_cons_name := getPrimaryKeyConstraint(m_schema_name,m_table_name);
  DBMS_OUTPUT.PUT_LINE(tabdef);
  DBMS_OUTPUT.PUT_LINE(tr||td||'Primary Key'||td_);
  DBMS_OUTPUT.PUT_LINE(td||m_cons_name||td_||tr_);
--
  m_string := 'Foreign Keys';
  FOR getFor IN getForeignKeyConstraints(m_schema_name,m_table_name) LOOP
    DBMS_OUTPUT.PUT_LINE(tr||td||m_string||td_);
    DBMS_OUTPUT.PUT_LINE(td||getFor.constraint_name||td_);
    BEGIN
      SELECT table_name
        INTO m_rtable
        FROM dba_constraints
       WHERE owner = m_schema_name
         AND constraint_name = getFor.r_constraint_name;
    EXCEPTION
      WHEN OTHERS THEN
         error_out(SQLCODE,SQLERRM);
    END;
    DBMS_OUTPUT.PUT_LINE(td||'References'||td_);
--    DBMS_OUTPUT.PUT_LINE(td||m_rtable||td_||tr_);
    DBMS_OUTPUT.PUT_LINE(td||'<A href="#'||m_rtable||'">'||m_rtable||'</A>'||td_);
    m_string := '';
  END LOOP;
--
  m_string := 'Table Constraints';
--  DBMS_OUTPUT.PUT_LINE(tr||td||td_||td||m_cons_name||td_||tr_);
  FOR getcon IN getConstraintCols(m_schema_name,m_table_name) LOOP
    DBMS_OUTPUT.PUT_LINE(tr||td||m_string||td_);
    DBMS_OUTPUT.PUT_LINE(td||getcon.constraint_name||td_||tr_);
    m_string := '';
  END LOOP;
--
  m_string := 'Indexes';

  FOR getidx IN getIndexes(m_table_name,m_schema_name) LOOP
    DBMS_OUTPUT.PUT_LINE(tr||td||m_string||td_);
    DBMS_OUTPUT.PUT_LINE(td||'<A href="#'||getidx.index_name||'">'||getidx.index_name||'</A>'||td_);
    DBMS_OUTPUT.PUT_LINE(td||getidx.uniqueness||td_||tr_);
    m_string := '';
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(tabend);
END desc_table;
/*********************************************************************************/
PROCEDURE desc_index
  (p_index_name IN dba_indexes.table_name%TYPE,
   p_owner    IN dba_indexes.OWNER%TYPE)
AS
--  HTML constants
  tabdef                        VARCHAR2(40) := '<table BORDER COLS=6 WIDTH="100%" >';
  tabend                        VARCHAR2(10) := '</table>';
  tr                            VARCHAR2(4) := '<tr>';
  tr_                           VARCHAR2(5) := '</tr>';
  td                            VARCHAR2(4) := '<td>';
  td_                           VARCHAR2(5) := '</td>';
  font                          VARCHAR2(16) := '<font size = -1>';
  font_                         VARCHAR2(7) := '</font>';
  bold                          VARCHAR2(3) := '<b>';
  bold_                         VARCHAR2(4) := '</b>';
--
  m_index_name                  dba_ind_columns.index_name%TYPE;
  m_table_name                  dba_ind_columns.table_name%TYPE;
  m_ind_string                  dba_ind_columns.index_name%TYPE;
  m_tab_string                  dba_ind_columns.table_name%TYPE;
--
  CURSOR getIndexColumns(c_index_name  VARCHAR2,c_schema_name VARCHAR2) IS
    SELECT *
      FROM dba_ind_columns
     WHERE index_name = c_index_name
       AND index_owner = c_schema_name
     ORDER BY column_position;
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
--
  m_index_name := UPPER(p_index_name);
  DBMS_OUTPUT.PUT_LINE('<H2><A name="'||m_index_name||'">'||m_index_name||'</A></H2>');
  DBMS_OUTPUT.PUT_LINE(tabdef);
  DBMS_OUTPUT.PUT_LINE(tr||td||font||bold||'Table Name'||bold_||td_);
  DBMS_OUTPUT.PUT_LINE(td||font||bold||'Index Name'||bold_||td_);
  DBMS_OUTPUT.PUT_LINE(td||font||bold||'Column Name'||bold_||td_);
  DBMS_OUTPUT.PUT_LINE(td||font||bold||'Column Order'||bold_||td_||tr_);
  FOR cur_rec IN getIndexColumns(m_index_name,p_owner) LOOP
    DBMS_OUTPUT.PUT_LINE(tr);
    IF cur_rec.column_position = 1 THEN
--      DBMS_OUTPUT.PUT_LINE(td||font||cur_rec.table_name||td_);
      DBMS_OUTPUT.PUT_LINE(td||'<A href="#'||cur_rec.table_name||'">'||cur_rec.table_name||'</A>'||td_);
      DBMS_OUTPUT.PUT_LINE(td||font||cur_rec.index_name||td_);
    ELSE
      DBMS_OUTPUT.PUT_LINE(td||' '||td_);
      DBMS_OUTPUT.PUT_LINE(td||' '||td_);
    END IF;
    DBMS_OUTPUT.PUT_LINE(td||font||cur_rec.column_name||td_);
    DBMS_OUTPUT.PUT_LINE(td||font||cur_rec.column_position||td_);
    DBMS_OUTPUT.PUT_LINE(tr_);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(tabend);
  DBMS_OUTPUT.PUT_LINE('<br>');
END desc_index;
/*********************************************************************************/
PROCEDURE table_indexes
  (p_table_name IN dba_indexes.table_name%TYPE,
   p_owner      IN dba_indexes.owner%TYPE)
AS
--
  m_table_name                  dba_ind_columns.table_name%TYPE;
--
  CURSOR getTableIndexes(c_table_name  VARCHAR2,c_schema_name VARCHAR2) IS
    SELECT *
      FROM dba_indexes
     WHERE table_name = c_table_name
       AND owner = c_schema_name;
--
BEGIN
  m_table_name := UPPER(p_table_name);
  FOR cur_rec IN getTableIndexes(m_table_name,p_owner) LOOP
    desc_index(cur_rec.index_name,p_owner);

  END LOOP;
--
END table_indexes;
--
END html_util;
/
