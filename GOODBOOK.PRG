*!* Prg By Rajesh 
*!* 18/11/2024	
*!* your commands
clea
clos tabl all
set talk off
set date to brit
set cent on
set dele on
set safe off

************************************************************************************************
if type('FINALCP')='U'
	firstdate=ctod('01/04/2018')
	lastdate= ctod('31/03/2025')
	datdev='e:\umeshmarg\whol'
	datext= 'DBF'
endi
datatransferpath=Subs('D:\Umesh_2425\November\luisc\LUISCO\'+Space(100),1,100)
datatransferext='DBF'
datatransfersql='No '
datatransfermdb='No '
old_3 = 'YES'
old_4 = 'Yes'
old_5 = firstdate
old_6 = lastdate
*softtype='Wholesale'
old_7 = 'G'
old_8 = '#'
mstatecode='30'
sure='SURE'
mrgmdbfile=Space(100)
mrgmdbpwd=Space(30)
rowno=2
removenull='No '
@ rowno,22 Say space(30)+'Goa Software To Marg'+space(30) Font 'Arial',14 Style 'B' Colo rgb(0,0,0,140,240,200)
rowno=rowno+1
@ 05,22 Say 'Data Path Master      :' Font 'Courier New',12  Get datatransferpath  Font 'Courier New',12
@ 06,22 Say 'Extension             :' Font 'Courier New',12  Get datatransferext  Font 'Courier New',12
@ 07,22 Say 'F.Y.BEGIN Date        :' Font 'Courier New',12  Get old_5  Font 'Courier New',12
@ 08,22 Say 'F.Y.End   Date        :' Font 'Courier New',12  Get old_6   Font 'Courier New',12
@ 09,22 Say 'State Code            :' Font 'Courier New',12  Get mstatecode Font 'Courier New',12
@ 10,22 Say  'Remove Null Values    :' Font 'Courier New',12 Get removenull Pict '@^ YES,NO '  Font 'Courier New',12
@ 11.5,22 Say 'Type SURE             :' Font 'Courier New',12  Get sure Pict '@x!' Font 'Courier New',12
Read
if Type('FINALCP')#'U'
	=starttransfer()
endif
Clear
Close TABLE ALL
datatransferpath=Alltrim(datatransferpath)
If !Right(datatransferpath,1)='\'
	datatransferpath=Alltrim(datatransferpath)+'\'
Endif

datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datdev= Alltrim (datdev)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif

If removenull='Y'
	@ 08,15 Say 'Removing Null Values........     Please Wait..........' Font 'Tahoma',18
	totfiles=Adir(fhandle,datatransferpath+'*.dbf')
	For cfile = 1 To totfiles
		Use datatransferpath+fhandle(cfile,1)
		If Reccount()>0
			Do rem_null
		Endif
	Next
Endi
Clea
Clear
rowno=5
@ rowno,22 Say 'Please Wait Importing Master Data from Goa Software Data To Marg.....' Font 'Arial',14 Style 'B' Colo rgb(0,0,0,255,204,255)
rowno=rowno+2
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
zap
*!*	Use &datdev\histdis.o00
*!*	zap
*!*	DELE  &datdev\*.CDX

Close table all
Set Colo To

@ rowno,22 Say 'Item Master Importing .........................' Font 'Courier New',12 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\msizesetdetail alias fsize
	index on str(sizesetdetailid,12) to fsize
sele sele(1) 
	use &datatransferpath\mdutytable alias ftax
	index on dutytableid to ftax
sele sele(1) 
	use &datatransferpath\mdutytariff alias fhsn   
	index on dutytariffid to fhsn
sele sele(1) 
	use &datatransferpath\mitem alias fitm   
	repl all itemdescription with chrtran(itemdescription,chr(0),'')
	alter table fitm  alter column itemdescription c(50)
sele sele(1)
	use &datatransferpath\mitemcategory  alia fcat
	index on itemcategoryid to fcat
sele sele(1)
	use &datatransferpath\muom alia fuom
	index on uomid to fuom
sele sele(1)
	use &datatransferpath\mmodel  alia fmodel
	index on modelid to fmodel
sele sele(1)
	use &datatransferpath\mitembrand alia fbrand
	index on itembrandid to fbrand
sele sele(1)
use &datatransferpath\mitemgroup alia fgroup
	index on itemgroupid to fgroup
*!*	sele sele(1)
*!*	use &datatransferpath\fitemclass alia fstk

sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\probat.&datext alias msbal

sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	Inde On sgcode+sname+Str(igst,5,2)To mpcm
Sele fitm
Go Top
scan
	sele fsize
	seek str(fitm.sizesetdetailid,12)
	sele fuom
	seek fitm.stockuomid
	Sele mitm
	Append Blank
	Repl mitm.Code With recno()
	Repl mitm.Name With allt(fitm.itemcode)
	Repl mitm.Product With ALLT(fitm.itemname) 
	repl mitm.rackno with allt(fitm.cataloguenumber)
	Repl mitm.packing With allt(fsize.sizevalue) &&fuom.uomname
	Repl mitm.billname With ALLT(Fitm.itemname)
	repl mitm.bookname with allt(fitm.itemname)
	Repl mitm.unit With fuom.uomcode
	repl mitm.upccode with padr(fitm.itemid,15)
	*Repl mitm.gcode With allt(fitm.company_code)
	*Repl mitm.gcode5 With left(allt(fitm.sub_section_code),3)+right(allt(fitm.sub_section_code),3)
	Repl mitm.taxc With 'T'
	Repl mitm.Decimal With 'Y'
	Repl mitm.salfix With 'N'
	*Repl mitm.purdis with fitm.purdisc
	*repl mitm.fixdis with fitm.saledisc
	*repl mitm.deal with val(subs(fitm.offer,1,at('+',fitm.offer)-1))
	*repl mitm.free with val(subs(fitm.offer,at('+',fitm.offer)+1,3))
	*Repl mitm.maximum With fitm.max_stk
	*Repl mitm.formulano With Substr(formulano,1,25)+Str(fitm.discount,5,2)+Substr(formulano,31,100)
	Repl mitm.halfsche With 'A'
	Repl mitm.qtrsche With 'Y'
	Repl mitm.Status With 'Y'
	repl mitm.lprate with fitm.purchasecostnlc
	repl mitm.prate with fitm.purchaserate
	repl mitm.ratea with fitm.salesrate
*!*		repl mitm.opening with fitm.quantity_in_stock
*!*		repl mitm.o_a with fitm.quantity_in_stock
*!*		repl mitm.balance with fitm.quantity_in_stock
*!*		repl mitm.b_a with fitm.quantity_in_stock
	sele ftax
	seek fitm.gsttableid
	Repl mitm.saltax With val(ftax.dutytablename)/2
	Repl mitm.cgst With val(ftax.dutytablename)/2
	Repl mitm.igst With val(ftax.dutytablename)
	&&&& Hsn transfer
	sele fhsn   
	seek fitm.gsttariffid

	Sele mpcm
	Seek 'COMMCD'+Subst(allt(padr(fhsn.dutytariffcode,10))+Space(40),1,40)+Str(mitm.igst,5,2)
	If !Foun()
		Appen Blank
		Repl mpcm.sgcode With 'COMMCD'
		Repl mpcm.scode With 'H'+Alltri(Str(recno()))
		Repl mpcm.sname With Subst(allt(fhsn.dutytariffcode)+Space(15),1,15) 
		Repl mpcm.parnam With Subst(allt(fhsn.dutytariffcode),1,15)
		Repl mpcm.tax With mitm.saltax
		Repl mpcm.cgst With mitm.cgst
		Repl mpcm.igst With mitm.igst
		Repl mpcm.tcode With 'No'
	Endi
	Repl mitm.gcode6 With mpcm.scode
	&&& Category
	sele fcat
	seek fitm.categoryid
	if found()
		Sele mpcm
		Seek 'CATEGO'+Subst(allt(fcat.itemcategoryname)+Space(40),1,40)
		If !Foun()
			Appen Blank
			Repl mpcm.sgcode With 'CATEGO'
			Repl mpcm.scode With 'C'+Alltri(Str(recno()))
			Repl mpcm.sname With allt(fcat.itemcategoryname)
			Repl mpcm.parnam With Subst(allt(fcat.itemcategoryname),1,15)
			Repl mpcm.tcode With 'No'
		Endi
		Repl mitm.gcode5 With mpcm.scode
	endif
	&&& Model
	sele fmodel
	seek fitm.modelid
	if found()
		Sele mpcm
		Seek 'SALT  '+Subst(allt(fmodel.Modelname)+Space(40),1,40)
		If !Foun()
			Appen Blank
			Repl mpcm.sgcode With 'SALT  '
			Repl mpcm.scode With 'S'+Alltri(Str(recno()))
			Repl mpcm.sname With allt(fmodel.Modelname)
			Repl mpcm.parnam With Subst(allt(fmodel.Modelname),1,15)
			Repl mpcm.tcode With 'No'
		Endi
		Repl mitm.gcode3 With mpcm.scode
	endif
	&&& Company/Brand
	sele fbrand
	seek fitm.itembrandid
	if found()
		Sele mpcm
		Seek 'ZZZZZZ'+Subst(allt(fbrand.itembrandname)+Space(40),1,40)
		If !Foun()
			Appen Blank
			Repl mpcm.sgcode With 'ZZZZZZ'
			Repl mpcm.scode With 'Z'+Alltri(Str(recno()))
			Repl mpcm.sname With allt(fbrand.itembrandname)
			Repl mpcm.parnam With Subst(allt(fbrand.itembrandname),1,15)
			Repl mpcm.tcode With 'No'
		Endi
		Repl mitm.gcode With mpcm.scode
	endif
endscan
close table all

@rowno,22 Say 'Store Transfer ................................' Font 'Courier New',12
rowno=rowno+1
sele sele(1) 
use &datatransferpath\mstore alias fstore
sele sele(1)
Use &datdev\saletype.&datext Alias mstore
sele fstore
N=65
scan for storecode#'NONE      '
	sele mstore
	appe blan
	repl mstore.upccode with padr(fstore.storeid,20)
	repl mstore.code with 'Y'
	repl mstore.sgcode With 'GODWON'
	repl mstore.scode With chr(N)
	repl mstore.sname With allt(fstore.StoreName)
	repl mstore.parnam With allt(fstore.StoreName)
	repl mstore.tcode With 'N'
	n=n+1
endsc
close table all

@ rowno,22 Say 'Stock Transfer ................................' Font 'Courier New',12
rowno=rowno+1
sele sele(1) 
use &datatransferpath\tstockposition alias fsbal
sele sele(1) 
use &datatransferpath\mpricelist alias frate
index on str(ouid,12)+str(itemid,12) to frate
sele sele(1)
Use &datdev\saletype.&datext Alias mstore
set filt to sgcode='GODWON'
index on upccode  to mstore
sele sele(1)
Use &datdev\probat.&datext Alias msbal
index on str(code,9)+batchno to msbal
sele sele(1)
Use &datdev\pro.&datext Alias mitm
index on left(upccode,20) to mitm
sele fsbal
scan for seek(padr(fsbal.storeid,20),'mstore') and seek(padr(fsbal.itemid,20),'mitm')
	sele frate
	seek str(fsbal.ouid,12)+str(fsbal.itemid,12)
	sele msbal
	seek(str(mitm.code,9)+left(str(frate.mrprate,9,2)+space(12),12))
	if !found()
		appen blank
		repl date With Date()
		repl code With mitm.Code
		repl name With mitm.Name
		repl billname With mitm.billname
		repl product With mitm.Product
		repl packing With mitm.packing
		repl pack With mitm.Pack
		repl unit With mitm.unit
		repl decimal with 'Y'
		repl opening with fsbal.quantity
		repl balance with opening
		wstore=allt(mstore.scode)
		repl o_&wstore with fsbal.quantity   &&&UMESH OPEN IT
		repl b_&wstore with fsbal.quantity
		repl misc1 with mitm.gcode
		repl batchno with str(frate.mrprate,9,2) 
		repl lprate with frate.itemcost		
		repl prate with frate.basicpurchaserate
		repl ratea with frate.basicsalesrate
		repl mrp with frate.mrprate
	else
		wstore=allt(mstore.scode)
		repl o_&wstore with o_&wstore+fsbal.quantity &&&UMESH OPEN IT
		repl b_&wstore with b_&wstore+fsbal.quantity
		*repl msbal.misc1 With mitm.gcode
		repl opening with opening+fsbal.quantity
		repl balance with balance+fsbal.quantity
	endi
endsca
clos tabl all

@ rowno,22 say 'Account Master ................................' Font 'Courier New',12
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alia mact
sele sele(1)
use &datatransferpath\maccount Alia fact
Sele Sele(1)
Use &datatransferpath\tvoucher Alia fcr
inde on maxcreditaccountid to fcr for conversionfactor#2
sele sele(1)
sele * from &datatransferpath\tvoucher into curs fdr readw where conversionfactor#2
inde on maxdebitaccountid to fdr
Sele Sele(1)
use &datdev\support.&datext alias support
index on aliase + str(sno,3) + lcode to Support
Sele Sele(1)
Use &datatransferpath\maddress alia fad
Inde On addressid To fad
Sele Sele(1)
Use &datatransferpath\mcity Alia fct
Inde On cityid To fct
Sele fact
Go Top
Scan
	last=recno()
	=seek(fact.defaultaddressid,'fad')
	=seek(fad.cityid,'fct')
	sele mact
	appen blan
	repl scode With iif(fact.accountcode='SUP','D31','C6')
	repl rate With 'Y'
	repl ordno With Alltr(Str(Recno()))
	repl fax2 With fact.accountcode
	repl docu with padr(fact.accountid,12)
	repl parnam  With fact.accountname
	repl mailnam With parnam
	repl paradd With fad.addressline1
	repl paradd1 With fad.addressline2
	repl paradd2 With fad.addressline3
	repl city With fct.cityname
	repl sthed With  'TIN No.'
	repl csthed With 'CST  No.'
	repl Gsthed With 'GST  No.'
	repl cstno With fad.vatcstnumber
	repl stno With fad.vattinnumber
	repl gstno With fad.gstin
	repl itno With fad.pan
	repl phone1 With fad.phone
	repl phone4 With fad.mobile
	repl fax1 With fad.fax
	repl confir With ' '
	repl rout With ''
	repl dsm With fad.zipcode
	repl dlno With ''
	repl ref With 'Mr.'
	repl price With 'A'
	repl status With 'Y'
	repl adhed With 'Discount'
	sele fcr
	seek fact.accountid
    sum voucheramount to cr while maxcreditaccountid=fact.accountid
	sele fdr
	seek fact.accountid
    sum voucheramount to dr while maxdebitaccountid=fact.accountid    
    sele mact
    repl opning with iif(scode='D31',-abs(cr-dr),abs(cr-dr))
	*** for state code ***
	Sele Support
	Appe Blan
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+'DEF'+Iif(Subs(mact.gstno,1,2)='  ',mstatecode,Subs(mact.gstno,1,2))+'          '
	*** For Email Id
	sele support
	appen blank
	repl aliase With 'ORDER   '
	repl Type With 'F'
	repl lcode With mact.ordno
	repl sno With 12
	repl remark With fad.Mail
	repl Heading With Substr(Heading,1,21)+Iif(Empty(mact.gstno),'UG','NG')
endsc
close table all

****************************
@ rowno,22 Say 'Purchase Transfer ................................' Font 'Courier New',12
rowno=rowno+1
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endi
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\pro.&datext alias pro      &&&Product Master
index on name to pro
sele sele(1)
use &datdev\order.&datext alia ord     &&Account Master
inde on padr(docu,12) to ord
sele sele(1)
use &datdev\dis.&datext alias dis      &&&Dis
sele sele(1)
use &datdev\mdis.&datext alias mdis    &&Mdis
sele sele(1)
use &datdev\probat.&datext alias prb   &&probat
index on name to prb
sele sele(1)
use &datdev\subdis.&datext alias msub
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20
sele sele(1)
use &datatransferpath\tvoucher alia pur
set filte to betwe(voucherdate,firstdate,lastdate) and mainaccountid=-1499999995
sele sele(1)
use &datatransferpath\rawpurchase alia pld
inde on purchaseinvoicenumber+invoicenumber to pld
sele pur
go top
do whil !eof()
	l3 = pur->vouchernumber
	=seek(padr(pur->maxcreditaccountid,12),'ord')
	sele mdis
	appen blan
	repl type with 'P'
	repl vcn with righ(alltr(l3),12)
	repl date with pur->voucherdate
	repl pm with pur->voucherreferencenumber
	repl lrda with pur->voucherdate
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl codep with ord.ordno
	repl ltype with '2'
	repl voucher with last4
	last4=last4+5
	repl amountp with pur->voucheramount
	repl final with pur->voucheramount
	repl round with 0
	repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	repl rout with ' '
	repl area with ' '
	repl addis with 0
	repl sale with 'Z'
	repl account with 'N'
	repl godwon with 'R'
	repl discafter with 'M'
	repl othun with 'STAC23'
	repl other with 0
	repl pacun with ''
	repl packing with 0
***Local Central***
	isigst=0
	if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
		isigst=1
	endi
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele pld
	seek pur->vouchernumber+subs(pur->voucherreferencenumber,1,20)
	do while purchaseinvoicenumber=pur->vouchernumber and invoicenumber=subst(pur->voucherreferencenumber,1,20) and !eof()
		last=pld->itemcode
		sele pro
		seek subst(last,1,10)
		sele prb
		seek subst(last,1,10) 
		sele dis
		appen blan
		repl codep with mdis->codep
		repl vcn with mdis->vcn
		repl date with mdis->date
		repl voucher with mdis->voucher
		repl code with pro->code
		repl batch with prb->batchno
		repl pack with pro->pack
		repl rate with  pld->rate
		repl exp with ctod('')
		repl mrp with  prb.mrp
		repl qty with pld->quantity
		repl free with 0&&pld->free
		repl disc1 with pld->discount
		repl flg with 'P'
		repl tax with 'T'
		if isigst=1
			repl ssta with pld->taxrate
		else
			repl ssta with pld->taxrate/2
			repl cgst with pld->taxrate/2
		endi
		repl half with 'A'
		repl godwon with mdis->godwon
		sele pld
		skip
endd
sele pur
skip
endd
clos tabl all

@ rowno,22 Say 'Sale Transfer ................................' Font 'Courier New',12
rowno=rowno+1
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endi
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\pro.&datext alias pro      &&&Product Master
index on name to pro
sele sele(1)
use &datdev\order.&datext alia ord     &&Account Master
inde on subs(fax2,1,12) to ord
sele sele(1)
use &datdev\dis.&datext alias dis      &&&Dis
sele sele(1)
use &datdev\mdis.&datext alias mdis    &&Mdis
sele sele(1)
use &datdev\probat.&datext alias prb   &&probat
index on name to prb
sele sele(1)
use &datdev\subdis.&datext alias msub
last4  = last4 + 10
slast5 = slast5 + 10
last4 = last4 + 20
sele sele(1)
use &datatransferpath\rawsales alia sal
inde on invoicenumber+dtos(invoicedate) to sal uniq
sele sele(1)
use &datatransferpath\tvoucher alia fn
inde on vouchernumber+dtos(voucherdate) to fn
sele sele(1)
SELE * from &datatransferpath\rawsales into curs sld readwri
inde on invoicenumber+dtos(invoicedate) to sld
sele sal
go top
do whil !eof()
	l3 = sal->invoicenumber
	=seek(subs(sal->customercode+spac(12),1,12),'ord')
	sele mdis
	appen blan
	repl type with 'S'
	repl vcn with righ(alltr(l3),12)
	repl date with sal->invoicedate
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl codep with ord.ordno
	repl ltype with '2'
	repl voucher with last4
	last4=last4+5
	=seek(sal.invoicenumber+dtos(sal.invoicedate),'fn')
	repl amountp with fn->voucheramount
	repl final with fn->voucheramount
	repl round with 0
	repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	repl rout with ' '
	repl area with ' '
	repl addis with 0
	repl sale with 'Z'
	repl account with 'N'
	repl godwon with 'R'
	repl discafter with 'M'
	repl othun with 'STAC23'
	repl other with 0
	repl pacun with ''
	repl packing with 0
***Local Central***
	isigst=0
	if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
		isigst=1
	endi
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele sld
	seek sal.invoicenumber+dtos(sal.invoicedate)
	do while invoicenumber+dtos(invoicedate)=sal.invoicenumber+dtos(sal.invoicedate) and !eof()
		last=sld->itemcode
		sele pro
		seek subst(last,1,10)
		sele prb
		seek subst(last,1,10) 
		sele dis
		appen blan
		repl codep with mdis->codep
		repl vcn with mdis->vcn
		repl date with mdis->date
		repl voucher with mdis->voucher
		repl code with pro->code
		repl batch with prb->batchno
		repl pack with pro->pack
		repl rate with  sld->rate
		repl exp with ctod('')
		repl mrp with  prb.mrp
		repl qty with sld->quantity
		repl free with 0&&pld->free
		repl disc1 with sld->discount
		repl flg with 'G'
		repl tax with 'T'
		if isigst=1
			repl ssta with sld->taxrate
		else
			repl ssta with sld->taxrate/2
			repl cgst with sld->taxrate/2
		endi
		repl half with 'A'
		repl godwon with mdis->godwon
		sele sld
		skip
endd
sele sal
skip
endd
clos tabl all

*!*	@ rowno,22 Say 'Purchase Out ................................' Font 'Courier New',12
*!*	rowno=rowno+1
*!*	sele sele(1)
*!*	use &datdev\support.&datext alias support
*!*	index on type+aliase to support
*!*	seek 'F' + 'BATCHPRT'
*!*	if !found()
*!*		append blank
*!*		repl type with 'F',;
*!*			aliase with 'BATCHPRT'
*!*	endi
*!*	repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
*!*	sele sele(1)
*!*	use &datdev\pro.&datext alias pro      &&&Product Master
*!*	index on name to pro
*!*	sele sele(1)
*!*	use &datdev\order.&datext alia ord     &&Account Master
*!*	inde on padr(docu,12) to ord
*!*	sele sele(1)
*!*	use &datdev\dis.&datext alias dis      &&&Dis
*!*	sele sele(1)
*!*	use &datdev\mdis.&datext alias mdis    &&Mdis
*!*	sele sele(1)
*!*	use &datdev\probat.&datext alias prb   &&probat
*!*	index on name to prb
*!*	sele sele(1)
*!*	use &datdev\subdis.&datext alias msub
*!*	sele sele(1)
*!*	use &datdev\slipno.&datext alias mslip
*!*	go top
*!*	last4  = voucher + 10
*!*	slast5 = svoucher + 10
*!*	last4 = last4 + 20
*!*	sele sele(1)
*!*	use &datatransferpath\tvoucher alia pur
*!*	set filte to betwe(voucherdate,firstdate,lastdate) and mainaccountid=-1499999995
*!*	sele sele(1)
*!*	use &datatransferpath\rawpurchase alia pld
*!*	inde on purchaseinvoicenumber+invoicenumber to pld
*!*	sele pur
*!*	go top
*!*	do whil !eof()
*!*		l3 = pur->vouchernumber
*!*		=seek(padr(pur->maxcreditaccountid,12),'ord')
*!*		sele mdis
*!*		appen blan
*!*		repl type with 'L'
*!*		repl challan with righ(alltr(l3),12)
*!*		repl chdate with pur->voucherdate
*!*		repl pm with pur->voucherreferencenumber
*!*		repl lrda with pur->voucherdate
*!*		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
*!*		repl codep with ord.ordno
*!*		repl ltype with '2'
*!*		repl voucher with last4
*!*		last4=last4+5
*!*		repl amountp with pur->voucheramount
*!*		repl final with pur->voucheramount
*!*		repl round with 0
*!*		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
*!*		repl rout with ' '
*!*		repl area with ' '
*!*		repl addis with 0
*!*		repl sale with 'Z'
*!*		repl account with 'N'
*!*		repl godwon with 'A'
*!*		repl discafter with 'M'
*!*		repl othun with 'STAC23'
*!*		repl other with 0
*!*		repl pacun with ''
*!*		repl packing with 0
*!*	***Local Central***
*!*		isigst=0
*!*		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
*!*			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
*!*			isigst=1
*!*		endi
*!*		sele support
*!*		appe blank
*!*		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!*		sele pld
*!*		seek pur->vouchernumber+subs(pur->voucherreferencenumber,1,20)
*!*		do while purchaseinvoicenumber=pur->vouchernumber and invoicenumber=subst(pur->voucherreferencenumber,1,20) and !eof()
*!*			last=pld->itemcode
*!*			sele pro
*!*			seek subst(last,1,10)
*!*			sele prb
*!*			seek subst(last,1,10) 
*!*			sele dis
*!*			appen blan
*!*			repl codep with mdis->codep
*!*			repl vcn with mdis->challan
*!*			repl date with mdis->chdate
*!*			repl voucher with mdis->voucher
*!*			repl code with pro->code
*!*			repl batch with prb->batchno
*!*			repl pack with pro->pack
*!*			repl rate with  pld->rate
*!*			repl exp with ctod('')
*!*			repl mrp with  prb.mrp
*!*			repl qty with pld->quantity
*!*			repl free with 0&&pld->free
*!*			repl disc1 with pld->discount
*!*			repl flg with 'L'
*!*			repl tax with 'T'
*!*			if isigst=1
*!*				repl ssta with pld->taxrate
*!*			else
*!*				repl ssta with pld->taxrate/2
*!*				repl cgst with pld->taxrate/2
*!*			endi
*!*			repl half with 'A'
*!*			repl godwon with mdis->godwon
*!*			sele pld
*!*			skip
*!*	endd
*!*	sele pur
*!*	skip
*!*	endd
*!*	clos tabl all

*!*	@ rowno,22 Say 'Sale In ................................' Font 'Courier New',12
*!*	rowno=rowno+1
*!*	sele sele(1)
*!*	use &datdev\support.&datext alias support
*!*	index on type+aliase to support
*!*	seek 'F' + 'BATCHPRT'
*!*	if !found()
*!*		append blank
*!*		repl type with 'F',;
*!*			aliase with 'BATCHPRT'
*!*	endi
*!*	repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
*!*	sele sele(1)
*!*	use &datdev\pro.&datext alias pro      &&&Product Master
*!*	index on name to pro
*!*	sele sele(1)
*!*	use &datdev\order.&datext alia ord     &&Account Master
*!*	inde on subs(fax2,1,12) to ord
*!*	sele sele(1)
*!*	use &datdev\dis.&datext alias dis      &&&Dis
*!*	sele sele(1)
*!*	use &datdev\mdis.&datext alias mdis    &&Mdis
*!*	sele sele(1)
*!*	use &datdev\probat.&datext alias prb   &&probat
*!*	index on name to prb
*!*	sele sele(1)
*!*	use &datdev\subdis.&datext alias msub
*!*	last4  = last4 + 10
*!*	slast5 = slast5 + 10
*!*	last4 = last4 + 20
*!*	sele sele(1)
*!*	use &datatransferpath\rawsales alia sal
*!*	inde on invoicenumber+dtos(invoicedate) to sal uniq
*!*	sele sele(1)
*!*	use &datatransferpath\tvoucher alia fn
*!*	inde on vouchernumber+dtos(voucherdate) to fn
*!*	sele sele(1)
*!*	SELE * from &datatransferpath\rawsales into curs sld readwri
*!*	inde on invoicenumber+dtos(invoicedate) to sld
*!*	sele sal
*!*	go top
*!*	do whil !eof()
*!*		l3 = sal->invoicenumber
*!*		=seek(subs(sal->customercode+spac(12),1,12),'ord')
*!*		sele mdis
*!*		appen blan
*!*		repl type with 'D'
*!*		repl challan with righ(alltr(l3),12)
*!*		repl chdate with sal->invoicedate
*!*		repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
*!*		repl codep with ord.ordno
*!*		repl ltype with '2'
*!*		repl voucher with last4
*!*		last4=last4+5
*!*		=seek(sal.invoicenumber+dtos(sal.invoicedate),'fn')
*!*		repl amountp with fn->voucheramount
*!*		repl final with fn->voucheramount
*!*		repl round with 0
*!*		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
*!*		repl rout with ' '
*!*		repl area with ' '
*!*		repl addis with 0
*!*		repl sale with 'Z'
*!*		repl account with 'N'
*!*		repl godwon with 'A'
*!*		repl discafter with 'M'
*!*		repl othun with 'STAC23'
*!*		repl other with 0
*!*		repl pacun with ''
*!*		repl packing with 0
*!*	***Local Central***
*!*		isigst=0
*!*		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
*!*			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
*!*			isigst=1
*!*		endi
*!*		sele support
*!*		appe blank
*!*		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!*		sele sld
*!*		seek sal.invoicenumber+dtos(sal.invoicedate)
*!*		do while invoicenumber+dtos(invoicedate)=sal.invoicenumber+dtos(sal.invoicedate) and !eof()
*!*			last=sld->itemcode
*!*			sele pro
*!*			seek subst(last,1,10)
*!*			sele prb
*!*			seek subst(last,1,10) 
*!*			sele dis
*!*			appen blan
*!*			repl codep with mdis->codep
*!*			repl vcn with mdis->challan
*!*			repl date with mdis->chdate
*!*			repl voucher with mdis->voucher
*!*			repl code with pro->code
*!*			repl batch with prb->batchno
*!*			repl pack with pro->pack
*!*			repl rate with  sld->rate
*!*			repl exp with ctod('')
*!*			repl mrp with  prb.mrp
*!*			repl qty with sld->quantity
*!*			repl free with 0&&pld->free
*!*			repl disc1 with sld->discount
*!*			repl flg with 'D'
*!*			repl tax with 'T'
*!*			if isigst=1
*!*				repl ssta with sld->taxrate
*!*			else
*!*				repl ssta with sld->taxrate/2
*!*				repl cgst with sld->taxrate/2
*!*			endi
*!*			repl half with 'A'
*!*			repl godwon with mdis->godwon
*!*			sele sld
*!*			skip
*!*	endd
*!*	sele sal
*!*	skip
*!*	endd
*!*	clos tabl all

****************************
*!*	@ rowno,22 Say 'Transaction History ...........................' Font 'Courier New',12
*!*	rowno=rowno+1
*!*	&& Purchase 
*!*	Sele Sele(1)
*!*	Use &datdev\slipno.&datext Alias mslip
*!*	go top
*!*	vno=voucher+10

*!*	Sele Sele(1)
*!*	Use &datdev\histdis.o00 Alias hdis
*!*	Sele Sele(1)
*!*	Use &datdev\pro.&datext Alias pro
*!*	index on upccode to pro
*!*	Sele Sele(1)
*!*	Use &datdev\order.&datext Alias ord
*!*	index on fax2 to ord
*!*	Sele Sele(1)
*!*	Use &datatransferpath\mbiztransactiontype Alias trnType
*!*	index on str(biztransactiontypeid,12) to trntryp
*!*	Sele Sele(1)
*!*	Use &datatransferpath\rawpurchase Alias htran
*!*	sele sele(1) 
*!*	use &datatransferpath\mpricelist alias frate
*!*	index on str(itemid,12) to frate


*!*	sele htran
*!*	do while not eof()
*!*	*!*		sele trnType
*!*	*!*		seek str(htran.biztransactiontypeid,12)
*!*		mvno=invoicenumber
*!*		do while invoicenumber=mvno and !eof()
*!*		sele ord
*!*		seek padr(htran.suppliercode,12)
*!*		sele frate
*!*		seek padr(htran.itemid,12)
*!*		sele pro
*!*		seek padr(htran.itemid,20)
*!*		sele ord
*!*		*seek padr(hdis.)
*!*		sele hdis
*!*		appen blan
*!*		*repl nera with allt(trnType.BiztransactionTypename)
*!*		repl codep with ord.ordno
*!*		repl vcn with right(ALLT(htran.purchaseinvoicenumber),12)
*!*		repl date with htran.purchaseinvoicedate
*!*		repl voucher with vno
*!*		repl code with pro.code
*!*		repl tax with "T"
*!*		repl qty with htran.quantity   &&hdis.quantity
*!*		*repl free with iif(purd.free>0,purd.g_qty,0)
*!*		*repl pack with htran.conversionfactor
*!*		
*!*		repl batch with str(frate.mrprate,9,2)
*!*		*repl exp with ctod('01/'+left(purd.e_date,2)+'/20'+right(allt(purd.e_date),2))
*!*		repl flg with 'P'
*!*		repl rate with htran.rate
*!*		*repl lprate with htran.cost
*!*		repl mrp with frate.mrprate
*!*		*Repl rateb with purd.g_mrp
*!*	*!*		repl disc1 with iif(purd.free>0,0,iif(isnull(purd.disc_per),0,purd.disc_per))
*!*	*!*		repl sdiscount with iif(isnull(purd.disc_per),0,purd.disc_per)
*!*	*!*		repl sstaamo with iif(isnull(purd.vat_amt),0,purd.vat_amt)
*!*		*repl ssta with purd.vat_per/2
*!*		*repl cgst with purd.vat_per/2
*!*		repl company with pro.gcode
*!*		repl half with "A"
*!*		repl godwon with 'A'
*!*	*!*		if (purd.g_amt*purd.vat_per/100)=purd.vat_amt
*!*	*!*			repl mdis.ltype with pcalc
*!*	*!*		else
*!*	*!*			if (purd.g_amt*purd.vat_per/(100+purd.vat_per))=purd.vat_amt
*!*	*!*				repl mdis.ltype with '9'
*!*	*!*			endif
*!*	*!*		endif
*!*		sele htran	
*!*		skip
*!*		enddo
*!*		vno=vno+5
*!*	enddo
*!*	sele mslip
*!*	go top
*!*	repl voucher with vno+10
*!*	close table all
*!*	*********************************************************************
*!*	retu

*!*	*!*	sele sele(1)
*!*	*!*	Use &datdev\saletype.&datext Alias mstore
*!*	*!*	set filt to sgcode='GODWON'
*!*	*!*	index on upccode  to mstore
*!*	Sele Sele(1)
*!*	Use &datdev\slipno.&datext Alias mslip
*!*	go top
*!*	vno=voucher+10

*!*	Sele Sele(1)
*!*	Use &datdev\dis.&datext Alias hdis
*!*	Sele Sele(1)
*!*	Use &datdev\pro.&datext Alias pro
*!*	index on upccode to pro
*!*	Sele Sele(1)
*!*	Use &datdev\order.&datext Alias ord
*!*	index on left(docu,12) to ord
*!*	Sele Sele(1)
*!*	Use &datatransferpath\mbiztransactiontype Alias trnType
*!*	index on str(biztransactiontypeid,12) to trntryp
*!*	Sele Sele(1)
*!*	Use &datatransferpath\tstockledger Alias htran
*!*	sele sele(1) 
*!*	use &datatransferpath\mpricelist alias frate
*!*	index on str(ouid,12)+str(itemid,12) to frate
*!*	sele htran
*!*	scan
*!*		sele trnType
*!*		seek str(htran.biztransactiontypeid,12)
*!*		sele frate
*!*		seek padr(htran.ouid,12)+padr(htran.itemid,12)
*!*		sele pro
*!*		seek padr(htran.itemid,20)
*!*		sele ord
*!*		*seek padr(hdis.)
*!*		sele hdis
*!*		appen blan
*!*		repl nera with allt(trnType.BiztransactionTypename)
*!*		*repl codep with mdis.codep
*!*		repl vcn with htran.stockledgernumber
*!*		repl date with htran.stockledgerdate
*!*		repl voucher with vno
*!*		vno=vno+5
*!*		repl code with pro.code
*!*		repl tax with "T"
*!*		repl qty with htran.Actualquantity   &&hdis.quantity
*!*		*repl free with iif(purd.free>0,purd.g_qty,0)
*!*		repl pack with htran.conversionfactor
*!*		
*!*		repl batch with str(frate.mrprate,9,2)
*!*		*repl exp with ctod('01/'+left(purd.e_date,2)+'/20'+right(allt(purd.e_date),2))
*!*	*	repl flg with Mdis.type
*!*		repl rate with htran.rate
*!*		repl lprate with htran.cost
*!*		repl mrp with frate.mrprate
*!*		*Repl rateb with purd.g_mrp
*!*	*!*		repl disc1 with iif(purd.free>0,0,iif(isnull(purd.disc_per),0,purd.disc_per))
*!*	*!*		repl sdiscount with iif(isnull(purd.disc_per),0,purd.disc_per)
*!*	*!*		repl sstaamo with iif(isnull(purd.vat_amt),0,purd.vat_amt)
*!*		*repl ssta with purd.vat_per/2
*!*		*repl cgst with purd.vat_per/2
*!*		repl company with pro.gcode
*!*		repl half with "A"
*!*		repl godwon with 'A'
*!*	*!*		if (purd.g_amt*purd.vat_per/100)=purd.vat_amt
*!*	*!*			repl mdis.ltype with pcalc
*!*	*!*		else
*!*	*!*			if (purd.g_amt*purd.vat_per/(100+purd.vat_per))=purd.vat_amt
*!*	*!*				repl mdis.ltype with '9'
*!*	*!*			endif
*!*	*!*		endif
*!*	endscan

*!*	@ rowno,22 Say 'Stock Opening ...........................' Font 'Courier New',12
*!*	rowno=rowno+1
*!*	sele sele(1)
*!*	use datdev + '\probat.'+datext alias prb
*!*	inde on batchno+str(code) to prb uniq
*!*	sele sele(1)
*!*	selec * from prb into curso bprb readwr
*!*	inde on batchno+str(code) to bprb
*!*	sele sele(1)
*!*	use datdev + '\dis.'+datext alias dis
*!*	inde on batch+str(code) to dis
*!*	sele prb
*!*	go top
*!*	scan
*!*		Sele bprb
*!*		Seek prb->batchno+Str(prb->Code)
*!*		Sum qty To mbalance While batchno+Str(Code)=prb.batchno+Str(prb.Code)
*!*		Store 0 To xin,xin1,xout,xout1,xout2
*!*		Sele dis
*!*		Seek prb->batchno+Str(prb->Code)
*!*		Scan For Date=>old_5 While Batch+Str(Code)=prb.batchno+Str(prb.Code)
*!*			If dis.flg = 'P'
*!*				xin = xin +(dis.qty) + (dis.Free)
*!*			Else
*!*				If dis.flg = 'R'
*!*					xin1 = xin1 +(dis.qty) + (dis.Free)
*!*				Else
*!*					If dis.flg = 'G'
*!*						xout = xout +(dis.qty) + (dis.Free)
*!*					Else
*!*						If dis.flg = 'B'
*!*							xout1 = xout1 +(dis.qty) + (dis.Free)
*!*	                         Else
*!*						         If dis.flg = 'O'
*!*							         xout2 = xout2 +(dis.qty) + (dis.Free)
*!*	                       endi
*!*						Endi
*!*					Endi
*!*				Endif
*!*			Endif
*!*		Endsc
*!*		mopening=mbalance+xout+xout1+xout2-(xin+xin1)
*!*		Sele prb
*!*		repl prb->opening With opening-iif(mopening<0,abs(mopening),-abs(mopening))
*!*		repl prb->o_r With mopening
*!*	endsc
*!*	clos tabl all

return

@ rowno,22 say 'Supplier Outstanding ..........................' Font 'Courier New',12
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alia mpend
sele sele(1)
use &datatransferpath\pen alias fout
set filt to (invamt-paidamt)#0
go top
sele sele(1)
use &datdev\slipno.&datext Alias mslip
sele mslip
go top
repl voucher with 100,svoucher with 107
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
	Sele mpend
		Append Blank
		Repl acgroup With 'D31'
		Repl ord With 'S'+allt(fout.supl_code)
		Repl ddate With fout.inv_date
		Repl vcn With fout.inv_no
		Repl invtype With 'O'
		Repl voucher  With vou
		Repl svoucher With svou
		Repl Final With -(fout.Invamt)
		Repl itemope With iif(fout.Invamt-fout.Paidamt>0,fout.paidamt,0)
		Repl balance With -(fout.Invamt-fout.paidamt)
		Repl Name With vcn
		vou=vou+5
		svou=svou+5
endsc
sele mslip
repl voucher  With vou+7
repl svoucher With svou+7
sele fout
use

@ rowno,22 Say 'Debtors Outstandings ..........................' Font 'Courier New',12
rowno=rowno+1
Sele Sele(1)
Use &datatransferpath\spare_custdues Alias fout
go top
Scan
	Sele mpend
		Append Blank
		Repl acgroup With 'C6'
		Repl ord With 'C'+allt(fout.Cust_code)
		Repl ddate With fout.BillDate
		Repl vcn With fout.Billno
		Repl invtype With 'O'
		Repl voucher  With vou
		Repl svoucher With svou
		Repl Final With fout.BillVal
		Repl itemope With iif(fout.BillVal-fout.Paidamt>0,fout.paidamt,0)
		Repl balance With fout.BillVal-fout.Paidamt
		Repl Name With vcn
		vou=vou+5
		svou=svou+5
Endsc
Sele mslip
Repl voucher  With vou+5
Repl svoucher With svou+5

@ rowno,22 Say 'Ledger Balance Update..........................' Font 'Courier New',12
rowno=rowno+1
Sele Sele(1)
Use &datdev\order.&datext Alias mord
sele mpend
index on ord to mpend
sele mord
go top
	scan	
	sele mpend
	seek mord.ordno
	sum balance to mbal whil ord=mord.ordno and !eof()
	sele mord
	repl opning with mbal
endsc
clos table all
return
proc rem_null
	a = afields(arr)
	for imarg = 1 to a
		mfldname = arr(imarg, 1)
		do case
			case inlist(arr(imarg,2), "C","V","M")
				replace all &mfldname with '' for isnull(&mfldname)
			case inlist(arr(imarg,2), "B","N","I","F","Y","M")
				replace all &mfldname with 0 for isnull(&mfldname)
			case inlist(arr(imarg,2), "D","T","M")
				replace all &mfldname with ctod('') for isnull(&mfldname)
		endcase
	endfor
	clos tabl all