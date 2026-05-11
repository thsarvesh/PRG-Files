** By COMMON MAN
**MEDIWIN Retail ACCESS**
*!*	BOF : MEDWIN.PRG .....DELHI(Pharma Wholesale)  Dated    : 15/03/2019   Author : Santosh K Srivastava
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

Clear 
close table all 
Set Talk Off
Set Date To brit
Set Cent On
set cpdi off
Set Dele On
Set Safe Off
if type ('FINALCP')='U'
	datdev='d:\transfer\'
	datext = 'DBF'
	firstdate=ctod('01/04/2024')
	lastdate=ctod('31/03/2025')
endif
*!*	sele sele(1)
*!*	create curs mycurs  (setup c(50),value c(4))
*!*	sele mycurs
*!*	appe blank
*!*	repl  setup with 'Item Wise Double Discount ',value with 'Y'
sure = 'SURE'
datatransfermdb='No '
datatransferpath=subs('D:\2025\Mar\Medwin\DBF\'+space(100),1,80)
datatransferext='dbf'
datatransferpwd=space(60)
old_3 = 'Y'
old_4 = 'NO'
old_5 = firstdate
old_6 = lastdate
OLD_9='GST'
mstatecode='07'
removenull='NO '
scalc='2'
pcalc='2'
mrgmdbfile=space(100)
mrgmdbpwd=space(30)
@09,10 say 'Convert DBF From MDB  :' font 'Courier',18 get datatransfermdb  pict '@m No ,Yes'  font 'COURIER',18 
@10,10 say 'Old Data From         :' font 'Courier',18 get datatransferpath     font 'Courier',18
read
if datatransfermdb='Y'
	=mdbsqlconvert(1)
endif
clear gets
@11,10 SAY 'Old Data Extension    :' font 'courier',18  get datatransferext font 'courier',18
@12,10 say 'With Out Standing     :' font 'Courier',18  get old_3    font 'Courier',18 pict  '@m Yes,No '
@13,10 say 'Only Balance          :' font 'Courier',18  get old_4    font 'Courier',18 pict  '@m No ,Yes'
@14,10 say 'Financial Year From   :' font 'Courier',18  get old_5    font 'Courier',18
@15,10 say 'Financial Year UpTo   :' font 'Courier',18  get old_6    font 'Courier',18
@16,10 say 'Purchase Calculation  :' font 'Courier',18  get pcalc    font 'Courier',18
@17,10 say 'Sales Calculation     :' font 'Courier',18  get scalc    font 'Courier',18
@18,10 say 'State GST Code        :' font 'Courier',18  get mstatecode font 'Courier',18
@19,10 say 'Remove Null           :' font 'courier',18  get removenull   pict '@M No ,Yes'  font 'courier',18
@20,10 say 'VAT/GST               :' font 'Courier',18  get old_9  font 'Courier',18 pict  '@m GST,VAT'
@21,10 say 'Type Sure             :' font 'Courier',18  get sure      pict  '@X!' font 'Courier',18
read
datatransferpath =Alltrim(datatransferpath )
datdev =Alltrim(datdev)
datext=Alltrim(datext)
datatransferext=alltrim(datatransferext)
if !dire(datatransferpath)
	md &datatransferpath
endif
If Lastkey() = 27 .And. sure# 'SURE'
	Return
Endif
CLEAR
if type ('FINALCP')#'U'
	=starttransfer()
endif
if removenull='Y'
  Do Removenull
endif

@02,10  say 'Please Wait Importing MEDIWIN Retail(Access) Data To Marg.....' font 'Arial',14 colo 'W+/G'
Rowno=5
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
use &datdev\support.&datext  
dele all for (type="#" and aliase="DAT/F") or aliase='ORDER'
pack
close table all

@rowno,10 say '**** Importing Area ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
  use &datatransferpath\areamas alias farea  
sele sele(1)   
  use &datdev\saletype.&datext alias stype 
  
sele farea  
scan
 sele stype
 appe blank 
 repl sgcode with 'AREA' 
 repl scode with farea.areacode 
 repl sname with farea.areadesc 
 repl parnam with farea.areadesc
endscan 
close table all    
@rowno,10 say '**** Importing Product Category ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
  use &datatransferpath\category alia fcat 
sele sele(1)
  use &datdev\saletype.&datext alias stype 
  index on sgcode+parnam+str(igst,6,2) to stype 
sele fcat
scan
  sele stype
  seek 'CATEGO'+subs(fcat.catcode+space(15),1,15)+str(fcat.cattax,6,2) 
  if !found()
	  appen blank 
  	  repl sgcode with 'CATEGO'  
  	  repl scode with alltrim(str(recno()))
  	  repl parnam with fcat.catcode 
  	  repl sname with parnam+fcat.descriptio
  	  repl igst with fcat.cattax  
  endif  	   
endscan
close table all
    

@rowno,10 say '**** Importing Product Company ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath + 'compmas.'+datatransferext
td=datdev + '\saletype.'+datext

Sele a
Use &fd Alias fpcm

Sele b
Use &td Alias mpcm

Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'ZZZZZZ',;
		mpcm.scode  With Alltrim(fpcm.compcode),;
		mpcm.sname  With fpcm.compname,;
		mpcm.parnam With fpcm.compname,;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele fpcm
	Skip
Enddo
close table all

@rowno,10 say '**** Importing Product Salt ****' font 'Arial',12
rowno=rowno+1

fd=datatransferpath + 'itemgrp.'+datatransferext
td=datdev + '\saletype.'+datext
Sele a
	Use &fd Alias fpcm
Sele b
	Use &td Alias mpcm

Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'SALT  ',;
		mpcm.scode  With Alltrim(fpcm.iTEMGRCD),;
		mpcm.sname  With fpcm.iTEMGRDS,;
		mpcm.parnam With fpcm.iTEMGRDS,;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele fpcm
	Skip
Enddo
close table all

@rowno,10 say '**** Importing Product Patient ****' font 'Arial',12
rowno=rowno+1

fd=datatransferpath + 'Patient_master.'+datatransferext
td=datdev +'\maorder.'+datext
Sele a
Use &fd Alias fdoc
Sele b
Use &td Alias mdoc

Sele fdoc
Go Top
Cd=10
Do While .Not. Eof()
	Last=Recno()
	Sele mdoc
	Append Blank
	Repl mdoc.scode With 'PET#$~'
	Repl mdoc.ordno With Alltrim(Str(Last))
	Replace mdoc.parnam With fdoc.Patient
	Repl  mdoc.Form With Alltrim(Str(Last))
	Sele fdoc
	Skip
Enddo
close table all

@rowno,10 say '**** Importing Product Doctor ****' font 'Arial',12
rowno=rowno+1

fd=datatransferpath + 'Doctor_master.'+datatransferext
td=datdev +'\maorder.'+datext

Sele a
Use &fd Alias fdoc
Sele b
Use &td Alias mdoc

Sele fdoc
Go Top
Do While .Not. Eof()
	Last=Recno()
	Sele mdoc
	Append Blank
	Repl mdoc.scode With 'PRE#$~'
	Repl  mdoc.ordno With Alltrim(Str(Last))
	Repl  mdoc.parnam With Substr(fdoc.Doctor,1,25)
	Repl  mdoc.city With Space(15)+Alltrim(fdoc.Doctor_pho)
	Repl  mdoc.Form With Alltrim(Str(Last))
	Sele fdoc
	Skip
Enddo
clos data

@rowno,10 say '**** Importing Product Product ****' font 'Arial',12
rowno=rowno+1

fd=datatransferpath+'Mednmas.'+datatransferext
fb=datatransferpath+'barscan_master.'+datatransferext
td=datdev+'\pro.'+datext

sele sele(1)
use datdev+'\saletype.'+datext alia mpcm
dele all for sgcode='COMMCD'
pack
inde on sgcode+parnam+str(igst,5,2) to mpcm

Sele a
Use &fd Alias fitm
sele c
use &fb alias fbar
inde on numbercd to fbar
Sele b
Use &td Alias mitm
Zap
Index On Name To mitm

Sele fitm
Pack
Go Top
Do While !Eof()
	Last=Recno()
    itembar=(numbercd*3.5)+196
    sele fbar
    seek padr(itembar,20)
    Select mitm
	Seek Substr(Alltrim(Str(fitm.Numbercd))+Space(10),1,10)
	if .not. found()
		Sele mitm
		Append Blank
		Repl mitm.Code With fitm.Numbercd
		Repl mitm.Name With alltrim(str(fitm.Numbercd))
		Repl mitm.Product With fitm.medname
		Repl mitm.packing With fitm.Medsize
		Repl mitm.Pack With Iif(fitm.sizefact=1,0,fitm.sizefact)
		Repl mitm.billname With Alltrim(fitm.medname)+' '+Alltrim(fitm.Medsize)
		REPL mitm.rackno with fbar.barcode
		REPL mitm.rackno2 with fitm.medloct
		Repl mitm.unit With 'PCS'
		Repl mitm.gcode With Right(Alltrim(fitm.Mcomp),6)
		Repl mitm.gcode3 With Right(Alltrim(fitm.Medgrp),6)
		Repl mitm.purdis With fitm.purdisc
		Repl mitm.taxl With 'T'
		Repl mitm.taxc With 'T'
		Repl mitm.Decimal With 'Y'
		Repl mitm.salfix With 'N'
		Repl mitm.halfsche With 'A'
		Repl mitm.qtrsche With 'Y'
		Repl mitm.Status With 'Y'
		Repl mitm.saltax With fitm.Purrtax/2
		Repl mitm.purtax With  fitm.Purrtax/2
		Repl mitm.cgst With  fitm.Purrtax/2
		Repl mitm.igst With  fitm.Purrtax
		Repl mitm.prate With fitm.Purrate
		Repl mitm.ratea With fitm.Finalmrp
		Repl mitm.mrp With fitm.mrp
		Repl misc5 With ' S          0.0000             YN 1B%             '
	Endif

	&&For HSN
	
	Sele mpcm
	Seek 'COMMCD' + Substr(fitm.Item_catco+Space(15),1,15) + Str(mitm.igst,5,2)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'COMMCD',;
			mpcm.scode  With 'C'+Alltrim(Str(Last)),;
			mpcm.sname  With Substr(fitm.Item_catco+Space(15),1,15)+' '+ Alltrim(Str(mitm.igst,5,2)) ,;
			mpcm.parnam With Substr(fitm.Item_catco,1,15),;
			mpcm.tax With mitm.saltax,;
			mpcm.cgst With mitm.cgst,;
			mpcm.igst With mitm.igst,;
			mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode6 With mpcm.scode

	Sele fitm
	Skip
Enddo
close table all

@rowno,10 say '**** Importing Product Batch/Stock ****' font 'Arial',12
rowno=rowno+1

fd=datatransferpath + 'Stockmas.'+datatransferext
td=datdev + '\probat.'+datext
mi=datdev + '\pro.'+datext
sp=datdev+'\support.'+datext

sele sele(1)
use &sp alias support

Sele a
Use &fd Alias fsbal 
copy to bal
sele sele(1) 
use bal
inde on Str(fsbal.Stkcode)+Substr(fsbal.Stkbatch+Space(12),1,12) to bal

Sele b
Use &mi Alias mitm
Index On code To mitm

Sele c
Use &td Alias msbal
Zap
Index On str(code)+ batchno To msbal

sele sele(1)
  use &datatransferpath\openstk1 alias opn 
  index on str(stkcode)+stkbatch to opn 
r=0
Sele fsbal
Go Top
Do While .Not. Eof()
   	myear='20'+alltri(str(stkexyr)) 
   	mmonth=iif(len(alltri(str(stkexmn)))=1,'0'+alltri(str(stkexmn)),alltri(str(stkexmn)))
   	mexp=ctod('01/'+mmonth+'/'+myear)
    
    =seek(str(stkcode)+stkbatch,'opn')
   	Sele mitm
	Seek fsbal.stkcode 

	Sele msbal
	Seek  str(fsbal.stkcode)+ Substr(fsbal.Stkbatch+Space(12),1,12)
	If !Found()
		Append Blank
		Repl msbal.Date With Date()
		Repl msbal.Code With mitm.Code
		Repl msbal.Name With mitm.Name
		Repl msbal.billname With mitm.billname
		Repl msbal.Product With mitm.Product
		Repl msbal.packing With mitm.packing
		Repl msbal.Pack With fsbal.stksize
		Repl msbal.unit2 With mitm.unit2
		Repl msbal.unit With mitm.unit
		Repl msbal.Decimal With 'Y'
		repl msbal.mycode with alltri(str(fsbal.stockno))
        repl msbal.batchno With fsbal.Stkbatch,;
			 msbal.EXP With mexp,;
			 msbal.prate With fsbal.stkinvrate,;
			 msbal.ratea With fsbal.Stkfpurt,;
			 msbal.lprate With fsbal.Stkfpurt,;
			 msbal.mrp With fsbal.mrprate,;
			 msbal.misc1 With mitm.gcode,;
			 msbal.deal With fsbal.Stkpaid,;
			 msbal.Free With fsbal.Stkfree
   endif
	  if old_4='Y'
	     repl msbal.opening With msbal.opening+(fsbal.Stkqty),;
			  msbal.balance With msbal.balance+(fsbal.Stkqty),;
			  msbal.o_a With msbal.o_a+(fsbal.Stkqty),;
			  msbal.b_a With msbal.b_a+(fsbal.Stkqty)
	  else	  
	  Repl  msbal.opening With msbal.opening + (opn.Stkqty),;
			msbal.balance With msbal.balance + (opn.Stkqty),;
			msbal.o_a With msbal.o_a + (opn.Stkqty),;
			msbal.b_a With msbal.b_a + (opn.Stkqty)
	  endi	
			sele bal
			Seek ALLTRIM(Str(fsbal.Stkcode)) + Substr(fsbal.Stkbatch+Space(12),1,12)
            sum Stkqty to bal while Stkcode=fsbal.Stkcode and Stkbatch=fsbal.Stkbatch AND !EOF()    
	Sele fsbal
	Skip
Enddo
Sele msbal
sele mitm
scan 
  sele msbal
  seek str(mitm.code)
  sum balance to tot while code=mitm.code
			sele support
	    	repl type with "#",aliase with "DAT/F-IT",lcode with "MEDWIN",pcode with mitm.code,value with tot

endscan 
close table all 


@rowno,10 say '**** Importing Account Masters  ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath + 'subgroup.'+datatransferext
fs=datatransferpath + 'amttrans.'+datatransferext
td=datdev + '\order.'+datext
tp=datdev + '\support.'+datext

sele c
use &datatransferpath\daccount alias bal
set filt to dentry_typ='YO'
index on daccount1 to bal 
 
sele f
	use &tp alias msup
	index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3)  to msup

Sele a
	Use &fd Alias fact


Sele b
	Use &td Alias mact
	ZAP
Sele fact
Go Top
Do While !Eof()
   =seek(acctno,'bal')
   mopening=iif(found(),damount,0) 
   sele bal
   seek fact.acctno 
   sum damount to mbalance while daccount1=fact.acctno 
    
	Sele mact
	Append Blank
	Repl mact.rate With 'N'
	DO CASE 
	   CASE fact.Subgrpty='SC  '
			Repl mact.scode With 'D31'
			Repl mact.rate With old_3
	   case fact.Subgrpty='SD  '
			Repl mact.scode With 'C6'
			Repl mact.rate With old_3
	   case fact.Subgrpty='BA  '
			Repl mact.scode With 'C1'
			Repl mact.rate With old_3
	   case fact.Subgrpty='CASH'
			Repl mact.scode With 'C2'
			Repl mact.rate With old_3
	   other		
			Repl mact.scode With 'J12'
			Repl mact.rate With old_3
     endcase  
	repl mact.ordno with alltrim(str(fact.acctno))
	repl mact.parnam  with fact.subdesc
	repl mact.paradd with fact.subadd1
	repl mact.paradd1 with fact.subadd2
	repl mact.paradd2 with fact.subadd3	
	repl mact.sthed with  'tin no.'
	repl mact.csthed with 'cst no.'
	repl mact.gsthed with  'gst no.'
	repl mact.dlno with alltrim(fact.sublcno)
	repl mact.cstno with fact.cstno
	repl mact.gstno with fact.tinno
	repl mact.dsm with fact.pincode
	repl mact.mailnam with fact.subdesc
	repl mact.phone1 with substr(alltrim(fact.subphone),1,12)
	repl mact.phone2 with fact.mobileno
	repl mact.confir with fact.subpercn
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.city with fact.city
	repl mact.status with 'Y'
	repl mact.adhed with 'discount'
	repl mact.dsm with fact.pincode
	repl mact.mr with fact.salesman
	repl mact.opning with iif(old_4='Y',mbalance,mopening)
	repl mact.balance with mbalance 
	&& State
	sele msup
	seek 'ORDER   ' + '  7' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(fact.Tinno,1,2)='  ',mstatecode,subs(fact.Tinno,1,2))+'                                           '
	
&& UPDATED SUPPORT FOR LEDGER  DIFFERENCE    
    sele msup
	appe blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with iif(fact.Subgrpty='SD  ',fact.Subclbal,-fact.Subclbal) 
	Sele fact
	skip
endd
close table all

IF OLD_3='Y'
@rowno,10 say '**** Importing Customer Outstanding  ****' font 'Arial',12
rowno=rowno+1
	fd=datdev + '\order.'+datext
	af=datdev + '\pendings.'+datext
	bf=datdev + '\slipno.'+datext
	cf=datatransferpath + 'purchase.'+datatransferext
	
Sele a
Use &af Alias mpend
Zap

Sele b
Use &bf Alias mslip

Sele c
Use &cf Alias fout
Set Filter To pactamt>0

	Sele mslip
	Go Top
	vou =voucher  + 10
	svou=svoucher + 10
	Sele fout
	Go Top
	Do While .Not. Eof()
		Sele mpend
		Append Blank
		Repl mpend.acgroup With 'D31'
		Repl mpend.ord With Alltrim(Str(fout.Purparty))
		Repl mpend.ddate With fout.Purbldt
		Repl mpend.vcn With Alltrim(fout.Pbillno)
		Repl mpend.invtype With 'O'
		Repl mpend.voucher  With vou
		Repl mpend.svoucher With svou
		Repl mpend.Final With -fout.pactamt
		Repl mpend.balance With -fout.pactamt

		Repl Name With vcn
		vou=vou+5
		svou=svou+5
		Sele fout
		Skip
	Enddo
	Sele mslip
	Repl voucher  With vou+5
	Repl svoucher With svou+5
Endif
close table all

if old_4='N'
	do import_transactions 
endi


proc import_transactions

@rowno,10 say '**** Importing Inventory Transactions  ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datdev\slipno.&datext alias mslip 
go top
mvoucher=voucher+5
msvoucher=svoucher+4 
sele sele(1)
  use &datdev\mdis.&datext alias mdis  
sele sele(1)
  use &datdev\dis.&datext alias dis  
sele sele(1)
  use &datdev\pro.&datext alias pro  
  index on code to pro      
sele sele(1)
  use &datdev\probat.&datext alias probat 
  index on str(code)+batchno to probat  
sele sele(1)
use &datdev\support.&datext alias support     
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
@rowno,10 say '**** Importing Sale Bills   ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
   use &datatransferpath\salemaster alias sal  
sele sele(1)
   use &datatransferpath\dsalemaster alias sld 
   index on dpurblno to sld  
sele sal
scan for between(purbldt,old_5,old_6)
  mvoucher=mvoucher+5 
  sele mdis 
  appen blank 
  repl voucher with mvoucher  
  repl type with 'S' 
  repl vcn with repli('0',7-len(alltrim(str(sal.purblno))))+alltrim(Str(sal.purblno)) 
  repl date with sal.purbldt 
  repl codep with alltrim(str(sal.purparty)) 
  repl final with ROUND(sal.pbillamt,0)-sal.pcheqamt
  repl cash with sal.pcheqamt
		if final=cash
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
isigst=0		
if sal.interstate='Y'
	repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
    isigst=1
endif       
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with scalc
		repl discafter with 'N'

sele support 
appen blan
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
sele sld  
seek sal.purblno 
scan while dpurblno=sal.purblno 
   	myear='20'+alltri(str(dpexyear)) 
   	mmonth=iif(len(alltri(str(dpexmon)))=1,'0'+alltri(str(dpexmon)),alltri(str(dpexmon)))
   	mexp=ctod('01/'+mmonth+'/'+myear)
   sele dis
   appen blank 
   repl voucher with mdis.voucher  
   repl vcn with mdis.vcn
   repl date with mdis.date 
   repl codep with mdis.codep 
   repl code with sld.dpmedcod 
   repl tax with 'T' 
   repl qty with sld.dpqty 
   repl batch with sld.dpbatch 
   repl exp with mexp
   repl free with sld.dpfree  
   repl rate with sld.dpmrp&&&dpinvrat 
   repl disc1 with sld.dpdisc
   repl flg with 'G'  
   if isigst=1
     repl ssta with sld.dptax 
   else
     repl ssta with sld.dptax/2 
     repl cgst with sld.dptax/2  
   endif  
   repl lprate with sld.dpcost
   repl mrp with sld.dpmrp 
   repl pack with sld.dpsize  
endscan
sele mslip 
repl voucher with mvoucher,svoucher with msvoucher  
mvoucher=voucher+5
msvoucher=svoucher+4 
 
endscan
SELE SELE(1)
  SELE SAL
  USE 
  SELE SLD 
  USE
@rowno,10 say '**** Importing Purchase  Bills   ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
   use &datatransferpath\purchase alias sal  
sele sele(1)
   use &datatransferpath\dpurchas alias sld 
   index on dpurblno to sld  
sele sal
scan for between(purbldt,old_5,old_6)
  if alltrim(pbillno)='' and pbillamt=0
    loop
  endif  
  mvoucher=mvoucher+5 
  sele mdis 
  appen blank 
  repl voucher with mvoucher  
  repl type with 'P' 
  repl vcn with repli('0',7-len(alltrim(str(sal.purblno))))+alltrim(Str(sal.purblno)) 
  repl pm with sal.pbillno
  repl date with sal.recvdt 
  repl lrda with sal.purbldt 
  repl codep with alltrim(str(sal.purparty)) 
  repl final with sal.pbillamt-sal.pcheqamt
  repl cash with sal.pcheqamt
*!*	endif  
		if final=cash
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
isigst=0		
if sal.interstate='Y'
	repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
    isigst=1
endif       
		repl account with 'N'
		repl sale with 'z'
		repl godwon with 'A'
		repl ltype with scalc
		repl discafter with 'N'

sele support 
appen blan
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

sele sld  
seek sal.purblno 
scan while dpurblno=sal.purblno 
   	myear='20'+alltri(str(dpexyear)) 
   	mmonth=iif(len(alltri(str(dpexmon)))=1,'0'+alltri(str(dpexmon)),alltri(str(dpexmon)))
   	mexp=ctod('01/'+mmonth+'/'+myear)
   sele dis
   appen blank 
   repl voucher with mdis.voucher  
   repl vcn with mdis.vcn
   repl date with mdis.date 
   repl codep with mdis.codep 
   repl code with sld.dpmedcod 
   repl tax with 'T' 
   repl qty with sld.dpqty 
   repl batch with sld.dpbatch
   repl exp with mexp 
   repl free with sld.dpfree  
   repl rate with sld.dpinvrat 
   repl disc1 with sld.dpdisc  
   repl godwon with 'A'
   repl rsm with alltri(str(sld.dpaid))+"+"+alltri(str(sld.dpfree))
   repl flg with 'P'
   if isigst=1
     repl ssta with sld.dptax 
   else
     repl ssta with sld.dptax/2 
     repl cgst with sld.dptax/2  
   endif  
   repl lprate with sld.dpcost
   repl mrp with sld.dpmrp 
   repl pack with sld.dpsize  
endscan
sele mslip 
repl voucher with mvoucher,svoucher with msvoucher  
mvoucher=voucher+5
msvoucher=svoucher+4 
 
endscan
SELE SELE(1)
  SELE SAL
  USE 
  SELE SLD 
  USE
@rowno,10 say '**** Importing Sales Return  ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
   use &datatransferpath\salereturnmaster alias sal  
sele sele(1)
   use &datatransferpath\dsalemaster_return alias sld 
   index on dpurblno to sld  
sele sal
scan for between(purbldt,old_5,old_6)
*!*	  if alltrim(pbillno)='' and pbillamt=0
*!*	    loop
*!*	  endif  
  mvoucher=mvoucher+5 
  sele mdis 
  appen blank 
  repl voucher with mvoucher  
  repl type with 'R' 
  repl vcn with repli('0',7-len(alltrim(str(sal.purblno))))+alltrim(Str(sal.purblno)) 
  repl pm with sal.pbillno
  repl date with sal.recvdt 
  repl lrda with sal.purbldt 
  repl codep with alltrim(str(sal.purparty)) 
  repl final with sal.pbillamt 
  repl cash with 0 

if final=0 .and. cash#0
	repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
else
	repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
endif
isigst=0		
if sal.interstate='Y'
	repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
    isigst=1
endif       
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with scalc
		repl discafter with 'N'

sele support 
appen blan
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

sele sld  
seek sal.purblno 
scan while dpurblno=sal.purblno 
   sele dis
   appen blank 
   repl voucher with mdis.voucher  
   repl vcn with mdis.vcn
   repl date with mdis.date 
   repl codep with mdis.codep 
   repl code with sld.dpmedcod 
   repl tax with 'T' 
   repl qty with sld.dpqty 
   repl batch with sld.dpbatch 
   repl free with sld.dpfree  
   repl rate with sld.dpmrp&&&invrat 
   repl disc1 with sld.dpdisc  
   repl flg with 'R'
   repl godwon with 'A'

   if isigst=1
     repl ssta with sld.dptax 
   else
     repl ssta with sld.dptax/2 
     repl cgst with sld.dptax/2  
   endif  
   repl lprate with sld.dpcost
   repl mrp with sld.dpmrp 
   repl pack with sld.dpsize  
endscan
sele mslip 
repl voucher with mvoucher,svoucher with msvoucher  
mvoucher=voucher+5
msvoucher=svoucher+4 
 
endscan
SELE SELE(1)
  SELE SAL
  USE 
  SELE SLD 
  USE
@rowno,10 say '**** Importing Purchase Return  ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
   use &datatransferpath\Purchase_return alias sal  
sele sele(1)
   use &datatransferpath\dpurchas_return alias sld 
   index on dpurblno to sld  
sele sal
scan for between(purbldt,old_5,old_6)
*!*	  if alltrim(pbillno)='' and pbillamt=0
*!*	    loop
*!*	  endif  
  mvoucher=mvoucher+5 
  sele mdis 
  appen blank 
  repl voucher with mvoucher  
  repl type with 'B' 
  repl vcn with repli('0',7-len(alltrim(str(sal.purblno))))+alltrim(Str(sal.purblno)) 
  repl pm with sal.pbillno
  repl date with sal.recvdt 
  repl lrda with sal.purbldt 
  repl codep with alltrim(str(sal.purparty)) 
*!*	if sal.paymode=1  
*!*	  repl final with 0 
*!*	  repl cash with sal.pbillamt  
*!*	else
  repl final with sal.pbillamt 
  repl cash with 0 
*!*	endif  

		if final=0 .and. cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
isigst=0		
if sal.interstate='Y'
	repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
    isigst=1
endif       
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with scalc
		repl discafter with 'N'

sele support 
appen blan
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

sele sld  
seek sal.purblno 
scan while dpurblno=sal.purblno 
   sele dis
   appen blank 
   repl voucher with mdis.voucher  
   repl vcn with mdis.vcn
   repl date with mdis.date 
   repl codep with mdis.codep 
   repl code with sld.dpmedcod 
   repl tax with 'T' 
   repl qty with sld.dpqty 
   repl batch with sld.dpbatch 
   repl free with sld.dpfree  
   repl rate with sld.dpinvrat 
   repl disc1 with sld.dpdisc  
   repl flg with 'B'
   repl godwon with 'A'
   if isigst=1
     repl ssta with sld.dptax 
   else
     repl ssta with sld.dptax/2 
     repl cgst with sld.dptax/2  
   endif  
   repl lprate with sld.dpcost
   repl mrp with sld.dpmrp 
   repl pack with sld.dpsize  
endscan
sele mslip 
repl voucher with mvoucher,svoucher with msvoucher  
mvoucher=voucher+5
msvoucher=svoucher+4 
 
endscan
SELE SELE(1)
  SELE SAL
  USE 
  SELE SLD 
  USE


close table all   
      
slast5=msvoucher+5      
	@rowno,10 say '**** Importing Account ( From Sales ) ****' font 'Arial',12
	rowno=rowno+1
	af     =datdev + '\gledger.'+datext
	pend   =datdev + '\pend.'+datext
	mdis   =datdev + '\mdis.'+datext
	pending=datdev + '\pendings.'+datext
	sele g
	use &pending alias pending
	sele f
	use &pend alias pend excl
	zap
	sele b
	use &af alias gledger excl
	zap
	sele sele(1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele d
	use &mdis alias mdis
	go top
	do while .not. eof()
		=seek(mdis.codep,'ord')
		sele d
		if vcn=space(12)
			skip
			loop
		endif
		last1=mdis.codep
		if mdis.final#0
			sele b
			appe blank
			repl voucher with mdis.voucher
			if d.type='P'
				repl cd with 'C'
				repl credit with mdis.final
				repl book with 'A'
			else
				repl cd with 'D'
				repl debit with mdis.final
				repl book with 'S'
			endif
			repl date with mdis.date
			repl code with mdis.codep
			last1=mdis.codep
			repl remark1 with mdis.vcn
			repl type with 'Y'
			if mdis.salun=space(6)
				repl code1 with 'SP#20 '
			else
				repl code1 with mdis.salun
			endif
			repl gcode with ord.scode
**** for outstanding
			if old_3='Y'

				sele f
				appe blank
				repl ord with mdis.codep
				repl ddate with mdis.date
				repl duedays with mdis.duedays
				repl vcn with mdis.vcn
				if d.type='P'
					repl final with -mdis.final
				else
					repl final with mdis.final
				endif
				repl type with 'N'
				repl voucher with mdis.voucher
				repl adjvoucher with mdis.voucher
				repl svoucher with slast5
				slast5=slast5+5
				sele g
				appe blank
				repl ord with f.ord
				repl ddate with f.ddate
				repl vcn with f.vcn
				repl invtype with 'I'
				repl voucher with f.voucher
				repl duedays with f.duedays
				repl duedate with ddate+duedays
				repl final with f.final
				repl balance with f.final
				repl svoucher with f.svoucher
				repl name with mdis.remark4
				repl acgroup with ord.scode
			endif
		endif
		if mdis.cash#0
			sele b
			appe blank
			repl voucher with mdis.voucher
			if d.type='P'
				repl cd with 'C'
				repl credit with mdis.cash
			else
				repl cd with 'D'
				repl debit with mdis.cash
			endif
			repl date with mdis.date
			repl code with 'STACO3'
			last1='STACO3'
			repl remark1 with mdis.vcn
			repl book with 'S'
			repl type with 'Y'
			if mdis.salun=space(6)
				repl code1 with 'SP#20 '
			else
				repl code1 with mdis.salun
			endif
		endif
		if (mdis.final+mdis.cash)#0
			sele b
			appe blank
			repl voucher with mdis.voucher
			if d.type#'P'
				repl cd with 'C'
				repl credit with (mdis.final+mdis.cash)
			else
				repl cd with 'D'
				repl debit with (mdis.final+mdis.cash)
			endif
			repl date with mdis.date
			if mdis.salun=space(6)
				repl code with 'SP#20 '
			else
				repl code with mdis.salun
			endif
			repl remark1 with mdis.vcn
			repl book with 'S'
			repl type with 'Y'
			repl code1 with last1
		endif
		sele gledger
		sele d
		skip
	enddo
	sele gledger
close table all 

@Rowno,10 say '**** Importing Account Transactions ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
  use &datdev\gledger.&datext  alias gle  
sele sele(1)
  use &datatransferpath\daccount alias led 
  index on dtoc(dacct_date)+str(dentry_no)+dentry_typ to led  
sele sele(1)
  use &datdev\slipno.&datext alias mslip 
  sele mslip 
  mvoucher=voucher+5
  svoucher=svoucher+4
sele led
set filt to inlist(dentry_typ,'DB','PA','SD') AND BETWEEN(DACCt_DATE,OLD_5,OLD_6)
go top 
mdacct_date=ctod('') &&dacct_date  
mdentry_no=999999999999
mdentry_typ='  '
do while !eof()
   if dtoc(mdacct_date)+str(mdentry_no)+mdentry_typ#dtoc(dacct_date)+str(dentry_no)+dentry_typ 
       mvoucher=mvoucher+5 
       mdacct_date=dacct_date  
       mdentry_no=dentry_no
       mdentry_typ=dentry_typ 
   endif
   mbook=''
	   IF (mdentry_typ='DB' or mdentry_typ='PA')
	     mbook='P' 
	   else
	     if mdentry_typ='SD'
	        mbook='R' 
	     endif
	   endif 

   do while dtoc(mdacct_date)+str(mdentry_no)+mdentry_typ=dtoc(dacct_date)+str(dentry_no)+dentry_typ and !eof()
	   sele gle
	   appen blank
	   repl voucher with mvoucher 
	   repl date with mdacct_date 
	   repl vcsno with alltrim(str(mdentry_no,7))
	   repl book with mbook 
	   repl code with alltrim(Str(led.daccount1)) 
	   repl code1 with alltrim(str(led.daccount2)) 
	   repl remark1 with led.narration3
	   repl remark2 with led.narration2  
	   if led.damount>0 
	     repl cd with 'D' 
	     repl debit with led.damount
	   else
	     repl cd with 'C' 
	     repl credit with abs(led.damount)
       endif
    sele led 
    skip 
    enddo   
enddo 
sele mslip
repl voucher with mvoucher,svoucher with msvoucher
close table all 
      
  
  

func mdbsqlconvert(mdbsqlpara1)
do case
case mdbsqlpara1=1
	if datatransfermdb='Y'
		mrgmdbfile=alltrim(getfile('mdb'))
		datatransferpath=subs(datatransferpath+space(80),1,80)

		datatransferpath=alltrim(datatransferpath)
		=mdbsqlconvert(2)
	endif
case mdbsqlpara1=2 and datatransfermdb='Y'
	clear
	mrgmdbfile=alltrim(mrgmdbfile)
	mrgmdbpwd=alltrim(mrgmdbpwd)
	datatransferpath=subs(datatransferpath+space(80),1,80)
	mrgexit=0
	if empty(mrgmdbfile)
		=messagebox("Please Enter Access File Name !!",100,'Check MDB File Path')
		mrgexit=1
	endif
	if !file(mrgmdbfile)
		=messagebox("Access File not found. Please Check !!",100,'Check MDB File Path')
		mrgexit=1
	endif
	if empty(datatransferpath)
		=messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	endif
	if mrgexit=1
		=messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		return
	endif
	lnconnhandle=0
	merrno=0
	try
		if empty(mrgmdbpwd)
			lnconnhandle=sqlstringconnect('DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		else
			lnconnhandle=sqlstringconnect('PWD='+trim(mrgmdbpwd)+';DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		endif
	catch to oexp
		merrno=1
	endtry
	if merrno=1
		=messagebox('Invalid MS-Access data file or invalid password.',48,'Will Quit Now')
		retu
	endif
	if !directo(alltrim(datatransferpath))
		md &datatransferpath
	endif
	datatransferpath=addbs(datatransferpath)
	if lnconnhandle>0
		clear
		@07,10 say 'Converting Access File to DBF. Please Wait......' font 'courier',16
		dvfp_tflds=0
		sele sele(1)
		lnresult=sqltables(lnconnhandle,'TABLE')
		tblfnd=0
		if lnresult > 0
			sele sqlresult
			scan
				try
					msqltabl=uppe(allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					sele sele(1)
					lngetdata=sqlexec(lnconnhandle,lcsqlcommand,'NEWDATA')
					if lngetdata>0
						lcdbffilenm=allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=chrtran(lcdbffilenm," "+chr(9),"")
						sele newdata
						copy to &lcdbffilenm
						wait wind lcdbffilenm nowait
						use
					endif
				catch to oerr
					merrno=1
					=messagebox(oerr.message,64)
					susp
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "Access File Successfully Converted to DBF."

	else
		=messagebox('Unable to read from Connection',48,'Marg Payroll')
		retu
	endif
	rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	if merrno=1
		=messagebox('Error encountered while importing data.',48)
		retu
	endif
	clear
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16

	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
case mdbsqlpara1=3
	clear
	mrgsqlfile=alltrim(mrgsqlfile)
	mrgsqluserid=alltrim(mrgsqlpwd)
	mrgsqlpwd=alltrim(mrgsqlpwd)
	datatransferpath=subs(fullpath(curdir())+'Logic_Sql\'+space(80),1,80)
	mrgexit=0
	if empty(mrgsqlfile)
		=messagebox("Please Enter SQL Database Name !!",100,'Check File Name')
		mrgexit=1
	endif
	if empty(datatransferpath)
		=messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	endif
	if mrgexit=1
		=messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		return
	endif
	lnconnhandle=0
	merrno=0
	try
		lnconnhandle=sqlstringconnect("DRIVER=Sql Server;SERVER=SANTOSH-LP\SQLEXPRESS;UID="+mrgsqluserid+";PWD="+mrgsqlpwd+";APP=Microsoft Visual FoxPro;WSID=MARG01;DATABASE="+mrgsqlfile)
	catch to oexp
		merrno=1
	endtry
	if merrno=1
		=messagebox('Invalid data file or invalid password.',48,'Will Quit Now')
		retu
	endif
	if !directo(datatransferpath)
		md &datatransferpath
	endif
	datatransferpath=addbs(datatransferpath)
	if lnconnhandle>0
		clear
		@07,10 say 'Converting SQL Database to DBF. Please Wait......' font 'courier',16
		dvfp_tflds=0
		sele sele(1)
		lnresult=sqltables(lnconnhandle,'TABLE')
		tblfnd=0
		if lnresult > 0
			sele sqlresult
			scan
				try
					msqltabl=uppe(allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					sele sele(1)
					lngetdata=sqlexec(lnconnhandle,lcsqlcommand,'NEWDATA')
					if lngetdata>0
						lcdbffilenm=allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=chrtran(lcdbffilenm," "+chr(9),"")
						sele newdata
						copy to &lcdbffilenm
						use
					endif
				catch to oerr
					merrno=1
					=messagebox(oerr.message,64)
					susp
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "SQL DataBase  Successfully Converted to DBF."

	else
		=messagebox('Unable to read from Connection',48,'Marg ')
		retu
	endif
	rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	if merrno=1
		=messagebox('Error encountered while importing data.',48)
		retu
	endif
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16

	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next                           
	datatransferpath=alltrim(datatransferpath)
wait wind datatransferpath
endcase

proc  removenull
@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
totfiles=adir(fhandle,datatransferpath+'*.dbf')
for cfile = 1 to totfiles
	use datatransferpath+fhandle(cfile,1)
	if reccount()>0
		do rem_null
	endif
next                           


proc  rem_null
  a = AFIELDS(arr)
     FOR i = 1 TO a
          mfldname = arr(i, 1)
          DO CASE
               CASE INLIST(arr(i,2), "C","V")
                    REPLACE ALL &mfldname WITH '' FOR ISNULL(&mfldname)
               CASE INLIST(arr(i,2), "B","N","I","F","Y")
                    REPLACE ALL &mfldname WITH 0 FOR ISNULL(&mfldname)
               CASE INLIST(arr(i,2), "D","T")
                    REPLACE ALL &mfldname WITH CTOD('') FOR ISNULL(&mfldname)
          ENDCASE
     ENDFOR
