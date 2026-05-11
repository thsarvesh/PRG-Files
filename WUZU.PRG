*!*	BOF : wuzu.PRG .....   Author : SARVESH
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
IF TYPE('FINALCP')='U'
	firstdate=ctod('01/04/2022')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2023')                         && Un-Comment this for run from VFP
	datdev='D:\transfer'                                 && Un-Comment this for run from VFP
	datext='dbf'
ENDIF

sure= space(4)
datatransferpath=substr('D:\June\7A5199EB\dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='23'
removenull = 'NO'


@13,10 say 'WUZU Data Path          :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'WUZU Extension          :'  font 'Courier',18 get datatransferext  font 'courier',18
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
IF TYPE('FINALCP')#'U'
	=starttransfer()
ENDIF
clear
rowno=5
@ 02,25 say 'Please Wait..Importing wuzu  Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\itemmst alias fitm
sele sele(1)
use &datatransferpath\gsttaxmst alias fgst
index on gstid to fgst
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
	=seek(fitm.gstid,'fgst')
	sele mitm
	appen blank
	repl code with fitm.itemid
	repl name with alltrim(str(fitm.itemid))
	repl product with fitm.itemname
	repl packing with ''
	repl billname with fitm.itemname
	repl pack WITH 0
	repl rackno with ''
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.halfsche with 'A'
	repl gcode with padr(fitm.brandid,6)
	repl gcode5 with padr(fitm.categoryid,6)
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with fgst.gsttaxpercentage/2
	repl cgst   with fgst.gsttaxpercentage/2
	repl igst   with fgst.gsttaxpercentage
	replace mrp with fitm.mrp
	replace prate with fitm.purchaseprice
	replace ratea with fitm.saleprice
	replace lprate with fitm.purchaseprice
	
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
endscan
close table all
@rowno,10 say '**** Importing Brand ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itembrandmst alias fpcm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan
	sele mpcm
	appen blank
	repl sgcode with 'ZZZZZZ'
	repl scode with padr(fpcm.brandid,6)
	repl sname with fpcm.brandname
	repl parnam with fpcm.brandname
endsc
close table all

@rowno,10 say '**** Importing Category ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemcategorymst alias fpcm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan
	sele mpcm
	appen blank
	repl sgcode with 'CATEGO'
	repl scode with padr(fpcm.categoryid,6)
	repl sname with fpcm.categoryname
	repl parnam with fpcm.categoryname
endsc
close table all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\vouchersubdetail alias fsbal

sele sele(1)
use &datatransferpath\ItemAttributes alias fc
index on str(itemid,9)+str(attributevalueid,9) to fc

sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9) to msbal
sele fsbal
*set filt to productid=31176
go top
scan for stockaddless>0
	=seek (str(fsbal.itemid,9)+str(fsbal.attributevalueid,9),'fc')
   sele mitm
   seek  str(fsbal.itemid,9)
   sele msbal
   seek str(fsbal.itemid,9)
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.packing with fc.attributevalue
      repl msbal.unit2 with mitm.unit2
      repl msbal.unit with mitm.unit
      repl msbal.decimal with 'Y'
      repl msbal.opening with abs(fsbal.stockaddless)
      repl msbal.balance with abs(fsbal.stockaddless)
      repl msbal.o_a with abs(fsbal.stockaddless)
      repl msbal.b_a with abs(fsbal.stockaddless)
      repl batchno with '_6Y01Q'+alltri(str(recno())) 
      repl mycode with alltri(fsbal.serialnumber),;
           msbal.mrp with mitm.mrp,;
           msbal.prate with mitm.prate,;
           msbal.ratea with mitm.ratea,;
           msbal.lprate with mitm.prate,;           
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
endsc
close table all

@rowno,10 say '**** Importing Account Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\accounts alias fact

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
	do case
		case fact.accounttypeid=12
			repl mact.scode with 'C6'
		case fact.accounttypeid=16
			repl mact.scode with 'D31'
		case fact.accounttypeid=8
			repl mact.scode with 'C2'
		otherwise
			repl mact.scode with 'J12'
	endcase
	repl mact.rate with 'Y'
	repl mact.ordno with 'F'+alltri(str(fact.accountid))
	repl mact.fax2 with alltri(str(fact.accountid))
	repl mact.parnam  with fact.name
	repl mact.mailnam with fact.name
	repl mact.paradd with substr(fact.addressline1,1,40)
	repl mact.paradd1 with substr(fact.addressline1,41,40)
	repl mact.paradd2 with alltri(fact.state)+' '+alltri(fact.country)
	repl mact.city with fact.city
	repl mact.dsm with fact.zipcode
	repl mact.itno with fact.pannumber
	repl gstno with fact.gstinnumber
	repl phone1 with fact.contactnumber1
	repl phone4 with fact.contactnumber2
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl opning with fact.balancedr
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

*!*	EOF : MD.PRG .....Dated    : 03/11/2022   Author : SARVESH
