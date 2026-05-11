*!*	BOF : ICON || TRADE : PHARMA WHOLESALE || DATE: 18-03-2026|| AUTHOR : SARVESH
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
datatransferpath=substr('D:\2025\March\Icon\data\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='33'
removenull = 'NO'
@13,10 say 'ICON Data Path          :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'ICON Extension          :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing ICON Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\item_mas alias fitm
sele sele(1)
use &datatransferpath\tax_mas alias taxmas
index on code to taxmas
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
    =seek(fitm.sgst,'taxmas')
	sele mitm
	appen blank
	repl code with fitm.item_code
	repl name with fitm.item_id
	repl product with fitm.item_name
	repl packing with fitm.des
	repl billname with mitm.product+mitm.packing
    repl bookname with fitm.item_tname
	repl pack with 0
	repl rackno with ''
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.gcode with padr(fitm.mnu_code,6)
	repl mitm.gcode3 with padr(fitm.div_code,6)
	repl mitm.gcode5 with padr(fitm.cat_code,6)
	repl mitm.maximum with fitm.max_qty
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.mrp
	repl mitm.ratea with fitm.sales_pric
    repl mitm.rateb with fitm.wholsale
	repl mitm.lprate with fitm.unit_cost
	repl mitm.prate with fitm.pur_price
	repl saltax with taxmas.sgst
	repl cgst   with taxmas.sgst
	repl igst   with taxmas.sgst*2
	mhsn=fitm.item_comco
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
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\manufacture.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ'
	repl mpcm.scode  with padr(fpcm.mnu_code,6)
	repl mpcm.sname  with fpcm.mnu_name
	repl mpcm.parnam with fpcm.mnu_name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing SALT****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\division.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'SALT  '
	repl mpcm.scode  with padr(fpcm.supp_code,6)
	repl mpcm.sname  with fpcm.supp_name
	repl mpcm.parnam with fpcm.supp_name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Category****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\category.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO'
	repl mpcm.scode  with padr(fpcm.cat_code,6)
	repl mpcm.sname  with fpcm.cat_name
	repl mpcm.parnam with fpcm.cat_name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Batch From Purchase****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\pur_det alias fsbal
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
	seek str(fsbal.Item_Code,9)
	sele msbal
	seek str(fsbal.Item_Code,9)+substr(fsbal.Pur_Mobile+space(12),1,12)
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
			msbal.opening with fsbal.Pur_Qty,;
			msbal.balance with fsbal.Pur_Qty,;
			msbal.o_a with fsbal.Pur_Qty,;
			msbal.b_a with fsbal.Pur_Qty,;
			msbal.batchno with fsbal.Pur_Mobile
		    repl msbal.exp with ctod('01/'+substr(fsbal.Pur_Margin,1,3)+'20'+substr(fsbal.Pur_Margin,4,2)),;
			msbal.mrp with fsbal.Pur_Mrp,;
			msbal.prate with fsbal.Pur_Rate,;
			msbal.ratea with fsbal.Pur_SalRat,;
			msbal.rateb with fsbal.Pur_Wholsa,;
			msbal.lprate with fsbal.Pur_Rate/iif(mitm.pack#0,mitm.pack,1),;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
			
	else
		repl msbal.opening with msbal.opening + fsbal.Pur_Qty,;
			msbal.balance with msbal.balance + fsbal.Pur_Qty,;
			msbal.o_a with msbal.o_a + fsbal.Pur_Qty,;
			msbal.b_a with msbal.b_a + fsbal.Pur_Qty
	endif
Endscan
close table all
@rowno,10 say '**** Importing Batch From Sales ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\Inv_det alias fsbal
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
	seek str(fsbal.Item_Code,9)
	sele msbal
	seek str(fsbal.Item_Code,9)+substr(fsbal.batch+space(12),1,12)
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
			msbal.opening with -fsbal.Inv_Qty,;
			msbal.balance with -fsbal.Inv_Qty,;
			msbal.o_a with -fsbal.Inv_Qty,;
			msbal.b_a with -fsbal.Inv_Qty,;
			msbal.batchno with fsbal.Batch
		    repl msbal.exp with ctod('01/'+substr(fsbal.ExpDate,1,3)+'20'+substr(fsbal.ExpDate,4,2)),;
			msbal.mrp with fsbal.Inv_Mrp,;
			msbal.prate with fsbal.Pur_Rate,;
			msbal.ratea with fsbal.Inv_SalRat,;
			msbal.rateb with fsbal.Inv_Wholsa,;
			msbal.lprate with fsbal.Pur_Rate/iif(mitm.pack#0,mitm.pack,1),;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
			
	else
		repl msbal.opening with msbal.opening - fsbal.Inv_Qty,;
			msbal.balance with msbal.balance - fsbal.Inv_Qty,;
			msbal.o_a with msbal.o_a - fsbal.Inv_Qty,;
			msbal.b_a with msbal.b_a - fsbal.Inv_Qty
	endif
Endscan
close table all
@rowno,10 say '**** Importing Sales Man ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\sman_inf alias fact
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
	repl mact.scode with 'D32'
	repl mact.rate with 'Y'
	repl mact.ordno with 'M'+alltri(str(fact.supp_code))
	repl mact.fax2 with fact.supp_id
	repl mact.parnam  with fact.supp_name
	repl mact.mailnam with fact.supp_name
	repl mact.paradd with fact.supp_add
	repl mact.paradd1 with fact.supp_add1
	repl mact.paradd2 with fact.supp_city
	repl mact.city with fact.supp_city
	repl mact.dsm with alltri(chrtran(fact.supp_pin,' ',''))
	repl phone1 with fact.supp_phone
	repl phone2 with fact.supp_phone
	repl phone4 with fact.supp_phone
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
	&&&&& Area Master
	sele mpcm
	seek 'AREA  '+substr(upper(fact.supp_area)+space(40),1,40)
	if !found()
		appen blank
		repl sgcode with 'AREA  '
		repl scode with 'A'+alltri(str(recno()))
		repl sname with upper(fact.supp_area)
		repl parnam with upper(fact.supp_area)
	endif
	repl mact.area with mpcm.scode
endscan
close tables all

@rowno,10 say '**** Importing Customer ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\Customer alias fact
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
	repl mact.scode with 'C6'
	repl mact.rate with 'Y'
	repl mact.ordno with 'L'+alltri(str(fact.Cust_code))
	repl mact.fax2 with fact.cust_id
	repl mact.parnam  with fact.cust_name
	repl mact.mailnam with fact.cust_name
	repl mact.paradd with fact.cust_add
	repl mact.paradd1 with fact.cust_add1
	repl mact.paradd2 with fact.cust_city
	repl mact.city with fact.cust_city
	repl mact.dsm with alltri(chrtran(fact.cust_pin,' ',''))
	repl mact.mr with 'M'+alltri(str(fact.salm_code))
	repl phone1 with fact.cust_phone
	repl phone2 with fact.cust_phon2
	repl phone4 with fact.cust_phone
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.gstno with fact.cust_phon3
	repl mact.dlno with fact.cust_phon6
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
	&&&&& Area Master
	sele mpcm
	seek 'AREA  '+substr(upper(fact.cust_area)+space(40),1,40)
	if !found()
		appen blank
		repl sgcode with 'AREA  '
		repl scode with 'A'+alltri(str(recno()))
		repl sname with upper(fact.cust_area)
		repl parnam with upper(fact.cust_area)
	endif
	repl mact.area with mpcm.scode
endscan
close tables all
@rowno,10 say '**** Importing Sales Man ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\supp_inf alias fact
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
	repl mact.ordno with 'P'+alltri(str(fact.supp_code))
	repl mact.fax2 with fact.supp_id
	repl mact.parnam  with fact.supp_name
	repl mact.mailnam with fact.supp_name
	repl mact.paradd with fact.supp_add
	repl mact.paradd1 with fact.supp_add1
	repl mact.paradd2 with fact.supp_city
	repl mact.city with fact.supp_city
	repl mact.dsm with alltri(chrtran(fact.supp_pin,' ',''))
	repl phone1 with fact.supp_phone
	repl phone2 with fact.supp_phone
	repl phone4 with fact.supp_phone
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.gstno with fact.supp_tin
	repl mact.dlno with fact.supp_pin
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
	&&&&& Area Master
	sele mpcm
	seek 'AREA  '+substr(upper(fact.supp_area)+space(40),1,40)
	if !found()
		appen blank
		repl sgcode with 'AREA  '
		repl scode with 'A'+alltri(str(recno()))
		repl sname with upper(fact.supp_area)
		repl parnam with upper(fact.supp_area)
	endif
	repl mact.area with mpcm.scode
endscan
close tables all
@rowno,10 say '**** Importing A/C Outstandings (Customer)  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\receipt alias Rec
index on str(inv_no,9) to rec
sele sele(1)
use &datatransferpath\inv_head alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan 
	sele rec
	seek str(fout.inv_tranno,9)
	sum rec_amount to ColTot while str(inv_no,9)=str(fout.inv_tranno,9)
	Lbillamt=fout.inv_net-fout.rec_amt
	Lcollection=Coltot
	mvcn=alltr(str(fout.billno))
	sele mord
	seek substr('L'+alltri(str(fout.cust_code))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.inv_date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with Lbillamt
	repl balance with Lbillamt-Lcollection
	repl itemope with Lcollection
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing A/C Outstandings (Supplier)  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\pur_head alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan 
	Lbillamt=fout.pur_net
	Lcollection=fout.rec_amt
	Lbalance=Lbillamt-Lcollection
	mvcn=alltri(fout.pur_billno)
	sele mord
	seek substr('P'+alltri(str(fout.supp_code))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.pur_date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with -Lbillamt
	repl balance with -lBalance
	repl itemope with -Lcollection
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
=messagebox('Master Transfer has been done,Please check the data','MargErp')
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
*!*	EOF : ICON || TRADE : PHARMA WHOLESALE || DATE: 18-03-2026|| AUTHOR : SARVESH
