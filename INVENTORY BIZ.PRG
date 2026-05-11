*!*	BOF : INNOVENTORY.PRG (Supermarket Retail).....CREATED By JEEVAN PREET SAINI     Dated: 17/09/2019
*!* STATE : KARNATKA (29)
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
	datdev='d:\transfer'     && Un-Comment this for run from VFP
	datext='dbf'
endif
datatransferext='DBF'
datatransferpath =substr('D:\2025\June\inventorybiz\DBF\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='29'
sure='SURE'
removenull='No '

Clear
Close Data
@ 02,22 Say 'Importing Innoventory(Retail) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 to 21,115 doub
@ 06,10 Say 'Innoventory Data Path  :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 07,10 Say 'Innoventory Extension  :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 08,10 Say 'F.Y.BEGIN Date         :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 09,10 Say 'F.Y.End   Date         :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 10,10 Say 'State Code             :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 11,10 Say 'Removenull             :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 12,10 Say 'Type SURE              :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18

Read
Clear
Close Data

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
rowno=5

@ 02,22 Say 'Please Wait Importing Importing Innoventory(Retail) To Marg.....' Font 'Arial',14 Colo 'W+/G'

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
use &datdev\support.&datext
dele all for type='#' or aliase='ORDER'
dele all For Type='#' And aliase='DAT/F'
Pack
Close Data
Set Colo To
close table all
@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\tblitemmaster alias fitm
sele sele(1) 
	use &datatransferpath\tblhsncode alias fhsn
	index on hsnid to fhsn
sele sele (1)
use &datatransferpath\tblPriceList alias fpr
index on itemid to fpr
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + parnam + str(igst,5,2) to  mpcm

sele fitm
go top
scan
   last=recno()
   sele fhsn
   	seek fitm.hsnid
   sele mitm
   append blank
   repl mitm.code with fitm.itemid
   repl mitm.name with alltrim(str(fitm.itemid))
   repl mitm.product with fitm.itemcode
   repl mitm.unit with fitm.unit
   repl mitm.billname with fitm.itemname
   repl mitm.gcode5 with alltrim(str(fitm.categoryid))
   repl mitm.gcode with substr(fitm.manufacturer,1,6)
   repl mitm.rackno with fitm.mfgbarcode
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.ratea with fitm.srate
   repl mitm.prate with fitm.prate
   repl mitm.mrp with fitm.mrp
   repl mitm.purtax with fhsn.cgsttaxper
   repl mitm.saltax with fhsn.sgsttaxper
   repl mitm.cgst with fhsn.cgsttaxper
   repl mitm.igst with fhsn.igsttaxper
   mprice=66
   sele fpr
   seek fitm.itemid
   scan while itemid=fitm.itemid
   	m=chr(mprice)
   sele mitm
   repl rate&m with fpr.plsrate
	   mprice=mprice+1
	   if mprice>73
	      exit
	   endif
   endscan
   &&HSN
   sele mpcm
   seek 'COMMCD' + substr(fhsn.hsncode+space(15),1,15) + str(mitm.igst,5,2)
   if !found()
      append blank
      repl mpcm.sgcode with 'COMMCD',;
           mpcm.scode  with 'H'+alltrim(str(last)),;
           mpcm.sname  with substr(fhsn.hsncode+space(15),1,15)+ substr(fhsn.hsncode,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
           mpcm.parnam with fhsn.hsncode,;
           mpcm.tax with mitm.saltax,;
           mpcm.cgst with mitm.cgst,;
           mpcm.igst with mitm.igst,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode6 with mpcm.scode
endscan
close table all

@Rowno,22 say 'Importing Company.....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\tblitemmaster alias fcomp
sele sele(1)
	use &datdev\saletype.&datext alias mcomp
	index on sgcode + sname + str(igst,5,2) to  mcomp

sele fcomp
go top
scan
   sele mcomp
   seek 'ZZZZZZ' + substr(fcomp.manufacturer,1,6)
   if !found()
      append blank
      repl mcomp.sgcode with 'ZZZZZZ',;
           mcomp.scode  with substr(fcomp.manufacturer,1,6),;
           mcomp.sname  with fcomp.manufacturer,;
           mcomp.parnam with fcomp.manufacturer,;
           mcomp.tcode with 'No'
   endif
endscan
close table all

@Rowno,22 say 'Importing Category .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\tblcategories alias fcat
sele sele(1)
	use &datdev\saletype.&datext alias mcat
	index on sgcode + parnam + str(igst,5,2) to  mcat

sele fcat
go top
scan
   sele mcat
   seek 'CATEGO' + substr(fcat.category+space(40),1,40)
   if !found()
      append blank
      repl mcat.sgcode with 'CATEGO',;
           mcat.scode  with alltrim(str(fcat.categoryid)),;
           mcat.sname  with fcat.category,;
           mcat.parnam with fcat.category,;
           mcat.tcode with 'No'
   endif
endscan
close table all

@Rowno,22 say 'Importing Batch .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\tblStockHistory alias fsbal
sele sele(1)
	use &datdev\probat.&datext alias msbal
	index on str(code,9)+batchno to msbal
sele sele(1)
	use &datdev\pro.&datext alias mitm
	index on str(code,9) to mitm
sele sele(1)
	use &datdev\support.&datext
  	dele all for type='#' and aliase='DAT/F-BT'
 	pack

r=0
sele fsbal
go top
scan
   sele mitm
   seek str(fsbal.itemid,9)
   sele msbal
   seek str(fsbal.itemid,9)+str(fsbal.mrp,9,2)
   if !found()   
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.unit with mitm.unit
      repl msbal.decimal with 'Y'
      repl msbal.batchno with str(fsbal.mrp,9,2)
      repl msbal.prate with fsbal.prate
      repl msbal.mrp with fsbal.mrp
      repl msbal.ratea with fsbal.srate
      repl msbal.misc1 with mitm.gcode
      repl msbal.opening with (fsbal.qtyin-fsbal.qtyout)
      repl msbal.balance with (fsbal.qtyin-fsbal.qtyout)
      repl msbal.o_a with (fsbal.qtyin-fsbal.qtyout)
      repl msbal.b_a with (fsbal.qtyin-fsbal.qtyout)
    else
      repl msbal.opening with msbal.opening+(fsbal.qtyin-fsbal.qtyout),;
           msbal.balance with msbal.balance+(fsbal.qtyin-fsbal.qtyout),;
           msbal.o_a with msbal.o_a+(fsbal.qtyin-fsbal.qtyout),;
           msbal.b_a with msbal.b_a+(fsbal.qtyin-fsbal.qtyout)
    endif
endscan
close table all

@Rowno,22 say 'Importing Area .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\tblledger alias farr
sele sele(1)
	use &datdev\saletype.&datext alias marr
	index on sgcode + sname + str(igst,5,2) to  marr

sele farr
go top
scan
   sele marr
   seek 'AREA  ' + substr(farr.area,1,6)
   if !found()
      append blank
      repl marr.sgcode with 'AREA  ',;
           marr.scode  with substr(farr.area,1,6),;
           marr.sname  with farr.area,;
           marr.parnam with farr.area,;
           marr.tcode with 'No'
   endif
endscan
close table all

@Rowno,22 say 'Importing Ledger .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
use &datatransferpath\tblledger alias fact  
set filter to accountgroupid=10 or accountgroupid=11
sele sele(1)
use &datdev\support.&datext alias support
sele sele(1)
use &datdev\order.&datext alias mact 

sele fact
go top
scan
	sele mact
   	append blank
   	do case
   		case fact.accountgroupid=11
   			repl mact.scode with 'D31'
   			repl mact.opning with -fact.opbalance
   		case fact.accountgroupid=10
   			repl mact.scode with 'C6'
   			repl mact.opning with fact.opbalance
   	endcase
   	repl mact.rate with 'Y'   	
   	repl mact.ordno with alltrim(str(fact.lid))
   	repl mact.parnam  with fact.lname
   	repl mact.paradd with fact.address
   	repl mact.gstno WITH fact.fax
   	repl mact.sthed with  'TIN No.'
  	repl mact.gsthed with  'GST No.'
  	repl mact.csthed with 'CST  No.'
   	repl mact.mailNam with fact.LNAME
   	repl mact.phone1 with fact.phone
   	repl mact.phone4 with fact.mobileno
   	repl mact.ref with 'Mr.'  	
   	repl mact.price with 'A'
   	repl mact.status with 'Y' 
   	repl mact.area with substr(fact.area,1,6)
   	repl opning with iif(fact.type='Dr',fact.opbalance,-fact.opbalance)
	*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having
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
close tables all

&&EOF : MPACT.PRG .....Author JEEVAN PREET SAINI
