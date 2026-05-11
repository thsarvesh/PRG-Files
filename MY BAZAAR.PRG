*!*	BOF : Mybazzar .PRG .....Dated    : 29/11/2024   Author : SARVESH
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
	firstdate=ctod('01/04/2024')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2025')                         && Un-Comment this for run from VFP
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\Data_Migration\Nov\Mybazar\Dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='27'
removenull = 'NO'
@13,10 say 'Mybazzar Data Path      :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'Mybazzar Extension      :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing Mybazzar Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\itmaster alias fitm
sele sele(1)
use &datatransferpath\gstslab alias ftax
index on taxcode to ftax
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
	repl code with fitm.itcode
	repl name with alltri(str(fitm.itcode))
	repl product with fitm.itname
	repl packing with fitm.weight
	repl billname with product+packing
	repl pack WITH 0
	repl rackno with fitm.barcode
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.maximum with 0
	repl mitm.gcode with padr(fitm.itgcode,6)
	repl mitm.gcode3 with padr(fitm.deptcode,6)
	repl mitm.gcode5 with padr(fitm.itsubgcode,6)
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl prate with fitm.purrate,mrp with fitm.mrp,;
		 ratea with fitm.salerate,fixdis with fitm.discper
	=seek(fitm.taxcode,'ftax')	 
	mtax=ftax.Igstper
	repl saltax with mtax
	repl cgst   with mtax
	repl igst   with mtax
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
endscan
close table all

@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\itgroup.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
		append blank
		repl mpcm.sgcode with 'ZZZZZZ  '
		repl mpcm.scode  with padr(fpcm.itgcode,6)
		repl mpcm.sname  with fpcm.itgname
		repl mpcm.parnam with fpcm.itgname
		repl mpcm.tcode with 'No'
endsc
close table all

@rowno,10 say '**** Importing Salt ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\deptmaster.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
		append blank
		repl mpcm.sgcode with 'SALT  '
		repl mpcm.scode  with padr(fpcm.deptcode,6)
		repl mpcm.sname  with fpcm.deptname
		repl mpcm.parnam with fpcm.deptname
		repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Category****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\itsubgroup.dbf alia fpcm
sele fpcm
go top
scan
		sele mpcm
		append blank
		repl mpcm.sgcode with 'CATEGO'
		repl mpcm.scode  with padr(fpcm.itsubgcode,6)
		repl mpcm.sname  with fpcm.itsubgname
		repl mpcm.parnam with fpcm.itsubgname
		repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Area****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\villagemaster.dbf alia fpcm
sele fpcm
go top
scan
		sele mpcm
		append blank
		repl mpcm.sgcode with 'AREA  '
		repl mpcm.scode  with padr(fpcm.vcode,6)
		repl mpcm.sname  with fpcm.villagename
		repl mpcm.parnam with fpcm.villagename
		repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itstock alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
do while !eof()
	mbal=(opqty+purqty+salertnqty+addqty)-(saleqty+purrtnqty+lessqty)
   sele mitm
   seek str(fsbal.itcode,9)
   sele msbal
   seek str(fsbal.itcode,9)+str(fsbal.mrp,9,2)
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
           msbal.batchno with str(fsbal.mrp,9,2)
     	repl msbal.exp with ctod(''),;
           msbal.mrp with fsbal.mrp,;
           msbal.prate with fsbal.purrate,;
           msbal.ratea with fsbal.salerate,;
           msbal.lprate with fsbal.purrate,;           
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
	   else
          repl msbal.opening with msbal.opening + mbal,;
	           msbal.balance with msbal.balance + fsmbal,;
	           msbal.o_a with msbal.o_a + mbal,;
	           msbal.b_a with msbal.b_a +mbal,;
	           msbal.mrp with fsbal.mpr,;
	           msbal.prate with fsbal.purrate,;
	           msbal.ratea with fsbal.salerate,;
	           msbal.lprate with fsbal.purrate,;           
	           msbal.misc1 with mitm.gcode
   endif
sele fsbal
skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Ledger Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ledgermaster alias fact
sele sele(1)
use &datatransferpath\villagemaster alias fcity
index on vcode to fcity
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
dele all for inlist(aliase,'FODDETAI','ORDER  ')
sele fact
scan
	=seek(fact.vcode,'fcity')
	sele mact
	appen blank
		workcode='  '
		do case
			case fact.gcode=5
				workcode='D31'
			case fact.gcode=4
				workcode='C6'
			case fact.gcode=2
				workcode='C2'
			case fact.gcode=3
				workcode='C1'
			otherwise
				workcode='J12'
		endcase
	repl mact.scode with workcode
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.accode))
	repl mact.parnam  with fact.achead
	repl mact.mailnam with fact.achead
	repl mact.paradd with substr(fact.address,1,30)
	repl mact.paradd1 with substr(fact.address,31,30)
	repl mact.paradd2 with substr(fact.address,61,30)
	repl mact.dsm with fact.pincode,mact.city with fcity.villagename
	repl mact.itno with fact.pancardno
	repl gstno with fact.gstno
	repl phone1 with fact.mobile
	repl phone4 with fact.mobile
	repl area with padr(fact.vcode,6)
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
&&&Food Licence Update		
	sele support
	appen blank
	repl type with 'F' aliase with 'FODDETAI',lcode with mact.ordno
	repl remark with 'Food Licence'+fact.foodlicno
endscan
close tables all
=Messagebox('Master Transfer has been done,Please check the data','MargErp')
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
*!*	EOF : Mybazzar .PRG .....Dated    : 29/11/2024   Author : SARVESH
