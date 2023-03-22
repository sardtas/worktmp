select 'grant all privileges on ' || n.nspname || '.' ||  t.relname || ' to bi_log;' 
from pg_catalog.pg_class t,  
     pg_catalog.pg_namespace n 
where t.relnamespace = n.oid 
and t.relkind = 'r'
and t.relname like 'c%';

grant select, insert , delete  on public.c_cfg_glob_logg to bi_log;
grant select, insert , delete on public.c_cfg_glob_para to bi_log;
grant select, insert , delete on public.c_cfg_glob_stat to bi_log;
grant select, insert , delete on public.c_cfg_load_column to bi_log;
grant select, insert , delete on public.c_cfg_load_info to bi_log;
grant select, insert , delete on public.c_cfg_mail_info to bi_log;
grant select, insert , delete on public.c_cfg_tran_info to bi_log;
grant select, insert , delete on public.c_cfg_tran_mapp to bi_log;
grant select, insert , delete on public.c_cfg_tran_recy to bi_log;


