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
	datdev='d:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Feb\Ayus_busy\data\'+space(50),1,50) &&rpos_path
datatransferext='DBF '
if type('FINALCP')#'U'
	colofhed="BUSY SOFTWARE MIGRATION"
	=colofil(3,5,21,70,10)
endif
old_3 = 'Yes'
old_4 = 'Full Migration     '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
mtrade='Pharma  '
serviceitem='No '
distax='Yes'
outsonly='No '
scalc='2'
pcalc='2'
old_12 = 'GST '
mstatecode='09'
multimode='N'
removenull = 'NO'
@4,7  say '                              Busy To Marg Transfer Process '+space(30) font 'Arial bold',14 color rgb(20,255,255,119,136,153)
@6,7  say 'Busy Data Path          :' font 'Courier New',12  get datatransferpath font 'Courier New',12
@7,7  say 'Busy Extension          :' font 'Courier New',12  get datatransferext font 'Courier New',12
@8,7  say 'WITH O/S                :' font 'Courier New',12  get old_3 pict '@m YES,NO ' font 'Courier New',12
@9,7  say 'MIGRATION TYPE          :' font 'Courier New',12  get old_4 pict '@m Master Migration,Full Migration '  font 'Courier New',12
@10,7 say 'F.Y.BEGIN FROM          :' font 'Courier New',12  get old_5 font 'Courier New',12
@11,7 say 'F.Y.UP TO               :' font 'Courier New',12  get old_9  font 'Courier New',12
@12,7 say 'GST/VAT                 :' font 'Courier New',12  get old_12 pict '@m GST ,VAT ' font 'Courier New',12
@13,7 say 'SAL CALCULATION         :' font 'Courier New',12  get scalc  font 'Courier New',12
@14,7 say 'PURCHASE CALCULATION    :' font 'Courier New',12  get pcalc font 'Courier New',12
@15,7 say 'State GST Code          :' font 'Courier New',12  get mstatecode  font 'Courier New',12
@16,7 say 'Removenull              :' font 'Courier New',12  get removenull pict '@m No ,Yes' font 'Courier New',12
@17,7 say '####ITEM                :' font 'Courier New',12  get serviceitem pict '@m No ,Yes' font 'Courier New',12
@18,7 say 'Discount Before Tax     :' font 'Courier New',12  get distax pict '@m No ,Yes' font 'Courier New',12
@19,7 say 'Multi Mode Of Payment   :' font 'Courier New',12  get Multimode pict '@m N,Y' font 'Courier New',12
@20,7 say 'Type SURE               :' font 'Courier New',12  get sure pict '@x!' font 'Courier New',12
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


@rowno,10 say '**** Importing Product/Company/Hsncode****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\master1.dbf alias masters
sele sele (1)
select * from masters where mastertype=8 into curs funit readwr
index on code to funit
sele sele (1)
use &datatransferpath\masteraddressinfo.dbf alias fdet
index on mastercode to fdet
sele sele (1)
sele * from masters where mastertype=2 into curs acgrp
index on code to acgrp
sele sele (1)
sele * from masters where mastertype=6 into curs fitm
sele sele (1)
sele * from masters where mastertype=5 into curs fpcm
index on code to fpcm
sele sele (1)
use &datatransferpath\tran4.dbf alias fopn
index on mastercode to fopn
sele sele (1)
sele * from masters where mastertype=25 into curs ftax
index on code to ftax
if old_4='M'
	sele sele (1)
	use &datatransferpath\tran2.dbf alias tran
	sele sele (1)
	sele * from tran where rectype=2 and vchtype=9 and d2#0 into curs fsrate	readwr
	sele fsrate
	index on mastercode to fsrate
	sele sele (1)
	sele * from tran where rectype=2 and vchtype=2 and d2#0 into curs fprate readwr
	sele fprate
	index on mastercode to fprate
	sele sele (1)
	select * from tran  into curs tranqty readwr
	index on mastercode to tranqty
endif
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
	=seek(fitm.parentgrp,'fpcm')
	=seek(fitm.code,'fdet')
	=seek(fitm.cm8,'ftax')
	=seek(fitm.cm1,'funit')
	=seek(fitm.cm4,'acgrp')
	if old_4='M'  &&&Master Rate Update From Transaction
		store 0 to salrate,purcrate,fmrp
		sele fsrate
		seek fitm.code
		scan while mastercode=fitm.code
			salrate=fsrate.d2
		endsc
		sele fprate
		seek fitm.code
		scan while mastercode=fitm.code
			purcrate=fprate .d2
			fmrp=fprate.d18
		endsc
	endif
	sele mitm
	appen blank
	repl code with fitm.code
	repl name with alltrim(str(fitm.code))
	repl product with fitm.name
	repl packing with ''
	repl billname with fitm.name
	repl pack with fitm.d1
	repl rackno with fitm.alias
	repl unit with upper(alltri(funit.name))
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	if upper('Purchases GST Exempt Goods')$upper(acgrp.name)
		repl taxl with 'E'
	endif
	repl mitm.minimum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.prate with fitm.d4
	repl mitm.lprate with fitm.d4
	repl mitm.ratea with fitm.d3
	repl mitm.mrp with fitm.d2
	repl fixdis with fitm.d16
	repl purdis with fitm.d17
	myno = "0123456789"
	btax=ftax.name
	itemtax=val(allt(chrtran(btax, chrtran(btax, myno, space(0)), space(0))))
	repl saltax with itemtax/2
	repl cgst   with itemtax/2
	repl igst   with itemtax
	store 0 to prodopn
	sele fopn &&&&busy opening Stock
	seek fitm.code
	sum d1 to prodopn while mastercode=fitm.code
	if old_4='M'  &&&&closing Stock Update from Transaction
		store 0 to trqty
		sele tranqty
		seek fitm.code
		sum value1 to trqty while mastercode=fitm.code
		sele mitm
		repl opening with (prodopn+trqty)
		repl o_a with (prodopn +trqty)
		repl b_a with (prodopn +trqty)
		repl balance with (prodopn +trqty)
	else
		sele mitm
		repl opening with prodopn
		repl o_a with prodopn
		repl b_a with prodopn
		repl balance with prodopn

	endif
	&&& HSN and Tax Mast
	thsn_code=chrtran(fitm.hsncode,chr(0),'')
	sele mpcm
	seek 'COMMCD' + substr(thsn_code+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with thsn_code,;
			mpcm.parnam with thsn_code,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
	&&& COMPANY
	sele mpcm
	seek 'ZZZZZZ' + substr(fpcm.name+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'p'+alltrim(str(recno())),;
			mpcm.sname  with fpcm.name,;
			mpcm.parnam with fpcm.name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
	&&& salt
	sele mpcm
	seek 'SALT  ' + substr(fdet.of2+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'S'+alltrim(str(recno())),;
			mpcm.sname  with fdet.of2,;
			mpcm.parnam with fdet.of2,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
	&&& category
	sele mpcm
	seek 'CATEGO' + substr(fdet.of1+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with fdet.of1,;
			mpcm.parnam with fdet.of1,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode5 with mpcm.scode
endscan
close table all
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
	sele sele(1)
	use &datatransferpath\tran1 alia pur
	set filte to inlist(vchtype,2,3) and between(date,firstdate,lastdate)
	sele sele(1)
	use &datatransferpath\tran2 alia pld
	set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
	index on vchcode to pld
	sele sele(1)
	use &datatransferpath\master1 alia ptax
	set filte to inlist(mastertype,13,14)
	index on code to ptax
	sele sele(1)
	use &datatransferpath\itemdesc alia pfqty
	index on str(vchcode,9)+str(srno,9) to pfqty
	sele sele(1)
	sele * from pld into curs pdisc where rectype=3
	inde on vchcode to pdisc
	i=1
	sele pur
	go top
	scan &&&&for vchcode=130
		f_billdate=date
		edt=date
		l2='P-'+padl(i,6,'0')
		l3=alltri(vchno)
		i=i+1
		=seek(substr(alltri(str(mastercode))+space(6),1,6),'ord')
		=seek(pur.cm1,'ptax')
		myno = "0123456789"
		btax=ptax.name
		busybilltax=val(allt(chrtran(btax, chrtran(btax, myno, space(0)), space(0))))
		sele mdis
		appen blan
		if pur.vchtype=2
			repl type with 'P'
			repl vcn with l2
			repl pm with l3
			repl date with f_billdate
			repl lrda with edt
		else
			repl type with 'R'
			repl vcn with l2
			repl pm with l3
			repl date with f_billdate
			repl lrda with edt
		endif
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
		repl ltype with iif('TAXINCL'$upper(ptax.name),'9','2')
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
			isigst=1
		endi
		repl amountp with pur.vchamtbase
		repl final with pur.vchamtbase
		store 0 to bdisc,lotherless,taxfound,f_billdiscount
		&&other head
		sele pdisc
		seek pur.vchcode
		if found()
			scan for seek(subs(alltr(str(pdisc.mastercode))+spac(6),1,6),'ord') while pdisc.vchcode=pur.vchcode
				if 'CGST'$ord.parnam
					taxfound=1
					loop
				endif
				if 'SGST'$ord.parnam
					taxfound=1
					loop
				endif
				if 'IGST'$ord.parnam
					taxfound=1
					loop
				endif
				if 'DISCOUNT'$upper(ord.parnam)
					bdisc=bdisc+(pdisc.value3)
					if distax='Y'
						loop
					endif
				endif
				lotherless=iif(empty(pdisc.value3),abs(pdisc.value1),0)&&&iif(empty(pdisc.value3),iif(pdisc.value1<0,pdisc.value1,-pdisc.value1),iif(pdisc.value3<0,pdisc.value3,-pdisc.value3))
				if mdis.other=0
					repl mdis.othun with alltri(str(pdisc.mastercode))
					repl mdis.other with iif(mdis.type='P'and distax='N',bdisc,lotherless)
				else
					if mdis.packing=0
						repl mdis.pacun with alltri(str(pdisc.mastercode))
						repl mdis.packing with iif(mdis.type='P'and distax='N',bdisc,lotherless)
					else
						repl mdis.freun with alltri(str(pdisc.mastercode))
						repl mdis.freight with iif(mdis.type='P'and distax='N',bdisc,lotherless)
					endi
				endi
			endsc
		endif
		sele mdis
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		if distax='Y'
			repl misc3 with substr(misc3,1,54)+str(bdisc,10,2)+substr(misc3,65,100)
		endif
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele pld
		seek pur.vchcode
		scan while vchcode=pur.vchcode
			=seek(str(pld.mastercode,9),'pro')
				if !empty(pld.d12)
					taxfound=1
				endif
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			if seek (str(pld.vchcode,9)+str(pld.srno,9),'pfqty')
				repl qty with abs(pld.d1)-abs(pfqty.d1)
				repl free with abs(pfqty.d1)
			else
				repl qty with abs(pld.d1)
			endif
			repl pack with roun(pld.d8,0)
			repl rate with  abs(pld.d2)&&&&abs(pld.d5)/abs(pld.D1)&&abs(pld.D2)
			repl mrp with  pld.d18
			repl tax with pro.taxl
			repl flg with iif(mdis.type='S','G',mdis.type)
			repl disc1 with iif(mdis.type='P',f_billdiscount,0)
			if taxfound=1
				if !'EXEMPT'$upper(btax)
					do case 
						case !empty(busybilltax)
							if isigst=1
								repl ssta with busybilltax
							else
								repl ssta with busybilltax/2
								repl cgst with busybilltax/2
							endif
						case empty(busybilltax)
							bitax=pld.d12
							if !empty(bitax)
								if isigst=1
									repl ssta with iif(inlist(bitax,3,5,12,18,28),bitax,bitax*2)
								else
									repl ssta with iif(inlist(bitax,3,5,12,18,28),bitax/2,bitax)
									repl cgst with iif(inlist(bitax,3,5,12,18,28),bitax/2,bitax)
								endif
							endif
						case empty(busybilltax) and empty(bitax)
								if isigst=1
									repl ssta with pro.igst
								else
									repl ssta with pro.cgst
									repl cgst with pro.cgst
								endif
					endcase
				endif
			endi
			IF dis.tax='E'
				repl ssta with 0
				repl cgst with 0
			endif
			repl half with 'A'
			repl godwon with mdis->godwon
		endsc
		store 0 to f_billdiscount
		if serviceitem='Y'
			sele pdisc
			seek pur.vchcode
			if found()
				scan for seek(subs(alltr(str(pdisc.mastercode))+spac(6),1,6),'ord') while pdisc.vchcode=pur.vchcode
					do case
						case upper('CGST')$upper(ord.parnam)
							loop
						case upper('SGST')$upper(ord.parnam)
							loop
						case upper('IGST')$upper(ord.parnam)
							loop
						case upper('DISCOUNT')$upper(ord.parnam)
							loop
						case upper('ROUNDED OFF')$upper(ord.parnam)
							loop
					endcase
					select pro
					seek str(pdisc.mastercode,9)
					if !found()
						append blank
						replace code with pdisc.mastercode
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
					repl code with pdisc.mastercode
					replace qty with 1
					replace flg with mdis.type
					replace rate with pdisc.value3
					if isigst=1
						if !empty(busybilltax)
							repl ssta with busybilltax
						else
							repl ssta with pro.igst
						endif
					else
						if !empty(busybilltax)
							repl ssta with busybilltax/2
							repl cgst with busybilltax/2
						else
							if !empty(pld.d12)
								repl ssta with iif(inlist(pld.d12,5,12,18,28),pld.d12/2,pld.d12)&&&iif(ptax.d1#0,ptax.d1,pro.cgst)&&pld.d12
								repl cgst with iif(inlist(pld.d12,5,12,18,28),pld.d12/2,pld.d12)&&&iif(ptax.d1#0,patx.d1,pro.cgst)&&pld.d33
							else
								repl ssta with pro.igst/2
								repl cgst with pro.igst/2
							endif
						endif
					endif
					repl half with 'A'
					repl godwon with mdis->godwon
				endscan
			endif
		endif
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
	sele sele (1)
	use &datatransferpath\tran2 alias bdis
	sele sele(1)
	use &datatransferpath\tran1 alia sal
	set filte to inlist(vchtype,9,10,11) and between(date,firstdate,lastdate) &&&&&and vchno='                      105'
	sele sele(1)
	select * from bdis into curs sld readwr
	set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
	index on vchcode to sld
	sele sele (1)
	select * from bdis into curs sld2 readwr
	set filt to rectype=1 and empty(cashflow)
	index on vchcode to sld2
	sele sele(1)
	use &datatransferpath\master1 alia stax
	set filte to inlist(mastertype,13,14)
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
	scan 
		f_billdate=date
		l3=alltri(vchno)
		i=i+1
		=seek(substr(alltri(str(mastercode))+space(6),1,6),'ord')
		=seek(sal.cm1,'stax')
			myno = "0123456789"
			btax=stax.name
			bgst=val(allt(chrtran(btax, chrtran(btax, myno, space(0)), space(0))))
*!*				bgst=val(substr(stax.name,rat('%',stax.name)-2,2))
		sele mdis
		appen blan
		do case
			case sal.vchtype=9
				repl type with 'S'
				repl vcn with l3
				repl pm with l3
				repl date with f_billdate
			case sal.vchtype=10
				repl type with 'B'
				repl vcn with iif(empty(l3),alltri(str(recno())),l3)
				repl date with f_billdate
			case sal.vchtype=11
				repl type with 'S'
				repl chdate with f_billdate
				repl challan with l3
		endcase
		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
		repl codep with ord.ordno
		repl ltype with scalc&&iif('TAXINCL'$upper(stax.name) or 'INCLUSIVE'$upper(stax.name),'9','2')
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
		&&&otherhead
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66,100)
			isigst=1
		endi
		store 0 to bdisc,fotheraddless
			sele sdisc
			seek sal.vchcode
			if found()
				scan for seek(subs(alltr(str(sdisc.mastercode))+spac(6),1,6),'ord') while sdisc.vchcode=sal.vchcode
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
						bdisc=abs(sdisc.value3)
						if distax='Y'
							loop
						endif
					endif
					f_otheraddless=iif(empty(sdisc.value3),sdisc.value1,sdisc.value3)
				if serviceitem='N'
					if mdis.other=0
						repl mdis.othun with alltri(str(sdisc.mastercode))
						repl mdis.other with  f_otheraddless
					else
						if mdis.packing=0
							repl mdis.pacun with alltri(str(sdisc.mastercode))
							repl mdis.packing with f_otheraddless
						else
							repl mdis.freun with alltri(str(sdisc.mastercode))
							repl mdis.freight with  f_otheraddless
						endi
					endi
				endif
				endsc
		endif
		sele mdis
		repl amountp with sal.vchamtbase
		repl final with sal.vchamtbase
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		if distax='Y'
			repl misc3 with substr(misc3,1,54)+str(bdisc,10,2)+substr(misc3,65,100)
		endif
		if multimode='Y'
			repl misc3 with substr(misc3,1,34)+'M'+substr(misc3,36,100)
			sele sld2
			seek sal.vchcode
			scan while vchcode=sal.vchcode
				sele msub
				appen blank
				repl codep with mdis.codep
				repl vcn with mdis.vcn
				repl date with mdis.date 
				repl voucher with mdis.voucher
				repl type with 'V'
				repl dsm with 'REMARK'
				repl rtqt with substr(alltri(str(sld2.mastercode))+space(6),1,6)+str(abs(sld2.value1),12,2)
			endscan
		endi
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

		sele sld
		seek sal.vchcode
		scan while vchcode=sal.vchcode
			=seek(str(sld.mastercode,9),'pro')
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl pack with 0&&&sld.d8
			repl rate with  abs(sld.d2)
			repl mrp with  sld.d18
			repl tax with pro.taxl
			mq=iif(sld.d1>0,-sld.d1,abs(sld.d1))
			if seek (str(sld.vchcode,9)+str(sld.srno,9),'sfqty')
				repl qty with iif(sld.d1>0,-(abs(sld.D1)-abs(sfqty.d1)),(abs(sld.D1)-abs(sfqty.d1)))
				repl free with abs(sfqty.d1)
			else
				repl qty with iif(sld.d1>0,-sld.d1,abs(sld.d1))
			endif
			
			repl disc1 with 0
			repl flg with iif(mdis.type='S','G',mdis.type)
			do case
				case !empty(bgst)
					if isigst=1
						repl ssta with bgst
					else
						repl ssta with bgst/2
						repl cgst with bgst/2
					endif
				case empty(bgst)
					mtx=sld.d12
					if mtx#0
						if isigst=1
							repl ssta with mtx
						else
							repl ssta with mtx
							repl cgst with mtx
						endif
					else
						if isigst=1
							repl ssta with pro.igst
						else
							repl ssta with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d12
							repl cgst with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d33
						endi
					endif
			endcase
			repl half with 'A'
			repl godwon with mdis->godwon
		endsc
		if serviceitem='Y'
			sele sdisc
			seek sal.vchcode
			if found()
				scan for seek(subs(alltr(str(sdisc.mastercode))+spac(6),1,6),'ord') while sdisc.vchcode=sal.vchcode
					if upper('Insurance')$upper(ord.parnam)
						select pro
						seek str(sdisc.mastercode,9)
						if !found()
							append blank
							replace code with sdisc.mastercode
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
						repl code with sdisc.mastercode
						replace qty with 1
						replace flg with iif(mdis.type='S','G',mdis.type)
						replace rate with sdisc.value3
						if !'EXEMPT'$upper(btax)
							if isigst=1
								if !empty(mtx)
									repl ssta with mtx
								else
									repl ssta with pro.igst
								endif
							else
								if !empty(mtx)
									repl ssta with mtx/2
									repl cgst with mtx/2
								else
									if !empty(sld.d12)
										repl ssta with iif(inlist(pld.d12,5,12,18,28),pld.d12/2,pld.d12)&&&iif(ptax.d1#0,ptax.d1,pro.cgst)&&pld.d12
										repl cgst with iif(inlist(pld.d12,5,12,18,28),pld.d12/2,pld.d12)&&&iif(ptax.d1#0,patx.d1,pro.cgst)&&pld.d33
									else
										repl ssta with pro.igst/2
										repl cgst with pro.igst/2
									endif
								endif
							endif
						endif
						repl half with 'A'
						repl godwon with mdis->godwon
					endif
					if upper('Freight & Forwarding Charges')$upper(ord.parnam)
						select pro
						seek str(sdisc.mastercode,9)
						if !found()
							append blank
							replace code with sdisc.mastercode
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
						repl code with sdisc.mastercode
						replace qty with 1
						replace flg with iif(mdis.type='S','G',mdis.type)
						replace rate with sdisc.value3
						do case
							case !empty(bgst)
								if isigst=1
									repl ssta with bgst
								else
									repl ssta with bgst/2
									repl cgst with bgst/2
								endif
							case empty(bgst)
								mtx=sld.d12
								if mtx#0
									if isigst=1
										repl ssta with mtx
									else
										repl ssta with mtx
										repl cgst with mtx
									endif
								else
									if isigst=1
										repl ssta with pro.igst
									else
										repl ssta with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d12
										repl cgst with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d33
									endi
								endif
						endcase
						repl half with 'A'
						repl godwon with mdis->godwon
					endif
				endscan
			endif
		endif
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
	use &datatransferpath\tran1.&datatransferext alias tran
	set filte to inlist(vchtype,9) and between(date,firstdate,lastdate)
	sele sele(1)
	use &datatransferpath\tran2.&datatransferext alias tran1
	set filte to inlist(vchtype,9) and between(date,firstdate,lastdate) &&and rectype=1 and b1=.t.
	index on vchcode to tran1
	sele tran
	scan
		f_voucherdate=date
		f_vouchernumber=alltri(tran1.vchno)
		sele tran1
		seek tran.vchcode
		scan for rectype=1 and b1=.t. while vchcode=tran.vchcode
			=seek(substr(alltri(str(tran1.mastercode))+space(6),1,6),'ord')
			if found()
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
					case inlist(tran.vchtype,9)
						repl book with 'R'
				endcase
			endif
		endscan
		last4=last4+10
	endscan
	sele mslip
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all

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
	use &datatransferpath\tran1.&datatransferext alias tran
	set filte to inlist(vchtype,14,19,16,15) and between(date,firstdate,lastdate)
	sele sele(1)
	use &datatransferpath\tran2.&datatransferext alias tran1
	set filte to inlist(vchtype,14,19,16,15) and rectype=1 and between(date,firstdate,lastdate)
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
	*!*	EOF : Busy General Trade.PRG .....Dated    : 24/04/2025   Author : SARVESH
