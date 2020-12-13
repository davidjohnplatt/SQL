SET SERVEROUTPUT ON SIZE 1000000
DECLARE

printLine                    VARCHAR2(264);

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
    printLine := i.schema_name || '  ' || i.os_user;
    dbms_output.put_line(printLine);
    dbms_output.put_line(i.sample_sql1);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
exit
