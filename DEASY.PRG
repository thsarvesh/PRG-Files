*!*	BOF : DEASY.PRG .....Dated    : 24/10/2024   Author : SARVESH
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
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endi
sure= space(4)
datatransferpath=substr('D:\OCT\Deasy\data\Data\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
trade='Retail  '
old_7= ''
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='33'
removenull = 'NO'
@13,10 say 'DEASY Data Path         :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'DEASY Extension         :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'TYPE                    :'  font 'courier',18 get trade  pict '@m Wholesale,Retail'  font 'courier',18
@17,10 say 'Last  2 Chr             :'  font 'courier',18 get old_7 pict '!!' font 'courier',18
@18,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@19,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_9    font 'courier',18
@20,10 say 'GST/VAT                 :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@21,10 say 'State GST Code          :'  font 'courier',18 get mstatecode    font 'courier',18
@22,10 say 'Removenull              :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@23,10 say 'Type SURE               :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing DEASY Data To Marg.....' font 'courier',14 colo 'W+/b'
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

rowno=5

@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
mfile=datatransferpath+'prodmast'
use &mfile alias fitm
sele sele(1)
mfile=datatransferpath+'taxmast'
use &mfile alias ftax
inde on code to ftax
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
select sele(1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm
sele fitm
go top
scan
	last=recno()
	sele ftax
	seek fitm.taxcode
	sele mitm
	seek substr(alltr(fitm.code)+space(10),1,10)
	if !foun()
		append blank
		repl mitm.code with last
		repl mitm.name with substr(alltr(fitm.code)+space(10),1,10)
		repl mitm.product with alltr(fitm.name)
		repl mitm.packing with alltr(fitm.pack)
		repl pack with iif(trade='R',fitm.rateper,0)
		repl mitm.billname with alltr(fitm.name)+' '+alltr(fitm.pack)
		repl mitm.unit with 'PCS'
		repl mitm.gcode with alltr(fitm.group)
		repl mitm.taxl with 'T'
		repl mitm.taxc with 'T'
		repl mitm.decimal with 'Y'
		repl mitm.salfix with 'N'
		repl mitm.halfsche with 'A'
		repl mitm.qtrsche with 'Y'
		repl mitm.status with 'Y'
		repl mitm.saltax with ftax.ptper
		repl mitm.cgst with ftax.ptper
		repl mitm.igst with ftax.ptper*2
		repl mitm.purtax with ftax.ptper
		replace mitm.o_a with fitm.balqty
		replace mitm.b_a with fitm.balqty
		replace mitm.opening with fitm.balqty
		replace mitm.balance with fitm.balqty
		*   REPLACE MITM.PRATE WITH FITM.CPUR
		*   REPLACE MITM.RATEA WITH FITM.CSAL
		*  REPLACE MITM.MRP WITH FITM.CMRP

		repl mitm.tqty with fitm.balqty
		repl gcode4 with '  N#       N     NN '
	else
		if fitm.sch='H1'
			repl gcode4 with '  NN       #     NN '
		endi
	endi
	&&?'foR hsn'
	sele mpcm
	seek 'COMMCD' + substr(fitm.hsncode+space(15),1,15) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'H'+alltrim(str(last)),;
			mpcm.sname  with substr(fitm.hsncode+space(15),1,15)+ substr(fitm.hsncode,1,15)+' '+ alltrim(str(mitm.igst,5,2)),;
			mpcm.parnam with substr(fitm.hsncode,1,15),;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endi
	repl mitm.gcode6 with mpcm.scode
endsc
close table all

@rowno,10 say '**** Importing Company Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
mfile=datatransferpath+'prodgrp'
use &mfile alias fpcm
inde on code to fpcm uniq
sele sele(1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode='ZZZZZZ'
pack
index on scode to mpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ',;
		mpcm.scode  with alltr(fpcm.code),;
		mpcm.sname  with upper(fpcm.name),;
		mpcm.parnam with upper(fpcm.name),;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
endsc
close table all
if trade='W'
	@rowno,10 say '**** Importing Area Master ****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	mfile=datatransferpath+'divmas'
	use &mfile alias fpcm
	inde on code to fpcm uniq
	sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	delete all for sgcode='AREA '
	pack
	sele fpcm
	go top
	scan
		sele mpcm
		append blank
		repl mpcm.sgcode with 'AREA  ',;
			mpcm.scode  with alltr(farr.code),;
			mpcm.sname  with upper(farr.name),;
			mpcm.parnam with upper(farr.name),;
			mpcm.tcode with 'No',;
			mpcm.tax with 1
	endsc
	close table all
endif
*	?'** Transferring category'
*	sele sele(1)
*	use fdir+'prodmast'+old_7+'.dbf' ALIAS fpcm
**    inde on type TO fpcm uniq
*sele sele(1)
*	use tdir+'saletype.'+old_2 ALIAS mpcm
*	dele all for sgcode='CATEGO'
*	pack
*	index on scode to mpcm
*	sele fpcm
*	go top
*	do while .not. eof()
*	   sele mpcm
*	   append blank
*	   repl mpcm.sgcode with 'CATEGO',;
*	        mpcm.scode  with alltr(fpcm.TYPE),;
*       mpcm.sname  with UPPER(fpcm.TYPE),;
*        mpcm.parnam with UPPER(fpcm.TYPE),;
*       mpcm.tcode with 'No',;
*      mpcm.tax with 1
*	sele fpcm
*	skip
*	enddo
*	close all

if trade='Retail'
	@rowno,10 say '**** Importing Patient ****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datatransferpath\patient alias fdoc
	sele sele (1)
	use &datdev\maorder.&datext alias mdoc
	dele all for  scode='PET#$~'
	pack
	sele fdoc
	go top
	cd=10
	scan
		sele mdoc
		append blank
		repl mdoc.scode with 'PET#$~',;
			mdoc.ordno with alltrim(str(cd)),;
			mdoc.parnam with fdoc.name,;
			mdoc.form with fdoc.code
		cd = cd + 1
	endsc
	close table all

	@rowno,10 say '**** Importing Doctor ****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datatransferpath\patient alias fdoc
	sele sele (1)
	use &datdev\maorder.&datext alias mdoc
	dele all for  scode='PRE#$~'
	sele fdoc
	go top
	scan
		sele mdoc
		append blank
		repl mdoc.scode with 'PRE#$~',;
			mdoc.parnam with substr(fdoc.name,1,25),;
			mdoc.city with ' ',;
			mdoc.form with fdoc.code
	endsc
	close table all
endif

@rowno,10 say '**** Importing Batch (Zero Stock) ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
mfile=datatransferpath+'stock'
use &mfile alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
zap
index on name + batchno to msbal
r=0
sele fsbal
go top
scan for seek(substr(alltr(fsbal.code)+space(10),1,10),'mitm')
	sele msbal
	seek substr(alltr(fsbal.code)+space(10),1,10)+substr(alltr(fsbal.batch)+space(12),1,12)
	if .not. found()
		append blank
		repl      msbal.date with date()
		repl      msbal.code with mitm.code
		repl      msbal.name with mitm.name
		repl      msbal.billname with mitm.billname
		repl      msbal.product with mitm.product
		repl      msbal.packing with mitm.packing
		repl      msbal.pack with mitm.pack
		repl      msbal.unit2 with mitm.unit2
		repl      msbal.unit with mitm.unit
		repl      msbal.decimal with 'Y'
		repl      msbal.opening with 0
		repl      msbal.balance with 0
		repl      msbal.o_a with 0
		repl      msbal.b_a with 0
		repl      msbal.batchno with alltr(fsbal.batch)
		if trade='W'
			repl      msbal.exp with ctod('01'+'/'+substr(fsbal.expdate,1,2)+'/'+substr(fsbal.expdate,4,4))
		else
			repl      msbal.exp with fsbal.expdate
		endif
		repl      msbal.prate with fsbal.prate
		repl      msbal.ratea with fsbal.srate
		repl      msbal.mrp with fsbal.mrp
		repl 		msbal.supcode with fsbal.scode
		repl 		msbal.supinvo with fsbal.billno
		repl 		msbal.supdat with fsbal.date
		repl      msbal.misc1 with mitm.gcode
	endif
endsc
close table all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
mfile=datatransferpath+'stock'
use &mfile alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
zap
index on name + batchno to msbal
r=0
sele fsbal
go top
scan for seek(substr(alltr(fsbal.code)+space(10),1,10),'mitm')
	sele msbal
	seek substr(alltr(fsbal.code)+space(10),1,10)+substr(alltr(fsbal.batch)+space(12),1,12)
	if .not. found()
		append blank
		repl      msbal.date with date()
		repl      msbal.code with mitm.code
		repl      msbal.name with mitm.name
		repl      msbal.billname with mitm.billname
		repl      msbal.product with mitm.product
		repl      msbal.packing with mitm.packing
		repl      msbal.pack with mitm.pack
		repl      msbal.unit2 with mitm.unit2
		repl      msbal.unit with mitm.unit
		repl      msbal.decimal with 'Y'
		repl      msbal.opening with iif(trade='W',fsbal.qty+fsbal.free,fsbal.balqty)
		repl      msbal.balance with  iif(trade='W',fsbal.qty+fsbal.free,fsbal.balqty)
		repl      msbal.o_a with  iif(trade='W',fsbal.qty+fsbal.free,fsbal.balqty)
		repl      msbal.b_a with  iif(trade='W',fsbal.qty+fsbal.free,fsbal.balqty)
		repl      msbal.batchno with alltr(fsbal.batch)
		if trade='W'
			repl      msbal.exp with ctod('01'+'/'+substr(fsbal.expdate,1,2)+'/'+substr(fsbal.expdate,4,4))
		else
			repl      msbal.exp with fsbal.expdate
		endif
		repl      msbal.prate with fsbal.prate
		repl      msbal.lprate with iif(trade='W',fsbal.cost,fsbal.prate)
		repl      msbal.ratea with fsbal.srate
		repl      msbal.mrp with fsbal.mrp
		repl 		msbal.supcode with fsbal.scode
		repl 		msbal.supinvo with fsbal.billno
		repl 		msbal.supdat with fsbal.date
		repl      msbal.misc1 with mitm.gcode
	else
		repl      msbal.opening with msbal.opening+ iif(trade='W',fsbal.qty+fsbal.free,fsbal.balqty)
		repl      msbal.balance with msbal.balance+ iif(trade='W',fsbal.qty+fsbal.free,fsbal.balqty)
		repl      msbal.o_a with msbal.o_a+ iif(trade='W',fsbal.qty+fsbal.free,fsbal.balqty)
		repl      msbal.b_a with msbal.b_a+ iif(trade='W',fsbal.qty+fsbal.free,fsbal.balqty)
		repl      msbal.lprate with iif(trade='W',fsbal.cost,fsbal.prate)
		if trade='W'
			repl      msbal.exp with ctod('01'+'/'+substr(fsbal.expdate,1,2)+'/'+substr(fsbal.expdate,4,4))
		else
			repl      msbal.exp with fsbal.expdate
		endif
		repl      msbal.prate with fsbal.prate
		repl      msbal.ratea with fsbal.srate
		repl      msbal.mrp with fsbal.mrp
	endif
endsc
close all

@rowno,10 say '**** Importing Account Master****' font 'Arial',10
rowno=rowno+1
sele sele(1)
mfile=datatransferpath+'ledgmast'
use &mfile alias fact
sele sele(1)
use &datdev\order.&datext alias mact
if trade='W'
	sele sele(1)
	mfile=datatransferpath+'custout'
	use &mfile alias fout
	index on acode to fout
endif
sele sele(1)
sele sele(1)
mfile=datatransferpath+'daybook'
use &mfile alias fout1
index on acode to fout1
sele fact
go top
scan
	last=recno()
	store 0 to bal
	if trade='W'
		sele fout
		seek fact.code
		sum balamt to bal for fout.acode=fact.code
	endif
	sele fout1
	seek fact.code

	sum amount to tot1 for fout1.acode=fact.code  and fout1.amount>0
	sum amount to tot2 for fout1.acode=fact.code  and fout1.amount<0

	sum amount to tot1 for fout1.acode=fact.code and fout1.acode=fout1.ccode and fout1.amount>0
	sum amount to tot2 for fout1.acode=fact.code and fout1.acode#fout1.ccode and fout1.amount<0

	tot = tot1-(-tot2)

	sele mact
	append blank
	if fact.grp='DEB' or fact.gcode='A0011'
		repl      mact.scode with 'C6'
	else
		if fact.grp='CRE' or fact.gcode='A0007'
			repl      mact.scode with 'D31'
		endi
	endi
	repl      mact.rate with 'Y'
	repl      mact.ordno with alltrim(fact.code)
	repl      mact.parnam  with fact.name
	repl      mact.paradd with fact.address1
	repl      mact.paradd1 with fact.address2
	repl      mact.paradd2 with fact.address3
	repl      mact.sthed with  'TIN No.'
	repl      mact.csthed with 'CST  No.'
	repl      mact.gsthed with 'GST  No.'
	repl      mact.stno with fact.tinno
	repl      mact.gstno with fact.gstin
	repl      mact.phone1 with fact.phone
	repl      mact.phone2 with fact.contact
	repl      mact.phone4 with fact.cell
	repl      mact.dlno with fact.dlno1+'*'+' '+ alltrim(fact.dlno2)
	repl      mact.mailnam with fact.name
	repl      mact.ref with 'Mr.'
	repl      mact.price with 'A'
	repl      mact.status with 'Y'
	repl      mact.adhed with 'Discount'
	repl 	 mact.area with iif(trade='W',fact.dcode,'')
	repl      mact.opning with iif(mact.scode='C6', bal, -abs(fact.balance+tot))
	repl		 mact.balance with iif(mact.scode='C6', bal, -abs(fact.balance+tot))
endsc
close table all
if trade='W'
@rowno,10 say '**** Importing Account Master****' font 'Arial',10
rowno=rowno+1
sele sele(1)
mfile=datatransferpath+'custout'
use &mfile alias fact
index on code to fact

sele sele(1)
mfile=datatransferpath+'ledgmast'
use &mfile alias fout
sele sele (1)
use &datdev\order.&datext alias forder
sele sele (1)
use &datdev\pendings.&datext alias 
sele sele (1)
use &datdev\slipno.&datext alias mslip
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
	sele fout
	go top
	scan
		select fact
		seek fout.acode
		sele mpend
		append blank
		if fact.grp='DEB' or fact.gcode='A0011'
			repl mpend.acgroup with 'C6'
		else
			if fact.grp='CRE' or fact.gcode='A0007'
				repl mpend.acgroup with 'D31'
			endi
		endi
		* repl mpend.acgroup with fact.code
		repl mpend.ord with fout.acode
		repl mpend.ddate with fout.date
		repl mpend.vcn with alltrim(fout.billno) &&&alltrim(fout.c_prefix)+alltrim(str(fout.n_srno,20))
		repl mpend.invtype with 'O'
		repl mpend.voucher  with vou
		repl mpend.svoucher with svou
		repl mpend.final with fout.balamt
		repl mpend.balance with fout.balamt
		repl mpend.name with fout.billno

		vou=vou+5
		svou=svou+5
	endscan
	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5
	close table all
endif

@rowno,10 say '**** Importing Supplier Outstanding****' font 'Arial',10
rowno=rowno+1
sele sele(1)
mfile=datatransferpath+'ledgmast'
use &mfile alias fact
index on code to fact
sele sele(1)
mfile=datatransferpath+'daybook'
use &mfile alias fout
sele sele (1)
use &datdev\order.&datext alias forder
sele sele (1)
use &datdev\pendings.&datext alias mpend
sele sele (1)
use &datdev\slipno.&datext alias mslip
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10

sele fout
go top
scan
	select fact
	seek fout.acode

	sele mpend
	append blank
	if fact.grp='CRE' or fact.gcode='A0007'
		repl mpend.acgroup with 'D31'
	endi
	repl mpend.ord with fout.acode
	repl mpend.ddate with fout.date
	repl mpend.vcn with alltrim(fout.billno)
	repl mpend.invtype with 'O'
	repl mpend.voucher  with vou
	repl mpend.svoucher with svou

	if fout.amount>0
		repl mpend.final with -(fout.amount)
	endif
	if fout.amount<0
		replace mpend.itemope with -(fout.amount)
	endif


	if fout.acode=fout.ccode and fout.amount>0
		repl mpend.final with -(fout.amount)
	endif
	if fout.acode#fout.ccode and fout.amount<0
		replace mpend.itemope with -(fout.amount)
	endif

	repl mpend.balance with (mpend.final + mpend.itemope)
	repl mpend.name with fout.billno

	vou=vou+5
	svou=svou+5
endscan
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

*!*	@rowno,10 say '**** Importing Account Vouchers  ****' font 'Arial',12
*!*	rowno=rowno+1

*!*	sele sele(1)
*!*	use &datdev\gledger.&datext alias gledger

*!*	sele sele(1)
*!*	use &datdev\DAY.&datext alias DAY

*!*	SELECT DAY
*!*	go top
*!*	do while ! eof()

*!*	 SELECT GLEDGER
*!*	 append blank
*!*	 repl voucher with last4
*!*	 if mled->type = 'C'
*!*	  repl cd with 'C'
*!*	  repl credit with led->amount
*!*	  repl book with 'R'
*!*	 else
*!*	  repl cd with 'D'
*!*	  repl debit with led->amount
*!*	  repl book with 'P'
*!*	 endif
*!*	 repl vcsno with led->vrno
*!*	 repl date with mled->vrdate
*!*	 repl code with led->accode
*!*	 repl code1 with led->book
*!*	 repl remark1 with led->part+led->chno
*!*	 repl remark2 WITH ' '
*!*	***contra
*!*	 sele gledger
*!*	 append blank
*!*	 repl voucher with last4
*!*	 if mled->type = 'C'
*!*	  repl cd with 'D'
*!*	  repl debit with led->amount
*!*	  repl book with 'R'
*!*	 else
*!*	  repl cd with 'C'
*!*	  repl credit with led->amount
*!*	  repl book with 'P'
*!*	endif
*!*	 repl vcsno with led->vrno
*!*	 repl date with mled->vrdate
*!*	 repl code with led->book
*!*	 repl code1 with led->accode
*!*	 repl remark1 with led->part+led->chno
*!*	 repl remark2 WITH ' '
*!*	 sele mled
*!*	 skip
*!*	enddo
*!*	close tabl all



*?"DEVELOPED BY UMESH NATH GOSWAMI"
proc  removenull
	*use &fdir\itmst
	*	do rem_null
	*use &fdir\btmst
	*	do rem_null

	*use &fdir\famst
	*	do rem_null

	*use &fdir\acmast
	*	do rem_null

	*use &fdir\head
	*	do rem_null
	*!*	use &fdir\accounts
	*!*		do rem_null
	*!*	use &fdir\salesmaster
	*!*		do rem_null
	*!*	use &fDir\saleschild
	*!*	    do rem_null
	*!*	use &fDir\purchasemaster
	*!*	    do rem_null
	*!*	use &fDir\purchasechild
	*!*	    do rem_null

proc  rem_null
	a = afields(arr)
	for i = 1 to a
		mfldname = arr(i, 1)
		do case
			case inlist(arr(i,2), "C","V")
				replace all &mfldname with '' for isnull(&mfldname)
			case inlist(arr(i,2), "B","N","I","F","Y")
				replace all &mfldname with 0 for isnull(&mfldname)
			case inlist(arr(i,2), "D","T")
				replace all &mfldname with ctod('') for isnull(&mfldname)
		endcase
	endfor








