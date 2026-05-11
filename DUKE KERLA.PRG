*!*	BOF : DUKE SOFTWARE.PRG (Pharma Software).....CREATED By Salman     Dated    : 18/03/2021
*!* STATE : Kerla (37)
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
	firstdate=ctod('01/04/2025')  		&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')  		&& Un-Comment this for run from VFP
	datdev='d:\transfer\'   && Un-Comment this for run from VFP
	datext='dbf'						&& Un-Comment this for run from VFP
endif
datatransferext='DBF'
datatransferpath =substr('D:\2025\Dec\Duke\data\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='32'
sure='SURE'
removenull='No '

Clear
Close Data
@ 02,22 Say 'Piping Duke SOFTWARE.PRG (Pharma Software) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 06,10 Say 'Duke SOFTWARE Data Path            :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 07,10 Say 'Duke SOFTWARE Extension            :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 09,10 Say 'F.Y. BEGIN Date                    :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 10,10 Say 'F.Y. End   Date                    :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 11,10 Say 'State Code                         :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 12,10 Say 'Removenull                         :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 13,10 Say 'Type SURE                          :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18

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
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
if type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
endif
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
@ 02,22 Say 'Piping Duke SOFTWARE.PRG (Pharma Software) To Marg.....' Font 'Arial',14 Colo 'W+/G'
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
Set Colo To
clos tabl all
@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
use &datatransferpath\Phm001 alias fitm
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
	Repl mitm.Code With Last
	Repl mitm.Name With Alltrim(fitm.Itcd)
	Repl mitm.Product With fitm.Itnm
	Repl mitm.Pack With Iif(fitm.Packqty=1,0,fitm.Packqty)
	Repl mitm.billname With Alltrim(fitm.Itnm)
	Repl mitm.unit With 'PCS'
	Repl mitm.gcode With Alltrim(fitm.Cocode)
	Repl mitm.gcode3 With iif(isnull(fitm.phnmcd),'',fitm.phnmcd)
	Repl mitm.taxl With 'T'
	Repl mitm.taxc With 'T'
	Repl mitm.Decimal With 'Y'
	Repl mitm.halfsche With 'A'
	Repl mitm.qtrsche With 'Y'
	Repl mitm.Status With 'Y'
	repl mitm.purtax with fitm.cst/2
	repl mitm.saltax with fitm.cst/2
	repl mitm.cgst with fitm.cst/2
	repl mitm.igst with fitm.cst
	repl mitm.ratea with fitm.Packrate
	repl mitm.mrp with fitm.Packmrp
	repl opening with fitm.balqty 
	repl o_A  with fitm.balqty
	repl balance with fitm.balqty
	repl b_a with fitm.balqty 
	repl RACKNO WITH ALLTRIM(FITM.RACK)
	&&HSN
	sele mpcm
	seek 'COMMCD' + substr(fitm.hsncode+space(15),1,15) + str(mitm.igst,5,2)
	if !found()
	append blank
		repl mpcm.sgcode with 'COMMCD',;
             mpcm.scode  with 'HH'+alltrim(str(last))
        repl mpcm.sname  with iif(isnull(fitm.hsncode),'',substr(fitm.hsncode+space(15),1,15)+ substr(fitm.hsncode,1,15) +' '+ alltrim(str(mitm.igst,5,2)))
        repl mpcm.parnam with iif(isnull(fitm.hsncode),'',fitm.hsncode)
        repl mpcm.tax with mitm.saltax
        repl mpcm.cgst with mitm.cgst
        repl mpcm.igst with mitm.igst
        repl mpcm.tcode with 'No'
    endif
    repl mitm.gcode6 with mpcm.scode
endscan
close table all
 
@Rowno,22 say 'Importing Company .....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
use &datatransferpath\phm006 alias fpcm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan
   sele mpcm
      append blank
      repl mpcm.sgcode with 'ZZZZZZ',;
           mpcm.scode  with alltrim(fpcm.Cocode),;
           mpcm.sname  with fpcm.Coname,;
           mpcm.parnam with fpcm.Coname,;
           mpcm.tcode with 'No'
endscan
close table all
@Rowno,22 say 'Importing Salt .....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
use &datatransferpath\Phm008 alias fpcm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
sele fpcm
go top
scan
   sele mpcm
      append blank
      repl mpcm.sgcode with 'SALT',;
           mpcm.scode  with alltrim(fpcm.phnmcd),;
           mpcm.sname  with fpcm.phnm,;
           mpcm.parnam with fpcm.phnm,;
           mpcm.tcode with 'No'
endscan
close table all
@Rowno,22 say 'Importing Batch .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\PHM002 alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name + batchno to msbal
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
	seek substr(fsbal.itcd+space(10),1,10)
    sele msbal
    seek  SUBSTR(ALLTRIM(fsbal.Itcd)+SPACE(10),1,10) + substr(fsbal.btno+space(12),1,12)
    if !found()   
	    append blank
		repl msbal.date with date()
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.pack with mitm.pack
		repl msbal.unit2 with mitm.unit2
		repl msbal.unit with mitm.unit
		repl msbal.decimal with 'Y'
		repl msbal.opening with fsbal.qty 
		repl msbal.balance with fsbal.qty
		repl msbal.o_a with fsbal.qty
		repl msbal.b_a with fsbal.qty
		repl msbal.batchno with fsbal.btno
		repl msbal.exp with iif(isnull(fsbal.expdt),ctod(''),fsbal.expdt)
		repl msbal.ratea with fsbal.rate
		repl msbal.mrp with fsbal.unit_mrp&&&&*iif(mitm.pack#0,mitm.pack,1)
		repl msbal.prate with fsbal.cprice
		repl msbal.misc1 with mitm.gcode
		repl msbal.mycode with alltrim(str(fsbal.barcode))
	else
		repl msbal.opening with opening+fsbal.qty 
		repl msbal.balance with balance+fsbal.qty
		repl msbal.o_a with o_a+fsbal.qty
		repl msbal.b_a with b_a+fsbal.qty
    endif
endscan
close table all
@Rowno,22 say 'Importing Customer .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\phm010 alias fact
sele sele(1) 
use &datdev\order.&datext alias mact 
sele sele(1)
use &datdev\support.&datext alias tsupp
index on aliase + str(sno,3) + lcode to tsupp
sele fact
go top
scan
	sele mact
	append blank
	repl mact.rate with 'Y'    
	REPL mact.scode With 'C6'
	Repl mact.rate With 'Y'
	Repl mact.ordno With fact.cuscd
	Repl mact.fax2 With fact.cuscd
	Repl mact.parnam  With fact.cusnm
	Repl mact.paradd With fact.cusadd1
	Repl mact.paradd1 With fact.cusadd2
	Repl mact.dsm With fact.cuspin
	Repl mact.sthed With  'TIN No.'
	Repl mact.csthed With 'CST  No.'
	Repl mact.dlno With (fact.cusdlno1+'  '+fact.cusdlno2)
	Repl mact.phone1 With Alltrim(fact.mobile)
	Repl mact.mailNam With fact.cusnm
	Repl mact.area With ALLTRIM(fact.areacd)
	Repl mact.gstno With fact.gstin
	Repl mact.ref With 'Mr.'
	Repl mact.price With 'A'
	Repl mact.Status With 'Y'
	Repl mact.adhed With 'Discount'
	Repl mact.opning With (fact.Balamt)
	&&&STATE
	sele support
	appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	&&Local/Central Update
	select support
	appe blan
	repl aliase with 'LBTDETAI'
	repl type with 'F'
	repl lcode with mact.ordno
	repl heading with iif(mstatecode=left(mact.gstno,2) and empty(mact.gstno),'L            LN','L            ON ')
endscan  
close table all
@Rowno,22 say 'Importing Supplier .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\phm003 alias fact
sele sele(1) 
use &datdev\order.&datext alias mact 
sele sele(1)
use &datdev\support.&datext alias support
index on aliase + str(sno,3) + lcode to support
sele fact
go top
scan
	sele mact
	append blank
	repl mact.rate with 'Y'       
	repl mact.scode With 'D31'
	Repl mact.rate With 'Y'
	Repl mact.ordno With fact.Supcd
	repl mact.fax2 with fact.supcd
	Repl mact.parnam  With fact.Supnm
	Repl mact.paradd With fact.Sadd1
	Repl mact.paradd1 With fact.Sadd2
	Repl mact.dsm With fact.pin
	Repl mact.sthed With  'TIN No.'
	Repl mact.csthed With 'CST  No.'
	repl mact.cstno with fact.kgstno
	repl mact.dlno with alltrim(fact.dlnos)
	repl mact.phone1 with alltrim(fact.phone)
	repl mact.mailnam with fact.supnm
	repl mact.area with alltrim(fact.accd)
	repl mact.gstno with fact.gstin
	Repl mact.ref With 'Mr.'
	Repl mact.price With 'A'
	repl mact.city with fact.city
	Repl mact.Status With 'Y'
	repl mact.adhed With 'Discount'
	repl mact.opning With (fact.Balamt)
	&&&STATE
	sele support
	appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	&&Local/Central Update
	select support
	appe blan
	repl aliase with 'LBTDETAI'
	repl type with 'F'
	repl lcode with mact.ordno
	repl heading with iif(mstatecode=left(mact.gstno,2) and empty(mact.gstno),'L            LN','L            ON ')
endscan          
close table all
@Rowno,22 say 'Importing Doctors  .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\Phm016 alias fact
sele sele(1)
use &datdev\maorder.&datext alias mact
sele fact
go top
scan
	sele mact
	append blank
	repl scode with 'PRE#$~'
	repl mact.ordno with alltrim(fact.Docod)
	repl mact.parnam  with fact.Docnm
	repl form with alltrim(fact.Docod)     
endscan
close table all

@rowno,22 say 'Importing Patient .....' font 'Courier',14
rowno=rowno+1
sele sele(1)
use &datatransferpath\Patient_master alias fdoc 
sele sele(1)
use &datdev\maorder.&datext alias mdoc 
index on scode to mdoc 
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PET#$~',;
		 mdoc.ordno with alltrim(str(last)),;
	     mdoc.parnam with fdoc.name,;
	     mdoc.form with alltrim(str(last))
endscan
close table all
    

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
*!*	eof : DUKE SOFTWARE.PRG (Pharma Software).....CREATED By Salman     Dated    : 18/03/2021
