with u as
 (select s.ACCOUNT_CD,
         TERMINATING_ID,
         SEG_BP_START_DATE,
         SEG_ORIG_BP,
         trunc(EVENT_DATE_TIME, 'MONTH') as EVENt_MONTH,
         sum(ORIG_CHRG_PARAM_VAL) as cnt,
         sum(NET_USAGE_CHRG) as amount
    from soa_prm_ie_dtl_usage s
   where s.SEG_BP_START_DATE between to_date('01.09.2019', 'dd.mm.yyyy') and
         to_date('01.02.2020', 'dd.mm.yyyy')
     and s.ADDL_USAGE like '%,27,1,1%'
     and s.ACCOUNT_CD = '568095'
   group by s.ACCOUNT_CD,
            TERMINATING_ID,
            SEG_BP_START_DATE,
            SEG_ORIG_BP,
            trunc(EVENT_DATE_TIME, 'MONTH')),
n as
 (select s.ACCOUNT_CD,
         TERMINATING_ID,
         SEG_BP_START_DATE,
         SEG_ORIG_BP,
         trunc(EVENT_DATE_TIME, 'MONTH') as EVENt_MONTH,
         sum(ORIG_CHRG_PARAM_VAL) as cnt,
         sum(NET_USAGE_CHRG) as amount
    from soa_prm_ie_dtl_usage s
   where s.SEG_BP_START_DATE between to_date('01.09.2019', 'dd.mm.yyyy') and
         to_date('01.02.2020', 'dd.mm.yyyy')
     and s.ADDL_USAGE like '%,27,1,2%'
     and s.ACCOUNT_CD = '568095'
   group by s.ACCOUNT_CD,
            TERMINATING_ID,
            SEG_BP_START_DATE,
            SEG_ORIG_BP,
            trunc(EVENT_DATE_TIME, 'MONTH'))

select u.*, n.cnt, n.amount
  from u
  left join n
    on (u.ACCOUNT_CD = n.ACCOUNT_CD and u.TERMINATING_ID = o.TERMINATING_ID and
       u.EVENt_MONTH = n.EVENt_MONTH)
