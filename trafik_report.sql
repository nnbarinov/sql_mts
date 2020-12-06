with param1 as
 (select '01.06.2020' as dm from dual), /*дата начала месЯца*/

d as
 (select to_date(dm, 'dd.mm.yyyy') + level - 1 as days
    from param1
  connect by level <=
             extract(day from add_months(to_date(dm, 'dd.mm.yyyy'), 1) - 1)),

dt as
 (select max(days) as lday, min(days) as fday from d),

x as
 (select trunc(au.EVENT_DATE) as evdate,
         sum(decode(ev.event_cd, 'SMST', au.TOT_CHRG_PARAM_VAL, 0)) as SMST,
         sum(decode(ev.event_cd, 'SUBT', au.TOT_CHRG_PARAM_VAL, 0)) as SUBT,
         sum(decode(ev.event_cd, 'SMSP', au.TOT_CHRG_PARAM_VAL, 0)) as SMSP,
         sum(decode(ev.event_cd, 'SUBP', au.TOT_CHRG_PARAM_VAL, 0)) as SUBP
    from ic_accumulated_usage au, icg_events ev, dt
   where au.EVENT_ID = ev.event_id
     and au.PROD_ID = ev.prod_id
     and au.FUTURE_9 = '1' --  '1' - условно оплаченный, '2' - неоплата, отриц.значения, '3' - оплата прошлых периодов, 'N' - рекламации 
     and trunc(au.EVENT_DATE) between dt.fday and dt.lday
   group by trunc(au.EVENT_DATE))

select to_char(d.days, 'dd.mm.yyyy') as days,
       x.SMST + x.SUBT as TechTrafic,
       x.SMSP + x.SUBP as PaydTrafic
  from d
  left join x
    on (d.days = x.evdate)
 order by d.days
