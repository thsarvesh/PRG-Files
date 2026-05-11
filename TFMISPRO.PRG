clear
close table all
set talk off
set date to brit
set cent on
set dele on
set safe off
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
sure = Space(4)
datatransferpath=substr('D:\2025\Feb\mispro\dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='08'
removenull = 'NO'
@13,10 say 'MISPRO Data Path        :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'MISPRO Extension        :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_9    font 'courier',18
@18,10 say 'GST/VAT                 :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code          :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Removenull              :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@21,10 say 'Type SURE               :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
Read
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
@ 02,25 say 'Please Wait..Importing MISPRO Data To Marg.....' font 'courier',14 colo 'W+/b'
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
close TABLE ALL
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
use &datatransferpath\ITEMMASTER alias fitm
Index On ItemID To fitm Uniq

sele sele(1)
use &datatransferpath\taxrate alias ftax
Index On taxid To ftax
sele sele(1)
use &datatransferpath\stockinfo alias fhsn
Index On ItemID To fhsn Uniq
sele sele(1)
use &datatransferpath\SizeGroup alias fsize
Index On Sizegroupid To fsize Uniq
sele sele(1)
use &datdev\pro.&datext alias  mitm
Index On Name To mitm

sele sele(1)
use &datdev\saletype.&datext alias  mpcm
Delete All For sgcode='COMMCD'
Pack
Index On sgcode+parnam+Str(igst,5,2) To mpcm
Sele fitm
Pack
Go Top
Do While !Eof()
	Last=Recno()
	=seek (fitm.itemid,'fhsn')
	=seek (fitm.taxid,'ftax')
	=seek (fitm.sizegroupid,'fsize')
	Sele mitm
	Seek Alltri(Str(fitm.ItemID))
	If !Found()
		Append Blank
		Repl mitm.Code With Last
		Repl mitm.Name With Alltr(Str(fitm.ItemID))
		Repl mitm.Product With upper(fitm.Itemname)
		Repl mitm.packing With upper(fsize.Sizegroup)
		Repl mitm.billname With Alltrim(upper(fitm.Itemname))&&&&+'  '+'Pcs'
		Repl mitm.unit With 'PCS'
		Repl mitm.gcode With Alltrim(Str(fitm.Brandid))
		Repl mitm.gcode5 With padr(fitm.colorid,6)
		Repl mitm.gcode3 With Alltrim(Str(fitm.Productid))
		Repl mitm.taxl With 'T'
		Repl mitm.taxc With 'T'
		Repl mitm.Decimal With 'Y'
		Repl mitm.salfix With 'N'
		Repl mitm.halfsche With 'A'
		Repl mitm.qtrsche With 'Y'
		Repl mitm.Status With 'Y'
		Repl mitm.saltax With ftax.Taxrate
		Repl mitm.purtax With ftax.Taxrate
		Repl mitm.cgst With ftax.Taxrate
		Repl mitm.igst With ftax.Gstrate
		Repl mitm.prate With fhsn.Purrate
		Repl mitm.ratea With fhsn.Salerate
		Repl mitm.rateb With fhsn.Rate
		Repl mitm.mrp With fhsn.mrp
	Endif
	Sele mpcm
	Seek 'COMMCD' + Substr(fhsn.Hsn+Space(15),1,15) + Str(mitm.igst,5,2)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'COMMCD',;
			mpcm.scode  With 'H'+Alltrim(Str(Last)),;
			mpcm.sname  With Substr(fhsn.Hsn+Space(15),1,15)+Substr(fhsn.Hsn,1,15) +' '+ Alltrim(Str(mitm.igst,5,2))+'%',;
			mpcm.parnam With Substr(fhsn.Hsn,1,15),;
			mpcm.tax With mitm.saltax,;
			mpcm.cgst With mitm.cgst,;
			mpcm.igst With mitm.igst,;
			mpcm.tcode With 'No'
	Endi
	Repl mitm.gcode6 With mpcm.scode
	Sele fitm
	Skip
Enddo
close table all
@rowno,10 say '**** Importing BATCH****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\batchmaster alias fsbal
sele sele(1)
use &datatransferpath\stockinfo alias fstock
index on batchid to fstock
sele sele(1)
use &datdev\malter.&datext  alias altr 
dele all
pack 
index on code+batch to altr

sele sele(1)
use &datatransferpath\sizegroup alias fsize
INDEX on Sizegroupid TO fsize 

sele sele(1)
use &datdev\pro.&datext alias  mitm
Index On Name To mitm
sele sele(1)
use &datdev\probat.&datext alias  msbal
Index On Name+batchno To msbal
r=0
Sele fsbal
Go Top
scan
	select fsize
	seek fsbal.sizeid
	sele fstock
	seek fsbal.batchid
	sele mitm
	seek substr(fsbal.itemid+space(10),1,10)
	sele msbal
*!*		seek  substr(fsbal.itemid+space(10),1,10)+ substr(fstock.isize+space(12),1,12)&&&substr(str(fsize.sizegroupid)+space(12),1,12)
*!*			if .not. found()
			append blank
			repl      msbal.date with date()
			repl      msbal.code with mitm.code
			repl      msbal.name with mitm.name
			repl      msbal.billname with mitm.billname
			repl      msbal.product with mitm.product
			repl      msbal.unit with mitm.unit
			repl      msbal.decimal with 'y'
			repl      msbal.opening with fsbal.qty
			repl      msbal.balance with fsbal.qty
			repl      msbal.o_a with fsbal.qty
			repl      msbal.b_a with fsbal.qty
			repl      msbal.mybatch with substr(fstock.isize+space(12),1,12)
			repl 	  msbal.batchno with alltri(str(recno()))
			repl      msbal.mycode with fsbal.barno
			repl      msbal.prate with fsbal.purrate
			repl      msbal.ratea with fsbal.salerate
			repl      msbal.mrp with fsbal.mrp
*!*			else
*!*				repl      msbal.opening with msbal.opening+fsbal.qty
*!*				repl      msbal.balance with msbal.balance+fsbal.qty
*!*				repl      msbal.o_a with msbal.o_a+fsbal.qty
*!*				repl      msbal.b_a with msbal.b_a+fsbal.qty
*!*			endif
*!*	      sele altr 
*!*	      seek str(msbal.code,9)+msbal.batchno+subs(alltrim(fsbal.barno)+space(20),1,20)
*!*	      if !found()   
*!*	         appen blank
*!*	         repl type with 'BTBRCD'
*!*	         repl code with STR(MSBAL.code,9)
*!*	         repl batch with msbal.batchno
*!*	         repl name with subs(alltrim(fsbal.barno)+space(20),1,20)
*!*	      endif   
		
endscan
close table all
@rowno,10 say '**** Importing Company Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\brand alias fpcm
index on brandid to fpcm unique
sele sele(1)
use &datdev\saletype.&datext alias  mpcm
dele all for sgcode='ZZZZZZ'
Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'ZZZZZZ',;
		mpcm.scode  With Alltrim(Str(fpcm.Brandid)),;
		mpcm.sname  With upper(fpcm.Brand),;
		mpcm.parnam With upper(fpcm.Brand),;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele fpcm
	Skip
Enddo
close table all
@rowno,10 say '**** Importing Salt Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\product alias fpcm
index on productid to fpcm uniq
sele sele(1)
use &datdev\saletype.&datext alias  mpcm
delete all for sgcode='SALT  '
pack
sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'SALT  ',;
		mpcm.scode  with alltrim(str(fpcm.productid)),;
		mpcm.sname  with upper(fpcm.product),;
		mpcm.parnam with upper(fpcm.product),;
		mpcm.tcode with 'no',;
		mpcm.tax with 1
	sele fpcm
	skip
enddo
close table all
@rowno,10 say '**** Importing Category Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\color alias fpcm
index on colorid to fpcm 
sele sele(1)
use &datdev\saletype.&datext alias  mpcm
delete all for sgcode='CATEGO'
pack
sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO',;
		mpcm.scode  with padr(fpcm.color,6),;
		mpcm.sname  with upper(fpcm.color),;
		mpcm.parnam with upper(fpcm.color),;
		mpcm.tcode with 'no',;
		mpcm.tax with 1
	sele fpcm
	skip
Enddo
close table all
@rowno,10 say '**** Importing Account Master (Debtors) ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\party alias fact
set filter to headid=        126
index on partyid to fact
sele sele(1)
use &datdev\order.&datext alias  mact
sele fact
go top
do while .not. eof()
	last=recno()
	sele mact
	append blank
	repl      mact.scode with 'C6'
	repl      mact.rate with 'Y'
	repl      mact.ordno with alltrim(str(fact.partyid))
	repl      mact.fax2 with  fact.fax
	repl      mact.parnam  with fact.partyname
	repl      mact.paradd with fact.address
	repl      mact.sthed with  'Tin No.'
	repl      mact.csthed with 'Cst No.'
	repl      mact.gsthed with 'Gst No.'
	repl      mact.itno with fact.panno
	repl      mact.gstno with fact.tinno
	repl      mact.confir with fact.contactperson
	repl      mact.mailnam with fact.partyname
	repl      mact.phone1 with fact.tel
	repl      mact.phone2 with fact.mobnum
	repl      mact.city with fact.city
	repl      mact.ref with 'mr.'
	repl      mact.price with 'A'
	repl      mact.status with 'Y'
	repl      mact.adhed with 'discount'
	repl      mact.opning with fact.dramt
	sele fact
	skip
enddo
close table all
@rowno,10 say '**** Importing Account Master (Creditors) ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\party alias fact
set filter to headid=        125
index on partyid to fact
sele sele(1)
use &datdev\order.&datext alias  mact
sele fact
go top
do while .not. eof()
	last=recno()
	sele mact
	append blank
	Repl      mact.scode With 'D31'
	Repl      mact.Rate With 'Y'
	Repl      mact.ordno With Alltrim(Str(fact.Partyid))
	Repl      mact.fax2 With  fact.Fax
	Repl      mact.parnam  With fact.Partyname
	Repl      mact.paradd With fact.Address
	Repl      mact.sthed With  'TIN No.'
	Repl      mact.csthed With 'CST  No.'
	Repl      mact.gsthed With 'GST  No.'
	Repl      mact.itno With fact.Panno
	Repl      mact.gstno With fact.Tinno
	Repl      mact.Confir With fact.Contactperson
	Repl      mact.mailNam With fact.Partyname
	Repl      mact.phone1 With fact.Tel
	Repl      mact.phone2 With fact.Mobnum
	Repl      mact.city With fact.city
	Repl      mact.ref With 'Mr.'
	Repl      mact.price With 'A'
	Repl      mact.Status With 'Y'
	Repl      mact.adhed With 'Discount'
	Repl      mact.opning With -(fact.Dramt)
	Sele fact
	Skip
Enddo
close table all

Proc  removenull
	Use &fdir\Taxrate
	Do rem_null

	*use &fdir\drs
	*	do rem_null

	*use &fdir\acmast
	*	do rem_null

	*use &fdir\head
	*	do rem_null
	*!*	use &fdir\accounts
	*!*		do rem_null
	*!*	use &fdir\salesmaster
	*!*		do rem_null
	*!*	use &fDir\saleschild
	*!*	    do rem_null
	*!*	use &fDir\purchasemaster
	*!*	    do rem_null
	*!*	use &fDir\purchasechild
	*!*	    do rem_null

Proc  rem_null
	a = Afields(arr)
	For i = 1 To a
		mfldname = arr(i, 1)
		Do Case
		Case Inlist(arr(i,2), "C","V")
			Replace All &mfldname With '' For Isnull(&mfldname)
		Case Inlist(arr(i,2), "B","N","I","F","Y")
			Replace All &mfldname With 0 For Isnull(&mfldname)
		Case Inlist(arr(i,2), "D","T")
			Replace All &mfldname With Ctod('') For Isnull(&mfldname)
		Endcase
	Endfor
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
