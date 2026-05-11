*!*	BOF : MDSOFT.PRG .....Dated    : 21/11/2024   Author : SARVESH
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
	firstdate=ctod('01/04/2022')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2023')                         && Un-Comment this for run from VFP
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\Data_Migration\Sep\mdsoft\dbf\'+space(95),1,95) &&rpos_path
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
@13,10 say 'MD Data Path            :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'MD Extension            :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing MD Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\strcnts alias fitm

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
	repl code with fitm.pcode
	repl name with alltri(str(fitm.pcode))
	repl product with fitm.pro_name
	repl packing with ''
	repl billname with fitm.pro_name
	repl pack WITH val(fitm.uom)
	repl rackno with fitm.rack
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with fitm.min
	repl mitm.maximum with fitm.max
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.nmrp
	repl mitm.ratea with fitm.netrate
	repl mitm.prate with fitm.trade
	mtax=0
	repl saltax with mtax
	repl cgst   with mtax
	repl igst   with mtax
mhsn=''	
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
&&& COMPANY
	sele mpcm
	seek 'ZZZZZZ' + substr(fitm.manfr+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'Z'+alltrim(str(recno())),;
			mpcm.sname  with fitm.manfr,;
			mpcm.parnam with fitm.manfr,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
&&& salt
	sele mpcm
	seek 'SALT  ' + substr(fitm.generic+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'S'+alltrim(str(recno())),;
			mpcm.sname  with fitm.generic,;
			mpcm.parnam with fitm.generic,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
&&& Category
	sele mpcm
	seek 'CATEGO' + substr(fitm.category+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with fitm.category,;
			mpcm.parnam with fitm.category,;
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
use &datatransferpath\brand.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	seek 'ZZZZZZ' + substr(fpcm.brand+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ  '
		repl mpcm.scode  with 'P'+alltri(str(recno()))
		repl mpcm.sname  with fpcm.brand
		repl mpcm.parnam with fpcm.brand
		repl mpcm.tcode with 'No'
	endif
endsc
close table all

@rowno,10 say '**** Importing Salt ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\generic.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
		append blank
		repl mpcm.sgcode with 'SALT  '
		repl mpcm.scode  with 'G'+alltri(str(fpcm.gcode))
		repl mpcm.sname  with fpcm.gname
		repl mpcm.parnam with fpcm.gname
		repl mpcm.tcode with 'No'
endsc
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
	seek 'CATEGO' + substr(fpcm.gname+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO'
		repl mpcm.scode  with 'R'+alltri(str(fpcm.gcode))
		repl mpcm.sname  with fpcm.gname
		repl mpcm.parnam with fpcm.gname
		repl mpcm.tcode with 'No'
	endif
endsc
close table all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
do while !eof()
   sele mitm
   seek str(fsbal.pcode,9)
   sele msbal
   seek str(fsbal.pcode,9)+substr(fsbal.batch+space(12),1,12)
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
           msbal.opening with fsbal.batchstk,;
           msbal.balance with fsbal.batchstk,;
           msbal.o_a with fsbal.batchstk,;
           msbal.b_a with fsbal.batchstk,;
           msbal.batchno with fsbal.batch
     	repl msbal.exp with fsbal.expiry,;
           msbal.mrp with fsbal.srate,;
           msbal.prate with fsbal.prate,;
           msbal.ratea with fsbal.srate,;
           msbal.lprate with fsbal.prate,;           
           msbal.mrp with fsbal.srate,;
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
        repl mitm.cgst with fsbal.cgst
        repl mitm.saltax with fsbal.cgst
        repl mitm.igst with iif(empty(fsbal.cgst),fsbal.igst,fsbal.cgst*2)
        repl supdat with fsbal.invdate
        repl supinvo with fsbal.invno
	   else
          repl msbal.opening with msbal.opening + fsbal.batchstk,;
	           msbal.balance with msbal.balance + fsbal.batchstk,;
	           msbal.o_a with msbal.o_a + fsbal.batchstk,;
	           msbal.b_a with msbal.b_a + fsbal.batchstk
   endif
sele fsbal
skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Doctor Master****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\doctor.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PRE#$~'
sele fdoc
go top
scan
   sele mdoc 
   append blank
   repl mdoc.scode with 'PRE#$~',;
        mdoc.ordno with alltrim(str(fdoc.code)),;
        mdoc.parnam with fdoc.name,;
        mdoc.form with alltrim(str(fdoc.code))
endsc
close data all

@rowno,10 say '**** Importing Patient Master  ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\patient.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PET#$~'
sele fdoc
go top
scan
   sele mdoc 
   append blank
   repl mdoc.scode with 'PET#$~',;
        mdoc.ordno with alltrim(str(fdoc.cellno)),;
        mdoc.parnam with fdoc.paname,;
        mdoc.form with alltrim(str(fdoc.cellno))
endsc
close data all
=Messagebox('Master Transfer has been done,Please check the data','MargErp')
retu
@rowno,10 say '**** Importing Customer Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\chemist alias fact

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
	repl mact.ordno with alltri(str(fact.s_code))
	repl mact.fax2 with alltri(str(fact.s_code))
	repl mact.parnam  with fact.s_name
	repl mact.mailnam with fact.s_name
	repl mact.paradd with iif(isnull(fact.address),'',fact.address)
	repl mact.paradd1 with iif(isnull(fact.add1),'',fact.add1)
	repl mact.paradd2 with iif(isnull(fact.add2),'',fact.add2)
	repl mact.city with iif(isnull(fact.place),'',fact.place)
	repl mact.dsm with fact.pin
	repl mact.itno with iif(isnull(fact.it_no),'',fact.it_no)
	repl mact.dlno with iif(isnul(fact.dlno1),'',fact.dlno1)+' '+iif(isnul(fact.dlno2),'',fact.dlno2)
	repl gstno with iif(isnull(fact.st_no),'',fact.st_no)
	repl phone1 with iif(isnull(fact.cell),'',fact.cell)
	repl phone4 with iif(isnull(fact.phone),'',fact.phone)
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
*!*	EOF : MDSOFT.PRG .....Dated    : 21/11/2024   Author : SARVESH
