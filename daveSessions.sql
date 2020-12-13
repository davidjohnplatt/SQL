SET SERVEROUTPUT ON SIZE 1000000
SET HEADING ON
--SET TERMOUT OFF
SET ARRAYSIZE 20
SET FEEDBACK 0
SET PAGESIZE 0
SET LINESIZE 20000
SET VERIFY OFF
SET SPACE 0
--SET TITLE "HI"
SET COLSEP '    '
SET TRIMSPOOL ON  


DECLARE
CURSOR dummy_cursor IS
SELECT 'Machine' machine, 'O/S User' os_user, 'O/S Process ID' os_process_id,
       'Schema Name' schema_name, 'Program' program,
       'Oracle Session ID' oracle_session_id, 'Logon Time' logon_time,
       'Cumulative CPU Used by Session' cpu_used, 'Sample SQL 1' sample_sql1,
       'Sample SQL 2' sample_sql2
  FROM DUAL;

CURSOR drive_cursor IS
SELECT   a.machine, a.osuser os_user, d.spid os_process_id,
         a.schemaname schema_name, a.program, a.SID oracle_session_id,
         a.logon_time, b.VALUE cpu_used,
         NVL (MIN (c.sql_text), MIN (e.sql_text)) sample_sql1,
         NVL (MAX (c.sql_text), MAX (e.sql_text)) sample_sql
    FROM gv$session a,
         (SELECT *
            FROM v$sesstat
           WHERE statistic# = 12) b,
         gv$sql c,
         gv$process d,
         gv$open_cursor e
   WHERE a.SID = b.SID(+)
     AND a.paddr = d.addr(+)
     AND a.inst_id = d.inst_id(+)
     AND a.sql_address = c.address(+)
     AND a.inst_id = c.inst_id(+)
     AND a.SID = e.SID(+)
     AND a.inst_id = e.inst_id(+)
     AND a.inst_id = 1
     AND a.schemaname = 'QP_BELLTV414_ADMIN'
GROUP BY a.SID,
         a.schemaname,
         a.logon_time,
         a.osuser,
         d.spid,
         a.machine,
         a.program,
         b.VALUE
ORDER BY TO_NUMBER (b.VALUE) DESC NULLS LAST;

BEGIN
FOR i IN drive_cursor LOOP
   dbms_output.put_line(RPAD(i.machine, 20)||RPAD(i.os_user,15)||RPAD(i.schema_name,30)||i.sample_sql1);
END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/

