*!*	BOF : DHANIGACHALAM.PRG .....Dated    : 26-06-2025   Author : SARVESH
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
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\July\Spinal\data\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='33'
removenull = 'NO'
@13,10 say 'DHANIGACHALAM Data Path  :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'DHANIGACHALAM Extension  :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                 :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM           :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO                :'  font 'courier',18 get old_9    font 'courier',18
@18,10 say 'GST/VAT                  :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code           :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Removenull               :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@21,10 say 'Type SURE                :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing DHANIGACHALAM Data To Marg.....' font 'courier',14 colo 'W+/b'
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
close table all
rowno=5
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock alias fitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
	sele mitm
	appen blank
	repl code with recno()
	repl name with fitm.code
	repl product with fitm.item
	repl billname with fitm.item
	repl pack with 0
	repl rackno with fitm.barcode
	repl unit with 'Pcs'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.maximum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with val(fitm.mrp)
	repl mitm.ratea with val(fitm.p)
	repl mitm.rateb with val(fitm.ws)
	repl mitm.lprate with val(fitm.op)
	repl mitm.prate with val(fitm.op)
	repl saltax with val(fitm.cgst)
	repl cgst   with val(fitm.cgst)
	repl igst   with val(fitm.cgst)*2
	repl opening with val(fitm.stock)
	repl balance with val(fitm.stock)
	repl b_a with val(fitm.stock)
	repl o_a with val(fitm.stock)
	mhsn=fitm.hsn
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
	repl mitm.gcode6 with mpcm.scode
	&&&Company Master Update
	mcomp=fitm.comp
	sele mpcm
	seek 'ZZZZZZ' + substr(mcomp+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with mcomp,;
			mpcm.parnam with mcomp,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
	&&&Group Master Update
	mgroup=fitm.head
	sele mpcm
	seek 'SALT  ' + substr(mgroup+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with mgroup,;
			mpcm.parnam with mgroup,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
go top
scan
	xmrp=val(fsbal.mrp)
	xprate=val(fsbal.op)
	xratea=val(fsbal.p)
	xrateb=val(fsbal.ws)
	sele mitm
	seek substr(fsbal.code+space(10),1,10)
	sele msbal
	seek substr(fsbal.code+space(10),1,10)+str(xmrp,9,2)
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
			msbal.mycode with fsbal.barcode,;
			msbal.opening with val(fsbal.stock),;
			msbal.balance with val(fsbal.stock),;
			msbal.o_a with val(fsbal.stock),;
			msbal.b_a with val(fsbal.stock),;
			msbal.batchno with str(xmrp,9,2)
		repl msbal.exp with ctod(''),;
			msbal.mrp with xmrp,;
			msbal.prate with xprate,;
			msbal.ratea with xratea,;
			msbal.rateb with xrateb,;
			msbal.lprate with xprate,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
	else
		repl msbal.opening with msbal.opening + val(fsbal.stock),;
			msbal.balance with msbal.balance + val(fsbal.stock),;
			msbal.o_a with msbal.o_a + val(fsbal.stock),;
			msbal.b_a with msbal.b_a + val(fsbal.stock)
	endif
endscan
sele msbal
close table all
@rowno,10 say '**** Importing Customer Master****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\name alias fact
sele sele(1)
use &datdev\sborder.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias msup
delete all for pcode=123456789 or pcode=123456790
index on type+aliase+lcode+str(pcode,9) to msup
sele fact
go top
scan
	xzipcode=''
	xpoint=val(fact.point)
	sele mact
	appen blank
	repl scode with '!@#POS'
	repl subcode with fact.cno
	repl couponno with iif(!empty(fact.cell),fact.cell,fact.cno)
	repl parnam with fact.name
	repl paradd with fact.add
	repl paradd1 with fact.add1
	repl paradd2 with fact.add2
	sele msup
	seek 'P'+substr(mact.couponno+space(8),1,8)+substr(mact.couponno+space(6),9,6)+str(123456789,9)
		if !found()
			appen blank
			repl type with 'P'
			repl aliase with substr(mact.couponno,1,8)
			repl lcode with substr(mact.couponno,9,6)
			repl pcode with 123456789
		endif
		repl remark with str(xpoint,9,1)
	sele msup
	seek 'P'+substr(mact.couponno+space(8),1,8)+substr(mact.couponno+space(6),9,6)+str(123456790,9)
		if !found()
			appen blank
			repl type with 'P'
			repl aliase with substr(mact.couponno,1,8)
			repl lcode with substr(mact.couponno,9,6)
			repl pcode with 123456790
		endif
		repl remark with 'DEF'+mstatecode+space(21)+xzipcode
endsca
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\cash alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='AREA  '
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan for group='SUPL '
	sele mact
	appen blank
	do case
		case fact.group='SUPL '
			mscode='D31'
		otherwise
			mscode='J12'
	endcase
	repl mact.scode with mscode
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(recno()))
	repl mact.fax2 with fact.id
	repl mact.parnam  with fact.name
	repl mact.mailnam with fact.name
	repl mact.paradd with alltri(fact.add)+' '+alltri(fact.add1)
	repl mact.paradd1 with fact.add2
	repl mact.paradd2 with fact.add3
	repl phone1 with fact.vno
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.gstno with ''
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
*!*		repl mact.opning with -fact.balamt
	&&&STATE
	sele support
	appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	&&Local/Central Update
	select support
	appe blan
	repl aliase with 'LBTDETAI'
	repl type with 'F'
	repl lcode with mact.ordno
	repl heading with iif(mstatecode=left(mact.gstno,2) and empty(mact.gstno),'L            LN','L            ON ')
endscan
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
*!*	EOF : DHANIGACHALAM.PRG .....Dated    : 26-06-2025   Author : SARVESH
