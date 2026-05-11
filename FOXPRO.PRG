*!*	BOF : Foxpro.PRG (Wholesale).....CREATED By Salman     Dated    : 27/01/2020
*!* STATE : Madhaya Pardesh(33)
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
	firstdate=ctod('01/04/2024')  		&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2025')  		&& Un-Comment this for run from VFP
	datdev='d:\TRANSFER\'              && Un-Comment this for run from VFP
	datext='dbf'						&& Un-Comment this for run from VFP
ENDIF
datatransferext='DBF'
datatransferpath =substr('D:\June\91FDFA1E\AVT\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
old_8='AVT'
old_7='24'
mstatecode='33'
sure='SURE'
removenull='No ' 

@ 08,22 Say  'Piping Foxpro (Wholesale) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 10,19 Say  'Foxpro Data Path     :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 11,19 Say  'Foxpro Extension     :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 12,19 Say  'F.Y.BEGIN Date       :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 13,19 Say  'F.Y.End   Date       :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 14,19 Say  'File First 3 Char    :' Font 'Courier',18  Get old_8   Font 'Courier',18
@ 15,19 Say  'File last 2 Character:' Font 'Courier',18  Get old_7   Font 'Courier',18
@ 16,19 Say  'State Code           :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 17,19 Say  'Removenull           :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 18,19 Say  'Type SURE            :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18

Read
Clear
Close Data
datatransferpath=alltrim(datatransferpath)
datatransferpath=Alltrim(datatransferpath)

*!*	If !Right(datatransferpath,1)='\'
*!*		datatransferpath=Alltrim(datatransferpath)+'\'
*!*	Endif
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
old_7=alltr(old_7)
old_8=alltr(old_8)

If Lastkey() = 23 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
if type('FINALCP')#'U'
	rest screen from simple
	colofhed="Foxpro Data Import"
	set colo to &colouract
	=colofil(6,18,18,60,10)
	=starttransfer()        &&&&Comment it for run in VFP
ENDIF
if removenull='Y'
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next                           
Endif
rowno=5

@ 02,22 Say 'Please Wait Importing Foxpro(wholesale) To Marg.....' Font 'Arial',14 Colo 'W+/G'

Set Colo To
Sele Sele(1)
Use &datdev\glmonth.&datext
Zap
Use &datdev\ggmonth.&datext
Zap
Use &datdev\pro.&datext
Zap
Use &datdev\Order.&datext
Zap
Use &datdev\saletype.&datext
Zap
Use &datdev\gledger.&datext
Zap
Use &datdev\pendings.&datext
Zap
Use &datdev\pend.&datext
Zap
Use &datdev\probat.&datext
Zap
Use &datdev\maorder.&datext
Zap
Use &datdev\sborder.&datext
Zap
Use &datdev\mdis.&datext
Zap
Use &datdev\dis.&datext
Zap
Use &datdev\glmonth.&datext
Zap
Use &datdev\ggmonth.&datext
Zap
Use &datdev\Support.&datext
Dele All For Type='#' And aliase='DAT/F'
Pack
Close Data
Set Colo To

@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

fprd=datatransferpath + old_8+'mas'+old_7+datatransferext
sele sele(1) 
use &fprd alias fitm
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + parnam + str(igst,5,2) to mpcm

sele fitm
go top
scan
   last=recno()
   sele mitm
   append blank
   repl mitm.code with fitm.slno
   repl mitm.name with fitm.pcod
   repl mitm.product with fitm.pnam
   repl mitm.unit with fitm.unitdes
   repl mitm.billname with fitm.pnam
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.purtax with fitm.gstper
   repl mitm.saltax with fitm.gstper
   repl mitm.cgst with fitm.gstper
   repl mitm.igst with fitm.gstper*2
   repl mitm.ratea with fitm.wsprice
   repl mitm.lprate with fitm.cost
   repl mitm.prate with fitm.price
   repl mitm.opening with fitm.clqty1
   repl mitm.balance with fitm.clqty1
   repl mitm.o_a with fitm.clqty1
   repl mitm.b_a with fitm.clqty1
  
   &&HSN
   sele mpcm
   seek 'COMMCD' + substr(fitm.hsncode+space(15),1,15) + str(mitm.igst,5,2)
   if !found()
      append blank
      repl mpcm.sgcode with 'COMMCD',;
           mpcm.scode  with 'HH'+alltrim(str(last)),;
           mpcm.sname  with substr(fitm.hsncode+space(15),1,15)+ substr(fitm.hsncode,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
           mpcm.parnam with fitm.hsncode,;
           mpcm.tax with mitm.saltax,;
           mpcm.cgst with mitm.cgst,;
           mpcm.igst with mitm.igst,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode6 with mpcm.scode
endscan
close table all

@Rowno,22 say 'Importing Area .....' font 'Courier',14 
rowno=rowno+1
farea=datatransferpath + old_8+'are'+old_7+datatransferext
sele sele(1) 
use &farea alias fcat
sele sele(1)
	use &datdev\saletype.&datext alias mcat
	index on sgcode + parnam to  mcat

sele fcat
go top
scan
   sele mcat
   seek 'AREA  ' + substr(fcat.areanam+space(40),1,40)
   if !found()
      append blank
      repl mcat.sgcode with 'AREA  ',;
           mcat.scode  with fcat.areacod,;
           mcat.sname  with fcat.areanam,;
           mcat.parnam with fcat.areanam,;
           mcat.tcode with 'No'
   endif
endscan
close table all


@Rowno,22 say 'Importing Stock .....' font 'Courier',14 
rowno=rowno+1
fprd=datatransferpath + old_8+'mas'+old_7+datatransferext
sele sele(1) 
	use &fprd alias fitm
sele sele(1)
	use &datdev\probat.&datext alias msbal
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + parnam + str(igst,5,2) to mpcm

sele fitm
go top
scan
   last=recno()
   sele msbal
   append blank
   repl msbal.code with fitm.slno
   repl msbal.name with fitm.pcod
   repl msbal.product with fitm.pnam
   repl msbal.unit with fitm.unitdes
   repl msbal.billname with fitm.pnam
   repl msbal.ratea with fitm.wsprice
   repl msbal.lprate with fitm.cost
   repl msbal.prate with fitm.price
   repl msbal.opening with fitm.clqty1
   repl msbal.balance with fitm.clqty1
   repl msbal.o_a with fitm.clqty1
   repl msbal.b_a with fitm.clqty1
endsc
close table all
@Rowno,22 say 'Importing Ledger(Customer) .....' font 'Courier',14 
rowno=rowno+1
fled=datatransferpath + old_8+'par'+old_7+datatransferext
sele sele(1)
	use &fled alias fact
sele sele(1)
	use &datdev\order.&datext alias mact 
Sele sele(1)
	Use &datdev\support.&datext Alias tsupp
	Index On aliase + Str(sno,3) + lcode To tsupp

sele fact
go top
scan
	sele mact
   	append blank
   	repl mact.rate with 'Y'   	
   	repl mact.ordno with fact.cucod
   	repl mact.parnam  with fact.cunam
   	repl mact.paradd with fact.cuadd
   	repl mact.paradd1 with fact.cuadd2
   	repl mact.city with fact.town
    repl mact.sthed with  'TIN No.'
  	repl mact.gsthed with  'Gstin.'
  	repl mact.gstno with fact.Tin
    repl mact.csthed with 'CST  No.'
    repl mact.Area with fact.Areacod  
    repl mact.mailNam with fact.cunam
   	repl mact.ref with 'Mr.'  	
   	repl mact.price with 'A'
   	repl mact.status with 'Y' 
   	repl mact.phone1 with fact.phone
	repl mact.scode with 'C6'
	
	&& Updating State
	Sele tsupp
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(fact.tin,1,2)='  ',MSTATECODE,Subs(fact.tin,1,2))+'                                           '  	
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

&&EOF : Foxpro.PRG .....Author Salman
