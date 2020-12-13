select inst_id,count(*) sessions from gv$session group by inst_id order by inst_id;
select inst_id,count(*) processes from gv$process group by inst_id order by inst_id;
exit
