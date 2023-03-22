
create or replace function yypm(v_exesql varchar, v_start_date date, v_days integer , out returnsql varchar) returns 
varchar AS $$
declare ii integer;
		calc_date date := v_start_date;
	--	returnsql varchar;
begin
	returnsql := '';
  FOR ii IN 1..v_days LOOP 		 		
	returnsql :=  returnsql || 'select  ' || v_exesql || '('''
				|| to_char(calc_date,'yyyy-mm-dd') || '''::date );
'; 
		calc_date := calc_date + interval '1 month';
  end loop;
  end;
$$ LANGUAGE plpgsql;

select yypp();

select yypo('bi_rpt.sp_r_fac_user_reg_right_add_tran', '20190101'::date , 304);
select yypw('bi_rpt.sp_r_fac_user_acti_with_s_tran', '20180101'::date , 53);
select yypm('bi_rpt.sp_r_fac_user_stock_with_s_tran', '20180131'::date , 20);

select '20191029'::date - '20190101'::date ;

select * from bi_adm.a_usr_user_ulog as a;
select count(*) from (
select t.schoolid, max(t.overdt) as mo  from bi_fdm.d_com_area_school  as t 
--where t.overdt > '20180101'::date  
group by t.schoolid)
as tt where tt.mo < '20991231'::date 
--group by mo order by mo ;

select * from bi_fdm.d_com_area_school as t where t.overdt = '20991231'::date;

select count(null ) ;

create table aa( a int , b varchar(10));
insert into aa values (1, null );
insert into aa values (2, null );
insert into aa values (3, null );

select count(10), count(2), count(a),count(b) from aa;

