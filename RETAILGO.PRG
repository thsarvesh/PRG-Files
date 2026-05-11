*!*	BOF : RETAIL GO.PRG .....Dated    : 25/03/2025   Author : SARVESH
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
	firstdate=ctod('01/04/2024')
	lastdate =ctod('31/03/2025')
	datdev='D:\transfer\'
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Mar\Retailgo\dbf\'+space(95),1,95) &&rpos_path
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
@13,10 say 'RETAIL GO Data Path     :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'RETAIL GO Extension     :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing RETAIL GO  Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\style alias prod
sele sele(1)
use &datatransferpath\ITEM alias fitm
index on item_key to fitm
sele sele(1)
use &datatransferpath\unit alias funit
index on cobr_id to funit
sele sele(1)
use &datatransferpath\TaxTermsTDS alias ftax
index on txtmtds_key to ftax
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele prod
scan 
	=seek(prod.item_key,'fitm')
	=seek(fitm.unit_key,'funit')
	=seek(fitm.tax_key,'ftax')
	sele mitm
	appen blank
	repl code with recno()
	repl name with prod.style_key
	repl product with prod.style_code
	repl bookname with fitm.item_desc
	repl packing with ''
	repl billname with prod.style_code
	repl gcode with fitm.itemgrp_key
	repl gcode3 with fitm.itemsubgrp_key
	repl pack WITH 0
	repl unit with funit.unit_name
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with prod.min_level
	repl mitm.maximum with prod.max_level
	repl mitm.halfsche with 'A'
	repl mrp with prod.mrp
	repl ratea with prod.sprice
	repl prate with prod.purrate
	repl lprate with prod.landing_cost
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	mtax=ftax.txtmtds_perc
	repl saltax with mtax/2
	repl cgst   with mtax/2
	repl igst   with mtax
mhsn=prod.hsncode	
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
&&& CATEGORY
	sele mpcm
	seek 'CATEGO' + substr(fitm.item_desc+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'cH'+alltrim(str(recno())),;
			mpcm.sname  with fitm.item_desc,;
			mpcm.parnam with fitm.item_desc,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode5 with mpcm.scode

endscan
close table all
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\itemgrp.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
		append blank
		repl mpcm.sgcode with 'ZZZZZZ  '
		repl mpcm.scode  with fpcm.itemgrp_key
		repl mpcm.sname  with fpcm.itemgrp_name
		repl mpcm.parnam with fpcm.itemgrp_name
		repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Salt ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\itemsubgrp.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
		append blank
		repl mpcm.sgcode with 'SALT  '
		repl mpcm.scode  with fpcm.itemsubgrp_key
		repl mpcm.sname  with fpcm.itemsubgrp_name
		repl mpcm.parnam with fpcm.itemsubgrp_name
		repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemstock alias fsbal
sele sele(1)
use &datatransferpath\itemsize alias fsize
index on itemsize_key to fsize
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
go top
scan
	=seek(fsbal.itemsize_key,'fsize')
   sele mitm
   seek substr(fsbal.style_key+space(10),1,10)
   sele msbal
   seek substr(fsbal.style_key+space(10),1,10)+substr(fsize.size_name+space(12),1,12)
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
           msbal.opening with fsbal.clqty,;
           msbal.balance with fsbal.clqty,;
           msbal.o_a with fsbal.clqty,;
           msbal.b_a with fsbal.clqty,;
           msbal.batchno with alltri(str(recno()))
        repl msbal.mybatch with fsize.size_name
     	repl msbal.exp with ctod(''),;
           msbal.mrp with fsbal.mrp,;
           msbal.prate with fsbal.purrate,;
           msbal.ratea with fsbal.srate,;
           msbal.lprate with fsbal.landing_cost,;           
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
        repl msbal.mycode with fsbal.barcode
	   else
          repl msbal.opening with msbal.opening + fsbal.clqty,;
	           msbal.balance with msbal.balance + fsbal.clqty,;
	           msbal.o_a with msbal.o_a + fsbal.clqty,;
	           msbal.b_a with msbal.b_a + fsbal.clqty
   endif
endscan
close table all
@rowno,10 say '**** Importing Ledger Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ledger alias fact
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
		case inlist(fact.acclgrp_key,'016  ','0126 ')
			mscode='D31'
		case inlist(fact.acclgrp_key,'014  ','013  ')
			mscode='C6'
		case inlist(fact.acclgrp_key,'011  ')
			mscode='C2'
		case inlist(fact.acclgrp_key,'012  ')
			mscode='C1'
	otherwise
		mscode='J12'
	endcase
	repl mact.scode with mscode
	repl mact.rate with 'Y'
	repl mact.ordno with fact.led_key
	repl mact.fax2 with fact.led_id
	repl mact.parnam  with fact.led_name
	repl mact.mailnam with fact.led_name
	repl mact.paradd with fact.oaddr
	repl mact.paradd1 with ''
	repl mact.paradd2 with ''
	repl mact.city with fact.oplace
	repl mact.dsm with fact.opin
	repl mact.itno with fact.panno
	repl mact.dlno with ''
	repl stno with fact.vatno
	repl cstno with fact.cstno
	repl gstno with fact.gstno
	repl phone1 with fact.mobile1
	repl phone4 with fact.smsmobile1
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
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
use &datatransferpath\purchase alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
scan 
	mvcn=alltr(fout.chln_no)
	sele mord
	seek subst(fout.supl_key+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.chln_dt
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->net_amt),abs(fout->net_amt))
	repl balance with iif(acgroup='D31',-abs(fout.balamt),abs(fout.balamt))
	repl itemope with iif(acgroup='D31',-abs(fout->net_amt-fout.balamt),abs(fout->net_amt-fout.balamt))
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
*!*	EOF : RETAIL GO.PRG .....Dated    : 25/03/2025   Author : SARVESH
