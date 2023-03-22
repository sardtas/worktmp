CREATE OR REPLACE FUNCTION public.sp_get_rt_rpt_tran_info()
 RETURNS TABLE(io_dir character varying, object_layer character varying, object_class character varying, table_name character varying, current_start_time timestamp without time zone, current_end_time timestamp without time zone, dispatch_type character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE log_procedure      VARCHAR(64) :='sp_get_rt_rpt_tran_info'; --处理过程名
        log_procedure_name VARCHAR(64) :='定时加载表获取脚本'; --处理过程中文名
BEGIN

	for i in (select relname  from ( select oid as toid, * from  pg_class ) as t 
				left  join  information_schema.tables as it on  t.relname = it.table_name
				  WHERE 1=1 and t.relkind = 'r' )
    loop
    --看一些大表的使用次数
		select  pn.nspname || '.' || pp.proname, count( pa.oid  )
		 from pg_proc pp , pg_authid pa , pg_catalog.pg_namespace pn 
		where pp.proowner = pa.oid 
		  and pp.pronamespace = pn.oid
		 -- and pa.rolname = 'dc'
		  and pp.prosrc like '%'|| i || '%'  
	  group by  pn.nspname || '.' || pp.proname
		  ;
    
    end loop;
 

 
 
    RETURN;
END;
$function$
;
