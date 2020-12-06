with p as
 (select to_date('01.01.2020', 'dd.mm.yyyy') as date_from,
         to_date('30.06.2020', 'dd.mm.yyyy') as date_to
    from dual),
e3 as
 (select count(distinct(l.new_file_name)) as qty
    from PRM_LSN_ERR_MNGR l, p
   where 1 = 1
     and l.sys_creation_date between p.date_from and p.date_to),
a3 as
 (select count(distinct(file_name)) as qty
    from AC_PHYSICAL_FILES f, p
   where 1 = 1
     and f.sys_creation_date between p.date_from and p.date_to),
e4 as
 (select count(*) as qty
    from PRM_DAT_ERR_MNGR er, p
   where 1 = 1
     and er.sys_creation_date between p.date_from and p.date_to),
a4 as
 (select count(*) as qty
    from soa_prm_ie_dtl_usage ac, p
   where 1 = 1
     and ac.SEG_BP_START_DATE between p.date_from and p.date_to)

select 'Загрузка трафика, поступающего из IL' as kpe_mame,
       round(100 * (a3.qty - e3.qty) / a3.qty, 2) as kpe_val
  from e3, a3
union
select 'Разбор ошибок, возникающих при загрузке трафика' as kpe_mame,
       round(100 * (a4.qty - e4.qty) / a4.qty, 2) as kpe_val
  from e4, a4
