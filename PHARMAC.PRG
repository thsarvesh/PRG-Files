***Last Modified by Umesh Nath Goswami on 04/10/2019
*!* for bill difference ## in support -> repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!* for item difference ## in support -> repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for item batch difference ## in support -> repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for ledger difference ## in support -> repl type with "#",aliase with "DAT/F-LD",Lcode with mact.ordno,value with TOT

clear
close data
set talk off
set date to brit
set cent on
set dele on
set cpdialog off
set safe off
close table all
clea
sele sele(1)
create curs mycurs  (setup c(50),value c(4))
sele mycurs
appe blank
repl  setup with 'Item Wise Double Discount ',value with 'Y'
appen blank
repl  setup with 'Ask Discount in Amount',value with 'N'
brow font 'COURIER',18    nomodify
store '' to mailid1,mailid2,mailid3
sure = 'SURE'
if type ('FINALCP')='U'
	firstdate=ctod('01/04/2024')
	lastdate =ctod('31/03/2025')
	datdev='D:\transfer\'
	datext='DBF'
endif
datatransferpath=substr('D:\Data_Migration\Nov\Pharmac\P5ABC1920\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'NO '
old_5=firstdate
old_6=lastdate
mstatecode='27'
softtype='Wholesale '
scalc='2'
pcalc='2'
removenull='No '
@ 05,10 say '*** PHARMACC DATA MIGRATION PROGRAM ***' font 'courier',18
@ 11,10 say 'PHARMACC DATA PATH    :' font 'courier',18 get datatransferpath   font 'courier',18
@ 12,10 say 'PHARMACC DATA EXT.    :' font 'courier',18 get datatransferext  font 'courier',18
@ 13,10 say 'WITH O/S              :' font 'courier',18 get old_3 pict '@m YES,NO ' font 'courier',18
@ 14,10 say 'ONLY BALANCE          :' font 'courier',18 get old_4 pict '@m YES,NO ' font 'courier',18
@ 15,10 say 'F.Y.BEGIN FROM        :' font 'courier',18 get old_5  font 'courier',18
@ 16,10 say 'F.Y.BEGIN FROM        :' font 'courier',18 get old_6  font 'courier',18
@ 17,10 say 'SALES CALULATION TYPE :' font 'courier',18 get scalc  font 'courier',18
@ 18,10 say 'PUR CALULATION TYPE   :' font 'courier',18 get pcalc  font 'courier',18
@ 19,10 say 'YOUR STATE CODE       :' font 'courier',18 get mstatecode font 'courier',18
@ 20,10 say 'Retail/WholeSale      :' font 'courier',18 get softtype pict '@M Whole Sale,Retail    '  font 'courier',18
@ 21,10 say 'Remove null Values    :' font 'courier',18 get removenull pict '@M No ,Yes' font 'courier',18
@ 22,10 say 'Type SURE             :' font 'courier',18 get sure pict '@x!' font 'courier',18
read
datatransferpath =alltrim(datatransferpath)
datdev =alltrim(datdev)
datext=alltrim(datext)
datatransferext=alltrim(datatransferext)
if lastkey()=27 or sure # 'SURE'
	return
endif
clear
if type ('FINALCP')#'U'
	=starttransfer()
endif
if removenull='Y'
	@ 08,15 say 'Removing Null Values........     Please Wait..........' font 'Courier',18
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endi
clea

set colo to n/w
@ 11,22 fill to 13,62 colo n+
@ 10,20 clea to 12,60
@ 10,20 to 12,60
set colo to n/w*
@ 11,22 say 'PLEASE WAIT PIPING PHARMACC DATA TO MARG.....'
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
dele all for aliase='PROGR'
DELE ALL FOR ALIASE ='DAT/F'
DELE ALL FOR ALIASE='GLEDGTMP'
DELE ALL FOR ALIASE='PARTYOTP'

PACK
use &datdev\subdis.&datext 
zap

close table all

if old_4 = 'Y'
	do margo
else
	do marga
endif

proc marga
?'** Transfer PRODUCT'
fd = datatransferpath+'stock.dbf'
td = datdev+'\pro.'+datext
ts=datdev+'\saletype.'+datext
sele sele(1)
use &ts alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm
sele sele(1)
use &fd alias fitm
sele sele(1)
use &td alias mitm
zap
index on name to mitm
sele sele(1)
use &datdev\support.&datext alias support

sele fitm
go top
do while .not. eof()
	sele mitm
	append blank
	repl mitm.code with fitm.itemcode
	repl mitm.name with str(fitm.itemcode,10)
	repl mitm.product with alltrim(upper(fitm.itemname))
	repl mitm.packing with fitm.packing
	repl mitm.billname with alltrim(upper(fitm.itemname)) +' '+ alltrim(fitm.packing)
	repl mitm.unit with 'Pcs'
	repl mitm.gcode with alltrim(str(fitm.companycod,6))
	repl mitm.pack with fitm.boxpacking
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.taxl with 'T'
	repl mitm.taxc with 'T'
	repl mitm.saltax with fitm.gstpercent/2
	repl mitm.cgst with fitm.gstpercent/2
	repl mitm.igst with fitm.gstpercent
	repl mitm.purtax with fitm.gstpercent/2
	repl mitm.status with 'Y'
	repl mitm.tfdate with date()
&&HSN
	sele mpcm
	seek 'COMMCD' + substr(fitm.hsn_code+space(15),1,15) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'C'+alltrim(str(fitm.itemcode)),;
			mpcm.sname  with substr(fitm.hsn_code+space(15),1,15)+ substr(fitm.hsn_code,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
			mpcm.parnam with fitm.hsn_code,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
	sele mitm
	mscheme=fitm.scheme
	repl deal with val(subs(fitm.scheme,1,at('+',fitm.scheme)-1))
	repl free with val(subs(fitm.scheme,at('+',fitm.scheme)+1))

	sele support
	repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,value with fitm.currentsto

	sele fitm
	skip
enddo
close table all


?'** Transfer COMPANY'
fd=datatransferpath + 'companymaster.dbf'
td=datdev + '\saletype.'+datext
sele sele(1)
use &datdev\support.&datext alias support
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to sgcode='ZZZZZZ'
dele all
pack
index on scode to mpcm
sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ',;
		mpcm.scode  with alltrim(str(fpcm.companycod,6)),;
		mpcm.sname  with fpcm.companynam,;
		mpcm.parnam with fpcm.companynam,;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
	do getmail
	if !empty(mailid1)
		sele support
		appen blank
		repl type with 'F',aliase with 'PROGROEA',lcode with  mpcm.scode,remark with mailid1
	endif
	if !empty(mailid2)
		sele support
		appen blank
		repl type with 'F',aliase with 'PROGROE1',lcode with  mpcm.scode,remark with mailid2
	endif
	if !empty(mailid3)
		sele support
		appen blank
		repl type with 'F',aliase with 'PROGROE2',lcode with  mpcm.scode,remark with mailid3
	endif

	sele fpcm
	skip
enddo
close table all

?'** Transfer AREA'
fd=datatransferpath + 'areamaster.dbf'
td=datdev + '\saletype.'+datext
sele a
use &fd alias farea
sele b
use &td alias marea
set filt to sgcode='AREA  '
dele all
pack
index on scode to marea
sele farea
go top
do while .not. eof()
	sele marea
	append blank
	repl marea.sgcode with 'AREA  ',;
		marea.scode  with alltrim(str(farea.areacode,5)),;
		marea.sname  with farea.areaname,;
		marea.parnam with farea.areaname,;
		marea.tcode with 'No',;
		marea.tax with 1
	sele farea
	skip
enddo
close table all


?'** Transfer City'
fd=datatransferpath + 'citymaster.dbf'
td=datdev + '\saletype.'+datext
sele a
use &fd alias farea
sele b
use &td alias marea
set filt to sgcode='ROUT  '
dele all
pack
index on scode to marea
sele farea
go top
do while .not. eof()
	sele marea
	append blank
	repl marea.sgcode with 'ROUT  ',;
		marea.scode  with alltrim(str(farea.citycode,5)),;
		marea.sname  with farea.cityname,;
		marea.parnam with farea.cityname,;
		marea.tcode with 'No',;
		marea.tax with 1
	sele farea
	skip
enddo
close table all

?'** Transfer BATCH'
fd=datatransferpath + 'batch.dbf'
fi=datatransferpath + 'itemtrsc.dbf'
ft=datatransferpath + 'taxmaster.dbf'
td=datdev + '\probat.'+datext
mi=datdev + '\pro.'+datext
ts=datdev+'\support.'+datext
sele sele(1)
use &ts alias support
dele all for type='#' and aliase='DAT/F-BT'
pack
sele e
use &ft alias ftax
index on str(taxcode,5) to ftax
sele d
use &fi alias ftrsc
index on str(uniqueid,10) to ftrsc
sele a
use &fd alias fsbal
index on itemcode to fsbal
sele b
use &mi alias mitm
index on name to mitm
sele c
use &td alias msbal
zap
index on name + batchno to msbal
r=0
sele fsbal
go top
do while .not. eof()
	=seek(substr(str(fsbal.itemcode,10)+space(10),1,10),'mitm')
	=seek(str(fsbal.uniqueid,10),'ftrsc')
	sele msbal
	seek substr(str(fsbal.itemcode,10)+space(10),1,10) + substr(fsbal.batchno+space(12),1,12)
	if .not. found()
		append blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with mitm.pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with (fsbal.opening+fsbal.openfree),;
			msbal.balance with (fsbal.opening+fsbal.openfree),;
			msbal.o_a with (fsbal.opening+fsbal.openfree),;
			msbal.b_a with (fsbal.opening+fsbal.openfree),;
			msbal.o_y with 0,;
			msbal.b_y with 0,;
			msbal.tqty with (fsbal.curstk+fsbal.curfree),;
			msbal.batchno with fsbal.batchno,;
			msbal.exp with fsbal.expiry,;
			msbal.lprate with fsbal.land_cost,;
			msbal.prate with fsbal.purchase,;
			msbal.ratea with fsbal.tp,;
			msbal.rateb with fsbal.nsalepr,;
			msbal.ratec with fsbal.ptr,;
			msbal.ratee with fsbal.nsalepr2,;
			msbal.rated with fsbal.nsalepr3,;
			msbal.mrp with fsbal.mrp,;
			msbal.misc1 with mitm.gcode,;
			msbal.supinvo with fsbal.inv_code,;
			msbal.supdat with fsbal.inv_date,;
			msbal.purexi with fsbal.excise,;
			msbal.purdis with ftrsc.pd_perc
		if (ftrsc.qty#0 .and. ftrsc.freeqty#0)
			repl purdeal with ftrsc.qty
			repl purfree  with ftrsc.freeqty
		endif
		sele support
		appen blan
		repl type with "#",aliase with "DAT/F-BT",lcode with "Pharma",pcode with mitm.code,;
			heading with fsbal->batchno,value with (fsbal->curstk+fsbal->curfree)
	else
		repl msbal.opening with msbal.opening + (fsbal.opening+fsbal.openfree),;
			msbal.balance with msbal.balance + (fsbal.opening+fsbal.openfree),;
			msbal.o_a with msbal.o_a + (fsbal.opening+fsbal.openfree),;
			msbal.b_a with msbal.b_a + (fsbal.opening+fsbal.openfree),;
			msbal.tqty with msbal.tqty + (fsbal.curstk+fsbal.curfree),;
			msbal.lprate with fsbal.land_cost,;
			msbal.prate with fsbal.purchase,;
			msbal.ratea with fsbal.tp,;
			msbal.rateb with fsbal.nsalepr,;
			msbal.ratec with fsbal.ptr,;
			msbal.ratee with fsbal.nsalepr2,;
			msbal.rated with fsbal.nsalepr3,;
			msbal.mrp with fsbal.mrp,;
			msbal.supinvo with fsbal.inv_code,;
			msbal.supdat with fsbal.inv_date,;
			msbal.purexi with fsbal.excise,;
			msbal.purdis with ftrsc.pd_perc
		if (ftrsc.qty#0 .and. ftrsc.freeqty#0)
			repl purdeal with ftrsc.qty
			repl purfree  with ftrsc.freeqty
		endif
		sele support
		repl type with "#",aliase with "DAT/F-BT",lcode with "Pharma",pcode with mitm.code,;
			heading with fsbal->batchno,value with value+(fsbal->curstk+fsbal->curfree)
	endif
	sele fsbal
	skip
enddo
sele mitm
scan
	sele fsbal
	seek mitm.code
	sum curstk+curfree to tot while itemcode=mitm.code
	sele mitm
	repl misc6 with str(tot,10,2)
endscan
sele msbal
go top
repl all date with old_5-1 for balance=0
close table all

?'** Transfer PARTY'
fd=datatransferpath + 'ledgermaster.dbf'
fa=datatransferpath + 'accountgroupmaster.dbf'
td=datdev + '\order.'+datext
fb=datatransferpath + 'tacb.dbf'
fc=datatransferpath + 'citymaster.dbf'
sp=datdev + '\support.'+datext
sele sele(1)
use &sp alias msup
index on aliase + str(sno,3) + lcode to msup
delete all for aliase ='ORDER' .and. sno=7
pack
sele sele(1)
use &fc alias fcity
index on str(citycode,5) to fcity
sele sele(1)
use &fd alias fact
index on accountcod to fact
sele sele(1)
use &fa alias fgrp
index on str(groupcode,5) to fgrp
sele sele(1)
use &td alias mact
zap
sele sele(1)
use &datatransferpath\invoice alias sal
index on accountcod to sal
sele fact
go top
do while .not. eof()
	tot=0
	sele sal
	seek fact->accountcod
	sum amount to tot for inlist(trsctype,31,33,42) while accountcod=fact.accountcod
	sele fcity
	seek str(fact.citycode,5)
	sele fgrp
	seek str(fact.groupcode,5)
	acgroup=' '
	do case
	case 'FIXED ASSETS   '$fgrp->groupname           &&&new entries by umesh 04/10/19
		acgroup='E '
	case 'CURRENT ASSETS  '$fgrp->groupname
		acgroup='C '
	case 'CAPITAL ACCOUNT '$fgrp->groupname
		acgroup='B '
	case 'CURRENT LIABILITIES '$fgrp->groupname
		acgroup='D '
	case 'OUTSTAND LIABILITIES '$fgrp->groupname
		acgroup='Dz '
	case 'SALES ACCOUNTS  '$fgrp->groupname
		acgroup='J6 '
	case 'PURCHASE ACCOUNTS '$fgrp->groupname
		acgroup='J52 '
	case 'OTHER INCOME '$fgrp->groupname
		acgroup='J4 '
	case 'PURCHASE A/C '$fgrp->groupname
		acgroup='J5 '
	case 'DIRECT EXPENSES '$fgrp->groupname
		acgroup='J11 '
	case 'INDIRECT EXPENSES  '$fgrp->groupname
		acgroup='J12 '
	case 'CASH BALANCE    '$fgrp->groupname
		acgroup='C2'
	case 'BANK BALANCE '$fgrp->groupname
		acgroup='C1'
	case 'SUNDRY CREDITORS  '$fgrp->groupname
		acgroup='D31'
	case 'SUNDRY DEBTORS '$fgrp->groupname
		acgroup='C6'
	case 'DUTIES AND TAXES '$fgrp->groupname
		acgroup='D1'
	case 'EXPENSES '$fgrp->groupname
		acgroup='J12'
	case 'INCOME '$fgrp->groupname
		acgroup='J4'

	endcase
	lcd=' '
	lc= len(alltr(str(fact->accountcod)))
	if lc<=6
		lcd=alltr(str(fact->accountcod))
	else
		lcd=left(alltr(str(fact->accountcod)),3)+right(alltr(str(fact->accountcod)),3)
	endi
	sele mact
	append blank
	repl mact.ordno with lcd
	repl mact.scode with acgroup
	repl mact.fax2 with  alltr(str(fact->accountcod))
	repl mact.parnam with alltrim(upper(fact.accountnam))
	repl mact.mailnam with alltrim(upper(fact.accountnam))
	repl mact.paradd with fact.address1
	repl mact.paradd1 with fact.address2
	repl mact.paradd2 with fcity.cityname
	repl mact.city with fcity.cityname
	repl mact.area with alltrim(str(fact.areacode,5))
	repl mact.rout with alltrim(str(fact.citycode,5))
	repl mact.sthed with  'CST TIN'
	repl mact.gsthed with 'GSTIN No.'
	repl mact.gstno with fact.gstn_no
	repl mact.stno with fact.vatno
	repl mact.dlno with alltrim(fact.druglic1) +' * '+ alltrim(fact.druglic2)
	repl mact.itno with fact.pan
	repl mact.phone1 with fact.phone
	repl mact.phone4 with fact.mobile
	repl mact.ref with 'Mr.'
	repl mact.confir with fact.contactper
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.adhed with 'Discount'
	repl mact.itno with fact.pan
	repl mact.addis with fact.cashdiscou

	repl mact.duedays with fact.creditdays
	repl mact.docu with fact.bank
	repl mact.docu1 with fact.bankaddres
	repl mact.opning with iif(fact.openingbal>0,-fact.openingbal,abs(fact.openingbal))
	repl mact.budget with iif(fact.currentbal>0,-fact.currentbal,abs(fact.currentbal))
	repl mact.rate with old_3 &&iif(inlist(scode,'C6 ','D31 '),old_3,'N')

	sele msup
	appe blank
	repl aliase with 'PARTYOTP'
	repl type with 'F'
	repl lcode with mact.ordno
	repl remark with 'M 50.00 40.00Y1             30            BABB0                                 '
	
*!*		if tot>5000000
*!*			repl remark with 'M 50.00 40.00Y1             30            BAA                                   '

*!*		else
*!*			repl remark with 'M 50.00 40.00Y1             30            BAC                                   '
*!*		endif
*!*		sele msup
*!*		append blank

	if alltrim(fact.gstn_type)='C'
		sele msup
		appen blank
		repl type with 'F',aliase with 'ORDER',lcode with mact.ordno,sno with 12,heading with '                00000CG  '
	endi
	sele msup
	append blank
	repl aliase with 'ORDER',;
		sno with 1,;
		type with 'F',;
		lcode with mact->ordno,;
		remark with subs(remark,1,70)+iif(fact.gstn_type='G','R','C')

	sele msup
	appe blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact->ordno,value with iif(mact->scode='D31',-(abs(fact->currentbal)),abs(fact->currentbal))

	sele msup
	appe blank
	repl type with 'F', aliase with 'ORDERsms', lcode with mact.ordno, sno with 2, remark with fact.emailid

	sele fact
	skip
enddo
sele mact
close table all

?'** Transfer MR'
fd=datatransferpath + 'salesmanmaster.dbf'
td=datdev + '\order.'+datext
sele a
use &fd alias fact
sele b
use &td alias mact
sele fact
go top
do while .not. eof()
	sele mact
	append blank
	repl mact.scode with 'D32'
	repl mact.rate with old_3
	repl mact.ordno with 'S'+str(fact.salesmanco,5)
	repl mact.parnam with alltrim(upper(fact.salesmanna))
	repl mact.mailnam with alltrim(upper(fact.salesmanna))
	repl mact.paradd with fact.address1
	repl mact.paradd1 with fact.address2
	repl mact.paradd2 with fact.city
	repl mact.sthed with  'LST  No.'
	repl mact.csthed with 'CST  No.'
	repl mact.phone1 with fact.phone
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.adhed with 'Discount'
	sele fact
	skip
enddo
close table all

?'** Transfer OUTSTANDING'
af=datdev + '\pendings.'+datext
bf=datdev + '\slipno.'+datext
cf=datatransferpath + 'billout.dbf'
sele a
use &af alias mpend
zap
sele b
use &bf alias mslip
sele c
use &cf alias fout
if old_3='Y'
	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10
	sele fout
	set filt to amount#0 .and. inv_date < old_5
	go top
	do while .not. eof()
		lcd=' '
		lc= len(alltr(str(fout->accountcod)))
		if lc<=6
			lcd=alltr(str(fout->accountcod))
		else
			lcd=left(alltr(str(fout->accountcod)),3)+right(alltr(str(fout->accountcod)),3)
		endi
		sele mpend
		append blank
		repl mpend.acgroup with iif(fout.amount>0,'C6','D31'),;
			mpend.ord with lcd,;
			mpend.ddate with fout.inv_date,;
			mpend.vcn with fout.inv_code,;
			mpend.invtype with 'O',;
			mpend.voucher  with vou,;
			mpend.svoucher with svou,;
			mpend.duedate with fout.duedate,;
			mpend.duedays with mpend.duedate-mpend.ddate
		if fout.amount < 0
			repl mpend.final with abs(fout.amount),;
				mpend.balance with abs(fout.amount),;
				mpend.itemope with 0
		else
			if fout.amount > 0
				repl mpend.final with -fout.amount,;
					mpend.balance with -fout.amount,;
					mpend.itemope with 0
			endif
		endif
		repl name with vcn
		vou=vou+5
		svou=svou+5
		sele fout
		skip
	enddo
	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5
endif

close table all

?'** Transfer LEDGER TRANSACTION'
mdis=datdev+ '\mdis.'+datext
af =datdev + '\gledger.'+datext
bf =datdev + '\slipno.'+datext
dis=datdev + '\dis.'+datext
pro=datdev + '\pro.'+datext
cf =datatransferpath + 'led.dbf'
bat=datatransferpath + 'batch.dbf'
sal1=datatransferpath + 'invoice.dbf'
sal2=datatransferpath + 'invdet.dbf'
sld =datatransferpath + 'itemtrsc.dbf'
sld1=datatransferpath + 'onlnpend.dbf'

sgr=datatransferpath + 'sgr.dbf'
pur=datatransferpath + 'pur.dbf'
pgr=datatransferpath + 'pgr.dbf'
tax=datatransferpath + 'taxmaster.dbf'
sele i
use &bf
go top
last4 =voucher+10
slast5=svoucher+10

?'** for INVENTORY TRANSACTION'
last4=last4+20
sele j
use &bat alias bat
index on str(uniqueid,10) to bat
sele f
use &tax alias tax
index on str(taxcode,6) to tax
sele e
use &pro alias pro
index on name to pro
sele c
use &sal1 alias sal1
sele a
use &sal2 alias sal2
index on str(trsc_type,2)+inv_code to sal2
sele h
use &sld alias sld
index on str(trsc_type,2)+inv_code to sld
sele b
use &sld1 alias sld1
index on adj_inv tag sld1
index on str(trsc_type,2) +inv_code tag sld10
sele sele(1)
use &datdev\subdis.&datext alias subdis
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord

sele sele(1)
use &datdev\gledger.&datext alias gle 

sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support

seek 'F' + 'BATCHPRT'

if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datatransferpath\billoutdet alias bout

sele d
use &mdis alias mdis
zap
sele g
use &dis alias dis
zap

**42      -  Sales
**31 & 33 -  Purchase
**32      -  Sales Return
**43      -  Purchase Return
**44      -  Self Expiry/Breakage
**41      -  Delevery Challan
**51      -  Expiry Sales Return
**52      -  Expiry Purchase Return
**63      -  Location Transfer to
**73      -  Location Transfer From
**11      -  Free to Sample
**12      -  Saleble to Free

sele c
set filt to !(trsctype=82 .or. trsctype = 83 .or. trsctype = 84) &&&&AND INV_CODE='CAS00004'
go top
do while .not. eof()
	lcd=' '
	lc= len(alltr(str(c->accountcod)))
	if lc<=6
		lcd=alltr(str(c->accountcod))
	else
		lcd=left(alltr(str(c->accountcod)),3)+right(alltr(str(c->accountcod)),3)
	endi
	if c.trsctype=41 .and. empty(c.inv_code)
		skip
		loop
	endif
	last1 = c.inv_code
	sele a
	seek str(c.trsctype,2)+c.inv_code
	sele d
	appe blank
*  repl misc3 with substr(misc3,1,53)+iif(c.vatbill=.t.,'T','R')+substr(misc3,55,100) &&&Reg/Unreg
	repl codep with lcd
	if c.accountcod = 1
		repl codep with 'STACO3'
		repl docu with c.narration2
		repl docu1 with a.cashbillad
	endif

**SALES
	if c.trsctype=42
		repl type with 'S'
		repl vcn with c.inv_code
		repl date with c.invoicedat
		repl godwon with 'A'
		repl other with a.crnote  &&&&(a.crnote+a.add_amt)
		repl packing with -(a.drnote+a.less_amt)
		repl ltype with scalc
		if !empty(a.cn_amount)
			repl crnorem with a.cn_string
			repl crno with -a.cn_amount
		endi
	else
**PURCHASE
		if c.trsctype=31 .or. c.trsctype=33
			repl type with 'P'
			repl pm with c.docno
			repl lrda with c.invoicedat
			repl godwon with 'A'
*Repl Other With -(a.disc)
			repl other with a.add_amt &&SCHEME
			repl packing with -(a.drnote+a.less_amt)
			repl freight with a.octroi
			if (c.direct_pur = 'Y')    && !(c.paymentmod = 'N') .or.
				repl vcn with c.inv_code
				repl date with c.invoicedat
			else
				repl challan with c.inv_code
				repl chdate with c.invoicedat
			endif
			repl ltype with pcalc
		else
**SALES RETURN
			if c.trsctype=32
				if !(c.paymentmod = 'N')
					repl type with 'R'
					repl vcn with c.inv_code
					repl date with c.invoicedat
					repl godwon with 'A'
					repl other with (a.crnote+a.add_amt)
					repl packing with -(a.drnote+a.less_amt)
					repl ltype with scalc
				else
					repl type with 'R'
					repl vcn with c.inv_code
					repl date with c.invoicedat
					repl godwon with 'A'
					repl other with (a.crnote+a.add_amt)
					repl packing with -(a.drnote+a.less_amt)
					repl ltype with scalc
				endif
			else
**SALES CHALLAN
				if c.trsctype=41
					repl type with 'S'
					repl challan with c.inv_code
					repl chdate with c.invoicedat
					repl godwon with 'A'
					repl other with (a.crnote+a.add_amt)
					repl packing with -(a.drnote+a.less_amt)
					repl ltype with scalc
				else
**PURCHASE RETURN
					if c.trsctype=43
						repl type with 'B'
						repl godwon with 'A'
						repl other with (a.crnote+a.add_amt)
						repl packing with -(a.drnote+a.less_amt)
						if !(c.paymentmod = 'N')
							repl vcn with c.inv_code
							repl date with c.invoicedat
						else
							repl challan with c.inv_code
							repl chdate with c.invoicedat
						endif
						repl ltype with pcalc
					else
**PURCHASE RETURN EXP/BRK
						if c.trsctype=52
							repl type with 'Q'
							repl vcn with c.inv_code
							repl date with c.invoicedat
							repl godwon with 'Y'
							repl other with (a.crnote+a.add_amt)
							repl packing with -(a.drnote+a.less_amt)
							repl ltype with pcalc
						else
							if c.trsctype=73 .or. c.trsctype = 44
								repl type with 'L'
								repl challan with c.inv_code
								repl chdate with c.invoicedat
								repl godwon with 'A'
								repl other with (a.crnote+a.add_amt)
								repl packing with -(a.drnote+a.less_amt)
								if c.trsctype = 44
									repl codep with 'STACsl'
								endif
								repl ltype with scalc
							else
**SALES RETURN EXPIRY
								if c.trsctype=51
									if !(c.paymentmod = 'N')
										repl type with 'W'
										repl vcn with c.inv_code
										repl date with c.invoicedat
										repl pm with c.inv_code
										repl lrda with c.invoicedat
										repl godwon with 'Y'
										repl other with (a.crnote+a.add_amt)
										repl packing with -(a.drnote+a.less_amt)
										repl ltype with scalc
									else
										repl type with 'W'
										repl challan with c.inv_code
										repl chdate with c.invoicedat
										repl godwon with 'Y'
										repl other with (a.crnote+a.add_amt)
										repl packing with -(a.drnote+a.less_amt)
										repl ltype with scalc
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
	endif
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.amount)
	repl salun with ''
	repl staxun with 'SZTZOZ'
	if c.paymentmod='C'
		repl cash with c.amount&&&+A.TDS_amount
		repl round with a.round_off
	else
		repl final with c.amount&&&+a.tds_amount
		repl round with a.round_off
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl mr with 'S'+str(c.salesmanco,5)
	repl duedays with 0
	repl addis with 0
	repl account with 'N'
	repl sale with 'Z'
	repl discafter with 'N'
	repl remark4 with c.inv_code
	repl remark1 with str(c.amount,12,2)
	=seek(codep,'ORD')
	isigst=0
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif
IF A.TCS_AMOUNT#0
	sele subdis
	appen blan
	repl codep with d.codep
	repl vcn with d.vcn
	repl date with d.date
	repl voucher with d.voucher
	repl type with '9'
	repl dsm with 'RETTCS'
	repl rtqt with str(a.tcs_amount)+' '+iif(len(alltrim(ord.itno))#0,'0.075','0.100')
ENDIF
=seek(mdis.codep,'ord')
try
  if a.tds_amount#0 
    REPL mdis.remark4 with subs(mdis.remark4,1,10)+str(a.tds_amount,10,2)
    SELE GLE
    appen blank 
    REPL voucher with mdis.voucher+1
    repl date with mdis.date 
    repl book with 'J' 
    repl credit with a.TDS_amount
    repl cd with 'C'
    repl code with 'SZTDP1' 
    REPL code1 with mdis.codep 
    repl remark1 with '##########000     TDS ON PURCHASE                       '+dtoc(firstdate)+dtoc(lastdate)
     
    appen blank 
    REPL voucher with mdis.voucher+1
    repl date with mdis.date 
    repl book with 'J' 
    repl debit with a.TDS_amount 
    repl cd with 'D'
    repl code with mdis.codep 
    repl code1 with mdis.codep
    repl remark1 with '##########000     TDS ON PURCHASE                       '+dtoc(firstdate)+dtoc(lastdate)
    
    sele SUBDIS
    appen blank
    REPL VOUCHER WITH MDIS.VOUCHER
    REPL vcn with mdis.vcn 
    repl date with mdis.date 
    repl codep with mdis.codep 
	repl dsm with 'RETTCS'
	repl type with '9'
	repl rtqt with str(a.tds_amount,12,2)+str(iif(len(allt(ord.itno))=0,.5,.1),6,3)+'TDS'
	
    sele support
    appen blank 
    repl type with 'M' 
    repl aliase with 'GLEDGTMP' 
    repl voucher with mdis.voucher
    repl sno with 1  
    repl heading with space(21)+str(iif(len(allt(ord.itno))=0,.5,.1),4,1)
    repl remark with '##########000     TDS ON PURCHASE                       '+DTOC(FIRSTDATE)+DTOC(LASTDATE)
    SELE SUPPORT
    APPEN BLANK    
    repl type with 'M' 
    repl aliase with 'GLEDGTMP' 
    repl voucher with mdis.voucher
    repl sno with 2  
    repl heading with space(21)+str(iif(len(allt(ord.itno))=0,.5,.1),4,1)
    repl remark with '0U/S 194Q'+STR(MDIS.FINAL,16,2)+space(14)+mdis.codep

  endif
CATCH
mError=1 
endtry  

	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	removeadd_amt=0
	sele h
	seek str(c.trsctype,2) + c.inv_code
	if !found()
		sele d
		delete
		sele c
		skip
		loop
	endif
	do while str(h.trsc_type,2)=str(c.trsctype,2) .and. h.inv_code=c.inv_code .and. .not. eof()
		last = substr(str(icode,10)+space(10),1,10)
		sele b
		set order to sld10
		seek str(h.trsc_type,2) + h.inv_code
		sele e
		seek last
		sele f
		seek str(h.tax_code,6)
		sele j
		seek str(h.uniqueid,10)
		sele g
		appe blank
		if empty(d.challan)
			repl vcn with d.vcn
			repl date with d.date
		else
			repl vcn with d.challan
			repl date with d.chdate
		endif
		repl codep with d.codep
		repl voucher with d.voucher
		repl code with e.code
		repl tax with iif(h.cgst_amoun+h.sgst_amoun+h.igst_amoun=0,'E','T')
		repl qty with h.qty
		repl free with h.freeqty
		repl batch with j.batchno
		repl exp with j.expiry
        REPL pack with e.pack
		if h.qty#0 and h.gross_amou#0
			repl rate with val(str(h.gross_amou/h.qty,12,2)) &&IIF(H.TAXABLE_AM=H.AMOUNT,h.rate,val(str(H.TAXABLE_AM/H.QTY,10,2)))
		endif
		repl  RATE WITH H.rate
		if h.cash_disc#0
			repl rate with h.rate
		endif
******REPL RATE WITH h.rate
*!*	      repl disc1 with IIF(D.TYPE#'P',h.pd_perc,0)
		repl disc1 with h.pd_perc

*repl disc2 with iif(h.cash_disc=0,0,a.pdisc)
		repl disc2 with iif(h.cash_disc#0,h.disc_perc,0)
		if h.disc_perc=0 and h.cash_disc#0
			repl svdis with h.cash_disc
			repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,45)
		endif
		repl ssta with iif(a.cgst_amoun+a.cgst_amoun+a.igst_amoun=0,0,h.staxperc)
		repl cgst with iif(a.cgst_amoun+a.cgst_amoun+a.igst_amoun=0,0,h.ctaxperc)
		repl sssc with 0
*  repl misc4 with ''
		repl mrp with j.mrp
		repl half with 'A'
		repl godwon with d.godwon

**SALES
		if c.trsctype=42
			repl flg with 'G'
		else
**PURCHASE
			if c.trsctype=31 .or. c.trsctype=33
				repl flg with 'P'
			else
**SALES RETURN
				if c.trsctype=32
					repl flg with 'R'
				else
					if c.trsctype=41
						repl flg with 'G'
					else
						if c.trsctype=43
							repl flg with 'B'
						else
							if c.trsctype=52
								repl flg with 'Q'
							else
								if c.trsctype=73 .or. c.trsctype=44
									repl flg with 'L'
								else
									if c.trsctype=51
										repl flg with 'W'
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
		
		sele h
		skip
	enddo
***SALES RETURN/EXP IS ADJUSTED IN SALE BILL
	if a.ret_goods#0 .or. a.exp_goods#0
		sele b
		set order to 1
		seek c.inv_code
		do while b.adj_inv=c.inv_code .and. .not. eof()
			last = substr(str(itemcode,10)+space(10),1,10)
			sele j
			seek str(b.uniqueid,10)
			sele e
			seek last
			sele f
			seek str(b.taxcode,6)
			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl qty with b.qty
			repl free with b.freeqty
			repl batch with b.batchno
			repl exp with b.expiry
			repl rate with b.rate
			repl mrp with b.mrp
			repl half with 'A'
			repl disc1 with 0
			repl ssex with 0
			if b.trsc_type = 32
				repl flg with 'R'
				repl godwon with 'A'
			else
				if b.trsc_type = 51
					repl flg with 'W'
					repl godwon with 'Y'
					repl ssta with 0
					repl sssc with 0
				else
					if b.trsc_type = 43
						repl flg with 'B'
						repl godwon with 'A'
					else
						if b.trsc_type = 52
							repl flg with 'Q'
							repl godwon with 'Y'
							repl ssta with 0
							repl sssc with 0
						endif
					endif
				endif
			endif
			sele b
			skip
		enddo
	endif
	sele c
	skip
enddo
close table all

?'** for INVENTORY TRANSACTION (Challan) '
last4=last4+20
sele j
use &bat alias bat
index on str(uniqueid,10) to bat
sele f
use &tax alias tax
index on str(taxcode,6) to tax
sele e
use &pro alias pro
index on name to pro
sele c
use &sal1 alias sal1
sele a
use &sal2 alias sal2
index on str(trsc_type,2)+inv_code to sal2
sele h
use &sld alias sld11
index on str(trsc_type,2) + inv_code to sld11
sele d
use &mdis alias mdis
sele g
use &dis alias dis
sele sele(1)
use &datdev\support.&datext alias support
**42      -  Sales
**31 & 33 -  Purchase
**32      -  Sales Return
**43      -  Purchase Return
**44      -  Self Expiry/Breakage
**41      -  Delevery Challan
**51      -  Expiry Sales Return
**52      -  Expiry Purchase Return
**63      -  Location Transfer to
**73      -  Location Transfer From
**11      -  Free to Sample
**12      -  Saleble to Free

sele c
set filt to !(trsctype=82 .or. trsctype = 83 .or. trsctype = 84)
go top
do while .not. eof()
	lcd=' '
	lc= len(alltr(str(c->accountcod)))
	if lc<=6
		lcd=alltr(str(c->accountcod))
	else
		lcd=left(alltr(str(c->accountcod)),3)+right(alltr(str(c->accountcod)),3)
	endi
	if c.trsctype=41 .and. empty(c.inv_code)
		skip
		loop
	endif

	last1 = c.inv_code

	sele a
	seek str(c.trsctype,2)+c.inv_code

	sele d
	appe blank
*  repl misc3 with substr(misc3,1,53)+iif(c.vatbill=.t.,'T','R')+substr(misc3,55,100)
	repl codep with lcd
	if c.accountcod = 1
		repl codep with 'STACO3'
		repl docu with c.narration2
		repl docu1 with a.cashbillad
	endif

**SALES
	if c.trsctype=42
		repl type with 'S'
		repl vcn with c.inv_code
		repl date with c.invoicedat
		repl godwon with 'A'
		repl other with (a.crnote+a.add_amt)
		repl packing with -(a.drnote+a.less_amt)
	else
**PURCHASE
		if c.trsctype=31 .or. c.trsctype=33
			repl type with 'P'
			repl pm with c.docno
			repl lrda with c.invoicedat
			repl godwon with 'A'
*  Repl Other With -(a.disc)
			repl packing with -(a.drnote+a.less_amt)
			repl freight with a.octroi
			if !(c.paymentmod = 'N')
				repl vcn with c.inv_code
				repl date with c.invoicedat
			else
				repl challan with c.inv_code
				repl chdate with c.invoicedat
			endif
		else
**SALES RETURN
			if c.trsctype=32
				if !(c.paymentmod = 'N')
					repl type with 'R'
					repl vcn with c.inv_code
					repl date with c.invoicedat
					repl godwon with 'A'
					repl other with (a.crnote+a.add_amt)
					repl packing with -(a.drnote+a.less_amt)
				else
					repl type with 'R'
					repl challan with c.inv_code
					repl chdate with c.invoicedat
					repl godwon with 'A'
					repl other with (a.crnote+a.add_amt)
					repl packing with -(a.drnote+a.less_amt)
				endif
			else
**SALES CHALLAN
				if c.trsctype=41
					repl type with 'S'
					repl challan with c.inv_code
					repl chdate with c.invoicedat
					repl godwon with 'A'
					repl other with (a.crnote+a.add_amt)
					repl packing with -(a.drnote+a.less_amt)
				else
**PURCHASE RETURN
					if c.trsctype=43
						repl type with 'B'
						repl godwon with 'A'
						repl other with (a.crnote+a.add_amt)
						repl packing with -(a.drnote+a.less_amt)
						if !(c.paymentmod = 'N')
							repl vcn with c.inv_code
							repl date with c.invoicedat
						else
							repl challan with c.inv_code
							repl chdate with c.invoicedat
						endif
					else
**PURCHASE RETURN EXP/BRK
						if c.trsctype=52
							repl type with 'Q'
							repl vcn with c.inv_code
							repl date with c.invoicedat
							repl godwon with 'Y'
							repl other with (a.crnote+a.add_amt)
							repl packing with -(a.drnote+a.less_amt)
						else
							if c.trsctype=73 .or. c.trsctype = 44
								repl type with 'L'
								repl challan with c.inv_code
								repl chdate with c.invoicedat
								repl godwon with 'A'
								repl other with (a.crnote+a.add_amt)
								repl packing with -(a.drnote+a.less_amt)
								if c.trsctype = 44
									repl codep with 'STACsl'
								endif
							else
**SALES RETURN EXPIRY
								if c.trsctype=51
									if !(c.paymentmod = 'N')
										repl type with 'W'
										repl vcn with c.inv_code
										repl date with c.invoicedat
										repl godwon with 'Y'
										repl other with (a.crnote+a.add_amt)
										repl packing with -(a.drnote+a.less_amt)
									else
										repl type with 'W'
										repl challan with c.inv_code
										repl chdate with c.invoicedat
										repl godwon with 'Y'
										repl other with (a.crnote+a.add_amt)
										repl packing with -(a.drnote+a.less_amt)
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
	endif
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.amount)
	repl salun with ''
	repl staxun with 'SZTZOZ'

	if c.paymentmod='C'
		repl cash with c.amount
		repl round with a.round_off
	else
		repl final with c.amount
		repl round with a.round_off
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl mr with 'S'+str(c.salesmanco,5)
	repl duedays with 0
	repl addis with 0
	repl account with 'N'
	repl sale with 'Z'
	repl ltype with '5'
	repl discafter with 'N'
	repl remark4 with c.inv_code
	repl remark1 with str(c.amount,12,2)
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

	sele h
	seek '88' + c.inv_code
	if !found()
		sele d
		delete
		sele c
		skip
		loop
	endif
	do while str(h.trsc_type,2) = '88' .and. h.inv_code = c.inv_code .and. !eof()
		last = substr(str(icode,10)+space(10),1,10)

		sele e
		seek last

		sele f
		seek str(h.tax_code,6)

		sele j
		seek str(h.uniqueid,10)

		sele g
		appe blank
		if empty(d.challan)
			repl vcn with d.vcn
			repl date with d.date
		else
			repl vcn with d.challan
			repl date with d.chdate
		endif
		repl codep with d.codep
		repl voucher with d.voucher
		repl code with e.code
		repl tax with iif(h.cgst_amoun+h.sgst_amoun+h.igst_amoun=0,'E','T')
		repl qty with h.qty
		repl free with h.freeqty
		repl batch with j.batchno
		repl exp with j.expiry
		repl rate with h.rate
		repl disc1 with h.pd_perc
		repl disc2 with iif(h.cash_disc=0,0,a.pdisc)
		repl ssta with iif(a.cgst_amoun+a.cgst_amoun+a.igst_amoun=0,0,h.staxperc)
		repl cgst with iif(a.cgst_amoun+a.cgst_amoun+a.igst_amoun=0,0,h.ctaxperc)
		repl sssc with 0
		repl ssex with 0
*    repl misc4 with ''
		repl mrp with j.mrp
		repl half with 'A'
		repl godwon with d.godwon

**SALES
		if c.trsctype=42
			repl flg with 'G'
		else
**PURCHASE
			if c.trsctype=31 .or. c.trsctype=33
				repl flg with 'P'
			else
**SALES RETURN
				if c.trsctype=32
					repl flg with 'R'
				else
					if c.trsctype=41
						repl flg with 'G'
					else
						if c.trsctype=43
							repl flg with 'B'
						else
							if c.trsctype=52
								repl flg with 'Q'
							else
								if c.trsctype=73 .or. c.trsctype=44
									repl flg with 'L'
								else
									if c.trsctype=51
										repl flg with 'W'
										repl godwon with 'Y'
										repl ssta with 0
										repl cgst with 0
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
		sele h
		skip
	enddo
	sele c
	skip
enddo
close table all


?'** Transfer ACCOUNT FROM SALES RETURN'

af=datdev+'\gledger.'+datext
pend =datdev + '\pend.'+datext
mdis=datdev+ '\mdis.'+datext
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord
pending=datdev + '\pendings.'+datext
sele g
use &pending alias pending
index on ord+vcn to pending
sele f
use &pend alias pend
sele b
use &af alias gledger

sele sele(1)
use &datdev\slipno.&datext alias mslip
mvoucher=voucher+5
msvoucher=svoucher+4

slast5=msvoucher+10

sele d
use &mdis alias mdis
*set filt to VCN='SLV02113' 
go top
do while .not. eof()
	if !(type$'RW')
		skip
		loop
	endif
	=seek(codep,'ord')
	if vcn=space(12)
		skip
		loop
	endif
	last1=mdis.codep
	if mdis.final#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		repl cd with 'C'
		repl credit with mdis.final
		repl book with 'E'
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
		if old_3='Y'
*!*				**** for outstanding
*!*	  			sele adj
*!*			    seek subs(mdis.vcn,1,3)+str(val(subs(mdis.vcn,5)))+str(val(mdis.codep) )

*!*	  			if found()
*!*			       scan while subs(b_buk,1,3)+str(b_vchr_no)+str(b_acc_No)=subs(mdis.vcn,1,3)+str(val(subs(mdis.vcn,5)))+str(val(mdis.codep) )
*!*			       mVCn=subs(subs(b_buk_name,1,3)+"-"+alltrim(Str(b_bill_no))+space(20),1,20)
*!*			      **PEND
*!*			      sele f
*!*			      appe blank
*!*			      repl ord with mdis.codep
*!*			      repl ddate with MDIS.date
*!*			      repl vcn with mvcn
*!*			      repl final with -(adj.b_rcv_amt)
*!*			      **PENDINGS
*!*			      sele g
*!*			      seek f.ord+substr(f.vcn+space(20),1,20)
*!*			      if found()
*!*			         sele f
*!*			         repl type with 'A'
*!*			         repl voucher with mdis.voucher
*!*			         repl adjvoucher with g.voucher
*!*			         repl svoucher with g.svoucher
*!*			      endif
*!*	              sele f
*!*			    endscan
*!*	       else
			sele f
			appe blank
			repl ord with mdis.codep
			repl ddate with mdis.date
			repl duedays with mdis.duedays
			repl vcn with mdis.vcn
			if d.type$'RW'
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
		repl cd with 'C'
		repl credit with mdis.cash
		repl book with 'E'
		repl date with mdis.date
		repl code with 'STACO3'
		last1='STACO3'
		repl remark1 with mdis.vcn
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
		repl cd with 'D'
		repl debit with (mdis.final+mdis.cash)
		repl book with 'E'
		repl date with mdis.date
		if mdis.salun=space(6)
			repl code with 'SP#20 '
		else
			repl code with mdis.salun
		endif
		repl remark1 with mdis.vcn
		repl type with 'Y'
		repl code1 with last1
	endif
	sele d
	skip
enddo
sele mslip
repl voucher with mvoucher,svoucher with msvoucher
close table all


?'** Transfer ACCOUNT FROM SALES'

af  =datdev + '\gledger.'+datext
pend =datdev + '\pend.'+datext
mdis=datdev+ '\mdis.'+datext
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord
pending=datdev + '\pendings.'+datext
sele g
use &pending alias pending
index on ord+vcn to pending
sele f
use &pend alias pend
sele b
use &af alias gledger
sele sele(1)
use &datatransferpath\billoutdet alias bout
index on refinv_cod+str(accountcod) to bout

sele sele(1)
use &datdev\slipno.&datext alias mslip
mvoucher=voucher+5
msvoucher=svoucher+4

slast5=msvoucher+10


sele d
use &mdis alias mdis
*set filt to inlist(vcn,'SLV02113','SLV04198')
go top
do while .not. eof()
	if type$'RW'
		skip
		loop
	endif
	=seek(codep,'ord')
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
			if d.type='S'
				repl cd with 'D'
				repl debit with mdis.final
				repl book with 'S'
			endif
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
			MDISSVOUCHER=SLAST5
			sele MDIS
			if mdis.crno#0
				sele bout
				seek subs(mdis.vcn+space(16),1,16)+str(val(mdis.codep))
				Mcrnorem='' 
				mcrno=0
				first=0
				scan for entrytype='Z' WHILE 	refinv_cod+str(accountcod)=subs(mdis.vcn+space(16),1,16)+str(val(mdis.codep))
				   if first=0
				     mcrnorem=allt(inv_code)
				     first=1 
				   else
				     mcrnorem=mcrnorem+","+allt(inv_code)
				   endif 
				   mcrno=mcrno+amount     
					SELE PENDING
					SEEK MDIS.CODEP+SUBS(BOUT.INV_CODE+SPACE(20),1,20)
					sele pend
					appen blank
					repl ord with mdis.codep
					repl ddate with mdis.date
					repl duedays with mdis.duedays
					repl vcn with bout.inv_code
					if d.type='P'
						repl final with -bout.amount
					else
						repl final with abs(bout.amount)
					endif
					repl type with 'A'
					repl voucher with mdis.voucher
					repl adjvoucher with pending.voucher
					repl svoucher with pending.svoucher
             endscan
             sele mdis
             repl crnorem with mcrnorem
             repl crno with -mcrno
           endif  
			slast5=slast5+5
			sele g
			appe blank
			repl ord with mdis.codep
			repl ddate with mdis.date
			repl vcn with mdis.vcn
			repl invtype with 'I'
			repl voucher with MDIS.voucher
			repl duedays with mdis.duedays
			repl duedate with ddate+duedays
			repl final with mdis.final
			repl balance with mdis.final &&&&+mdis.crno
			repl svoucher with mdissvoucher   &&&f.svoucher
			repl name with iif(len(alltrim(mdis.vcn))=0,mdis->challan,mdis->vcn)
		endif

	endif
	if mdis.cash#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		if d.type='P'
			repl cd with 'C'
			repl credit with mdis.cash
			repl book with 'A'
		else
			if d.type='S'
				repl cd with 'D'
				repl debit with mdis.cash
				repl book with 'S'
			endif
		endif
		repl date with mdis.date
		repl code with 'STACO3'
		last1='STACO3'
		repl remark1 with mdis.vcn
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
		if d.type='S'
			repl cd with 'C'
			repl credit with (mdis.final+mdis.cash)
			repl book with 'S'
		else
			if d.type='P'
				repl cd with 'D'
				repl debit with (mdis.final+mdis.cash)
				repl book with 'A'
			endif
		endif
		repl date with mdis.date
		if mdis.salun=space(6)
			repl code with 'SP#20 '
		else
			repl code with mdis.salun
		endif
		repl remark1 with mdis.vcn
		repl type with 'Y'
		repl code1 with last1
	endif
	sele d
	skip
enddo
sele mslip
repl voucher with mvoucher,svoucher with msvoucher
sele b
close table all



*******

?'** Transfer ACCOUNT TRANSACTION'
af     =datdev + '\gledger.'+datext
bf     =datdev + '\slipno.'+datext
cf     =datatransferpath + 'ledger.dbf'
df     =datatransferpath + 'acctrsc.dbf'
ef     =datatransferpath + 'billoutdet.dbf'
pend   =datdev + '\pend.'+datext
pending=datdev + '\pendings.'+datext

sele g
use &pending alias pending
index on ord + substr(name,1,12) to rou2
last4 =last4 + 10
slast5=slast5+ 10
sele f
use &pend alias pend
sele b
use &af alias gledger

sele d
use &ef alias billo
index on substr(inv_code,1,10) + str(c_rowid,3) to billo

sele a
use &cf alias led
inde on inv_code to led
set filt to (trsctype=81 .or. trsctype=82 .or. trsctype=83 .or. trsctype=84) .and. c_rowid # 100
go top
last3='%%%%%%%%%%'
do while .not.eof()
	lcd=' '
	lc= len(alltr(str(a->accountcod)))
	if lc<=6
		lcd=alltr(str(a->accountcod))
	else
		lcd=left(alltr(str(a->accountcod)),3)+right(alltr(str(a->accountcod)),3)
	endi
	if a.inv_code # last3 .or. a.oppositeac # 0
		last4=last4+4
	endif

	last3=inv_code
	sele b
	appe blank
	repl voucher with last4
	if a.amount>0
		repl cd with 'C'
		repl credit with a.amount
	else
		if a.amount<0
			repl cd with 'D'
			repl debit with abs(a.amount)
		endif
	endif
	repl date with a.inv_date
	repl code with lcd&&str(a.accountcod,5)
	repl remark1 with a.narration1
	repl remark2 with a.narration2
	repl addfield1 with a.docno
	if a.trsctype=84
		repl book with 'J'
	else
		if a.trsctype=82
			repl book with 'R'
		else
			if a.trsctype=83
				repl book with 'P'
			endif
		endif
	endif

**** for outstanding
	if old_3='Y'
		sele d
		seek substr(a.inv_code,1,10) + str(a.c_rowid,3)
		do while substr(d.inv_code,1,10) = substr(a.inv_code,1,10) .and. str(d.c_rowid,3) = str(a.c_rowid,3) .and. .not. eof()

			if d.amount#0
				sele f
				appe blank
				repl ord with b.code
				repl ddate with b.date
				repl vcn with d.refinv_cod
&&&&&shailneder sir
				if a.trsctype=82
					if d.amount>0
						repl final with -d.amount
					else
						repl final with d.amount
					endif
				else
					if a.trsctype=83
						if d.amount>0
							repl final with d.amount
						else
							repl final with -d.amount
						endif
					endif
				endif
				sele g
				seek f.ord+substr(f.vcn,1,12)
				if found()
					sele f
					repl type with 'A'
					repl voucher with b.voucher
					repl adjvoucher with g.voucher
					repl svoucher with g.svoucher
				endif
			endif
			sele d
			skip
		enddo
	endif

**CONTRA ENTRY
	if a.oppositeac#0
		sele b
		appe blank
		repl voucher with last4

		if a.amount>0
			repl cd with 'D'
			repl debit with a.amount
		else
			if a.amount<0
				repl cd with 'C'
				repl credit with abs(a.amount)
			endif
		endif
		repl date with a.inv_date
		repl code with alltrim(str(a.oppositeac,5))
		repl remark1 with a.narration1
		repl remark2 with a.narration2
		repl addfield1 with a.docno
		if a.trsctype=84
			repl book with 'J'
		else
			if a.trsctype=82
				repl book with 'R'
			else
				if a.trsctype=83
					repl book with 'P'
				endif
			endif
		endif
	endif
	sele a
	skip
enddo
close table all



proc  rem_null
a = afields(arr)
for i = 1 to a
	mfldname = arr(i, 1)
	do case
	case inlist(arr(i,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(i,2), "B","N","I","F","Y","M")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(i,2), "D","T","M")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

proc getmail
store '' to mailid1,mailid2,mailid3
if !empt(fpcm.mrmail)
	mailid1=fpcm.mrmail
	if !empt(fpcm.asmmail)
		if empty(mailid1)
			mailid1=fpcm.asmmail
		else
			mailid2=fpcm.asmmail
		endif
		if !empty(fpcm.rsmmail)
			if empty(mailid1)
				mailid1=fpcm.rsmmail
			else
				if empty(mailid2)
					mailid2=fpcm.rsmmail
				else
					mailid3=fpcm.rsmmail
				endif
			endif
		endif
	endif
else
	if !empt(fpcm.asmmail)
		if empty(mailid1)
			mailid1=fpcm.asmmail
		else
			mailid2=fpcm.asmmail
		endif
		if !empty(fpcm.rsmmail)
			if empty(mailid1)
				mailid1=fpcm.rsmmail
			else
				if empty(mailid2)
					mailid2=fpcm.rsmmail
				else
					mailid3=fpcm.rsmmail
				endif
			endif
		endif
	else
		if !empty(fpcm.rsmmail)
			if empty(mailid1)
				mailid1=fpcm.rsmmail
			else
				if empty(mailid2)
					mailid2=fpcm.rsmmail
				else
					mailid3=fpcm.rsmmail
				endif
			endif
		endif
	endif
endif
