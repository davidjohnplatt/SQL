select * from nls_content where rownum < 2;

select * from content_encoding where rownum < 2;

select max(meta_id) from meta_content;

select * from meta_content where rownum < 2;


   

purge recyclebin;


create sequence temp_seq;

select 'prepareInsertContact.'||
       decode(data_type,'NUMBER','setInt ','VARCHAR2','setString ','DATE','setTimestamp ','String ')||
        '('||
        temp_seq.nextval|| 
        ','|| 
        LOWER(column_name)||'_'||
        ');'      
from user_tab_columns where table_name = 'CONTACT';

select decode(data_type,'NUMBER','int ','VARCHAR2','String ','DATE','java.sql.Timestamp ','String ')||
       lower(column_name)||'_'||' = EncSet.'||
       decode(data_type,'NUMBER','getInt ','VARCHAR2','getString ','DATE','getTimestamp ','getString ')||
       ' ("'||column_name||'");' 
from user_tab_columns where table_name = 'CONTACT';




