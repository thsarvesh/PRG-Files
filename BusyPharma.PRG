&&&SARVESH THAKUR
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
create curs mycurs  (setup c(50),value c(4))
sele mycurs
appe blank
repl  setup with 'Item Wise Double Discount ',value with 'Y'
appen blank
repl  setup with 'Ask Discount in Amount ',value with 'N'
brow font 'tahoma',12   nomodify
if type('FINALCP')='U'
	firstdate=ctod('01/04/2026')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2027')                         && Un-Comment this for run from VFP
	datdev='d:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\MIGRATION_DATA\APR\PHARMA-RETAIL-BUSY\'+space(100),1,100) &&rpos_path
datatransferext='DBF '
if type('FINALCP')#'U'
	colofhed="BUSY SOFTWARE MIGRATION"
	=colofil(3,5,19,70,10)
endif
old_3 = 'Yes'
old_4 = 'Full Migration     '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
mtrade='Pharma  '
outsonly='No '
scalc='9'
pcalc='2'
disaftertax='N'
disaftertaxp='N'
old_12 = 'GST '
mstatecode='19'
taxfrommaster='No '
removenull = 'NO'
@4,7  say '                              Busy To Marg Transfer Process '+space(30) font 'Arial bold',14 color rgb(20,255,255,119,136,153)
@6,7  say 'Busy Data Path           :' font 'Courier New',12  get datatransferpath font 'Courier New',12
@7,7  say 'Busy Extension           :' font 'Courier New',12  get datatransferext font 'Courier New',12
@8,7  say 'WITH O/S                 :' font 'Courier New',12  get old_3 pict '@m YES,NO ' font 'Courier New',12
@9,7  say 'MIGRATION TYPE           :' font 'Courier New',12  get old_4 pict '@m Master Migration,Full Migration '  font 'Courier New',12
@10,7 say 'F.Y.BEGIN FROM           :' font 'Courier New',12  get old_5 font 'Courier New',12
@11,7 say 'F.Y.UP TO                :' font 'Courier New',12  get old_9  font 'Courier New',12
@12,7 say 'GST/VAT                  :' font 'Courier New',12  get old_12 pict '@m GST ,VAT ' font 'Courier New',12
@13,7 say 'SALE CALCULATION         :' font 'Courier New',12  get scalc  font 'Courier New',12
@14,7 say 'PURCHASE CALCULATION     :' font 'Courier New',12  get pcalc font 'Courier New',12
@15,7 say 'State GST Code           :' font 'Courier New',12  get mstatecode  font 'Courier New',12
@16,7 say 'Tax From Master in Bills :' font 'Courier New',12  get taxfrommaster pict '@m No ,Yes' font 'Courier New',12
@17,7 say 'Discount Before Tax      :' font 'Courier New',12  get disaftertax pict '@m No ,Yes' font 'Courier New',12
@18,7 say 'Disc Before Tax in Purc  :' font 'Courier New',12  get disaftertaxp pict '@m No ,Yes' font 'Courier New',12
@19,7 say 'Removenull               :' font 'Courier New',12  get removenull pict '@m No ,Yes' font 'Courier New',12
@20,7 say 'Type SURE                :' font 'Courier New',12  get sure pict '@x!' font 'Courier New',12
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
@3,7  say '                              Please Wait..Importing Busy Data To Marg..... '+space(30) font 'Arial bold',14 color rgb(20,255,255,119,136,153)

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
rowno=5


@rowno,10 say '**** IMPORTING ITEM MASTER/COMPANY/HSNCODE MASTER****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\master1.dbf alias fpcm
index on str(mastertype,9)+str(code,9) to fpcm
sele sele (1)
sele * from fpcm where mastertype=6 into curs fitm
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
	repl code with fitm.code
	repl name with fitm.alias
	repl product with fitm.name
	repl packing with ''
	repl billname with fitm.name
	repl rackno with ''
	***Unit Master Update***
	do case
		case fitm.i9=1
			=seek(str(8,9)+str(fitm.cm2,9),'fpcm')
			repl unit with fpcm.name
			=seek(str(8,9)+str(fitm.cm1,9),'fpcm')
			repl unit2 with fpcm.name
		otherwise
			=seek(fitm.cm2,'fpcm')
			repl unit2 with fpcm.name
			=seek(fitm.cm1,'fpcm')
			repl unit with fpcm.name
	endcase
	replace pack with iif(fitm.d1#0,iif(int(fitm.d1)#0,fitm.d1,1/fitm.d1),0)
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.prate with fitm.d4
	repl mitm.lprate with fitm.d4
	repl mitm.ratea with fitm.d3
	repl mitm.mrp with fitm.d2
	***Tax Master Updated***
	=seek(str(25,9)+str(fitm.cm8,9),'fpcm')
	if at('%',fpcm.name)<=2
		taxrate=val(substr(fpcm.name,rat('%',fpcm.name)-1,2))
	else
		taxrate=val(substr(fpcm.name,rat('%',fpcm.name)-2,2))
	endif
	repl saltax with taxrate/2
	repl cgst   with taxrate/2
	repl igst   with taxrate
	***Hsncode Master Update***
	hsncode=chrtran(fitm.hsncode,chr(0),'')
	sele mpcm
	seek 'COMMCD' + substr(hsncode+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with hsncode,;
			mpcm.parnam with hsncode,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
	***Company Master Update***
	=seek(str(5,9)+str(fitm.parentgrp,9),'fpcm')
	sele mpcm
	seek 'ZZZZZZ' + substr(fpcm.name+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with fpcm.name,;
			mpcm.parnam with fpcm.name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
endscan
close table all
@rowno,10 say '**** IMPORTING AREA MASTER****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\master1.&datatransferext alias fpcm
index on code to fpcm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
scan for mastertype=251
	sele mpcm
	appen blank
	repl sgcode with 'AREA',;
		 sname with fpcm.name,;
		 parnam with fpcm.name,;
		 scode with alltri(str(fpcm.code))
endscan
close table all

*!*	if inlist(old_4,'M','F')
*!*		@rowno,10 say '**** IMPORTING OPENING BATCH MASTER****' font 'Arial',10
*!*		rowno=rowno+1
*!*		sele sele (1)
*!*		use &datatransferpath\Folio1.&datatransferext alias fsbal_1
*!*		index on mastercode to fsbal_1
*!*		sele sele (1)
*!*		use &datatransferpath\tran3.&datatransferext alias fsbal
*!*		set filt to rectype=2 and vchtype=1
*!*		index on mastercode to fsbal
*!*		sele sele (1)
*!*		use &datatransferpath\master1.&datatransferext alias fitm
*!*		index on str(mastertype,9)+str(code,9) to fitm
*!*		sele sele(1)
*!*		use &datdev\pro.&datext alias mitm
*!*		index on str(code,9) to mitm
*!*		sele sele(1)
*!*		use &datdev\probat.&datext alias msbal
*!*		index on str(code,9)+batchno to msbal
*!*		sele fsbal
*!*		go top
*!*		scan
*!*		itemcode=mastercode
*!*		IF seek(str(6,9)+str(fsbal_1.mastercode,9),'fitm')
*!*			sele fsbal
*!*			seek fsbal_1.mastercode
*!*			if found()
*!*			scan while mastercode=fsbal_1.mastercode		
*!*				sele mitm
*!*				seek str(itemcode,9)
*!*				sele msbal
*!*				seek str(mitm.code,9)+substr(alltri(fsbal.no)+space(12),1,12)
*!*				if !found()
*!*					append blank
*!*					repl msbal.code with mitm.code
*!*					repl msbal.name with mitm.name
*!*					repl msbal.billname with mitm.billname
*!*					repl msbal.product with mitm.product
*!*					repl msbal.pack with mitm.pack
*!*					repl msbal.unit2 with mitm.unit2
*!*					repl msbal.unit with mitm.unit
*!*					repl msbal.decimal with 'Y'
*!*	*!*					if fsbal.status=1
*!*						repl msbal.opening with fsbal.value2
*!*						repl msbal.balance with fsbal.value2
*!*						repl msbal.o_a with 	fsbal.value2
*!*						repl msbal.b_a with fsbal.value2
*!*	*!*					else
*!*	*!*						repl msbal.opening with fsbal.value1*iif(mitm.pack#0,mitm.pack,1)
*!*	*!*						repl msbal.balance with fsbal.value1*iif(mitm.pack#0,mitm.pack,1)
*!*	*!*						repl msbal.o_a with 	fsbal.value1*iif(mitm.pack#0,mitm.pack,1)
*!*	*!*						repl msbal.b_a with fsbal.value1*iif(mitm.pack#0,mitm.pack,1)
*!*	*!*					endif
*!*					repl msbal.batchno with alltri(fsbal.no)
*!*					repl msbal.exp with fsbal.duedate
*!*					repl msbal.mfd with fsbal.mfgdate
*!*					repl msbal.mrp with fsbal.balance3
*!*					repl msbal.prate with fsbal.balance1
*!*					repl msbal.ratea with fsbal.balance2
*!*					replace msbal.ratea with mitm.ratea
*!*					repl msbal.rateb with mitm.rateb
*!*					replace msbal.lprate with mitm.lprate
*!*					repl msbal.misc1 with mitm.gcode
*!*					repl msbal.supcode with ''
*!*					repl msbal.supinvo with ''
*!*					repl msbal.supdat with ctod('')
*!*				else
*!*	*!*					if fsbal.status=1
*!*	*!*						repl msbal.opening with opening+(fsbal.value2*iif(mitm.pack#0,mitm.pack,1))
*!*	*!*						repl msbal.balance with balance+(fsbal.value2*iif(mitm.pack#0,mitm.pack,1))
*!*	*!*						repl msbal.o_a with 	o_a+(fsbal.value2*iif(mitm.pack#0,mitm.pack,1))
*!*	*!*						repl msbal.b_a with b_a+(fsbal.value2*iif(mitm.pack#0,mitm.pack,1))
*!*	*!*					else
*!*						repl msbal.opening with opening+fsbal.value1
*!*						repl msbal.balance with balance+fsbal.value1
*!*						repl msbal.o_a with 	o_a+fsbal.value1
*!*						repl msbal.b_a with b_a+fsbal.value1
*!*	*!*					endif
*!*				endif
*!*			endsca
*!*			else
*!*				=seek(str(6,9)+str(fsbal_1.mastercode,9),'fitm')
*!*				sele mitm
*!*				seek str(itemcode,9)
*!*				sele msbal
*!*				append blank
*!*				repl msbal.code with mitm.code
*!*				repl msbal.name with mitm.name
*!*				repl msbal.billname with mitm.billname
*!*				repl msbal.product with mitm.product
*!*				repl msbal.pack with mitm.pack
*!*				repl msbal.unit2 with mitm.unit2
*!*				repl msbal.unit with mitm.unit
*!*				repl msbal.decimal with 'Y'
*!*				repl msbal.opening with fsbal_1.d1
*!*				repl msbal.balance with fsbal_1.d1
*!*				repl msbal.o_a with 	fsbal_1.d1
*!*				repl msbal.b_a with fsbal_1.d1
*!*			endif
*!*		ENDIF
*!*		endsc
*!*		close table all
*!*	endif
	@rowno,10 say '**** IMPORTING INWARD BATCH MASTER ****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datatransferpath\tran3.&datatransferext alias fsbal
	set filt to rectype=2
	sele sele (1)
	use &datatransferpath\master1.&datatransferext alias fitm
	index on str(mastertype,9)+str(code,9) to fitm
	sele sele(1)
	use &datdev\pro.&datext alias mitm
	index on str(code,9) to mitm
	sele sele(1)
	use &datdev\probat.&datext alias msbal
	index on str(code,9)+batchno to msbal
	sele fsbal
	go top
	scan
		=seek(str(6,9)+str(fsbal.mastercode,9),'fitm')
		sele mitm
		seek str(fsbal.mastercode,9)
		sele msbal
		seek str(mitm.code,9)+substr(alltri(fsbal.no)+space(12),1,12)
		if !found()
			append blank
			repl msbal.code with mitm.code
			repl msbal.name with mitm.name
			repl msbal.billname with mitm.billname
			repl msbal.product with mitm.product
			repl msbal.pack with mitm.pack
			repl msbal.unit2 with mitm.unit2
			repl msbal.unit with mitm.unit
			repl msbal.decimal with 'Y'
			if old_4='M'
				repl msbal.opening with fsbal.value1&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
				repl msbal.balance with fsbal.value1&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
				repl msbal.o_a with fsbal.value1&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
				repl msbal.b_a with fsbal.value1&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
			else
				repl msbal.opening with iif(fsbal.vchcode=0,fsbal.value2,0)&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
				repl msbal.balance with iif(fsbal.vchcode=0,fsbal.value2,0)
				repl msbal.o_a with iif(fsbal.vchcode=0,fsbal.value2,0)
				repl msbal.b_a with iif(fsbal.vchcode=0,fsbal.value2,0)
			endif
			repl msbal.batchno with alltri(fsbal.no)
			repl msbal.exp with fsbal.duedate
			repl msbal.mfd with fsbal.mfgdate
			repl msbal.mrp with fsbal.balance3
			repl msbal.ratea with fsbal.balance2
			repl msbal.prate with fsbal.balance1
			repl msbal.rateb with mitm.rateb
			replace msbal.lprate with fsbal.balance1
			repl msbal.misc1 with mitm.gcode
			repl msbal.supcode with ''
			repl msbal.supinvo with ''
			repl msbal.supdat with ctod('')
		else
			if old_4='M'
				repl msbal.opening with opening+fsbal.value1&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
				repl msbal.balance with balance+fsbal.value1&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
				repl msbal.o_a with o_a+fsbal.value1&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
				repl msbal.b_a with b_a+fsbal.value1&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
			else
				repl msbal.opening with opening+iif(fsbal.vchcode=0,fsbal.value2,0)&&iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
				repl msbal.balance with balance+iif(fsbal.vchcode=0,fsbal.value2,0)
				repl msbal.o_a with o_a+iif(fsbal.vchcode=0,fsbal.value2,0)
				repl msbal.b_a with b_a+iif(fsbal.vchcode=0,fsbal.value2,0)
			endif
		endif
	endsc
	close table all
*if old_4='M'

*!*	if old_4='M'
*!*		@rowno,10 say '**** IIMPORTING OUTWARD BATCH MASTER ****' font 'Arial',10
*!*		rowno=rowno+1
*!*		sele sele (1)
*!*		use &datatransferpath\tran3.&datatransferext alias fsbal
*!*		set filt to rectype=2
*!*		sele sele (1)
*!*		use &datatransferpath\master1.&datatransferext alias fitm
*!*		index on str(mastertype,9)+str(code,9) to fitm
*!*		sele sele(1)
*!*		use &datdev\pro.&datext alias mitm
*!*		index on str(code,9) to mitm
*!*		sele sele(1)
*!*		use &datdev\probat.&datext alias msbal
*!*		index on str(code,9)+batchno to msbal
*!*		sele fsbal
*!*		go top
*!*		scan for inlist(vchtype,9,10) &&&AND  mastercode=1894
*!*			=seek(str(6,9)+str(fsbal.mastercode,9),'fitm')
*!*			sele mitm
*!*			seek str(fsbal.mastercode,9)
*!*			sele msbal
*!*			seek str(mitm.code,9)+substr(alltri(fsbal.no)+space(12),1,12)
*!*			if !found()
*!*				append blank
*!*				repl msbal.code with mitm.code
*!*				repl msbal.name with mitm.name
*!*				repl msbal.billname with mitm.billname
*!*				repl msbal.product with mitm.product
*!*				repl msbal.pack with mitm.pack
*!*				repl msbal.unit2 with mitm.unit2
*!*				repl msbal.unit with mitm.unit
*!*				repl msbal.decimal with 'Y'
*!*				repl msbal.opening with -iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
*!*				repl msbal.balance with -iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
*!*				repl msbal.o_a with -iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
*!*				repl msbal.b_a with -iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
*!*				repl msbal.batchno with alltri(fsbal.no)
*!*				repl msbal.exp with fsbal.duedate
*!*				repl msbal.mfd with fsbal.mfgdate
*!*				repl msbal.mrp with fsbal.balance3
*!*				replace msbal.ratea with mitm.ratea
*!*				repl msbal.rateb with mitm.rateb
*!*				replace msbal.lprate with mitm.lprate
*!*				repl msbal.misc1 with mitm.gcode
*!*				repl msbal.supcode with ''
*!*				repl msbal.supinvo with ''
*!*				repl msbal.supdat with ctod('')
*!*			else
*!*				repl msbal.opening with msbal.opening -iif(fitm.d1<0,abs(fsbal.value1),abs(fsbal.value2))
*!*				repl msbal.balance with msbal.balance -iif(fitm.d1<0,abs(fsbal.value1),abs(fsbal.value2))
*!*				repl msbal.o_a with msbal.o_a -iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
*!*				repl msbal.b_a with msbal.b_a -iif(fitm.d1<1,abs(fsbal.value1),abs(fsbal.value2))
*!*			endif
*!*		endsc
*!*		close table all
*!*	endif

@rowno,10 say '**** IMPORTING ACCOUNT MASTER****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\master1 alias masters
sele sele (1)
sele * from masters where inlist(mastertype,2,19) into curs fact
sele sele(1)
use &datatransferpath\folio1 alias fopn
index on mastercode to fopn for mastertype=2
sele sele (1)
sele * from masters where mastertype=1 and between(code,101,129)  into curs facgrp readwr
index on code to facgrp
sele sele (1)
sele * from masters where mastertype=1 and !between(code,101,129)  into curs subgrp readwr
index on code to subgrp
sele sele(1)
use &datatransferpath\masteraddressinfo alias fdet
index on mastercode to fdet
sele sele(1)
use &datdev\order.&datext alias mact
zap
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	f_openingbalance=0
	if seek(fact.code,'fopn')
		f_openingbalance=iif(fopn.d1<0,abs(fopn.d1),-fopn.d1)
	endif
	=seek(fact.code,'fdet')
	sele mact
	appen blank
	repl mact.rate with IIF(OLD_4='M','Y','N')
	repl mact.ordno with alltri(str(fact.code))
	repl mact.fax2 with fact.alias
	repl mact.parnam  with fact.name
	repl mact.mailnam with fact.printname
	repl mact.paradd with alltri(fdet.address1)
	repl mact.paradd1 with alltri(fdet.address2)
	repl mact.paradd2 with alltri(fdet.address3)+' '+alltri(fdet.address4)
	repl mact.city with fdet.station
	repl mact.dsm with fdet.pincode
	repl mact.itno with fdet.itpan
	repl mact.dlno with alltri(fdet.dlno)+' '+alltri(fdet.dlno)
	repl gstno with fdet.gstno
	repl cstno with fdet.cst
	repl stno with fdet.lst
	repl phone1 with chrtran(fdet.mobile,chr(0),'')
	repl phone2 with chrtran(fdet.telno,chr(0),'')
	repl phone4 with chrtran(fdet.mobile,chr(0),'')
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.opning with f_openingbalance
	repl mr with alltri(str(fact.cm3))
	repl area with chrtran(fdet.of1,chr(0),'')
	if seek(fact.parentgrp,'subgrp')
		do case
			case subgrp.parentgrp=116
				mscode='C6'
			case subgrp.parentgrp=117
				mscode='D31'
			case subgrp.parentgrp=115
				mscode='C2'
			case subgrp.parentgrp=112
				mscode='C1'
			case subgrp.parentgrp=128
				mscode='C1'
			case subgrp.parentgrp=127
				mscode='J11'
			case subgrp.parentgrp=125
				mscode='J12'
			otherwise
				mscode='J12'
		endcase
	else
		if seek(fact.parentgrp,'facgrp')
			do case
				case facgrp.code=116
					mscode='C6'
				case facgrp.code=117
					mscode='D31'
				case facgrp.code=115
					mscode='C2'
				case facgrp.code=112
					mscode='C1'
				case facgrp.code=128
					mscode='C1'
				case facgrp.code=127
					mscode='J11'
				case facgrp.code=125
					mscode='J12'
				otherwise
					mscode='J12'
			endcase
		endif
	endif
	sele mact
	repl mact.scode with mscode
	if fact.mastertype=19
		repl mact.scode with 'D32'
	endif


	*!*	update mact set fopning=sum(bal.cr)-sum(bal.dr) from bal group by acid having
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

@rowno,10 say '**** IMPORTING OTHER LEDGER ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alia mact
sele sele(1)
use &datatransferpath\master1 alias fact
scan for mastertype=9
	sele mact
	appen blan
	repl mact.ordno with alltri(str(fact.code))
	repl mact.fax2 with alltri(str(fact.code))
	repl mact.parnam  with fact.name
	repl mact.mailnam with fact.printname
	repl scode with 'J12'
endsc
clos tabl all
if old_4='M'
		@rowno,10 say '**** Importing Bill Wise Os  ****' font 'Arial',10
		rowno=rowno+1
		sele sele(1)
		use &datdev\pendings.&datext alias mpend
		sele sele(1)
		use &datdev\order.&datext alias mord
		inde on ordno to mord
		sele sele(1)
		use &datdev\slipno.&datext alias mslip
		sele sele(1)
		use &datatransferpath\tran3 alias fout
		sele sele(1)
		select * from fout where inlist(vchtype,9,2,14,19,16,15) and method=2 into curs frec readwr
		index on str(mastercode,9)+str(refcode,9) to frec
		sele mslip
		go top
		vou =voucher  + 10
		svou=svoucher + 10
		sele fout
		set filter to inlist(vchtype,2,3,9,10,11) and method=1 &&2,3 for purchase,sale ret and 9,10,11 for sale and purret
		go top
		scan
			sele frec
			seek str(fout.mastercode,9)+str(fout.refcode,9)
			sum abs(value1) to PyRe while str(mastercode,9)+str(refcode,9)=str(fout.mastercode,9)+str(fout.refcode,9)
			mvcn=alltr(fout.no)
			xfinal=abs(fout.value1)
			xbal=abs(fout.value1)-Pyre
			sele mord
			seek substr(alltri(str(fout.mastercode))+space(6),1,6)
			sele mpend
			appen blan
			repl acgroup with mord->scode
			repl ord with mord.ordno
			repl ddate with fout.date
			repl vcn with mvcn
			repl invtype with 'O'
			repl voucher  with vou
			repl svoucher with svou
			repl mr with alltri(str(fout.brokercode))
				if inlist(fout.vchtype,9,10,11)
					repl final with abs(fout.value1)
					repl itemope with PyRe
					repl balance with xbal
				else
					repl final with -abs(fout.value1)
					repl itemope with -PyRe
					repl balance with -xbal
				endif
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
endif

if old_4='F'
	do busyfullmigration
endif

proc busyfullmigration
	@rowno,10 say '**** IMPORTING INWARD TRANSACTIONS****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datdev\support.&datext alias support
	index on type+aliase to support
	seek 'F' + 'BATCHPRT'
	if !found()
		append blank
		repl type with 'F',;
			aliase with 'BATCHPRT'
	endif
	repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
	sele sele(1)
	use &datdev\pro.&datext alias pro
	index on str(code,9) to pro
	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on ordno to ord
	sele sele(1)
	use &datdev\dis.&datext alias dis
	sele sele(1)
	use &datdev\mdis.&datext alias mdis
	sele sele(1)
	use &datdev\probat.&datext alias prb
	index on str(code,9)+batchno to prb
	sele sele(1)
	use &datdev\subdis.&datext alias msub
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20

	if mtrade='P'
		sele sele(1)
		use &datatransferpath\tran3 alia fsbal
		set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
		index on str(vchcode,9)+str(mastercode,9)+str(itemsrno,9) to fsbal
	endif

	sele sele(1)
	use &datatransferpath\tran1 alia pur
	set filte to inlist(vchtype,2,3) and between(date,firstdate,lastdate)

	sele sele(1)
	use &datatransferpath\VchGSTSumItemWise alia trantax
	set filte to  between(vchdate,firstdate,lastdate)
	index on str(vchcode,9)+str(itemcode,9) to trantax

	sele sele(1)
	use &datatransferpath\tran2 alia pld
	set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
	index on vchcode to pld
	sele sele(1)
	use &datatransferpath\master1 alia ptax
	set filte to mastertype=14
	index on code to ptax
	sele sele(1)
	use &datatransferpath\itemdesc alias pfqty
	index on str(vchcode,9)+str(srno,9) to pfqty
	sele sele(1)
	sele * from pld into curs pdisc where rectype=3
	inde on vchcode to pdisc
	i=1
	sele pur
	go top
	scan 
		bdt=date
		edt=date
		l2='P-'+padl(i,6,'0')
		l3=alltri(vchno)
		i=i+1
		=seek(substr(alltri(str(mastercode))+space(6),1,6),'ord')
		=seek(pur.cm1,'ptax')
		sele mdis
		appen blan
		if pur.vchtype=2
			repl type with 'P'
			repl vcn with l2
			repl pm with l3
			repl date with bdt
			repl lrda with edt
		else
			repl type with 'R'
			repl vcn with l2
			repl pm with l3
			repl date with bdt
			repl lrda with edt
		endif
		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
		repl codep with ord.ordno
		do case
			case pur.vchtype=2
				repl ltype with iif('TAXINCL'$upper(ptax.name),'9','2')
			case pur.vchtype=3
				repl ltype with '9'&&&&&iif('TAXINCL'$upper(ptax.name),'9','2')
		endcase
		repl voucher with last4
		last4=last4+5
		repl rout with ' '
		repl area with ' '
		repl addis with 0
		repl sale with 'z'&&&'Z'
		repl account with 'N'
		repl godwon with 'A'
		repl discafter with 'M'
		repl othun with 'STAC23'
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
			isigst=1
		endi
		repl amountp with pur.vchamtbase
		repl final with pur.vchamtbase
		store 0 to billdiscountamount,billaddless,taxfound,taxper
		sele pdisc
		seek pur.vchcode
		if found()
			scan for seek(subs(alltr(str(pdisc.mastercode))+spac(6),1,6),'ord') while pdisc.vchcode=pur.vchcode
				if 'CGST'$ord.parnam
					taxfound=1
					taxper=pdisc.value1
					loop
				endif
				if 'SGST'$ord.parnam
					taxfound=1
					taxper=pdisc.value1
					loop
				endif
				if 'IGST'$ord.parnam
					taxfound=1
					taxper=pdisc.value1
					loop
				endif
				if 'DISCOUNT'$upper(ord.parnam)
					if disaftertaxp='N'
						billdiscountamount=billdiscountamount+pdisc.value3
						loop
					else
						billdiscountamount=billdiscountamount+pdisc.value3
					endif
				else
					billaddless=billaddless+pdisc.value3			
				endif
				if mdis.other=0
					repl mdis.othun with alltri(str(pdisc.mastercode))
					repl mdis.other with iif(mdis.type='P'and disaftertaxp='Y',-billdiscountamount,billaddless)
				else
					if mdis.packing=0
						repl mdis.pacun with alltri(str(pdisc.mastercode))
						repl mdis.packing with iif(mdis.type='P'and disaftertaxp='Y',-billdiscountamount,billaddless)
					else
						repl mdis.freun with alltri(str(pdisc.mastercode))
						repl mdis.freight with iif(mdis.type='P'and disaftertaxp='Y',-billdiscountamount,billaddless)
					endi
				endi
			endsc
		endif
		sele mdis
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		if disaftertaxp='N'
			repl misc3 with substr(misc3,1,54)+str(billdiscountamount,10,2)+substr(misc3,65,100)
		endif
		store  0 to bdisc
		store 0 to itdisc
		store 0 to idiscamt
		store 0 to idiscamt1

		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

		sele pld
		seek pur.vchcode
		scan whil vchcode=pur.vchcode
			=seek(str(pld.vchcode,9)+str(pld.mastercode,9),'Trantax')
			locqty=abs(pld.value1)
			locbatch=''
			locexp=ctod('')
			locmfg=ctod('')
			locpurcfree=0
			sele pfqty
			seek str(pld.vchcode,9)+str(pld.srno,9)
			if found()
				locpurcfree=iif(!empty(pfqty.d3),abs(pfqty.d3),abs(pfqty.d1))
			endif
			=seek(str(pld.mastercode,9),'pro')
			store 0 to batchfound
			sele fsbal
			seek str(pld.vchcode,9)+str(pld.mastercode,9)+str(pld.srno,9)
			scan while str(vchcode,9)+str(mastercode,9)+str(itemsrno,9)=str(pld.vchcode,9)+str(pld.mastercode,9)+str(pld.srno,9)
					batchfound=1
					sele prb
					seek str(pro.code,9)+substr(alltri(fsbal.no)+space(12),1,12)
					locbatch=alltri(fsbal.no)
					locexp=fsbal.duedate
					locmfg=fsbal.mfgdate
					sele dis
					appen blan
					repl codep with mdis->codep
					repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
					repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
					repl voucher with mdis->voucher
					repl code with pro.code
					repl batch with locbatch
					repl exp with locexp
					repl mfd with locmfg
					repl prb.rateb with pld.d4
					repl pack with pro.pack
					if int(pld.d8)=0
						repl pack with pro.pack
						repl qty with iif(locqty#0,abs(fsbal.value2)-(locpurcfree),1)
						repl rate with iif(!empty(pld.d9),pld.d4,pld.d2)*iif(pro.pack#0,pro.pack,1)
					else
						repl pack with PRO.pack
						repl qty with iif(locqty#0,abs(fsbal.value2)-(locpurcfree),1)
						repl rate with iif(!empty(pld.d9),pld.d4,pld.d2)
						repl free with (locpurcfree)
					endif
					repl nera with iif(pld.d4#0,'List Price : '+alltr(str(pld.d4,10,2)),'')
					repl rate with  iif(!empty(pld.d9),pld.d4,pld.d2)
					if isnull(pld.c1)
						repl disc1 with pld.d9
					else
						idisc=getwordnum(pld.c1,1,'+')
						idisc2=getwordnum(pld.c1,2,'+')
						repl disc1 with val(idisc)
						repl disc2 with val(idisc2)
						repl rate with pld.d4
					endif
					repl mrp with  pld.d18
					repl flg with iif(mdis.type='S','G',mdis.type)
					repl tax with 'T'
					if isigst=1
						repl ssta with iif(inlist(trantax.taxrate,5,12,18,28),trantax.taxrate,trantax.taxrate*2)
					else
						repl ssta with iif(inlist(trantax.taxrate,5,12,18,28),trantax.taxrate/2,trantax.taxrate)
						repl cgst with iif(inlist(trantax.taxrate,5,12,18,28),trantax.taxrate/2,trantax.taxrate)
					endi
					repl half with 'A'
					repl godwon with mdis->godwon
					mqt=iif(locqty#0,abs(fsbal.value2)-(locpurcfree),1)
					mrt=iif(!empty(pld.d9),pld.d4,pld.d2)
					idiscamt=idiscamt+(((dis.qty*dis.rate)*dis.disc1)/100)
    	   endscan
			if batchfound=0
				sele dis
				appen blan
				repl codep with mdis->codep
				repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
				repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
				repl voucher with mdis->voucher
				repl code with pro.code
				sele dis
				repl batch with ''
				repl exp with ctod('')
				repl mfd with ctod('')
				repl prb.rateb with pld.d4
				repl pack with pro.pack
				if int(pld.d8)=0
					repl pack with pro.pack
					repl qty with abs(pld.value2)-(locpurcfree)
					repl rate with iif(!empty(pld.d9),pld.d4,pld.d2)*iif(pro.pack#0,pro.pack,1)
				else
					repl pack with pro.pack
					repl qty with abs(pld.value2)-(locpurcfree)
					repl rate with iif(!empty(pld.d9),pld.d4,pld.d2)
				endif
				repl free with (locpurcfree*iif(pro.pack#0,pro.pack,1))
				repl nera with iif(pld.d4#0,'List Price : '+alltr(str(pld.d4,10,2)),'')
				repl rate with  iif(!empty(pld.d9),pld.d4,pld.d2)
				if isnull(pld.c1)
					repl disc1 with pld.d9
				else
					idisc=getwordnum(pld.c1,1,'+')
					idisc2=getwordnum(pld.c1,2,'+')
					repl disc1 with val(idisc)
					repl disc2 with val(idisc2)
					repl rate with pld.d4
				endif
				idiscamt=idiscamt+(((dis.qty*dis.rate)*dis.disc1)/100)
				repl mrp with  pld.d18
				repl flg with iif(mdis.type='S','G',mdis.type)
				repl tax with 'T'
				if isigst=1
					repl ssta with iif(inlist(trantax.taxrate,5,12,18,28),trantax.taxrate,trantax.taxrate*2)
				else
					repl ssta with iif(inlist(trantax.taxrate,5,12,18,28),trantax.taxrate/2,trantax.taxrate)
					repl cgst with iif(inlist(trantax.taxrate,5,12,18,28),trantax.taxrate/2,trantax.taxrate)
				endi
				repl half with 'A'
				repl godwon with mdis->godwon
			endif
		endsc
		if disaftertax='N'
			sele mdis
			*repl misc3 with substr(misc3,1,54)+str(billdiscountamount+bdisc+idiscamt,10,2)+substr(misc3,65,100)
		endif
	endsc
	sele sele(1)
	sele mslip
	go top
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all


	@rowno,10 say '**** Transfer Payment Against Purchase Bill****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datdev\gledger.&datext alias gle
	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on ordno to ord
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20
	sele sele(1)
	use &datatransferpath\tran1.&datatransferext alias ltran1
	set filte to inlist(vchtype,2) and between(date,firstdate,lastdate)
	sele sele(1)
	use &datatransferpath\tran2.&datatransferext alias ltran2
	set filte to inlist(vchtype,2) and between(date,firstdate,lastdate) &&and rectype=1 and b1=.t.
	index on vchcode to ltran2
	sele ltran1
	scan
		lvoucherdate=date
		lvouchernumber=alltri(ltran2.vchno)
		sele ltran2
		seek ltran1.vchcode
		scan for rectype=1 and b1=.t. while vchcode=ltran1.vchcode
			=seek(substr(alltri(str(ltran2.mastercode))+space(6),1,6),'ord')
			if found()
				sele gle
				appen blank
				repl voucher with last4
				repl vcsno with lvouchernumber
				repl code with ord.ordno
				repl date with lvoucherdate
				if ltran2.value1>0
					repl cd with 'C'
					repl credit with abs(ltran2.value1)
				else
					repl cd with 'D'
					repl debit with abs(ltran2.value1)
				endi
				repl remark1 with ltran2.shortnar
				do case
					case inlist(ltran1.vchtype,2)
						repl book with 'P'
				endcase
			endif
		endscan
		last4=last4+10
	endscan
	sele mslip
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all
	@rowno,10 say '**** Transfer Payment Against Sale Return****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datdev\gledger.&datext alias gle
	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on ordno to ord
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20
	sele sele(1)
	use &datatransferpath\tran1.&datatransferext alias ltran1
	set filte to inlist(vchtype,3) and between(date,firstdate,lastdate)
	sele sele(1)
	use &datatransferpath\tran2.&datatransferext alias ltran2
	set filte to inlist(vchtype,3) and between(date,firstdate,lastdate) &&and rectype=1 and b1=.t.
	index on vchcode to ltran2
	sele ltran1
	scan
		lvoucherdate=date
		lvouchernumber=alltri(ltran2.vchno)
		sele ltran2
		seek ltran1.vchcode
		scan for rectype=1 while vchcode=ltran1.vchcode&&&and b1=.t.
			=seek(substr(alltri(str(ltran2.mastercode))+space(6),1,6),'ord')
			if found()
				sele gle
				appen blank
				repl voucher with last4
				repl vcsno with lvouchernumber
				repl code with ord.ordno
				repl date with lvoucherdate
				if ltran2.value1>0
					repl cd with 'C'
					repl credit with abs(ltran2.value1)
				else
					repl cd with 'D'
					repl debit with abs(ltran2.value1)
				endi
				repl remark1 with ltran2.shortnar
				do case
					case inlist(ltran1.vchtype,2)
						repl book with 'P'
				endcase
			endif
		endscan
		last4=last4+10
	endscan
	sele mslip
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all

	@rowno,10 say '**** IMPORTING OUTWARD TRANSACTIONS****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datdev\support.&datext alias support
	index on type+aliase to support
	seek 'F' + 'BATCHPRT'
	if !found()
		append blank
		repl type with 'F',;
			aliase with 'BATCHPRT'
	endif
	repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
	sele sele(1)
	use &datdev\pro.&datext alias pro
	index on str(code,9) to pro
	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on ordno to ord
	sele sele(1)
	use &datdev\dis.&datext alias dis
	sele sele(1)
	use &datdev\mdis.&datext alias mdis
	sele sele(1)
	use &datdev\probat.&datext alias prb
	index on str(code,9)+batchno to prb
	sele sele(1)
	use &datdev\subdis.&datext alias msub
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20
	if mtrade='P'
		sele sele(1)
		use &datatransferpath\tran3 alia fsbal
		set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
		index on str(vchcode,9)+str(mastercode,9)+str(itemsrno,9) to fsbal
	endif

	sele sele(1)
	use &datatransferpath\tran1 alia sal
	set filte to inlist(vchtype,9,10,11) and between(date,firstdate,lastdate) &&&&&and vchno='                      105'
	sele sele(1)
	use &datatransferpath\tran2 alia sld
	set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
	index on vchcode to sld
	sele sele(1)
	use &datatransferpath\master1 alia stax
	set filte to mastertype=13
	index on code to stax
	sele sele(1)
	use &datatransferpath\itemdesc alia sfqty
	index on str(vchcode,9)+str(srno,9) to sfqty
	sele sele(1)
	sele * from sld into curs sdisc where rectype=3
	inde on vchcode to sdisc
	i=1
	sele sal
	go top
	scan &&&for vchcode=        127
		bdt=date
		l3=alltri(vchno)
		i=i+1
		=seek(substr(alltri(str(mastercode))+space(6),1,6),'ord')
		=seek(sal.cm1,'stax')
		sele mdis
		appen blan
		do case
			case sal.vchtype=9
				repl type with 'S'
				repl vcn with l3
				repl pm with l3
				repl date with bdt
				repl ltype with scalc&&&&iif('TAXINCL'$upper(stax.name),'9','2')
			case sal.vchtype=10
				repl type with 'B'
				repl vcn with iif(empty(l3),alltri(str(recno())),l3)
				repl date with bdt
				repl ltype with pcalc&&&&iif('TAXINCL'$upper(stax.name),'9','2')
			case sal.vchtype=11
				repl type with 'S'
				repl challan with l3
				repl pm with l3
				repl chdate with bdt
				repl ltype with scalc&&&&iif('TAXINCL'$upper(stax.name),'9','2')
		endcase
		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
		repl codep with ord.ordno
		repl voucher with last4
		last4=last4+5
		repl rout with ' '
		repl area with ' '
		repl addis with 0
		repl sale with 'Z'
		repl account with 'N'
		repl godwon with 'A'
		repl discafter with 'M'
		repl othun with 'STAC23'
		&&&f_otheraddless
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and !empty(substr(ord.gstno,1,2))&&&&len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
			isigst=1
		endi
		store 0 to discountbeforetax,discountaftertax,locbilldisc,lbilldiscamt
		sele sdisc
		seek sal.vchcode
		if found()
			scan for seek(subs(alltr(str(sdisc.mastercode))+spac(6),1,6),'ord') while sdisc.vchcode=sal.vchcode
*				if sdisc.mastercode=       1192
					
				if 'CGST'$ord.parnam
					loop
				endif
				if 'SGST'$ord.parnam
					loop
				endif
				if 'IGST'$ord.parnam
					loop
				endif

				if 'DISCOUNT'$upper(ord.parnam)
					if disaftertax='Y'
						discountaftertax=-sdisc.value3&&&&&iif(sdisc.value1#0,0,iif(empty(sdisc.value3),iif(sdisc.value1<0,sdisc.value1,-sdisc.value1),iif(sdisc.value3<0,sdisc.value3,-sdisc.value3)))
					else
					locbilldisc=sdisc.value1
					lbilldiscamt=abs(sdisc.value3)
					discountbeforetax=sdisc.value3

					endif
				endif

				if mdis.other=0
					repl mdis.othun with alltri(str(sdisc.mastercode))
					repl mdis.other with discountaftertax
				else
					if mdis.packing=0
						repl mdis.pacun with ''
						repl mdis.packing with 0
					else
						repl mdis.freun with ''
						repl mdis.freight with  0
					endi
				endi
			endsc
		endif
		sele mdis
		repl amountp with sal.vchamtbase
		repl final with sal.vchamtbase
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		repl misc3 with subs(misc3,1,54)+str(lbilldiscamt,10,2)+subs(misc3,65,100)
		
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele sld
		seek sal.vchcode
		scan while vchcode=sal.vchcode
			store 0 to salebatchfound
			locqty=abs(sld.d1)
			locbatch=''
			locexp=ctod('')
			locmfg=ctod('')
			store 0 to freeqty
			locsalefree=0
			=seek(str(sld.mastercode,9),'pro')
			sele sfqty
			seek str(sld.vchcode,9)+str(sld.srno,9)
			if found()
				freeqty=abs(sfqty.d1)
			endif
			sele fsbal
			seek str(sld.vchcode,9)+str(sld.mastercode,9)+str(sld.srno,9)
			scan while str(vchcode,9)+str(mastercode,9)+str(itemsrno,9)=str(sld.vchcode,9)+str(sld.mastercode,9)+str(sld.srno,9)
				if found()
					salebatchfound=1
					sele prb
					seek str(pro.code,9)+substr(alltri(fsbal.no)+space(12),1,12)
					locbatch=alltri(fsbal.no)
					locexp=fsbal.duedate
					locmfg=fsbal.mfgdate
					sele prb
					seek str(pro.code,9)+substr(alltri(fsbal.no)+space(12),1,12)
					sele dis
					appen blan
					repl codep with mdis->codep
					repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
					repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
					repl voucher with mdis->voucher
					repl code with pro.code
					repl batch with locbatch
					repl exp with locexp
					repl mfd with locmfg
					repl prb.rateb with sld.d4
					if int(sld.d8)=0 or sld.d8=1
						repl pack with pro.pack
						repl qty with iif(locqty#0,(abs(fsbal.value2)-freeqty),1)
						repl rate with iif(!empty(sld.d9),sld.d4,sld.d2)*iif(pro.pack#0,pro.pack,1)
					else
						repl pack with pro.pack
						repl qty with iif(locqty#0,(abs(fsbal.value2))-(freeqty),1)
						repl rate with iif(!empty(sld.d9),sld.d4,sld.d2)*iif(pro.pack#0,pro.pack,1)
					endif
					repl mrp with  sld.d18
					repl nera with iif(sld.d4#0,'List Price : '+alltr(str(sld.d4,10,2)),'')
					repl flg with iif(sld.value1<0,'G','R')&&&iif(mdis.type='S','G',mdis.type)
					repl tax with 'T'
					*repl svdis with sld.d11
					repl free with freeqty
					if isnull(sld.c1)
						repl disc1 with sld.d9
					else
						idisc=getwordnum(sld.c1,1,'+')
						idisc2=getwordnum(sld.c1,2,'+')
						repl disc1 with val(idisc)
						repl disc2 with val(idisc2)
			*			repl rate with iif(!empty(sld.d9),sld.d4,sld.d2)
					endif
					if isigst=1
						if empty(sld.d12)
							if taxfrommaster='Y'
								repl ssta with pro.igst
							endif
						else
							repl ssta with iif(inlist(sld.d12,5,12,18,28),sld.d12,sld.d12*2)
						endif
					else
						if empty(sld.d12)
							if taxfrommaster='Y'
								repl ssta with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d12
								repl cgst with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d33
							endif
						else
							repl ssta with iif(inlist(sld.d12,5,12,18,28),sld.d12/2,sld.d12)
							repl cgst with iif(inlist(sld.d12,5,12,18,28),sld.d12/2,sld.d12)
						endif
					endi
					repl half with 'A'
					repl godwon with mdis->godwon
				endif
			endsc
			if salebatchfound=0
				sele prb
				seek str(pro.code,9)+substr(alltri(fsbal.no)+space(12),1,12)
				locbatch=alltri(fsbal.no)
				locexp=fsbal.duedate
				locmfg=fsbal.mfgdate
				sele prb
				seek str(pro.code,9)+substr(alltri(fsbal.no)+space(12),1,12)
				sele dis
				appen blan
				repl codep with mdis->codep
				repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
				repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
				repl voucher with mdis->voucher
				repl code with pro.code
				repl batch with locbatch
				repl exp with locexp
				repl mfd with locmfg
				repl prb.rateb with sld.d4
				if int(sld.d8)=0
					repl pack with pro.pack
					repl qty with abs(sld.d1)-freeqty
					repl rate with iif(!empty(sld.d9),sld.d4,sld.d2)*iif(pro.pack#0,pro.pack,1)
				else
					repl pack with pro.pack
					repl qty with abs(sld.d1)-freeqty
					repl rate with iif(!empty(sld.d9),sld.d4,sld.d2)*iif(pro.pack#0,pro.pack,1)
				endif
				repl mrp with  sld.d18
				repl nera with iif(sld.d4#0,'List Price : '+alltr(str(sld.d4,10,2)),'')
				repl flg with iif(mdis.type='S','G',mdis.type)
				repl tax with 'T'
				*repl svdis with sld.d11
				repl free with freeqty
				if isnull(sld.c1)
					repl disc1 with sld.d9
				else
					idisc=getwordnum(sld.c1,1,'+')
					idisc2=getwordnum(sld.c1,2,'+')
					repl disc1 with val(idisc)
					repl disc2 with val(idisc2)
					repl rate with iif(!empty(sld.d9),sld.d4,sld.d2)*iif(pro.pack#0,pro.pack,1)
				endif
				if isigst=1
					if empty(sld.d12)
						if taxfrommaster='Y'
							repl ssta with pro.igst
						endif
					else
						repl ssta with iif(inlist(sld.d12,5,12,18,28),sld.d12,sld.d12*2)
					endif
				else
					if empty(sld.d12)
						if taxfrommaster='Y'
							repl ssta with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d12
							repl cgst with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d33
						endif
					else
						repl ssta with iif(inlist(sld.d12,5,12,18,28),sld.d12/2,sld.d12)
						repl cgst with iif(inlist(sld.d12,5,12,18,28),sld.d12/2,sld.d12)
					endif
				endi
				repl half with 'A'
				repl godwon with mdis->godwon
			endif
		endsc
	endsc
	sele sele(1)
	sele mslip
	go top
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all

*!*		@rowno,10 say '**** IMPORT RECEIPT ON SALE BILLS****' font 'Arial',10
*!*		rowno=rowno+1
*!*		sele sele(1)
*!*		use &datdev\gledger.&datext alias gle
*!*		sele sele(1)
*!*		use &datdev\order.&datext alia ord
*!*		inde on ordno to ord
*!*		sele sele(1)
*!*		use &datdev\slipno.&datext alias mslip
*!*		go top
*!*		last4  = voucher + 10
*!*		slast5 = svoucher + 10
*!*		last4 = last4 + 20
*!*		sele sele(1)
*!*		use &datatransferpath\tran1.&datatransferext alias tran
*!*		set filte to inlist(vchtype,9) and between(date,firstdate,lastdate)
*!*		sele sele(1)
*!*		use &datatransferpath\tran2.&datatransferext alias tran1
*!*		set filte to inlist(vchtype,9) and between(date,firstdate,lastdate) and rectype=1 and b1=.t.
*!*		index on vchcode to tran1
*!*		sele tran
*!*		scan
*!*			f_voucherdate=date
*!*			f_vouchernumber=alltri(tran1.vchno)
*!*			sele tran1
*!*			seek tran.vchcode
*!*			if found()
*!*				scan while vchcode=tran.vchcode
*!*					=seek(substr(alltri(str(tran1.mastercode))+space(6),1,6),'ord')
*!*					sele gle
*!*					appen blank
*!*					repl voucher with last4
*!*					repl vcsno with f_vouchernumber
*!*					repl code with ord.ordno
*!*					repl date with f_voucherdate
*!*					if tran1.value1>0
*!*						repl cd with 'C'
*!*						repl credit with abs(tran1.value1)
*!*					else
*!*						repl cd with 'D'
*!*						repl debit with abs(tran1.value1)
*!*					endi
*!*					repl remark1 with tran1.shortnar
*!*					do case
*!*						case inlist(tran.vchtype,9)
*!*							repl book with 'R'
*!*					endcase
*!*				endscan
*!*			endif
*!*			last4=last4+10
*!*		endscan
*!*		sele mslip
*!*		repl voucher with last4+10
*!*		repl svoucher with slast5+10
*!*		clos tabl all
	@rowno,10 say '**** IMPORTING ACCOUNTS FROM INVENTORY****' font 'Arial',10
	rowno=rowno+1
	af     =datdev + '\gledger.'+datext
	pend   =datdev + '\pend.'+datext
	mdis   =datdev + '\mdis.'+datext
	pending=datdev + '\pendings.'+datext
	sele g
	use &pending alias pending
	sele f
	use &pend alias pend excl
	sele b
	use &af alias gledger excl
	sele sele(1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele d
	use &mdis alias mdis
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	msvoucher=svoucher+5
	slast5=msvoucher
	sele d
	go top
	do while .not. eof()
		=seek(mdis.codep,'ord')
		sele d
		if vcn=space(12)
			skip
			loop
		endif
		last1=mdis.codep
		if mdis.final#0
			sele b
			appe blank
			repl voucher with mdis.voucher
			if d.type='P'
				repl cd with 'C'
				repl credit with mdis.final
				repl book with 'A'
			else
				repl cd with 'D'
				repl debit with mdis.final
				repl book with 'S'
			endif
			repl date with mdis.date
			repl code with mdis.codep
			last1=mdis.codep
			repl remark1 with mdis.vcn
			repl type with 'Y'
			if mdis.salun=space(6)
				repl code1 with 'SP#20 '
			else
				repl code1 with mdis.salun
			endif
			repl gcode with ord.scode
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
			appe blank
			repl voucher with mdis.voucher
			if d.type='P'
				repl cd with 'C'
				repl credit with mdis.cash
			else
				repl cd with 'D'
				repl debit with mdis.cash
			endi
			repl date with mdis.date
			repl code with 'STACO3'
			last1='STACO3'
			repl remark1 with mdis.vcn
			repl book with 'S'
			repl type with 'Y'
			if mdis.salun=space(6)
				repl code1 with 'SP#20 '
			else
				repl code1 with mdis.salun
			endif
		endif
		if (mdis.final+mdis.cash)#0
			sele b
			appe blank
			repl voucher with mdis.voucher
			if d.type#'P'
				repl cd with 'C'
				repl credit with (mdis.final+mdis.cash)
			else
				repl cd with 'D'
				repl debit with (mdis.final+mdis.cash)
			endif
			repl date with mdis.date
			if mdis.salun=space(6)
				repl code with 'SP#20 '
			else
				repl code with mdis.salun
			endif
			repl remark1 with mdis.vcn
			repl book with 'S'
			repl type with 'Y'
			repl code1 with last1
		endif
		sele gledger
		sele d
		skip
	enddo
	sele gledger
	sele mslip
	repl svoucher with msvoucher
	clos tabl all

	@rowno,10 say '**** IMPORT OTHER ACCOUNTING ENTRIES****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datdev\gledger.&datext alias gle
	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on ordno to ord
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20
	sele sele(1)
	use &datatransferpath\tran1.&datatransferext alias tran
	set filte to inlist(vchtype,14,19,16,15) and between(date,firstdate,lastdate)
	sele sele(1)
	use &datatransferpath\tran2.&datatransferext alias tran1
	set filte to inlist(vchtype,14,19,16,15) and between(date,firstdate,lastdate)
	index on vchcode to tran1
	sele tran
	scan
		f_voucherdate=date
		f_vouchernumber=alltri(tran.vchno)
		sele tran1
		seek tran.vchcode
		scan while vchcode=tran.vchcode
			=seek(substr(alltri(str(tran1.mastercode))+space(6),1,6),'ord')
			sele gle
			appen blank
			repl voucher with last4
			repl vcsno with f_vouchernumber
			repl code with ord.ordno
			repl date with f_voucherdate
			if tran1.value1>0
				repl cd with 'C'
				repl credit with abs(tran1.value1)
			else
				repl cd with 'D'
				repl debit with abs(tran1.value1)
			endi
			repl remark1 with tran1.shortnar
			do case
				case inlist(tran.vchtype,14)
					repl book with 'R'
				case inlist(tran.vchtype,19)
					repl book with 'P'
				case inlist(tran.vchtype,16)
					repl book with 'J'
				case inlist(tran.vchtype,15)
					repl book with 'C'
				otherwise
					repl book with 'J'
			endcase
		endscan
		last4=last4+10
	endscan
	sele mslip
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all
endproc


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
