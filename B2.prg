*!*	BOF :B2.PRG .....Dated    : 05-08-2024  Author : Sarvesh 
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
ENDIF

sure= space(4)
datatransferpath=substr('D:\Aug\B2\dbf\'+space(95),1,95) &&rpos_path

datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='21'
removenull = 'NO'
@13,10 say 'B2 Data Path            :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'B2 Extension            :'  font 'Courier',18 get datatransferext  font 'courier',18
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
ENDIF
clear
rowno=5
@ 02,25 say 'Please Wait..Importing B2 Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\itemmaster01 alias fitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
sele fitm
scan
	sele mitm
	appen blank
	repl code with recno()
	repl name with fitm.itemcode
	repl product with fitm.itemname
	repl packing with ''
	repl billname with fitm.itemname
	repl pack WITH 0
	repl rackno with ''
	repl gcode with fitm.cmpcode
	repl gcode3 with fitm.divcd
	repl unit with fitm.lowerdesc
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with fitm.entrytax/2
	repl cgst   with fitm.entrytax/2
	repl igst   with fitm.entrytax
&&& HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(fitm.refcode+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with fitm.refcode,;
			mpcm.parnam with fitm.refcode,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Company Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\cmpmst01 alias fpcm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan
   sele mpcm
   append blank
   repl mpcm.sgcode with 'ZZZZZZ',;
		mpcm.scode  with fpcm.cmpcode,;
		mpcm.sname  with fpcm.cmpname,;
		mpcm.parnam with fpcm.cmpname,;
		mpcm.tcode with 'No'
endsc
close table all

@rowno,10 say '**** Importing Division Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\divmaster01 alias fpcm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan
   sele mpcm
   append blank
   repl mpcm.sgcode with 'SALT  ',;
		mpcm.scode  with fpcm.code,;
		mpcm.sname  with fpcm.division,;
		mpcm.parnam with fpcm.division,;
		mpcm.tcode with 'No'
endsc
close table all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ratemaster01 alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
*set filt to productid=31176
go top
do while !eof()
   sele mitm
   seek substr(fsbal.itemcode+space(10),1,10)
   sele msbal
   seek substr(fsbal.itemcode+space(10),1,10)+str(fsbal.mrp,9,2)
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
           msbal.opening with fsbal.cbqt,;
           msbal.balance with fsbal.cbqt,;
           msbal.o_a with fsbal.cbqt,;
           msbal.b_a with fsbal.cbqt,;
           msbal.batchno with str(fsbal.mrp,9,2)
     	repl msbal.exp with ctod(''),;
           msbal.mrp with fsbal.mrp,;
           msbal.prate with fsbal.purrate,;
           msbal.ratea with fsbal.salrtlrate,;
           msbal.rateb with fsbal.salwsrate,;
           msbal.lprate with fsbal.purrate,;           
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
	   else
          repl msbal.opening with msbal.opening + fsbal.cbqt,;
	           msbal.balance with msbal.balance + fsbal.cbqt,;
	           msbal.o_a with msbal.o_a + fsbal.cbqt,;
	           msbal.b_a with msbal.b_a + fsbal.cbqt
   endif
sele fsbal
skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\partymaster01 alias fact
sele sele(1)
use &datatransferpath\aremst01 alias fpcm
index on am_arcd to fpcm
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	=seek(fact.ar_arcd,'fpcm')	
	sele mact
	appen blank
	workcode='  '
	do case
		case fact.ptytype='Debtors '
			workcode='C6'
		case fact.ptytype='Creditors '
			workcode='D31'
		case fact.ptytype='Sales Man '
			workcode='D32'
		otherwise 
			workcode='J12'
	endcase
	repl mact.scode with workcode
	repl mact.rate with 'Y'
	repl mact.ordno with 'A'+alltri(str(recno()))
	repl mact.fax2 with fact.partycode
	repl mact.parnam  with fact.partyname
	repl mact.mailnam with fact.partyname
	repl mact.paradd with substr(fact.address,1,40)
	repl mact.paradd1 with substr(fact.address,41,40)
	repl mact.paradd2 with substr(fact.address,81,40)
	repl mact.city with fpcm.am_area
	repl mact.confir with fact.cntperson
	repl mact.dsm with ''
	repl mact.itno with fact.pan
	repl mact.dlno with fact.dlno
	repl phone1 with fact.phone
	repl phone4 with fact.cell
	repl mact.gstno with fact.email
	repl stno with fact.tin
	repl cstno with fact.srin
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl opning with fact.ptyobdr-fact.ptyobcr
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
&&&area update
	sele mpcm
	seek 'AREA  '+substr(fpcm.am_area+space(40),1,40)
		if !found()
			appen blank
			repl sgcode with 'AREA  '
			repl sname with fpcm.am_area
			repl parnam with fpcm.am_area
			repl scode with 'S'+alltri(str(recno()))
		endif
	repl mact.area with mpcm.scode
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

*!*	EOF :B2.PRG .....Dated    : 05-08-2024  Author : Sarvesh 
