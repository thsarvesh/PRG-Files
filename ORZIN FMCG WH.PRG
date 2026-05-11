** Wholesale fmcg 
** Code By VK Rajesh dt. 16/03/2026
Clea
Close Tabl All
Set Talk Off
Set Date To brit
Set Cent On
Set Dele On
Set Safe Off
Set Cpdia Off
sure = Space(4)

If Type('FINALCP')='U'
	firstdate=Ctod('01/04/2025')
	lastdate =Ctod('31/03/2026')
	datdev='d:\transfer\'
	datext='dbf'
Endif
old_3= 'Yes'
old_4= 'Yes'
old_5= firstdate
old_6= lastdate
datatransferpath=Substr('D:\2025\March\Oriz\GAZALIYAGST\skyway\'+Space(60),1,60)
datatransferext ='dbf'
mstatecode='32'
removenull='No '
memo2chr='No '
@ 05,22 Say 'Oriz Software To Marg Erp 9+'+Space(60) Font 'Arial Bold',14 Colo Rgb(20,255,255,119,136,153)
@ 07,22 Say 'Oriz Data Path         :'Font 'Courier New',14 Get datatransferpath Font 'Courier New',14
@ 08,22 Say 'Oriz  Data Ext.        :'Font 'Courier New',14 Get datatransferext Font 'Courier New',14
@ 09,22 Say 'With Outstanding       :'Font 'Courier New',14 Get old_3 Pict '@^ YES,NO ' Font 'Courier New',12
@ 10,22 Say 'Only Master            :'Font 'Courier New',14 Get old_4 Pict '@^ YES,NO   ' Font 'Courier New',12
@ 11,22 Say 'F.Y.Begin From         :'Font 'Courier New',14 Get old_5 Font 'Courier New',14
@ 12,22 Say 'F.Y.Ended To           :'Font 'Courier New',14 Get old_6 Font 'Courier New',14
@ 13,22 Say 'Your State Code        :'Font 'Courier New',14 Get mstatecode Font 'Courier New',14
@ 14,22 Say 'Remove null Value      :'Font 'Courier New',14 Get removenull Pict '@^ Yes,No   ' Font 'Courier New',12
@ 15,22 Say 'Type <Sure>            :'Font 'Courier New',14 Get sure Pict '@x!' Font 'Courier New',14
Read
datatransferpath=Alltrim(datatransferpath)
datatransferext=Alltr(datatransferext)
datdev=Alltrim(datdev)
datext=Alltrim(datext)
If Lastkey()=27 &&.or. Sure#'SURE'
	Return
Endif
Clear
If Type('FINALCP')#'U'
	=starttransfer()
Endif
If removenull='Y'
	@ 08,22 Say 'Removing Null Values........     Please Wait..........' Font 'Arial Bold',14 Colo Rgb(20,255,255,119,136,153)
	totfiles=Adir(fhandle,datatransferpath+'*.dbf')
	For cfile = 1 To totfiles
		Use datatransferpath+fhandle(cfile,1)
		If Reccount()>0
			Do rem_null
		Endif
	Next
Endi
Clea
If memo2chr='Y'
	@07,10 Say 'Converting Memo to Char..Please Wait......' Font 'Arial Bold',14 Colo Rgb(20,255,255,119,136,153)
	totfiles=Adir(fhandle,datatransferpath+'*.dbf')
	For cfile = 1 To totfiles
		Use datatransferpath+fhandle(cfile,1)
		If Reccount()>0
			Do memo2char
		Endif
	Next
Endif
Clea
@ 02,22 Say 'Please Wait converting Oriz Software FMCG Data Into Marg' Font 'Arial Bold',14 Colo Rgb(20,255,255,119,136,153)
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
DELE ALL FOR aliasE ='ORDER   ' AND Type ='F' AND PCODE=15 AND SNO=7
Pack
Close Data
rowno=5
@rowno,22 Say Padr('Importing Item Master',50,'.') Font 'Courier New',14
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\company Alia fcomp
index on code to fcomp
Sele Sele(1)
Use &datatransferpath\category  Alia fcat
Index On code To fcat
Sele Sele(1)
Use &datatransferpath\subcategory Alia subcat
index on code to subcat
Sele Sele(1)
Use &datatransferpath\item Alia fitm
Sele Sele(1)
Use &datdev\pro.&datext Alia mitm
Inde On Name To mitm
Sele Sele(1)
Use &datdev\saletype.&datext Alia mpcm
Index On sgcode + sname + Str(igst,5,2) To mpcm
Sele fitm
Pack
Go Top
Do While !Eof()
	Sele mitm
	Append Blank
	Repl Code With recno()
	Repl Name With fitm.code
	Repl Product With fitm.name
	Repl packing With fitm.size
	Repl billname With Product+packing
	*   repl pack with fitm.qtybox
	Repl unit With 'PCS'
	*Repl rackno With fitm.item_eancode
	Repl taxl With 'T'
	Repl taxc With 'T'
	Repl Decimal With 'Y'
	Repl salfix With 'N'
	Repl halfsche With 'A'
	Repl qtrsche With 'Y'
	Repl Status With 'Y'
	Repl prate With fitm.prate
	Repl ratea With fitm.wsrate
	repl rateb with fitm.retrate
	repl lprate with fitm.cost
	Repl mrp With fitm.mrprate
	Repl cgst With fitm.cgst
	Repl saltax With fitm.cgst
	Repl igst With  cgst+saltax
	repl opening with fitm.clstock
	repl o_a with opening
	repl balance with opening
	repl b_a with opening
	*****Hsn Transfer******
	Sele mpcm
	Seek 'COMMCD' + Substr(fitm.hsncode+Space(40),1,40) + Str(mitm.igst,5,2)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'COMMCD',;
			mpcm.scode  With 'H'+Alltrim(Str(Recno())),;
			mpcm.sname  With Padr(fitm.hsncode,15),;
			mpcm.parnam With fitm.hsncode,;
			mpcm.tax With mitm.saltax,;
			mpcm.cgst With mitm.cgst,;
			mpcm.igst With mitm.igst,;
			mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode6 With mpcm.scode
	
	*****Category Transfer******
	sele fcat
	seek fitm.category
	if found()
		Sele mpcm
		Seek 'CATEGO' + Substr(fcat.name+Space(40),1,40)
		If !Found()
			Append Blank
			Repl mpcm.sgcode With 'CATEGO',;
				mpcm.scode  With 'C'+Alltrim(Str(Recno())),;
				mpcm.sname  With Padr(fcat.name,15),;
				mpcm.parnam With fcat.name
		Endif
		Repl mitm.gcode5 With mpcm.scode	
	endif
	***** (Sub - Category ) Salt Transfer******
	sele subcat
	seek fitm.subcategor
	if found()
		Sele mpcm
		Seek 'SALT  ' + Substr(subcat.name+Space(40),1,40)
		If !Found()
			Append Blank
			Repl mpcm.sgcode With 'SALT  ',;
				mpcm.scode  With 'S'+Alltrim(Str(Recno())),;
				mpcm.sname  With Padr(subcat.name,15),;
				mpcm.parnam With subcat.name
		Endif
		Repl mitm.gcode3 With mpcm.scode	
	endif	
	
	
	***** Company Transfer******
	sele fcomp
	seek fitm.company
	if found()
		Sele mpcm
		Seek 'ZZZZZZ' + Substr(fcomp.name+Space(40),1,40)
		If !Found()
			Append Blank
			Repl mpcm.sgcode With 'ZZZZZZ',;
				mpcm.scode  With 'Z'+Alltrim(Str(Recno())),;
				mpcm.sname  With Padr(fcomp.name,15),;
				mpcm.parnam With fcomp.name
		Endif
		Repl mitm.gcode With mpcm.scode	
	endif
	Sele fitm
	Skip
Enddo
Sele mpcm
Repl All sname With parnam+parnam+Str(igst,5,2)+'%' For sgcode='COMMCD'
Close Table All


*!*	@rowno,22 Say Padr('Importing Customer retail Master ',50,'.') Font 'Courier New',14
*!*	rowno=rowno+1
*!*	Sele Sele(1)
*!*	Use &datatransferpath\tbl_Customer Alia fcust

*!*	Sele Sele(1)
*!*	Use &datdev\sborder.&datext Alias mcust
*!*	Index On scode To mcust
*!*	Sele fcust
*!*	Scan &&for customer_supplier=2
*!*		Sele mcust
*!*		Append Blank
*!*		Repl scode With '!@#POS'
*!*		Repl subcode With fcust.customer_mobile
*!*		Repl parnam With fcust.Customer_name
*!*		Repl paradd With fcust.Customer_address1
*!*		Repl couponno With fcust.customer_mobile

*!*	Endsc
*!*	Close Tabl All

@rowno,22 Say PADR('Importing Account(Customer) Master ',50,'.') Font 'Courier New',14
rowno=rowno+1

Sele Sele(1)
Use &datdev\Order.&datext Alia mact
Sele Sele(1)
Use &datatransferpath\customer Alia fact

Sele Sele(1)
Use &datatransferpath\Accountm Alia fbal
index on accode to fbal
Sele Sele(1)
Use &datdev\Support.&datext Alias Support
Index On aliase + Str(sno,3) + lcode To Support
Sele Sele(1)
Use &datdev\saletype.&datext Alia mpcm
Index On sgcode + sname  To mpcm

Sele fact
Go Top
Do While .Not. Eof()
	sele fbal
	seek fact.code
	Sele mact
	Append Blank
	Repl scode With 'C6'
	Repl rate With 'Y'
	Repl ordno With Padr(fact.code,6)
	Repl parnam  With fact.name
	Repl paradd With fact.addr1
	repl paradd1 with fact.addr2
	repl paradd2 with fact.addr3
	repl City with fact.city
	repl phone1 with fact.phone
	repl phone2 with ''
	Repl phone3 With ' '
	Repl phone4 With iif(!empty(fact.mobile),fact.mobile,fact.phone)
	repl duedays with fact.crdlmtdays 
	*Repl fax2 With fact.party_id
	Repl sthed With  'TIN No.'
	Repl csthed With 'CST  No.'
	Repl Gsthed With 'GSTIN'
	repl gstno with fact.tin
	*repl cstno with fact.vat_tin
	*repl itno with fact.pan_no
	Repl stno With ' '
	Repl dlno With ' '
	Repl fax2 With ' '
	*Repl Confir With fact.supplier_contactperson
	Repl area With ' '
	Repl mailNam With fact.name
	* repl dsm with fact.pin_no
	Repl ref With 'Mr.'
	Repl price With 'A'
	Repl Status With 'Y'
	Repl adhed With 'Discount'
	Repl opning With fbal.amount
	repl balance with opning

	**  AREA UPDATE
	sele mpcm
	seek 'AREA  '+left(fact.CITY+space(40),40)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'AREA  ',;
			mpcm.scode  With 'A'+Alltrim(Str(Recno())),;
			mpcm.sname  With Padr(fact.city,15),;
			mpcm.parnam With fact.city
	Endif
	Repl mact.area With mpcm.scode	
	**  ROUT UPDATE
	sele mpcm
	seek 'ROUT  '+left(fact.CITY+space(40),40)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'ROUT  ',;
			mpcm.scode  With 'R'+Alltrim(Str(Recno())),;
			mpcm.sname  With Padr(fact.route,15),;
			mpcm.parnam With fact.route
	Endif
	Repl mact.rout With mpcm.scode	

	****Ledger Difference
	Sele Support
	Appe Blank
	Repl Type With "#",aliase With "DAT/F-LD",lcode With mact->ordno,Value With 0

	&& Updating State
	SELE SUPPORT
	Appe Blank
	Repl aliasE With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl pcode With 15
	Repl sno With 7
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',mstatecode ,Subs(mact.gstno,1,2))
	
	Appe Blank
	Repl aliasE With 'LBTDETAI'
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl heading With iif(substr(mact.gstno,1,2)=mstatecode or empty(mact.gstno),'L            LN          ','L            ON          ')


	Sele fact
	Skip
Enddo
Close Table All

@rowno,22 Say PADR('Importing Account(Supplier) Master ',50,'.') Font 'Courier New',14
rowno=rowno+1
Sele Sele(1)
Use &datdev\Order.&datext Alia mact
Sele Sele(1)
Use &datatransferpath\supplier Alia fact
Sele Sele(1)
Use &datatransferpath\Accountm Alia fbal
index on accode to fbal
Sele Sele(1)
Use &datdev\Support.&datext Alias Support
Index On aliase + Str(sno,3) + lcode To Support
Sele Sele(1)
Use &datdev\saletype.&datext Alia mpcm
Index On sgcode + sname  To mpcm

Sele fact
Go Top
Do While .Not. Eof()
	sele fbal
	seek fact.code
	Sele mact
	Append Blank
	Repl scode With 'D31'
	Repl rate With 'Y'
	Repl ordno With Padr(fact.code,6)
	Repl parnam  With fact.name
	Repl paradd With fact.addr1
	repl paradd1 with fact.addr2
	repl paradd2 with fact.addr3
	repl City with fact.city
	repl phone1 with fact.phone
	repl phone2 with ''
	Repl phone3 With ' '
	Repl phone4 With iif(!empty(fact.mobile),fact.mobile,fact.phone)
	Repl sthed With  'TIN No.'
	Repl csthed With 'CST  No.'
	Repl Gsthed With 'GSTIN'
	repl gstno with fact.tin
	Repl stno With ' '
	Repl dlno With ' '
	Repl fax2 With ' '
	Repl area With ' '
	Repl mailNam With fact.name
	Repl ref With 'Mr.'
	Repl price With 'A'
	Repl Status With 'Y'
	Repl adhed With 'Discount'
	Repl opning With fbal.amount
	repl balance with opning
	**  AREA UPDATE
	sele mpcm
	seek 'AREA  '+left(fact.CITY+space(40),40)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'AREA  ',;
			mpcm.scode  With 'A'+Alltrim(Str(Recno())),;
			mpcm.sname  With Padr(fact.city,15),;
			mpcm.parnam With fact.city
	Endif
	Repl mact.area With mpcm.scode	
	**  ROUT UPDATE
	sele mpcm
	seek 'ROUT  '+left(fact.CITY+space(40),40)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'ROUT  ',;
			mpcm.scode  With 'R'+Alltrim(Str(Recno())),;
			mpcm.sname  With Padr(fact.route,15),;
			mpcm.parnam With fact.route
	Endif
	Repl mact.rout With mpcm.scode	

	****Ledger Difference
	Sele Support
	Appe Blank
	Repl Type With "#",aliase With "DAT/F-LD",lcode With mact->ordno,Value With 0

	&& Updating State
	SELE SUPPORT
	Appe Blank
	Repl aliasE With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl pcode With 15
	Repl sno With 7
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',mstatecode ,Subs(mact.gstno,1,2))
	
	Appe Blank
	Repl aliasE With 'LBTDETAI'
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl heading With iif(substr(mact.gstno,1,2)=mstatecode or empty(mact.gstno),'L            LN          ','L            ON          ')


	Sele fact
	Skip
Enddo
Close Table All
@rowno,22 Say PADR('Importing MRP Master ',50,'.') Font 'Courier New',14
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\item Alia fsbal
Sele Sele(1)
Use &datdev\pro.&datext Alia mitm
Index On Name To mitm
Sele Sele(1)
Use &datdev\probat.&datext Alia msbal
Index On Name + batchno To msbal

r=0
Sele fsbal
Go Top
Scan

	Sele mitm
	Seek Subs(fsbal.code+Space(10),1,10)
	Sele msbal
	Seek Subs(fsbal.code,1,10)+Str(fsbal.mrprate,9,2)
	If !Foun()
		Appe Blan
		Repl Code With mitm->Code
		Repl Name With mitm->Name
		Repl billname With mitm->billname
		Repl Product With mitm->Product
		Repl Pack With mitm->Pack
		Repl packing With mitm->packing
		Repl unit2 With mitm->unit2
		Repl unit With mitm->unit
		Repl Decimal With 'Y'
		Repl batchno With Str(fsbal.mrprate,9,2)
		Repl prate With fsbal.prate
		Repl ratea With fsbal.wsrate
		repl rateb with fsbal.retrate
		repl lprate with fsbal.cost
		Repl mrp With fsbal.mrprate
		Repl supcode With ' '
		Repl supinvo With ' '
		Repl supdat With  Ctod('')
		Repl misc1 With mitm->gcode
		Repl opening With fsbal.clstock
		Repl balance With fsbal.clstock
		Repl o_a With fsbal.clstock
		Repl b_a With fsbal.clstock
	Else
		Repl opening With opening+fsbal.clstock
		Repl balance With balance+fsbal.clstock
		Repl o_a With o_a+fsbal.clstock
		Repl b_a With b_a+fsbal.clstock
		Repl Exp With ctod('')
	Endi
Endsc
Close Table All

Proc rem_null
	a = Afields(arr)
	For imarg = 1 To a
		mfldname = arr(imarg, 1)
		Do Case
			Case Inlist(arr(imarg,2), "C","V","M")
				Replace All &mfldname With '' For Isnull(&mfldname)
			Case Inlist(arr(imarg,2), "B","N","I","F","Y","M")
				Replace All &mfldname With 0 For Isnull(&mfldname)
			Case Inlist(arr(imarg,2), "D","T","M")
				Replace All &mfldname With Ctod('') For Isnull(&mfldname)
		Endcase
	Endfor
Proc  memo2char
	tbl=Alia()
	a = Afields(arr)
	For i = 1 To a
		mfldname = arr(i, 1)
		Do Case
			Case Inlist(arr(i,2),"M")
				Alter Table &tbl Alter Column &mfldname c(254)
				Repl All &mfldname With Chrtran(&mfldname,Chr(0),'')
		Endcase
	Endf
	Clos Table All
