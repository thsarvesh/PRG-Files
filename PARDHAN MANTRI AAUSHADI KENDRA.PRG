*!*	BOF : PMJAK.PRG .....Dated    by ST
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
set cpdialog off
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
sele sele(1)
close tables all

*!*	create curs mycurs  (setup c(50),value c(4))
*!*	sele mycurs
*!*	appe blank
*!*	repl  setup with 'Item Wise Double Discount ',value with 'Y'
*!*	appen blank
*!*	repl  setup with 'Volume discount 1st ',value with 'L'
*!*	brow font 'COURIER',18    nomodify

if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='D:\transfer'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif

sure= space(4)
datatransferpath=substr('D:\2025\Oct\Pardhanmantri\Dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='09'
removenull = 'NO'

@13,10 say 'PKMBK Data Path         :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'PKMBK Extension         :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_9    font 'courier',18
@18,10 say 'GST/VAT                 :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code          :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Removenull              :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@21,10 say 'Type SURE               :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
read
datatransferpath  = alltrim(datatransferpath)
datdev  = alltrim(datdev)
datext = alltrim(datext)
if lastkey()=27 &&.or. sure#'SURE'
	return
endif
if type('FINALCP')#'U'
	=starttransfer()
endif
clear
rowno=5
@ 02,25 say 'Please Wait..Importing PKMBK Data To Marg.....' font 'courier',14 colo 'W+/b'
rowno=rowno+1
set colo to
if removenull='Y'
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next

endif
close data

set colo to
sele sele(1)
use &datdev\pro.&datext
zap
use &datdev\order.&datext
zap
use &datdev\saletype.&datext
dele all for inlist(sgcode,'ZZZZZ','SALT  ','CATEGO')
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
dele all for type='#' or aliase='ORDER'
pack
close data
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\MedicineMaster alias fitm
sele sele(1)
use &datatransferpath\medicinewisetaxmaster alias ftx
index on mtm_mmid to ftx
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\support.&datext alias  supp
delete all for aliase='PRO    '
index on type+aliase+str(pcode,9)+str(sno,3) to supp
sele sele(1)
use &datdev\pro.&datext alias  mitm
sele fitm
scan
	prdnm=upper(fitm.mm_name)
	=seek(fitm.mm_id,'ftx')
	sele mitm
	appen blank
	repl code with fitm.mm_id
	repl name with fitm.mm_code
	repl product with upper(fitm.mm_name)
	repl billname with upper(fitm.mm_name)
	repl pack WITH fitm.mm_salesratio
	repl rackno with ''
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.gcode with padr(fitm.mm_mgmid,6)
	repl mitm.gcode5 with padr(fitm.mm_mcmid,6)
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with ftx.mtm_taxvalue/2
	repl cgst   with ftx.mtm_taxvalue/2
	repl igst   with ftx.mtm_taxvalue
	replace mrp with fitm.mm_mrp
	replace prate with fitm.mm_purrate
	replace ratea with fitm.mm_salerate
	replace lprate with fitm.mm_purrate
	sele supp
	seek 'F'+'PRO     '+str(mitm.code,9)+str(1,3)
	if !found()
		appen blank
		repl type with 'F'
		repl aliase with 'PRO'
		repl pcode with mitm.code
		repl sno with 1
		repl remark with prdnm
	endif
	if len(alltri(prdnm))>80
		sele supp
		seek 'F'+'PRO     '+str(mitm.code,9)+str(2,3)
		if !found()
			appen blank
			repl type with 'F'
			repl aliase with 'PRO'
			repl pcode with mitm.code
			repl sno with 1
			repl remark with substr(prdnm,81,80)
		endif
	endif
	if len(alltri(prdnm))>160
		sele supp
		seek 'F'+'PRO     '+str(mitm.code,9)+str(3,3)
		if !found()
			appen blank
			repl type with 'F'
			repl aliase with 'PRO'
			repl pcode with mitm.code
			repl sno with 1
			repl remark with substr(prdnm,161,80)
		endif
	endif

&&& HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(fitm.mm_hsncode+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with fitm.mm_hsncode,;
			mpcm.parnam with fitm.mm_hsncode,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
&&& group
	sele mpcm
	seek 'SALT  ' + substr(upper(fitm.mm_saltname)+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'S'+alltrim(str(recno())),;
			mpcm.sname  with upper(fitm.mm_saltname),;
			mpcm.tname with substr(upper(fitm.mm_saltname),41,40),;
			mpcm.tcode with 'No'
			repl parnam with sname
	endif
	repl mitm.gcode3 with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Company ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\medicinegroupmaster alias fpcm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan
	sele mpcm
	appen blank
	repl sgcode with 'ZZZZZZ'
	repl scode with padr(fpcm.mgm_id,6)
	repl sname with upper(fpcm.mgm_name)
	repl parnam with upper(fpcm.mgm_name)
endsc
close table all
@rowno,10 say '**** Importing Category ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\medicinecategorymaster alias fpcm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan
	sele mpcm
	appen blank
	repl sgcode with 'CATEGO'
	repl scode with padr(fpcm.mcm_id,6)
	repl sname with fpcm.mcm_name
	repl parnam with fpcm.mcm_name
endsc
close table all

@rowno,10 say '**** Importing AREA ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\areamaster alias fpcm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan for !empty(area_name)
	sele mpcm
	appen blank
	repl sgcode with 'AREA  '
	repl scode with padr(fpcm.area_id,6)
	repl sname with upper(fpcm.area_name)
	repl parnam with upper(fpcm.area_name)
endsc
close table all
@rowno,10 say '**** Importing Patient****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\PatientMaster.dbf alias fpat
sele sele (1)
use &datdev\maorder.&datext alias mdoc
set filt to scode='PET#$~'
dele all
pack
index on scode to mdoc 
sele fpat 
go top
do while !eof()
   sele mdoc 
   append blank
   repl mdoc.scode with 'PET#$~',;
        mdoc.ordno with alltrim(str(fpat.pm_id)),;
        mdoc.parnam with upper(fpat.pm_fullname),;
        mdoc.form with upper(alltrim(str(fpat.pm_id)))
     sele fpat
skip
ENDDO
close data all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stockregister alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
set filt to stk_tran_typ='C'
go top
do while !eof()
   sele mitm
   seek  str(fsbal.stk_mmid,9)
   sele msbal
   seek str(fsbal.stk_mmid,9)+ substr(fsbal.stk_batchno+space(12),1,12)
   if !found()
      append blank
      repl msbal.code with mitm.code,;
           msbal.name with mitm.name,;
           msbal.billname with mitm.billname,;
           msbal.product with mitm.product,;
           msbal.pack with mitm.pack,;
           msbal.unit2 with mitm.unit2,;
           msbal.unit with mitm.unit,;
           msbal.decimal with 'Y',;
           msbal.opening with fsbal.stk_salesqty,;
           msbal.balance with (fsbal.stk_salesqty),;
           msbal.o_a with (fsbal.stk_salesqty),;
           msbal.b_a with (fsbal.stk_salesqty),;
           msbal.batchno with fsbal.stk_batchno
     	repl msbal.exp with ctod(substr(fsbal.stk_expdate,9,2)+'/'+substr(fsbal.stk_expdate,6,2)+'/'+substr(fsbal.stk_expdate,1,4)),;
           msbal.mrp with fsbal.stk_mrp,;
           msbal.prate with fsbal.stk_purchaserate,;
           msbal.ratea with fsbal.stk_salesrate,;
           msbal.lprate with fsbal.stk_purchaserate,;           
           msbal.mrp with fsbal.stk_mrp,;
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
	   else
          repl msbal.opening with msbal.opening + (fsbal.stk_salesqty),;
	           msbal.balance with msbal.balance + (fsbal.stk_salesqty),;
	           msbal.o_a with msbal.o_a + (fsbal.stk_salesqty),;
	           msbal.b_a with msbal.b_a + (fsbal.stk_salesqty)
   endif
sele fsbal
skip
enddo
sele msbal
sele fsbal
set filt to stk_tran_typ='D'
go top
do while !eof()
   sele mitm
   seek  str(fsbal.stk_mmid,9)
   sele msbal
   seek str(fsbal.stk_mmid,9)+ substr(fsbal.stk_batchno+space(12),1,12)
   if !found()
      append blank
      repl msbal.code with mitm.code,;
           msbal.name with mitm.name,;
           msbal.billname with mitm.billname,;
           msbal.product with mitm.product,;
           msbal.pack with mitm.pack,;
           msbal.unit2 with mitm.unit2,;
           msbal.unit with mitm.unit,;
           msbal.decimal with 'Y',;
           msbal.opening with -fsbal.stk_salesqty,;
           msbal.balance with -(fsbal.stk_salesqty),;
           msbal.o_a with -(fsbal.stk_salesqty),;
           msbal.b_a with -(fsbal.stk_salesqty),;
           msbal.batchno with fsbal.stk_batchno
     	repl msbal.exp with ctod(substr(fsbal.stk_expdate,9,2)+'/'+substr(fsbal.stk_expdate,6,2)+'/'+substr(fsbal.stk_expdate,1,4)),;
           msbal.mrp with fsbal.stk_mrp,;
           msbal.prate with fsbal.stk_purchaserate,;
           msbal.ratea with fsbal.stk_salesrate,;
           msbal.lprate with fsbal.stk_purchaserate,;           
           msbal.mrp with fsbal.stk_mrp,;
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
	   else
          repl msbal.opening with msbal.opening -(fsbal.stk_salesqty),;
	           msbal.balance with msbal.balance - (fsbal.stk_salesqty),;
	           msbal.o_a with msbal.o_a - (fsbal.stk_salesqty),;
	           msbal.b_a with msbal.b_a - (fsbal.stk_salesqty)
   endif
sele fsbal
skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\vendormaster alias fact
sele sele(1)
use &datatransferpath\vendoraddmaster alias fadr
index on vendadd_vendorid to fadr
sele sele(1)
use &datatransferpath\citymaster alias fcity
index on city_id to fcity
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	=seek(fact.vendor_id,'fadr')
	=seek(fadr.vendadd_cityid,'fcity')
	sele mact
	appen blank
	repl mact.scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.vendor_id))
	repl mact.fax2 with fact.vendor_code
	repl mact.parnam  with upper(fact.vendor_name)
	repl mact.mailnam with upper(fact.vendor_name)
	repl mact.paradd with substr(upper(fadr.vendadd_addr1),1,40)
	repl mact.paradd1 with substr(upper(fadr.vendadd_addr1),41,40)
	repl mact.paradd2 with substr(upper(fadr.vendadd_addr1),81,40)
	repl mact.dsm with fadr.vendadd_pincode	
	repl mact.city with upper(fcity.city_name)
	repl mact.area with fadr.vendadd_areaid
	repl phone1 with fadr.vendadd_mobno
	repl phone2 with fadr.vendadd_phno
	repl mact.dlno with alltr(upper(fadr.vendadd_druglic1))+' '+alltri(upper(fadr.vendadd_druglic2))
	repl gstno with upper(fadr.vendadd_gstno)
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having  
***STATE
	    sele support
	    appen blank
		repl aliase with 'ORDER   '
		repl type with 'F'
		repl lcode with mact.ordno
		repl sno with 7
		repl pcode with 15
		repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
endscan
close tables all
retu
@rowno,10 say '**** Importing A/C Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\sales1 alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
set filter to balance#0
	go top
scan 
	mvcn=alltr(str(fout.salno))
	sele mord
	seek substr(alltri(str(fout.pa_code))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->net),abs(fout->net))
	repl balance with iif(acgroup='D31',-abs(fout.balance),abs(fout.balance))
	repl itemope with iif(acgroup='D31',-abs(fout->net-fout.balance),abs(fout->net-fout.balance))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

@rowno,10 say '**** Importing Ledger Balance  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord 

sele sele(1)
use &datdev\pendings.&datext alias mpend
inde on ord to mpend 

sele mord
go top
	scan
	sele mpend
	seek mord->ordno
	
	sum balance to mbal whil ord=mord->ordno and !eof()
	sele mord
	repl opning with mbal

endsc

clos table all

proc rem_null
totfields = afields(arr)
for imarg = 1 to totfields
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

*!*EOF : PMJAK.PRG .....Dated    by ST
