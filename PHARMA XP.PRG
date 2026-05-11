**	TICKET NO. 		:	CA357FEC
**	Zone			:	Zone Chennai	
**	State			:	Kerala Central	
**	Migration Type	:	New
**	Transfer Type	:	Master Migration
**	Software		:	Pharma XP Local SOFTWARE
**	Trade			:	Pharma
**	Business Type	:	WHOLESALE(Only Master)
**  Date            :   12/10/2022

*!*	*!* your commands
clear
set cpdialog off
close table all
set talk off
set date to brit
set cent on
set dele on
set safe off
CLOSE TABLE ALL
firstdate=ctod('01/04/2022')  		&& Un-Comment this for run from VFP
lastdate =ctod('31/03/2023')  		&& Un-Comment this for run from VFP
datdev='d:\transfer\'   && Un-Comment this for run from VFP
datext='dbf'						&& Un-Comment this for run from VFP

datatransferext='DBF'
datatransferpath =substr('D:\DM\Feb\1accede\DBF\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='32'
sure='SURE'
removenull='No '

Clear
Close table all
@ 02,22 Say 'Piping DATA To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 to 21,115 doub
@ 06,10 Say 'Data Path        :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 08,10 Say 'Extension        :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 09,10 Say 'F.Y.BEGIN Date   :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 10,10 Say 'F.Y.End   Date   :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 11,10 Say 'State Code       :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 12,10 Say 'Removenull       :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 13,10 Say 'Type SURE        :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18
Read
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
*!*	=starttransfer()        &&&&Comment it for run in VFP

Clear
close tabl all
datatransferpath=alltrim(datatransferpath)
datatransferpath=Alltrim(datatransferpath)

datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
Clear
if removenull='Y'
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	@ 02,22 Say 'Please Wait Removing Null Values.....' Font 'Arial',14 Colo 'W+/G'
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next                           
Endif
rowno=5

@ 02,22 Say 'Please Wait Importing Pharma Xp Wholesale To Marg.....' Font 'Arial',14 Colo 'W+/G'

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
Close table all
Set Colo To

@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\proddata alias fitm
sele sele(1) 
	use &datatransferpath\compdata alias fcomp
	index on int(CompCode) to fcomp
sele sele(1) 
	use &datatransferpath\drug alias fdrug
	index on drugcode to fdrug
	
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\probat.&datext alias msbal
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + SNAME + str(igst,5,2) to mpcm
sele fitm
go top
scan
	Sele mitm
	Append Blank
	Repl mitm.Code With Recno()
	Repl mitm.Name With Alltr(Str(int(fitm.prodcode)))
	Repl mitm.Product With Alltr(Uppe(fitm.name))
	Repl mitm.billname With Alltr(Uppe(fitm.name))
	repl unit with 'Pcs'
	Repl mitm.taxl With 'T'
	Repl mitm.taxc With 'T'
	Repl mitm.Decimal With 'Y'
	Repl mitm.salfix With 'N'
	Repl mitm.halfsche With 'A'
	Repl mitm.qtrsche With 'Y'
	Repl mitm.Status With 'Y'
	Repl mitm.saltax With iif(fitm.gst#0,fitm.gst/2,0)
	Repl mitm.cgst With iif(fitm.gst#0,fitm.gst/2,0)
	Repl mitm.igst With fitm.gst
	Repl mitm.purtax With iif(fitm.gst#0,fitm.gst/2,0)
	Repl mitm.gcode With 'Z'+allt(str(fitm.compcode))
	REPL mitm.GCODE3 with 'S'+alltrim(str(fitm.drugcode))
&&&hsn update
	sele mpcm
	Seek 'COMMCD' + substr(fitm.hsn+space(40),1,40)+ str(mitm.igst,5,2)
	If !Found()
		Append Blank
		Repl sgcode With 'COMMCD'
		Repl scode  With 'H'+Allt(Str(Recno()))
		Repl parnam  With Substr(Upper(fitm.hsn),1,15)
		Repl sname With Substr(Upper(Allt(fitm.hsn))+Space(40),1,40)
		Repl mpcm.tax With iif(mitm.igst#0,mitm.igst/2,0)
		Repl mpcm.cgst With iif(mitm.igst#0,mitm.igst/2,0)
		Repl mpcm.igst With mitm.igst
		Repl mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode6 With mpcm.scode	
	** salt
endsca

sele fcomp
scan
	Sele mpcm
	Append Blan
	Repl sgcode With 'ZZZZZZ'
	Repl scode  With 'Z'+Allt(Str(fcomp.Compcode))
	Repl parnam With Substr(Upper(fcomp.name),1,15)
	Repl sname  With Subs(Upper(Allt(fcomp.name))+Space(40),1,40)
endsc

@Rowno,22 say 'Importing Drug Master .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
sele fdrug
do while not eof()
	sele mpcm
	Append Blank
	Repl sgcode With 'SALT  '
	Repl scode  With 'S'+Allt(Str(fdrug.drugcode))
	Repl parnam  With Substr(fdrug.drug,1,15)
	Repl sname With Substr(fdrug.drug,1,40)
	Repl tname With Substr(fdrug.drug,41,40)
	sele fdrug
	skip
enddo
close table all

@Rowno,22 say 'Importing Customer .....' font 'Courier',14 
rowno=rowno+1
sele sele (1)
use &datatransferpath\RetLdata&datatransferext alias fcust
sele sele (1)
use &datatransferpath\District&datatransferext alias fdist
index on DistCode to fdist 
sele sele (1)
use &datatransferpath\Area&datatransferext alias farea
index on areacode to farea

sele sele(1)
use &datdev\order.&datext alias mact

sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode + sname to mpcm
sele sele (1)
Use &datdev\support.&datext Alias msup
Index On aliase + Str(sno,3) + lcode To msup
Dele All For aliase = 'ORDER   '
Dele All For sno=7
Dele All For (Type='#' And aliase='DAT/F-LD')
Pack
Sele fcust
Go Top
scan
	=seek(fcust.areacode,'farea')
	wgrp=''
	do case
		case fcust.GroupCode=1
		wgrp='C6'
		case fcust.GroupCode=6
		wgrp='C1'
		case fcust.GroupCode=8 OR fcust.GroupCode=9
	endcase
	Sele mact
	Append Blank
	Repl mact.ordno With Allt(Str(Recno()))
	repl mact.fax2 with alltri(str(fcust.retlcode))
	Repl mact.scode With wgrp  &&acount group code
	Repl mact.parnam  With allt(Upper(fcust.NAME))
	Repl mact.mailnam With substr(allt(fcust.name)+space(30),1,30)+subst(allt(fcust.Place),15)
	Repl mact.paradd With allt(fcust.add1)
	Repl mact.paradd1 With allt(fcust.add2)
	repl paradd2 with fcust.place
	repl city with fcust.place
	Repl mact.area With ''
	Repl mact.price With 'A'
	Repl mact.rate With 'Y'
	Repl mact.Status With 'Y'
	Repl mact.adhed With 'Discount'
	Repl mact.itno With ''
	Repl mact.sthed With  'TIN No.'
	Repl mact.csthed With 'CST No.'
	Repl mact.gsthed With 'GSTIN'
	if len(allt(fcust.email))=15 
		Repl mact.gstno with allt(fcust.email)
	endif
	Repl mact.cstno With iif(len(allt(fcust.email))#15,allt(fcust.email),'')  &&Strtran(fcust.vcinno,CHR(0),'')
	Repl mact.stno With '' &&Strtran(fcust.vcinno,CHR(0),'')
	if !empty(fcust.dlno1)
		Repl mact.dlno With allt(fcust.dlno1)+','+allt(fcust.dlno2)
	endif
	Repl mact.dsm With allt(fcust.pin)
	Repl mact.phone1 With allt(fcust.phone)
	Repl mact.phone4 With allt(fcust.phone)
	Repl mact.ref With 'Mr.'
	Repl mact.Confir With ''

&&&&area update
		sele mpcm
		Seek 'AREA  ' + substr(farea.area+space(40),1,40) 
		If !Found()
			Append Blank
			Repl sgcode With 'AREA  '
			Repl scode  With 'A'+Allt(Str(recno()))
			Repl parnam  With substr(farea.area+space(40),1,40)
			Repl sname With substr(farea.area+space(40),1,40)
		Endif
		Repl mact.area With mpcm.scode
**support update
	Sele msup
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Substr(mact.gstno,1,2)='  ',mstatecode,Subs(mact.gstno,1,2))+Substr(remark,42)
	If mstatecode#Subs(mact.gstno,1,2) And !Empty(Subs(mact.gstno,1,2))
		Append Blank
		Repl aliase With 'LBTDETAI'
		Repl Type With 'F'
		Repl lcode With mact.ordno
		Repl Heading With 'L            ON          '
	Endif
endsca
Close Tables All


@Rowno,22 say 'Importing Vendor .....' font 'Courier',14 
rowno=rowno+1
sele sele (1)
use &datatransferpath\vendor&datatransferext alias fact

sele sele(1)
use &datdev\order.&datext alias mact

sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode +sname to mpcm

sele sele (1)
Use &datdev\support.&datext Alias msup
Index On aliase + Str(sno,3) + lcode To msup
Dele All For aliase = 'ORDER   '
Dele All For sno=7
Dele All For (Type='#' And aliase='DAT/F-LD')
Pack
Sele fact
Go Top
Do While !Eof()
	Sele mact
	Append Blank
	Repl mact.ordno With Allt(Str(Recno()))
	Repl mact.scode With 'D31'  &&acount group code
	Repl mact.parnam  With allt(Upper(fact.NAME))
	Repl mact.mailnam With allt(fact.NAME)
	Repl mact.paradd With allt(fact.add1)
	Repl mact.paradd1 With allt(fact.add2)
	Repl mact.paradd2 With allt(fact.place)
	Repl mact.area With ''
	Repl mact.price With 'A'
	Repl mact.rate With 'Y'
	Repl mact.Status With 'Y'
	Repl mact.adhed With 'Discount'
	Repl mact.itno With ''
	Repl mact.sthed With  'TIN No.'
	Repl mact.csthed With 'CST No.'
	Repl mact.gsthed With 'GSTNO.'
	if len(allt(fact.kgst))=14 or len(allt(fact.kgst))=15
		Repl mact.gstno with allt(fact.kgst)
	endif
	Repl mact.cstno With allt(fact.cst)  &&Strtran(fact.vcinno,CHR(0),'')
	Repl mact.stno With '' &&Strtran(fact.vcinno,CHR(0),'')
	Repl mact.dlno With ''
	Repl mact.dsm With fact.pin
	Repl mact.phone1 With fact.phone
	Repl mact.phone2 With fact.phone1
	Repl mact.phone3 With fact.phone2
	Repl mact.phone4 With fact.phone
	Repl mact.city with substr(allt(fact.place),1,at('-',allt(fact.Place))-1)
	Repl mact.ref With 'Mr.'
	Repl mact.Confir With ''
	repl mact.opning with 0 &&fact.opbal
	Sele msup
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Substr(mact.gstno,1,2)='  ',mstatecode,Subs(mact.gstno,1,2))+Substr(remark,42)
	If mstatecode#Subs(mact.gstno,1,2) And !Empty(Subs(mact.gstno,1,2))
		Append Blank
		Repl aliase With 'LBTDETAI'
		Repl Type With 'F'
		Repl lcode With mact.ordno
		Repl Heading With 'L            ON          '
	Endif
	Sele fact
	Skip
Enddo

close table all
@rowno,22 say 'Importing A/C Outstandings  ****' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on substr(fax2,1,6) to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\Retailer alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
	go top
scan 
	mvcn=alltr(str(fout.billno))
	sele mord
	seek substr(alltri(str(fout.retlcode))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->amount),abs(fout->amount))
	repl itemope with iif(acgroup='D31',-abs(fout.amtrec),abs(-fout.amtrec))
	repl balance with iif(acgroup='D31',-abs(final-itemope),abs(final-itemope))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

@rowno,22 say 'Importing Ledger Balance  ****' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord 

sele sele(1)
use &datdev\pendings.&datext alias mpend
inde on ord to mpend 

sele mord
go top
	scan
	sele mpend
	seek mord->ordno
	
	sum balance to mbal whil ord=mord->ordno and !eof()
	sele mord
	repl opning with mbal
endsc
clos table all



*** STOCK TRANSFER
@rowno,22 say 'Importing Batch Stock  ****' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
go top
scan
   sele mitm
   seek  substr(alltr(str(fsbal.prodcode))+space(10),1,10)
   sele msbal
   seek substr(alltr(str(fsbal.prodcode))+space(10),1,10) + substr(fsbal.batchno+space(12),1,12)
   if !found()
      append blank
      repl msbal.code with mitm.code,;
           msbal.name with mitm.name,;
           msbal.billname with mitm.billname,;
           msbal.product with mitm.product,;
           msbal.pack with mitm.pack,;
           msbal.unit2 with mitm.unit2,;
           msbal.unit with mitm.unit,;
           msbal.decimal with 'Y',;
           msbal.opening with fsbal.stock,;
           msbal.balance with fsbal.stock,;
           msbal.o_a with fsbal.stock,;
           msbal.b_a with fsbal.stock,;
           msbal.batchno with fsbal.batchno
     	repl msbal.exp with ctod('01/'+substr(fsbal.expdate,1,2)+'/20'+substr(fsbal.expdate,4,2)),;
           msbal.mrp with fsbal.mrp,;
           msbal.prate with fsbal.pprice,;
           msbal.ratea with fsbal.sprice,;
           msbal.lprate with fsbal.ventax,;           
           msbal.mrp with fsbal.mrp,;
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
	   else
          repl msbal.opening with msbal.opening + fsbal.stock,;
	           msbal.balance with msbal.balance + fsbal.stock,;
	           msbal.o_a with msbal.o_a + fsbal.stock,;
	           msbal.b_a with msbal.b_a + fsbal.stock
   endif
endsc
close table all



retu


***********  VENDOR TRANSFER  *********************************
*!*	fact=datatransferpath + 'vendor'+datatransferext
*!*	*fbal=datatransferpath + 'PurchReg'+datatransferext
*!*	fcust=datatransferpath + 'RetLdata'+datatransferext
*!*	fdist=datatransferpath + 'District'+datatransferext
*!*	fArea=datatransferpath + 'Area'+datatransferext
*!*	*fsbil=datatransferpath + 'BillRegi'+datatransferext
*!*	frec=datatransferpath + 'Retailer'+datatransferext
*!*	*fcn=datatransferpath + 'CRNOTE'+datatransferext
*!*	td=datdev + '\order.'+datext
*!*	ts=datdev + '\support.'+datext
*!*	*pn=datdev + '\pendings.'+datext
*!*	sele sele(1) 
*!*		use &datatransferpath\EXPENSE alias fledBal
*!*		set filt to fledBal.Credit=0 OR fledBal.Debit=0
*!*		index on ExpCode to fled
*!*		Goto top
*!*	*sele sele(1)
*!*	*use &fsbil alia fsbil
*!*	*index on retlcode to fsbil
*!*	*goto top
*!*	sele sele(1)
*!*	use &frec alia frec
*!*	index on retlcode to frec
*!*	*sele sele(1)
*!*	*use &fcn alias fcn
*!*	*index on RetlCode to fcn
*!*	sele sele(1)
*!*	use &farea alia farea
*!*	index on areacode to farea
*!*	sele sele(1)
*!*	use &fdist alia fdist
*!*	index on DistCode to fdist 
*!*	sele sele(1)
*!*	use &fcust alia fcust
*!*	*!*	sele sele(1)
*!*	*!*	use &fbal alia fbal
*!*	*!*	index on compcode to fbal
*!*	sele sele(1)
*!*	use &fact alia fact
*!*	index on compcode to fact
*!*	sele sele(1)
*!*	use &datdev\saletype.&datext alias mpcm
*!*	index on sgcode + parnam + str(igst,5,2) to mpcm
*!*	Sele Sele(1)
*!*	Use &ts Alias msup
*!*	Index On aliase + Str(sno,3) + lcode To msup
*!*	Dele All For aliase = 'ORDER   '
*!*	Dele All For sno=7
*!*	Dele All For (Type='#' And aliase='DAT/F-LD')
*!*	Pack
*!*	Sele Sele(1)
*!*	Use &datdev\pendings.&datext Alias mpend
*!*	sele sele(1)
*!*	Use &datdev\slipno.&datext  Alias mslip
*!*	Sele Sele(1)
*!*	Use &td Alias mact

*!*	Sele fact
*!*	Go Top
*!*	Do While !Eof()
*!*		Sele mact
*!*		Append Blank
*!*		Repl mact.ordno With Allt(Str(Recno()))
*!*		Repl mact.scode With 'D31'  &&acount group code
*!*		Repl mact.parnam  With allt(Upper(fact.NAME))
*!*		Repl mact.mailnam With allt(fact.NAME)
*!*		Repl mact.paradd With allt(fact.add1)
*!*		Repl mact.paradd1 With allt(fact.add2)
*!*		Repl mact.paradd2 With allt(fact.place)
*!*		Repl mact.area With ''
*!*		Repl mact.price With 'A'
*!*		Repl mact.rate With 'Y'
*!*		Repl mact.Status With 'Y'
*!*		Repl mact.adhed With 'Discount'
*!*		Repl mact.itno With ''
*!*		Repl mact.sthed With  'TIN No.'
*!*		Repl mact.csthed With 'CST No.'
*!*		Repl mact.gsthed With 'GSTNO.'
*!*		if len(allt(fact.kgst))=14 or len(allt(fact.kgst))=15
*!*			Repl mact.gstno with allt(fact.kgst)
*!*		endif
*!*		Repl mact.cstno With allt(fact.cst)  &&Strtran(fact.vcinno,CHR(0),'')
*!*		Repl mact.stno With '' &&Strtran(fact.vcinno,CHR(0),'')
*!*		Repl mact.dlno With ''
*!*		Repl mact.dsm With fact.pin
*!*		Repl mact.phone1 With fact.phone
*!*		Repl mact.phone2 With fact.phone1
*!*		Repl mact.phone3 With fact.phone2
*!*		Repl mact.phone4 With fact.phone
*!*		Repl mact.city with substr(allt(fact.place),1,at('-',allt(fact.Place))-1)
*!*		Repl mact.ref With 'Mr.'
*!*		Repl mact.Confir With ''
*!*		repl mact.opning with 0 &&fact.opbal
*!*	*!*		sele fledBal
*!*	*!*		store 0 to wCrAmt
*!*	*!*		seek fact.CompCode
*!*	*!*		if found()
*!*	*!*			Sele mslip
*!*	*!*			Go Top
*!*	*!*			vou =voucher  + 10
*!*	*!*			svou=svoucher + 10
*!*	*!*			sele fledBal	
*!*	*!*			seek fact.CompCode		
*!*	*!*			do while fledBal.Expcode=fact.CompCode 
*!*	*!*				Sele mpend
*!*	*!*				Appe Blank
*!*	*!*				Replace mpend.ord       With   mact.ordno
*!*	*!*				Replace mpend.ddate     With   fledBal.Date
*!*	*!*				Replace mpend.invtype   With   "O"
*!*	*!*				Replace mpend.vcn       With   allt(str(fledBal.BillNo))
*!*	*!*				Replace mpend.voucher   With   vou
*!*	*!*				Replace mpend.Final     With   -fledBal.Amount &&fout.pbat,-fout.pbat)
*!*	*!*				Replace mpend.balance   With   -fledBal.Amount
*!*	*!*				Replace mpend.duedate   With   fledBal.Date
*!*	*!*				Replace mpend.acgroup   With   mact.scode
*!*	*!*				Replace mpend.svoucher  With   svou
*!*	*!*				Replace mpend.Name      With   mact.parnam
*!*	*!*				wCrAmt=wCrAmt+fledBal.Amount
*!*	*!*				vou=vou+5
*!*	*!*				svou=svou+5
*!*	*!*				Sele fledBal
*!*	*!*				Skip
*!*	*!*			Enddo
*!*	*!*			sele mpend
*!*	*!*			BROW
*!*	*!*			Sele mslip
*!*	*!*			Repl voucher  With vou+5
*!*	*!*			Repl svoucher With svou+5
*!*	*!*		endif
*!*	*!*		repl mact.opning with -(wCrAmt)
*!*	*!*		repl mact.balance with -(wCrAmt)
*!*		Sele msup
*!*		Seek 'ORDER   ' + '  7' +  mact.ordno
*!*		Append Blank
*!*		Repl aliase With 'ORDER   '
*!*		Repl Type With 'F'
*!*		Repl lcode With mact.ordno
*!*		Repl sno With 7
*!*		Repl pcode With 15
*!*		Repl remark With Subs(remark,1,32)+"DEF"+Iif(Substr(mact.gstno,1,2)='  ',mstatecode,Subs(mact.gstno,1,2))+Substr(remark,42)
*!*		If mstatecode#Subs(mact.gstno,1,2) And !Empty(Subs(mact.gstno,1,2))
*!*			Append Blank
*!*			Repl aliase With 'LBTDETAI'
*!*			Repl Type With 'F'
*!*			Repl lcode With mact.ordno
*!*			Repl Heading With 'L            ON          '
*!*		Endif
*!*		Sele fact
*!*		Skip
*!*	Enddo
*!*	************** customer transfer
*!*	Sele fcust
*!*	Go Top
*!*	Do While !Eof()
*!*		wgrp=''
*!*		do case
*!*			case fcust.GroupCode=1
*!*			wgrp='C6'
*!*			case fcust.GroupCode=6
*!*			wgrp='C1'
*!*			case fcust.GroupCode=8 OR fcust.GroupCode=9
*!*		endcase
*!*		Sele mact
*!*		Append Blank
*!*		Repl mact.ordno With Allt(Str(Recno()))
*!*		repl mact.fax2 with alltri(str(fcust.retlcode))
*!*		Repl mact.scode With wgrp  &&acount group code
*!*		Repl mact.parnam  With allt(Upper(fcust.NAME))
*!*		Repl mact.mailnam With substr(allt(fcust.name)+space(30),1,30)+subst(allt(fcust.Place),15)
*!*		Repl mact.paradd With allt(fcust.add1)
*!*		Repl mact.paradd1 With allt(fcust.add2)
*!*		sele fdist
*!*		seek fcust.DistCode
*!*		if found()
*!*			if !empty(allt(fcust.place))
*!*				Repl mact.paradd2 With allt(fcust.place)+', '+allt(fdist.District)
*!*			else
*!*				Repl mact.paradd2 With allt(fdist.District)
*!*			endif
*!*		else
*!*			Repl mact.paradd2 With allt(fcust.place)
*!*		endif
*!*		Repl mact.area With ''
*!*		Repl mact.price With 'A'
*!*		Repl mact.rate With 'Y'
*!*		Repl mact.Status With 'Y'
*!*		Repl mact.adhed With 'Discount'
*!*		Repl mact.itno With ''
*!*		Repl mact.sthed With  'TIN No.'
*!*		Repl mact.csthed With 'CST No.'
*!*		Repl mact.gsthed With 'GSTIN'
*!*		if len(allt(fcust.email))=15 
*!*			Repl mact.gstno with allt(fcust.email)
*!*		endif
*!*		Repl mact.cstno With iif(len(allt(fcust.email))#15,allt(fcust.email),'')  &&Strtran(fcust.vcinno,CHR(0),'')
*!*		Repl mact.stno With '' &&Strtran(fcust.vcinno,CHR(0),'')
*!*		if !empty(fcust.dlno1)
*!*			Repl mact.dlno With allt(fcust.dlno1)+','+allt(fcust.dlno2)
*!*		endif
*!*		Repl mact.dsm With allt(fcust.pin)
*!*		Repl mact.phone1 With allt(fcust.phone)
*!*		*Repl mact.phone2 With fcust.phone1
*!*		*Repl mact.phone3 With fcust.phone2
*!*		Repl mact.phone4 With allt(fcust.phone)
*!*		Repl mact.city with substr(allt(fcust.place),1,at('-',allt(fcust.Place))-1)
*!*		Repl mact.ref With 'Mr.'
*!*		Repl mact.Confir With ''
*!*		*area
*!*		sele farea
*!*		seek fcust.areacode
*!*		if found()
*!*			sele mpcm
*!*			Seek 'AREA  ' + Left(farea.Area,15) 
*!*			If !Found()
*!*				Append Blank
*!*				Repl sgcode With 'AREA  '
*!*				Repl scode  With 'A'+Allt(Str(recno()))
*!*				Repl parnam  With Substr(Upper(allt(farea.Area)),1,15)
*!*				Repl sname With Substr(Upper(Allt(farea.Area))+Space(40),1,40)
*!*			Endif
*!*			Repl mact.area With mpcm.scode
*!*		endif
*!*		*** Balance Calculate
*!*		sele fledBal
*!*		seek fcust.Retlcode		
*!*		if found()
*!*			store 0 to wDrAmt
*!*			Sele mslip
*!*			Go Top
*!*			vou =voucher  + 10
*!*			svou=svoucher + 10
*!*			do while fledBal.Expcode=fcust.Retlcode 
*!*				Sele mpend
*!*				Appe Blank
*!*				Replace mpend.ord       With   mact.ordno
*!*				Replace mpend.ddate     With   fledBal.Date
*!*				Replace mpend.invtype   With   "O"
*!*				Replace mpend.vcn       With   iif(isnull(fledBal.BillNo),'',allt(str(fledBal.BillNo)))
*!*				Replace mpend.voucher   With   vou
*!*				Replace mpend.Final     With   iif(isnull(fledbal.amount),0,iif(fledBal.Credit=0 and fledBal.debit>0,fledBal.Amount,-(fledBal.Credit)))
*!*				Replace mpend.balance   With   iif(isnull(fledbal.amount),0,iif(fledBal.Credit=0 and fledBal.debit>0,fledBal.Amount,-(fledBal.Credit)))
*!*				Replace mpend.duedate   With   fledBal.Date
*!*				Replace mpend.acgroup   With   mact.scode
*!*				Replace mpend.svoucher  With   svou
*!*				Replace mpend.Name      With   mact.parnam
*!*				wDrAmt=wDrAmt+iif(fledBal.Credit=0 and fledBal.debit>0,fledBal.Amount,-(fledBal.Credit))
*!*				vou=vou+5
*!*				svou=svou+5
*!*				Sele fledBal
*!*				Skip
*!*			Enddo
*!*			Sele mslip
*!*			Repl voucher  With vou+5
*!*			Repl svoucher With svou+5
*!*		endif
*!*		repl mact.opning with iif(isnull(wDrAmt),0,wDrAmt)
*!*		repl mact.balance with iif(isnull(wDrAmt),0,wDrAmt)

*!*		Sele msup
*!*		Seek 'ORDER   ' + '  7' +  mact.ordno
*!*		Append Blank
*!*		Repl aliase With 'ORDER   '
*!*		Repl Type With 'F'
*!*		Repl lcode With mact.ordno
*!*		Repl sno With 7
*!*		Repl pcode With 15
*!*		Repl remark With Subs(remark,1,32)+"DEF"+Iif(Substr(mact.gstno,1,2)='  ',mstatecode,Subs(mact.gstno,1,2))+Substr(remark,42)
*!*		If mstatecode#Subs(mact.gstno,1,2) And !Empty(Subs(mact.gstno,1,2))
*!*			Append Blank
*!*			Repl aliase With 'LBTDETAI'
*!*			Repl Type With 'F'
*!*			Repl lcode With mact.ordno
*!*			Repl Heading With 'L            ON          '
*!*		Endif
*!*		Sele fcust
*!*		Skip
*!*	Enddo
*!*	Close Tables All
*!*	*Return
*!*	*** STOCK TRANSFER
*!*	sele sele(1) 
*!*	use &datatransferpath\stock alias fsbal
*!*	sele sele(1) 
*!*	use &datatransferpath\proddata alias fitm
*!*	Sele Sele(1)
*!*	Use &datdev\pro.&datext alia mitm
*!*	index on name to mitm
*!*	Sele Sele(1)
*!*	Use &datdev\probat.&datext alia msbal

*!*	sele fsbal
*!*	Do while not eof()
*!*		sele mitm
*!*		seek substr(allt(str(fsbal.prodcode))+space(10),1,10)
*!*		if !found()
*!*			sele fsbal
*!*			skip
*!*			loop
*!*		endif
*!*		sele msbal
*!*		Append Blank
*!*		Repl msbal.Date With firstdate-1
*!*		Repl msbal.ratea With fsbal.sprice
*!*		Repl msbal.prate With fsbal.pprice
*!*		Repl msbal.mrp With fsbal.mrp
*!*		Repl msbal.rateb With val(fsbal.supp)
*!*		Repl msbal.batchno With fsbal.Batchno
*!*		wexdt='28/'+left(fsbal.expdate,2)+'/20'+substr(fsbal.expdate,4,2)
*!*		Repl msbal.exp With ctod(wexdt)
*!*		
*!*		Repl msbal.opening WITH fsbal.stock
*!*		Repl msbal.o_a WITH fsbal.stock
*!*		Repl msbal.BALANCE WITH fsbal.stock
*!*		Repl msbal.B_a WITH fsbal.stock
*!*		Repl msbal.Code With mitm.Code
*!*		Repl msbal.Name With mitm.Name
*!*		Repl msbal.billname With mitm.billname
*!*		Repl msbal.Product With mitm.Product
*!*		Repl msbal.Pack With mitm.Pack
*!*		Repl msbal.unit2 With mitm.unit2
*!*		Repl msbal.unit With mitm.unit
*!*		Repl msbal.Decimal With 'Y'
*!*		Repl msbal.MISC1 With mitm.gcode
*!*		Repl msbal.mycode With mitm.rackno
*!*		Repl msbal.BSALTAX With mitm.saltax
*!*		Repl msbal.cgst With mitm.cgst
*!*		Repl msbal.igst With mitm.igst
*!*		sele fsbal
*!*		skip
*!*	enddo
*!*	close table all
************************************************************
proc rem_null
curfield = afields(arr)
for imarg = 1 to curfield
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

&&EOF : 
