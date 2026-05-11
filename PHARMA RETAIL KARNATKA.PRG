*!*	BOF : Pharma Retail.PRG .....Dated    : 02/08/2025   Author : SARVESH
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
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Aug\Pharmapl\Pharma\dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='29'
removenull = 'NO'
@13,10 say 'Pharma Retail Data Path :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'Pharma Retail Extension :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing Pharma Retail Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\item_master alias fitm
sele sele(1)
use &datatransferpath\stock_master alias fstk
index on item_id to fstk
sele sele(1)
use &datatransferpath\unit_master alias funit
index on unit_id to funit
sele sele(1)
use &datatransferpath\tax_master alias ftax
index on tax_id to ftax
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
index on str(code,9)+upper(packing) to mitm
dele all
sele fitm
scan
	sele fstk
	seek fitm.item_id
	scan while item_id=fstk.item_id
		=seek(fstk.unit_id,'funit')
		sele mitm
		seek str(fitm.item_id,9)+substr(upper(funit.unit_name)+space(15),1,15)
		if !found()
			appen blank
			repl code with fitm.item_id
			repl name with alltri(str(fitm.item_id))
			repl product with fitm.item_name
			repl packing with funit.unit_name
			repl billname with product+packing
			repl pack with 0
			repl rackno with ''
			repl unit with 'PCS'
			repl mitm.decimal with 'Y'
			repl mitm.salfix with 'N'
			repl mitm.gcode with padr(fitm.mfr_id,6)
			repl mitm.gcode5 with padr(fitm.itemgroup_id,6)
			repl mitm.maximum with fitm.item_maxlevel
			repl mitm.minimum with fitm.item_miinlevel
			repl mitm.halfsche with 'A'
			repl mitm.qtrsche with 'Y'
			repl mitm.salsc with 0
			repl mitm.mrp with fitm.item_mrp
			=seek(fitm.gsttax_id,'ftax')
			repl saltax with ftax.tax_percentage/2
			repl cgst   with ftax.tax_percentage/2
			repl igst   with ftax.tax_percentage
			mhsn=fitm.item_hsncode
			&&&HSN and Tax Mast
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
			&&&Salt Master Update
			sele mpcm
			seek 'SALT  ' + substr(upper(fitm.item_generic)+space(40),1,40)
			if !found()
				append blank
				repl mpcm.sgcode with 'SALT  ',;
					mpcm.scode  with 'SA'+alltrim(str(recno())),;
					mpcm.sname  with upper(fitm.item_generic),;
					mpcm.parnam with sname,;
					mpcm.tname with substr(upper(fitm.item_generic),41,40),;
					mpcm.tcode with 'No'
			endif
			repl mitm.gcode3 with mpcm.scode
		endif
	endscan
endscan
close table all
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\mfr_master.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ  '
	repl mpcm.scode  with padr(fpcm.mfr_id,6)
	repl mpcm.sname  with fpcm.mfr_name
	repl mpcm.parnam with fpcm.mfr_name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Category ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\itemgroup_master.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO'
	repl mpcm.scode  with padr(fpcm.itemgroup_id,9)
	repl mpcm.sname  with fpcm.itemgroup_name
	repl mpcm.parnam with fpcm.itemgroup_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock_master alias fsbal
sele sele(1)
use &datatransferpath\stock_inprice alias fpr
index on str(item_id,9)+str(unit_id,9)+stock_batch to fpr
sele sele(1)
use &datatransferpath\unit_master alias funit
index on unit_id to funit
sele sele(1)
use &datatransferpath\item_master alias fitm
index on item_id to fitm
sele sele(1)
use &datdev\pro.&datext alias mitm
index on product+packing to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on product+packing+batchno to msbal
sele fsbal
go top
scan
	=seek(fsbal.item_id,'fitm')
	=seek(fsbal.unit_id,'funit')
	=seek(str(fsbal.item_id,9)+str(fsbal.unit_id,9)+fsbal.stock_batch,'fpr')
	sele mitm
	seek substr(fitm.item_name,1,30)
	sele msbal
	seek substr(fitm.item_name,1,30)+substr(funit.unit_name+space(15),1,15)+substr(fsbal.stock_batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.product with mitm.product,;
			msbal.packing with funit.unit_name,;
			msbal.billname with mitm.billname,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with fsbal.stock_qty,;
			msbal.balance with fsbal.stock_qty,;
			msbal.o_a with fsbal.stock_qty,;
			msbal.b_a with fsbal.stock_qty,;
			msbal.batchno with fsbal.stock_batch
		repl msbal.exp with fsbal.stock_expiry,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
		repl msbal.mrp with fpr.stock_mrp
		repl msbal.lprate with fpr.stock_cost
		repl msbal.ratea with fpr.stock_mrp
		repl msbal.prate with fpr.stock_inprice
	else
		repl msbal.opening with msbal.opening + fsbal.stock_qty,;
			msbal.balance with msbal.balance + fsbal.stock_qty,;
			msbal.o_a with msbal.o_a + fsbal.stock_qty,;
			msbal.b_a with msbal.b_a + fsbal.stock_qty
		repl msbal.mrp with fpr.stock_mrp
		repl msbal.lprate with fpr.stock_cost
		repl msbal.ratea with fpr.stock_mrp
		repl msbal.prate with fpr.stock_inprice
	endif
endscan
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\acctrans_master alias fdet
sele sele(1)
use &datatransferpath\contact_details alias fact
index on contact_id to fact
sele sele (1)
use &datatransferpath\vouchdetails alias fbal
index on acc_id to fbal
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='AREA  '
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fdet
scan
	=seek (fdet.contact_id,'fact')
	sele mact
	appen blank
	repl mact.scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fdet.acc_id))
	repl mact.fax2 with fdet.acc_code
	repl mact.parnam  with fdet.acc_name
	repl mact.mailnam with fdet.acc_name
	repl mact.paradd with fact.contact_address1
	repl mact.paradd1 with fact.contact_address2
	repl mact.paradd2 with fact.contact_address3
	repl mact.city with fact.contact_place
	repl mact.dsm with fact.contact_pin
	repl mact.phone1 with fact.contact_phone1
	repl mact.phone2 with fact.contact_phone2
	repl gstno with fact.contact_kstno
	repl cstno with fact.contact_cstno
	repl dlno with fact.contact_dlno
	repl stno with fact.contact_tin
	repl itno with fact.contact_panno
	repl confir with fact.contact_contact
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	sele fbal
	seek fdet.acc_id
	sum v_debit to tdr while acc_id=fdet.acc_id
	sele fbal
	seek fdet.acc_id
	sum v_credit to tcr while acc_id=fdet.acc_id
	sele mact
	repl opning with tdr-tcr
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
	&&&&Update Email
	sele support
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 12
	repl remark with substr(fact.contact_email,1,40)+substr(support.remark,41,100),;
		heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
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
*!*	EOF : Pharma Retail.PRG .....Dated    : 02/08/2025   Author : SARVESH
