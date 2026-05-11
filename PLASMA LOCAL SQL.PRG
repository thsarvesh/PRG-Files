*!*	BOF || Local Software || Sql Base || Date 03-04-2026 || Sarvesh
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
datatransferpath=substr('D:\MIGRATION_DATA\MAR\PLASMA_GURUKRIPA\DBF_FILES\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_6 = lastdate
old_7 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='29'
removenull = 'NO'
@13,10 say 'LocalSoft Data Path     :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'LocalSoft Extension     :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing LocalSoft Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\tax_master alias tax
index on tax_id to tax
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
    =seek(fitm.gsttax_id,'tax')
	sele mitm
	appen blank
	repl code with fitm.item_id
	repl name with alltri(str(fitm.item_id))
	repl product with fitm.item_name
	repl packing with' '
	repl billname with fitm.item_name
	repl pack with 0
	repl rackno with fitm.item_rackno
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.gcode with padr(fitm.mfr_id,6)
	repl mitm.gcode5 with padr(fitm.itemgroup_id,6)
	repl mitm.maximum with fitm.item_maxlevel
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.item_mrp
	repl saltax with tax.tax_percentage/2
	repl cgst   with tax.tax_percentage/2
	repl igst   with tax.tax_percentage
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
endscan
close table all
@rowno,10 say '**** Importing Area****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\area_master.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA'
	repl mpcm.scode  with padr(fpcm.area_id,6)
	repl mpcm.sname  with fpcm.area_name
	repl mpcm.parnam with fpcm.area_name
	repl mpcm.tcode with 'No'
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
use &datatransferpath\unit_master alias unitmst
index on unit_id to unitmst
sele sele(1)
use &datatransferpath\stock_inprice alias rate
index on str(item_id,9)+stock_batch to rate
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan
    =seek(fsbal.unit_id,'unitmst')
    =seek(str(fsbal.item_id,9)+fsbal.stock_batch,'rate')
	sele mitm
	seek str(fsbal.item_id,9)
	sele msbal
	seek str(fsbal.item_id,9)+substr(fsbal.stock_batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with mitm.pack,;
            mitm.packing with unitmst.unit_name,;
            msbal.packing with unitmst.unit_name,;
            msbal.pack with unitmst.unit_conv_factor,;
            mitm.pack with unitmst.unit_conv_factor,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with fsbal.stock_bqty,;
			msbal.balance with fsbal.stock_bqty,;
			msbal.o_a with fsbal.stock_bqty,;
			msbal.b_a with fsbal.stock_bqty,;
			msbal.batchno with fsbal.stock_batch,;
		    msbal.exp with fsbal.stock_expiry,;
			msbal.mrp with rate.stock_mrp,;
			msbal.prate with rate.stock_tp,;
			msbal.ratea with rate.stock_mrp,;
			msbal.lprate with rate.stock_cost,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
	else
		repl msbal.opening with msbal.opening + fsbal.stock_bqty,;
			msbal.balance with msbal.balance + fsbal.stock_bqty,;
			msbal.o_a with msbal.o_a + fsbal.stock_bqty,;
			msbal.b_a with msbal.b_a + fsbal.stock_bqty
	endif
endscan
close table all
*!*	@rowno,10 say '**** Importing Doctor Master****' font 'Arial',10
*!*	rowno=rowno+1
*!*	sele sele (1)
*!*	use &datatransferpath\mtbdoctor.dbf alias fdoc
*!*	sele sele (1)
*!*	use &datdev\maorder.&datext alias mdoc
*!*	delete all for scode='PRE#$~'
*!*	sele fdoc
*!*	go top
*!*	scan
*!*		sele mdoc
*!*		append blank
*!*		repl mdoc.scode with 'PRE#$~',;
*!*			mdoc.ordno with alltrim(str(fdoc.code)),;
*!*			mdoc.parnam with fdoc.name,;
*!*			mdoc.city with upper(fdoc.clinicadd1),;
*!*			mdoc.form with alltrim(str(fdoc.code))
*!*	endsc
*!*	close data all
@rowno,10 say '**** Importing Patient Master  ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\customer_master.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PET#$~'
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PET#$~',;
		mdoc.ordno with alltrim(str(fdoc.cust_id)),;
		mdoc.parnam with fdoc.cust_name,;
		mdoc.city with upper(fdoc.cust_address1),;
		mdoc.form with alltrim(str(fdoc.cust_id))
endsc
close data all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\contact_details alias fact
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
	repl mact.scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.contact_id))
	repl mact.fax2 with alltri(str(fact.contact_id))
	repl mact.parnam  with fact.contact_name
	repl mact.mailnam with fact.contact_name
	repl mact.paradd with fact.contact_address1
	repl mact.paradd1 with fact.contact_address2
	repl mact.paradd2 with fact.contact_address3
	repl confir with fact.contact_contact
    repl phone1 with fact.contact_phone1
    repl gstno with fact.contact_kstno
    repl cstno with fact.contact_cstno
    repl dlno with fact.contact_dlno
    repl area with padr(fact.area_id,6)
    repl mr with padr(fact.rep_id,6)
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
	&& Email ID UPDATE
    Sele support
    Append Blank
    Repl aliase With 'ORDER   ',;
        type With 'F',;
        lcode With mact.ordno,;
        sno With 12,;
        remark With fact->contact_email,;
        heading With Substr(Heading,1,21)+Iif(Empty(mact->gstno),'UG','NG')
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
*!*	EOF || Local Software || Sql Base || Date 03-04-2026 || Sarvesh
