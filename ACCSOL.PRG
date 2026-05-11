*!*	BOF :accounting Solutions.PRG .....Santosh Srivastava  23/07/2022
****FOR REMOVING OPENING OUTSTANDING DIFFERENCE 
****SELE PENDINGS
*!*	=MESSAGEBOX('After Transfer & Re-Saving run this command in Direct command'+chr(13)+;
*!*	'sele pendings'+chr(13)+'repl all iteemope with balance for vcn="Opening "',100)
****REPL ALL ITEMOPE WIWTH BALANCE FOR VCN='Opening '
****FOR REMOVING OPENING OUTSTANDING DIFFERENCE 
*!* datatransferpath="e:\datafrom\"+space(45)
*!* datatransferext="dbf"
*!* for bill difference ## in support -> repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!* for item difference ## in support -> repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for item batch difference ## in support -> repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for ledger difference ## in support -> repl type with "#",aliase with "DAT/F-LD",Lcode with mact.ordno,value with TOT
*!* ******************
*!* Your Commands
*!* ******************
*!* if LastKey()=27
*!*  Return
*!* endif
*!* =starttransfer()
*!* ******************
*!*	*!* your commands
clear
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
set memowidth to 20
sele sele(1)
create curs mycurs  (setup c(50),value c(4))
sele mycurs
appe blank
repl  setup with 'Item Wise Double Discount ',value with 'Y'
appe blank
repl  setup with 'Bill discount ',value with 'Y'
appen blank
repl  setup with 'Ask Discount in Amount',value with 'N'
brow font 'COURIER',18    nomodify
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&OUTSITDE PATHE PRG&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')
	lastdate= ctod('31/03/2026')
	datdev='d:\transfer\'
	datext= 'DBF'
endif
datatransferpath=subs('D:\2025\Dec\ac\AC_SOL_DBF\'+space(100),1,100)
datatransferext='DBF'
datatransfersql='No '
datatransfermdb='No '
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
old_7 = 'G'
softtype='WholeSale'
scalc='2'
pcalc='2'
old_12 = 'SEXPE '
old_13 = 'ADJUST'
old_14 = '#'
mstatecode='23'
sure='SURE'
datatype1='SQL'
mrgmdbfile=space(100)
mrgmdbpwd=space(30)
removenull='No '
	mrgsqlfile=subs('AccSol'+space(60),1,60)
	mrgsqluserid=subs('sa'+space(60),1,60)
	mrgsqlpwd=subs('Marg@1234'+space(60),1,60)
	@ 07,10 say 'Convert DBF From SQL  :' font 'Courier',14 get datatransfersql pict '@^m No ,Yes'  font 'Courier',11
	@ 08,10 say 'SQL Database Name     :' font 'Courier',14 get mrgsqlfile    font 'cOURIER',14
	@ 09,10 say 'Convert DBF From SQL  :' font 'Courier',14 get mrgsqluserid   font 'cOURIER',14
	@ 10,10 say 'Convert DBF From SQL  :' font 'Courier',14 get mrgsqlpwd    font 'cOURIER',14
	read
if datatransfersql='Y'
	=mdbsqlconvert(3)
endif
clear gets
mRow=iif(datatype1='S',11,8)
@mROW+0 ,10 say 'ACCSOL Data Path      :' font 'Courier',14  get datatransferpath  font 'courier',14
@mRow+1 ,10 say 'ACCSOL Extension      :' font 'Courier',14  get datatransferext  font 'courier',14
@mROw+2 ,10 say 'With Outstanding Y/N  :' font 'Courier',14  get old_3 pict '@^m YES,NO '  font 'Courier',14
@mRow+3 ,10 say 'No-Full Yes-Master    :' font 'Courier',14  get old_4 pict '@^m No,Yes'  font 'Courier',14
@mRow+4 ,10 say 'F.Y.BEGIN Date        :' font 'Courier',14  get old_5  font 'Courier',14
@mRow+5 ,10 say 'F.Y.End   Date        :' font 'Courier',14  get old_6   font 'Courier',14
@mRow+6 ,10 say 'G-GST  V-Vat          :' font 'Courier',14  get old_7  font 'Courier',14
@mRow+7 ,10 say 'State Code            :' font 'Courier',14  get mstatecode font 'Courier',14
@mRow+8 ,10 say 'Sales Calculation     :' font 'Courier',14  get scalc   font 'Courier',14
@mRow+9 ,10 say 'Purch.Calculation     :' font 'Courier',14  get pcalc   font 'Courier',14
@mRow+10,10 say 'Removenull            :' font 'Courier',14  get removenull pict '@^ No ,Yes'   font 'Courier',14
@mRow+11,10 say 'Type SURE             :' font 'courier',14  get sure pict '@x!' font 'courier',14
read
clear
close data
if type('FINALCP')#'U'
	=starttransfer()
endif
mYear='2022-2023'
=select_year()
mCompcd=repli('9',10)
=select_Company()

if removenull='Y'
	clear
	@05,10 say 'Removing Null Values..Please Wait......' font 'courier',14
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif


datatransferpath=alltrim(datatransferpath)
if !right(datatransferpath,1)='\'
	datatransferpath=alltrim(datatransferpath)+'\'
endif
datatransferext='.'+alltrim(datatransferext)
datdev= alltrim (datdev)
datdev= alltrim (datdev)
if !dire(datatransferpath)
	md &datatransferpath
endif


if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
rowno=5

@02,22 say 'Please Wait Importing Accounting Solutions(ACCSOL) Data To Marg.....' font 'Arial',14 colo 'W+/G'

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
use &datdev\SUBDIS.&datext
zap

use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F'
dele all for SNO=7  OR SNO=12 OR ALIASE='ORDER' &&&&and aliase='DAT/F'

pack
close data
set colo to
*do removenull

@rowno,10 say '**** Importing Area****' font 'Arial',12
rowno=rowno+1
sele sele(1)
  use &datatransferpath\areamst alias fa
sele sele(1)
  use &datdev\saletype.&datext alias stype 
sele fa
scan
 sele stype
 appen blank 
 repl sgcode with 'AREA' 
 repl scode with fa.area_cd
 repl parnam with fa.area_nm
 repl sname with fa.area_nm
endscan
close table all
    
@rowno,10 say '**** Importing Product Category****' font 'Arial',12
rowno=rowno+1
sele sele(1)
  use &datatransferpath\catmst alias fc
sele sele(1)
  use &datdev\saletype.&datext alias stype 
sele fc
scan
 sele stype
 appen blank 
 repl sgcode with 'CATEGO' 
 repl scode with fc.cat_cd
 repl parnam with fc.cat_nm
 repl sname with fc.cat_nm
endscan
close table all

@rowno,10 say '**** Importing Product ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemmst alias fitm 
sele sele(1)
use &datdev\pro.&datext alias mitm 
sele sele(1)
use &datdev\support.&datext alias support  
sele sele(1)
use &datdev\saletype.&datext alias mpcm 
index on sgcode+parnam+str(igst,6,2) to mpcm
sele fitm
set filt to comp_cd=mCompcd 
scan
  sele mitm
  appen blan
  repl code with recno() 
  repl name with fitm.item_cd
  repl unit with fitm.unit_nm 
  repl product with fitm.item_nm
  repl packing with '' 
  repl billname with fitm.item_nm
  repl gcode5 with fitm.cat_cd
  repl pack with fitm.case_qty 
  repl maximum with fitm.stock_max
  repl minimum with fitm.stock_min
  repl saltax with fitm.gst_per/2
  repl cgst   with fitm.gst_per/2
  repl igst   with fitm.gst_per
mhsn=fitm.hsn_cd
&&&HSN and Tax Mast
sele mpcm
seek 'COMMCD' + substr(mhsn+space(40),1,40) + str(mitm.igst,5,2)
if !found()
	append blank
	repl mpcm.sgcode with 'COMMCD',;
		mpcm.scode  with 'HH'+alltrim(str(recno())),;
		mpcm.sname  with mhsn,;
		mpcm.parnam with mhsn,;
		mpcm.tax with mitm.saltax,;
		mpcm.cgst with mitm.cgst,;
		mpcm.igst with mitm.igst,;
		mpcm.tcode with 'No'
endif
sele mitm
repl gcode6 with mpcm.scode
endscan
close table all 

@rowno,10 say '**** Importing MRP Wise Stock Opening****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemopbl alias fsbal
set filt to comp_cd=mCompcd and fin_year=mYear 
index on item_cd to fsbal
sele sele(1)
use &datatransferpath\ratemst alias frate
set filt to comp_cd=mcompcd  
index on item_cd+rate_cd to frate 

sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal

sele sele(1)
use &datdev\support.&datext alias support 
sele fsbal
scan
	=seek(item_cd+rate_cd,'frate')
	sele mitm
	seek substr(fsbal.item_cd+space(10),1,10)
	sele msbal
	seek substr(fsbal.item_cd+space(10),1,10)+str(frate.mrp,9,2)  
	if !found()
		appen blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with mitm.pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with fsbal.op_qty,;
			msbal.balance with fsbal.op_qty,;
			msbal.o_a with fsbal.op_qty,;
			msbal.b_a with fsbal.op_qty,;
			msbal.batchno with str(frate.mrp,9,2),;
	   		msbal.exp with ctod(''),;
			msbal.mrp with frate.mrp,;
			msbal.prate with frate.pur_rate,;
			msbal.ratea with frate.sal_rate,;
			msbal.lprate with frate.pur_rate,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
	else
		repl msbal.opening with msbal.opening + fsbal.op_qty,;
			msbal.balance with msbal.balance + fsbal.op_qty,;
			msbal.o_a with msbal.o_a + fsbal.op_qty,;
			msbal.b_a with msbal.b_a + fsbal.op_qty
	endif
endscan
close table all 

@rowno,10 say '**** Importing MRP Wise Stock Stock In****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemDtl alias fsbal
set filt to comp_cd=mCompcd and fin_year=mYear 
index on item_cd to fsbal
sele sele(1)
use &datatransferpath\ratemst alias frate
set filt to comp_cd=mcompcd  
index on item_cd+rate_cd to frate 

sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal

sele sele(1)
use &datdev\support.&datext alias support 
sele fsbal
scan for vou_type='PR'
	=seek(item_cd+rate_cd,'frate')
	sele mitm
	seek substr(fsbal.item_cd+space(10),1,10)
	sele msbal
	seek substr(fsbal.item_cd+space(10),1,10)+str(frate.mrp,9,2)  
	if !found()
		appen blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with mitm.pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with fsbal.item_qty+fsbal.free_qty,;
			msbal.balance with fsbal.item_qty+fsbal.free_qty,;
			msbal.o_a with fsbal.item_qty+fsbal.free_qty,;
			msbal.b_a with fsbal.item_qty+fsbal.free_qty,;
			msbal.batchno with str(frate.mrp,9,2),;
	   		msbal.exp with ctod(''),;
			msbal.mrp with frate.mrp,;
			msbal.prate with frate.pur_rate,;
			msbal.ratea with frate.sal_rate,;
			msbal.lprate with frate.pur_rate,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
	else
		repl msbal.opening with msbal.opening + fsbal.item_qty+fsbal.free_qty,;
			msbal.balance with msbal.balance + fsbal.item_qty+fsbal.free_qty,;
			msbal.o_a with msbal.o_a + fsbal.item_qty+fsbal.free_qty,;
			msbal.b_a with msbal.b_a +fsbal.item_qty+fsbal.free_qty
	endif
endscan
close table all 

@rowno,10 say '**** Importing MRP Wise Stock Stock Out****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemDtl alias fsbal
set filt to comp_cd=mCompcd and fin_year=mYear 
index on item_cd to fsbal
sele sele(1)
use &datatransferpath\ratemst alias frate
set filt to comp_cd=mcompcd  
index on item_cd+rate_cd to frate 

sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal

sele sele(1)
use &datdev\support.&datext alias support 
sele fsbal
scan for vou_type='SR'
	=seek(item_cd+rate_cd,'frate')
	sele mitm
	seek substr(fsbal.item_cd+space(10),1,10)
	sele msbal
	seek substr(fsbal.item_cd+space(10),1,10)+str(frate.mrp,9,2)  
	if !found()
		appen blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with mitm.pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with -(fsbal.item_qty+fsbal.free_qty),;
			msbal.balance with-(fsbal.item_qty+fsbal.free_qty),;
			msbal.o_a with -(fsbal.item_qty+fsbal.free_qty),;
			msbal.b_a with -(fsbal.item_qty+fsbal.free_qty),;
			msbal.batchno with str(frate.mrp,9,2),;
	   		msbal.exp with ctod(''),;
			msbal.mrp with frate.mrp,;
			msbal.prate with frate.pur_rate,;
			msbal.ratea with frate.sal_rate,;
			msbal.lprate with frate.pur_rate,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
	else
		repl msbal.opening with msbal.opening -(fsbal.item_qty+fsbal.free_qty),;
			msbal.balance with msbal.balance -(fsbal.item_qty+fsbal.free_qty),;
			msbal.o_a with msbal.o_a -(fsbal.item_qty+fsbal.free_qty),;
			msbal.b_a with msbal.b_a -(fsbal.item_qty+fsbal.free_qty)
	endif
endscan
close table all 

@rowno,10 say '**** Importing Ledgers  ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
  use &datatransferpath\acmst alias fact 
  set filt to comp_cd=mcompcd  
sele sele(1)
  use &datatransferpath\acgrpmst alias fgrp 
  index on acgrp_cd to fgrp
sele sele(1)
use &datatransferpath\acopbl alias fbal 
set filt to comp_cd=mcompcd and fin_year=mYear 
index on ac_cd to fbal  
sele sele(1)
use &datatransferpath\voutrans alias fvou
set filt to comp_cd=mcompcd and fin_year=mYear 
index on ac_cd to fvou  

sele sele(1)
use &datatransferpath\voudtlsp alias fvou1
set filt to comp_cd=mcompcd and fin_year=mYear 
index on ac_cd to fvou1  

sele sele(1)
  use &datdev\order.&datext alias mact 
sele sele(1)  
  use &datdev\support.&datext alias support  
sele fact
scan
  =seek(acgrp_cd,'fgrp')
  msname=fgrp.acgrp_nm
  sele mact
  appen blank 
  repl ordno with fact.ac_cd 
  repl mailnam with fact.ac_nm 
  REPL PARNAM WITH FACT.AC_NM
  repl paradd with fact.ac_add
  repl city with fact.ac_city
  repl confir with fact.con_per
  repl phone1 with fact.ph1 
  repl phone2 with fact.ph2 
  repl phone3 with fact.mob1 
  repl phone4 with fact.mob2
  repl area with fact.area_cd
  repl limit with fact.dr_cr_lim
  repl disc1 with fact.disc_per
  repl itno with fact.pan_no
  repl gsthed with 'GST No.'
  repl gstno with fact.pan_no&&&tin_no
  REPL rate with old_3
  sele fbal
  seek fact.ac_cd 
  sum dr_amt-cr_amt to tot while ac_cd=fact.ac_cd 
  sele fvou
  seek fact.ac_cd 
  sum dr_amt-cr_amt to tot1 while ac_cd=fact.ac_cd 
  sele fvou1
  seek fact.ac_cd 
  sum dr_amt-cr_amt to tot2 while ac_cd=fact.ac_cd 
  
  sele mact
  repl opning with tot+tot2+tot1 
  repl balance with tot+tot2+tot1 
	wacctgroup=''
	wgroupcode=''
	parentgrup=''
	wcurrentaccount=alltrim(upper(msname))
	do case
	case 'BRANCH'$wcurrentaccount or 'DIVISION'$wcurrentaccount
		wgroupcode='A '
	case 'CAPITAL'$wcurrentaccount and ('A/C'$wcurrentaccount or 'ACCOUNT'$wcurrentaccount)
		wgroupcode='B '
	case 'RESERVE'$wcurrentaccount and 'SURPLUS'$wcurrentaccount
		wgroupcode='B '
	case 'CURRENT ASSET'$wcurrentaccount
		wgroupcode='C '
	case 'FIXED'$wcurrentaccount and 'ASSET'$wcurrentaccount
		wgroupcode='E '
	case 'INVESTMENT'$wcurrentaccount
		wgroupcode='F   '
	case 'CURRENT LIABILIT'$wcurrentaccount
		wgroupcode='D '
	case ('DUTY'$wcurrentaccount or 'DUTIES'$wcurrentaccount) and 'TAXES'$wcurrentaccount
		wgroupcode='D '
	case 'SALES TAX'$wcurrentaccount and 'CENTRAL'$wcurrentaccount
		wgroupcode='D11'
	case 'SALES TAX'$wcurrentaccount and 'LOCAL'$wcurrentaccount
		wgroupcode='D12 '
	case 'PROVISIONS'$wcurrentaccount
		wgroupcode='D  '
	case 'LOAN' $wcurrentaccount and 'LIABILITY' $wcurrentaccount
		wgroupcode='G   '
	case 'MISC. EXPENSES' $wcurrentaccount and 'ASSET'$wcurrentaccount
		wgroupcode='H   '
	case 'PROFIT & LOSS A/C'$wcurrentaccount
		wgroupcode='I   '
	case 'REVENUE'$wcurrentaccount
		wgroupcode='J   '
	case 'SUNDRY CREDITOR'$wcurrentaccount OR 'CREDITOR'$wcurrentaccount
		wgroupcode='D31 '
	case 'SUPPLIER'$wcurrentaccount
		wgroupcode='D31 '
	case 'SUNDRY DEBTOR'$wcurrentaccount OR 'DEBTOR'$wcurrentaccount&&&or fdet.mastertype=7
		wgroupcode='C6 '
	case 'DEPOSITS'$wcurrentaccount
		wgroupcode='C3 '
	case 'INVESTMENT'$wcurrentaccount
		wgroupcode='F '
	case "BANK"$wcurrentaccount &&and 'ACCOU'$wcurrentaccount and !('ODD'$wcurrentaccount) and !('OCC'$wcurrentaccount)
		wgroupcode='C1   '
	case "CASH"$wcurrentaccount and ('IN'$wcurrentaccount OR 'A/C'$wcurrentaccount or 'AC'$wcurrentaccount) and 'HAND'$wcurrentaccount
		wgroupcode='C2   '
		wgroupcode='C2   '
		parentgrup='C '
	case "STOCK" $ wcurrentaccount and ('CURRENT'$wcurrentaccount or 'IN-HAND'$wcurrentaccount or 'IN HAND'$wcurrentaccount)
		wacctgroup='C5 '
		wgroupcode='C   '
		parentgrup='C '
	case "BANK OD A/C" $wcurrentaccount or "BANK OCC A/C" $wcurrentaccount
		wgroupcode="G1 "
	case "LOAN" $wcurrentaccount and "ADVANCE" $wcurrentaccount
		wgroupcode="C4  "
	case "SECURED LOAN" $wcurrentaccount
		wgroupcode="G2  "
	case "UNSECURED LOAN" $wcurrentaccount
		wgroupcode="G3  "
	case "DIRECT" $wcurrentaccount and !("INDIRECT"$wcurrentaccount)
		if "INCOME"$wcurrentaccount
			wgroupcode="J3 "
		endif
		if "EXPENSE" $wcurrentaccount
			wacctgroup='J11 '
			wgroupcode="J1  "
			parentgrup='J1 '
		endif
	case "INDIRECT" $wcurrentaccount
		if "INCOME" $wcurrentaccount
			wgroupcode="J4 "
		endif
		if "EXPENSE" $wcurrentaccount
			wgroupcode="J12  "
		endif
	case 'SALE'$wcurrentaccount
		if "CENTRAL"$wcurrentaccount or "CST"$wcurrentaccount
			wgroupcode='J61  '
		else
			wgroupcode='J62  '
		endif
	case 'PURCHASE'$wcurrentaccount
		if "CENTRAL"$wcurrentaccount or "CST"$wcurrentaccount
			wgroupcode="J51  "
		else
			wgroupcode="J52  "
		endif
	otherwise
	endcase
	repl mact.scode with wgroupcode
  
  sele support
  append blank
  repl aliase with 'ORDER   '
  repl type with 'F'
  repl lcode with mact.ordno
  repl sno with 7
  repl pcode with 15
  repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
&& UPDATED SUPPORT FOR LEDGER  DIFFERENCE
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with  mact.balance
  
endscan
SELE MACT
appen blank 
repl scode with 'J12' 
repl ordno with 'FRE999' 
repl parnam with 'FREIGHT/OTHER CHARGES' 
repl mailnam with 'FREIGHT/OTHER CHARGES'
appen blank 
repl scode with 'J12' 
repl ordno with 'DSP999' 
repl parnam with 'OTHER ADD/LESS ' 
repl mailnam with 'OTHER ADD/LESS'

close table all 
*RETU
if old_4='N'
*   do import_transactions 
endif

proc import_transactions         
@rowno,10 say '**** Importing Inventory Transactions  ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
  use &datdev\slipno.&datext alias mslip 
  mvoucher=voucher+5 
  msvoucher=svoucher+4 
sele sele(1)
 use &datdev\support.&datext alias support 
 INDEX on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\mdis.&datext alias mdis  
sele sele(1)
use &datdev\dis.&datext alias dis  
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm 
sele sele(1)
 use &datatransferpath\voutranssp alias sal 
 set filt to comp_cd=mcompcd and  fin_year=mYear 
sele sele(1)
 use &datatransferpath\itemdtl alias sld  
 set filt to comp_cd=mcompcd and  fin_year=mYear 
 index on vou_no to sld  

sele sal 
scan
 mvoucher=mvoucher+5 
 sele mdis
 appen blank 
 repl voucher with mvoucher
 repl type with iif(sal.vou_type='PR','P',iif(sal.vou_type='SR','S','R'))
 repl vcn with sal.vou_no 
 repl date with sal.vou_dt
 repl pm with sal.bill_no
 repl lrda with sal.bill_dt
 repl codep with sal.party_cd 
 repl final with sal.tot_amt 
 repl cash with 0 
	if Final=0 .and. Cash#0
		repl Misc3 with substr(Misc3,1,34)+'C'+substr(Misc3,36,100)
	else
		repl Misc3 with substr(Misc3,1,34)+'R'+substr(Misc3,36,100)
	endif
	isigst=0
    if sal.pos#mstatecode 
         repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
         isigst=1
    endif
    repl freight with sal.fri_amt+SAL.ADJ_AMT
    repl freun with 'FRE999'
    repl other with -sal.disp_amt+SAL.OTH1_AMT+SAL.OTH2_AMT
    repl othun with 'DSP999'
    
	repl DueDays with 0
	repl Account with 'N'
	repl Sale with 'Z'
	repl GodWon with 'A'
	repl lType with iif(mdis.type$'SRWL',scalc,pCALC)
	repl DiscAfter with 'N'

    sele support 
    appen blank
    repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
sele sld 
seek sal.vou_no
scan while vou_no=sal.vou_no 
 =seek(subs(item_cd+space(10),1,10),'mitm')
 sele dis
 appen blank 
 repl voucher with mdis.voucher
 repl vcn with mdis.vcn 
 repl date with mdis.date 
 repl codep with mdis.codep 
 repl flg with iif(mdis.type='S','G',mdis.type)
 repl tax with 'T'
 repl code with mitm.code 
 repl qty with sld.item_qty 
 repl free with sld.free_qty 
 repl rate with sld.t_rate 
 repl mrp with sld.item_mrp 
 repl disc1 with iif(sld.disc_amt#0,sld.disc_per,0)
 repl disc2 with iif(sld.cd_amt#0,sld.cd_per,0)
 if isigst=1 
   repl ssta with sld.tax_per
 else
  repl ssta with sld.tax_per/2 
  repl cgst with sld.tax_per/2
 endif   
 repl godwon with mdis.godwon
endscan 
endscan
sele mslip 
repl voucher with mvoucher 
repl svoucher with msvoucher
close table all 
     
@Rowno,10 Say '**** Importing Account From Sales  ****' font 'Arial',12
Rowno=Rowno+1
        
af  =datdev + '\gledger.'+datext
pend =datdev + '\pend.'+datext
mdis=datdev+ '\mdis.'+datext 
sele sele(1) 
  use &datdev\order.&datext alias ord  
  index on ordno to ord
pending=datdev + '\pendings.'+datext
sele g
use &pendING alias pendING
sele f
use &pend alias pend
sele b
use &af alias gledger
sele sele(1)
  use &datdev\slipno.&datext alias mslip 
  mvoucher=voucher+5
  msvoucher=svoucher+4

slast5=msvoucher+10

sele d
use &mdis alias mdis
go top
do while .not. eof()
  if type='R'
     skip 
     loop 
  endif   
    =seek(codep,'ord')
	if vcn=space(12)
		skip
		loop
	endif
	LAST1=mdis.codep
	if mdis.final#0
		sele b
		APPE BLANK
		REPL VOUCHER WITH mdis.voucher
		IF d.type='P'
			   REPL CD WITH 'C'
			   REPL CREDIT WITH mdis.final
			   REPL BOOK WITH 'A'
		ELSE
		 IF D.TYPE='S' 
			  REPL CD WITH 'D'
			  REPL DEBIT WITH mdis.final
			  REPL BOOK WITH 'S'
		 ENDIF
		ENDIF 	  
		
		REPL DATE WITH mdis.date
		REPL CODE WITH mdis.codep
		LAST1=mdis.codep
		REPL REMARK1 WITH mdis.vcn
		repl type with 'Y'
		if mdis.salun=space(6)
			repl code1 with 'SP#20 '
		else
			repl code1 with mdis.salun
		endif
		**** for outstanding
		if old_3='Y'
		   sele f
		   appe blank
		   repl ord with mdis.codep
		   repl ddate with mdis.date
		   repl duedays with mdis.duedays
		   repl vcn with mdis.vcn
		   if d.type='P'
			  repl final with -mdis.final
		   else
			  repl final with mdis.final
		   endif
		   repl type with 'N'
		   repl voucher with mdis.voucher
		   repl adjvoucher with mdis.voucher
		   repl svoucher with slast5 
		   
		   slast5=slast5+5
		   sele g
		   appe blank
		   repl ord with f.ord
		   repl ddate with f.ddate
		   repl vcn with f.vcn
		   repl invtype with 'I'
		   repl voucher with f.voucher
		   repl duedays with f.duedays
		   repl duedate with ddate+duedays
		   repl final with f.final
   		   repl balance with f.final
		   repl svoucher with f.svoucher
		   repl name with mdis.remark4
		   repl acgroup with ord.scode
		endif
	endif
	if mdis.cash#0
		sele b
		APPE BLANK
		REPL VOUCHER WITH mdis.voucher
		if d.type='P'
			REPL CD WITH 'C'
			REPL CREDIT WITH mdis.CASH
		    REPL BOOK WITH 'A'			
		ELSE
		   IF d.type='S'
			  REPL CD WITH 'D'
			  REPL DEBIT WITH mdis.CASH
			  REPL BOOK WITH 'S'			  
		   endif	   
		endif
		REPL DATE WITH mdis.date
		REPL CODE WITH 'STACO3'
		LAST1='STACO3'
		REPL REMARK1 WITH mdis.vcn
		repl type with 'Y'
		if mdis.salun=space(6)
			repl code1 with 'SP#20 '
		else
			repl code1 with mdis.salun
		endif
	endif
	if (mdis.final+mdis.cash)#0
		sele b
		APPE BLANK
		REPL VOUCHER WITH mdis.voucher
		if d.type='S'
			REPL CD WITH 'C'
			REPL CREDIT WITH (mdis.final+mdis.cash)
			REPL BOOK WITH 'S'			
		ELSE
		   IF d.type='P'
			  REPL CD WITH 'D'
			  REPL DEBIT WITH (mdis.final+mdis.cash)
		      REPL BOOK WITH 'A' 
		   endif 	  
		endif
		REPL DATE WITH mdis.date
		if mdis.salun=space(6)
			repl code with 'SP#20 '
		else
			repl code with mdis.salun
		endif
		REPL REMARK1 WITH mdis.vcn
		repl type with 'Y'
		repl code1 with LAST1
	endif
	sele d
	skip
enddo
sele mslip 
repl voucher with mvoucher,svoucher with msvoucher 
SELE B
CLOSE Table All



*******
@Rowno,10 Say '**** Importing Account From Sales Return ****' font 'Arial',12
Rowno=Rowno+1
        
af=datdev+'\gledger.'+datext
pend =datdev + '\pend.'+datext
mdis=datdev+ '\mdis.'+datext 
sele sele(1) 
  use &datdev\order.&datext alias ord  
  index on ordno to ord
  pending=datdev + '\pendings.'+datext
sele g
use &pendING alias pending
index on ord+vcn to pending
sele f
use &pend alias pend
sele b
use &af alias gledger

sele sele(1)
  use &datdev\slipno.&datext alias mslip 
  mvoucher=voucher+5
  msvoucher=svoucher+4

sLast5=msvoucher+10

sele d
use &mdis alias mdis
go top
do while .not. eof()
  if type#'R'
     skip 
     loop 
  endif   
    =seek(codep,'ord')
	if vcn=space(12)
		skip
		loop
	endif
	LAST1=mdis.codep
	if mdis.final#0
		sele b
		APPE BLANK
		REPL VOUCHER WITH mdis.voucher
		REPL CD WITH 'C'
		REPL CREDIT WITH mdis.final
		REPL BOOK WITH 'E'
		REPL DATE WITH mdis.date
		REPL CODE WITH mdis.codep
		LAST1=mdis.codep
		REPL REMARK1 WITH mdis.vcn
		repl type with 'Y'
		if mdis.salun=space(6)
			repl code1 with 'SP#20 '
		else
			repl code1 with mdis.salun
		endif
  endif		
	if mdis.cash#0
		sele b
		APPE BLANK
		REPL VOUCHER WITH mdis.voucher
		REPL CD WITH 'C'
		REPL CREDIT WITH mdis.CASH
		REPL BOOK WITH 'E'			
		REPL DATE WITH mdis.date
		REPL CODE WITH 'STACO3'
		LAST1='STACO3'
		REPL REMARK1 WITH mdis.vcn
		repl type with 'Y'
		if mdis.salun=space(6)
			repl code1 with 'SP#20 '
		else
			repl code1 with mdis.salun
		endif
	endif
	if (mdis.final+mdis.cash)#0
		sele b
		APPE BLANK
		REPL VOUCHER WITH mdis.voucher
		REPL CD WITH 'D'
		REPL DEBIT WITH (mdis.final+mdis.cash)
		REPL BOOK WITH 'E' 
		REPL DATE WITH mdis.date
		if mdis.salun=space(6)
			repl code with 'SP#20 '
		else
			repl code with mdis.salun
		endif
		REPL REMARK1 WITH mdis.vcn
		repl type with 'Y'
		repl code1 with LAST1
	endif
	sele d
	skip
enddo
sele mslip 
repl voucher with mvoucher,svoucher with msvoucher 

CLOSE Table All
 
        


@Rowno,10 Say '**** Importing Receipts/Payments  ****' font 'Arial',12
Rowno=Rowno+1

sele sele(1)
  use &datdev\slipno.&datext alias mslip 
  go top
  mvoucher=voucher+5
  msvoucher=svoucher+4
sele sele(1)
  use &datdev\pend.&datext alias pend  
sele sele(1)
  use &datdev\pendings.&datext alias pendings  
  index on ord+vcn to pendings 
  
sele sele(1)
  use &datdev\gledger.&datext alias gle  
sele sele(1)
  use &datatransferpath\voutrans alias led  
  set filt to comp_cd=mcompcd and fin_year=mYear
  INDEX ON VOU_NO TO LED 
sele led
go top 
mvou_no='999999'
do while !eof() 
  if vou_no#mvou_no 
    mvou_no=vou_no 
    mvoucher=mvoucher+5
 endif
 do while vou_no=mvou_no and !eof()
    sele gle
    appen blank 
    repl voucher with mvoucher
    repl date with led.vou_dt 
    repl vcsno with led.vou_no 
    repl code with led.ac_cd
    repl cd with iif(led.dr_amt#0,'D','C')
    REPL debit with led.dr_amt
    repl credit with led.cr_amt
    repl remark1 with led.remark1 
    if led.vou_type='BP' or led.vou_type='CP' 
      repl book with 'P' 
    else
      if led.vou_type='BR' or led.vou_type='CR'
          repl book with 'R' 
      else
        if led.vou_type='JV'
           repl  book with 'J' 
        else
          repl book with 'C'
        endif
     endif
   endif             
   sele led
   skip
enddo  
enddo
sele mslip 
repl voucher with mvoucher

  
close data



func mdbsqlconvert(mdbsqlpara1)
do case
case mdbsqlpara1=1
	if datatransfermdb='Y'
		mrgmdbfile=alltrim(getfile('mdb'))
		datatransferpath=alltrim(datatransferpath)
		=mdbsqlconvert(2)
	endif
case mdbsqlpara1=2 and datatransfermdb='Y'
	mrgmdbfile=alltrim(mrgmdbfile)
	mrgmdbpwd='' &&alltrim(mrgmdbpwd)
	datatransferpath=subs(alltrim(datatransferpath)+space(80),1,80)
	datatransferpath=alltrim(datatransferpath)
	mrgexit=0
	if empty(mrgmdbfile)
		=messagebox("Please Enter Access File Name !!",100,'Check MDB File Path')
		mrgexit=1
	endif
	if !file(mrgmdbfile)
		=messagebox("Access File not found. Please Check !!",100,'Check MDB File Path')
		mrgexit=1
	endif
	if empty(datatransferpath)
		=messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	endif
	if mrgexit=1
		=messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		return
	endif
	lnconnhandle=0
	merrno=0
	try
		if empty(mrgmdbpwd)
			lnconnhandle=sqlstringconnect('DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		else
			lnconnhandle=sqlstringconnect('PWD='+trim(mrgmdbpwd)+';DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		endif
	catch to oexp
		merrno=1
	endtry
	if merrno=1
		=messagebox('Invalid MS-Access data file or invalid password.',48,'Will Quit Now')
		retu
	endif
	if !directo(alltrim(datatransferpath))
		md &datatransferpath
	endif
	datatransferpath=addbs(datatransferpath)
	if lnconnhandle>0
		clear
		@07,10 say 'Converting Access File to DBF. Please Wait......' font 'courier',16
		dvfp_tflds=0
		sele sele(1)
		lnresult=sqltables(lnconnhandle,'TABLE')
		tblfnd=0
		if lnresult > 0
			sele sqlresult
			scan
				try
					msqltabl=uppe(allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					sele sele(1)
					lngetdata=sqlexec(lnconnhandle,lcsqlcommand,'NEWDATA')
					if lngetdata>0
						lcdbffilenm=allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=chrtran(lcdbffilenm," "+chr(9),"")
						sele newdata
						copy to &lcdbffilenm
						wait wind lcdbffilenm nowait
						use
					endif
				catch to oerr
					merrno=1
					=messagebox(oerr.message,64)
*!*						susp
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "Access File Successfully Converted to DBF."
	else
		=messagebox('Unable to read from Connection',48,'Marg ')
		retu
	endif
	rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	if merrno=1
		=messagebox('Error encountered while importing data.',48)
		retu
	endif
	clear
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
case mdbsqlpara1=3
	clear
	mrgsqlfile=alltrim(mrgsqlfile)
	mrgsqluserid=alltrim(mrgsqluserid)
	mrgsqlpwd=alltrim(mrgsqlpwd)
	datatransferpath=alltrim(datatransferpath)
	mrgexit=0
	if empty(mrgsqlfile)
		=messagebox("Please Enter SQL Database Name !!",100,'Check File Name')
		mrgexit=1
	endif
	if empty(datatransferpath)
		=messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	endif
	if mrgexit=1
		=messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		return
	endif
	lnconnhandle=0
	merrno=0
	try
		lnconnhandle=sqlstringconnect("DRIVER=Sql Server;SERVER=SANTOSH-IT-LP\SQLEXPRESS;UID="+mrgsqluserid+";PWD="+mrgsqlpwd+";APP=Microsoft Visual FoxPro;WSID=MARG01;DATABASE="+mrgsqlfile)
	catch to oexp
		merrno=1
	endtry
	if merrno=1
		=messagebox('Invalid data file or invalid password.',48,'Will Quit Now')
		retu
	endif
	if !directo(datatransferpath)
		md &datatransferpath
	endif
	datatransferpath=addbs(datatransferpath)
	if lnconnhandle>0
		clear
		@07,10 say 'Converting SQL Database to DBF. Please Wait......' font 'courier',16
		dvfp_tflds=0
		sele sele(1)
		lnresult=sqltables(lnconnhandle,'TABLE')
		tblfnd=0
		if lnresult > 0
			sele sqlresult
			scan
			 if 'BC_LIST'$upper(alltriM(table_name))
			   loop 
			 endif  
				try
					msqltabl=uppe(allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					sele sele(1)
					lngetdata=sqlexec(lnconnhandle,lcsqlcommand,'NEWDATA')
					if lngetdata>0
						lcdbffilenm=allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=chrtran(lcdbffilenm," "+chr(9),"")
						sele newdata
						copy to &lcdbffilenm
						use
					endif
				catch to oerr
					merrno=1
					=messagebox(oerr.message,64)
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "SQL DataBase  Successfully Converted to DBF."

	else
		=messagebox('Unable to read from Connection',48,'Marg ')
		retu
	endif
	rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	if merrno=1
		=messagebox('Error encountered while importing data.',48)
		retu
	endif
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
*datatransferpath=subs(alltrim(datatransferpath)+space(80),1,80)
endcase


proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

proc Select_year
close DATA 
IF USED('myear')
   sele sele(1)
    sele myear
    use
endif
sele sele(1)    
mYear=alltrim(datatraNsferpath)+'YearMst'
use &mYear alias mYear
defi wind PartyBills from 4,20 to 20,150 shadow float title "::Sele Year ::" font 'Courier',18 
browse nomodi wind PartyBills field fin_year:h="Financial Year":15,Fr_Dt:h="From" :20,To_dt :h="To" :20  
mYear=Fin_year
CLOSE TABLE ALL 
CLOSE DATA

return   
  
proc select_company  
sele sele(1)    
mCompcd=alltrim(datatraNsferpath)+'CompMst'
use &mCompcd alias mCompCd
defi wind PartyBills from 4,20 to 20,150 shadow float title "::Sele Year ::" font 'Courier',18 
browse nomodi wind PartyBills field Comp_cd:h="Company Code":15,Comp_nm:h="Company Name" :20
mCompcd=subs(comp_cd,1,10)
CLOSE TABLE ALL 
CLOSE DATA
return   
*!*	EOF :accounting Solutions.PRG .....Santosh Srivastava
