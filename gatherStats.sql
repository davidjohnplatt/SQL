DECLARE
BEGIN
  dbms_stats.gather_schema_stats(ownname=> 'QP_BELLTV414_ADMIN' , cascade=> TRUE);
END;
/
