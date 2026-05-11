*!*	BOF : CHIRAG SOFTWARE.PRG .....Dated    : 06/03/2025   Author : SARVESH THAKUR
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
datatransferpath=substr('D:\2025\Mar\Chirag_Banglore\chirag\'+space(95),1,95) &&rpos_path
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
@13,10 say 'CHIRAG Data Path        :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'CHIRAG Extension        :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing Chirag Software Garment Data To Marg.....' font 'tahoma',20,1 colo RGB(247,243,247,94,60,90)
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
use &datatransferpath\fam_Items alias fitm
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
	repl name with fitm.itemid
	repl rackno with fitm.itemcode
	repl product with fitm.itemname
	repl packing with ''
	repl billname with fitm.itemname
	repl pack WITH 0
	repl unit with fitm.uom
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.gcode with fitm.groupid
	repl mitm.gcode3 with fitm.colourid
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	mtax=5
	repl saltax with mtax/2
	repl cgst   with mtax/2
	repl igst   with mtax
mhsn=fitm.hsnsac	
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
use &datatransferpath\fam_itemgroups.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
		append blank
		repl mpcm.sgcode with 'ZZZZZZ  '
		repl mpcm.scode  with fpcm.groupid
		repl mpcm.sname  with fpcm.groupname
		repl mpcm.parnam with fpcm.groupname
		repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Ledger Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\fam_acmaster alias fact
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
			case fact.actype=4
				repl mact.scode with 'C6'
			case fact.actype=3
				repl mact.scode with 'D31'
			case fact.actype=2
				repl mact.scode with 'C1'
			case fact.actype=1
				repl mact.scode with 'C2'
			otherwise
				repl mact.scode with 'J12'
		endcase				
	repl mact.rate with 'Y'
	repl mact.ordno with fact.acid
	repl mact.fax2 with fact.accode
	repl mact.parnam  with fact.achead
	repl mact.mailnam with fact.achead
	repl mact.paradd with substr(fact.ptyaddress,1,30)
	repl mact.paradd1 with substr(fact.ptyaddress,31,30)
	repl mact.paradd2 with substr(fact.ptyaddress,61,30)
	repl mact.area with fact.areaid
	repl mact.rout with fact.agentid
	repl gstno with fact.gstin
	repl phone1 with fact.phone
	repl phone3 with fact.fax
	repl phone4 with fact.phone
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
@rowno,10 say '**** Importing A/C Outstandings Opening ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\fam_OBRef alias fout
sele sele(1)
use &datatransferpath\fat_ReceiptAdj alias frec
index on rinvno to frec
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
scan 
	sele frec
	seek fout.uvno
	if !foun()
		mser=getwordnum(fout.docno,3,'/')
		mbi=getwordnum(fout.docno,4,'/')
		mvcn=right(alltri(fout.docno),12)&&mser+"/"+mbi
		sele mord
		seek substr(fout.acid+space(6),1,6)
		sele mpend
		appen blan
		repl acgroup with mord->scode
		repl ord with mord.ordno
		repl ddate with fout.docdate
		repl vcn with mvcn
		repl invtype with 'O'
		repl voucher  with vou
		repl svoucher with svou
		repl final with fout.docamt
		repl balance with fout.docamt
		repl name with vcn
	endif
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

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
use &datatransferpath\fat_invoice alias fout
sele sele(1)
use &datatransferpath\fam_forms alias fser
index on spid to fser
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
scan 
	=seek(fout.spid,'fser')
	mser=getwordnum(fser.billtitle,2,'/')
	mvcn=mser+"/"+padl(fout.invno,5,'0')
	sele mord
	seek substr(fout.acid+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.invdate
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->invamt),abs(fout->invamt))
	repl itemope with iif(acgroup='D31',-abs(fout->recamt),abs(fout->recamt))
	repl balance with iif(acgroup='D31',-(abs(fout.invamt)-abs(fout.recamt)),abs(fout.invamt)-abs(fout.recamt))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing A/C Outstandings Credit Notes ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\fat_SalesReturns alias fout
sele sele(1)
use &datatransferpath\fat_ReceiptAdj alias frec
index on rinvno to frec
sele sele(1)
use &datatransferpath\fam_forms alias fser
index on spid to fser
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
scan 
	=seek(fout.spid,'fser')
	mser=alltri(fser.billtitle)
	mvcn=mser+alltri(str(fout.cnno))
	sele frec
	seek fout.uvno
	if !foun()
		sele mord
		seek substr(fout.acid+space(6),1,6)
		sele mpend
		appen blan
		repl acgroup with mord->scode
		repl ord with mord.ordno
		repl ddate with fout.cndate
		repl vcn with right(mvcn,12)
		repl invtype with 'O'
		repl voucher  with vou
		repl svoucher with svou
		repl final with -fout.cnamt
		repl balance with -fout.cnamt
		repl name with vcn
	endif
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
