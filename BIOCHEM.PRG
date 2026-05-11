*!*	BOF : BIOCHEM.PRG .....Dated    : 24/02/2023   Author : SARVESH
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
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Oct\BIOCHEM\data\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='36'
removenull = 'NO'


@13,10 say 'BIOCHEM Data Path       :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'BIOCHEM Extension       :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing BIOCHEM Data To Marg.....' font 'courier',14 colo 'W+/b'
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





@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\invitems alias fitm
*!*	sele sele(1)
*!*	use &datatransferpath\batch alias fsbal
*!*	index on p_code to fsbal
*!*	sele sele(1)
*!*	use &datatransferpath\tax alias ftx
*!*	index on tcode to ftx
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
sele fitm
scan
*!*		=seek(fitm.p_code,'fsbal')
*!*		=seek(fsbal.gsno,'ftx')
	sele mitm
	appen blank
	repl code with fitm.itemid
	repl name with fitm.itemcode
	repl product with upper(fitm.itemname)
	repl packing with fitm.pack
	repl billname with upper(fitm.itemname)
	repl pack WITH 0
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl formulano with substr(fitm.manufactu2,1,15)
	repl maximum with fitm.maximumlev
	repl saltax with fitm.gstpercent/2
	repl cgst   with fitm.gstpercent/2
	repl igst   with fitm.gstpercent
	
&&& HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(fitm.hsncode+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with fitm.hsncode,;
			mpcm.parnam with fitm.hsncode,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
*!*	&&& COMPANY
*!*		sele mpcm
*!*		seek 'ZZZZZZ' + substr(fitm.manufactu2+space(40),1,40) 
*!*		if !found()
*!*			append blank
*!*			repl mpcm.sgcode with 'ZZZZZZ',;
*!*				mpcm.scode  with 'p'+alltrim(str(recno())),;
*!*				mpcm.sname  with fitm.manufactu2,;
*!*				mpcm.parnam with fitm.manufactu2,;
*!*				mpcm.tcode with 'No'
*!*		endif
*!*		repl mitm.gcode with mpcm.scode

&&& CATEGORY
	sele mpcm
	seek 'CATEGO' + substr(fitm.categoryna+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with fitm.categoryna,;
			mpcm.parnam with fitm.categoryna,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode5 with mpcm.scode
endscan
close table all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\invbatches alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
*set filt to productid=31176
go top
do while !eof()
   sele mitm
   seek  str(fsbal.itemid,9)
   sele msbal
   seek str(fsbal.itemid,9)+ substr(fsbal.batchnumbe+space(12),1,12)
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
           msbal.opening with fsbal.currentsto,;
           msbal.balance with fsbal.currentsto,;
           msbal.o_a with fsbal.currentsto,;
           msbal.b_a with fsbal.currentsto,;
           msbal.batchno with fsbal.batchnumbe
        repl supcode with 'K'+alltri(str(fsbal.supplierid))
        repl packing with fsbal.packing
     	repl msbal.exp with fsbal.expirydate,;
           msbal.prate with fsbal.purchasera,;
           msbal.ratea with fsbal.retailrate,;
           msbal.ratea with fsbal.wholesaler,;
           msbal.lprate with fsbal.currentcos,;           
           msbal.mrp with fsbal.mrpperunit,;
           msbal.misc1 with mitm.gcode
	   else
          repl supcode with 'K'+alltri(str(fsbal.supplierid))
          repl msbal.opening with msbal.opening + fsbal.currentsto,;
	           msbal.balance with msbal.balance + fsbal.currentsto,;
	           msbal.o_a with msbal.o_a + fsbal.currentsto,;
	           msbal.b_a with msbal.b_a + fsbal.currentsto
   endif
sele fsbal
skip
enddo
sele msbal
close table all

@rowno,10 say '**** Importing Suppliers  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\invsuppliers alias fact
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
	repl mact.ordno with 'K'+alltri(str(fact.supplierid))
	repl mact.fax2 with alltri(fact.supplierco)
	repl mact.parnam  with fact.supplierna
	repl mact.mailnam with fact.supplierna
	repl mact.paradd with fact.address1
	repl mact.paradd1 with fact.address2
	repl mact.paradd2 with fact.address3
	repl confir with fact.contactper
	repl phone1 with substr(fact.mobilephon,1,10)
	repl phone2 with substr(fact.phone,1,10)
	repl phone3 with substr(fact.phone,11,12)
	repl dlno with alltri(fact.druglicenc)
	repl stno with fact.kgstnumber
	repl cstno with fact.cstnumber
	repl gstno with fact.gstin 
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'

	sele support
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 12
	repl remark with substr(fact.email,1,40)+substr(support.remark,41,100),;
		heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')

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
endscan
close tables all

@rowno,10 say '**** Importing Customers  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\invcustomers alias fact
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
	repl mact.ordno with 'L'+alltri(str(fact.customerid))
	repl mact.fax2 with alltri(fact.customerco)
	repl mact.parnam  with fact.customerna
	repl mact.mailnam with fact.customerna
	repl mact.paradd with fact.address
	repl mact.paradd1 with fact.address1
	repl mact.paradd2 with fact.address2
	repl mact.city with fact.cityname
	repl confir with iif(!empty(fact.contactper),fact.contactper,fact.adharnumbe)
	repl phone1 with substr(fact.phone,1,10)
	repl phone2 with substr(fact.phone,1,10)
	repl phone3 with substr(fact.phone,11,12)
	repl dlno with alltri(fact.druglicenc)
	repl stno with fact.tinnumber
	repl cstno with fact.cstnumber
	repl gstno with fact.gstin 
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'

	sele support
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 12
	repl remark with substr(fact.email,1,40)+substr(support.remark,41,100),;
		heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
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
&&&&Rout
sele mpcm
seek ('ROUT  '+substr(fact.routename+space(40),1,40))
	if !found()
		appen blank
		repl sgcode with 'ROUT  '
		repl sname with fact.routename
		repl parnam with fact.routename
		repl scode with 'R'+alltrI(str(recno()))
	endif
repl mact.rout with mpcm.scode
endscan
close tables all
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
use &datatransferpath\invsalesmaster alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan 
	mvcn=alltr(fout.billnumber)
	ledcod='L'+alltri(str(fout.customerid))
	sele mord
	seek substr(ledcod+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.billdate
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->totalamoun),abs(fout->totalamoun))
	repl balance with iif(acgroup='D31',-abs(fout.totalamoun-fout.partpaymen),abs(fout.totalamoun-fout.partpaymen))
	repl itemope with iif(acgroup='D31',-abs(fout.partpaymen),abs(fout.partpaymen))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
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
use &datatransferpath\invPurchaseMaster alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan 
	mvcn=alltr(fout.invoicenum)
	ledcod='K'+alltri(str(fout.supplierid))
	sele mord
	seek substr(ledcod+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.invoicedat
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->netamount),abs(fout->netamount))
	repl balance with iif(acgroup='D31',-abs(fout.netamount-fout.partpaymen),abs(fout.netamount-fout.partpaymen))
	repl itemope with iif(acgroup='D31',-abs(fout.partpaymen),abs(fout.partpaymen))
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
return
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

*!*	EOF : BIOCHEM.PRG .....Dated    : 24/02/2023   Author : SARVESH
