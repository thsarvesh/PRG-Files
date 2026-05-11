*!*	BOF : Sun Online.PRG (PHARMA Retail).....CREATED By Sarvesh Thakur     Dated    : 30/03/2021
*!* STATE : Gujarat(24)
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
if type('FINALCP')='U'
	firstdate=Ctod('01/04/2024')                         && Un-Comment this for run from VFP
	lastdate =Ctod('31/03/2025')                         && Un-Comment this for run from VFP
	datdev='d:\transfer\'   && Un-Comment this for run from VFP
	datext='dbf'
endif

datatransferext='DBF'
datatransferpath =substr('D:\2025\Feb\SunOnline\Dbf1\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='24'
sure='SURE'
removenull='No '

clear
close data
@ 02,22 say 'Piping Sun Online (Pharma Retail) To Marg.....' font 'Arial',14 colo 'W+/G'
@ 04,08 to 21,115 doub
@ 06,10 say 'SUN Data Path       :' font 'Courier',18  get datatransferpath  font 'courier',18
@ 07,10 say 'SUN Extension       :' font 'Courier',18  get datatransferext  font 'courier',18
@ 08,10 say 'F.Y.BEGIN Date      :' font 'Courier',18  get old_5  font 'Courier',18
@ 9,10 say 'F.Y.End   Date       :' font 'Courier',18  get old_6   font 'Courier',18
@ 10,10 say 'State Code          :' font 'Courier',18  get mstatecode font 'Courier',18
@ 11,10 say 'Removenull          :' font 'Courier',18  get removenull pict '@m No,Yes ' font 'Courier',18
@ 12,10 say 'Type SURE           :' font 'courier',18  get sure pict '@x!' font 'courier',18

read
clear
close data
datatransferpath=alltrim(datatransferpath)
datatransferpath=alltrim(datatransferpath)
datatransferext='.'+alltrim(datatransferext)
datdev= alltrim (datdev)
datext= alltrim (datext)
if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
if type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
endif
if removenull='Y'
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	@ 02,22 say 'Please wait removing null values'
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif
clear
rowno=5
@ 02,22 say 'Please Wait Importing Sun Online (PHARMA RETAIL) To Marg.....' font 'Arial',14 colo 'W+/G'
set colo to
sele sele(1)
use &datdev\glmonth.&datext
zap
use &datdev\ggmonth.&datext
zap
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
dele all for type='#' and aliase='DAT/F'
pack
close data
set colo to
close table all
@rowno,22 say 'Importing Product_Master .....' font 'Courier',14
rowno=rowno+1
@rowno,22 say 'Importing HSN_Master .....' font 'Courier',14
rowno=rowno+1
@rowno,22 say 'Importing COMPANY_Master .....' font 'Courier',14
rowno=rowno+1

sele sele(1)
use &datatransferpath\material alias fitm
sele sele(1)
use &datatransferpath\hsn alias fhsn
index on code to fhsn
sele sele(1)
use &datatransferpath\comp alias fcomp
index on code to fcomp
sele sele(1)
use &datatransferpath\rack alias frac
index on code to frac
sele sele(1)
use &datatransferpath\taxcomp alias ftax
index on substr(tcode,1,3) to ftax
sele sele(1)
use &datatransferpath\composition alias fsalt
index on code to fsalt
sele sele(1)
use &datatransferpath\CATAGORY alias fcate
index on code to fcate
sele sele(1)
use &datdev\pro.&datext alias mitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode + sname + str(igst,5,2) to mpcm

sele fitm
go top
scan
	last=recno()
	sele fhsn
	seek fitm.hc
	sele fcomp
	seek fitm.mfrcd
	sele frac
	seek fitm.rack
	sele ftax
	seek substr(fitm.gtax,1,3)
	sele fsalt
	seek fitm.compositio
	sele fcate
	seek fitm.catagory
	sele mitm
	append blank
	repl mitm.code with last
	repl mitm.name with fitm.matcd
	repl mitm.product with upper(fitm.matnm)
	repl mitm.packing with upper(fitm.pack)
	repl mitm.pack with fitm.factor
	repl mitm.billname with mitm.product+' '+mitm.packing
	repl mitm.rackno with frac.name
	repl mitm.unit with 'PCS'
	repl mitm.taxl with 'T'
	repl mitm.taxc with 'T'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.status with 'Y'
	repl mitm.minimum with fitm.minqty
	repl mitm.purtax with ftax.tax1/2
	repl mitm.saltax with ftax.tax1/2
	repl mitm.cgst with ftax.tax1/2
	repl mitm.igst with ftax.tax1
&&HSN
	sele mpcm
	seek 'COMMCD' + substr(fhsn.hsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(last)),;
			mpcm.sname  with fhsn.hsn ,;
			mpcm.parnam with fhsn.hsn,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
&&Company
	sele mpcm
	seek 'ZZZZZZ' + substr(fcomp.name+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'SA'+alltrim(str(last)),;
			mpcm.sname  with fcomp.name,;
			mpcm.parnam with fcomp.name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
&&Salt
	sele mpcm
	seek 'SALT  ' + substr(fsalt.name+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'CO'+alltrim(str(last)),;
			mpcm.sname  with fsalt.name,;
			mpcm.parnam with fsalt.name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
&&category
	sele mpcm
	seek 'CATEGO' + substr(fcate.name+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'CA'+alltrim(str(last)),;
			mpcm.sname  with fcate.name,;
			mpcm.parnam with fcate.name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode5 with mpcm.scode
endscan
close table all

@Rowno,22 say 'Importing Patient_Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
   use &datatransferpath\patient alias doc 
sele sele(1)
   use &datdev\maorder.&datext alias mord 
sele doc
scan
  sele mord
  appen blank 
  repl scode with 'PET#$~'&&'PRE#$~' 
  repl parnam with doc.name
  repl city with alltri(doc.address)
  repl balance with val(doc.mobile)
  repl form with doc.mobile
endscan       
close table all
@Rowno,22 say 'Importing Doctor_Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
   use &datatransferpath\doctor alias doc 
sele sele(1)
   use &datdev\maorder.&datext alias mord 
sele doc
scan
  sele mord
  appen blank 
  repl scode with 'PRE#$~' 
  repl parnam with substr(doc.name+space(25),1,25) + substr(doc.add1+space(25),1,25)
  repl city with substr(doc.regno+space(15),1,15)+substr(doc.phno+space(25),1,25)
  repl form with doc.phno
endscan       
close table all

@rowno,22 say 'Importing Batch_Master.....' font 'Courier',14
rowno=rowno+1
sele sele(1)
use &datatransferpath\ob alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal

sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F-BT'
pack
r=0
sele fsbal
go top
scan
	sele mitm
	seek substr(fsbal.matcd+space(10),1,10)
	sele msbal
	seek substr(fsbal.matcd+space(10),1,10) +substr(fsbal.batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.pack with mitm.pack
		repl msbal.exp with fsbal.expdt
		repl msbal.decimal with 'Y'
		repl msbal.batchno with fsbal.batch
		repl msbal.prate with fsbal.purprice
		repl msbal.ratea with fsbal.rtprice
		repl msbal.mrp with fsbal.mrp
		repl msbal.misc1 with mitm.gcode
		repl msbal.opening with fsbal.qty
		repl msbal.balance with fsbal.qty
		repl msbal.o_a with fsbal.qty
		repl msbal.b_a with fsbal.qty
	else
		repl msbal.opening with msbal.opening + fsbal.qty,;
			msbal.balance with msbal.balance + fsbal.qty,;
			msbal.o_a with msbal.o_a + fsbal.qty,;
			msbal.b_a with msbal.b_a + fsbal.qty
	endif
endscan
close table all
@rowno,22 say 'Importing Batch_Purchase.....' font 'Courier',14
rowno=rowno+1
sele sele(1)
use &datatransferpath\purchbot alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal

sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F-BT'
pack
sele fsbal
go top
scan &&&for matcd='19737'
	balqty=qty*iif(factor#0,factor,1)
	sele mitm
	seek substr(fsbal.matcd+space(10),1,10)
	sele msbal
	seek substr(fsbal.matcd+space(10),1,10)+ substr(fsbal.batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.pack with mitm.pack
		repl msbal.exp with fsbal.expdt
		repl msbal.decimal with 'Y'
		repl msbal.batchno with fsbal.batch
		repl msbal.prate with fsbal.stprice
		repl msbal.ratea with fsbal.rtprice
		repl msbal.mrp with fsbal.mrp
		repl msbal.misc1 with mitm.gcode
		repl msbal.opening with balqty
		repl msbal.balance with balqty
		repl msbal.o_a with balqty
		repl msbal.b_a with balqty
	else
		repl msbal.opening with msbal.opening + balqty,;
			msbal.balance with msbal.balance + balqty,;
			msbal.o_a with msbal.o_a + balqty,;
			msbal.b_a with msbal.b_a + balqty
	endif

endscan
close table all
@rowno,22 say 'Importing Batch_Sale Ret.....' font 'Courier',14
rowno=rowno+1
sele sele(1)
use &datatransferpath\SALRETURNBOT alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F-BT'
pack
sele fsbal
go top
scan
	balqty=qty&&&*iif(factor#0,factor,1)
	sele mitm
	seek substr(fsbal.matcd+space(10),1,10)
	sele msbal
	seek substr(fsbal.matcd+space(10),1,10)+ substr(fsbal.batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.pack with mitm.pack
		repl msbal.exp with fsbal.expdt
		repl msbal.decimal with 'Y'
		repl msbal.batchno with fsbal.batch
		repl msbal.ratea with fsbal.rtprice
		repl msbal.mrp with fsbal.mrp
		repl msbal.misc1 with mitm.gcode
		repl msbal.opening with balqty
		repl msbal.balance with balqty
		repl msbal.o_a with balqty
		repl msbal.b_a with balqty
	else
		repl msbal.opening with msbal.opening + balqty,;
			msbal.balance with msbal.balance + balqty,;
			msbal.o_a with msbal.o_a + balqty,;
			msbal.b_a with msbal.b_a + balqty
	endif
endscan
close table all



@rowno,22 say 'Importing Batch_Sales.....' font 'Courier',14
rowno=rowno+1
sele sele(1)
use &datatransferpath\salesbot alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F-BT'
pack
sele fsbal
go top
scan
	balqty=qty&&&*iif(factor#0,factor,1)
	sele mitm
	seek substr(fsbal.matcd+space(10),1,10)
	sele msbal
	seek substr(fsbal.matcd+space(10),1,10)+ substr(fsbal.batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.pack with mitm.pack
		repl msbal.exp with fsbal.expdt
		repl msbal.decimal with 'Y'
		repl msbal.batchno with fsbal.batch
		repl msbal.ratea with fsbal.rtprice
		repl msbal.mrp with fsbal.mrp
		repl msbal.misc1 with mitm.gcode
		repl msbal.opening with -balqty
		repl msbal.balance with -balqty
		repl msbal.o_a with -balqty
		repl msbal.b_a with -balqty
	else
		repl msbal.opening with msbal.opening - balqty,;
			msbal.balance with msbal.balance - balqty,;
			msbal.o_a with msbal.o_a - balqty,;
			msbal.b_a with msbal.b_a - balqty
		repl msbal.ratea with fsbal.rtprice
		repl msbal.mrp with fsbal.mrp
	endif
endscan
close table all
@rowno,22 say 'Importing Batch_Pur Ret.....' font 'Courier',14
rowno=rowno+1
sele sele(1)
use &datatransferpath\PRETURNBOT alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F-BT'
pack
sele fsbal
go top
scan
	balqty=qty&&*iif(factor#0,factor,1)
	sele mitm
	seek substr(fsbal.matcd+space(10),1,10)
	sele msbal
	seek substr(fsbal.matcd+space(10),1,10)+ substr(fsbal.batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.pack with mitm.pack
		repl msbal.exp with fsbal.expdt
		repl msbal.decimal with 'Y'
		repl msbal.batchno with fsbal.batch
		repl msbal.ratea with fsbal.rtprice
		repl msbal.mrp with fsbal.mrp
		repl msbal.misc1 with mitm.gcode
		repl msbal.opening with -balqty
		repl msbal.balance with -balqty
		repl msbal.o_a with -balqty
		repl msbal.b_a with -balqty
	else
		repl msbal.opening with msbal.opening - balqty,;
			msbal.balance with msbal.balance - balqty,;
			msbal.o_a with msbal.o_a - balqty,;
			msbal.b_a with msbal.b_a - balqty
	endif
endscan
close table all
@rowno,22 say 'Importing Supplier_Master .....' font 'Courier',14
rowno=rowno+1
sele sele(1)
use &datatransferpath\ledger alias fact
sele sele(1)
use &datatransferpath\area alias farea
index on code to farea

sele sele(1)
use &datatransferpath\data alias ldebit
index on code to ldebit

sele sele(1)
use &datatransferpath\purchtop alias lcredit
index on custcd to lcredit

sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias tsupp
index on aliase + str(sno,3) + lcode to tsupp
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode + sname + str(igst,5,2) to mpcm 

sele fact
go top
scan &&&&for code=68
sele farea
seek fact.area
	store 0 to tcredit,tdebit
	sele lcredit
	seek fact.code
	sum abs(netamt) to tcredit while custcd=fact.code

	sele ldebit
	seek fact.code
	sum abs(amount) to tdebit while code=fact.code

	sele mact
	append blank
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(RECNO()))
	repl mact.parnam  with fact.name
	repl mact.paradd with fact.address1
	repl mact.paradd1 with fact.address2
	repl mact.paradd2 with fact.address3
	repl mact.city with fact.place
	repl mact.dsm with fact.pincode
	repl mact.dlno with alltri(fact.dlno)+' '+alltri(fact.dlno1)
	repl mact.sthed with 'TIN No.'
	repl mact.gsthed with 'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.cstno with fact.cst
	repl mact.stno with fact.kst
	repl mact.gstno with fact.gstin
	repl mact.mailnam with fact.name
	repl mact.confir with fact.prop
	repl mact.dlno with alltri(fact.dlno)+' '+alltri(fact.dlno1)
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.phone1 with alltri(fact.phone)
	repl mact.phone2 with alltri(fact.phone1)
	repl mact.phone3 with alltri(fact.fax)
	repl mact.phone4 with alltri(fact.mobile)
	repl mact.scode with 'D31'
	repl mact.opning with iif(mact.scode='D31',-(fact.ob+tcredit-tdebit),(fact.ob+tcredit-tdebit))
&& Updating State
	sele tsupp
	seek 'ORDER   ' + '  7' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',MSTATECODE,Subs(mact.gstno,1,2))+'                                           '  	
	&&area
   sele mpcm
   seek 'AREA  ' + substr(farea.place+space(40),1,40)
   if !found()
      append blank
      repl mpcm.sgcode with 'AREA  ',;
           mpcm.scode  with 'AR'+alltrim(str(last)),;
           mpcm.sname  with farea.place,;
           mpcm.parnam with farea.place,;
           mpcm.tcode with 'No'
   endif
   repl mact.area with mpcm.scode
endscan
close tables all

proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T","M")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

*!*	EOF : Sun Online.PRG (PHARMA Retail).....CREATED By Sarvesh Thakur     Dated    : 30/03/2021
