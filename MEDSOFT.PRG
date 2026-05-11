*!*	BOF : MEDSOFT.PRG .....Dated    : 14/08/2025   Author : SARVESH
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
*!*	replace  setup with 'Item Wise Double Discount ',value with 'Y'
*!*	appen blank
*!*	replace  setup with 'Volume discount 1st ',value with 'L'
*!*	brow font 'COURIER',18    nomodify
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Aug\MedSoft\gst\'+space(95),1,95) &&rpos_path
datatransferext='mst'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='32'
removenull = 'NO'
@13,10 say 'MEDSOFT Data Path       :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'MEDSOFT Extension       :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing MEDSOFT Data To Marg.....' font 'courier',14 colo 'W+/b'
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
delete all for inlist(sgcode,'ZZZZZZ','COMMCD','CATEGO','SALT  ','AREA','ROUT')
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
close table all
rowno=5
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\promas.&datatransferext alias fitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
do while !eof()
	sele mitm
	appen blank
	replace code with recno()
	replace name with fitm.pm_cod
	replace product with fitm.pm_nm
	replace packing with fitm.pm_pac
	replace billname with mitm.product+mitm.packing
	replace pack with fitm.pm_un
	replace rackno with ''
	replace unit with 'PCS'
	replace mitm.decimal with 'Y'
	replace mitm.salfix with 'N'
	replace mitm.gcode with fitm.pm_cc
	replace mitm.maximum with 0
	replace mitm.halfsche with 'A'
	replace mitm.qtrsche with 'Y'
	replace mitm.salsc with 0
	replace mitm.mrp with fitm.pm_mrp
	replace mitm.ratea with fitm.pm_srt
	replace mitm.lprate with fitm.pm_inrt
	replace mitm.prate with fitm.pm_prt
	replace saltax with fitm.pm_ptax/2
	replace cgst   with fitm.pm_ptax/2
	replace igst   with fitm.pm_ptax
	mhsn=alltri(str(fitm.pm_hsn))
	&&&HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(mhsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		replace mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with mhsn,;
			mpcm.parnam with mhsn,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	replace mitm.gcode6 with mpcm.scode
	sele fitm
	skip
enddo
close table all
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\commas.&datatransferext alia fpcm
sele fpcm
go top
do while !eof()
	sele mpcm
	append blank
	replace mpcm.sgcode with 'ZZZZZZ  '
	replace mpcm.scode  with fpcm.cm_cod
	replace mpcm.sname  with fpcm.cm_nm
	replace mpcm.parnam with fpcm.cm_nm
	replace mpcm.tcode with 'No'
	sele fpcm
	skip
enddo
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stomas.&datatransferext alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
go top
do while !eof()
	sele mitm
	seek substr(fsbal.st_cod+space(10),1,10)
	sele msbal
	seek substr(fsbal.st_cod+space(10),1,10)+substr(fsbal.st_bn+space(12),1,12)
	if !found()
		append blank
		replace msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with mitm.pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with fsbal.st_qty,;
			msbal.balance with fsbal.st_qty,;
			msbal.o_a with fsbal.st_qty,;
			msbal.b_a with fsbal.st_qty,;
			msbal.batchno with fsbal.st_bn
		replace msbal.exp with ctod('01/'+substr(fsbal.st_exp,1,2)+'/'+substr(fsbal.st_exp,3,4)),;
			msbal.mrp with fsbal.st_mrp,;
			msbal.prate with fsbal.st_prt,;
			msbal.ratea with fsbal.st_srt,;
			msbal.lprate with fsbal.st_prt,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
		replace msbal.date with fsbal.st_dt
		replace msbal.supdat with fsbal.st_dt
	else
		replace msbal.opening with msbal.opening + fsbal.st_qty,;
			msbal.balance with msbal.balance + fsbal.st_qty,;
			msbal.o_a with msbal.o_a + fsbal.st_qty,;
			msbal.b_a with msbal.b_a + fsbal.st_qty
	endif
	sele fsbal
	skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\cusmas.&datatransferext alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
do while !eof()
	sele mact
	appen blank
	replace mact.scode with 'C6'
	replace mact.rate with 'Y'
	replace mact.ordno with fact.cu_cod
	replace mact.fax2 with fact.cu_cod
	replace mact.parnam  with substr(fact.cu_nm+space(30),1,30)+fact.cu_pl
	replace mact.mailnam with fact.cu_nm
	replace mact.paradd with fact.cu_ad1
	replace mact.paradd1 with fact.cu_ad2
	replace mact.dsm with fact.cu_pin
	replace mact.city with fact.cu_pl
	replace mact.dlno with alltri(fact.cu_dl1)+' '+alltri(fact.cu_dl2)
	replace gstno with fact.cu_st
	replace stno with fact.cu_cst
	replace phone1 with fact.cu_hol
	replace phone2 with fact.cu_ph1
	replace mact.sthed with  'TIN No.'
	replace mact.gsthed with  'GST No.'
	replace mact.csthed with 'CST  No.'
	replace mact.ref with 'Mr.'
	replace mact.price with 'A'
	replace mact.status with 'Y'
	replace mact.opning with fact.cu_ytd
	*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having
	&&&STATE
	sele support
	appen blank
	replace aliase with 'ORDER   '
	replace type with 'F'
	replace lcode with mact.ordno
	replace sno with 7
	replace pcode with 15
	replace remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	&&Local/Central Update
	select support
	appe blan
	replace aliase with 'LBTDETAI'
	replace type with 'F'
	replace lcode with mact.ordno
	replace heading with iif(mstatecode=left(mact.gstno,2) and empty(mact.gstno),'L            LN','L            ON ')
	&&&&& Area Master
	sele mpcm
	seek 'AREA  '+substr(upper(fact.cu_ter)+space(40),1,40)
	if !found()
		appen blank
		replace sgcode with 'AREA  '
		replace scode with 'A'+alltri(str(recno()))
		replace sname with upper(fact.cu_ter)
		replace parnam with sname
	endif
	replace mact.scode with mpcm.scode
	sele fact
	skip
enddo
close tables all
=messagebox('Master Transfer has been done,Please check the data','MargErp')
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
	replace acgroup with mord->scode
	replace ord with mord.ordno
	replace ddate with fout.date
	replace vcn with mvcn
	replace invtype with 'O'
	replace voucher  with vou
	replace svoucher with svou
	replace final with iif(acgroup='D31',-abs(fout->net),abs(fout->net))
	replace balance with iif(acgroup='D31',-abs(fout.balance),abs(fout.balance))
	replace itemope with iif(acgroup='D31',-abs(fout->net-fout.balance),abs(fout->net-fout.balance))
	replace name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
replace voucher  with vou+5
replace svoucher with svou+5
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
	replace opning with mbal
endsc
clos table all
proc rem_null
	totfields = afields(arr)
	for imarg = 1 to totfields
		mfldname = arr(imarg, 1)
		do case
			case inlist(arr(imarg,2), "C","V","M")
				replaceace all &mfldname with '' for isnull(&mfldname)
			case inlist(arr(imarg,2), "B","N","I","F","Y")
				replaceace all &mfldname with 0 for isnull(&mfldname)
			case inlist(arr(imarg,2), "D","T")
				replaceace all &mfldname with ctod('') for isnull(&mfldname)
		endcase
	endfor
*!*	EOF : MEDSOFT.PRG .....Dated    : 14/08/2025   Author : SARVESH
