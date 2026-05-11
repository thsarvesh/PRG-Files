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
datatransferpath=substr('D:\2025\apr\gARMENT\data\'+space(50),1,50) &&rpos_path
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
opnwithsize='Yes'
scalc='2'
pcalc='2'
old_12 = 'GST '
mstatecode='20'
removenull = 'NO'
@4,7  say '                              Busy To Marg Transfer Process '+space(30) font 'Arial bold',14 color rgb(20,255,255,119,136,153)
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
@16,7 say 'Item OPening With Size  :' font 'Courier New',12  get opnwithsize pict '@m No ,Yes' font 'Courier New',12
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
	sele * from masters where mastertype=6 into curs fitm
sele sele (1)
	sele * from masters where mastertype=5 into curs fpcm
	index on code to fpcm
sele sele (1)
	use &datatransferpath\tran4.dbf alias fopstk
	index on mastercode to fopstk
sele sele (1)
	sele * from masters where mastertype=25 into curs ftax
	index on code to ftax
	if old_4='M'
	sele sele (1)
		use &datatransferpath\tran2.dbf alias tsale
	sele sele (1)
		sele * from tsale where rectype=2 and vchtype=9 and d2#0 into curs tsalerate	readwr
		sele tsalerate
		index on mastercode to tsalerate
	sele sele (1)
		sele * from tsale where rectype=2 and vchtype=2 and d2#0 into curs tpurchaserate readwr
		sele tpurchaserate
		index on mastercode to tpurchaserate
	sele sele (1)
		select * from tsale where rectype=2 and inlist(vchtype,2,3) into curs tpurchasequantity readwr
		index on mastercode to purqty
	sele sele (1)
		select * from tsale where rectype=2 and inlist(vchtype,9,10) into curs tsalequantity readwr
		index on mastercode to salqty
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
		=seek(fitm.cm8,'ftax')
		if old_4='M'  &&&Master Rate Update From Transaction
		store 0 to fsalerate,fpurchaserate,fmrp
			sele tsalerate
			seek fitm.code
			scan while mastercode=fitm.code
				f=tsalerate.d2
			endsc
			sele tpurchaserate 
			seek fitm.code
			scan while mastercode=fitm.code
				fpurchaserate=tpurchaserate .d2
				fmrp=tpurchaserate.d18
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
		if old_4='M' 
			repl mitm.prate with fpurchaserate&&&tpurchaserate.d2
			repl mitm.lprate with fpurchaserate&&&tpurchaserate.d2
			repl mitm.ratea with fsalerate&&tsalerate.d2
			repl mitm.mrp with fmrp&&&tsalerate.d18
		endif
		if at('%',ftax.name)<=2
			ftaxrate=val(substr(ftax.name,rat('%',ftax.name)-1,2))
		else
			ftaxrate=val(substr(ftax.name,rat('%',ftax.name)-2,2))
		endif
		repl saltax with ftaxrate/2
		repl cgst   with ftaxrate/2
		repl igst   with ftaxrate	

		sele fopstk &&&&busy opening Stock
		seek fitm.code
		sum d1 to prdopstk while mastercode=fitm.code
		if old_4='M'  &&&&closing Stock Update from Transaction
			sele tpurchasequantity 
			seek fitm.code
			sum abs(d1) to tpurchasequantity while mastercode=fitm.code
			sele tsalequantity
			seek fitm.code
			sum abs(d1) to tsalequantity while mastercode=fitm.code
			sele mitm
			repl opening with ((prdopstk +tpurchasequantity)-tsalequantity)
			repl o_a with ((prdopstk +tpurchasequantity)-tsalequantity)
			repl b_a with ((prdopstk +tpurchasequantity)-tsalequantity)
			repl balance with ((prdopstk +tpurchasequantity)-tsalequantity)
		else
			sele mitm
			repl opening with prdopstk 
			repl o_a with prdopstk 
			repl b_a with prdopstk 
			repl balance with prdopstk 
			
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
	endscan
	close table all
if opnwithsize='Y'
@rowno,10 say '**** Importing Size Wise Opening  ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\itemparamdet.&datatransferext alias fsbal
sele sele (1)
use &datatransferpath\help1.&datatransferext alias lbar
set filter to rectype=3 and nameoralia#1
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan for inlist(vchtype,1) and rectype=1 and vchcode=0
	sele mitm
	seek str(fsbal.itemcode,9)
	sele msbal
	seek str(mitm.code,9)+substr(fsbal.c1+space(12),1,12)
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
		repl msbal.opening with fsbal.value1
		repl msbal.balance with fsbal.value1
		repl msbal.o_a with fsbal.value1
		repl msbal.b_a with fsbal.value1
		repl msbal.batchno with fsbal.c1
*!*			repl msbal.mrp with fsbal.d18
*!*			replace msbal.ratea with fsbal.d26
*!*			replace msbal.lprate with mitm.lprate
		repl msbal.misc1 with mitm.gcode
		repl msbal.supcode with ''
		repl msbal.supinvo with ''
		repl msbal.supdat with ctod('')
	else
			repl msbal.opening with msbal.opening +fsbal.value1
			repl msbal.balance with msbal.balance +fsbal.value1
			repl msbal.o_a with msbal.o_a +fsbal.value1
			repl msbal.b_a with msbal.b_a +fsbal.value1
	endif
endsc
close table all
else
	@rowno,10 say '**** Importing Size Wise Opening  ****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datatransferpath\tran4.&datatransferext alias fsbal
	sele sele (1)
	use &datatransferpath\help1.&datatransferext alias lbar
	set filter to rectype=3 and nameoralia#1
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
		seek str(fsbal.mastercode,9)
		sele msbal
		seek str(mitm.code,9)&&&&+substr(fsbal.c1+space(12),1,12)
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
			repl msbal.opening with fsbal.d1
			repl msbal.balance with fsbal.d1
			repl msbal.o_a with fsbal.d1
			repl msbal.b_a with fsbal.d1
			repl msbal.batchno WITH ''&&&with fsbal.c1
	*!*			repl msbal.mrp with fsbal.d18
	*!*			replace msbal.ratea with fsbal.d26
	*!*			replace msbal.lprate with mitm.lprate
			repl msbal.misc1 with mitm.gcode
			repl msbal.supcode with ''
			repl msbal.supinvo with ''
			repl msbal.supdat with ctod('')
		else
				repl msbal.opening with msbal.opening +fsbal.d1
				repl msbal.balance with msbal.balance +fsbal.d1
				repl msbal.o_a with msbal.o_a +fsbal.d1
				repl msbal.b_a with msbal.b_a +fsbal.D1
		endif
	endsc
	close table all
endif
@rowno,10 say '**** Importing Ledger****' font 'Arial',10
rowno=rowno+1
sele sele(1)
	use &datatransferpath\master1 alias masters
sele sele (1)
	sele * from masters where mastertype=2 into curs fact
sele sele(1)
	use &datatransferpath\folio1 alias taccountopening
	index on mastercode to taccountopening for mastertype=2
sele sele (1)
	sele * from masters where mastertype=1 and between(code,101,129)  into curs facgrp readwr
	index on code to facgrp
sele sele (1)
	sele * from masters where mastertype=1 and !between(code,101,129)  into curs subgrp readwr
	index on code to subgrp 
		if old_4='M'
	sele sele (1)
		use &datatransferpath\tran2.dbf alias taccounttransaction
		set filt to rectype=1
		index on mastercode to taccounttransaction
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
		mtaccountopening=0
		if seek(fact.code,'taccountopening')
			mtaccountopening=iif(taccountopening.d1<0,abs(taccountopening.d1),-taccountopening.d1)
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
		repl mact.opning with mtaccountopening
		*!*	wait wind mtaccountopening

		if old_4='M'
			store 0 to ttran
			sele taccounttransaction
			seek fact.code
			sum value1 to ttran while mastercode=fact.code
			repl mact.opning with mtaccountopening+iif(ttran<0,abs(ttran),-ttran)
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

		*!*	update mact set taccountopeninging=sum(bal.cr)-sum(bal.dr) from bal group by acid having
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
Proc busyfullmigration
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
	use &datatransferpath\ItemParamDet alia tparameter
	index on str(vchcode,9)+str(itemcode,9)+str(vchitemsn,9) to tparameter

sele sele(1)
	use &datatransferpath\tran2 alia pld
	set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
	index on vchcode to pld
sele sele(1)
	use &datatransferpath\master1 alia ptax
	set filte to inlist(mastertype,13,14)
	index on code to ptax
sele sele(1)
	use &datatransferpath\itemdesc alia purfree
	index on str(vchcode,9)+str(srno,9) to purfree
sele sele(1)
	sele * from pld into curs tpurchasediscount where rectype=3
	inde on vchcode to tpurchasediscount
	i=1
	sele pur
	go top
	scan
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
		f_billdiscount=0
		&&other head
		sele tpurchasediscount
		seek pur.vchcode
		if found()
			scan for seek(subs(alltr(str(tpurchasediscount.mastercode))+spac(6),1,6),'ord') while tpurchasediscount.vchcode=pur.vchcode
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
					f_otheraddless=iif(empty(tpurchasediscount.value3),-abs(tpurchasediscount.value1),-abs(tpurchasediscount.value3))
					f_billdiscount=tpurchasediscount.value1
				else
					f_otheraddless=iif(empty(tpurchasediscount.value3),abs(tpurchasediscount.value1),abs(tpurchasediscount.value3))&&&iif(empty(tpurchasediscount.value3),iif(tpurchasediscount.value1<0,tpurchasediscount.value1,-tpurchasediscount.value1),iif(tpurchasediscount.value3<0,tpurchasediscount.value3,-tpurchasediscount.value3))

				endif
				if mdis.other=0
					repl mdis.othun with alltri(str(tpurchasediscount.mastercode))
					repl mdis.other with iif(mdis.type='P'and 'DISCOUNT'$upper(ord.parnam),0,f_otheraddless)
				else
					if mdis.packing=0
						repl mdis.pacun with alltri(str(tpurchasediscount.mastercode))
						repl mdis.packing with iif(mdis.type='P'and 'DISCOUNT'$upper(ord.parnam),0,f_otheraddless)
					else
						repl mdis.freun with alltri(str(tpurchasediscount.mastercode))
						repl mdis.freight with  iif(mdis.type='P'and 'DISCOUNT'$upper(ord.parnam),0,f_otheraddless)
					endi
				endi
			endsc
		endif
		sele mdis
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele pld
		seek pur.vchcode
		scan while vchcode=pur.vchcode
	     =seek(str(pld.mastercode,9),'pro')
        sele tparameter
		seek str(pld.vchcode,9)+str(pld.mastercode,9)+str(pld.srno,9)
        if found()
            scan while str(vchcode,9)+str(itemcode,9)+str(vchitemsn,9)=str(pld.vchcode,9)+str(pld.mastercode,9)+str(pld.srno,9)
    			sele dis
				appen blan
				repl codep with mdis->codep
				repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
				repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
				repl voucher with mdis->voucher
				repl code with pro.code
				repl pack with pld.d8
	            repl batch with tparameter.bcn
	            repl qty with abs(tparameter.value1)
				repl rate with  abs(tparameter.d2)
				repl mrp with  pld.d18
				repl flg with iif(mdis.type='S','G',mdis.type)
				repl tax with 'T'
				repl disc1 with iif(mdis.type='P',f_billdiscount,0)
				repl pro.mrp with pld.d18
				repl pro.ratea with pld.d26
				repl PRO.prate with abs(pld.d2)
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
						repl ssta with iif(inlist(pld.d12,5,12,18,28),pld.d12/2,pld.d12)&&&iif(ptax.d1#0,ptax.d1,pro.cgst)&&pld.d12
						repl cgst with iif(inlist(pld.d12,5,12,18,28),pld.d12/2,pld.d12)&&&iif(ptax.d1#0,patx.d1,pro.cgst)&&pld.d33
					endif
				endi
				repl half with 'A'
				repl godwon with mdis->godwon
            endsc
		else
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl pack with pld.d8
			if seek (str(pld.vchcode,9)+str(pld.srno,9),'purfree')
				repl qty with (abs(pld.d1)-abs(purfree.d1))*iif(pld.d8#0,pld.d8,1)
				repl free with abs(purfree.d1)
			else
				repl qty with abs(pld.d1)*iif(pld.d8#0,pld.d8,1)
			endif
            repl batch with ''
			repl rate with  abs(pld.d2)
			repl mrp with  pld.d18
			repl flg with iif(mdis.type='S','G',mdis.type)
			repl tax with 'T'
			repl disc1 with iif(mdis.type='P',f_billdiscount,0)
			repl pro.mrp with pld.d18
			repl pro.ratea with pld.d26
			repl PRO.prate with abs(pld.d2)
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
					repl ssta with iif(inlist(pld.d12,5,12,18,28),pld.d12/2,pld.d12)&&&iif(ptax.d1#0,ptax.d1,pro.cgst)&&pld.d12
					repl cgst with iif(inlist(pld.d12,5,12,18,28),pld.d12/2,pld.d12)&&&iif(ptax.d1#0,patx.d1,pro.cgst)&&pld.d33
				endif
			endi
			repl half with 'A'
			repl godwon with mdis->godwon
		endif
		endsc
		f_billdiscount=0
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
	use &datatransferpath\master1 alias busymaster
	index on code to busymaster

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
	use &datatransferpath\tran1 alia sal
	set filte to inlist(vchtype,9,10) and between(date,firstdate,lastdate) &&&&&and vchno='                      105'
sele sele(1)
	use &datatransferpath\ItemParamDet alia tparameter
	index on str(vchcode,9)+str(itemcode,9)+str(vchitemsn,9) to tparameter

    sele sele(1)
	use &datatransferpath\tran2 alia sld
	set filte to inlist(rectype,2,7) and between(date,firstdate,lastdate)
	index on vchcode to sld
sele sele(1)
	select * from busymaster where mastertype=13 into curs stax readwr
	index on code to stax
sele sele(1)
	use &datatransferpath\itemdesc alia salefree
	index on str(vchcode,9)+str(srno,9) to salefree
sele sele(1)
	sele * from sld into curs tsalediscount where rectype=3
	inde on vchcode to tsalediscount
	i=1
	sele sal
	go top
	scan 
		f_billdate=date
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
				repl date with f_billdate
			case sal.vchtype=10
				repl type with 'B'
				repl vcn with iif(empty(l3),alltri(str(recno())),l3)
				repl date with f_billdate
		endcase
		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
		repl codep with ord.ordno
		repl ltype with '2'&&&iif('TAXINCL'$upper(stax.name),'9','2')
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
		store 0 to bdisc1,bdisc2,dis1found,dis2found,f_otheraddless
		sele tsalediscount
		seek sal.vchcode
		if found()
			scan for seek(subs(alltr(str(tsalediscount.mastercode))+spac(6),1,6),'ord') while tsalediscount.vchcode=sal.vchcode
			=seek (tsalediscount.mastercode,'busymaster')
				if 'CGST'$ord.parnam
					loop
				endif
				if 'SGST'$ord.parnam
					loop
				endif
				if 'IGST'$ord.parnam
					loop
				endif
				if upper(busymaster.name)='DISCOUNT'
					disrate=tsalediscount.value1
					dis1found=1
					LOOP
				endif
				if upper(busymaster.name)='T DISCOUNT'
					dis2rate=tsalediscount.value1
					dis2found=1
					loop
				endif
				f_otheraddless=iif(tsalediscount.mastercode= 3511,-tsalediscount.value3,tsalediscount.value3)
				if mdis.other=0
					repl mdis.othun with alltri(str(tsalediscount.mastercode))
					repl mdis.other with f_otheraddless
				else
					if mdis.packing=0
						repl mdis.pacun with alltri(str(tsalediscount.mastercode))
						repl mdis.packing with f_otheraddless
					else
						repl mdis.freun with alltri(str(tsalediscount.mastercode))
						repl mdis.freight with  f_otheraddless
					endi
				endi
			endsc
		endif
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
			isigst=1
		endi
		sele mdis
		repl amountp with sal.vchamtbase
		repl final with sal.vchamtbase
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele sld
		seek sal.vchcode
		scan while vchcode=sal.vchcode
		=seek(str(sld.mastercode,9),'pro')
	    sele tparameter
		seek str(sld.vchcode,9)+str(sld.mastercode,9)+str(sld.srno,9)
		  if found()
	        scan while str(vchcode,9)+str(itemcode,9)+str(vchitemsn,9)=str(sld.vchcode,9)+str(sld.mastercode,9)+str(sld.srno,9)
            			sele dis
						appen blan
						repl codep with mdis->codep
						repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
						repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
						repl voucher with mdis->voucher
						repl code with pro.code
						repl pack with sld.d8
						repl rate with  abs(sld.d2)
						repl mrp with  sld.d18
						repl qty with abs(tparameter.value1)
					    repl batch with tparameter.c1&&&bcn
					    repl nera with  tparameter.c1
						repl disc1 with iif(dis1found=1,disrate,0)
						repl disc2 with iif(dis2found=1,dis2rate,0)
						repl flg with iif(mdis.type='S','G',mdis.type)
						repl tax with 'T'
						if isigst=1
							repl ssta with pro.igst
						else
							repl ssta with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d12
							repl cgst with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d33
						endi
						repl half with 'A'
						repl godwon with mdis->godwon
				endsc
			else
					sele dis
					appen blan
					repl codep with mdis->codep
					repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
					repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
					repl voucher with mdis->voucher
					repl code with pro.code
					repl pack with sld.d8
					repl rate with  abs(sld.d2)
					repl mrp with  sld.d18
					if seek (str(sld.vchcode,9)+str(sld.srno,9),'salefree')
						repl qty with (abs(sld.d1)-abs(salefree.d1))*iif(sld.d8#0,sld.d8,1)
						repl free with abs(salefree.d1)
					else
						repl qty with abs(sld.d1)*iif(sld.d8#0,sld.d8,1)
					endif
					repl disc1 with iif(dis1found=1,disrate,0)
					repl disc2 with iif(dis2found=1,dis2rate,0)
					repl flg with iif(mdis.type='S','G',mdis.type)
					repl tax with 'T'
					if isigst=1
						repl ssta with pro.igst
					else
						repl ssta with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d12
						repl cgst with iif(stax.d1#0,stax.d1,pro.cgst)&&sld.d33
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
	use &datatransferpath\tran1.&datatransferext alias ttransactionheader
	set filte to inlist(vchtype,9) and between(date,firstdate,lastdate)
sele sele(1)
	use &datatransferpath\tran2.&datatransferext alias ttransactiondetail
	set filte to inlist(vchtype,9) and between(date,firstdate,lastdate) &&and rectype=1 and b1=.t.
	index on vchcode to ttransactiondetail
	sele ttransactionheader
	scan
		f_voucherdate=date
		f_vouchernumber=alltri(ttransactiondetail.vchno)
		sele ttransactiondetail
		seek ttransactionheader.vchcode
		scan for rectype=1 and b1=.t. while vchcode=ttransactionheader.vchcode
			=seek(substr(alltri(str(ttransactiondetail.mastercode))+space(6),1,6),'ord')
			if found()
				sele gle
				appen blank
				repl voucher with last4
				repl vcsno with f_vouchernumber
				repl code with ord.ordno
				repl date with f_voucherdate
				if ttransactiondetail.value1>0
					repl cd with 'C'
					repl credit with abs(ttransactiondetail.value1)
				else
					repl cd with 'D'
					repl debit with abs(ttransactiondetail.value1)
				endi
				repl remark1 with ttransactiondetail.shortnar
				do case
					case inlist(ttransactionheader.vchtype,9)
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
	use &datatransferpath\tran1.&datatransferext alias ttransactionheader
	set filte to inlist(vchtype,14,19,16,15) and between(date,firstdate,lastdate)
sele sele(1)
	use &datatransferpath\tran2.&datatransferext alias ttransactiondetail
	set filte to inlist(vchtype,14,19,16,15) and rectype=1 and between(date,firstdate,lastdate)
	index on vchcode to ttransactiondetail
	sele ttransactionheader
	scan
		f_voucherdate=date
		f_vouchernumber=alltri(ttransactionheader.vchno)
		sele ttransactiondetail
		seek ttransactionheader.vchcode
		scan while vchcode=ttransactionheader.vchcode
			=seek(substr(alltri(str(ttransactiondetail.mastercode))+space(6),1,6),'ord')
			sele gle
			appen blank
			repl voucher with last4
			repl vcsno with f_vouchernumber
			repl code with ord.ordno
			repl date with f_voucherdate
			if ttransactiondetail.value1>0
				repl cd with 'C'
				repl credit with abs(ttransactiondetail.value1)
			else
				repl cd with 'D'
				repl debit with abs(ttransactiondetail.value1)
			endi
			repl remark1 with ttransactiondetail.shortnar
			do case
				case inlist(ttransactionheader.vchtype,14)
					repl book with 'R'
				case inlist(ttransactionheader.vchtype,19)
					repl book with 'P'
				case inlist(ttransactionheader.vchtype,16)
					repl book with 'J'
				case inlist(ttransactionheader.vchtype,15)
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
Endproc
