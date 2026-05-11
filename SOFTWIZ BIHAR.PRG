Set Talk Off
Set Date To brit
Set Cent On
Set Dele On
Set Safe Off
close table all
clea
sure = 'SURE'
If Type('FINALCP')='U'
	firstdate=Ctod('01/04/2024')
	lastdate =Ctod('31/03/2025')
	datdev='d:\transfer\'
	datext='DBF'
Endif

old_3 = 'YES'
old_4 = 'YES'
old_5 = Ctod('01/04/2019')
old_6 = '2'
mstatecode='10'
datatransferpath=Substr('D:\2025\June\softwiz\SOFTWIZ\data\'+Space(100),1,100)
OLD_7='G'
datatransferext='DBF'
@ 08,22 Say 'Softwiz Data Transfe to Marg Erp'+space(20) font 'Arial Bold',14 Colo Rgb(20,255,255,119,136,153)
@ 10,22 Say 'Softwiz Data Path :' font 'Courier New',12 Get datatransferpath font 'Courier New',12
@ 11,22 Say 'Softwiz Extantion :' font 'Courier New',12 Get datatransferext font 'Courier New',12
@ 12,22 Say 'Only Balance      :' font 'Courier New',12 Get old_4 pict '@m Yes,No ' font 'Courier New',12
@ 13,22 Say 'State Code        :' font 'Courier New',12 GET mstatecode font 'Courier New',12
@ 14,22 Say 'Type SURE         :' font 'Courier New',12 Get sure Pict '@x!' font 'Courier New',12
Read

datatransferpath=Alltrim(datatransferpath)
datdev=Alltrim(datdev)
datext=Alltrim(datext)
If Type('FINALCP')#'U'
	=starttransfer()
Endif
If Lastkey()=27 Or Sure # 'SURE'
	Return
Endif
Clear

@02,22 Say 'Please Wait Importing Softwiz Data....'+Space(50) Font 'Arial Bold',14 Colo Rgb(20,255,255,119,136,153)
close table all
Sele Sele(1)
Use &datdev\Pro.&datext
Zap
Use &datdev\Order.&datext
Zap
Use &datdev\SaleType.&datext
Zap
Use &datdev\Gledger.&datext
Zap
Use &datdev\Pendings.&datext
Zap
Use &datdev\Pend.&datext
Zap
Use &datdev\Probat.&datext
Zap
Use &datdev\maOrder.&datext
Zap
Use &datdev\sBorder.&datext
Zap
Use &datdev\MDIS.&datext
Zap
Use &datdev\DIS.&datext
Zap
Use &datdev\GLMONTH.&datext
Zap
Use &datdev\subdis.&datext
Zap
Use &datdev\support.&datext
Zap

Close Table All
If old_4='Y'
	Do margonly
Else
	Do margall
Endif
****  FOR ONLY BALANCES **************************************************

Proc margonly
rowno=4
@ rowno,22 say padr('Transfer PRODUCT ',50,'.') font 'Courier New',12
rowno=rowno+1
fd=datatransferpath+'product.DBF'
td=datdev+'pro.'+datext
ts = datdev+'saletype.'+datext

Sele d
Use &datdev\saletype.&datext Alias mpcm
Dele All For sgcode = 'COMMCD'
Pack
Index On sgcode + parnam + Str(igst,5,2) To mpcm


Sele a
Use &fd Alias fitm

Sele b
Use &datdev\Pro.&datext alias mitm
Zap
Index On Name To mitm
Sele fitm
Pack
Go Top
Do While !Eof()
	Last=Recno()
	Select mitm
	Substr(ALLTRIM(STR(fitm.Procode))+Space(10),1,10)
	If .Not. Found()
		Sele mitm
		Append Blank
		Repl mitm.Code With Last
		Repl mitm.Name With ALLTRIM(STR(fitm.Procode))
		Repl mitm.Product With Upper(fitm.Product_na)
	*	Repl mitm.packing With Upper(fitm.Itmpack)
		Repl mitm.Pack With Iif(fitm.pack1=1,0,fitm.pack1)
		Repl mitm.billname With Alltrim(fitm.Product_na)
		Repl mitm.unit With 'PCS'
		Repl mitm.gcode With right(Alltrim(fitm.Company),6)
		Repl mitm.gcode5 With RIGHT(Alltrim(fitm.Group_name),6)
		Repl mitm.rackno With left(fitm.codeno,20)
		Repl mitm.taxl With 'T'
		Repl mitm.taxc With 'T'
		Repl mitm.Decimal With 'Y'
		Repl mitm.salfix With 'N'
		Repl mitm.halfsche With 'A'
		Repl mitm.qtrsche With 'Y'
		Repl mitm.Status With 'Y'
		Repl mitm.minimum With fitm.minqty
		Repl mitm.maximum With fitm.maxqty
		
		If fitm.purtax='GST5%                                                                                               '

			Repl mitm.saltax With  2.50
			Repl mitm.purtax With  2.50
			Repl mitm.cgst With 2.50
			Repl mitm.igst With 5
		Else
			If  fitm.purtax='GST12%                                                                                              '
				Repl mitm.saltax With  6.00
				Repl mitm.purtax With  6.00
				Repl mitm.cgst With 6.00
				Repl mitm.igst With 12.00
			Else
				If  fitm.purtax='GST18%                                                                                              '
					Repl mitm.saltax With  9.00
					Repl mitm.purtax With  9.00
					Repl mitm.cgst With 9.00
					Repl mitm.igst With 18.00
				Else
					If  fitm.purtax='GST28%                                                                                              '
						Repl mitm.saltax With  14.00
						Repl mitm.purtax With  14.00
						Repl mitm.cgst With 14.00
						Repl mitm.igst With 28.00
					Endif
				Endif
			Endif
		Endif
		
		Repl mitm.prate With fitm.pur
		Repl mitm.ratea With fitm.sale
		Repl mitm.mrp With fitm.mrp
	Endif
	&&For HSN
	Sele mpcm
	Seek 'COMMCD' + Substr(fitm.hsncode+Space(15),1,15) + Str(mitm.igst,5,2)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'COMMCD',;
			mpcm.scode  With 'C'+Alltrim(Str(Last)),;
			mpcm.sname  With Substr(fitm.hsncode+Space(15),1,15)+ Substr(fitm.hsncode,1,15) +' '+ Alltrim(Str(mitm.igst,5,2)) ,;
			mpcm.parnam With Substr(fitm.hsncode,1,15),;
			mpcm.tax With mitm.saltax,;
			mpcm.cgst With mitm.cgst,;
			mpcm.igst With mitm.igst,;
			mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode6 With mpcm.scode

	Sele fitm
	Skip
Enddo
Close table all
@ rowno,22 say padr('Transfer COMPANY ',50,'.') font 'Courier New',12
rowno=rowno+1

fd=datatransferpath+'product.DBF'
td=datdev+'saletype.'+datext
Sele a
Use &fd Alias fpcm
INDEX on left(mfg,20) TO fpcm uniq

Sele b
Use &datdev\saletype.&datext Alias mpcm
Set Filt To sgcode='ZZZZZZ'
Dele All
Pack
Index On scode To mpcm

Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'ZZZZZZ',;
		mpcm.scode  With RIGHT(Alltrim(fpcm.mfg),6),;
		mpcm.sname  With UPPER(fpcm.mfg),;
		mpcm.parnam With UPPER(fpcm.mfg),;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele fpcm
	Skip
Enddo
Close table all

@ rowno,22 say padr('Transfer CATEGORY ',50,'.') font 'Courier New',12
rowno=rowno+1

fd=datatransferpath+'product.dbf'
td=datdev+'saletype.'+datext
Sele a
Use &fd Alias fpcm
INDEX on left(group_name,20) TO fpcm uniq
Sele b
Use &datdev\saletype.&datext Alias mpcm
Set Filt To sgcode='CATEGO'
Dele All
Pack
Index On scode To mpcm
Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'CATEGO',;
		mpcm.scode  With RIGHT(Alltrim(fpcm.group_name),6),;
		mpcm.sname  With UPPER(fpcm.group_name),;
		mpcm.parnam With UPPER(fpcm.group_name),;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele fpcm
	Skip
Enddo
Close table all

@ rowno,22 say padr('Transfer BATCH ',50,'.') font 'Courier New',12
rowno=rowno+1

fd=datatransferpath + 'productstock.DBF'
td=datdev + 'probat.'+datext
mi=datdev + 'pro.'+datext

Sele a
Use &fd Alias fsbal

Sele b
Use &datdev\pro.&datext Alias mitm
Index On Name To mitm

Sele c
Use &datdev\probat.&datext Alias msbal

Zap
Index On Name + batchno To msbal

r=0
Sele fsbal
Go Top
Do While .Not. Eof()

	Sele mitm
	Seek Substr(Alltrim(Str(fsbal.Procode))+Space(10),1,10)

	Sele msbal
	Seek  Substr(Alltrim(Str(fsbal.Procode))+Space(10),1,10)+ Substr(fsbal.Batch+Space(12),1,12)

	If .Not. Found()
		Append Blank
		Repl msbal.Date With Date()
		Repl msbal.Code With mitm.Code
		Repl msbal.Name With mitm.Name
		Repl msbal.billname With mitm.billname
		Repl msbal.Product With mitm.Product
		Repl msbal.packing With mitm.packing
		Repl msbal.Pack With mitm.Pack
		Repl msbal.unit2 With mitm.unit2
		Repl msbal.unit With mitm.unit
		Repl msbal.Decimal With 'Y'
		Repl msbal.opening With fsbal.stock
		Repl msbal.balance With fsbal.stock
		Repl msbal.o_a With   fsbal.stock
		Repl msbal.b_a With  fsbal.stock
		Repl msbal.batchno With fsbal.Batch
		Repl msbal.Exp With fsbal.Exp
		Repl msbal.prate With fsbal.purrate
		Repl msbal.ratea With fsbal.Salerate
		Repl msbal.mrp With fsbal.mrp
		Repl msbal.misc1 With mitm.gcode
	
     Else
		Repl msbal.opening With msbal.opening +fsbal.stock
		Repl msbal.balance With msbal.balance+fsbal.stock
		Repl msbal.o_a With   msbal.o_a+fsbal.stock
		Repl msbal.b_a With  msbal.b_a+fsbal.stock

	Endif
	Sele fsbal
	Skip
Enddo
Sele msbal
Close table all

@ rowno,22 say padr('Transfer ACCOUNT MASTER (SUNDRY DEBTORS) ',50,'.') font 'Courier New',12
rowno=rowno+1

fd=datatransferpath + 'accmaster.DBF'
td=datdev + 'order.'+datext

SELE SELE(1) 
USE &datdev\SUPPORT.&datext ALIAS SUPP 
index on aliase + str(sno,3) + lcode to SUPP 
DELE ALL FOR ALIASE ='ORDER' AND SNO=7
PACK 


Sele a
Use &fd Alias fact
**Set Filter To accgroup='Party(Deb)'


Sele b
Use &datdev\order.&datext Alias mact
Sele fact
Go Top
Do While .Not. Eof()
	Last=Recno()
	
	Sele mact
	Append Blank
	do case
		case fact.accgroup='Company(cre)'
			mscode='D31'
		case fact.accgroup='Party(Deb)'
			mscode='C6'
		otherwise
			mscode='J12'
	endcase	
	Repl mact.scode With mscode
	Repl mact.rate With 'Y'
	Repl mact.ordno With ALLTRIM(STR(fact.Mastercode))
	Repl mact.parnam  With Upper(fact.Accname)
	Repl mact.paradd With Upper(fact.Address1)
	Repl mact.paradd1 With Upper(fact.address2)
	Repl mact.paradd2 With Upper(Alltrim(fact.Dist)+" "+Alltrim(fact.City))
	Repl mact.dsm With fact.pincode
	Repl mact.sthed With  'TIN No.'
	Repl mact.csthed With 'CST  No.'
	Repl mact.stno With fact.Bstno
    Repl mact.cstno With fact.cstno
	Repl mact.gstno With iif(len(allt(fact.gstin))<14,'',fact.gstin)
	Repl mact.fax2 With ALLTRIM(STR(fact.Mastercode))
	Repl mact.dlno With Alltrim(fact.dlno)  
	Repl mact.fax1 With Alltrim(fact.faxno)
	Repl mact.phone4 With Substr(Alltrim(fact.Phone1),1,10)
	Repl mact.phone1 With Substr(Alltrim(fact.Phone1),11,10)
	Repl mact.mailNam With Upper(fact.Accname)
	Repl mact.ref With 'Mr.'
	Repl mact.price With 'A'
	Repl mact.city With Upper(fact.City)
	Repl mact.Status With 'Y'
	*Repl mact.area With  Alltrim(STR(fact.Areaid))
	Repl mact.adhed With 'Discount'
	Repl mact.opning With val(fact.dramt)-val(fact.cramt)
	   && State    
        sele SUPP
        seek 'ORDER   ' + '  7' +  mact.ordno
        append blank
        repl aliase with 'ORDER   '
        repl type with 'F'
        repl lcode with mact.ordno
        repl sno with 7
        repl pcode with 15        
        repl remark with SUBS(REMARK,1,32)+"DEF"+IIF(SUBS(fact.gstin,1,2)='  ',MSTATECODE,SUBS(fact.gstin,1,2))+'                                           '            
	
    Sele fact
	Skip
Enddo
Close table all


*!*	proc  removenull
*!*	use &datatransferpath\Item_master
*!*		do rem_null

*!*	use &datatransferpath\stock
*!*		do rem_null
*!*	use &datatransferpath\account
*!*		do rem_null
*!*	use &datatransferpath\salesmaster
*!*		do rem_null
*!*	use &datatransferpath\saleschild
*!*	    do rem_null
*!*	use &datatransferpath\purchasemaster
*!*	    do rem_null
*!*	use &datatransferpath\purchasechild
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
