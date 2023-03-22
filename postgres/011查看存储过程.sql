
select  pn.nspname || '.' || pp.proname, pp.prosrc, pa.rolname, pa.oid  
 from pg_proc pp , pg_authid pa , pg_catalog.pg_namespace pn 
where pp.proowner = pa.oid 
  and pp.pronamespace = pn.oid
 -- and pa.rolname = 'dc'
  and pp.prosrc like '%d_sal_b_comsncountlog%'  
  ;
bi_adm.sp_a_fac_empyibi_rise_tran;
bi_fdm.sp_d_oadt_pubpermlog_tran;
bi_adm.sp_a_fac_empyibi_rise_tran
bi_rpt.sp_r_tmp_havefeedata_tran
select public.fc_p_get_date( '20190305'::date, 'WB');

select bi_rt_rpt.sp_rtr_rpt_seller_overview_tran('20190301'::date, 'M');
