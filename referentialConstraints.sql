SET LINE 250

select owner,constraint_name,r_owner,r_constraint_name
    from dba_constraints
   where constraint_type = 'R' 
    and table_name = 'CONSUMPTION_TRACKING'
    and owner = 'QP_BELLNHL41_ADMIN';
