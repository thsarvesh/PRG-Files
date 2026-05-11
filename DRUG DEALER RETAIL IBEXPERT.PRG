*!*	BOF : DRUG DEALER.PRG  RETAIL DBF FROM IBEXPERT .....Dated    : 13/03/2025   Author : SARVESH
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
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='d:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='32'
removenull = 'NO'
@13,10 say 'DRUG DEALER Data Path   :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'DRUG DEALER Extension   :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing Drug Dealer Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\products alias fitm
sele sele(1)
use &datatransferpath\taxmaster alias ftax
index on taxid to ftax
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
	=seek(groupid,'ftax')
	sele mitm
	appen blank
	repl code with fitm.productid
	repl name with alltri(str(fitm.productid))
	repl product with fitm.productnam
	repl packing with fitm.strength
	repl billname with fitm.productnam
	repl pack with fitm.packing
	repl gcode with padr(fitm.companyid,6)
	repl gcode5 with padr(fitm.groupid,6)
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.maximum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	store 0 to mtax
	repl saltax with ftax.sal_taxper
	repl cgst   with ftax.sal_taxper
	repl igst   with ftax.sal_taxper*2
	mhsn=fitm.hsncode
&&& HSN and Tax Mast
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
endsc
close table all
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\company.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ'
	repl mpcm.scode  with padr(fpcm.companyid,6)
	repl mpcm.sname  with fpcm.companynam
	repl mpcm.parnam with fpcm.companynam
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Group****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\groupmaster.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO'
	repl mpcm.scode  with padr(fpcm.group_id,6)
	repl mpcm.sname  with fpcm.group_name
	repl mpcm.parnam with fpcm.group_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Doctor Master****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\doctor.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PRE#$~'
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PRE#$~',;
		mdoc.ordno with alltrim(str(fdoc.doctorid)),;
		mdoc.parnam with fdoc.name,;
		mdoc.city with upper(fdoc.address),;
		mdoc.form with alltrim(str(fdoc.doctorid))
endsc
close data all

*!*	@rowno,10 say '**** Importing Area****' font 'Arial',10
*!*	rowno=rowno+1
*!*	sele sele (1)
*!*	use &datdev\saletype.&datext alia mpcm
*!*	dele all for sgcode='AREA'
*!*	index on sgcode+sname to mpcm
*!*	sele sele (1)
*!*	use &datatransferpath\area.dbf alia fpcm
*!*	sele fpcm
*!*	go top
*!*	scan
*!*		sele mpcm
*!*		append blank
*!*		repl mpcm.sgcode with 'AREA  '
*!*		repl mpcm.scode  with padr(fpcm.area_id,6)
*!*		repl mpcm.sname  with fpcm.areaname
*!*		repl mpcm.parnam with fpcm.areaname
*!*		repl mpcm.tcode with 'No'
*!*	endsc
*!*	close table all
@rowno,10 say '**** Importing MR****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\order.&datext alia mpcm
sele sele (1)
use &datatransferpath\salesrep.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.scode with 'D32'
	repl ordno with 'M'+alltri(str(fpcm.rep_id))
	repl mpcm.mailnam  with fpcm.rep_name
	repl mpcm.parnam with fpcm.rep_name
endsc
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\batches alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
do while !eof()
	mbal=stock
	mexp=date_exp&&&&ctod('01/'+substr(expirystri,1,3)+'20'+substr(expirystri,4,2))
	sele mitm
	seek str(fsbal.productid,9)
	sele msbal
	seek str(fsbal.productid,9)+substr(fsbal.batch+space(12),1,12)
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
			msbal.opening with mbal,;
			msbal.balance with mbal,;
			msbal.o_a with mbal,;
			msbal.b_a with mbal,;
			msbal.batchno with fsbal.batch
		repl msbal.exp with mexp,;
			msbal.mrp with fsbal.mrp,;
			msbal.prate with fsbal.rate,;
			msbal.ratea with fsbal.mrp,;
			msbal.lprate with fsbal.rate,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
		repl msbal.supinvo with fsbal.lastpurc01
		repl msbal.date with fsbal.lastpurc02
		repl supdat with fsbal.lastpurc02
	else
		repl msbal.opening with msbal.opening + mbal,;
			msbal.balance with msbal.balance + mbal,;
			msbal.o_a with msbal.o_a + mbal,;
			msbal.b_a with msbal.b_a + mbal
		repl msbal.supinvo with fsbal.lastpurc01
		repl msbal.date with fsbal.lastpurc02
		repl supdat with fsbal.lastpurch_
	endif
	sele fsbal
	skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\mst_ledger alias fact
sele sele(1)
use &datatransferpath\daybookdetail alias fbal
index on ledgerid to fbal
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	mopen=opdebit-opcredit
	sele fbal
	seek fact.ledgerid
	sum debit-credit to mtran while ledgerid=fact.ledgerid
	
	sele mact
	appen blank
	do case
	case right(alltri(fact.acc_groupi),2)='SD'
		repl mact.scode with 'C6'
	case right(alltri(fact.acc_groupi),2)='SC'
		repl mact.scode with 'D31'
	otherwise
		repl mact.scode with 'J12'
	endcase
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.id))
	repl mact.fax2 with fact.ledgerid
	repl mact.parnam  with fact.ledger
	repl mact.mailnam with fact.ledger
	repl mact.paradd with substr(fact.address,1,30)
	repl mact.paradd1 with substr(fact.address,31,30)
	repl mact.paradd2 with fact.phoneno
	repl mact.city with fact.place
	repl mact.dlno with alltri(fact.dlno1)+alltri(fact.dlno2)
	repl gstno with fact.tin_pin
	repl phone1 with alltri(getwordnum(fact.phoneno,1,","))
	repl phone2 with fact.phoneno
	repl phone4 with alltri(getwordnum(fact.phoneno,2,","))
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.area with padr(fact.area_id,6)
	repl mact.mr with 'M'+alltri(str(fact.rep_id))
	repl opning with mopen+mtran
*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having
***STATE
	sele support
	appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
*!*	&& For Email & Registered/Unregistered
*!*		sele support
*!*		append blank
*!*		repl aliase with 'ORDER   '
*!*		repl type with 'F'
*!*		repl lcode with mact.ordno
*!*		repl sno with 12
*!*		repl remark with substr(fadd.emaild,1,40)+substr(support.remark,41,100),;
*!*			heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
endscan
close tables all
retu
@rowno,10 say '**** Importing Supplier Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\purchase alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
	mvcn=alltr(fout.billnumber)
	sele mord
	seek substr(alltri(str(fout.ledgerid))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.billdate
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with   -abs(fout->netamount)
	repl itemope with -abs(fout.paidamount)
	repl balance with -abs(fout->netamount-fout.paidamount)
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing Customer Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\sales alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
	mvcn=alltr(fout.number)
	sele mord
	seek substr(alltri(str(fout.ledgerid))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with abs(fout->netvalue)
	repl itemope with abs(fout.receivedam)
	repl balance with abs(fout->netvalue-fout.receivedam)
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing Customer Credit Note Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\sales_return alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
	mvcn=alltr(fout.number)
	sele mord
	seek substr(alltri(str(fout.ledgerid))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with -(fout->netvalue)
	repl itemope with -abs(fout.settledamo)
	repl balance with -abs(fout->netvalue-fout.settledamo)
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing Customer Debit Note Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\purchase_return alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
	mvcn=alltr(fout.number)
	sele mord
	seek substr(alltri(str(fout.ledgerid))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with (fout->netamount)
	repl itemope with abs(fout.settledamo)
	repl balance with abs(fout->netamount-fout.settledamo)
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
*!*	BOF : DRUG DEALER.PRG  RETAIL DBF FROM IBEXPERT .....Dated    : 13/03/2025   Author : SARVESH
