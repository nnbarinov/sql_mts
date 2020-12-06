update  BNN_PRM_DAT_ERR_MNGR t1 
set t1.adu = replace(t1.adu, substr(t1.adu, instr(t1.adu, 'N')+ 15, 14), substr(t1.adu, instr(t1.adu, 'N')+ 1, 14) 
where  1=1 
   and t1.DOMINANT_ERR_CD=t2.ERROR_CODE 
   and t1.sys_creation_date >= (sysdate) - 5 --/2 --/ 6 --- + 17/24 + 10/24/60 
   and t1.terminating_id = '482_21001_000001' 
   and IECD  in ('SMSS') 
