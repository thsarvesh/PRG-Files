
sure = Space(4)
datdev=Substr('E:\VFP\TRANSFER\'+Space(150),1,150)
datatransferpath=Substr('E:\VFP\DATA\'+Space(150),1,150)
datext ='A01'
datatransferext='.dbf'
Old_3 = 'YES'
Old_4 =  'NO'
Old_5 = Ctod('01/04/2025')
Old_6 = Ctod('31/03/2026')
freeqty='NO '
MSTATECODE='33'
@08,10 Say 'MARG DATA FROM            :' Get datdev
@09,10 Say 'MARG EXTENTION            :' Get datext
@10,10 Say 'BIT_BYTE  DATA FROM       :' Get datatransferpath
@11,10 Say 'OUR EXTENTION             :' Get datatransferext
@12,10 Say 'WITH O/S                  :' Get Old_3 Pict '@m Yes,No '
@13,10 Say 'ONLY BALANCE              :' Get Old_4 Pict '@m Yes,No '
@14,10 Say 'Opn & Free Stock Separate :' Get freeqty  Pict '@m No ,Yes'
@15,10 Say 'F.Y.BEGIN FROM            :' Get Old_5
@16,10 Say 'F.Y.UPTO                  :' Get Old_6
@17,10 Say 'Type SURE                 :' Get sure Pict '@x!'
Read
datatransferpath =Alltrim(datatransferpath)
datatransferext=alltrim(datatransferext)
datdev =Alltrim(datdev)
datext=Alltrim(datext)
If Lastkey() = 27 .And. sure# 'SURE'
	Return
Endif
Clear
Set Colo To N/W
@ 11,22 Fill To 13,62 Colo N+
@ 10,20 Clea To 12,60
@ 10,20 To 12,60
Set Colo To N/W*
@ 11,22 Say 'Transfering RaviShankar(WS)Data to MARG Data .....'
Set Colo To
*=starttransfer()
If Old_4='Y'
	Do margO
Else
	Do margA
Endif
Proc margO
* wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'Transfer ITEM'
@ 12,22 Say  'Transfering ITEM Master'

fd=datatransferpath+'MEDMAST'+datatransferext
td=datdev+'\pro.'+datext
ts=datdev+'\saletype.'+datext

sele e
use &ts alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm

SELECT a
USE &fd ALIAS fitm

Sele b
Use &td Alias mitm
ZAP  
Index On Name To mitm

sele fitm
pack
go top
do while !eof()

   last=recno()
    Sele mitm
	Seek fitm.mdcode
	append blank
    Replace mitm.Code With Last
	Replace mitm.Name With fitm.mdcode
	Replace mitm.Product With fitm.mdname
	Replace mitm.BillName With fitm.mdname+' '+fitm.packg
*	Repl mitm.billname With Upper(fitm.mdname)+" "+Alltrim(Str(fitm.packg,5,0))+' S'

*	Replace mitm.Unit With fitm.Uqc

	If fitm.Uqc=' '
	Replace mitm.Unit With 'Pcs'
	Else
	Replace mitm.Unit With fitm.Uqc
		Endif

	Replace mitm.Gcode With fitm.supno
	Replace mitm.Packing With fitm.packg
	Replace mitm.formulano With fitm.SUPCODE

		If fitm.tax1='01'
			Replace mitm.Saltax With 0
			Replace mitm.Purtax With 0
			Replace mitm.CGST   With 0
			Replace mitm.IGST   With 0
			Replace mitm.Taxl With "E"
			Replace mitm.Taxc With "E"
		Else
		Endif
		If fitm.tax1='02'
			Replace mitm.Saltax With 6
			Replace mitm.Purtax With 6
			Replace mitm.CGST   With 6
			Replace mitm.IGST   With 12
			Replace mitm.Taxl With "T"
			Replace mitm.Taxc With "T"
		Else
		Endif
		If fitm.tax1='03'
			Replace mitm.Saltax With 9
			Replace mitm.Purtax With 9
			Replace mitm.CGST   With 9
			Replace mitm.IGST   With 18
			Replace mitm.Taxl With "T"
			Replace mitm.Taxc With "T"
		Else
		Endif
		If fitm.tax1='04'
			Replace mitm.Saltax With 14
			Replace mitm.Purtax With 14
			Replace mitm.CGST   With 14
			Replace mitm.IGST   With 28
			Replace mitm.Taxl With "T"
			Replace mitm.Taxc With "T"
		Else
		Endif
		If fitm.tax1='05'
			Replace mitm.Saltax With 2.5
			Replace mitm.Purtax With 2.5
			Replace mitm.CGST   With 2.5
			Replace mitm.IGST   With 5
			Replace mitm.Taxl With "T"
			Replace mitm.Taxc With "T"
		Else
		Endif
&&?'foR hsn'
  
  Sele mpcm
		Seek 'COMMCD' + Substr(fitm.Hsn+Space(15),1,15) + Str(mitm.igst,5,2)
		If !Found()
			Append Blank
			Repl mpcm.sgcode With 'COMMCD',;
				mpcm.scode  With 'H'+alltr(str(last)),;
				mpcm.sname  With Substr(fitm.Hsn+Space(15),1,15)+ Substr(fitm.Hsn,1,15)+' '+ Alltrim(Str(mitm.igst,5,2))+'%',;
				mpcm.parnam With Substr(fitm.Hsn,1,15),;
				mpcm.tax With mitm.saltax,;
				mpcm.cgst With mitm.cgst,;
				mpcm.igst With mitm.igst,;
				mpcm.tcode With 'No'
		Endi
		Repl mitm.gcode6 With mpcm.scode
Sele fitm
	Skip
Enddo
Close data

@ 13,22 Say  'Transfering Company Master'
*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'Transfer COMPANY'
fd=datatransferpath + 'SUPMAST'+datatransferext
td=datdev + '\saletype.'+datext

Sele a
Use &fd Alias FPcm
Sele b
Use &td Alias MPcm
Index On SCode To MPcm
pack
Sele FPcm
Go Top
Do While .Not. Eof()
	Sele MPcm
	If .Not. Found()
		Append Blank
		Replace MPcm.SGCode With 'ZZZZZZ'
		Replace MPcm.SCode  With FPcm.supno
		Replace MPcm.SName  With FPcm.supname
		Replace MPcm.ParNam With FPcm.supname
	Endif
	Sele FPcm
	Skip
Enddo
Close data

@ 14,22 Say  'Transfering Area Master'
*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'Transfer AREA'
fd=datatransferpath + 'afile'+datatransferext
td=datdev + '\saletype.'+datext

SELECT a
use &fd ALIAS fpcm

sele b
use &td ALIAS mpcm
dele all for sgcode='AREA  '
pack
index on scode to mpcm 
sele fpcm
go top
do while .not. eof()
   sele mpcm
   append blank
        repl mpcm.sgcode with 'AREA  '
        Replace MPcm.SCode  With fpcm.acode
		Replace MPcm.SName  With FPcm.aname
		Replace MPcm.ParNam With FPcm.aname
        replace mpcm.tcode with 'No'
        replace mpcm.tax with 1
sele fpcm
skip
enddo
close data

@ 15,22 Say  'Transfering Stock Details'

*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'Transfer BATCH'
fd=datatransferpath + 'medmast'+datatransferext
td=datdev + '\probat.'+datext
mi=datdev + '\pro.'+datext
ms=datdev + '\support.'+datext

sele select(1)
use &ms alias support
dele all for type='#'

Sele a
Use &fd Alias FSbal
Index On mdcode To ROUGH1

Sele b
Use &mi Alias mitm
Index On Name To mitm

Sele c
Use &td Alias MSbal
Zap
Index On Name To MSbal

r=0
sele fsbal
go top
do while .not. eof()

select fsbal
    for x=1 to 9
    y=alltrim(str(x))
    if !empty(fsbal.bat&y)
     
   Sele mitm
   Seek FSbal.mdcode
   
   sele msbal
      append blank
         Replace MSbal.Code With mitm.Code
	     Replace MSbal.Name With mitm.Name
	     Replace MSbal.BillName With mitm.BillName
	     Replace MSbal.Product With mitm.Product
	     Replace MSbal.Packing With mitm.Packing
	     Replace MSbal.Opening With FSbal.qty&y
	     Replace MSbal.Balance With FSbal.qty&y
	     Replace MSbal.o_a With FSbal.qty&y
	     Replace MSbal.b_a With FSbal.qty&y
	     Replace MSbal.BatchNo With FSbal.Bat&y
	     Replace MSbal.Exp With FSbal.Exp&y
	     Replace MSbal.prate With FSbal.prate&y
	     Replace MSbal.lprate With FSbal.prate&y
	     Replace MSbal.ratea With FSbal.srate&y
	     Replace MSbal.mrp With FSbal.mrp&y
     endif	
      next x
	  sele fsbal
	  SKIP
	  ENDDO 
      sele msbal
      Repl All Date With Old_5-1 For balance = 0
      close data
      
@ 16,22 Say  'Transfering Supplier Master'

*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'Transfer SUPPLIER'
fd=datatransferpath + 'DISTMAST'+datatransferext
td=datdev + '\order.'+datext
ts=datdev + '\support.'+datext

sele e
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup
DELE ALL FOR ALIASE ='ORDER' AND SNO=7
pack
   
sele a
use &fd alia fact

sele b
use &td alia mact
zap

sele fact
go top
do while .not. eof()
last=recno()
   sele mact
   append blank
    replace mact.scode with 'D31'
    replace mact.rate with 'Y'
    Replace mact.ordno With fact.pacode
	Replace mact.ParNam With fact.pname
	Replace mact.MAILNAM With fact.pname
	Replace mact.PARADD With fact.padd1
	Replace mact.PARADD1 With fact.padd2
	Replace mact.PARADD2 With alltrim(fact.padd3)+" "+alltrim(fact.padd4)
	Replace mact.PHONE1 With fact.phone
	Replace mact.gstno With fact.Gstin
	Replace mact.itno With fact.Pan
	Replace mact.CITY With fact.padd4
	Replace mact.csthed With 'TIN No.'
	replace mact.ref with 'Mr.'
    replace mact.price with 'A'
    replace mact.status with 'Y'
    replace mact.adhed with 'Discount'
  
   	&& Updating State
	Sele msup
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(fact.Gstin,1,2)='  ',MSTATECODE,Subs(fact.Gstin,1,2))+'                                           '
	         
 sele fact
skip
enddo
close data

@ 17,22 Say  'Transfering Customer Master'
*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'Transfer CUSTOMER'
fd=datatransferpath + 'CUSMAST'+datatransferext
td=datdev + '\order.'+datext
ts=datdev + '\support.'+datext

sele e
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup
DELE ALL FOR ALIASE ='ORDER' AND SNO=7
pack
   
sele a
use &fd alia fact

sele b
use &td alia mact

sele fact
go top
do while .not. eof()
last=recno()
   sele mact
   append blank
    replace  mact.scode with 'C6'
    replace  mact.rate with 'Y'
    Replace mact.ordno With fact.ccode
	Replace mact.ParNam With fact.cname
	Replace mact.MAILNAM With fact.cname
	Replace mact.PARADD With fact.cadd1
	Replace mact.PARADD1 With fact.cadd2
	Replace mact.PARADD2 With alltrim(fact.cadd3)+" "+alltrim(fact.cadd4)
	Replace mact.PHONE1 With fact.cphone
	Replace mact.CITY With fact.cadd4
	Replace mact.dlno With fact.cdl20+" "+fact.cdl21
	Replace mact.fax2 With fact.ccode
	Replace mact.mr With fact.scode
*	Replace mact.opning With fact.Clbal
	Replace mact.area With fact.acode
	Replace mact.gstno With fact.gstin
	Replace mact.itno With fact.pan
	Replace mact.csthed With 'TIN No.'
  
   	&& Updating State
	Sele msup
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(fact.Gstin,1,2)='  ',MSTATECODE,Subs(fact.Gstin,1,2))+'                                           '
	         
 sele fact
skip
enddo
close data

@ 18,22 Say  'Transfering Rep Master'
*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'Transfer Sales Man'
fc=datatransferpath + 'sfile'+datatransferext
td=datdev + '\order.'+datext

sele c
use &fc alias fsup
sele b
use &td alias mact

sele fsup
go top
do while .not. eof()
   sele mact
   APPEND BLANK
   REPLACE mact.rate with 'Y'
   replace MACT.ordno with fsup.scode
   replace MACT.parnam with fsup.sname
   REPLACE MACT.MAILNAM WITH fsup.sname
   REPLACE MACT.scode with 'D32'
sele fsup
skip
enddo
close data

@ 19,22 Say  'Transfering Supplier Outstanding'
*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'Transfer SUPPLIER OUTSTANDING OPENING'
cf=datatransferpath + 'supout'+datatransferext
af=datdev + '\pendings.'+datext
bf=datdev + '\slipno.'+datext
df=datdev + '\order.'+datext


Select d
Use &df Alias mord
Index On ordno To mord
Sele a
Use &af Alias mpend
Zap
Sele b
Use &bf Alias mslip
Sele c
Use &cf Alias fout
Index On pacode To fout

If old_3='Y'

	Sele mslip
	Go Top
	vou =voucher  + 10
	svou=svoucher + 10

	Sele fout
	Go Top
	Do While !Eof()

		Select mord
		Seek fout.pacode
		Sele mpend
		Append Blank
		Repl mpend.acgroup With Iif(fout.invamt<0,'C6 ','D31 ')
		Repl mpend.ord With fout.pacode
		Repl mpend.ddate With fout.invdt
		Repl mpend.vcn With fout.invno
		Repl mpend.invtype With 'O'
		Repl mpend.voucher  With vou
		Repl mpend.svoucher With svou
		Repl mpend.Final With -fout.invamt
		Repl mpend.itemope With -fout.Paidamt
		Repl mpend.Balance With -(fout.invamt-fout.paidamt)
		
		Repl Name With vcn
		vou=vou+5
		svou=svou+5
		Sele fout
		Skip
		Repl mord.opning With (mpend.Balance-(fout.invamt-fout.paidamt))
	Enddo
    
    
    Sele mslip
	Repl voucher  With vou+5
	Repl svoucher With svou+5

Endif
Close data


@ 20,22 Say  'Transfering Customer Outstanding'
*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'** Transfer CUSTOMER OUTSTANDING OPENING'
cf=datatransferpath + 'custran'+datatransferext
af=datdev + '\pendings.'+datext
bf=datdev + '\slipno.'+datext
df=datdev + '\order.'+datext

Select d
Use &df Alias mord
Index On ordno To mord
Sele a
Use &af Alias mpend
Sele b
Use &bf Alias mslip
Sele c
Use &cf Alias fout
Index On ccode To fout
set filt to rdamt<invamt

If old_3='Y'

	Sele mslip
	Go Top
	vou =voucher  + 10
	svou=svoucher + 10

	Sele fout
	Go Top
	Do While !Eof()

		Select mord
		Seek fout.ccode
		Sele mpend
		Append Blank
		Repl mpend.acgroup With Iif(fout.invamt>0,'C6 ','D31 ')
		Repl mpend.ord With fout.ccode
		Repl mpend.ddate With fout.invdt
		Repl mpend.vcn With alltrim(str(fout.invno))
		Repl mpend.invtype With 'O'
		Repl mpend.voucher  With vou
		Repl mpend.svoucher With svou
		Repl mpend.Final With fout.Invamt
		Repl mpend.itemope With fout.Rdamt
		Repl mpend.Balance With fout.Invamt-fout.Rdamt
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
Close data

@ 21,22 Say  'Transfering CUSTOMER Credit note Pending OPENING'
*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'** Transfer CUSTOMER credit note pending OPENING'
cf=datatransferpath + 'sreturn'+datatransferext
af=datdev + '\pendings.'+datext
bf=datdev + '\slipno.'+datext
df=datdev + '\order.'+datext

Select d
Use &df Alias mord
Index On ordno To mord
Sele a
Use &af Alias mpend
Sele b
Use &bf Alias mslip
Sele c
Use &cf Alias fout
Index On ccode To fout
set filt to adjust#flock()

If old_3='Y'

	Sele mslip
	Go Top
	vou =voucher  + 10
	svou=svoucher + 10

	Sele fout
	Go Top
	Do While !Eof()

		Select mord
		Seek fout.ccode
		Sele mpend
		Append Blank
		Repl mpend.acgroup With Iif(fout.net_amt>0,'C6 ','D31 ')
		Repl mpend.ord With fout.ccode
		Repl mpend.ddate With fout.sretdt
		Repl mpend.vcn With 'CN-'+alltrim(str(fout.sretno))
		Repl mpend.invtype With 'O'
		Repl mpend.voucher  With vou
		Repl mpend.svoucher With svou
		Repl mpend.Final With -fout.net_amt
		Repl mpend.Balance With -fout.net_amt
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
Close data


Select SELECT(1)
Use datdev+'\pendings.'+datext ALIAS pendings  
Index On ord To T

Select b
Use datdev+'\order.'+datext ALIAS order 
Index On ordNO To ttt
Select a

Select b

Select ord,Sum(BALANCE) As balance From pendings Into Cursor tmp readwrite Group By ord
Select tmp
Scan
	Select Order
	Seek tmp.ord
	Replace balance With tmp->balANCE
	ENDSCAN
	Select ord,Sum(BALANCE) As BALANCE From pendings Into Cursor tmp readwrite Group By ord 
Select tmp
Scan
	Select Order
	Seek tmp.ord
	Replace  order.opning With tmp->BALANCE 
Endscan
@ 28,25 Say '<<< Please Check all Tax Details with Tax code in Product Master    !!! >>>' font 'Tahoma',14
@ 30,25 Say '<<< Migration Process completed. Congratulations to Win more orders !!! >>>' font 'Tahoma',14

CLOSE DATA


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

Close data
Close all
Clear

