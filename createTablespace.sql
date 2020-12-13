create tablespace  ROGERSVDS41B
--datafile '+SITSdata' 
  datafile '/u02/oradata/DIT/ROGERSVDS41B' 
            size 200M
            autoextend on 
            next 10M maxsize unlimited
            extent management local;
