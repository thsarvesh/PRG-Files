**  PRG   : BSS, UK , Pharma Wholesale
** Dated  : 04/12/2024
** prg by : Rajesh Vk

Set Cpdialog Off
Close Data
Set Talk Off
Set Date To brit
Set Cent On
Set Dele On
Set Safe Off
If Type('FINALCP')='U'
	firstdate=Ctod('01/04/2024')
	lastdate =Ctod('31/03/2025')
	datdev='d:\transfer\'
	datext='dbf'
Endif
datatransferpath =Substr('D:\2025\Jan\Ezee\dbf\'+Space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='09'
sure='SURE'
removenull='No '
Clea
Clos Tabl All
@ 02,22 Say 'Piping EZee To Marg Erp9 '+Space(60) Font 'Arial Bold',14 Colo Rgb(20,255,255,119,136,153)
@ 04,22 Say 'EZee Data Path       :' Font 'Courier New' ,12  Get datatransferpath  Font 'Courier New' ,12
@ 05,22 Say 'EZee Extension       :' Font 'Courier New' ,12  Get datatransferext  Font 'Courier New' ,12
@ 06,22 Say 'F.Y.BEGIN Date       :' Font 'Courier New' ,12  Get old_5  Font 'Courier New' ,12
@ 07,22 Say 'F.Y.End   Date       :' Font 'Courier New' ,12  Get old_6   Font 'Courier New' ,12
@ 08,22 Say 'State Code           :' Font 'Courier New' ,12  Get mstatecode Font 'Courier New' ,12
@ 09,22 Say 'Removenull           :' Font 'Courier New' ,12  Get removenull Pict '@m No,Yes ' Font 'Courier New' ,12
@ 10,22 Say 'Type SURE            :' Font 'Courier New' ,12  Get sure Pict '@x!' Font 'Courier New' ,12

Read
Clear
Close Data
datatransferpath=Alltrim(datatransferpath)
datatransferpath=Alltrim(datatransferpath)
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
If Type('FINALCP')#'U'
	=starttransfer()
Endif
If removenull='Y'
	totfiles=Adir(fhandle,datatransferpath+'*.dbf')
	@ 02,22 Say 'Please wait removing null values'
	For cfile = 1 To totfiles
		Use datatransferpath+fhandle(cfile,1)
		If Reccount()>0
			Do rem_null
		Endif
	Next
Endif
Clear
rowno=5
@ 02,22 Say 'Please Wait Importing Ezee General Trading To Marg.....'+space(20) Font 'Arial Bold',14 Colo Rgb(20,255,255,119,136,153)
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
Close Table All
@rowno,22 Say Padr('Importing Product_Master ',50,'.') Font 'Courier New' ,12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\ProductStock Alias fstk
index on id to fstk
Sele Sele(1)
Use &datatransferpath\Products Alias fitm
Sele Sele(1)
Use &datdev\pro.&datext Alias mitm
Sele Sele(1)
Use &datdev\saletype.&datext Alias mpcm
Index On sgcode + sname + Str(igst,5,2) To mpcm
Sele fitm
Go Top
Scan
	@rowno-1,75 Say Str(Recno(),5)   Font 'Courier New',12
	sele fstk
	seek fitm.id
	Sele mitm
	Append Blank
	Repl mitm.Code With fitm.id
	Repl mitm.Name With Padr(fitm.id,10)
	Repl mitm.Product With Upper(fitm.ProductName)
	repl mitm.bookname with Upper(fitm.ProductName)
	Repl mitm.unit With 'PCS'
	Repl mitm.Pack With 0
	Repl mitm.billname With Upper(fitm.ProductName)
	Repl gcode With Padr(fitm.groupid,6)
	Repl opening With fstk.qty
	Repl balance With fstk.qty
	Repl b_a With opening
	Repl o_a With opening
	Repl minimum with fitm.minlevel
	repl maximum with fitm.maxlevel
	Repl mitm.taxl With 'T'
	Repl mitm.taxc With 'T'
	Repl mitm.Decimal With 'Y'
	Repl mitm.salfix With 'N'
	Repl mitm.halfsche With 'A'
	Repl mitm.qtrsche With 'Y'
	Repl mitm.Status With 'Y'
	repl mitm.prate with fitm.purchaseprice
	repl mitm.ratea with fitm.saleprice
	Repl mitm.purtax With fitm.cgst
	Repl mitm.saltax With fitm.sgst
	Repl mitm.cgst With fitm.cgst
	Repl mitm.igst With iif(fitm.igst#0,fitm.igst,fitm.cgst*2)
	&&HSN
	Sele mpcm
	Seek 'COMMCD' + Substr(fitm.productcode+Space(40),1,40) + Str(mitm.igst,5,2)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'COMMCD',;
			mpcm.scode  With 'H'+Padr(Recno(),6),;
			mpcm.sname  With fitm.productcode,;
			mpcm.parnam With fitm.productcode,;
			mpcm.tax With mitm.saltax,;
			mpcm.cgst With mitm.cgst,;
			mpcm.igst With mitm.igst,;
			mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode6 With mpcm.scode
Endscan
sele mpcm
repl all sname with parnam+str(igst,5,2)+'%' for sgcode='COMMCD'
Close Table All

@rowno,22 Say Padr('Importing Product Company ',50,'.') Font 'Courier New' ,12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\ProductGroup Alias fpcm
Sele Sele(1)
Use &datdev\saletype.&datext Alias mpcm
Sele fpcm
Go Top
Scan
	@rowno-1,75 Say Str(Recno(),5)   Font 'Courier New',12
	Sele mpcm
	Appen Blank
	Repl sgcode With "ZZZZZZ"
	Repl scode With Padr(fpcm.id,6)
	Repl sname With Upper(fpcm.productGroup)
	Repl parnam With Upper(fpcm.productGroup)
Endsc
Close Table All

@rowno,22 Say Padr('Importing Stock ',50,'.') Font 'Courier New' ,12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\ProductStock  Alias fsbal
Sele Sele(1)
Use &datdev\probat.&datext Alias msbal
Index On str(code,9)+batchno To msbal
Sele Sele(1)
Use &datdev\pro.&datext Alias mitm
Index On str(code,9) To mitm
Sele Sele(1)
Use &datdev\Support.&datext
Dele All For Type='#' And aliase='DAT/F-BT'
Pack
Sele fsbal
Go Top
Scan
	@rowno-1,75 Say Str(Recno(),5)   Font 'Courier New',12
	Sele mitm
	Seek str(fsbal.productid,9)
	Sele msbal
	Seek str(fsbal.productid,9)&&&+Left(str(mitm.mrp,9,2),12)
	If !Found()
		Append Blank
		repl msbal.date with firstdate
		Repl msbal.Code With mitm.Code
		Repl msbal.Name With mitm.Name
		Repl msbal.billname With mitm.billname
		Repl msbal.Product With mitm.Product
		Repl msbal.packing With mitm.packing
		Repl msbal.Decimal With 'Y'
		Repl lprate With mitm.lprate
		Repl msbal.prate With mitm.prate
		Repl msbal.ratea With mitm.ratea
		Repl msbal.mrp With mitm.mrp
		Repl msbal.misc1 With mitm.gcode
		Repl msbal.opening With fsbal.qty
		Repl msbal.balance With fsbal.qty
		Repl msbal.o_a With fsbal.qty
		Repl msbal.b_a With fsbal.qty
		Repl msbal.supcode With ''
		Repl msbal.supinvo With ''
	Else
		Repl msbal.opening With msbal.opening +fsbal.qty,;
			msbal.balance With msbal.balance +fsbal.qty,;
			msbal.o_a With msbal.o_a +fsbal.qty,;
			msbal.b_a With msbal.b_a +fsbal.qty
	Endif

Endscan
Close Table All
@rowno,22 Say Padr('Importing Ledger Master ',50,'.') Font 'Courier New' ,12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\tblaccount Alias fact

Sele Sele(1)
Use &datatransferpath\tblAccountDues Alias fbal
index on accountid to fbal

Sele Sele(1)
Use &datdev\Order.&datext Alias mact
Sele Sele(1)
Use &datdev\Support.&datext Alias Support
Sele fact
Scan 
store 0 to cbal
	@rowno-1,75 Say Str(Recno(),5)   Font 'Courier New',12
	Sele mact
	Appen Blank
	do case
		case fact.ttype='BUYER  '
			repl mact.scode with 'C6'
		case fact.ttype='SUPPLIER  '
			repl mact.scode with 'D31'
		otherwise
			repl mact.scode with 'J12'
	endcase
	Repl mact.rate With 'Y'
	Repl mact.ordno With alltri(str(fact.id))
	Repl mact.parnam  With fact.accountname
	Repl mact.mailnam With fact.accountname
	Repl mact.paradd With fact.address1
	Repl mact.paradd1 With fact.address2
	repl mact.city with fact.city
	repl mact.confir with fact.cperson
	Repl mact.dsm With fact.pin
	repl mact.phone1 with fact.mobile
	repl mact.phone4 with fact.mobile
	repl mact.gstno with fact.tinno
	Repl mact.gsthed With  'GSTIN'
	Repl mact.sthed With  'TIN No.'
	Repl mact.csthed With 'CST No.'
	Repl mact.ref With 'Mr.'
	Repl mact.price With 'A'
	Repl mact.Status With 'Y'
	***STATE
	Sele Support
*!*		if fact.disc_1#0
*!*			appe blan
*!*			repl aliase with 'FODDETAI'
*!*			repl type with 'F'
*!*			repl lcode with mact.ordno
*!*			repl remark with space(57)+str(0,4,1)+str(0,4,1)+str(0,4,1)
*!*		endif
	
	Appe Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl pcode With 15
	Repl sno With 7
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',mstatecode ,Subs(mact.gstno,1,2))

	Appe Blank
	Repl aliase With 'LBTDETAI'
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl Heading With Iif(Substr(mact.gstno,1,2)=mstatecode Or Empty(mact.gstno),'L            LN          ','L            ON          ')
	
	sele fbal
	seek fact.id
	sum amt to cbal while accountid=fact.id
	
	sele mact
	repl opning with cbal
Endscan
Close Tables All
retu

@rowno,22 Say Padr('Importing Creditors Master ',50,'.') Font 'Courier New' ,12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\credind Alias fact

Sele Sele(1)
Use &datdev\Order.&datext Alias mact
Sele Sele(1)
Use &datdev\Support.&datext Alias Support
Sele fact
Scan 
	@rowno-1,75 Say Str(Recno(),5)   Font 'Courier New',12
	mgrp='D31'
	Sele mact
	Appen Blank
	Repl mact.scode With mgrp
	Repl mact.rate With 'Y'
	Repl mact.ordno With padr(fact.glcode,6)
	Repl mact.fax2 With Alltri(fact.glcode)
	Repl mact.parnam  With fact.gldesc
	Repl mact.mailnam With fact.gldesc
	Repl mact.paradd With fact.add1
	Repl mact.paradd1 With fact.add2
	Repl mact.paradd2 With fact.add3
	Repl mact.dsm With allt(chrtran(fact.pin,' ',''))
	*Repl mact.stno With fact.vatno
	*Repl itno With fact.panno
	repl mact.disc1 with fact.disc_1
	repl mact.dlno with fact.dlreg
	Repl mact.gstno With fact.streg
	Repl mact.gsthed With  'GSTIN'
	*Repl area With Padr(int(fact.areacode),6)
	*Repl phone1 With fact.phone
	*Repl phone4 With fact.phone
	Repl mact.sthed With  'TIN No.'
	Repl mact.csthed With 'CST No.'
	Repl mact.ref With 'Mr.'
	Repl mact.price With 'A'
	Repl mact.Status With 'Y'
	repl mact.opning with -ABS(fact.yob+fact.act1+fact.act2+fact.act3+fact.act4+fact.act5+fact.act6+fact.act7+fact.act8+fact.act9+fact.act10+fact.act11+fact.act12)
	repl mact.balance with opning

	*!*		repl mact.disc1 with fact.disc_1
	***Discount
	Sele Support
	if fact.disc_1#0
		appe blan
		repl aliase with 'FODDETAI'
		repl type with 'F'
		repl lcode with mact.ordno
		repl remark with space(57)+str(0,4,1)+str(0,4,1)+str(0,4,1)
	endif
	&& state 
	Appe Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl pcode With 15
	Repl sno With 7
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',mstatecode ,Subs(mact.gstno,1,2))

	Appe Blank
	Repl aliase With 'LBTDETAI'
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl Heading With Iif(Substr(mact.gstno,1,2)=mstatecode Or Empty(mact.gstno),'L            LN          ','L            ON          ')
Endscan
Close Tables All
return


@rowno,22 Say padr('Importing Debtors Outstanding ',50,'.') Font 'Courier New' ,12
rowno=rowno+1
sele sele(1)
use &datatransferpath\retailer alia fout
set filt to amtrec=0
*select * from &datatransferpath\expense where debit#0 into curs fout
*use &datatransferpath\expense alia fout

*!*	sele sele(1)
*!*	select * from &datatransferpath\expense where Credit#0 into curs frec
*!*	index on str(expcode)+str(billno) to frec
sele sele(1)
use &datdev\order.&datext alia mact
set filt to scode='C6'
index on ordno to mact
go top
sele sele(1)
use &datdev\pendings.&datext alia mpend
sele sele(1)
use &datdev\slipno.&datext alia mslip
go top
repl voucher with 100,svoucher with 107
svou=svoucher+3
vou=voucher+6
sele fout
scan 
	@rowno-1,75 Say Str(Recno(),5)   Font 'Courier New',12
	sele mact
	=seek(padr(int(fout.retlcode),6),'mact')
	if found()
		Sele mpend
		Appe Blank
		Replace mpend.ord       With   mact.ordno
		Replace mpend.ddate     With   fout.date
		Replace mpend.invtype   With   "O"
		Replace mpend.vcn       With   padr(int(fout.billno),12)
		Replace mpend.voucher   With   vou
		Replace mpend.Final     With   fout.amount
		Replace mpend.Balance    With  fout.amount
		Replace mpend.duedate   With   fout.date
		Replace duedays         with  0
		Replace mpend.acgroup   With   mact.scode
		Replace mpend.svoucher  With   svou
		Replace mpend.Name      With   mact.parnam
		Replace mpend.area 		with 	mact.area
		vou=vou+6
		svou=svou+3
	endif
endscan
sele mact
scan 
	sele mpend
	sum balance TO wbal for mpend.ord=mact.ordno
	sele mact 
	repl opning with wbal
	repl balance with wbal
endscan
*Enddo
Close Table All




Proc rem_null
	a = Afields(arr)
	For imarg = 1 To a
		mfldname = arr(imarg, 1)
		Do Case
			Case Inlist(arr(imarg,2), "C","V","M")
				Replace All &mfldname With '' For Isnull(&mfldname)
			Case Inlist(arr(imarg,2), "B","N","I","F","Y")
				Replace All &mfldname With 0 For Isnull(&mfldname)
			Case Inlist(arr(imarg,2), "D","T","M")
				Replace All &mfldname With Ctod('') For Isnull(&mfldname)
		Endcase
	Endfor

	*!*	EOF :

Function DaysInMonth(dDate)
	Local dMonthPlus1
	Try
		dMonthPlus1 = Gomonth(Date(Year(dDate),Month(dDate),1),1)
		Return dMonthPlus1 - Date(Year(dDate),Month(dDate),1)
	Catch
		er=0
	Endtry

Endfunc