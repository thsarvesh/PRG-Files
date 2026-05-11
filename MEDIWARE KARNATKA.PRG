*!*	BOF : MEDIWARE.PRG .....Dated    : 23/04/2025   Author : SARVESH
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
datatransferpath=substr('D:\2025\apr\Mediware\Dbf\'+space(95),1,95) &&rpos_path
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
@13,10 say 'MEDIWARE Data Path      :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'MEDIWARE Extension      :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing MEDIWARE (Pharma Retail) Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\m_item_master alias fitm
sele sele(1)
use &datatransferpath\si_gst alias fhsn
index on id to fhsn
sele sele(1)
use &datatransferpath\m_package alias fpac
index on id to fpac
sele sele(1)
use &datatransferpath\m_unit alias funit
index on id to funit
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
	=seek(fitm.sunitid,'funit')
	=seek(fitm.packageid,'fpac')
	=seek(fitm.gstid,'fhsn')
	sele mitm
	appen blank
	repl code with recno()
	repl name with fitm.id
	repl product with fitm.name
	repl packing with fpac.name
	repl billname with mitm.product+mitm.packing
	repl pack with fitm.sqty
	repl rackno with fitm.rack
	repl unit with funit.name
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.maximum with 0
	repl mitm.gcode with alltri(fitm.companyid)
	repl gcode5 with padr(fitm.categoryid,6)
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with fhsn.tax/2
	repl cgst   with fhsn.tax/2
	repl igst   with fhsn.tax
	mhsn=fhsn.code
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
endscan
close table all
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\m_company.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ  '
	repl mpcm.scode  with alltri(str(fpcm.id))
	repl mpcm.sname  with fpcm.name
	repl mpcm.parnam with fpcm.name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Category****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\m_category.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO'
	repl mpcm.scode  with alltri(str(fpcm.id))
	repl mpcm.sname  with fpcm.name
	repl mpcm.parnam with fpcm.name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\si_stock alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
scan
	sele mitm
	seek substr(fsbal.itemid+space(10),1,10)
	sele msbal
	seek substr(fsbal.itemid+space(10),1,10)+substr(fsbal.batchno+space(12),1,12)
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
		repl msbal.opening with fsbal.qty
		repl msbal.balance with fsbal.qty
		repl msbal.o_a with fsbal.qty
		repl msbal.b_a with fsbal.qty
		repl msbal.batchno with fsbal.batchno
		repl msbal.exp with fsbal.expdate
		repl msbal.mrp with fsbal.leastmrp*iif(mitm.pack#0,mitm.pack,1)
		repl msbal.prate with fsbal.leastptr*iif(mitm.pack#0,mitm.pack,1)
		repl msbal.ratea with fsbal.rate*iif(mitm.pack#0,mitm.pack,1)
		repl msbal.lprate with fsbal.leastptr*iif(mitm.pack#0,mitm.pack,1)
		repl msbal.misc1 with mitm.gcode
		repl msbal.supcode with fsbal.supid
		repl supdat with fsbal.invdate
		repl supinvo with fsbal.invno
	else
		repl msbal.opening with msbal.opening + fsbal.qty
		repl msbal.balance with msbal.balance + fsbal.qty
		repl msbal.o_a with msbal.o_a + fsbal.qty
		repl msbal.b_a with msbal.b_a + fsbal.qty
	endif
endscan
close table all
@rowno,10 say '**** Importing Patient Master****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\m_doctor.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PET#$~'&&&&'PRE#$~'
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PET#$~'
	repl mdoc.ordno with alltrim(str(fdoc.id))
	repl mdoc.parnam with fdoc.name
	repl mdoc.city with fdoc.place
	repl mdoc.form with alltrim(str(fdoc.id))
endsc
close data all
@rowno,10 say '**** Importing Account Master****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\fa_account_heads alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
delete all for inlist(aliase,'LBTDETAI','ORDER   ')
sele fact
scan
	sele mact
	appen blank
	repl mact.scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(fact.id)
	repl mact.fax2 with alltri(fact.id)
	repl mact.parnam  with fact.name
	repl mact.mailnam with fact.name
	repl mact.paradd with fact.house
	repl mact.paradd1 with fact.place
	repl mact.paradd2 with fact.district
	repl mact.city with fact.place
	repl mact.dsm with ''
	repl mact.itno with ''
	repl mact.dlno with fact.dlno
	repl gstno with fact.email
	repl phone1 with fact.phone
	repl phone4 with fact.mobile
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	&&Local/Central Update
	select support
	appe blan
	repl aliase with 'LBTDETAI'
	repl type with 'F'
	repl lcode with mact.ordno
	repl heading with iif(mstatecode=left(mact.gstno,2) and empty(mact.gstno),'L            LN','L            ON ')
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
=messagebox('Mediware data transfer has been done.','MargErp')
return
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
close table all

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
	*!*	EOF : MDSOFT.PRG .....Dated    : 21/11/2024   Author : SARVESH
