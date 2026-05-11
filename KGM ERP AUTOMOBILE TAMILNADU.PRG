*!*	BOF : KGM ERP RX.PRG .....Dated    : 21-04-2026   Author : SARVESH
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
	datdev='d:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\MIGRATION_DATA\APR\KMS\DBF\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_6 = lastdate
old_7 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='33'
removenull = 'NO'
@13,10 say 'KGM ERP Data Path       :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'KGM ERP Extension       :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_6    font 'courier',18
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
@ 02,25 say 'Please Wait..Importing KGM ERP (Automobile) Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\item_table alias fitm
sele sele(1)
use &datatransferpath\Rack_table alias RackMst
Index on Rack_sno to RackMst
sele sele(1)
use &datatransferpath\Unit_table alias UnitMst
Index on Unit_sno to UnitMst
sele sele(1)
use &datatransferpath\Hsncode_table alias HsnMst
Index on hsn_sno to HsnMst
sele sele(1)
use &datatransferpath\Tax_table alias TaxMst
Index on Tax_sno to TaxMst
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
	repl code with recno()
	repl name with fitm.item_sno
	repl product with fitm.item_mtcode
	repl packing with ''
	repl billname with fitm.item_name
	repl bookname with fitm.item_aliasname
	repl pack with Fitm.Convratio
	if seek(Fitm.Unit_no,'UnitMst')
		repl unit with UnitMst.Unit_mtname
	else
		repl unit with 'PCS'
	Endif
	repl mitm.decimal with 'N'
	repl mitm.salfix with 'N'
	if seek(Fitm.Rack_no,'RackMst')
		Repl Mitm.Rackno2 with RackMst.Rack_name
	Endif
	repl mitm.gcode with Fitm.Brand_no
	repl mitm.gcode3 with Fitm.Model_no
	repl mitm.gcode5 with Fitm.Item_Groupno
	repl minimum with Fitm.Item_minstock
	repl mitm.maximum with Fitm.Item_Maxstock
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.Item_Mrp
	repl mitm.ratea with fitm.Item_Srate
	repl mitm.lprate with fitm.Item_cost
	repl mitm.prate with Fitm.Item_prate
	repl opening with Fitm.cloqty
	repl balance with Fitm.cloqty
	repl o_a with Fitm.cloqty
	repl b_a with Fitm.cloqty
	if seek(Fitm.Gst_no,'TaxMst')
		repl saltax with TaxMst.Sgst_per
		repl cgst   with TaxMst.Cgst_per
		repl igst   with TaxMst.Sgst_per+TaxMst.Cgst_per
	Endif
	if seek(fitm.Hsncode,'HsnMst')
		mhsn=HsnMst.Hsn_code
	else
		mHsn=''
	endif
	&&&HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(mhsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'H'+alltrim(str(recno())),;
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
use &datatransferpath\Brand_table.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ  '
	repl mpcm.scode  with Fpcm.Brand_sno
	repl mpcm.sname  with Fpcm.Brand_name
	repl mpcm.parnam with Fpcm.Brand_name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Model ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\Model_table.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'SALT  '
	repl mpcm.scode  with Fpcm.Model_Sno
	repl mpcm.sname  with Fpcm.Model_name
	repl mpcm.parnam with Fpcm.Model_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Group ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\Itemgroup_table.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO'
	repl mpcm.scode  with Fpcm.Itemgroup_sno
	repl mpcm.sname  with Fpcm.Itemgroup_name
	repl mpcm.parnam with Fpcm.Itemgroup_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Ledger Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\Ledger_table alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
		Do case
			Case inlist(Fact.Ledger_Groupno,'AR14        ','AR34        ')
				Mscode='D31'
			Case Inlist(Fact.Ledger_Groupno,'AR10        ','AR35        ')
				Mscode='C6'
			Case Fact.Ledger_Groupno='AR6         '
				Mscode='C2'
			Otherwise
				Mscode='J12'
		Endcase
	repl mact.scode with Mscode
	repl mact.rate with 'Y'
	repl mact.ordno with Fact.Ledger_sno
	repl mact.fax2 with Fact.Ledger_sno
	repl mact.parnam  with Upper(Fact.Ledger_name)
	repl mact.mailnam with Upper(Fact.Ledger_name)
	repl mact.paradd with Fact.Ledger_add1
	repl mact.paradd1 with Fact.Ledger_add2
	repl mact.paradd2 with Fact.Ledger_add3+' '+Fact.Ledger_add4
	repl Mact.Dsm with chrtran(Fact.Area_code,' ','')
	repl mact.stno with Fact.Ledger_tin
	repl mact.cstno with Fact.Ledger_cst
	repl mact.itno with Fact.Ledger_pan
	repl mact.gstno with Fact.Ledger_gst
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
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
*!*	EOF : KGM ERP.PRG .....Dated    : 21-04-2026   Author : SARVESH
