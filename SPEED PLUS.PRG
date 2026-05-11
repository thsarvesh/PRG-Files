*!*	BOF : MIRACLE.PRG(WHOLESALE) .....Nivedan Sharma
*****Last Change By Nivedan Sharma        Dated    : 24/01/2019
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
Close Data
Set Talk Off
Set Date To brit
Set Cent On
Set Dele On
Set Safe Off
Sele Sele(1)
Create Curs mycurs  (Setup c(50),Value c(4))
Sele mycurs
Appe Blank
Repl  Setup With 'Item Wise Double Discount ',Value With 'Y'
*!*	Appen Blank
*!*	Repl  Setup With 'Volume discount 1st ',Value With 'L'
Brow Font 'COURIER',18    Nomodify
if type('FINALCP')='U'
firstdate=ctod('01/04/2025')
lastdate= ctod('31/03/2026')
datdev='d:\transfer\'
datext= 'DBF'
endif
*!*	MARGPRMFMT='COURIER'
*!*	MARGPRMKKRFSZ=18
*!*	*SAVE SCREE TO SIMPLE   &&&REMOVE
datatransferpath=Substr('D:\2025\July\Miracle\data\'+Space(100),1,100)
datatransferext='DBF'
datatransfermdb='No '
old_3 = 'YES'
old_4 = 'Yes'
old_5 = FIRSTDATE
old_6 = LASTDATE
OLD_7 = 'G'
softtype='Wholesale'
scalc='2'
pcalc='2'
mstatecode='22'
sure='SURE'
mrgmdbfile=space(100)
mrgmdbpwd=space(30)
removenull='No '
clear
close data

@06,10 say 'Convert DBF From MDB  :' font 'Courier',12 get datatransfermdb  pict '@^m No ,Yes'  Font 'courier',12  valid mdbsqlconvert(1)
@07,10 Say 'Miracle Data Path    :' Font 'Courier',12  Get datatransferpath  Font 'courier',12
@08,10 Say 'Miracle Extension    :' Font 'Courier',12  Get datatransferext  Font 'courier',12
Read
@09,10 Say 'With Outstanding Y/N :' Font 'Courier',12  Get old_3 Pict '@m Yes,No '  Font 'Courier',12
@10,10 Say 'No-Full Yes-Master   :' Font 'Courier',12  Get old_4 Pict '@m No,Yes'  Font 'Courier',12
@11,10 Say 'F.Y.BEGIN Date       :' Font 'Courier',12  Get old_5  Font 'Courier',12
@12,10 Say 'F.Y.End   Date       :' Font 'Courier',12  Get old_6   Font 'Courier',12
@13,10 Say 'G-GST  V-Vat         :' Font 'Courier',12  Get OLD_7  Font 'Courier',12
@14,10 Say 'State Code           :' Font 'Courier',12  Get mstatecode Font 'Courier',12
@15,10 Say 'Sales Calculation    :' Font 'Courier',12  Get scalc   Font 'Courier',12
@16,10 Say 'Purch.Calculation    :' Font 'Courier',12  Get pcalc   Font 'Courier',12
@17,10 Say 'Wholesale            :' Font 'Courier',12  Get softtype Pict '@m Wholesale'   Font 'Courier',12
@18,10 Say 'Remove Null          :' Font 'Courier',12  Get Removenull Pict '@m No ,Yes'   Font 'Courier',12
@19,10 Say 'Type SURE            :' Font 'courier',12  Get sure Pict '@x!' Font 'courier',12
Read
Clear
Close Data
datatransferpath=Alltrim(datatransferpath)
If !Right(datatransferpath,1)='\'
	datatransferpath=Alltrim(datatransferpath)+'\'
Endif
datatransferext='.'+Alltrim(datatransferext)
DATDEV= Alltrim (DATDEV)
DATEXT= Alltrim (DATEXT)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
if type('FINALCO')#'U'
=starttransfer()
endif
if removenull='Y'
	clear
	@05,10 say 'Removing Null Values..Please Wait......' font 'courier',14
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif

rowno=5

@ 02,22 Say 'Please Wait Importing Miracle Data To Marg.....' Font 'Arial',14 Colo 'W+/G'

Set Colo To
Sele Sele(1)
Use &DATDEV\glmonth.&DATEXT
Zap
Use &DATDEV\ggmonth.&DATEXT
Zap
Use &DATDEV\pro.&DATEXT
Zap
Use &DATDEV\Order.&DATEXT
Zap
Use &DATDEV\saletype.&DATEXT
Zap
Use &DATDEV\gledger.&DATEXT
Zap
Use &DATDEV\pendings.&DATEXT
Zap
Use &DATDEV\pend.&DATEXT
Zap
Use &DATDEV\probat.&DATEXT
Zap
Use &DATDEV\maorder.&DATEXT
Zap
Use &DATDEV\sborder.&DATEXT
Zap
Use &DATDEV\mdis.&DATEXT
Zap
Use &DATDEV\dis.&DATEXT
Zap
Use &DATDEV\glmonth.&DATEXT
Zap
Use &DATDEV\ggmonth.&DATEXT
Zap
Use &DATDEV\Support.&DATEXT
Dele All For Type='#' And aliase='DAT/F'
Pack
Close Data
Set Colo To
If old_4='Y'
	Do margo
Else
	Do marga
Endif

Proc margo
@rowno,10 Say '**** Importing Company  ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\itemcompany  Alias Comp
Sele Sele(1)
Use &DATDEV\saletype.&DATEXT Alias stype
Dele All For sgcode = 'ZZZZZZ'
Pack
Sele Comp
Scan
	Sele stype
	Appen Blank
	Repl sgcode With 'ZZZZZZ',scode With Alltrim(Str(Comp.itemcompan,6))
	Repl parnam With Comp.itemcompa2,sname With Comp.itemcompa2
Endscan
Close Data

@rowno,10 Say '**** Importing Category  ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\itemgroup Alias grp
Sele Sele(1)
Use &DATDEV\saletype.&DATEXT Alias stype
Dele All For sgcode='CATEGO'
Pack
Sele grp
Scan
	Sele stype
	Appen Blank
	Repl sgcode With 'CATEGO',scode With Alltrim(Str(grp.itemgroupi,6))
	Repl parnam With grp.itemgroupn,sname With grp.itemgroupn
Endscan
Close Data


@rowno,10 Say '**** Importing Product with HSN  ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &DATDEV\saletype.&DATEXT Alias stype
Dele All For sgcode = 'COMMCD'
Pack
Inde On sgcode+parnam+Str(igst,6,2) To stype
Sele Sele(1)
Use &datatransferpath\items Alias fpro
*Do memo2chr
Sele Sele(1)
Use &datatransferpath\Pack Alias Pack
Index On ItemID To Pack
Sele Sele(1)
Use &datatransferpath\unit Alias unit
Index On unitid To unit
Sele Sele(1)
Use &datatransferpath\vatslab Alias ftax
Index On vatslabid To ftax
Sele Sele(1)
Use &DATDEV\pro.&DATEXT Alias pro
Dele All
Pack
Sele fpro
Scan
	=Seek(ItemID,'pack')
	=Seek(unitid,'unit')
	Sele pro
	Appen Blank
	Repl Code With fpro.ItemID
	Repl Name With Alltrim(Str(fpro.ItemID))
	Repl Product With fpro.itemname
	repl bookname WITH fpro.om2
	Repl packing With fpro.saltname
	Repl Pack With fpro.conversion
	Repl billname With subs(fpro.itemname,1,30)+' '+subs(fpro.itemname,1,15)
	Repl unit With unit.unitname
	Repl billname With Alltrim(fpro.itemname)+' '+Pack.packname
	Repl gcode With Alltrim(Str(fpro.itemcompan,6))
	Repl gcode5 With Alltrim(Str(fpro.itemgroupi,6))
	Repl Pack With FPRO.CONVERSION
	Repl saltax  With fpro.vatpercent
	Repl taxl With Iif(fpro.vatpercent#0,'T','P')
	Repl Decimal With 'Y'
	Repl gcode3 With Alltrim(Str(fpro.itemgroupi))
	Repl RACKNO With fpro.OT13
	If old_7='G'
		If Empty(fpro->hsncode)
			Loop
		Endi
		=Seek(fpro->vatslabid,'ftax')
		If Found('ftax')
			Sele stype
			If !Seek('COMMCD'+Padr(fpro->hsncode,15)+Str(ftax->igstpercen,6,2),'stype')
				Appen Blank
				Repl sgcode With 'COMMCD',;
					scode With Right(Sys(2015),6),;
					parnam With Padr(fpro->hsncode,15),;
					sname With Padr(fpro->hsncode,15),;
					tax With ftax->sgstpercen,;
					cgst With ftax->cgstpercen,;
					igst With ftax->igstpercen
			Endi
			Sele pro
			Repl gcode6 With stype->scode
			Repl saltax With stype->tax
			Repl cgst With stype->cgst
			Repl igst With stype->igst
		Endif
	Endi
	Sele pro
Endscan
Close Data

@rowno,10 Say '**** Importing Stock  ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\Batch Alias fstock
Sele Sele(1)
Use &datatransferpath\INVENTORY  Alias Tran
*do memo2chr
Index On Str(ItemID,6)+Str(batchid,6) To Tran
Sele Sele(1)
Use &DATDEV\pro.&DATEXT Alias pro
Index On Str(Code,9) To pro
Sele Sele(1)
Use &DATDEV\probat.&DATEXT Alias probat
Dele All
Pack
Index On Code To probat
Sele Sele(1)
Use  &DATDEV\Support.&DATEXT Alias Support


Sele fstock
Scan
	=Seek(Str(ItemID,9),'PRO')
	Sele probat
	Appen Blank
	Repl Code With pro.Code
	Repl Name With pro.Name
	Repl Product With pro.Product
	Repl packing With pro.name
	Repl billname With pro.billname
	Repl batchno With fstock.batchno
	Repl mycode With fstock.batchCODE
	Repl lprate With fstock.basicprice
	Repl ratea With fstock.saleprice
	Repl mrp With fstock.mrp
	Repl prate With fstock.purchasepr
	Repl Exp With Ctod('01/'+Chrtr(fstock.expirydate,'-','/'))
	Sele Tran
	Seek Str(fstock.ItemID,6)+Str(fstock.batchid,6)
	Sum Iif('PURC'$Upper(Transactio),qty+Free,-(qty+Free)) To tot While ItemID=fstock.ItemID And batchid=fstock.batchid
	Sele probat
	Repl opening With fstock.OPSTOCK+tot,balance With fstock.OPSTOCK+tot,o_a With fstock.OPSTOCK+tot,b_a With fstock.OPSTOCK+tot
	Sele pro
	Repl ratea With probat.ratea,mrp With probat.mrp,prate With probat.prate,lprate With probat.lprate
	
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-BT",pcode With pro.Code,Heading With probat.batchno,Value With probat.balance


Endscan
Sele pro
Scan
	Sele probat
	Seek pro.Code
	Sum balance To tot While Code=pro.Code
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-IT",pcode With pro.Code,Value With tot

Endscan
Close Data

@rowno,10 Say '**** Importing Product Composition  ****' Font 'courier',12
rowno=rowno+1

Sele Sele(1)
Use &datatransferpath\items Alias fslt
Index On itemgroupi To xx Uniq
Sele Sele(1)
Use &DATDEV\saletype.&DATEXT Alias stype
Sele fslt
Scan
	Sele stype
	Appe Blank
	Repl sgcode With 'SALT'
	Repl scode With Alltrim(Str(fslt.itemgroupi))
	Repl sname With Alltrim(fslt.itemgroupn)
Endscan
Close Table All


@rowno,10 Say '**** Importing Ledgers   ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\account Alias fact
Do memo2chr
Sele Sele(1)
Use &datatransferpath\ledger Alias Tran
Do memo2chr
Sele Tran
Index On accountid To Tran
Sele Sele(1)
Use &DATDEV\Order.&DATEXT Alias mact
Dele All
Pack
Sele Sele(1)
Use &DATDEV\Support.&DATEXT Alias Support

Sele fact
Scan
	mopbal=opbal
	Sele mact
	Appen Blank
	Do Case
	Case fact.Accountsgr=1
		Repl scode With 'B'
	Case fact.Accountsgr=2
		Repl scode With 'C'
	Case fact.Accountsgr=3
		Repl scode With 'D'
	Case fact.Accountsgr=4
		Repl scode With 'E'
	Case fact.Accountsgr=5
		Repl scode With 'F'
	Case fact.Accountsgr=6
		Repl scode With 'G'
	Case fact.Accountsgr=8
		Repl scode With 'I'
	Case fact.Accountsgr=9
		Repl scode With 'J'
	Case fact.Accountsgr=11
		Repl scode With 'C2'
	Case fact.Accountsgr=12
		Repl scode With 'C1'
	Case fact.Accountsgr=13
		Repl scode With 'C3'
	Case fact.Accountsgr=14
		Repl scode With 'C4'
	Case fact.Accountsgr=15
		Repl scode With 'C5'
	Case fact.Accountsgr=16 Or fact.Accountsgr=23 Or fact.Accountsgr=99
		Repl scode With 'C6'
	Case fact.Accountsgr=17 Or fact.Accountsgr=24 Or fact.Accountsgr=100
		Repl scode With 'D31'
	Case fact.Accountsgr=18
		Repl scode With 'D1'
	Case fact.Accountsgr=19
		Repl scode With 'J12'
	Case fact.Accountsgr=20
		Repl scode With 'G2'
	Case fact.Accountsgr=21
		Repl scode With 'G3'
	Case fact.Accountsgr=24
		Repl scode With 'J11'
	Case fact.Accountsgr=25
		Repl scode With 'J12'
	Case fact.Accountsgr=26
		Repl scode With 'J3'
	Case fact.Accountsgr=28
		Repl scode With 'G1'
	Case fact.Accountsgr=29
		Repl scode With 'B1'
	Case fact.Accountsgr=24
		Repl scode With 'J11'
	Endcase

	Repl ordno With Alltrim(Str(fact.accountid))
	Repl mailnam With Upper(fact.accountnam)
	Repl parnam With Upper(fact.accountnam)
	Repl paradd With fact.address
	Repl paradd1 With fact.address2
	Repl city With fact.city
	Repl phone1 With fact.phone
	Repl gstno With fact.tinno,gsthed With 'TIN NO:'
	Repl dlno With Alltrim(fact.dlno1)+' '+Alltrim(fact.dlno2)
	Repl itno With fact.itpan
	Repl gstno With fact.ot21
	Repl limit With fact.creditlimi,duedays With fact.creditdays
	Sele Tran
	Seek fact.accountid
	Sum Iif(Dc='D',amount,0),Iif(Dc='C',amount,0) To dr,cr While accountid =fact.accountid
	Sele mact
	Repl opning With  dr-cr,balance With dr-cr
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-LD",Lcode With mact.ordno,Value With mact.balance
	Appe Blank
	Repl Type With 'F'
	Repl Lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Substr(mact.gstno,1,2)=mstatecode,mstatecode,'00')+Substr(remark,42)

Endscan
Close Data


Proc marga
@rowno,10 Say '**** Importing Company  ****' Font  'courier',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\itemcompany&datatransferext  Alias Comp
Sele Sele(1)
Use &DATDEV\saletype.&DATEXT Alias stype
Dele All For sgcode = 'ZZZZZZ'
Pack
Sele Comp
Scan
	Sele stype
	Appen Blank
	Repl sgcode With 'ZZZZZZ',scode With Alltrim(Str(Comp.itemcompan,6))
	Repl parnam With Comp.itemcompa2,sname With Comp.itemcompa2
Endscan
Close Data

@rowno,10 Say '**** Importing Category  ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\itemgroup&datatransferext Alias grp
Sele Sele(1)
Use &DATDEV\saletype.&DATEXT Alias stype
Dele All For sgcode='CATEGO'
Pack
Sele grp
Scan
	Sele stype
	Appen Blank
	Repl sgcode With 'CATEGO',scode With Alltrim(Str(grp.itemgroupi,6))
	Repl parnam With grp.itemgroupn,sname With grp.itemgroupn
Endscan
Close Data


@rowno,10 Say '**** Importing Product with HSN  ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &DATDEV\saletype.&DATEXT Alias stype
Dele All For sgcode = 'COMMCD'
Pack
Inde On sgcode+parnam+Str(igst,5,2) To stype
Sele Sele(1)
Use &datatransferpath\items&datatransferext Alias fpro
Do memo2chr
Sele Sele(1)
Use &datatransferpath\Pack Alias Pack
Index On ItemID To Pack
Sele Sele(1)
Use &datatransferpath\unit&datatransferext Alias unit
Index On unitid To unit
Sele Sele(1)
Use &datatransferpath\vatslab&datatransferext Alias ftax
Index On vatslabid To ftax
Sele Sele(1)
Use &DATDEV\pro.&DATEXT Alias pro
Dele All
Pack
Sele fpro
SCAN
last=recno()
	=Seek(ItemID,'pack')
	=Seek(unitid,'unit')
    =Seek(fpro->vatslabid,'ftax')
	Sele pro
	Appen Blank
	Repl Code With fpro.ItemID
	Repl Name With Alltrim(Str(fpro.ItemID))
	Repl Product With fpro.itemname
	Repl billname With subs(fpro.itemname,1,30)+' '+subs(fpro.itemname,1,15)
	Replace unit With unit.unitname
	*Replace packing With fpro.PACKING &&&&&&saltname
    Repl pack With fpro.conversion
    repl pack with fpro.qtypercase
    repl bookname with fpro->om2
    
	Repl billname With Alltrim(fpro.itemname)
	Repl gcode With Alltrim(Str(fpro.itemcompan,6))
	Repl gcode5 With Alltrim(Str(fpro.itemgroupi,6))
	Repl saltax  With fpro.vatpercent
	Repl taxl With Iif(fpro.vatpercent#0,'T','P')
	Repl Decimal With 'Y'
	repl opening WITH fpro->opstock
	repl o_a WITH fpro->opstock
    repl saltax WITH ftax->sgstpercen
    repl cgst WITH ftax->cgstpercen	
    repl igst WITH ftax->igstpercen	
	*********Hsn Transfer********
	Sele stype
	Seek 'COMMCD' + Substr(fpro->hsncode+Space(15),1,15) + Str(pro->igst,5,2)
	If !Found()
		Append Blank
		Repl sgcode With 'COMMCD',;
			scode  With  'H'+Alltr(Str(Last)),;
			sname  With Substr(fpro->hsncode+Space(15),1,15)+' '+ Alltrim(Str(pro->igst,5,2)) ,;
			parnam With Substr(fpro->hsncode,1,15),;
			tax With pro->saltax,;
			cgst With pro->cgst,;
			igst With pro->igst,;
			tcode With 'No'
	Endif
	Repl pro->gcode6 With stype->scode
Endsca
Clos Table All

@rowno,10 Say '**** Importing Stock  ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\Batch&datatransferext Alias fstock

Sele Sele(1)
Use &datatransferpath\Inventory&datatransferext  Alias Tran
Index On Str(ItemID,6)+Str(batchid,6) To Tran
Sele Sele(1)
Use &DATDEV\pro.&DATEXT Alias pro
Index On Str(Code,9) To pro
Sele Sele(1)
Use &DATDEV\support.&DATEXT Alias support
INDEX on pcode TO support
Sele Sele(1)
Use &DATDEV\probat.&DATEXT Alias probat
Dele All
PACK
Index On Code To probat

Sele fstock
Scan
	=Seek(Str(ItemID,9),'PRO')
	Sele probat
	Appen Blank
	Repl Code With pro.Code
	Repl Name With pro.Name
	Repl Product With pro.Product
	Repl packing With pro.packing
	Repl pack With pro.pack
	Repl billname With pro.billname
	Repl batchno With fstock.batchno
	Repl mycode With fstock.batchcode
	Repl lprate With fstock.basicprice
	Repl ratea With fstock.saleprice
	Repl mrp With fstock.mrp
	Repl prate With fstock.purchasepr
	Repl Exp With Ctod('01/'+Chrtr(fstock.expirydate,'-','/'))
	Repl opening With fstock.OPSTOCK
	Repl balance With fstock.OPSTOCK
	Repl o_a With fstock.OPSTOCK
	Repl b_a With fstock.OPSTOCK
	
	Sele Tran
	
	Seek Str(fstock.ItemID,6)+Str(fstock.batchid,6)
	
	Sum Iif(Transactio='Purchase       '  OR Transactio='Sale Return' OR Transactio='Purchase Challan   ' ,qty+Free,0),Iif(Transactio='Sale      '  OR Transactio='Purchase Return   ' OR Transactio='Purchase Challan   ' OR TRANSACTIO='Sale Challan       ' ,(qty+Free),0) To tot1,tot2 While ItemID=fstock.ItemID And batchid=fstock.batchid
	
    stockcl=probat.opening+tot1-TOT2
	
	Sele pro
	Repl ratea With probat.ratea,mrp With probat.mrp,prate With probat.prate,lprate With probat.lprate
   && UPDATING SUPPORT FOR BATCH STOCK DIFF
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-BT",pcode With pro.Code,Heading With fstock.batchno,Value With stockcl
	
 Endscan
 Sele pro
 Scan
	Sele support
	Seek pro.Code
	
	Sum value To tot While support.Pcode=pro.Code 
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-IT",pcode With pro.Code,Value With tot

 Endscan
Close Data


@rowno,10 Say '**** Importing Ledgers   ****' Font 'courier',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\account&datatransferext Alias fact
Do memo2chr
Sele Sele(1)
Use &datatransferpath\ledger&datatransferext Alias Tran
Do memo2chr
Sele Tran
Index On accountid To Tran
Sele Sele(1)
Use &DATDEV\Support.&DATEXT Alias Support
index on aliase + str(sno,3) + lcode to msup
Dele All For aliase = 'ORDER   '
Dele All For aliase = "DAT/F-LD"
Pack


Sele Sele(1)
Use &DATDEV\Order.&DATEXT Alias mact
Dele All
Pack
Sele fact
Scan
	mopbal=IIF(FACT.DC='C',-opbal,OPBAL)
	Sele mact
	Appen Blank
	Do Case
	Case fact.Accountsgr=1
		Repl scode With 'B'
	Case fact.Accountsgr=2
		Repl scode With 'C'
	Case fact.Accountsgr=3
		Repl scode With 'D'
	Case fact.Accountsgr=4
		Repl scode With 'E'
	Case fact.Accountsgr=5
		Repl scode With 'F'
	Case fact.Accountsgr=6
		Repl scode With 'G'
	Case fact.Accountsgr=8
		Repl scode With 'I'
	Case fact.Accountsgr=9
		Repl scode With 'J'
	Case fact.Accountsgr=11
		Repl scode With 'C2'
	Case fact.Accountsgr=12
		Repl scode With 'C1'
	Case fact.Accountsgr=13
		Repl scode With 'C3'
	Case fact.Accountsgr=14
		Repl scode With 'C4'
	Case fact.Accountsgr=15
		Repl scode With 'C5'
	Case fact.Accountsgr=16 Or fact.Accountsgr=23 Or fact.Accountsgr=99
		Repl scode With 'C6'
	Case fact.Accountsgr=17 Or fact.Accountsgr=24 Or fact.Accountsgr=100
		Repl scode With 'D31'
	Case fact.Accountsgr=18
		Repl scode With 'D1'
	Case fact.Accountsgr=19
		Repl scode With 'J12'
	Case fact.Accountsgr=20
		Repl scode With 'G2'
	Case fact.Accountsgr=21
		Repl scode With 'G3'
	Case fact.Accountsgr=24
		Repl scode With 'J11'
	Case fact.Accountsgr=25
		Repl scode With 'J12'
	Case fact.Accountsgr=26
		Repl scode With 'J3'
	Case fact.Accountsgr=28
		Repl scode With 'G1'
	Case fact.Accountsgr=29
		Repl scode With 'B1'
	Case fact.Accountsgr=24
		Repl scode With 'J11'



	Endcase

	Repl ordno With Alltrim(Str(fact.accountid))
	Repl mailnam With Upper(fact.accountnam)
	Repl parnam With Upper(fact.accountnam)
	Repl paradd With fact.address
	Repl paradd1 With fact.address2
	Repl city With fact.city
	Repl phone1 With fact.phone
	Repl cstno With fact.tinno,csthed With 'TIN NO:'
	Repl dlno With Alltrim(fact.dlno1)+' '+Alltrim(fact.dlno2)
	Repl itno With fact.itpan
	Repl gstno With fact.ot21
	Repl limit With fact.creditlimi,duedays With fact.creditdays
	Sele Tran
	Seek fact.accountid
	Sum Iif(Dc='D',amount,0),Iif(Dc='C',amount,0) To dr,cr While accountid =fact.accountid
	Sele mact
	Repl opning With  mopbal,balance With mopbal+dr-cr&&IIF(MACT.SCODE='D31',mopbal+cr-dr,mopbal+dr-cr)
   &&&&& UPDATING SUPPORT LEDGER DIFF
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-LD",Lcode With mact.ordno,Value With mact.balance
   && State
	Sele Support
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl Lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(fact.ot21,1,2)='  ',mstatecode,Subs(fact.ot21,1,2))+'                                           '


Endscan
Close Data

@rowno,10 Say '**** Importing Inventory Transaction  ****' Font 'courier',12
rowno=rowno+1
mdis=DATDEV+ '\mdis.'+DATEXT
af =DATDEV + '\gledger.'+DATEXT
bf =DATDEV + '\slipno.'+DATEXT
dis=DATDEV + '\dis.'+DATEXT
pro=DATDEV + '\pro.'+DATEXT
ord=DATDEV + '\order.'+DATEXT
sp=datdev +'\support.'+datext
sal=datatransferpath +'voucher'+datatransferext
sld=datatransferpath +'Inventory'+datatransferext
Sele Sele(1)
Use &sp Alias Support
Dele All For Type='#'  And aliase="DAT/F-SL"
Pack
Sele i
Use &bf
Go Top
last4 = voucher+10
slast5= svoucher+10

last4=last4+20
Sele e
Use &pro Alias pro
index on code to pro 
Sele SELECT(1)
Use &ord Alias ord
INDEX on ordno TO ord
Sele c
Use &sal Alias sal
Set Filter To ENTRYDATE>=old_5 And ENTRYDATE<=old_6
Do memo2chr
Set Filter To  (Transactio='Purchase            ' Or Transactio='Sale           ' Or Transactio='Sale Return      ' Or Transactio='Purchase Return    ' Or Transactio='Purchase Challan   ' Or Transactio='Sale Challan     ' OR transactio='Sale Return Challan     ' or transactio='Purchase Return Challan     ' ) And (ENTRYDATE>=old_5 And ENTRYDATE<=old_6 )

Sele h
Use &sld Alias sld
Index On voucherid To sld

Sele d
Use &mdis Alias mdis
Zap
Sele g
Use &dis Alias dis
Zap

Sele c
Go Top
Do While .Not. Eof()
   MVCN=repl('0',6-len(alltrim(STR(c.vchno))))+alltrim(STR(C.vchno))
    SELECT ORD
    SEEK STR(c.partyid,6)
	last1=c.voucherid
	
	Sele d
	Appe Blank

	If c.Transactio='Purchase                                          '
		Repl Type With 'P'
		Repl vcn With 'P'+MVCN
		Repl Date With c.ENTRYDATE
		Repl PM With c.purchasebi && updated party code dated 31-12-2019
	Else
		If c.Transactio='Sale                                              '
			Repl Type With 'S'
			If c.SUBTYPE='Retail       '
				Repl vcn With mvcn
				Repl Date With c.ENTRYDATE
			Else
				Repl vcn With mvcn
				Repl Date With c.ENTRYDATE
			Endif
		Else
			If  c.Transactio='Purchase Return                                   '
				Repl Type With 'B'
				Repl vcn With 'PR'+mvcn
				Repl Date With c.ENTRYDATE
			Else
				If c.Transactio='Sale Return                                       '
					Repl Type With 'R'
					Repl vcn With 'SR'+mvcn
					Repl Date With c.ENTRYDATE
				Else
					If c.Transactio='Purchase Challan   '
						Repl Type With 'P'
						Repl challan With 'PC'+mvcn
						Repl chdate With c.ENTRYDATE
					Else
						If c.Transactio='Sale Challan                              '
							Repl Type With 'S'
							Repl challan With 'SC'+mvcn
							Repl chdate With c.ENTRYDATE
                       else
                          If c.Transactio='Sale Return Challan                '  &&&&added by umesh on 22th,jul,2020
							Repl Type With 'R'
							Repl challan With 'SRC'+mvcn
							Repl chdate With c.ENTRYDATE
							else
                               If c.Transactio= 'Purchase Return Challan     '  &&&&added by umesh on 22th,jul,2020
                               Repl Type With 'B'
		       	          	   Repl challan With 'PRC'+mvcn
       			    	       Repl chdate With c.entrydate
                                endi
                             endi
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif


	Repl Codep With Alltrim(Str(C.accountid))
	Repl voucher With last4&&c.voucherid
	last4=last4+5
	Repl amountp With Iif(Empty(c.billsundry),Round(c.subtotal,2),Round(c.totalamoun,2))
	Repl salun With ''
	Repl staxun With 'SZTZOZ'
	If c.paymentter='Cash     '
		Repl cash With Iif(Empty(c.billsundry),Round(c.subtotal,2),Round(c.totalamoun,2))
	Else
		Repl Final With Iif(Empty(c.billsundry),Round(c.subtotal,2),Round(c.totalamoun,2))
	Endif
	If Final=0 .And. cash#0
		Repl misc3 With Substr(misc3,1,34)+'C'+Substr(misc3,36,100)
	Else
		Repl misc3 With Substr(misc3,1,34)+'R'+Substr(misc3,36,100)
	Endif
	Repl duedays With 0
	Repl lrda With c.Date1
	Repl account With 'N'
	Repl sale With 'Z'
	Repl godwon With 'A'
	Repl ltype With IIF(D.type$'PB',pcalc,scalc)
	Repl discafter With 'N'
	Repl remark4 With Alltrim(Str(c.vchno))
	Repl remark1 With Iif(Empty(c.billsundry),STR(c.subtotal,2),Str(c.totalamoun,12,2))
	Repl other With c.billsundry
	Repl othun With 'STcA%-'
	isigst=0
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
			isigst=1
 
     endif
	&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SL",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	Sele h
	Seek last1

	Do While .Not. Eof() .And. h.voucherid= last1 .And.  h.vchno=c.vchno
       =seek(itemid,'pro')
		Sele g
		Appe Blank
		Repl Codep With d.Codep
		Repl vcn With IIF(EMPTY(d.vcn),d.challan,d.vcn)
		Repl Date With IIF(EMPTY(d.Date),d.chdate,d.date)
		Repl voucher With d.voucher&&h.voucherid
		Repl Code With h.ItemID
		Repl tax With 'T'
		Repl qty With h.qty
		Repl Free With h.Free
		Repl Batch With h.batchno
	    repl exp with CTOD('01'+'/'+SUBSTR(h.expirydate,1,2)+'/'+SUBSTR(h.expirydate,4,4))
	    If (h.transactio='Sale' OR h.transactio='Sale Challan' ) .and. d.Type = 'S'  &&& UPDATED BY NIVEDAN SHARMA DATED 05/11/2019
	    
			Repl flg With 'G'
		ELSE
		IF  h.transactio='Sale Return' or h.transactio='Sale Return Challan'
		Repl flg With 'R'
		
		Else
			Repl flg With d.Type
		ENDIF
		endif
		Repl Rate With h.selectedpr
		Repl disc1 With h.discountra
		Repl disc2 With -h.on2
		If isigst=1
				Repl ssta With h.igstpercen
			Else

				Repl ssta With h.igstpercen/2
				Repl cgst With h.igstpercen/2
		Endif
	
		Repl mrp With h.mrp
		Repl Half With 'A'
		Repl godwon With d.godwon

		Sele h
		Skip
	Enddo
	Sele c
	Skip
Enddo
Close Data
@rowno,10 Say '**** Importing Account from Sales ****' Font 'Arial',12
rowno=rowno+1
af   =datdev+'\gledger.'+datext
pend =datdev+'\pend.'+datext
mdis =datdev+'\mdis.'+datext
pending=datdev+'\pendings.'+datext
Sele g
Use &pending Alias pending
Zap
Sele F
Use &pend Alias pend
Zap
Sele b
Use &af Alias gledger
Zap
Sele d
Use &mdis Alias mdis
Go Top
Do While .Not. Eof()
	If vcn=Space(12)
		Skip
		Loop
	Endif
	last1 = mdis.Codep
	If mdis.Final#0
		Sele b
		Appe Blank
		Repl voucher With mdis.voucher
		If d.Type = 'P'
			Repl Cd With 'C'
			Repl credit With mdis.Final
			Repl book With 'A'
		Else
			Repl Cd With 'D'
			Repl debit With mdis.Final
			Repl book With 'S'
		Endif
		Repl Date With mdis.Date
		Repl Code With mdis.Codep
		last1=mdis.Codep
		Repl remark1 With mdis.vcn
		Repl Type With 'Y'
		If mdis.salun=Space(6)
			Repl code1 With 'SP#20 '
		Else
			Repl code1 With mdis.salun
		Endif
       **** for outstanding
		If old_3='Y'
			Sele F
			Appe Blank
			Repl ord With mdis.Codep
			Repl ddate With mdis.Date
			Repl duedays With mdis.duedays
			Repl vcn With mdis.vcn
			If d.Type = 'P'
				Repl Final With -mdis.Final
			Else
				Repl Final With mdis.Final
			Endif
			Repl Type With 'N'
			Repl voucher With mdis.voucher
			Repl adjvoucher With mdis.voucher
			Repl svoucher With slast5
			slast5 = slast5 + 5
			Sele g
			Appe Blank
			Repl ord With F.ord
			Repl ddate With F.ddate
			Repl vcn With F.vcn
			Repl invtype With 'I'
			Repl voucher With F.voucher
			Repl duedays With F.duedays
			Repl duedate With ddate+duedays
			Repl Final With F.Final
			Repl balance With F.Final
			Repl svoucher With F.svoucher
			Repl Name With mdis.remark4
		Endif
	Endif
	If mdis.cash#0
		Sele b
		Append Blank
		Repl voucher With mdis.voucher
		If d.Type = 'P'
			Repl Cd With 'C'
			Repl credit With mdis.cash
		Else
			Repl Cd With 'D'
			Repl debit With mdis.cash
		Endif
		Repl Date With mdis.Date
		Repl Code With 'STACO3'
		last1='STACO3'
		Repl remark1 With mdis.vcn
		Repl book With 'S'
		Repl Type With 'Y'
		If mdis.salun=Space(6)
			Repl code1 With 'SP#20 '
		Else
			Repl code1 With mdis.salun
		Endif
	Endif
	If (mdis.Final+mdis.cash)#0
		Sele b
		Append Blank
		Repl voucher With mdis.voucher
		If d.Type#'P'
			Repl Cd With 'C'
			Repl credit With (mdis.Final + mdis.cash)
		Else
			Repl Cd With 'D'
			Repl debit With (mdis.Final+mdis.cash)
		Endif
		Repl Date With mdis.Date
		If mdis.salun=Space(6)
			Repl Code With 'SP#20 '
		Else
			Repl Code With mdis.salun
		Endif
		Repl remark1 With mdis.vcn
		Repl book With 'S'
		Repl Type With 'Y'
		Repl code1 With last1
	Endif
	Sele d
	Skip
Enddo
Close Data

@rowno,10 Say '**** Importing Ledgers Transaction(Receipt/Payment)   ****' Font 'courier',12
rowno=rowno+1
af      = DATDEV + '\gledger.'+DATEXT
bf      = DATDEV + '\slipno.'+DATEXT
cf      = datatransferpath+'voucher'+datatransferext
pend    = DATDEV + '\pend.'+DATEXT
pending = DATDEV + '\pendings.'+DATEXT
Sele g
Use &pending Alias pending
Index On ord + Substr(Name,1,12) To rou2
last4  = last4 + 10
slast5 = slast5 + 10

Sele F
Use &pend Alias pend
Sele b
Use &af Alias gledger
Sele a
Use &cf Alias led
Set Filter To Transactio='Quick Receipt                          ' Or Transactio='Quick Payment                             ' Or Transactio='Chq Issd                                          ' Or Transactio='Chq Recd                                          ' And Date>=old_5
Go Top

Do While !Eof()

&& Debit Credit Vice versa
	Sele b
	Append Blank
	Repl vcsno With ALLTRIM(STR(a.vchno))
	Repl voucher With a.voucherid
	If a.Transactio='Quick Payment                             ' Or a.Transactio='Chq Issd                                          '
		Repl Cd With 'D'
		Repl DEBIT With a.totalamoun
		Repl Code With alltri(str(a.partyid))
		Repl code1 With alltri(str(a.accountid))
		Repl book With 'P'
	Else
		If a.Transactio='Chq Recd                                          ' OR A.Transactio='Quick Receipt                          '
			Repl Cd With 'C'
			Repl credit With a.totalamoun
			Repl Code With  alltri(str(a.partyid))
			Repl code1 With alltri(str(a.accountid))
			Repl book With 'R'
		Endif
	Endif
	Repl Date With a.ENTRYDATE
	Repl remark1 With a.longnarrat
	If a.Transactio='Quick Receipt                          '
		Repl book With 'R'
	Else
		If a.Transactio='Quick Payment                    '
			Repl book With 'P'

		Endif
	ENDIF


&& Debit Credit Vice versa
	Sele b
	Append Blank
	Repl vcsno With ALLTRIM(STR(a.vchno))
	Repl voucher With a.voucherid
	If a.Transactio='Quick Payment                             ' Or a.Transactio='Chq Issd                                          '
		Repl Cd With 'C'
		Repl credit With a.totalamoun
		Repl code1 With Padr(a.partyid,6)
		Repl Code With Padr(a.accountid,6)
		Repl book With 'P'
	Else
		If a.Transactio='Chq Recd                                          ' OR A.Transactio='Quick Receipt                          '
			Repl Cd With 'D'
			Repl DEBIT With a.totalamoun
			Repl code1 With Padr(a.partyid,6)
			Repl Code With Padr(a.accountid,6)
			Repl book With 'R'
		Endif
	Endif
	Repl Date With a.ENTRYDATE

	Repl remark1 With a.longnarrat
*!*		If a.Transactio='Quick Receipt                          '
*!*			Repl book With 'R'
*!*		Else
*!*			If a.Transactio='Quick Payment                    '
*!*				Repl book With 'P'

*!*			Endif
*!*		Endif


	Sele a
	Skip
Enddo
Close Data

bf=DATDEV+'\slipno.'+DATEXT
Use &bf
Go Top
Repl voucher With last4+20
Repl svoucher With slast5+20
bf=DATDEV+'\mdis.'+DATEXT
Use &bf
Repl misc4 With ' '
bf=DATDEV+'\pendings.'+DATEXT

Use &bf
Repl All vcn With '*'+vcn For invtype='O' .And. ddate<=old_5
Close Data

** Transfer CALCULATION FIELD OF MARG TRANSACTION FILE
dis=DATDEV+'\dis.'+DATEXT
Use &dis
Go Top
Do While .Not. Eof()
	Repl sfrate With Rate+Val(Substr(dis.misc4,1,6))
	Repl ssscamo With Round((sfrate*qty)*sssc/100,2)
	Repl sstaamo With Round((sfrate*qty+ssscamo)*ssta/100,2)
	Repl sfrate With sfrate+Round(sfrate*sssc/100,2)
	Repl sfrate With sfrate+Round(sfrate*ssta/100,2)
	Repl shalfamo With Rate*halffree
	tot=Rate*qty-vdisamo-shalfamo
	totd=Round(tot*disc1/100,2)
	Repl sdiscount With totd
	tot=tot-totd
	totd=Round(tot*disc2/100,2)
	Repl sdiscount With sdiscount+totd
	tot=(Rate-ssex)*qty-sdiscount-shalfamo-vdisamo
	totd=Round(tot*addis/100,2)
	Repl ammmount With sfrate*qty-sdiscount-shalfamo-vdisamo
	Repl ssscamo With ssscamo+(sfrate*qty-Rate*qty)-(ssscamo+sstaamo)
	Skip
Enddo
Close Data
Endproc


func mdbsqlconvert(mdbsqlpara1)
do case
case mdbsqlpara1=1
	if datatransfermdb='Y'
		mrgmdbfile=alltrim(getfile('mdb'))
		datatransferpath=alltrim(datatransferpath)
		=mdbsqlconvert(2)
	endif
case mdbsqlpara1=2 and datatransfermdb='Y'
	mrgmdbfile=alltrim(mrgmdbfile)
	mrgmdbpwd='' &&alltrim(mrgmdbpwd)
	datatransferpath=subs(alltrim(datatransferpath)+space(80),1,80)
	datatransferpath=alltrim(datatransferpath)
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
*!*						susp
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "Access File Successfully Converted to DBF."
	else
		=messagebox('Unable to read from Connection',48,'Marg ')
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
	mrgsqluserid=alltrim(mrgsqluserid)
	mrgsqlpwd=alltrim(mrgsqlpwd)
	datatransferpath=alltrim(datatransferpath)
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
		lnconnhandle=sqlstringconnect("DRIVER=Sql Server;SERVER=SANTOSH-IT-LP\SQLEXPRESS;UID="+mrgsqluserid+";PWD="+mrgsqlpwd+";APP=Microsoft Visual FoxPro;WSID=MARG01;DATABASE="+mrgsqlfile)
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
*datatransferpath=subs(alltrim(datatransferpath)+space(80),1,80)
endcase


proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor


Proc memo2chr
tbl=Alia()
Set Memo To 8000
Sele &tbl
marr=Afield(tarr)
For i=1 To marr
	If tarr[i,2]='M'
		fldname=tarr[i,1]
		Alter Table &tbl Alter Column &fldname c(254)
	Endi
	@rowno,10	Say'Wait while Fetching records :' +Str(i,10) Font 'courier',12
Next
rowno=rowno+1
ENDPROC
