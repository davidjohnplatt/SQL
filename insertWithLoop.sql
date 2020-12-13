DECLARE

iter          NUMBER            := 0;

BEGIN

LOOP
  EXIT WHEN iter > 100;
  iter := iter + 1;
  insert into splex.demo_src 
    values ('Jim','231 Cherryhill Rd.',TO_CHAR(SYSDATE,'DD HH:MI:SS'));
END LOOP;
 
EXCEPTION
  WHEN OTHERS THEN 
    dbms_output.put_line(SQLERRM);
END;
/
COMMIT;
EXIT
