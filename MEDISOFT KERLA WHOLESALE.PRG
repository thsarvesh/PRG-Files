*!*	BOF : Medisoft Kerla PH WH .....Dated    : 26/09/2025   Author : SARVESH
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
datatransferpath=substr('D:\2025\Feb\Medisoft\Dbf\'+space(95),1,95) &&rpos_path
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
@13,10 say 'MEDISOFT Data Path      :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'MEDISOFT Extension      :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing MEDISOFT Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\product alias fitm
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
	repl code with fitm.product_id
	repl name with alltri(str(fitm.product_id))
	repl product with upper(fitm.product_name)
	repl packing with ''
	repl billname with upper(fitm.product_name)
	repl pack with 0
	repl rackno with ''
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.gcode with padr(fitm.manufacturer_id,6)
	repl mitm.gcode3 with padr(fitm.generic_id,6)
	repl mitm.gcode5 with padr(fitm.category_id,6)
	repl mitm.maximum with fitm.maxlevel
	repl mitm.minimum with fitm.minlevel
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with fitm.gst/2
	repl cgst   with fitm.gst/2
	repl igst   with fitm.gst
	mhsn=fitm.hsncode
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
use &datatransferpath\manufacturer.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ  '
	repl mpcm.scode  with padr(fpcm.manufacturer_id,6)
	repl mpcm.sname  with upper(fpcm.manufacturer_name)
	repl mpcm.parnam with upper(fpcm.manufacturer_name)
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Salt ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\Generic.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'SALT  '
	repl mpcm.scode  with padr(fpcm.Generic_id,9)
	repl mpcm.sname  with upper(fpcm.Generic_name)
	repl mpcm.parnam with upper(fpcm.Generic_name)
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Category ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\category.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO'
	repl mpcm.scode  with padr(fpcm.category_id,9)
	repl mpcm.sname  with upper(fpcm.category_name)
	repl mpcm.parnam with upper(fpcm.category_name)
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock alias fsbal
sele sele(1)
use &datatransferpath\purchase1 alias fm
index on purchase_id to fm
sele sele(1)
use &datatransferpath\purchase_item1 alias fd
index on str(product_id,9)+substr(batch,1,12) to fd
sele sele(1)
use &datatransferpath\purchase2 alias fm2
index on purchase_id to fm2

sele sele(1)
use &datatransferpath\purchase_item2 alias fd2
index on str(product_id,9)+substr(batch,1,12) to fd2
sele sele(1)
use &datatransferpath\purchase3 alias fm3
index on purchase_id to fm3
sele sele(1)
use &datatransferpath\purchase_item3 alias fd3
index on str(product_id,9)+substr(batch,1,12) to fd3

sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan	
	msup=''
	mdate=ctod('')
	mvcn=0
	sele fd
	seek str(fsbal.product_id,9)+substr(fsbal.batch+space(12),1,12)
	scan while str(product_id,9)+substr(batch+space(12),1,12)=str(fsbal.product_id,9)+substr(fsbal.batch+space(12),1,12)
	if found()
		sele fm
		seek fd.purchase_id
		msup='E'+alltri(str(fm.supplier_id))
		mdate=fm.purchase_date
		mvcn=(fm.purchase_id)
	endif
	endscan
	sele fd2
	seek str(fsbal.product_id,9)+substr(fsbal.batch+space(12),1,12)
	scan while str(product_id,9)+substr(batch+space(12),1,12)=str(fsbal.product_id,9)+substr(fsbal.batch+space(12),1,12)
	if found()
		sele fm2
		seek fd2.purchase_id
		msup='E'+alltri(str(fm2.supplier_id))
		mdate=fm2.purchase_date
		mvcn=(fm2.purchase_id)
	endif
	endsca
	sele fd3
	seek str(fsbal.product_id,9)+substr(fsbal.batch+space(12),1,12)
	scan while str(product_id,9)+substr(batch+space(12),1,12)=str(fsbal.product_id,9)+substr(fsbal.batch+space(12),1,12)
	if found()
		sele fm3
		seek fd3.purchase_id
		msup='E'+alltri(str(fm3.supplier_id))
		mdate=fm3.purchase_date
		mvcn=(fm3.purchase_id)
	endif
	endscan

		
	sele mitm
	seek str(fsbal.product_id,9)
	sele msbal
	seek str(fsbal.product_id,9)+substr(fsbal.batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with fsbal.upack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with (fsbal.purchase_quantity-fsbal.sales_quantity),;
			msbal.balance with (fsbal.purchase_quantity-fsbal.sales_quantity),;
			msbal.o_a with (fsbal.purchase_quantity-fsbal.sales_quantity),;
			msbal.b_a with (fsbal.purchase_quantity-fsbal.sales_quantity),;
			msbal.batchno with fsbal.batch
		repl msbal.exp with fsbal.expiry,;
			msbal.mrp with fsbal.mrp,;
			msbal.prate with fsbal.unit_rate,;
			msbal.ratea with fsbal.ptr,;
			msbal.rateb with fsbal.sales_rate,;
			msbal.lprate with fsbal.unit_rate,;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
		repl supcode with msup
		repl date with mdate
		repl supdat with mdate
		repl supinvo with alltri(str(mvcn))
	else
		repl msbal.opening with msbal.opening +(fsbal.purchase_quantity-fsbal.sales_quantity),;
			msbal.balance with msbal.balance +(fsbal.purchase_quantity-fsbal.sales_quantity),;
			msbal.o_a with msbal.o_a +(fsbal.purchase_quantity-fsbal.sales_quantity),;
			msbal.b_a with msbal.b_a +(fsbal.purchase_quantity-fsbal.sales_quantity)
		repl supcode with msup
		repl date with mdate
		repl supdat with mdate
		repl supinvo with alltri(str(mvcn))
	endif
endscan
sele msbal
close table all
@rowno,10 say '**** Importing Salesman ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\staff alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
	repl mact.scode with 'D32'
	repl mact.rate with 'Y'
	repl mact.ordno with 'M'+alltri(str(fact.staffid))
	repl mact.fax2 with alltri(str(fact.staffid))
	repl mact.parnam  with upper(fact.staffname)
	repl mact.mailnam with upper(fact.staffname)
	repl mact.paradd with upper(fact.location)
	repl mact.dsm with fact.pin
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
	repl heading with iif(mstatecode=left(mact.gstno,2) or empty(mact.gstno),'L            LN','L            ON ')
&& For Email & Registered/Unregistered
	sele support
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 12
	repl remark with substr(fact.email,1,40)+substr(support.remark,41,100),;
		heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
endscan
close tables all

@rowno,10 say '**** Importing Customer ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\customer alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
delete all for inlist(sgcode,'AREA','ROUT')
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
	repl mact.scode with 'C6'
	repl mact.rate with 'Y'
	repl mact.ordno with 'D'+alltri(str(fact.Customer_id))
	repl mact.fax2 with alltri(str(fact.customer_id))
	repl mact.parnam  with upper(fact.customer_name)
	repl mact.mailnam with upper(fact.customer_name)
	repl mact.paradd with upper(fact.address1)
	repl mact.paradd1 with upper(fact.address2)
	repl mact.paradd2 with upper(fact.location)+' '+upper(fact.location2)
	repl mact.city with fact.location2
	repl confir with fact.contact
	repl phone1 with fact.phone1
	repl phone2 with fact.phone2
	repl phone3 with fact.mobile2
	repl phone4 with fact.mobile
	repl dlno with alltri(fact.dl)+' '+alltri(fact.dl2)
	repl mr with 'M'+alltri(str(fact.salesman))
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.gstno with fact.gstno
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
	seek 'AREA  '+substr(upper(fact.location2)+space(40),1,40)
	if !found()
		appen blank
		repl sgcode with 'AREA  '
		repl scode with 'A'+alltri(str(recno()))
		repl sname with upper(fact.location2)
		repl parnam with sname
	endif
	repl mact.area with mpcm.scode
	&&&&& Rout Master
	sele mpcm
	seek 'ROUT '+substr(upper(fact.location)+space(40),1,40)
	if !found()
		appen blank
		repl sgcode with 'ROUT  '
		repl scode with 'A'+alltri(str(recno()))
		repl sname with upper(fact.location)
		repl parnam with sname
	endif
	repl mact.rout with mpcm.scode
endscan
close tables all
@rowno,10 say '**** Importing Supplier ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\supplier alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
	repl mact.scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with 'E'+alltri(str(fact.supplier_id))
	repl mact.fax2 with alltri(str(fact.supplier_id))
	repl mact.parnam  with upper(fact.supplier_name)
	repl mact.mailnam with upper(fact.supplier_name)
	repl mact.paradd with upper(fact.address1)
	repl mact.paradd1 with upper(fact.address2)
	repl mact.paradd2 with upper(fact.address3)
	repl mact.dsm with fact.pin
	repl itno with fact.pan
	repl confir with fact.contact
	repl phone1 with fact.phone1
	repl phone2 with fact.phone2
	repl phone4 with fact.mobile
	repl dlno with alltri(fact.dl)
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.gstno with fact.gstno
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
	repl heading with iif(mstatecode=left(mact.gstno,2) or empty(mact.gstno),'L            LN','L            ON ')
&& For Email & Registered/Unregistered
	sele support
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 12
	repl remark with substr(fact.email,1,40)+substr(support.remark,41,100),;
		heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
endscan
close tables all
@rowno,10 say '**** Importing Customer O/s From Sale-1  ****' font 'Arial',10
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
go top
scan
	custcode='D'+alltri(fout.customer_id)
	mvcn=alltr(str(fout.bill_no))
	sele mord
	seek substr(custcode+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.bill_date
	repl vcn with mvcn
	repl invtype with 'O'
	repl mr with 'M'+alltri(str(fout.salesman))
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->grand_total),abs(fout->grand_total))
	repl balance with iif(acgroup='D31',-abs(fout->grand_total),abs(fout->grand_total))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing Customer O/s From Sale-2  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\sales2 alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
	custcode='D'+alltri(fout.customer_id)
	mvcn=alltr(str(fout.bill_no))
	sele mord
	seek substr(custcode+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.bill_date
	repl vcn with mvcn
	repl mr with 'M'+alltri(str(fout.salesman))
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->grand_total),abs(fout->grand_total))
	repl balance with iif(acgroup='D31',-abs(fout->grand_total),abs(fout->grand_total))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing Customer O/s From Sale-3 ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on  ordno  to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\sales3 alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
	custcode='D'+alltri(fout.customer_id)
	mvcn=alltr(str(fout.bill_no))
	sele mord
	seek substr(custcode+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.bill_date
	repl vcn with mvcn
	repl mr with 'M'+alltri(str(fout.salesman))
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->grand_total),abs(fout->grand_total))
	repl balance with iif(acgroup='D31',-abs(fout->grand_total),abs(fout->grand_total))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

@rowno,10 say '**** Importing Customer Collection From Ledger-1 ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
index on substr(vcn+space(20),1,20)+substr(ord+space(6),1,6) to mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on  ordno  to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\ledger1 alias fcol
set filt to group_name='Sundry Debtors '
sele fcol
go top
scan
	custcode='D'+alltri(str(fcol.party_id))
	mvcn=substr(alltr(str(fcol.against))+space(20),1,20)
	sele mord
	seek substr(custcode+space(6),1,6)
	sele mpend
	seek mvcn+mord.ordno
	if found()
		repl itemope with itemope+fcol.amount
		repl balance with final-itemope
	endif
endsc
close table all
@rowno,10 say '**** Importing Customer Collection From Ledger-2 ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
index on substr(vcn+space(20),1,20)+substr(ord+space(6),1,6) to mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on  ordno  to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\ledger2 alias fcol
set filt to group_name='Sundry Debtors '
sele fcol
go top
scan
	custcode='D'+alltri(str(fcol.party_id))
	mvcn=substr(alltr(str(fcol.against))+space(20),1,20)
	sele mord
	seek substr(custcode+space(6),1,6)
	sele mpend
	seek mvcn+mord.ordno
	if found()
		repl itemope with itemope+fcol.amount
		repl balance with final-itemope
	endif
endsc
close table all


@rowno,10 say '**** Importing Customer Collection From Ledger-3  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
index on substr(vcn+space(20),1,20)+substr(ord+space(6),1,6) to mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\ledger3 alias fcol
set filt to group_name='Sundry Debtors '
sele fcol
go top
scan 
	custcode='D'+alltri(str(fcol.party_id))
	mvcn=substr(alltr(str(fcol.against))+space(20),1,20)
	sele mord
	seek substr(custcode+space(6),1,6)

	sele mpend
	seek mvcn+mord.ordno
	if found()
		repl itemope with itemope+fcol.amount
		repl balance with final-itemope
	endif
endsc
close table all

&&SUPPLIER
@rowno,10 say '**** Importing Supplier Outstanding From Purchase-1  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\purchase1 alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
tot1=0
	supcode='E'+alltri(str(fout.supplier_id))
	mvcn=alltr((fout.invoice_no))
	sele mord
	seek substr(supcode+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.invoice_date
	repl vcn with mvcn
	repl invtype with 'O'
	repl itempro with fout.purchase_id
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->accounts_amount),abs(fout->accounts_amount))
	repl balance with iif(acgroup='D31',-abs(fout->accounts_amount-tot1),abs(fout->accounts_amount-tot1))
	repl itemope with iif(acgroup='D31',-abs(tot1),abs(tot1))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

@rowno,10 say '**** Importing Supplier Outstanding From Purchase-2  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\purchase2 alias fout
sele sele(1)
use &datatransferpath\ledger2 alias fcol
index on str(party_id,9)+str(against,9) to fcol

sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
tot1=0
	supcode='E'+alltri(str(fout.supplier_id))
	mvcn=alltr((fout.invoice_no))
	sele mord
	seek substr(supcode+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.invoice_date
	repl vcn with mvcn
	repl invtype with 'O'
	repl itempro with fout.purchase_id
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->accounts_amount),abs(fout->accounts_amount))
	repl balance with iif(acgroup='D31',-abs(fout->accounts_amount-tot1),abs(fout->accounts_amount-tot1))
	repl itemope with iif(acgroup='D31',-abs(tot1),abs(tot1))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing Supplier Outstanding From Purchase-3  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\purchase3 alias fout
sele sele(1)
use &datatransferpath\ledger3 alias fcol
index on str(party_id,9)+str(against,9) to fcol

sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
tot1=0
	supcode='E'+alltri(str(fout.supplier_id))
	mvcn=alltr((fout.invoice_no))
	sele mord
	seek substr(supcode+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.invoice_date
	repl vcn with mvcn
	repl invtype with 'O'
	repl itempro with fout.purchase_id
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->accounts_amount),abs(fout->accounts_amount))
	repl balance with iif(acgroup='D31',-abs(fout->accounts_amount-tot1),abs(fout->accounts_amount-tot1))
	repl itemope with iif(acgroup='D31',-abs(tot1),abs(tot1))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

@rowno,10 say '**** Importing Supplier Payment From Ledger-1 ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
index on str(itempro,9)+substr(ord+space(6),1,6) to mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on  ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\ledger1 alias fcol
set filt to group_name='Sundry Creditors '
sele fcol
go top
scan
	msupcode='E'+alltri(str(fcol.party_id))
	
	sele mord
	seek substr(msupcode+space(6),1,6)
	sele mpend
	seek str(fcol.against,9)+mord.ordno
	if found()
		repl itemope with iif(mord.scode='C6',(abs(itemope)+fcol.amount),-(abs(itemope)+fcol.amount))
		repl balance with iif(mord.scode='C6',(final-itemope),-(abs(final)-abs(itemope)))
	endif
endsc
close table all

@rowno,10 say '**** Importing Supplier Payment From Ledger-2 ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
index on str(itempro,9)+substr(ord+space(6),1,6) to mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on  ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\ledger2 alias fcol
set filt to group_name='Sundry Creditors '
sele fcol
go top
scan
	msupcode='E'+alltri(str(fcol.party_id))
	sele mord
	seek substr(msupcode+space(6),1,6)
	sele mpend
	seek str(fcol.against,9)+mord.ordno
	if found()
		repl itemope with iif(mord.scode='C6',(abs(itemope)+fcol.amount),-(abs(itemope)+fcol.amount))
		repl balance with iif(mord.scode='C6',(final-itemope),-(abs(final)-abs(itemope)))
	endif
endsc
close table all
@rowno,10 say '**** Importing Supplier Payment From Ledger-3 ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
index on str(itempro,9)+substr(ord+space(6),1,6) to mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on  ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\ledger3 alias fcol
set filt to group_name='Sundry Creditors '
sele fcol
go top
scan
	msupcode='E'+alltri(str(fcol.party_id))
	sele mord
	seek substr(msupcode+space(6),1,6)
	sele mpend
	seek str(fcol.against,9)+mord.ordno
	if found()
		repl itemope with iif(mord.scode='C6',(abs(itemope)+fcol.amount),-(abs(itemope)+fcol.amount))
		repl balance with iif(mord.scode='C6',(final-itemope),-(abs(final)-abs(itemope)))
	endif
endsc
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
retu

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
*!*	EOF : Medisoft Kerla PH WH .....Dated    : 26/09/2025   Author : SARVESH
