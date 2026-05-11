*!*  TICKET NO. 39CBE083
**  XQLUSIVE SOFTWARE SOLUTION FOREVER, SOUTH
*!*  Transfer type : Master Only

*!*	*!* your commands
Clear
Set Cpdialog Off
Close Data
Set Talk Off
Set Date To brit
Set Cent On
Set Dele On
Set Safe Off
If Type('FINALCP')='U'
	firstdate=Ctod('01/04/2024')  		&& Un-Comment this for run from VFP
	lastdate =Ctod('31/03/2025')  		&& Un-Comment this for run from VFP
	datdev='E:\transfer'   && Un-Comment this for run from VFP
	datext='dbf'						&& Un-Comment this for run from VFP
Endif

datatransferext='DBF'
datatransferpath =Substr('D:\Month\Feb\xqlusive\dbf'+Space(50),1,50)
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
@ 04,22 Say 'Piping XQLUSIVE(wholesale) General Trading To Marg.....' Font 'Arial Bold',14 Colo Rgb(254,254,254,150,230,230)
@ 06,22 Say 'myinfosoft Data Path   :' Font 'Courier New' ,14 Get datatransferpath  Font 'courier new',14
@ 07,22 Say 'myinfosoft Extension   :' Font 'Courier New' ,14 Get datatransferext  Font 'courier new',14
@ 08,22 Say 'F.Y.BEGIN Date         :' Font 'Courier New' ,14 Get old_5  Font 'Courier new',14
@ 09,22 Say 'F.Y.End   Date         :' Font 'Courier New' ,14 Get old_6   Font 'Courier new',14
@ 10,22 Say 'State Code             :' Font 'Courier New' ,14 Get mstatecode Font 'Courier new',14
@ 11,22 Say 'Removenull             :' Font 'Courier New' ,14 Get removenull Pict '@m No,Yes ' Font 'Courier new',13
@ 12,22 Say 'Type SURE              :' Font 'Courier New' ,14 Get sure Pict '@x!' Font 'courier new',14
Read
If Type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
Endif
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

@ 03,22 Say 'Please Wait Importing XQLUSIVE General Trading To Marg.....' Font 'Arial Bold',14 Colo Rgb(254,254,254,150,230,230)
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
Close Table all

@rowno,22 Say 'Importing Product .....' Font 'Courier New',14
rowno=rowno+1

Sele Sele(1)
Use &datatransferpath\GENS0004  Alias fitm
Sele Sele(1)
Use &datatransferpath\GENS0003 Alias fcomp
Sele Sele(1)
Use &datatransferpath\GENS0016 Alias fcat
Sele Sele(1)
Use &datatransferpath\GENS0012 Alias ftax
index on taxno to ftax
Sele Sele(1)
Use &datatransferpath\GENS0017 Alias fsbal
index on pmcode to fsbal
Sele Sele(1)
Use &datdev\pro.&datext Alias mitm

Sele Sele(1)
Use &datdev\saletype.&datext Alias mpcm
Index On sgcode + parnam + Str(igst,5,2) To  mpcm

Sele fitm
Go Top
Scan
	sele ftax
	seek fitm.gstaxno
	Sele mitm
	Append Blank
	Repl mitm.Code With fitm.pmcode
	Repl mitm.Name With Padr(fitm.pmcode,10)
	Repl mitm.Product With upper(fitm.pmname)
	Repl mitm.billname With upper(fitm.pmname)
	Repl mitm.Pack With fitm.piece
	Repl mitm.gcode With allt(Str(fitm.compcode))
	Repl mitm.gcode5 With allt(Str(fitm.pgrcode))
	Repl mitm.taxl With 'T'
	Repl mitm.taxc With 'T'
	Repl mitm.Decimal With 'Y'
	Repl mitm.salfix With 'N'
	Repl mitm.halfsche With 'A'
	Repl mitm.qtrsche With 'Y'
	Repl mitm.Status With 'Y'
	Repl mitm.prate With fitm.prate
	Repl mitm.lprate With fitm.pnlc
	Repl mitm.ratea With fitm.wholesale
	Repl mitm.mrp With fitm.mrp
	Repl mitm.rateb With fitm.retail

	Repl mitm.saltax With ftax.TaxRate/2
	Repl mitm.cgst With ftax.TaxRate/2
	Repl mitm.igst With ftax.TaxRate

	&&HSN
	Sele mpcm
	Set Order To Tag mpcm
	Seek 'COMMCD' + Substr(fitm.hsncode+Space(15),1,15) + Str(mitm.igst,5,2)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'COMMCD',;
			mpcm.scode  With 'H'+Alltrim(Str(recno())),;
			mpcm.sname  With Substr(fitm.hsncode+Space(15),1,15)+ Substr(fitm.hsncode,1,15) +' '+ Alltrim(Str(mitm.igst,5,2)) ,;
			mpcm.parnam With fitm.hsncode,;
			mpcm.tax With mitm.saltax,;
			mpcm.cgst With mitm.cgst,;
			mpcm.igst With mitm.igst,;
			mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode6 With mpcm.scode
	sele fsbal
	seek fitm.pmcode
	qbal=0
	scan while fsbal.pmcode=fitm.pmcode
		qbal=qbal+(IQTY-OQTY) 
	endscan
	sele mitm
	Repl mitm.o_a With qbal
	Repl mitm.b_a With qbal
	Repl mitm.opening With qbal
	Repl mitm.balance With qbal
Endscan
@rowno,22 Say 'Importing Company ...' Font 'Courier New',14
rowno=rowno+1

	&& COMPANY
sele fcomp
scan	
	sele mpcm
	append blank
	Repl mpcm.sgcode With 'ZZZZZZ'
	Repl mpcm.scode  With Alltrim(Str(fcomp.code))
	Repl mpcm.sname  With upper(fcomp.cmname)
	Repl mpcm.parnam With upper(fcomp.cmname)
endscan

@rowno,22 Say 'Importing Category ..' Font 'Courier New',14
rowno=rowno+1
&&category
sele fcat
scan
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'CATEGO',;
		mpcm.scode  With allt(str(fcat.pgrcode)),;
		mpcm.sname  With upper(fcat.pgroup) ,;
		mpcm.parnam With upper(fcat.pgroup),;
		mpcm.tcode With 'No'
Endscan

Close Table All


@rowno,22 Say 'Importing Party Master .....' Font 'Courier New',14
rowno=rowno+1


Sele Sele(1)
Use &datatransferpath\GENS0002 Alias fdet
index on accode to fdet
Sele Sele(1)
Use &datatransferpath\GENS0011 Alias fact
set filt to inlist(grcode,0,10,11,12,13) and inlist(grtype,1,2)
Sele Sele(1)
Use &datatransferpath\GENS0010 Alia fgrp
index on grcode to fgrp
Sele Sele(1)
Use &datatransferpath\GENS0013 Alia fled
index on accode to fled

Sele Sele(1)
Use &datdev\saletype.&datext Alias mpcm
Index On sgcode + sname  To mpcm
Sele Sele(1)
Use &datdev\Order.&datext Alias mact
Sele Sele(1)
Use &datdev\Support.&datext Alias tsupp
Index On aliase + Str(sno,3) + lcode To tsupp

Sele fact
Go Top
Scan
	wgrp=''
	sele fgrp
	seek fact.grcode
	Do Case
		Case fgrp.grname='Sundry Creditors ' or  fact.grtype=2
			wgrp='D31'
		Case fgrp.grname='Sundry Debtors  ' or fact.grtype=1
			wgrp='C6'
		Case fgrp.grname='Bank O/D  '
			wgrp='G1'
		Case fgrp.grname='Loans & Advances '
			wgrp='C4'
		Case fgrp.grname='Cash '
			wgrp='C1'
	
	Endc
	sele fdet
	seek fact.accode
	Sele mact
	Append Blank
	Repl mact.scode With  wgrp
	Repl mact.rate With 'Y'
	repl mact.fax2 with padr(fdet.code,7)
	Repl mact.ordno With Alltrim(Str(fact.accode))
	Repl mact.parnam  With Alltrim(Upper(fact.acName))
	Repl mact.mailNam With Alltrim(Upper(fact.acName))
	Repl mact.paradd With upper(fdet.add1)
	Repl mact.Paradd1 With upper(fdet.add2)
	Repl mact.Paradd2 With upper(fdet.add3)
	Repl mact.sthed With  'TIN No.'
	Repl mact.gsthed With  'GSTIN'
	Repl mact.csthed With 'CST  No.'
	Repl mact.gstno With  fdet.gstno
	Repl mact.dlno With  fdet.dlno
	Repl mact.phone1 With fdet.phone
	Repl mact.phone2 With fdet.mobile
	Repl mact.phone4 With fdet.phone
	repl mact.area with padr(fdet.routcode,6)
	repl mact.mr with ALLT('S'+padr(fdet.REPCODE,5))
	repl mact.confir with fdet.contactperson
	Repl mact.ref With 'Mr.'
	Repl mact.price With 'A'
	Repl mact.Status With 'Y'
	sele fled
	seek fact.accode
	mbal=0
	if found()
		scan while fled.accode= fact.accode
			if mact.scode='C6'
				mbal=mbal+(fled.DR-fled.CR)
			else
				mbal=mbal+(fled.dR-fled.cR)
			endif
		endscan
	endif
	sele mact
	repl opning with mbal
	repl balance with mbal
	&& Updating State
	Sele tsupp
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
	Sele fact
Endscan
Close table all
@rowno,22 Say 'Importing Area ...' Font 'Courier New',14
rowno=rowno+1

Sele Sele(1)
Use &datatransferpath\GENS0006 Alias farea
Sele Sele(1)
Use &datdev\saletype.&datext Alias mpcm

	&& AREA
sele farea
scan	
	sele mpcm
	append blank
	Repl mpcm.sgcode With 'AREA'
	Repl mpcm.scode  With Alltrim(Str(farea.code))
	Repl mpcm.sname  With upper(farea.Rtname)
	Repl mpcm.parnam With upper(farea.Rtname)
endscan
close table all
@rowno,22 Say 'Importing MR ...' Font 'Courier New',14
rowno=rowno+1

Sele Sele(1)
Use &datatransferpath\GENS0005 Alias fact
Sele Sele(1)
Use &datdev\order.&datext Alias mact

	&& AREA
sele fact
scan	
	Sele mact
	Append Blank
	Repl mact.scode With  'D32'
	Repl mact.rate With 'Y'
	Repl mact.ordno With 'S'+Alltrim(Str(fact.code))
	Repl mact.parnam  With Alltrim(Upper(fact.Smname))
	Repl mact.mailNam With Alltrim(Upper(fact.Smname))
	Repl mact.paradd With upper(fact.add1)
	Repl mact.Paradd1 With upper(fact.add2)
	Repl mact.Paradd2 With upper(fact.add3)
	Repl mact.sthed With  'TIN No.'
	Repl mact.gsthed With  'GSTIN'
	Repl mact.csthed With 'CST  No.'
	*Repl mact.gstno With  fdet.gstno
	*Repl mact.dlno With  fdet.dlno
	Repl mact.phone1 With fact.mobile
	Repl mact.phone2 With fact.mobile
	Repl mact.phone4 With fact.mobile
	Repl mact.ref With 'Mr.'
	Repl mact.price With 'A'
	Repl mact.Status With 'Y'
endscan
close table all



return

@rowno,22 Say 'Importing Party Outstandings .....' Font 'Courier New',14
rowno=rowno+1


Sele Sele(1)
Use &datatransferpath\payment Alias fpay
index on str(paymentid,10)+str(customerid,10) to fpay
go top
Use &datatransferpath\transaction Alias fout
index on str(paymentid,10)+str(customerid,10) to fout


Return




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

	*!*	&&EOF : Neosoft.PRG .....Author JEEVAN PREET SAINI
