*!*	BOF : Bhat.PRG .....Dated    : 28/04/2025   Author : SARVESH
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
	firstdate=ctod('01/04/2022')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2023')                         && Un-Comment this for run from VFP
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\apr\Bhat\Apr2025\DATE25\DATA25\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
lastchr='11'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='29'
removenull = 'NO'
@13,10 say 'BHAT Data Path          :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'BHAT Extension          :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing BHAT Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\stock&lastchr alias fitm
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
	repl code with fitm.icode
	repl name with alltri(str(fitm.icode))
	repl product with fitm.iname
	repl packing with ''
	repl billname with fitm.iname
	repl pack with 0
	repl rackno with ''
	repl unit with fitm.unit
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.gcode with fitm.acode
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.mrp
	repl mitm.ratea with fitm.grate
	repl mitm.rateb with fitm.grate
	repl mitm.prate with fitm.rate
	mtax=fitm.vrate
	repl saltax with mtax/2
	repl cgst   with mtax/2
	repl igst   with mtax
	mhsn=fitm.pcode
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
	&&&Company
	sele mpcm
	seek 'ZZZZZZ' + substr(fitm.acode+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with fitm.acode,;
			mpcm.parnam with fitm.acode,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
	&&&Group
	sele mpcm
	seek 'SALT  ' + substr(fitm.lname+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with fitm.lname,;
			mpcm.parnam with fitm.lname,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock&lastchr alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan
	sele mitm
	seek str(fsbal.icode,9)
	sele msbal
	seek str(fsbal.icode,9)
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
			msbal.opening with fsbal.pqty-fsbal.sqty,;
			msbal.balance with fsbal.pqty-fsbal.sqty,;
			msbal.o_a with fsbal.pqty-fsbal.sqty,;
			msbal.b_a with fsbal.pqty-fsbal.sqty,;
			msbal.batchno with ''
		repl msbal.exp with ctod(''),;
			msbal.mrp with fsbal.mrp,;
			msbal.prate with fsbal.rate,;
			msbal.ratea with fsbal.rate,;
			msbal.lprate with fsbal.rate,;
			msbal.rateb with fsbal.grate,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
	else
		repl msbal.opening with msbal.opening +(fsbal.pqty-fsbal.sqty),;
			msbal.balance with msbal.balance+(fsbal.pqty-fsbal.sqty),;
			msbal.o_a with msbal.o_a +(fsbal.pqty-fsbal.sqty),;
			msbal.b_a with msbal.b_a +(fsbal.pqty-fsbal.sqty)
	endif
endsca
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\acc&lastchr alias fact
sele sele(1)
use &datatransferpath\ledg&lastchr alias fbal
index on acname to fbal
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='AREA  '
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
		do case
			case fact.gname='SUNDRY DEBTORS      '
				mscode='C6'
			case fact.gname='SUNDRY CREDITORS    '
				mscode='D31'
			case fact.gname='MSTAFF              '
				mscode='D32'
			case fact.gname='CASH IN HAND        '
				mscode='C2'
			otherwise
				mscode='J12'
			endcase
	repl mact.scode with mscode
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(recno()))
	repl mact.parnam  with fact.acname
	repl mact.mailnam with fact.acname
	repl mact.paradd with fact.add1
	repl mact.paradd1 with fact.add2
	repl mact.paradd2 with alltri(fact.add3)+' '+alltri(fact.add4)
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.gstno with fact.tinnum
	repl phone4 with fact.mphone
	repl phone1 with fact.mphone
	repl phone2 with fact.phone
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	store 0 to mbal
	sele fbal
	seek fact.acname
	sum debit-credit to mbal while acname=fact.acname
	sele mact
	repl opning with mbal
	*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having
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
	marea=''
	&&&&& Area Master
	sele mpcm
	seek 'AREA  '+substr(upper(marea)+space(40),1,40)
	if !found()
		appen blank
		repl sgcode with 'AREA  '
		repl scode with 'A'+alltri(str(recno()))
		repl sname with marea
		repl parnam with marea
	endif
	repl mact.scode with mpcm.scode
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
*!*	BOF : Bhat.PRG .....Dated    : 28/04/2025   Author : SARVESH
