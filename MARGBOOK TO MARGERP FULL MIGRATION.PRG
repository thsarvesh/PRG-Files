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
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Feb\MB\dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
styp='W'
old_3 = 'Yes'
old_4 = 'Full Migration'
old_5 = firstdate
old_9 = lastdate
scalc='9'
pcalc='9'
outsonly='No '
old_12 = 'GST'
mtrade='FMCG'
mstatecode='01'
removenull = 'NO'
multimode='Yes'
mlinkid=space(30)
flinkid=space(30)
mychoice=1
=get_firm()
@01,5 say 'MARGBOOK TO MARGERP 9 + MIGRATION TOOL '  font 'ARIAL BOLD',12 color rgb(197,91,49)
@04,5 say 'COMPANY MASTER LINKID   :'  font 'COURIER new',12 get mlinkid font 'COURIER new',12
@05,5 say 'FINANCIAL YEAR LINKID   :'  font 'COURIER new',12 get flinkid font  'COURIER new',12
@06,5 say 'MARG BOOK Data Path     :'  font 'COURIER new',12 get datatransferpath font  'COURIER new',12
@07,5 say 'MARG BOOK Extension     :'  font 'COURIER new',12 get datatransferext  font  'COURIER new',12
@08,5 say 'WITH O/S                :'  font 'COURIER new',12 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'COURIER new',12
@09,5 say 'MIGRATION TYPE          :'  font 'COURIER new',12 get old_4 pict '@m Master,Full Migration' font 'COURIER new',12
@10,5 say 'F.Y.BEGIN FROM          :'  font 'COURIER new',12 get old_5  font 'COURIER new',12
@11,5 say 'F.Y.UP TO               :'  font 'COURIER new',12 get old_9  font 'COURIER new',12
@12,5 say 'PURCHASE CALCULATION    :'  font 'COURIER new',12 get pcalc pict '@m 2,9' font 'COURIER new',12
@13,5 say 'SALE CALCULATION        :'  font 'COURIER new',12 get scalc pict '@m 2,9' font 'COURIER new',12
@14,5 say 'SOFTWARE TYPE           :'  font 'COURIER new',12 get styp  pict '@m R,W'    font 'COURIER new',12
@15,5 say 'TRADE                   :'  font 'COURIER new',12 get mtrade  pict '@m FMCG,Pharma'    font 'COURIER new',12
@16,5 say 'State GST Code          :'  font 'COURIER new',12 get mstatecode   font 'COURIER new',12
@17,5 say 'Removenull              :'  font 'COURIER new',12 get removenull pict '@M No ,Yes'    font 'COURIER new',12
@18,5 say 'Type SURE               :'  font 'COURIER new',12 get sure pict '@x!'  font 'COURIER new',12
read
datatransferpath  = alltrim(datatransferpath)
datdev  = alltrim(datdev)
datext = alltrim(datext)
if lastkey()=27 or mychoice=2
	return
endif

*!*	release WINDOW wDataMigration
if type('FINALCP')#'U'
	=starttransfer()
endif
clear
rowno=5
@ 02,25 say 'Please Wait..Importing MARGBOOK Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datdev\subdis.&datext
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
use &datatransferpath\itemmaster alias fitm
set filt to complinkid=mlinkid
sele sele(1)
use &datatransferpath\unitmaster alias funit
set filt to complinkid=mlinkid
index on linkid to funit

sele sele(1)
use &datatransferpath\taxcategorymaster alias ftax
set filt to complinkid=mlinkid
index on salepurtypelinkid to ftax

sele sele(1)
use &datatransferpath\hsnmaster alias fhsn
set filt to complinkid=mlinkid
index on linkid to fhsn

sele sele(1)
use &datatransferpath\itemcompanymaster alias fcomp
set filt to complinkid=mlinkid
index on linkid to fcomp

sele sele(1)
use &datatransferpath\saltmaster alias fsalt
set filt to complinkid=mlinkid
index on linkid to fsalt

sele sele(1)
use &datatransferpath\categorymaster alias fcat
set filt to complinkid=mlinkid
index on linkid to fcat

sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
sele fitm
scan
	=seek(fitm.taxcategorylinkid,'ftax')
	=seek(fitm.hsnlinkid,'fhsn')
	=seek(fitm.itemcomplinkid,'fcomp')
	=seek(fitm.saltlinkid,'fsalt')
	=seek(fitm.categorylinkid,'fcat')
	sele mitm
	appen blank
	repl code with recno()
	repl name with fitm.itemcode
	repl product with chrtran(fitm.product,chr(0),'')
	repl packing with chrtran(fitm.packing,chr(0),'')
	repl billname with mitm.product+mitm.packing
	repl pack with fitm.conversion
	repl bookname with fitm.linkid
	repl unit with 'PCS'
	repl rackno with fitm.barcode
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with fitm.minimumquantity
	repl maximum with fitm.maximumquantity
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with ftax.sgst
	repl cgst   with ftax.cgst
	repl igst   with ftax.igst
	replace mrp with fitm.mrp
	replace prate with fitm.prate
	replace ratea with fitm.ratea,rateb with fitm.rateb,ratec with fitm.ratec,rated with fitm.rated,;
		ratee with fitm.ratee,ratef with fitm.ratef,rateg with fitm.rateg,rateh with fitm.rateh
	replace lprate with fitm.cost
	&&& HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(fhsn.hsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with fhsn.hsn,;
			mpcm.parnam with fhsn.hsn,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
	&&& COMPANY
	sele mpcm
	seek 'ZZZZZZ' + substr(fcomp.cname+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'CO'+alltrim(str(recno())),;
			mpcm.sname  with fcomp.cname,;
			mpcm.parnam with fcomp.cname,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
	&&& group
	sele mpcm
	seek 'SALT  ' + substr(fsalt.name+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'SA'+alltrim(str(recno())),;
			mpcm.sname  with fsalt.name,;
			mpcm.parnam with fsalt.name,;
			mpcm.tname with substr(fsalt.name,41,40),;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
	&&& CATEGORY
	sele mpcm
	seek 'CATEGO' + substr(fcat.name+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'CAT'+alltrim(str(recno())),;
			mpcm.sname  with fcat.name,;
			mpcm.parnam with fcat.name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode5 with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Store ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\storemaster alias fstore
set filt to complinkid=mlinkid and isdelete#1
sele sele(1)
use &datdev\saletype.&datext alias mpcm

sele fstore
go top
lstring=65
scan
	sele mpcm
	appen blank
	repl sgcode with 'GODWON'
	repl scode with chr(lstring)
	repl sname with 'M-'+fstore.storename
	repl parnam with 'M-'+fstore.storename
	repl tname with fstore.linkid
	lstring=lstring+1
endscan
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\batchmaster alias fsbal
set filt to complinkid=mlinkid 

sele sele(1)
use &datatransferpath\stocktransferheader alias stocktransferheader
sele sele(1)
use &datatransferpath\stocktransfer alias stocktransfer
update stocktransfer set stocktransfer.billdate=stocktransferheader.billdate from stocktransferheader ;
where transferheaderlinkid=stocktransferheader.linkid
set filt to complinkid=mlinkid and !INLIST(isdelete,1,2) ;
			and ctod(substr(billdate,9,2)+'/'+substr(billdate,6,2)+'/'+substr(billdate,1,4))<firstdate
			index on itemlinkid+parentbatchlinkid+fromstorelinkid to stocktransfer

sele sele(1)
use &datatransferpath\purchasechallanbill alias purchasechallanbill
sele sele(1)
use &datatransferpath\purchasechallanbilldetail alias purchasechallanbilldetail

update purchasechallanbilldetail set purchasechallanbilldetail.entrydate=purchasechallanbill.entrydate;
	   from purchasechallanbill where purchasechallanlinkid=purchasechallanbill.linkid &&&and purchasechallanbilldetail.datatype=20
set filt to complinkid=mlinkid and !INLIST(isdelete,1,2) ;
			and ctod(substr(entrydate,9,2)+'/'+substr(entrydate,6,2)+'/'+substr(entrydate,1,4))<firstdate
			index on itemlinkid+batchlinkid+storelinkid to purchasechallanbilldetail
&&&BROW FOR itemlinkid='7093391179109   '
sele sele(1)
use &datatransferpath\salechallanbill alias salechallanbill
sele sele(1)
use &datatransferpath\salechallanbilldetail alias salechallanbilldetail
update salechallanbilldetail set salechallanbilldetail.entrydate=;
ctod(substr(salechallanbill.billdate,9,2)+'/'+substr(salechallanbill.billdate,6,2)+'/'+substr(salechallanbill.billdate,1,4)) ;
from salechallanbill where salechallanbilldetail.salechallanlinkid=salechallanbill.linkid
set filt to complinkid=mlinkid and !INLIST(isdelete,1,2) and entrydate<firstdate
			index on itemlinkid+batchlinkid+storelinkid to salechallanbilldetail
&&&&BROW FOR itemlinkid='7093391179109   '

sele sele(1)
use &datdev\pro.&datext alias mitm
index on substr(bookname,1,20) to mitm

sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on substr(tname+space(20),1,20) to mpcm

sele sele(1)
use &datdev\probat.&datext alias msbal
index on substr(mycode,1,20)+batchno to msbal
sele fsbal
&&&&set filt to itemmasterlinkid='7093384786521'
go top
do while !eof()
	bstorelinkid=storelinkid
	sele mpcm
	seek substr(fsbal.storelinkid+space(20),1,20)
	mstorevar=alltri(scode)
	mopn=fsbal.openingquantity
	sele stocktransfer
	seek fsbal.itemmasterlinkid+fsbal.linkid+bstorelinkid
	sum (quantity) to gqty while itemlinkid=fsbal.itemmasterlinkid and parentbatchlinkid=fsbal.linkid and fromstorelinkid=bstorelinkid
	sele purchasechallanbilldetail
	seek fsbal.itemmasterlinkid+fsbal.linkid+fsbal.storelinkid
	sum iif(inlist(datatype,16,17,19),(quantity+free),0),iif(inlist(datatype,20,21,22,23),(quantity+free),0) to purcqty,pretqty while itemlinkid=fsbal.itemmasterlinkid and batchlinkid=fsbal.linkid and storelinkid=fsbal.storelinkid and ctod(substr(entrydate,9,2)+'/'+substr(entrydate,6,2)+'/'+substr(entrydate,1,4))<firstdate
	sele salechallanbilldetail
	seek fsbal.itemmasterlinkid+fsbal.linkid
	sum iif(inlist(datatype,13,2,5),(quantity+free),0),iif(inlist(datatype,7,4,8,6),(quantity+free),0) to salqty,sretqty while itemlinkid=fsbal.itemmasterlinkid and batchlinkid=fsbal.linkid and storelinkid=fsbal.storelinkid and entrydate<firstdate

	mbal=((mopn+purcqty+sretqty)-(pretqty+salqty))-gqty

	sele mitm
	seek substr(fsbal.itemmasterlinkid,1,20)
	sele msbal
	seek substr(fsbal.itemmasterlinkid,1,20)+ substr(fsbal.batchname+space(12),1,12)
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
			mycode with fsbal.itemmasterlinkid
			if old_4='F'
					repl msbal.opening with mbal
					repl msbal.o_&mstorevar with mbal
					repl msbal.b_&mstorevar with mbal
					repl msbal.balance with mbal
			else
				repl msbal.opening with fsbal.totalbalancequantity
				repl msbal.o_a with fsbal.totalbalancequantity
				repl msbal.b_a with fsbal.totalbalancequantity
				repl msbal.balance with fsbal.totalbalancequantity
			endif
			repl msbal.batchno with iif(mtrade='F',str(val(fsbal.batchname),9,2),(fsbal.batchname))
		repl msbal.exp with ctod(substr(fsbal.expirydate,9,2)+'/'+substr(fsbal.expirydate,6,2)+'/'+substr(fsbal.expirydate,1,4))
		repl msbal.mrp with fsbal.mrp,;
			msbal.prate with 0.00
		replace ratea with fsbal.ratea,rateb with fsbal.rateb,ratec with fsbal.ratec,rated with fsbal.rated,;
			ratee with fsbal.ratee,ratef with fsbal.ratef,rateg with fsbal.rateg,rateh with fsbal.rateh
		replace msbal.lprate with fsbal.costperpcs,;
			msbal.mrp with fsbal.mrp,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
		repl msbal.supinvo with fsbal.purchasebillno
		repl msbal.supdat with fsbal.billdate
	else
			if old_4='F'
				repl msbal.opening with opening+mbal
				repl msbal.o_&mstorevar with o_&mstorevar+ mbal
				repl msbal.b_&mstorevar with b_&mstorevar+mbal
				repl msbal.balance with balance+mbal
			else
				repl msbal.opening with opening+fsbal.totalbalancequantity
				repl msbal.o_a with o_a+fsbal.totalbalancequantity
				repl msbal.b_a with b_a+fsbal.totalbalancequantity
				repl msbal.balance with balance+fsbal.totalbalancequantity
			endif
	endif
	sele fsbal
	skip
enddo
sele msbal
close table all
if styp='R'
	@rowno,10 say '**** Importing Patient Master  ****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\patientmaster alias fpat
	set filt to complinkid=mlinkid

	sele sele (1)
	use &datdev\maorder.&datext alias mdoc
	set filt to scode='PET#$~'
	dele all
	pack
	index on scode to mdoc
	sele fpat
	go top
	scan
		sele mdoc
		append blank
		repl mdoc.scode with 'PET#$~',;
			mdoc.parnam with fpat.name,;
			mdoc.city with (fpat.address),;
			mdoc.form with alltrim(fpat.mobileno)
	endscan
	close data all
	@rowno,10 say '**** Importing Patient Master  ****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\doctormaster alias fdoc
	set filt to complinkid=mlinkid
	sele sele (1)
	use &datdev\maorder.&datext alias mdoc
	set filt to scode='PRE#$~'
	dele all
	pack
	index on scode to mdoc
	sele fdoc
	go top
	scan
		sele mdoc
		append blank
		repl mdoc.scode with 'PRE#$~',;
			mdoc.parnam with fdoc.name,;
			mdoc.form with alltrim(fdoc.mobileno)
	endscan
	close data all
endif
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ledgermaster alias fact
set filt to complinkid=mlinkid
sele sele(1)
use &datatransferpath\accountgroupmaster alias fgrp
*set filt to complinkid=mlinkid
index on linkid to fgrp
sele sele(1)
use &datatransferpath\stationmaster alias fcity
set filt to complinkid=mlinkid
index on linkid to fcity

sele sele(1)
use &datatransferpath\accountingdetails alias accountingdetails
set filt to complinkid=mlinkid and !inlist(isdelete,1,2) and ;
			ctod(substr(billdate,9,2)+'/'+substr(billdate,6,2)+'/'+substr(billdate,1,4))<firstdate
index on ledgerlinkid to accountingdetails

sele sele(1)
use &datatransferpath\areamaster alias farea
set filt to complinkid=mlinkid
index on linkid to farea

sele sele (1)
use &datatransferpath\routemaster alias frout
set filt to complinkid=mlinkid
index on linkid to frout

sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan 
	=seek(fact.arealinkid,'farea')
	=seek(fact.routlinkid,'frout')
	=seek(fact.accountgrouplinkid,'fgrp')
	=seek(fact.stationlinkid,'fcity')
	sele mact
	appen blank
	wacctgroup=''
	wgroupcode=''
	parentgrup=''
	wcurrentaccount=alltrim(upper(fgrp.name))
	do case
		case 'BRANCH'$wcurrentaccount or 'DIVISION'$wcurrentaccount
			wgroupcode='A '
		case 'CAPITAL'$wcurrentaccount and ('A/C'$wcurrentaccount or 'ACCOUNT'$wcurrentaccount)
			wgroupcode='B '
		case 'RESERVE'$wcurrentaccount and 'SURPLUS'$wcurrentaccount
			wgroupcode='B '
		case 'CURRENT ASSET'$wcurrentaccount
			wgroupcode='C '
		case 'FIXED'$wcurrentaccount and 'ASSET'$wcurrentaccount
			wgroupcode='E '
		case 'INVESTMENT'$wcurrentaccount
			wgroupcode='F   '
		case 'CURRENT LIABILIT'$wcurrentaccount
			wgroupcode='D '
		case ('DUTY'$wcurrentaccount or 'DUTIES'$wcurrentaccount) and 'TAXES'$wcurrentaccount
			wgroupcode='D '
		case 'SALES TAX'$wcurrentaccount and 'CENTRAL'$wcurrentaccount
			wgroupcode='D11'
		case 'SALES TAX'$wcurrentaccount and 'LOCAL'$wcurrentaccount
			wgroupcode='D12 '
		case 'PROVISIONS'$wcurrentaccount
			wgroupcode='D  '
		case 'LOAN' $wcurrentaccount and 'LIABILITY' $wcurrentaccount
			wgroupcode='G   '
		case 'MISC. EXPENSES' $wcurrentaccount and 'ASSET'$wcurrentaccount
			wgroupcode='H   '
		case 'PROFIT & LOSS A/C'$wcurrentaccount
			wgroupcode='I   '
		case 'REVENUE'$wcurrentaccount
			wgroupcode='J   '
		case 'SUNDRY CREDITOR'$wcurrentaccount
			wgroupcode='D31 '
		case 'SUPPLIER'$wcurrentaccount or 'VENDOR'$wcurrentaccount
			wgroupcode='D31 '
		case 'SUNDRY DEBTOR'$wcurrentaccount or 'CUSTOMER'$wcurrentaccount
			wgroupcode='C6 '
		case 'DEPOSITS'$wcurrentaccount
			wgroupcode='C3 '
		case 'INVESTMENT'$wcurrentaccount
			wgroupcode='F '
		case "BANK"$wcurrentaccount and 'ACCOU'$wcurrentaccount and !('ODD'$wcurrentaccount) and !('OCC'$wcurrentaccount)
			wgroupcode='C1   '
		case "CASH"$wcurrentaccount and 'IN'$wcurrentaccount and 'HAND'$wcurrentaccount
			wgroupcode='C2   '
			wgroupcode='C2   '
			parentgrup='C '
		case "STOCK" $ wcurrentaccount and ('CURRENT'$wcurrentaccount or 'IN-HAND'$wcurrentaccount or 'IN HAND'$wcurrentaccount)
			wacctgroup='C5 '
			wgroupcode='C   '
			parentgrup='C '
		case "BANK OD A/C" $wcurrentaccount or "BANK OCC A/C" $wcurrentaccount
			wgroupcode="G1 "
		case "LOAN" $wcurrentaccount and "ADVANCE" $wcurrentaccount
			wgroupcode="C4  "
		case "SECURED LOAN" $wcurrentaccount
			wgroupcode="G2  "
		case "UNSECURED LOAN" $wcurrentaccount
			wgroupcode="G3  "
		case "DIRECT" $wcurrentaccount and !("INDIRECT"$wcurrentaccount)
			if "INCOME"$wcurrentaccount
				wgroupcode="J3 "
			endif
			if "EXPENSE" $wcurrentaccount
				wacctgroup='J11 '
				wgroupcode="J1  "
				parentgrup='J1 '
			endif
		case "INDIRECT" $wcurrentaccount
			if "INCOME" $wcurrentaccount
				wgroupcode="J4 "
			endif
			if "EXPENSE" $wcurrentaccount
				wgroupcode="J12  "
			endif
		case 'SALE'$wcurrentaccount
			if "CENTRAL"$wcurrentaccount or "CST"$wcurrentaccount
				wgroupcode='J61  '
			else
				wgroupcode='J62  '
			endif
		case 'PURCHASE'$wcurrentaccount
			if "CENTRAL"$wcurrentaccount or "CST"$wcurrentaccount
				wgroupcode="J51  "
			else
				wgroupcode="J52  "
			endif
		otherwise
	endcase
	repl mact.scode with wgroupcode
	repl mact.rate with 'Y'
	repl mact.ordno with 'A'+alltri(str(recno()))
	repl mact.fax2 with fact.linkid
	repl mact.margcode with fact.linkid
	repl mact.parnam  with fact.ledgername
	repl mact.mailnam with fact.mailto
	repl mact.paradd with fact.address1
	repl mact.paradd1 with fact.address2
	repl mact.paradd2 with fact.address3
	repl mact.city with fcity.stationname
	repl mact.dsm with fact.postalcode
	repl mact.confir with fact.firstname
	repl mact.desi with fact.designation
	repl mact.phone1 with fact.phoneno
	repl mact.phone2 with fact.mobile2
	repl mact.phone4 with fact.mobile1
	repl mact.gstno with fact.gstno
	repl mact.stno with fact.vatno
	repl itno with fact.panno
	repl mact.dlno with fact.dlno
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	sele accountingdetails
	seek fact.linkid
	sum iif(creditordebit=1,amount,0),iif(creditordebit=2,amount,0) to tdr,tcr while ledgerlinkid=fact.linkid
	sele mact
*!*		if tdr-tcr#0
*!*			repl mact.opning with tdr-tcr
*!*		else
		repl mact.opning with iif(fact.openingiscreditdebit=2,-fact.opening,fact.opening)
*!*		endif
	***STATE
	sele support
	appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	&&&&&area
	sele mpcm
	seek 'AREA  ' + substr(farea.areaname+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'AREA  ',;
			mpcm.scode  with 'AR'+alltrim(str(recno())),;
			mpcm.sname  with farea.areaname,;
			mpcm.parnam with farea.areaname,;
			mpcm.tcode with 'No'
	endif
	repl mact.area with mpcm.scode
	&&&&&rout
	sele mpcm
	seek 'ROUT  ' + substr(frout.routename+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ROUT  ',;
			mpcm.scode  with 'RO'+alltrim(str(recno())),;
			mpcm.sname  with frout.routename,;
			mpcm.parnam with frout.routename,;
			mpcm.tcode with 'No'
	endif
	repl mact.rout with mpcm.scode

endscan
close tables all

*!*	@rowno,10 say '**** Importing A/C Outstandings  ****' font 'Arial',10
*!*	rowno=rowno+1
*!*	sele sele(1)
*!*	use &datdev\pendings.&datext alias mpend
*!*	sele sele(1)
*!*	use &datdev\order.&datext alias mord
*!*	inde on substr(margcode,1,20) to mord

*!*	sele sele(1)
*!*	use &datatransferpath\salechallanbill alias sal
*!*	set filt to complinkid=mlinkid
*!*	index on linkid to sal
*!*	sele sele(1)
*!*	use &datatransferpath\purchasechallanbill alias pur
*!*	set filt to complinkid=mlinkid
*!*	index on linkid to pur
*!*	sele sele(1)
*!*	use &datdev\slipno.&datext alias mslip
*!*	sele sele(1)
*!*	use &datatransferpath\outstanding alias fout
*!*	if old_4='F'
*!*		set filt to complinkid=mlinkid and datatype=101
*!*	else
*!*		set filt to complinkid=mlinkid
*!*	endif
*!*	sele mslip
*!*	go top
*!*	vou =voucher  + 10
*!*	svou=svoucher + 10
*!*	sele fout
*!*	go top
*!*	scan
*!*		mvcn=''
*!*		if seek(fout.saleorpurchaselinkid,'sal')
*!*			mvcn=alltr(sal.entryno)
*!*		endif
*!*		if seek(fout.saleorpurchaselinkid,'pur')
*!*			mvcn=alltr(pur.partybillno)
*!*		endif
*!*		mdate=ctod(substr(fout.billdate,9,2)+'/'+substr(fout.billdate,6,2)+'/'+substr(fout.billdate,1,4))
*!*		sele mord
*!*		seek substr(fout.ledgerlinkid+space(20),1,20)
*!*		sele mpend
*!*		appen blan
*!*		repl acgroup with mord->scode
*!*		repl ord with mord.ordno
*!*		repl ddate with mdate
*!*		repl vcn with iif(empty(mvcn),'Opening',mvcn)
*!*		repl invtype with 'O'
*!*		repl voucher  with vou
*!*		repl svoucher with svou
*!*		repl final   with iif(fout.creditordebit=2,-abs(fout->totalamount),abs(fout->totalamount))
*!*		repl balance with iif(fout.creditordebit=2,-abs(fout.balanceamount),abs(fout.balanceamount))
*!*		repl itemope with iif(fout.creditordebit=2,-abs(fout->receiveamount),abs(fout->receiveamount))
*!*		repl name with vcn
*!*		vou=vou+5
*!*		svou=svou+5
*!*	endsc
*!*	sele mslip
*!*	repl voucher  with vou+5
*!*	repl svoucher with svou+5
*!*	close table all

*!*	@rowno,10 say '**** Importing Ledger Balance  ****' font 'Arial',10
*!*	rowno=rowno+1
*!*	sele sele(1)
*!*	use &datdev\order.&datext alias mord
*!*	inde on ordno to mord
*!*	sele sele(1)
*!*	use &datdev\pendings.&datext alias mpend
*!*	inde on ord to mpend
*!*	sele mord
*!*	go top
*!*	scan
*!*		sele mpend
*!*		seek mord->ordno
*!*		sum balance to mbal whil ord=mord->ordno and !eof()
*!*		sele mord
*!*		repl opning with iif(mbal#opning,opning,mbal)
*!*	endsc
*!*	clos table all

if old_4='F'
	do inward_trf
	do outward_trf
	do godwontrf
	do invertory_voucher
	do account_voucher
endif


proce inward_trf
	@rowno,10 say '**** Importing Purchase Transactions  ****' font 'Arial',10
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
	index on substr(bookname,1,20) to pro
	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on substr(margcode+space(20),1,20) to ord
	sele sele(1)
	use &datdev\dis.&datext alias dis
	sele sele(1)
	use &datdev\mdis.&datext alias mdis
	sele sele(1)
	use &datdev\probat.&datext alias prb
	index on substr(mycode,1,20)+batchno to prb
	sele sele(1)
	use &datdev\subdis.&datext alias msub
	
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20
	sele sele(1)
	use &datatransferpath\batchmaster alia fsbal
	set filte to complinkid=mlinkid and isdelete#1
	index on itemmasterlinkid+linkid to fsbal
	sele sele(1)
	use &datatransferpath\accountingdetails alia foth
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2)
	index on saleorpurchaselinkid to foth
	sele sele(1)
	use &datatransferpath\purchasechallanbill alia pur
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2)and financialyearlinkid=flinkid
	sele sele(1)
	use &datatransferpath\purchasechallanbilldetail alia pld
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2) and financialyearlinkid=flinkid
	index on purchasechallanlinkid to pld
	i=1
	sele pur
	go top
	scan for !inlist(isdelete,1,2)
		l_entrydate=ctod(substr(pur.entrydate,9,2)+'/'+substr(pur.entrydate,6,2)+'/'+substr(pur.entrydate,1,4))
		l_billdate=ctod(substr(pur.partysalebilldate,9,2)+'/'+substr(pur.partysalebilldate,6,2)+'/'+substr(pur.partysalebilldate,1,4))
		l2='P-'+padl(i,6,'0')
		l3=partybillno
		i=i+1
		=seek(substr(pur.partyinfolinkid+space(20),1,20),'ord')
		sele mdis
		appen blan
		do case
			case pur.datatype=16
				repl type with 'P'
				repl pm with l3
				repl challan with l2
				repl chdate with l_entrydate
				repl lrda with l_billdate
			case inlist(pur.datatype,17)
				repl type with 'P'
				repl vcn with l2
				repl pm with l3
				repl date with l_entrydate
				repl lrda with l_billdate
			case pur.datatype=18
				repl type with 'X'
				repl challan with l3
				repl chdate with l_entrydate
				repl lrda with l_billdate
			case pur.datatype=23
				repl type with 'Q'
				repl pm with l2
				repl challan with l3
				repl chdate with l_entrydate
				repl lrda with l_billdate
			case pur.datatype=22
				repl type with 'Q'
				repl vcn with l3
				repl pm with l2
				repl date with l_entrydate
				repl lrda with l_billdate
			case pur.datatype=21
				repl type with 'B'
				repl challan with l3
				repl pm with alltri(sal.partybillno)
				repl chdate with l_entrydate
				repl lrda with l_billdate
			case pur.datatype=20
				repl type with 'B'
				repl vcn with l3
				repl pm with l3
				repl date with l_entrydate
				repl lrda with l_billdate
			case pur.datatype=19
				repl type with 'D'
				repl challan with l2
				repl pm with l3
				repl chdate with l_entrydate
				repl lrda with l_billdate
		endcase
		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
		repl codep with ord.ordno
		repl ltype with pcalc

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
		repl other with 0
		repl pacun with ''
		repl packing with 0
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
			isigst=1
		endi
		repl amountp with pur.totalinvoiceamount
		repl final with pur.totalinvoiceamount
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		&&other expenses
		sele foth
		seek pur.linkid
		scan for isadditionalexp=1  while saleorpurchaselinkid=pur.linkid
			=seek(substr(ledgerlinkid+space(20),1,20),'ord')
			if mdis.packing=0
				repl mdis.pacun with ord.ordno
				repl mdis.packing with iif(creditordebit=1,foth.amount,-foth.amount)
			else
				if mdis.other =0
					repl mdis.othun with ord.ordno
					repl mdis.other with iif(creditordebit=1,foth.amount,-foth.amount)
				else
					repl mdis.freun with ord.ordno
					repl mdis.freight with iif(creditordebit=1,foth.amount,-foth.amount)
				endi
			endi
		endsc
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

		sele pld
		seek pur.linkid
		scan while purchasechallanlinkid=pur.linkid
			=seek(substr(pld.itemlinkid,1,20),'pro')
			=seek(pld.itemlinkid+pld.batchlinkid,'fsbal')
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl batch with iif(mtrade='F',str(val(fsbal.batchname),9,2),(fsbal.batchname))
			repl exp with ctod(substr(fsbal.expirydate,9,2)+'/'+substr(fsbal.expirydate,6,2)+'/'+substr(fsbal.expirydate,1,4))
			repl pack with pro.pack
			repl rate with  pld.purchaserate
		&&&	repl exp with prb.exp
			repl mrp with  pld.mrp
			repl qty with pld.quantity
			repl free with pld.free
			repl disc1 with pld.discount1
			repl disc2 with pld.discount2
			repl svdis with pld.volumediscount1
			repl svdis1 with pld.volumediscount2
			repl flg with iif(mdis.type='S','G',mdis.type)
			repl tax with 'T'
			if isigst=1
				repl ssta with pld.igstper
			else
				repl ssta with pld.sgstper
				repl cgst with pld.cgstper
			endi
			repl half with 'A'
			repl godwon with mdis->godwon
		endsc
		pbildis=pur.billdiscountinamount+pur.discount1amount+pur.discount2amount+pur.volumedisc1amount+pur.volumedisc2amount
	sele mdis
	repl misc3 with substr(misc3,1,54)+str(pbildis,10,2)+substr(misc3,65,100)

	endsc
	sele sele(1)
	sele mslip
	go top
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all
	retu


proce outward_trf
	@rowno,10 say '**** Importing Sale Transactions  ****' font 'Arial',10
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
	index on substr(bookname,1,20) to pro
	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on substr(margcode+space(20),1,20) to ord
	sele sele(1)
	use &datdev\dis.&datext alias dis
	sele sele(1)
	use &datdev\mdis.&datext alias mdis
	sele sele(1)
	use &datdev\probat.&datext alias prb
	index on substr(mycode,1,20)+batchno to prb
	sele sele(1)
	use &datdev\subdis.&datext alias msub
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20
	if styp='R'
		sele sele(1)
		use &datatransferpath\patientmaster alia fpat
		set filte to complinkid=mlinkid
		index on linkid to fpat
		sele sele(1)
		use &datatransferpath\doctormaster alia fdoc
		set filte to complinkid=mlinkid
		index on linkid to fdoc
	endif
	sele sele(1)
	use &datatransferpath\batchmaster alia fsbal
	set filte to complinkid=mlinkid
	index on itemmasterlinkid+linkid to fsbal

	sele sele(1)
	use &datatransferpath\accountingdetails alia foth
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2)
	index on saleorpurchaselinkid to foth

	sele sele(1)
	select * from foth into curs sal2 readwr
	set filte to complinkid=mlinkid and datatype=59 and creditordebit=1 and !inlist(isdelete,1,2)
	index on saleorpurchaselinkid to sal2

	sele sele(1)
	use &datatransferpath\salechallanbill alia sal
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2) and financialyearlinkid=flinkid

	sele sele(1)
	use &datatransferpath\salechallanbilldetail alia sld
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2) &&&&and FinancialYearLinkId=flinkid
	index on salechallanlinkid to sld

	sele sal
	go top
	scan for !inlist(isdelete,1,2)
		f_saledate=ctod(substr(sal.billdate,9,2)+'/'+substr(sal.billdate,6,2)+'/'+substr(sal.billdate,1,4))
		f_lrdate=ctod(substr(sal.deliverydate,9,2)+'/'+substr(sal.deliverydate,6,2)+'/'+substr(sal.deliverydate,1,4))
		l3 = entryno
		=seek(substr(sal.partyinfolinkid+space(20),1,20),'ord')
		sele mdis
		appen blan
		do case
			case sal.datatype=1
				repl type with 'S'
				repl challan with l3
				repl chdate with f_saledate
				repl pm with l3
			case inlist(sal.datatype,2,9)
				repl type with 'S'
				repl vcn with right(alltri(l3),12)
				repl date with f_saledate
				repl pm with l3
			case sal.datatype=3
				repl type with 'V'
				repl challan with l3
				repl chdate with f_saledate
				repl pm with l3
			case sal.datatype=7
				repl type with 'W'
				repl challan with l3
				repl chdate with f_saledate
				repl pm with alltri(sal.partybillno)
				repl lrda with f_saledate
			case sal.datatype=4
				repl type with 'W'
				repl vcn with l3
				repl date with f_saledate
				repl pm with alltri(sal.partybillno)
				repl lrda with f_lrdate
			case sal.datatype=8
				repl type with 'R'
				repl challan with l3
				repl chdate with f_saledate
				repl pm with alltri(sal.partybillno)
				repl lrda with f_lrdate
			case sal.datatype=6
				repl type with 'R'
				repl vcn with alltri(l3)
				repl date with f_saledate
				repl pm with alltri(sal.partybillno)
				repl lrda with f_lrdate
			case sal.datatype=5
				repl type with 'L'
				repl challan with l3
				repl chdate with f_saledate
		endcase
		repl pm with l3
		repl lrda with f_lrdate
		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
		repl codep with ord.ordno
		repl ltype with scalc
		repl voucher with last4
		last4=last4+5
		repl rout with ' '
		repl area with ' '
		repl addis with sal.billdiscountinpercent
		repl sale with 'Z'
		repl account with 'N'
		repl godwon with 'A'
		repl discafter with 'M'
		repl othun with 'STAC23'
		repl other with 0
		repl pacun with ''
		repl packing with 0
		if styp='R'
			if seek(sal.patientlinkid,'fpat')
				repl docu with substr(fpat.mobileno+space(10),1,10)+alltri(fpat.name)
			else
				repl docu with space(10)+alltri(sal.patientname)
			endif
			if seek(sal.doctorlinkid,'fdoc')
				repl docu1 with substr(alltri(fdoc.mobileno)+space(10),1,10)+alltri(fdoc.name)
			else
				repl docu1 with space(10)+alltri(sal.doctorname)
			endif
		endif
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
			isigst=1
		endi
		repl misc3 with substr(misc3,1,54)+str(sal.totaldiscount,10,2)+substr(misc3,65,100)
		repl sale with 'ZYNYNGAYUN1N1INN M       '
		repl amountp with sal.totalinvoiceamount
		repl final with sal.totalinvoiceamount
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		&&other expenses
		sele foth
		seek sal.linkid
		scan for isadditionalexp=1  while saleorpurchaselinkid=sal.linkid
			=seek(substr(ledgerlinkid+space(20),1,20),'ord')
			if mdis.packing=0
				repl mdis.pacun with ord.ordno
				repl mdis.packing with iif(creditordebit=2,foth.amount,-foth.amount)
			else
				if mdis.other =0
					repl mdis.othun with ord.ordno
					repl mdis.other with iif(creditordebit=2,foth.amount,-foth.amount)
				else
					repl mdis.freun with ord.ordno
					repl mdis.freight with iif(creditordebit=2,foth.amount,-foth.amount)
				endi
			endi
		endsc
		if multimode='Y'
			sele mdis
			repl misc3 with substr(misc3,1,34)+'M'+substr(misc3,36,100)
			sele sal2
			seek sal.linkid
			scan while saleorpurchaselinkid=sal.linkid
				=seek(substr(sal2.ledgerlinkid+space(20),1,20),'ord')
				sele msub
				appen blank
				repl codep with mdis.codep
				repl vcn with mdis.vcn
				repl date with mdis.date 
				repl voucher with mdis.voucher
				repl type with 'V'
				repl dsm with 'REMARK'
				repl rtqt with substr(ord.ordno+space(6),1,6)+str(abs(sal2.amount),12,2)
			endscan
		endi
		
		
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

		sele sld
		seek sal.linkid
		scan while salechallanlinkid=sal.linkid
			=seek(substr(sld.itemlinkid,1,20),'pro')
			=seek(sld.itemlinkid+sld.batchlinkid,'fsbal')
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl batch with iif(mtrade='F',str(val(fsbal.batchname),9,2),(fsbal.batchname))
			repl exp with ctod(substr(fsbal.expirydate,9,2)+'/'+substr(fsbal.expirydate,6,2)+'/'+substr(fsbal.expirydate,1,4))
			repl pack with pro.pack
			repl rate with  sld.salerate
			&&repl exp with prb.exp
			repl mrp with  sld.mrp
			repl qty with sld.quantity
			repl free with sld.free
			repl svdis with sld.voldiscount1
			repl svdis1 with sld.voldiscount2
			repl disc1 with sld.discount1
			repl disc2 with sld.discount2
			repl flg with iif(mdis.type='S','G',mdis.type)
			*!*			repl misc4 with substr(misc4,1,32)+'1'+substr(misc4,34,100)
			repl tax with 'T'
			if isigst=1
				repl ssta with sld.igstper
			else
				repl ssta with sld.sgstper
				repl cgst with sld.cgstper
			endi
			repl half with 'A'
			repl godwon with mdis->godwon
		endscan
		bildis=sal.billdiscountinamount+sal.discount1amount+sal.discount2amount+sal.volumedisc1amount+sal.volumedisc2amount
		sele mdis
		repl misc3 with substr(misc3,1,54)+str(bildis,10,2)+substr(misc3,65,100)
	endsc
	sele mslip
	go top
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all
	retu

proce godwontrf
	@rowno,10 say '**** Importing Store Transfer  ****' font 'Arial',10
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
	index on substr(bookname,1,20) to pro
	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on substr(margcode+space(20),1,20) to ord
	sele sele(1)
	use &datdev\dis.&datext alias dis
	sele sele(1)
	use &datdev\mdis.&datext alias mdis
	sele sele(1)
	use &datdev\probat.&datext alias prb
	index on substr(mycode,1,20)+batchno to prb

	sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode+sname to mpcm
	sele sele(1)
	use &datdev\subdis.&datext alias msub
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20
	sele sele(1)
	use &datatransferpath\batchmaster alia fsbal
	set filte to complinkid=mlinkid
	index on itemmasterlinkid+linkid to fsbal

	sele sele(1)
	use &datatransferpath\storemaster alia store
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2)
	inde on linkid to store

	sele sele(1)
	use &datatransferpath\StockTransferheader alia stmdis
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2) and between(ctod(substr(billdate,9,2)+'/'+substr(billdate,6,2)+'/'+substr(billdate,1,4)),firstdate,lastdate)
	sele sele(1)
	use &datatransferpath\StockTransfer alia stdis
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2) &&&&and FinancialYearLinkId=flinkid
	index on transferheaderlinkid to sld

	sele stmdis
	go top
	scan for !inlist(isdelete,1,2)
		trandate=ctod(substr(billdate,9,2)+'/'+substr(billdate,6,2)+'/'+substr(billdate,1,4))
		l3 = invoiceno
		sele mdis
		appen blan
		repl type with 'L'
		repl challan with right(alltri(l3),12)
		repl chdate with trandate
		repl pm with l3
		repl lrda with trandate
		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
		repl codep with 'STACgo'
		repl ltype with scalc
		repl voucher with last4
		last4=last4+5
		repl rout with ' '
		repl area with ' '
		repl addis with 0
		repl sale with 'Z'
		repl account with 'N'
			if seek(stmdis.fromstorelinkid,'store')
				=seek('GODWON'+substr('M-'+store.storename+space(40),1,40),'mpcm')
				sele mdis
				repl godwon with mpcm.scode
			endif
			if seek(stmdis.tostorelinkid,'store')
				=seek('GODWON'+substr('M-'+store.storename+space(40),1,40),'mpcm')
				sele mdis
				repl discafter with mpcm.scode
			endif
		repl othun with 'STAC23'
		repl other with 0
		repl pacun with ''
		repl packing with 0
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
			isigst=1
		endi
*!*			repl misc3 with substr(misc3,1,54)+str(sal.totaldiscount,10,2)+substr(misc3,65,100)
		repl sale with 'ZYNYNGAYUN1N1INN M       '
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

		sele stdis
		seek stmdis.linkid
		scan while transferheaderlinkid=stmdis.linkid
			=seek(substr(stdis.itemlinkid,1,20),'pro')
			=seek(stdis.itemlinkid+stdis.batchlinkid,'fsbal')
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl batch with iif(mtrade='F',str(val(fsbal.batchname),9,2),(fsbal.batchname))
			repl exp with ctod(substr(fsbal.expirydate,9,2)+'/'+substr(fsbal.expirydate,6,2)+'/'+substr(fsbal.expirydate,1,4))
			repl pack with pro.pack
			repl rate with  stdis.salepurchaserate
			repl mrp with  fsbal.mrp
			repl qty with stdis.quantity
			repl free with stdis.free
			repl flg with 'L'
			repl godwon with mdis.godwon
			repl tax with 'T'
			repl half with 'A'
			repl godwon with mdis->godwon
		endscan
		sele stdis
		seek stmdis.linkid
		scan while transferheaderlinkid=stmdis.linkid
			=seek(substr(stdis.itemlinkid,1,20),'pro')
			=seek(stdis.itemlinkid+stdis.batchlinkid,'fsbal')
			sele dis
			appen blan
			repl codep with mdis->codep
			repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
			repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
			repl voucher with mdis->voucher
			repl code with pro.code
			repl batch with iif(mtrade='F',str(val(fsbal.batchname),9,2),(fsbal.batchname))
			repl exp with ctod(substr(fsbal.expirydate,9,2)+'/'+substr(fsbal.expirydate,6,2)+'/'+substr(fsbal.expirydate,1,4))
			repl pack with pro.pack
			repl rate with  stdis.salepurchaserate
			repl mrp with  fsbal.mrp
			repl qty with stdis.quantity
			repl free with stdis.free
			repl flg with 'D'
			repl godwon with mdis.discafter
			repl tax with 'T'
			repl half with 'A'
		endscan
	endsc
	sele mslip
	go top
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all
	retu

proc invertory_voucher
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
	retu

proc account_voucher
	@rowno,10 say '**** Transfer other Accounting Entries ****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datdev\gledger.&datext alias gle

	sele sele(1)
	use &datdev\order.&datext alia ord
	inde on substr(margcode+space(20),1,20) to ord

	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	last4  = voucher + 10
	slast5 = svoucher + 10
	last4 = last4 + 20

	sele sele(1)
	use &datatransferpath\voucher.&datatransferext alias fvouhead
	set filte to complinkid=mlinkid and financialyearlinkid=flinkid
	sele sele(1)
	use &datatransferpath\accountingdetails.&datatransferext alias fvoudetail
	set filte to complinkid=mlinkid and !inlist(isdelete,1,2) and inlist(datatype,51,52,53,54,55,56,57,58,62,63) &&&and financialyearlinkid=flinkid 
	index on voucherlinkid to fvoudetail
	sele fvouhead
	scan
	
		f_voucherdate=ctod(substr(fvouhead.entrydate,9,2)+'/'+substr(fvouhead.entrydate,6,2)+'/'+substr(fvouhead.entrydate,1,4))
		f_vouchernumber=fvouhead.voucherno
		sele fvoudetail
		seek fvouhead.linkid
		scan while voucherlinkid=fvouhead.linkid
			=seek(substr(fvoudetail.ledgerlinkid+space(20),1,20),'ord')
			sele gle
			appen blank
			repl voucher with last4
			repl vcsno with f_vouchernumber
			repl code with ord.ordno
			repl date with f_voucherdate
			if fvoudetail.creditordebit=1
				repl cd with 'D'
				repl debit with fvoudetail->amount+fvoudetail.shortamount
			else
				repl cd with 'C'
				repl credit with fvoudetail.amount+fvoudetail.shortamount
			endi
			repl remark1 with chrtran(fvoudetail.remarks,chr(0),'')
			repl remark2 with iif(fvoudetail.instype=2,'Cheque No : '+alltri(fvoudetail.insno),'')
			do case
				case inlist(fvouhead.datatype,53,54,63)
					repl book with 'R'
				case inlist(fvouhead.datatype,51,52,62)
					repl book with 'P'
				case inlist(fvouhead.datatype,55)
					repl book with 'C'
				case inlist(fvouhead.datatype,56)
					repl book with 'D'
				case inlist(fvouhead.datatype,57)
					repl book with 'E'
				case inlist(fvouhead.datatype,58)
					repl book with 'J'
			endcase			
		endscan
		last4=last4+10
	endscan
	sele mslip
	repl voucher with last4+10
	repl svoucher with slast5+10
	clos tabl all
	retu

procedure get_firm
	close data
	if used('FIRM')
		sele sele(1)
		sele firm
		use
	endif

	datatransferpath=allt(datatransferpath)
	select compm.linkid, compm.compname,lcomp.fincialyearfrom,;
		lcomp.fincialyearto,lcomp.linkid as finlink from &datatransferpath\companymaster compm ;
		left join &datatransferpath\financialyearhistory lcomp on lcomp.complinkid=compm.linkid into curs company

	defi wind partybills from 1,0 to 15,200 shadow float title "::Select Company ::" font 'Courier',18
	browse nomodi wind partybills field linkid :h="Company link Id":20,;
		compname :h="Company Name" :50,;
		fincialyearfrom :h="Financial Start":20,;
		fincialyearto :h="Financial End":20,;
		finlink :h="Financial Year LinkId" :20 font'tahoma',13
	mlinkid=linkid
	flinkid=finlink
	release wind partybills

	*!*	ACTIVATE WINDOW wDataMigration
	close table all
	retu



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
	retu
