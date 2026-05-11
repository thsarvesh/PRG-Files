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
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Sep\Serial_data\data\'+space(50),1,50) &&rpos_path
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
scalc='2'
pcalc='2'
old_12 = 'GST '
serviceitem='Yes'
mstatecode='08'
removenull = 'NO'
@4,7  say '                              Busy To Marg Transfer Process{SERIAL NUMBER WISE BILLING} '+space(30) font 'Arial bold',14 color rgb(20,255,255,119,136,153)
@6,7  say 'Busy Data Path          :' font 'Courier New',12  get datatransferpath font 'Courier New',12
@7,7  say 'Busy Extension          :' font 'Courier New',12  get datatransferext font 'Courier New',12
@8,7  say 'WITH O/S                :' font 'Courier New',12  get old_3 pict '@m YES,NO ' font 'Courier New',12
@9,7  say 'MIGRATION TYPE          :' font 'Courier New',12  get old_4 pict '@m Master Migration,Full Migration '  font 'Courier New',12
@10,7 say 'F.Y.BEGIN FROM          :' font 'Courier New',12  get old_5 font 'Courier New',12
@11,7 say 'F.Y.UP TO               :' font 'Courier New',12  get old_9  font 'Courier New',12
@12,7 say 'GST/VAT                 :' font 'Courier New',12  get old_12 pict '@m GST ,VAT ' font 'Courier New',12
@13,7 say 'SALE CALCULATION        :' font 'Courier New',12  get scalc  font 'Courier New',12
@14,7 say 'PURCHASE CALCULATION    :' font 'Courier New',12  get pcalc font 'Courier New',12
@15,7 say 'State GST Code          :' font 'Courier New',12  get mstatecode  font 'Courier New',12
@16,7 say '####ITEM                :' font 'Courier New',12  get serviceitem pict '@m No ,Yes' font 'Courier New',12
@17,7 say 'Removenull              :' font 'Courier New',12  get removenull pict '@m No ,Yes' font 'Courier New',12
@18,7 say 'Type SURE               :' font 'Courier New',12  get sure pict '@x!' font 'Courier New',12
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
use &datdev\malter.&datext
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
@3,7  say '                              Please Wait..Importing Busy Serial Number Wise Data To Marg..... '+space(30) font 'Arial bold',14 color rgb(20,255,255,119,136,153)
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
@rowno,10 say '**** Importing Product/Company/Hsncode****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\master1.dbf alias masters
sele sele (1)
sele * from masters where mastertype=6 into curs fitm
sele sele (1)
sele * from masters where mastertype=5 into curs lcomp
index on code to lcomp
sele sele (1)
use &datatransferpath\tran4.dbf alias lop
index on mastercode to lop
sele sele (1)
sele * from masters where mastertype=25 into curs ltax
index on code to ltax
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
	=seek(fitm.parentgrp,'lcomp')
	=seek(fitm.cm8,'ltax')
	sele mitm
	appen blank
	repl code with fitm.code
	repl name with alltrim(str(fitm.code))
	repl product with fitm.name
	repl packing with ''
	repl billname with fitm.name
	repl pack with 0
	repl rackno with fitm.alias
	repl unit with 'PCS'
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
	repl mitm.fixdis with fitm.d16
	if at('%',ltax.name)<=2
		ltaxrate=val(substr(ltax.name,rat('%',ltax.name)-1,2))
	else
		ltaxrate=val(substr(ltax.name,rat('%',ltax.name)-2,2))
	endif
	repl saltax with ltaxrate/2
	repl cgst   with ltaxrate/2
	repl igst   with ltaxrate
&&& HSN and Tax Mast
	lhsncode=chrtran(fitm.hsncode,chr(0),'')
	sele mpcm
	seek 'COMMCD' + substr(lhsncode+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with lhsncode,;
			mpcm.parnam with lhsncode,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
&&& COMPANY
	sele mpcm
	seek 'ZZZZZZ' + substr(lcomp.name+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with lcomp.name,;
			mpcm.parnam with lcomp.name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Serial Opening  ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\itemserialno.&datatransferext alias lser
index on str(itemcode,9) to lser
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+substr(mycode,1,20) to msbal
sele lser
go top
scan &&&&for inlist(vchtype,1,2,3)
	sele mitm
	seek str(lser.itemcode,9)
	sele msbal
	seek str(lser.itemcode,9)+substr(alltri(lser.serialno)+space(20),1,20)
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
		repl mycode with substr(alltri(lser.serialno)+space(20),1,20)
*!*			if lser.vchcode=0 and lser.vchtype=1
			repl msbal.opening with lser.value1
			repl msbal.balance with lser.value1
			repl msbal.o_a with lser.value1
			repl msbal.b_a with lser.value1
*!*			endif
		repl msbal.batchno with '_'+alltri(str(recno()))
		repl msbal.misc1 with mitm.gcode
	else
*!*			if lser.vchcode=0 and lser.vchtype=1
			repl msbal.opening with msbal.opening +lser.value1
			repl msbal.balance with msbal.balance +lser.value1
			repl msbal.o_a with msbal.o_a +lser.value1
			repl msbal.b_a with msbal.b_a +lser.value1
*!*			endif
	endif
endscan
close table all

*!*	@rowno,10 say '**** Importing Serial Opening  ****' font 'Arial',10
*!*	rowno=rowno+1
*!*	sele sele (1)
*!*	use &datatransferpath\itemserialno.&datatransferext alias lser
*!*	index on str(itemcode,9) to lser
*!*	sele sele(1)
*!*	use &datdev\pro.&datext alias mitm
*!*	index on str(code,9) to mitm
*!*	sele sele(1)
*!*	use &datdev\probat.&datext alias msbal
*!*	index on str(code,9)+substr(mycode,1,20) to msbal
*!*	sele lser
*!*	go top
*!*	scan for inlist(vchtype,9,10,11)
*!*		sele mitm
*!*		seek str(lser.itemcode,9)
*!*		sele msbal
*!*		seek str(lser.itemcode,9)+substr(alltri(lser.serialno)+space(20),1,20)
*!*		if !found()
*!*			append blank
*!*			repl msbal.code with mitm.code
*!*			repl msbal.name with mitm.name
*!*			repl msbal.billname with mitm.billname
*!*			repl msbal.product with mitm.product
*!*			repl msbal.pack with mitm.pack
*!*			repl msbal.unit2 with mitm.unit2
*!*			repl msbal.unit with mitm.unit
*!*			repl msbal.decimal with 'Y'
*!*			repl mycode with substr(alltri(lser.serialno)+space(20),1,20)
*!*	*!*			if lser.vchcode=0 and lser.vchtype=1
*!*				repl msbal.opening with -lser.value1
*!*				repl msbal.balance with -lser.value1
*!*				repl msbal.o_a with -lser.value1
*!*				repl msbal.b_a with -lser.value1
*!*	*!*			endif
*!*			repl msbal.batchno with '_'+alltri(str(recno()))
*!*			repl msbal.misc1 with mitm.gcode
*!*		else
*!*	*!*			if lser.vchcode=0 and lser.vchtype=1
*!*				repl msbal.opening with msbal.opening -lser.value1
*!*				repl msbal.balance with msbal.balance -lser.value1
*!*				repl msbal.o_a with msbal.o_a -lser.value1
*!*				repl msbal.b_a with msbal.b_a -lser.value1
*!*	*!*			endif
*!*		endif
*!*	endscan
*!*	close table all

*!*	@rowno,10 say '**** Importing With Out Serial Opening  ****' font 'Arial',10
*!*	rowno=rowno+1
*!*	sele sele (1)
*!*	use &datatransferpath\tran4.&datatransferext alias fsbal
*!*	index on str(mastercode,9) to fsbal
*!*	sele sele (1)
*!*	use &datatransferpath\itemserialno.&datatransferext alias lser
*!*	set filt to vchcode#0
*!*	index on str(itemcode,9) to lser
*!*	sele sele(1)
*!*	use &datdev\pro.&datext alias mitm
*!*	index on str(code,9) to mitm
*!*	sele sele(1)
*!*	use &datdev\probat.&datext alias msbal
*!*	index on str(code,9)+substr(mycode,1,20) to msbal
*!*	sele fsbal
*!*	go top
*!*	scan 
*!*		store '' to lserialno
*!*		sele lser
*!*		seek str(fsbal.mastercode,9)
*!*		scan while str(itemcode,9)=str(fsbal.mastercode,9)
*!*			sele mitm
*!*			seek str(fsbal.mastercode,9)
*!*			sele msbal
*!*			seek str(fsbal.mastercode,9)+substr(alltri(lserialno)+space(20),1,20)
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
*!*				repl mycode with substr(alltri(lserialno)+space(20),1,20)
*!*				repl msbal.opening with fsbal.d1
*!*				repl msbal.balance with fsbal.d1
*!*				repl msbal.o_a with fsbal.d1
*!*				repl msbal.b_a with fsbal.d1
*!*				repl msbal.batchno with ''
*!*				repl msbal.misc1 with mitm.gcode
*!*			else
*!*				repl msbal.opening with opening+fsbal.d1
*!*				repl msbal.balance with balance+fsbal.d1
*!*				repl msbal.o_a with o_a+fsbal.d1
*!*				repl msbal.b_a with b_a+fsbal.d1
*!*			endif
*!*		endscan
*!*	endscan
*!*	close table all
@rowno,10 say '**** Importing Ledger****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\master1 alias masters
sele sele (1)
sele * from masters where mastertype=2 into curs fact
sele sele(1)
use &datatransferpath\folio1 alias fbal
index on mastercode to fbal for mastertype=2
sele sele (1)
sele * from masters where mastertype=1 and between(code,101,129)  into curs facgrp readwr
index on code to facgrp
sele sele (1)
sele * from masters where mastertype=1 and !between(code,101,129)  into curs subgrp readwr
index on code to subgrp
if old_4='M'
	sele sele (1)
	use &datatransferpath\tran2.dbf alias factran
	set filt to rectype=1
	index on mastercode to factran
endif
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
	mfbal=0
	if seek(fact.code,'fbal')
		mfbal=iif(fbal.d1<0,abs(fbal.d1),-fbal.d1)
	endif
	=seek(fact.code,'fdet')
	sele mact
	appen blank
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.code))
	repl mact.fax2 with alltri(str(fact.code))
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
	repl phone1 with fdet.mobile
	repl phone2 with fdet.telno
	repl phone4 with fdet.mobile
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl rate with 'N'
	repl mact.status with 'Y'
	repl mact.opning with mfbal
	*!*	wait wind mfbal
	if old_4='M'
		store 0 to ttran
		sele factran
		seek fact.code
		sum value1 to ttran while mastercode=fact.code
		sele mact
		repl opning with mfbal+iif(ttran<0,abs(ttran),-ttran)
	endif
	
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
			case subgrp.parentgrp= 111
				mscode='C2'
			case subgrp.parentgrp= 104
				mscode='E'
			case subgrp.parentgrp= 108
				mscode='I'
			case subgrp.parentgrp= 113
				mscode='C3'
			case subgrp.parentgrp= 119
				mscode='D2'
			case subgrp.parentgrp= 122
				mscode='J5'
			case subgrp.parentgrp= 123
				mscode='J6'
			case subgrp.parentgrp= 110
				mscode='K'
			case inlist(subgrp.parentgrp,1135,1144,1136,1137,1138,1139,1140,1141,1142,1143,118)
				mscode='D1'
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
				case facgrp.code= 111
					mscode='C2'
				case facgrp.code= 104
					mscode='E'
				case facgrp.code= 108
					mscode='I'
				case facgrp.code= 113
					mscode='C3'
				case facgrp.code= 119
					mscode='D2'
				case facgrp.code= 122
					mscode='J5'
				case facgrp.code= 123
					mscode='J6'
				case facgrp.code= 110
					mscode='K'
				case inlist(facgrp.code,1135,1144,1136,1137,1138,1139,1140,1141,1142,1143,118)
					mscode='D1'
				otherwise
					mscode='J12'
			endcase
		endif
	endif
	sele mact
	repl mact.scode with mscode
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
@rowno,10 say '**** Importing Other Ledger****' font 'Arial',10
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
if old_4='F'
	do busyfullmigration
endif
proc busyfullmigration
@rowno,10 say '**** Importing Inward Transactions  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F'
	repl aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\pro.&datext alias pro
index on str(code,9) to pro
sele sele(1)
use &datdev\probat.&datext alias probat
index on str(code,9)+substr(mycode,1,30) to probat
sele sele(1)
use &datdev\order.&datext alia ord
inde on ordno to ord
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\subdis.&datext alias msub
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20
sele sele(1)
use &datatransferpath\tran1 alia ltran1
set filte to inlist(vchtype,2,3,8) and between(date,firstdate,lastdate)
sele sele(1)
use &datatransferpath\tran2 alia ltran2
set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
index on vchcode to pld
sele sele(1)
use &datatransferpath\itemserialno alia lser
index on str(vchcode,9)+str(vchtype,9)+str(itemcode,9) to mser
sele sele(1)
use &datatransferpath\master1 alia ltax
set filte to inlist(mastertype,13,14)
index on code to ltax
sele sele(1)
use &datatransferpath\itemdesc alia lfqty
index on str(vchcode,9)+str(srno,9) to lfqty
sele sele(1)
sele * from ltran2  where rectype=3 into curs lother readwr
inde on vchcode to lother
i=1
sele ltran1
go top
scan
	lbilldate=date
	lentrydate=date
	l2='P-'+padl(i,6,'0')
	l3=alltri(vchno)
	i=i+1
	=seek(substr(alltri(str(mastercode))+space(6),1,6),'ord')
	=seek(ltran1.cm1,'ltax')
	lstring= "0123456789"
	ltaxname=ltax.name
	ltaxrate=val(allt(chrtran(ltaxname,chrtran(ltaxname,lstring,space(0)),space(0))))
	sele mdis
	appen blan
	do case
	case ltran1.vchtype=2
		repl type with 'P'
		repl vcn with l2
		repl pm with l3
		repl date with lbilldate
		repl lrda with lentrydate
	case ltran1.vchtype=8
		repl type with 'D'
		repl challan with iif(!empty(ltran1.vchno),ltran1.vchno,'STJRNL'+alltri(str(recno())))
		repl chdate with lbilldate
	case ltran1.vchtype=3
		repl type with 'R'
		repl vcn with l2
		repl pm with l3
		repl date with lbilldate
		repl lrda with lenrtydate
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
	repl ltype with iif('TAXINCL'$upper(ltax.name),'9','2')
***Local Central***
	isigst=0
	if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
		isigst=1
	endi
	repl amountp with ltran1.vchamtbase
	repl final with ltran1.vchamtbase
&&other head
	store 0 to lbilldiscount
	do case
	case serviceitem='N'
		sele lother
		seek ltran1.vchcode
		if found()
			scan for seek(subs(alltr(str(lother.mastercode))+spac(6),1,6),'ord') while lother.vchcode=ltran1.vchcode
				do case
				case 'CGST'$ord.parnam
					loop
				case 'SGST'$ord.parnam
					loop
				case 'IGST'$ord.parnam
					loop
				endcase
				do case
				case 'DISCOUNT'$upper(ord.parnam)
					laddless=iif(empty(lother.value3),-abs(lother.value1),-abs(lother.value3))
					lbilldiscount=lother.value1
				otherwise
					laddless=iif(empty(lother.value3),abs(lother.value1),abs(lother.value3))
				endcase
				do case
				case mdis.other=0
					repl mdis.othun with alltri(str(lother.mastercode))
					repl mdis.other with iif(mdis.type='P'and 'DISCOUNT'$upper(ord.parnam),0,laddless)
				case mdis.packing=0
					repl mdis.pacun with alltri(str(lother.mastercode))
					repl mdis.packing with iif(mdis.type='P'and 'DISCOUNT'$upper(ord.parnam),0,laddless)
				otherwise
					repl mdis.freun with alltri(str(lother.mastercode))
					repl mdis.freight with  iif(mdis.type='P'and 'DISCOUNT'$upper(ord.parnam),0,laddless)
				endcase
			endsc
		endif
	endcase
	sele mdis
	repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele ltran2
	seek ltran1.vchcode
	scan while vchcode=ltran1.vchcode
		=seek(str(ltran2.mastercode,9),'pro')
		store '' to lserial
		sele lser
		if seek(str(ltran2.vchcode,9)+str(ltran2.vchtype,9)+str(ltran2.mastercode,9))
			scan while str(vchcode,9)+str(vchtype,9)+str(itemcode,9)=str(ltran2.vchcode,9)+str(ltran2.vchtype,9)+str(ltran2.mastercode,9)	
			lserial=alltri(serialno)
			store '' to lbatch
				if seek(str(ltran2.mastercode,9)+substr(lserial+space(30),1,30),'probat')
					lbatch=probat.batchno
				endif
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl qty with abs(lser.value1) &&&for ### if condition for ### item
			repl rate with  iif(ltran2.d2#0,abs(ltran2.d2),abs(ltran2.d5)) &&&for ### if condition for ### item
			repl mrp with  ltran2.d18
			repl batch with lbatch
			repl flg with iif(mdis.type='S','G',mdis.type)
			repl tax with 'T'
			repl disc1 with iif(mdis.type='P',lbilldiscount,0)
			do case
			case isigst=1
				do case
				case !empty(ltaxrate)
					repl ssta with ltaxrate
				otherwise
					repl ssta with pro.igst
				endcase
			otherwise
				do case
				case !empty(ltaxrate)
					repl ssta with ltaxrate/2
					repl cgst with ltaxrate/2
				otherwise
					repl ssta with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)&&&iif(ftax.d1#0,ftax.d1,pro.cgst)&&pld.d12
					repl cgst with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)&&&iif(ftax.d1#0,patx.d1,pro.cgst)&&pld.d33
				endcase
			endcase
			repl half with 'A'
			repl godwon with mdis->godwon

			endsc	
		else			
			store '' to lbatch
			if seek(str(ltran2.mastercode,9)+substr(lserial+space(30),1,30),'probat')
				lbatch=probat.batchno
			endif
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl qty with iif(ltran2.d1#0,ltran2.d1,1) &&&for ### if condition for ### item
			repl rate with  iif(ltran2.d2#0,abs(ltran2.d2),abs(ltran2.d5)) &&&for ### if condition for ### item
			repl mrp with  ltran2.d18
			repl batch with lbatch
			repl flg with iif(mdis.type='S','G',mdis.type)
			repl tax with 'T'
			repl disc1 with iif(mdis.type='P',lbilldiscount,0)
			do case
			case isigst=1
				do case
				case !empty(ltaxrate)
					repl ssta with ltaxrate
				otherwise
					repl ssta with pro.igst
				endcase
			otherwise
				do case
				case !empty(ltaxrate)
					repl ssta with ltaxrate/2
					repl cgst with ltaxrate/2
				otherwise
					repl ssta with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)&&&iif(ftax.d1#0,ftax.d1,pro.cgst)&&pld.d12
					repl cgst with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)&&&iif(ftax.d1#0,patx.d1,pro.cgst)&&pld.d33
				endcase
			endcase
			repl half with 'A'
			repl godwon with mdis->godwon
		endif
	endscan
	do case
	case serviceitem='Y'
		sele lother
		seek ltran1.vchcode
		if found()
			scan for seek(subs(alltr(str(lother.mastercode))+spac(6),1,6),'ord') while lother.vchcode=ltran1.vchcode
				if upper('freight & forwarding charges')$upper(ord.parnam)
					select pro
					seek str(lother.mastercode,9)
					if !found()
						append blank
						replace code with lother.mastercode
						replace name with alltrim(str(code))
						replace billname with ord.parnam
						replace product with billname
					endif
					sele dis
					appen blan
					repl codep with mdis->codep
					repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
					repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
					repl voucher with mdis->voucher
					repl code with lother.mastercode
					repl qty with 1
					repl flg with mdis.type
					repl rate with lother.value3
					do case
					case isigst=1
						do case
						case !empty(ltaxrate)
							repl ssta with ltaxrate
						otherwise
							repl ssta with pro.igst
						endcase
					otherwise
						do case
						case !empty(ltaxrate)
							repl ssta with ltaxrate/2
							repl cgst with ltaxrate/2
						case !empty(ltran2.d12)
							repl ssta with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)
							repl cgst with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)
						otherwise
							repl ssta with pro.igst/2
							repl cgst with pro.igst/2
						endcase
					endcase
					repl half with 'a'
					repl godwon with mdis->godwon
				endif
			endscan
		endif
	endcase
endsc
sele sele(1)
sele mslip
go top
repl voucher with last4+10
repl svoucher with slast5+10
clos tabl all
@rowno,10 say '**** Importing Outward Transactions  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F'
	repl aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\pro.&datext alias pro
index on str(code,9) to pro
sele sele(1)
use &datdev\probat.&datext alias probat
index on str(code,9)+substr(mycode,1,30) to probat
sele sele(1)
use &datdev\order.&datext alia ord
inde on ordno to ord
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\subdis.&datext alias msub
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20
sele sele(1)
use &datatransferpath\tran1 alia ltran1
set filte to inlist(vchtype,9,10) and between(date,firstdate,lastdate)
sele sele(1)
use &datatransferpath\tran2 alia ltran2
set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
index on vchcode to ltran2
sele sele(1)
use &datatransferpath\itemserialno alia lser
index on str(vchcode,9)+str(vchtype,9)+str(itemcode,9) to lser
sele sele(1)
use &datatransferpath\master1 alia ltax
set filte to mastertype=13
index on code to ltax
sele sele(1)
use &datatransferpath\itemdesc alia lfqty
index on str(vchcode,9)+str(srno,9) to lfqty
sele sele(1)
sele * from ltran2  where rectype=3 into curs lother readwr
inde on vchcode to lother
i=1
sele ltran1
go top
scan
	lbilldate=date
	l3=alltri(vchno)
	i=i+1
	=seek(substr(alltri(str(mastercode))+space(6),1,6),'ord')
	=seek(ltran1.cm1,'ltax')
	sele mdis
	appen blan
	do case
	case ltran1.vchtype=9
		repl type with 'S'
		repl vcn with l3
		repl pm with l3
		repl date with lbilldate
	case ltran1.vchtype=10
		repl type with 'B'
		repl vcn with iif(empty(l3),alltri(str(recno())),l3)
		repl date with lbilldate
	endcase
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl codep with ord.ordno
	repl ltype with iif('TAXINCL'$upper(ltax.name),'9','2')
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
***Local Central***
	isigst=0
	if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
		repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
		isigst=1
	endi
&&&otherhead
	lbilldiscount=0
	sele lother
	seek ltran1.vchcode
	if found()
		scan for seek(subs(alltr(str(lother.mastercode))+spac(6),1,6),'ord') while lother.vchcode=ltran1.vchcode
			do case
			case 'CGST'$ord.parnam
				loop
			case 'SGST'$ord.parnam
				loop
			case 'IGST'$ord.parnam
				loop
			endcase
			do case
			case 'DISCOUNT'$upper(ord.parnam)
				laddless=iif(empty(lother.value3),-abs(lother.value1),-abs(lother.value3))
				lbilldiscount=lother.value1
			otherwise
				laddless=iif(empty(lother.value3),abs(lother.value1),abs(lother.value3))
			endcase
			do case
			case mdis.other=0
				repl mdis.othun with alltri(str(lother.mastercode))
				repl mdis.other with iif(mdis.type='S'and 'DISCOUNT'$upper(ord.parnam),0,laddless)
			case mdis.packing=0
				repl mdis.pacun with alltri(str(lother.mastercode))
				repl mdis.packing with iif(mdis.type='S'and 'DISCOUNT'$upper(ord.parnam),0,laddless)
			otherwise
				repl mdis.freun with alltri(str(lother.mastercode))
				repl mdis.freight with  iif(mdis.type='S'and 'DISCOUNT'$upper(ord.parnam),0,laddless)
			endcase
		endsc
	endif
	sele mdis
	repl amountp with ltran1.vchamtbase
	repl final with ltran1.vchamtbase
	repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele ltran2
	seek ltran1.vchcode
	scan while vchcode=ltran1.vchcode
		=seek(str(ltran2.mastercode,9),'pro')
		store '' to lserial
		sele lser
		if seek(str(ltran2.vchcode,9)+str(ltran2.vchtype,9)+str(ltran2.mastercode,9))
			scan while str(vchcode,9)+str(vchtype,9)+str(itemcode,9)=str(ltran2.vchcode,9)+str(ltran2.vchtype,9)+str(ltran2.mastercode,9)	
				lserial=alltri(serialno)
				if seek(str(ltran2.mastercode,9)+substr(lserial+space(30),1,30),'probat')
					lbatch=probat.batchno
				endif
				sele dis
				appen blan
				repl codep with mdis->codep
				repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
				repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
				repl voucher with mdis->voucher
				repl code with pro.code
				repl pack with pro.pack
				repl rate with  abs(ltran2.d2)
				repl mrp with ltran2.d18
				repl qty with abs(lser.value1)
				repl batch with lbatch
				repl disc1 with lbilldiscount
				repl flg with iif(mdis.type='S','G',mdis.type)
				repl tax with 'T'
				do case
				case isigst=1
					do case
					case !empty(ltaxrate)
						repl ssta with ltaxrate
					otherwise
						repl ssta with pro.igst
					endcase
				otherwise
					do case
					case !empty(ltaxrate)
						repl ssta with ltaxrate/2
						repl cgst with ltaxrate/2
					case !empty(ltran2.d12)
						repl ssta with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)
						repl cgst with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)
					otherwise
						repl ssta with pro.igst/2
						repl cgst with pro.igst/2
					endcase
				endcase
				repl half with 'A'
				repl godwon with mdis->godwon
			endsc
		else
			store '' to lbatch
			if seek(str(ltran2.mastercode,9)+substr(lserial+space(30),1,30),'probat')
				lbatch=probat.batchno
			endif
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl pack with pro.pack
			repl rate with  abs(ltran2.d2)
			repl mrp with ltran2.d18
			repl qty with abs(ltran2.d1)
			repl batch with lbatch
			repl disc1 with lbilldiscount
			repl flg with iif(mdis.type='S','G',mdis.type)
			repl tax with 'T'
			do case
			case isigst=1
				do case
				case !empty(ltaxrate)
					repl ssta with ltaxrate
				otherwise
					repl ssta with pro.igst
				endcase
			otherwise
				do case
				case !empty(ltaxrate)
					repl ssta with ltaxrate/2
					repl cgst with ltaxrate/2
				case !empty(ltran2.d12)
					repl ssta with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)
					repl cgst with iif(inlist(ltran2.d12,5,12,18,28),ltran2.d12/2,ltran2.d12)
				otherwise
					repl ssta with pro.igst/2
					repl cgst with pro.igst/2
				endcase
			endcase
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

@rowno,10 say '**** Transfer Receipt on Bill****' font 'Arial',10
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
set filte to inlist(vchtype,9) and between(date,firstdate,lastdate)
sele sele(1)
use &datatransferpath\tran2.&datatransferext alias ltran2
set filte to inlist(vchtype,9) and between(date,firstdate,lastdate)
index on vchcode to ltran2
sele ltran1
scan
	lvoudate=date
	lvounumber=alltri(vchno)
	sele ltran2
	seek ltran1.vchcode
	scan for rectype=1 and b1=.t. while vchcode=ltran1.vchcode
		=seek(substr(alltri(str(ltran2.mastercode))+space(6),1,6),'ord')
		if found()
			sele gle
			appen blank
			repl voucher with last4
			repl vcsno with lvounumber
			repl code with ord.ordno
			repl date with lvoudate
			if tran2.value1>0
				repl cd with 'C'
				repl credit with abs(ltran2.value1)
			else
				repl cd with 'D'
				repl debit with abs(ltran2.value1)
			endi
			repl remark1 with ltran2.shortnar
			do case
			case inlist(ltran1.vchtype,9)
				repl book with 'R'
			endcase
		endif
	endscan
	last4=last4+10
endscan
sele mslip
repl voucher with last4+10
repl svoucher with slast5+10
close table all
@rowno,10 say '**** Importing Account From Inventories ****' font 'Arial',10
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

@rowno,10 say '**** Transfer other Accounting Entries ****' font 'Arial',10
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
set filte to inlist(vchtype,14,19,16,15) and between(date,firstdate,lastdate)
sele sele(1)
use &datatransferpath\tran2.&datatransferext alias ltran2
set filte to inlist(vchtype,14,19,16,15) and rectype=1 and between(date,firstdate,lastdate)
index on vchcode to tran2
sele ltran1
scan
	lvoudate=date
	lvounumber=alltri(ltran1.vchno)
	sele ltran2
	seek ltran1.vchcode
	scan while vchcode=ltran1.vchcode
		=seek(substr(alltri(str(ltran2.mastercode))+space(6),1,6),'ord')
		sele gle
		appen blank
		repl voucher with last4
		repl vcsno with lvounumber
		repl code with ord.ordno
		repl date with lvoudate
		if ltran2.value1>0
			repl cd with 'C'
			repl credit with abs(ltran2.value1)
		else
			repl cd with 'D'
			repl debit with abs(ltran2.value1)
		endi
		repl remark1 with ltran2.shortnar
		do case
		case inlist(ltran1.vchtype,14)
			repl book with 'R'
		case inlist(ltran1.vchtype,19)
			repl book with 'P'
		case inlist(ltran1.vchtype,16)
			repl book with 'J'
		case inlist(ltran1.vchtype,15)
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
