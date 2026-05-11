*!*	BOF : FAST SOFT.PRG .....
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
	firstdate=ctod('01/04/2023')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2024')                         && Un-Comment this for run from VFP
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif

sure= space(4)
datatransferpath=substr('D:\DM\Apr\Fas\dbf\data\'+space(95),1,95) &&rpos_path

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


@13,10 say 'FAST SOFT Data Path     :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'FAST SOFT Extension     :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing FAST SOFT Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\msrmst alias HSN
index on groupcode to hsn

sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
sele fitm
scan
	=seek(fitm.msrcode,'hsn')
	sele mitm
	appen blank
	repl code with fitm.itemcode
	repl name with fitm.shrtnm
	repl product with fitm.itemname
	repl packing with ''
	repl billname with fitm.itemname
	replace gcode with padr(fitm.groupcode,6)
	repl pack WITH 0
	repl rackno with ''
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with fitm.vatper
	repl cgst   with fitm.vatper
	repl igst   with fitm.vatper*2
	
&&& HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(hsn.groupname+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with hsn.groupname,;
			mpcm.parnam with hsn.groupname,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
*!*	&&& COMPANY
*!*		sele mpcm
*!*		seek 'ZZZZZZ' + substr(fitm.company+space(40),1,40) 
*!*		if !found()
*!*			append blank
*!*			repl mpcm.sgcode with 'ZZZZZZ',;
*!*				mpcm.scode  with 'p'+alltrim(str(recno())),;
*!*				mpcm.sname  with fitm.company,;
*!*				mpcm.parnam with fitm.company,;
*!*				mpcm.tcode with 'No'
*!*		endif
*!*		repl mitm.gcode with mpcm.scode

*!*	&&& group
*!*		sele mpcm
*!*		seek 'SALT  ' + substr(fitm.type+space(40),1,40) 
*!*		if !found()
*!*			append blank
*!*			repl mpcm.sgcode with 'SALT  ',;
*!*				mpcm.scode  with 'S'+alltrim(str(recno())),;
*!*				mpcm.sname  with fitm.type,;
*!*				mpcm.parnam with fitm.type,;
*!*				mpcm.tcode with 'No'
*!*		endif
*!*		repl mitm.gcode3 with mpcm.scode

*!*	&&& CATEGORY
*!*		sele mpcm
*!*		seek 'CATEGO' + substr(fitm.schedule+space(40),1,40) 
*!*		if !found()
*!*			append blank
*!*			repl mpcm.sgcode with 'CATEGO',;
*!*				mpcm.scode  with 'C'+alltrim(str(recno())),;
*!*				mpcm.sname  with fitm.schedule,;
*!*				mpcm.parnam with fitm.schedule,;
*!*				mpcm.tcode with 'No'
*!*		endif
*!*		repl mitm.gcode5 with mpcm.scode
endscan
close table all

@rowno,10 say '**** Importing Company ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\groupmst alias fpcm

sele sele(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='ZZZZZZ'
index on sgcode+sname+str(igst,5,2) to mpcm
select fpcm
go top
scan
	select mpcm
	append blank 
	replace sgcode with 'ZZZZZZ'
	replace scode with padr(fpcm.groupcode,6)
	replace sname with fpcm.groupname
	replace parnam with fpcm.groupname
endsc
close tables all

@rowno,10 say '**** Importing Batch In ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\purtrn alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
do while !eof()
	mmonth=substr(wgtq,1,2)
	myear=iif(len(alltrim(substr(wgtq,4,4)))=4,substr(wgtq,4,4),"20"+substr(wgtq,4,4))
   sele mitm
   seek  str(fsbal.icode,9)
   sele msbal
   seek str(fsbal.icode,9)+ substr(fsbal.bqty+space(12),1,12)
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
           msbal.opening with fsbal.qty,;
           msbal.balance with fsbal.qty,;
           msbal.o_a with fsbal.qty,;
           msbal.b_a with fsbal.qty,;
           msbal.batchno with fsbal.bqty
     	repl msbal.exp with ctod('01/'+mmonth+'/'+myear),;
           msbal.mrp with fsbal.mrp,;
           msbal.prate with fsbal.rate,;
           msbal.ratea with 0,;
           msbal.lprate with fsbal.rate,;           
           msbal.mrp with fsbal.mrp,;
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
	   else
          repl msbal.opening with msbal.opening + fsbal.qty,;
	           msbal.balance with msbal.balance + fsbal.qty,;
	           msbal.o_a with msbal.o_a + fsbal.qty,;
	           msbal.b_a with msbal.b_a + fsbal.qty
   endif
sele fsbal
skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Batch Out ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\invtrn alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
do while !eof()
	mmonth=substr(wgtq,1,2)
	myear=iif(len(alltrim(substr(wgtq,4,4)))=4,substr(wgtq,4,4),"20"+substr(wgtq,4,4))
   sele mitm
   seek  str(fsbal.icode,9)
   sele msbal
   seek str(fsbal.icode,9)+ substr(fsbal.bqty+space(12),1,12)
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
           msbal.opening with -fsbal.qty,;
           msbal.balance with -fsbal.qty,;
           msbal.o_a with -fsbal.qty,;
           msbal.b_a with -fsbal.qty,;
           msbal.batchno with fsbal.bqty
     	repl msbal.exp with ctod('01/'+mmonth+'/'+myear),;
           msbal.mrp with fsbal.mrp,;
           msbal.prate with fsbal.rate,;
           msbal.ratea with 0,;
           msbal.lprate with fsbal.rate,;           
           msbal.mrp with fsbal.mrp,;
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
	   else
          repl msbal.opening with msbal.opening - fsbal.qty,;
	           msbal.balance with msbal.balance - fsbal.qty,;
	           msbal.o_a with msbal.o_a - fsbal.qty,;
	           msbal.b_a with msbal.b_a - fsbal.qty
   endif
sele fsbal
skip
enddo
sele msbal
close table all



@rowno,10 say '**** Importing Ledger Master  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\acmst alias fact
sele sele(1)
use &datatransferpath\invmst alias sal
index on custcode to sal
sele sele(1)
use &datatransferpath\voucpay alias pay
index on accode to pay

sele sele(1)
use &datatransferpath\voucrec alias rec
index on accode to rec


sele sele(1)
use &datatransferpath\purmst alias pur
index on custcode to pur

sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan &&for shortnm='A00012'
	select sal
	seek fact.accode
	sum netamt to totsal while custcode=fact.accode

	select pur
	seek fact.accode
	sum netamt to totpur while custcode=fact.accode

	select pay
	seek fact.accode
	sum dr to totpay while accode=fact.accode

	select rec
	seek fact.accode
	sum cr to totrec while accode=fact.accode

	sele mact
	appen blank
		do case
			case fact.typecode=24
				replace scode with 'C6'
			case fact.typecode=21
				replace scode with 'D31'
			otherwise
				replace scode with 'J12'
		endcase
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.accode))
	repl mact.fax2 with fact.shortnm
	repl mact.parnam  with fact.acname
	repl mact.mailnam with fact.acname
	repl mact.paradd with fact.add1
	repl mact.paradd1 with fact.add2
	repl mact.paradd2 with fact.add3
	repl mact.city with fact.cityname
	repl mact.dsm with ''
	repl mact.dlno with substr(fact.cstno,6,100)
	repl gstno with fact.tinno
	repl phone1 with fact.phone
	repl phone4 with fact.mobile
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	replace mact.opning with (totpur+totrec)-(totsal+totpay)
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

*!*	EOF : MD.PRG .....Dated    : 03/11/2022   Author : SARVESH
