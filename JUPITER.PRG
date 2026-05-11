clear 
set talk off
set date brit
set cent on
set dele on
set cpdi off
set safe off
close table all

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&OUTSITDE PATHE PRG&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')
	lastdate= ctod('31/03/2026')
	datdev='d:\transfer\'
	datext= 'dbf'
endif


sure = space(4)
DATATRANSFERPATH=substr('D:\2025\Oct\jupiter\jupiter\'+space(70),1,70)
DATATRANSFEREXT='DBF'
old_3 = 'YES'
old_4 = 'YES'
old_5 = ctod('01/04/2025')
old_6 = '2'
@ 10,10 say 'OLD DATA FROM :' get DATATRANSFERPATH
@ 11,10 say 'OLD Extension :' get DATATRANSFERExt
@ 12,10 say 'WITH O/S      :' get old_3 PICT '@m YES,NO '
@ 13,10 say 'F.Y.BEGIN FROM:' get old_5
@ 14,10 say 'FORMAT        :' get old_6 PICT '@m 1,2' 
@ 15,10 say 'Type SURE     :' get sure Pict '@x!'
read

DATATRANSFERPATH=alltrim(DATATRANSFERPATH)
DATDEV=alltrim(DATDEV)
DATEXT=alltrim(DATEXT)
if lastkey()=27 .and. sure#'SURE'
   return
endif
clear
set colo to N/W
@ 11,22 fill to 13,62 colo N+
@ 10,20 clea to 12,60
@ 10,20 to 12,60
set colo to N/W*
@ 11,22 say 'PLEASE WAIT PIPING DATA TO MARG.....'
set colo to
if type('FINALCP')#'U'
	=STARTTRANSFER()
endif
set colo to
sele sele(1)
use &datdev\glmonth.&datext
zap
use &datdev\ggmonth.&datext
zap
use &datdev\pro.&datext
zap
use &datdev\order.&datext
zap
use &datdev\saletype.&datext
zap
use &datdev\gledger.&datext
zap
use &datdev\pendings.&datext
zap
use &datdev\pend.&datext
zap
use &datdev\probat.&datext
zap
use &datdev\maorder.&datext
zap
use &datdev\sborder.&datext
zap
use &datdev\mdis.&datext
zap
use &datdev\dis.&datext
zap
use &datdev\glmonth.&datext
zap
use &datdev\ggmonth.&datext
zap
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F'
pack
close data
set colo to


?'** Transfer ITEM'
fd=DATATRANSFERPATH+'itemmast.dbf'
fp=DATATRANSFERPATH+'itemtran.dbf'
td=DATDEV+'\pro.'+DATEXT
sele c
use &fp alias fitt
index on item_code to fitt
sele a
use &fd alias fitm
sele b
use &td alias mitm 
zap
index on name to mitm
sele fitm
go top
do while .not. eof()
   last=recno()
   sele fitt
   seek fitm.item_code
   sele mitm
   append blank
   repl mitm.code with fitm.item_code
   repl mitm.name with str(fitt.item_tran_,10)
   repl mitm.product with fitm.item_name
   repl mitm.packing with fitt.pack_id
   repl mitm.billname with alltrim(fitm.item_name)
   repl mitm.pack with fitt.unit_per_p
   repl mitm.unit with 'Pcs'
   repl mitm.gcode with str(fitm.mfr_key,6)
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.salsc with fitt.cst_purc
   repl mitm.saltax with fitt.tngst_purc
   repl mitm.pursc with fitt.cst_purc
   repl mitm.purtax with fitt.cst_purc
   repl mitm.status with 'Y'
   repl mitm.misc5 with substr(mitm.misc5,1,1)+iif(fitt.incl_tax=1,'I','E')+substr(mitm.misc5,3,100)
   repl mitm.prate with fitt.pur_rate
   repl mitm.ratea with fitt.sal_rate
   repl mitm.mrp with fitt.mrp
   repl mitm.lprate with fitt.cl_stk_rat
   sele fitm
   skip
enddo
close table all

?'** Transfer COMPANY'
fd=DATATRANSFERPATH + 'mfr.dbf'
td=DATDEV + '\saletype.'+DATEXT
sele a
use &fd alias fpcm 
sele b
use &td alias mpcm 
ZAP
index on scode to mpcm 

sele fpcm
go top
do while .not. eof()
   sele mpcm
   append blank
   repl mpcm.sgcode with 'ZZZZZZ',;
        mpcm.scode  with str(fpcm.mfr_key,6),;
        mpcm.sname  with fpcm.mfr_name,;
        mpcm.parnam with fpcm.mfr_name,;
        mpcm.tcode with 'No',;
        mpcm.tax with 1
sele fpcm
skip
enddo
close table all

?'** Transfer MR'
fd=DATATRANSFERPATH + 'rep_master.dbf'
td=DATDEV + '\order.'+DATEXT

sele a
use &fd alias fact  
sele b
use &td alias mact 
zap

sele fact
go top
do while .not. eof()
   sele mact
   append blank
   repl mact.rate with 'N'
   repl mact.scode with 'D32'
   repl mact.rate with 'N'
   repl mact.ordno with 'R'+str(fact.rep_code,5),;
        mact.parnam  with fact.rep_name,;
        mact.sthed with  'TIN No.',;
        mact.csthed with 'CST No.',;
        mact.mailnam with fact.rep_name,;
        mact.ref with 'Mr.',;
        mact.price with 'A',;
        mact.status with 'Y',;
        mact.adhed with 'Discount'
sele fact
skip
enddo
close table all


?'** Transfer ACCOUNT'
fd=DATATRANSFERPATH + 'acctmast.dbf'
td=DATDEV + '\order.'+DATEXT

sele a
use &fd alias fact  
sele b
use &td alias mact 

sele fact
go top
do while .not. eof()
   sele mact
   append blank
   repl mact.rate with 'N'
   if fact.sub_grp_co = 5
      repl mact.scode with 'D31'
	  repl mact.rate with old_3
   else
      if fact.sub_grp_co = 13
		 repl mact.scode with 'C6'
         repl mact.rate with old_3
      else
		 repl mact.scode with 'J12'
      endif
   endif   
   repl mact.ordno with ALLTRIM(str(fact.act_code,6)),;
        mact.parnam  with fact.act_name,;
        mact.paradd with fact.address,;
        mact.paradd1 with fact.place,;
        mact.sthed with  'TIN No.',;
        mact.csthed with 'CST No.',;
        mact.cstno with fact.cst_no,;
        mact.stno with fact.rc_no,;
        mact.dlno with alltrim(fact.dl_no),;
        mact.fax2 with fact.cust_code,;
        mact.mailnam with fact.act_name,;
        mact.ref with 'Mr.',;
        mact.price with 'A',;
        mact.city with fact.place,;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        mact.opning with fact.cl_bal
sele fact
skip
enddo
close table all


?'** Transfer Stock'
sele sele(1)
  use &datatransferpath\itemtran alias trn  
  index on item_tran_ to trn  && item_code
sele sele(1)
  use &datatransferpath\purc_tran alias pur  
  index on item_tran_ to pur  
sele sele(1)
  use &datdev\pro.&datext alia mitm 
  index on str(code,9) to mitm 
sele sele(1)
  use &datdev\probat.&datext alias msbal 
index on str(code,9)+batchno to msbal 
sele trn     
scan 
    sele pur
    seek trn.item_tran_
    scan while item_tran_=trn.item_tran_
		sele mitm
	    seek str(trn.item_code,9)
	    sele msbal
	    seek str(trn.item_code,9)+subs(pur.batch_no,1,12)
	    if !found()
	      appen blank
	      repl code with mitm.code
	      repl name with mitm.name
	      repl product with mitm.product
	      repl packing with mitm.packing
	      repl pack with mitm.pack 
	      repl billname with mitm.billname
	      repl mrp with pur.mrp 
	      repl ratea with pur.sales_rate
	      repl prate with pur.rate
	      repl batchno with pur.batch_no 
	      repl exp with pur.exp_date
	   endif
	   repl opening with opening+pur.tota_quan
	   repl balance with balance+pur.tota_quan
	   repl o_a with o_a+pur.tota_quan
	   repl b_a with b_a+pur.tota_quan 
	  endscan
endscan
sele msbal
repl all date with old_5-1 for balance=0
close table all 

?'** Transfer Debtor Outstanding'
sele sele(1)
  use &datatransferpath\sale_mast alias cOs
sele sele(1)
  use &datdev\pendings.&datext alias pend  
sele sele(1)
  use &datdev\slipno.&datext alias mslip 
  go bott
  mvoucher=voucher+5
  msvoucher=svoucher+5
sele cos
scan
  mvoucher=mvoucher+5
  msvoucher=msvoucher+4
 sele pend
 appen blank
 repl voucher with mvoucher
 repl svoucher with msvoucher 
 repl ord with alltrim(str(cos.act_code))
 repl vcn with str(cos.bill_no,1,6)
 repl ddate with cos.bill_date
 repl duedate with cos.due_date
 repl final with cos.total_amt
 repl balance with cos.total_amt
 repl invtype with 'O'
 repl acgroup with 'C6'
endscan
?'** Transfer Creditor Outstanding'
sele sele(1)
  use &datatransferpath\purc_mast alias pos  
sele pos
scan
  mvoucher=mvoucher+5
  msvoucher=msvoucher+4
 sele pend
 appen blank
 repl voucher with mvoucher
 repl svoucher with msvoucher 
 repl ord with alltrim(str(pos.act_code))
 repl vcn with pos.bill_no
 repl ddate with pos.bill_date
 repl duedate with pos.bill_date
 repl final with pos.total_amt
 repl balance with pos.total_amt
 repl invtype with 'O'
 repl acgroup with 'D31'
endscan
sele mslip 
repl voucher with mvoucher
repl svoucher with msvoucher
close table all 

**************************************************************************