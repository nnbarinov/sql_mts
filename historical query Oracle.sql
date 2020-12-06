select distinct (new_file_name) from PRM_LSN_ERR_MNGR as of timestamp (systimestamp-interval '6000' second) 
where 1=1
  and sys_creation_date >= to_date('24.04.2020','dd.mm.yyyy')
  and error_cd='LS05' 
