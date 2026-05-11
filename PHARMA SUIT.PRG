*!*	BOF : pharma Suit.PRG .....Dated    : 27/06/2022   Author : SARVESH
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
	firstdate=ctod('01/04/2024')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2025')                         && Un-Comment this for run from VFP
	datdev='D:\transfer'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif

sure= space(4)
datatransferpath=substr('D:\MIGRATION_DATA\MAR\PHARMA_SUIT\DBF_FILES\'+space(95),1,95)
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
mtrade='Pharma  '
old_12 = 'GST'
mstatecode='32'
removenull = 'NO'


@13,10 say 'PharmaSuit Data Path         :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'PharmaSuit Extension         :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                     :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM               :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO                    :'  font 'courier',18 get old_9    font 'courier',18
@18,10 say 'GST/VAT                      :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code               :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Select Trade                 :'  font 'courier',18 get Mtrade  pict '@M Pharma ,General'  font 'courier',18
@21,10 say 'Removenull                   :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@22,10 say 'Type SURE                    :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing PharmaSuit Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\stock alias fitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,6,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
sele fitm
scan
	sele mitm
	appen blank
	repl code with recno()
	repl name with fitm.icode
	repl product with fitm.iname
	repl packing with fitm.iunit
	repl pack with val(fitm.iunit)
	repl billname with mitm.product+mitm.packing
	repl unit with "PCS"
	repl saltax with fitm.gst/2
	repl cgst   with fitm.gst/2
	repl igst   with fitm.gst
*!*		repl formulano with substr(fitm.market+space(15),1,15)
	repl prate with fitm.ipp
	repl ratea with fitm.iup
	repl mrp with fitm.iup

&&& HSN and Tax Mast
&&HSN
	sele mpcm
	seek 'COMMCD' + substr(fitm.hsn+space(40),1,40) + str(mitm.igst,6,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with substr(fitm.hsn+space(40),1,40),;
			mpcm.parnam with fitm.hsn,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
&&Company
	sele mpcm
	seek 'ZZZZZZ' + substr(fitm.imanf+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'CO'+alltrim(str(recno())),;
			mpcm.sname  with substr(fitm.imanf+space(40),1,40),;
			mpcm.parnam with fitm.imanf,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
&&Salt
	sele mpcm
	seek 'SALT  ' + substr(fitm.combi+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'SA'+alltrim(str(recno())),;
			mpcm.sname  with substr(fitm.combi+space(40),1,40),;
			mpcm.parnam with fitm.combi,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
endscan
close data


@rowno,10 say '**** Importing Batch_Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\batch alias fsbal
sele sele(1)
use &datatransferpath\purch alias pld
index on pic+pbatch to pld

sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno  to msbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F-BT'
pack
r=0
sele fsbal
go top
scan
	=seek(fsbal.bcode+fsbal.bno,'pld')
	sele mitm
	seek substr(fsbal.bcode+space(10),1,10)
	sele msbal
	seek substr(fsbal.bcode+space(10),1,10)+substr(fsbal.bno,1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.decimal with 'Y'
		repl msbal.batchno with fsbal.bno
		repl msbal.exp with fsbal.bexp
		repl msbal.prate with fsbal.bpr
		repl msbal.lprate with iif(!empt(fsbal.bpr),fsbal.bpr+((fsbal.bpr*mitm.igst)/100),0)
		repl msbal.ratea with fsbal.brate
		repl msbal.mrp with fsbal.brate&&bmrp
		repl msbal.misc1 with mitm.gcode
		repl msbal.opening with (fsbal.bqty)
		repl msbal.balance with (fsbal.bqty)
		repl msbal.o_a with (fsbal.bqty)
		repl msbal.b_a with (fsbal.bqty)
		repl supinvo with pld.pinvno
		repl supdat with pld.pd
		repl date with pld.pd
		repl supcode with pld.pspcode
		
	else
		repl msbal.opening with msbal.opening + (fsbal.bqty),;
			msbal.balance with msbal.balance + (fsbal.bqty),;
			msbal.o_a with msbal.o_a + (fsbal.bqty),;
			msbal.b_a with msbal.b_a + (fsbal.bqty)
		repl supinvo with pld.pinvno
		repl supdat with pld.pd
		repl date with pld.pd
		repl supcode with pld.pspcode
	endif
endscan
close table all
try
@rowno,10 say '**** Importing Supplier  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\supl alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	select mact
	append blank
	repl scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with fact.supcode
	repl mact.parnam  with fact.supname
	repl mact.paradd with fact.place,city with fact.place,phone4 with fact.ph,gstno with fact.st,dlno with fact.no
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.mailnam with fact.supname
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	replace mact.opning with 0
endscan
close tables all
catch
	merror=1
endtry
mversion=1
if mversion=1
@rowno,10 say '**** Importing Suppplier  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\drs alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	select mact
	append blank
	repl scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with fact.cc
	repl mact.fax2 with fact.cc
	repl parnam with fact.drname
	repl mact.paradd with substr(fact.line,1,30)
	repl mact.paradd1 with substr(fact.line,31,30)
	repl mact.paradd2 with substr(fact.line,60,30)
	repl phone4 with fact.supcomps
	repl gstno with fact.supco2
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.mailnam with fact.drname
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	replace mact.opning with 0
endscan
close tables all
else

@rowno,10 say '**** Importing Customer  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\drs alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	select mact
	append blank
	repl scode with 'C6'
	repl mact.rate with 'Y'
	repl mact.ordno with fact.dacode
	repl parnam with fact.drname
	repl mact.paradd with fact.dadr
	repl paradd2 with fact.kgst
	repl city with fact.area,phone4 with fact.ph
	repl gstno with fact.tin
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.mailnam with fact.drname
	repl mr with 'MR'+alltri(fact.rc)
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	replace mact.opning with 0
endscan
close tables all

@rowno,10 say '**** Importing MR  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\repp alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	select mact
	append blank
	repl scode with 'D32'
	repl mact.rate with 'Y'
	repl mact.ordno with 'MR'+alltri(fact.repcode),parnam with fact.repname
	repl mact.mailnam with fact.repname
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	replace mact.opning with 0
endscan
close tables all
endif


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
use &datatransferpath\cpurch alias fout

sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan  
	mvcn=cpbno
	sele mord
	seek substr(fout.cppcode+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout->cpbdat
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->cpbamt),abs(fout->cpbamt))
	repl itemope with iif(acgroup='D31',-abs(fout.pamt),abs(fout.pamt))	
	repl balance with iif(acgroup='D31',-abs(final-itemope),abs(final-itemope))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
SELE MPEND
dele all for ddate<firstdate
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

*!*	EOF : pharma Suit.PRG .....Dated    : 27/06/2022   Author : SARVESH
