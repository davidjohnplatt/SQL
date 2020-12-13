COLUMN get_system_change_number FORMAT 999999999999
SELECT dbms_flashback.get_system_change_number 
  FROM DUAL;
exit
