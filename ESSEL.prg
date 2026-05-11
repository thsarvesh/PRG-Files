*!*	BOF :ESSAL MDB MASTER WHOLESALE(AREA AP).PRG .....Nivedan Sharma
Clear
Close Data
Set Talk Off
Set Date To brit
Set Cent On
Set Dele On
Set Safe Off
if type('FINALCP')='U'
	firstdate=Ctod('01/04/2023')
	lastdate= Ctod('31/03/2024')
	datdev='d:\transfer\'
	datext= 'DBF'
endif
datatransferpath=Subs('D:\DM\Mar\Essel\dbf\'+Space(100),1,100)
datatransferext='DBF'
datatransfersql='No '
datatransfermdb='No '
old_3 = 'YES'
old_4 = 'Yes'
old_5 = firstdate
old_6 = lastdate
softtype='Wholesale'
old_7 = 'G'
old_8 = '#'
mstatecode='37'
sure='SURE'
datatype1='SQL'
mrgmdbfile=Space(100)
mrgmdbpwd=Space(30)
removenull='No '

@05,10 Say 'Convert DBF From MDB  :' Font 'Courier',18 Get datatransfermdb  Pict '@m No ,Yes'  Font 'COURIER',18
@06,10 Say 'ESSAL mdb to Dbf Path :' Font 'Courier',18 Get datatransferpath     Font 'Courier',18
Read
If datatransfermdb='Y'
	=mdbsqlconvert(1,Alltrim(datatransferpath))
Endif
Clear
Close Data
@ 02,22 Say 'Piping Essal(wholesale) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 To 21,115 Doub
@ 05,10 Say 'ESSAL Data Path      :' Font 'Courier',14  Get datatransferpath  Font 'courier',11
@ 06,10 Say 'ESSAL Extension      :' Font 'Courier',14  Get datatransferext  Font 'courier',11
@ 07,10 Say 'With Outstanding Y/N :' Font 'Courier',14  Get old_3 Pict '@^m YES,NO '  Font 'Courier',11
@ 08,10 Say 'Yes-Master           :' Font 'Courier',14  Get old_4 Pict '@^m Yes'  Font 'Courier',11
@ 09,10 Say 'F.Y.BEGIN Date       :' Font 'Courier',14  Get old_5  Font 'Courier',11
@ 10,10 Say 'F.Y.End   Date       :' Font 'Courier',14  Get old_6   Font 'Courier',11
@ 11,10 Say 'State Code           :' Font 'Courier',14  Get mstatecode Font 'Courier',11
@ 12,10 Say 'Wholesale            :' Font 'Courier',14  Get softtype Pict '@m Wholesale   '   Font 'Courier',11
@ 13,10 Say 'VAT/GST              :' Font 'Courier',14  Get old_7 Pict '@m V,G ' Font 'Courier',11
@ 14,10 Say 'Removenull           :' Font 'Courier',18  Get removenull Pict '@^ No ,Yes'   Font 'Courier',11
@ 16,10 Say 'Type SURE            :' Font 'courier',14  Get sure Pict '@x!' Font 'courier',11

Read
Clear
Close Data
If removenull='Y'
	Clear
	@05,10 Say 'Removing Null Values..Please Wait......' Font 'courier',14
	totfiles=Adir(fhandle,datatransferpath+'*.dbf')
	For cfile = 1 To totfiles
		Use datatransferpath+fhandle(cfile,1)
		If Reccount()>0
			Do rem_null
		Endif
	Next
Endif

datatransferpath=Alltrim(datatransferpath)
If !Right(datatransferpath,1)='\'
	datatransferpath=Alltrim(datatransferpath)+'\'
Endif
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datdev= Alltrim (datdev)
If !Dire(datatransferpath)
	Md &datatransferpath
Endif


If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
if type('FINALCP')#'U'
	=starttransfer()
endif
rowno=5

@ 02,22 Say 'Please Wait Importing ESSAL WHOLESALE Data To Marg.....' Font 'Arial',14 Colo 'W+/G'

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

If old_4='Y'
	Do margA
Else
	Do margA
Endif

Proc margA
Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer PRODUCT"
fd=datatransferpath+'items.dbf'
fx=datatransferpath+'item_grp.dbf'
ts=datdev+'\support.'+datext
td=datdev+'\pro.'+datext

Sele Sele(1)
Use datdev+'\saletype.'+datext Alias mpcm
Dele All For sgcode='COMMCD'
Pack
Inde On sgcode+parnam+Str(igst,5,2)To mpcm

Sele c
Use &ts Alias msup
Index On aliase + Str(sno,3) + Str(pcode,9) To msup
Dele All For aliase = 'PRODUCT '
Pack

Sele a
Use &fd Alias fitm
Index On Str(item_id,9) To fitm
Sele d
Use &fx Alias fitd
Index On Str(item_id,9) To fitd
Sele b
Use &td Alias mitm
Zap
Index On Name To mitm
Sele fitd
Go Top
Do While .Not. Eof()
	Last=Recno()
	Sele fitm
	Seek Str(fitd.item_id,9)

	Sele mitm
	Append Blank
	Repl mitm.Code With fitd.ic_id
	Repl mitm.Name With fitm.item_code
	Repl mitm.Product With Upper(fitm.item_name)
	Repl mitm.packing With Upper(fitd.item_pack)
	Repl mitm.billname With Upper(Alltrim(fitm.item_name)) +'  '+ Upper(Alltrim(fitd.item_pack))
	Repl mitm.unit With 'Pcs'
	*  repl mitm.pack with iif(fitm.packing=1,0,iif(fitm.packing>=1000,999,fitm.packing))
	Repl mitm.gcode With Str(fitd.grp_id,6)
	*  repl mitm.rackno with fitd.rack_number
	Repl mitm.taxl With Iif(fitd.tot=0,'E','T')
	Repl mitm.taxc With 'T'
	Repl mitm.Decimal With 'Y'
	Repl mitm.salfix With 'N'
	Repl mitm.minimum With fitd.min_stock
	Repl mitm.maximum With fitd.max_stock
	Repl mitm.formulano With Substr(formulano,1,25)+Str(fitd.discount,5,2)+Substr(formulano,31,100)
	Repl mitm.halfsche With 'A'
	Repl mitm.qtrsche With 'Y'

	If old_7='G'
		*repl mitm.salsc with 0
		Repl mitm.saltax With fitd.sgst
		*repl mitm.pursc with fitd.pctax
		Repl mitm.purtax With fitd.sgst
		Repl mitm.cgst With fitd.cgst
		Repl mitm.igst With fitd.gst
	Else
		*repl mitm.salsc with 0
		Repl mitm.saltax With fitd.sgst
		*repl mitm.pursc with fitd.pctax
		Repl mitm.purtax With fitd.sgst
	Endi
	Repl mitm.purdis With Iif(fitd.pdtype='P',fitd.pdrate,0)
	Repl mitm.purexi With Iif(fitd.petype='A',fitd.pexcise,0)

	**Rates
	Repl mitm.lprate With fitd.prate
	Repl mitm.prate With fitd.pgrate
	Repl mitm.ratea With fitd.sgrate
	Repl mitm.rateb With fitd.ptr
	Repl mitm.mrp With fitd.mrp
	Repl mitm.Status With 'Y'

	Sele msup
	Seek 'PRODUCT ' + '  1' +  Str(mitm.Code,9)
	Append Blank
	Repl aliase With 'PRODUCT '
	Repl Type With 'F'
	Repl pcode With mitm.Code
	*  repl heading with substr(msup.heading,1,17)+str(fitm.ped,5,2)+substr(msup.heading,23,100)

	&&----------------------------------------------------------------------------------------
	&&&& Hsn transfer
	Sele mpcm
	Seek 'COMMCD'+Subst(fitd.hsncode+Space(15),1,15)+Str(mitm.igst,5,2)
	If !Foun()
		Appen Blank
		Repl mpcm.sgcode With 'COMMCD'
		Repl mpcm.scode With 'H'+Alltri(Str(Last))
		Repl mpcm.sname With Subst(fitd.hsncode+Space(15),1,15)+Subst(fitd.hsncode,1,15)+''+Str(mitm.igst,5,2)
		Repl mpcm.parnam With Subst(fitd.hsncode,1,15)
		Repl mpcm.tax With mitm.saltax
		Repl mpcm.cgst With mitm.cgst
		Repl mpcm.igst With mitm.igst
		Repl mpcm.tcode With 'No'
	Endi
	Repl mitm.gcode6 With mpcm.scode

	Sele fitd
	Skip
Enddo
Close Table All

Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer COMPANY"
fd=datatransferpath + 'groups.dbf'
td=datdev+ '\saletype.'+datext
ts=datdev+ '\support.'+datext
Sele c
Use &ts Alias mstp
Index On aliase + lcode To mstp
Dele All For aliase = 'PROGRSTP'
Pack
Sele a
Use &fd Alias fpcm
Sele b
Use &td Alias mpcm
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
		mpcm.scode  With Str(fpcm.grp_id,6),;
		mpcm.sname  With Upper(fpcm.grp_name),;
		mpcm.parnam With Upper(fpcm.grp_name),;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele mstp
	Append Blank
	Repl Type With 'F'
	Repl lcode With Str(fpcm.grp_id,6)
	Repl aliase With 'PROGRSTP'
	Repl Heading With Str(fpcm.grp_excise,5,2)+Substr(Heading,6,100)
	**WholeSale Discount ==> ws_discoun
	**Retail    Discount ==> rs_discoun
	Sele fpcm
	Skip
Enddo
Close Table All



Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer AREA"
fd=datatransferpath + 'areas.dbf'
td=datdev+ '\saletype.'+datext
Sele a
Use &fd Alias fpcm
Sele b
Use &td Alias mpcm
Set Filt To sgcode='AREA  '
Dele All
Pack
Index On scode To mpcm

Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'AREA  ',;
		mpcm.scode  With Str(fpcm.area_no,6),;
		mpcm.sname  With Upper(fpcm.area_name),;
		mpcm.parnam With Upper(fpcm.area_name),;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele fpcm
	Skip
Enddo
Close Table All
Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer Party/Company Discount Master"
fd=datatransferpath +'dis_structure.dbf'
td=datdev+'\rate.'+datext
ti=datdev+'\pro.'+datext

Sele c
Use &ti Alias mpro
Index On rackno To mpro
Sele a
Use &fd Alias fpcm
Set Filt To Empty(ic_id) .And. .Not. Empty(grp_id)
Sele b
Use &td Alias mpcm
Zap

Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.pcode With Str(fpcm.accmst_naccno,6),;
		mpcm.gcode With Str(fpcm.grp_id,6)
	If fpcm.ws_discount#0
		Repl mpcm.disc1 With fpcm.ws_discount
	Endif
	If fpcm.rs_discount#0
		Repl mpcm.disc1 With fpcm.rs_discount
	Endif
	Sele fpcm
	Skip
Enddo
Close Table All
Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Party/Product Discount Master"
fd=datatransferpath +'dis_structure.dbf'
td=datdev+'\rate.'+datext
ti=datdev+'\pro.'+datext

Sele c
Use &ti Alias mpro
Index On rackno To mpro
Sele a
Use &fd Alias fpcm
Set Filt To .Not. Empty(ic_id)
Sele b
Use &td Alias mpcm

Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.pcode With Str(fpcm.accmst_NAC,6),;
		mpcm.Code With fpcm.ic_id
	If fpcm.ws_discoun#0
		Repl mpcm.disc1 With fpcm.ws_discoun
	Endif
	If fpcm.rs_discoun#0
		Repl mpcm.disc1 With fpcm.rs_discoun
	Endif
	Sele fpcm
	Skip
Enddo
Close Table All

Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer BATCH HISTORY"
ft=datatransferpath + 'ttypes.dbf'
fd=datatransferpath + 'doc_header.dbf'
fz=datatransferpath + 'stock_recd.dbf'

sele sele(1)
use &datatransferpath\stock_delv alia stkisue
index on str(ic_id,9)+ str(Recd_Id,9) to stkisue

td=datdev+ '\probat.'+datext
mi=datdev+ '\pro.'+datext
Sele Sele(1)
Use &datdev\Support.&datext Alias Support  &&inde &datdev\&datext.supp

Sele j
Use &ft Alias ftyp
Index On Str(tid,9) To ftyp

Sele a
Use &fd Alias fsbal
index on doc_id to fsbal
Sele d
Use &fz Alias fsbad
Index On Str(doc_id,9) To fsbad

Sele b
Use &mi Alias mitm
Index On Str(Code,9) To mitm
Sele c
Use &td Alias msbal
Zap
Index On Str(Code,9) + batchno To msbal
r=0
Sele fsbad 
Go Top
Do While .Not. Eof()
	Sele mitm
	Seek Str(fsbad.ic_id,9)
	Sele msbal
	Seek Str(fsbad.ic_id,9) + Substr(fsbad.Batch+Space(12),1,12)
	If !Found()
		Append Blank
		Repl msbal.Code With mitm.Code,;
			msbal.Name With mitm.Name,;
			msbal.billname With mitm.billname,;
			msbal.Product With mitm.Product,;
			msbal.Pack With mitm.Pack,;
			msbal.unit2 With mitm.unit2,;
			msbal.unit With mitm.unit,;
			msbal.Decimal With 'Y',;
			msbal.batchno With fsbad.Batch,;
			msbal.Exp With fsbad.exp_date,;
			msbal.misc1 With mitm.gcode
		**Purcfhase Deal
		If Len(Alltrim(fsbad.Scheme)) > 1
			px  =At('+',fsbad.Scheme)
			pdq = Val(Substr(fsbad.Scheme,1,px-1))
			pdf = Val(Substr(fsbad.Scheme,px+1,10))
		Else
			pdq = 0
			pdf = 0
		endif
		select fsbal
		seek fsbad.recd_id
		=found()
		select msbal
		Repl msbal.supcode With Alltrim(Str(fsbad.RECD_id,6)),;
			msbal.purdis With Iif(fsbad.pdtype='P',fsbad.pdrate,0),;
			msbal.purexi With Iif(fsbad.petype='A',fsbad.pexcise,0)
		If pdq#0 .And. pdf#0
			Repl msbal.purdeal With pdq
			Repl msbal.purfree With pdf
		Endif
		Repl msbal.lprate With fsbad.prate,;
			msbal.prate With fsbad.pgrate,;
			msbal.ratea With fsbad.sgrate,;
			msbal.rateb With 0,;
			msbal.ratec With 0,;
			msbal.mrp With fsbad.mrp
		Repl msbal.misc1 With mitm.gcode
		Repl msbal.SupInvo With fsbal.supp_billn
		Repl msbal.supdat With fsbal.supp_billd
		Repl msbal.supcode With Str(fsbal.dochead_na,6)
		repl msbal.qty with fsbad.recd_id
		If fsbad.sale_type = 0
			Repl msbal.tqty With msbal.tqty + (fsbad.bill_qty+fsbad.bill_free-fsbad.bla_qty-fsbad.bla_free)
		Endif
			select stkisue
			Seek str(fsbad.ic_id,9)+str(fsbad.recd_id,9)
			sqty=0
			scan while str(ic_id,9)+ str(Recd_Id,9)= str(fsbad.ic_id,9)+ str(fsbad.Recd_Id,9)
				sqty=sqty+stkisue.bill_qty+stkisue.bill_free
			endscan
			select msbal
		Repl msbal.opening With (fsbad.bill_qty + fsbad.bill_free)-sqty,;
			msbal.balance With msbal.opening,;
			msbal.o_a With msbal.opening,;
			msbal.b_a With msbal.opening

			
	else
			select stkisue
			Seek str(fsbad.ic_id,9)+str(fsbad.recd_id,9)
			sqty=0
			scan while str(ic_id,9)+ str(Recd_Id,9)= str(fsbad.ic_id,9)+ str(fsbad.Recd_Id,9)
				sqty=sqty+stkisue.bill_qty+stkisue.bill_free
			endscan
			select msbal

		Repl msbal.opening With msbal.opening+((fsbad.bill_qty + fsbad.bill_free))-sqty,;
			msbal.balance With msbal.opening,;
			msbal.o_a With msbal.opening,;
			msbal.b_a With msbal.opening
	Endif
	Sele fsbad
	skip
Enddo
*!*	sele msbal
*!*	Index On str(Code,9)+str(qty,9) To msbal
*!*	sele stkisue
*!*	index on str(ic_id,9)+ str(Recd_Id,9) to stkisue

*!*	Sele msbal
*!*	scan for code=8060
*!*		sele stkisue
*!*		Seek str(msbal.code,9)+str(msbal.qty,9)
*!*	    sum stkisue.bill_qty + stkisue.bill_free to iqty while str(ic_id,9)=str(msbal.code,9) and str(Recd_Id,9)=str(msbal.qty,9)
*!*	    select msbal	
*!*			Repl msbal.opening With msbal.opening-iqty,;
*!*				msbal.balance With msbal.opening,;
*!*				msbal.o_a With msbal.opening,;
*!*				msbal.b_a With msbal.opening
*!*	endscan
*sele msbal
*repl all qty with 0

*!*	Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer BATCH HISTORY"
*!*	ft=datatransferpath + 'ttypes.dbf'
*!*	fd=datatransferpath + 'doc_header.dbf'
*!*	fz=datatransferpath + 'stock_recd.dbf'
*!*	sele sele(1)
*!*	use &datatransferpath\stock_delv alia stkisue
*!*	td=datdev+ '\probat.'+datext
*!*	mi=datdev+ '\pro.'+datext
*!*	Sele Sele(1)
*!*	Use &datdev\Support.&datext Alias Support  &&inde &datdev\&datext.supp

*!*	Sele j
*!*	Use &ft Alias ftyp
*!*	Index On Str(tid,9) To ftyp

*!*	Sele a
*!*	Use &fd Alias fsbal
*!*	Sele d
*!*	Use &fz Alias fsbad
*!*	Index On Str(doc_id,9) To fsbad

*!*	Sele b
*!*	Use &mi Alias mitm
*!*	Index On Str(Code,9) To mitm
*!*	Sele c
*!*	Use &td Alias msbal
*!*	Zap
*!*	Index On Str(Code,9) + batchno To msbal
*!*	r=0
*!*	Sele fsbal
*!*	Go Top
*!*	Do While .Not. Eof()
*!*		Sele j
*!*		Seek Str(fsbal.tt_id,9)
*!*		Sele fsbad
*!*		Seek Str(fsbal.doc_id,9)
*!*		Do While Str(fsbad.doc_id,9) = Str(fsbal.doc_id,9) .And. .Not. Eof()
*!*			Sele mitm
*!*			Seek Str(fsbad.ic_id,9)
*!*			Sele msbal
*!*			Seek Str(fsbad.ic_id,9) + Substr(fsbad.Batch+Space(12),1,12)
*!*			If .Not. Found()
*!*				Append Blank
*!*				Repl msbal.Code With mitm.Code,;
*!*					msbal.Name With mitm.Name,;
*!*					msbal.billname With mitm.billname,;
*!*					msbal.Product With mitm.Product,;
*!*					msbal.Pack With mitm.Pack,;
*!*					msbal.unit2 With mitm.unit2,;
*!*					msbal.unit With mitm.unit,;
*!*					msbal.Decimal With 'Y',;
*!*					msbal.batchno With fsbad.Batch,;
*!*					msbal.Exp With fsbad.exp_date,;
*!*					msbal.misc1 With mitm.gcode
*!*				If ((j.vouchtype = 'Purchase                                          '  .Or.;
*!*						j.vouchtype = 'OpStock                                           '  .Or.;
*!*						j.vouchtype = 'Transfer                                          ') .And. ;
*!*						j.inward = 1)
*!*					**Purcfhase Deal
*!*					If Len(Alltrim(fsbad.Scheme)) > 1
*!*						px  =At('+',fsbad.Scheme)
*!*						pdq = Val(Substr(fsbad.Scheme,1,px-1))
*!*						pdf = Val(Substr(fsbad.Scheme,px+1,10))
*!*					Else
*!*						pdq = 0
*!*						pdf = 0
*!*					Endif
*!*					Repl msbal.supcode With Alltrim(Str(fsbad.RECD_id,6)),;
*!*						msbal.purdis With Iif(fsbad.pdtype='P',fsbad.pdrate,0),;
*!*						msbal.purexi With Iif(fsbad.petype='A',fsbad.pexcise,0)
*!*					If pdq#0 .And. pdf#0
*!*						Repl msbal.purdeal With pdq
*!*						Repl msbal.purfree With pdf
*!*					Endif
*!*					Repl msbal.lprate With fsbad.prate,;
*!*						msbal.prate With fsbad.pgrate,;
*!*						msbal.ratea With fsbad.sgrate,;
*!*						msbal.rateb With 0,;
*!*						msbal.ratec With 0,;
*!*						msbal.mrp With fsbad.mrp
*!*				Endif
*!*				If fsbad.sale_type = 0
*!*					Repl msbal.tqty With (fsbad.bill_qty+fsbad.bill_free-fsbad.bla_qty-fsbad.bla_free)
*!*				Else	
*!*				Endif
*!*			Else
*!*				If ((j.vouchtype = 'Purchase                                          '  .Or.;
*!*					j.vouchtype = 'OpStock                                           '  .Or.;
*!*					j.vouchtype = 'Transfer                                          ') .And. j.inward = 1)

*!*					**Purcfhase Deal
*!*					If Len(Alltrim(fsbad.Scheme)) > 1
*!*						px  =At('+',fsbad.Scheme)
*!*						pdq = Val(Substr(fsbad.Scheme,1,px-1))
*!*						pdf = Val(Substr(fsbad.Scheme,px+1,10))
*!*					Else
*!*						pdq = 0
*!*						pdf = 0
*!*					Endif
*!*					Repl msbal.supcode With Str(fsbad.RECD_id,6),;
*!*						msbal.purdis With Iif(fsbad.pdtype='P',fsbad.pdrate,0),;
*!*						msbal.purexi With Iif(fsbad.petype='A',fsbad.pexcise,0)
*!*					If pdq#0 .And. pdf#0
*!*						Repl msbal.purdeal With pdq
*!*						Repl msbal.purfree With pdf
*!*					Endif
*!*					Repl msbal.lprate With fsbad.prate,;
*!*						msbal.prate With fsbad.pgrate,;
*!*						msbal.ratea With fsbad.sgrate,;
*!*						msbal.mrp With fsbad.mrp,;
*!*						msbal.rateb With 0,;
*!*						msbal.ratec With 0
*!*				Endif
*!*				Repl msbal.misc1 With mitm.gcode
*!*				Repl msbal.SupInvo with fsbal.supp_billn
*!*				Repl msbal.supdat with fsbal.supp_billd
*!*				Repl msbal.supcode with str(fsbal.dochead_na,6)
*!*				If fsbad.sale_type = 0
*!*					Repl msbal.tqty With msbal.tqty + (fsbad.bill_qty+fsbad.bill_free-fsbad.bla_qty-fsbad.bla_free)
*!*				Else
*!*				Endif
*!*			Endif
*!*			Sele fsbad
*!*			Skip
*!*		Enddo


*!*		Sele fsbal
*!*		Skip
*!*	Enddo
*!*	** stock issue less  ***********************************************
*!*	*!*	sele stkisue
*!*	*!*	scan 
*!*	*!*		Sele mitm
*!*	*!*		Seek Str(stkisue.ic_id,9)
*!*	*!*		Sele msbal
*!*	*!*		Seek Str(stkisue.ic_id,9) + Substr(stkisue.Batch+Space(12),1,12)
*!*	*!*		If .Not. Found()
*!*	*!*			Append Blank
*!*	*!*			Repl msbal.Code With mitm.Code,;
*!*	*!*				msbal.Name With mitm.Name,;
*!*	*!*				msbal.billname With mitm.billname,;
*!*	*!*				msbal.Product With mitm.Product,;
*!*	*!*				msbal.Pack With mitm.Pack,;
*!*	*!*				msbal.unit2 With mitm.unit2,;
*!*	*!*				msbal.unit With mitm.unit,;
*!*	*!*				msbal.Decimal With 'Y',;
*!*	*!*				msbal.batchno With fsbad.Batch,;
*!*	*!*				msbal.Exp With fsbad.exp_date,;
*!*	*!*				msbal.misc1 With mitm.gcode
*!*	*!*				Repl msbal.misc1 With mitm.gcode
*!*	*!*				*Repl msbal.SupInvo with fsbal.supp_billn
*!*	*!*				*Repl msbal.supdat with fsbal.supp_billd
*!*	*!*				*Repl msbal.supcode with str(fsbal.dochead_na,6)
*!*	*!*				*If fsbad.sale_type = 0
*!*	*!*		

*!*	*!*	edscan

*!*	Sele msbal
*!*	Scan

*!*		Sele Support
*!*		Append Blank
*!*		Repl Type With "#",aliase With "DAT/F-BT",lcode With "ESSLTF",pcode With msbal.Code,;
*!*			heading With msbal.batchno ,Value With msbal.tqty


*!*	Endscan


*!*	Sele msbal
*!*	Repl All Date With old_5-1 For balance = 0
*!*	Close Table All
*!*	Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer BATCH "
*!*	fd=datatransferpath + 'doc_header.dbf'
*!*	fz=datatransferpath + 'stock_recd.dbf'
*!*	td=datdev+ '\probat.'+datext
*!*	mi=datdev+ '\pro.'+datext
*!*	Sele a
*!*	Use &fd Alias fsbal
*!*	Sele d
*!*	Use &fz Alias fsbad
*!*	Index On Str(doc_id,9) To fsbad

*!*	Sele b
*!*	Use &mi Alias mitm
*!*	Index On Str(Code,9) To mitm
*!*	Sele c
*!*	Use &td Alias msbal
*!*	Index On Str(Code,9) + batchno To msbal
*!*	r=0
*!*	Sele fsbal
*!*	Set Filt To tt_id = 0
*!*	Go Top
*!*	Do While .Not. Eof()

*!*		Sele fsbad
*!*		Seek Str(fsbal.doc_id,9)
*!*		Do While Str(fsbad.doc_id,9) = Str(fsbal.doc_id,9) .And. .Not. Eof()

*!*			**Purcfhase Deal
*!*			If Len(Alltrim(fsbad.Scheme)) > 1
*!*				px  =At('+',fsbad.Scheme)
*!*				pdq = Val(Substr(fsbad.Scheme,1,px-1))
*!*				pdf = Val(Substr(fsbad.Scheme,px+1,10))
*!*			Else
*!*				pdq = 0
*!*				pdf = 0
*!*			Endif


*!*			Sele mitm
*!*			Seek Str(fsbad.ic_id,9)


*!*			Sele msbal
*!*			Seek Str(fsbad.ic_id,9) + Substr(fsbad.Batch+Space(12),1,12)
*!*			If .Not. Found()
*!*				Append Blank
*!*				Repl msbal.Code With mitm.Code,;
*!*					msbal.Name With mitm.Name,;
*!*					msbal.billname With mitm.billname,;
*!*					msbal.Product With mitm.Product,;
*!*					msbal.Pack With mitm.Pack,;
*!*					msbal.unit2 With mitm.unit2,;
*!*					msbal.unit With mitm.unit,;
*!*					msbal.Decimal With 'Y',;
*!*					msbal.batchno With fsbad.Batch,;
*!*					msbal.Exp With fsbad.exp_date,;
*!*					msbal.lprate With fsbad.prate,;
*!*					msbal.prate With fsbad.pgrate,;
*!*					msbal.ratea With fsbad.sgrate,;
*!*					msbal.rateb With 0,;
*!*					msbal.ratec With 0,;
*!*					msbal.mrp With fsbad.mrp,;
*!*					msbal.misc1 With mitm.gcode,;
*!*					msbal.supcode With '',;
*!*					msbal.purdis With Iif(fsbad.pdtype='P',fsbad.pdrate,0),;
*!*					msbal.purexi With Iif(fsbad.petype='A',fsbad.pexcise,0)
*!*				If pdq#0 .And. pdf#0
*!*					Repl msbal.purdeal With pdq
*!*					Repl msbal.purfree With pdf
*!*					Repl msbal.deal With pdq
*!*					Repl ms.bal.Free With pdf
*!*				Endif
*!*				If fsbad.sale_type = 0
*!*					Repl msbal.opening With (fsbad.bill_qty + fsbad.bill_free),;
*!*						msbal.balance With (fsbad.bill_qty + fsbad.bill_free),;
*!*						msbal.o_a With (fsbad.bill_qty + fsbad.bill_free),;
*!*						msbal.b_a With (fsbad.bill_qty + fsbad.bill_free)
*!*				Else
*!*					Repl msbal.o_y With (fsbad.bill_qty + fsbad.bill_free),;
*!*						msbal.b_y With (fsbad.bill_qty + fsbad.bill_free)
*!*				Endif
*!*			Else
*!*				Repl msbal.lprate With fsbad.prate,;
*!*					msbal.prate With fsbad.pgrate,;
*!*					msbal.ratea With fsbad.sgrate,;
*!*					msbal.mrp With fsbad.mrp,;
*!*					msbal.rateb With 0,;
*!*					msbal.ratec With 0,;
*!*					msbal.mrp With fsbad.mrp,;
*!*					msbal.misc1 With mitm.gcode,;
*!*					msbal.supcode With Str(fsbad.RECD_id,6),;
*!*					msbal.purdis With Iif(fsbad.pdtype='P',fsbad.pdrate,0),;
*!*					msbal.purexi With Iif(fsbad.petype='A',fsbad.pexcise,0)
*!*				If pdq#0 .And. pdf#0
*!*					Repl msbal.purdeal With pdq
*!*					Repl msbal.purfree With pdf
*!*					Repl msbal.deal With pdq
*!*					Repl msbal.Free With pdf
*!*				Endif
*!*				If fsbad.sale_type = 0
*!*					Repl msbal.opening With msbal.opening + (fsbad.bill_qty + fsbad.bill_free),;
*!*						msbal.balance With msbal.balance + (fsbad.bill_qty + fsbad.bill_free),;
*!*						msbal.o_a With msbal.o_a + (fsbad.bill_qty + fsbad.bill_free),;
*!*						msbal.b_a With msbal.b_a + (fsbad.bill_qty + fsbad.bill_free)
*!*				Else
*!*					Repl msbal.o_y With msbal.o_y + (fsbad.bill_qty + fsbad.bill_free),;
*!*						msbal.b_y With msbal.b_y + (fsbad.bill_qty + fsbad.bill_free)
*!*				Endif
*!*			Endif
*!*			Sele fsbad
*!*			Skip
*!*		Enddo
*!*		Sele fsbal
*!*		Skip
*!*	Enddo
*!*	Sele msbal
*!*	Repl All Date With old_5-1 For balance = 0
Close Table All


Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer ACCOUNT MASTER"
fd=datatransferpath + 'accmst.dbf'
fy=datatransferpath + 'address_master.dbf'
td=datdev+ '\order.'+datext
ts=datdev+ '\support.'+datext
tg=datdev+ '\acgroup.'+datext
Sele e
Use &tg Alias mgrp
Index On Str(budget,9) To mgrp

Sele d
Use &ts Alias msup
Index On aliase + Str(sno,3) + lcode To msup
Dele All For aliase = 'ORDER   '
Dele All For aliase = 'LBTDETAI'
Dele All For (Type='#' And aliase='DAT/F-LD')
Dele All For Substr(aliase,1,2) = '#@'
Pack

Sele a
Use &fd Alias fact
Sele c
Use &fy Alias facd
Index On Str(acccode,6) To facd

Sele b
Use &td Alias mact
Zap

Sele fact
Go Top
Do While .Not. Eof()

	Sele facd
	Seek Str(fact.accmst_NAC,6)

	Sele mact
	Append Blank
	Repl mact.rate With 'N'
	*Sundry Creditors
	If fact.accmst_cld = 'Supplier               '
		Repl mact.scode With 'D31'
		Repl mact.rate With old_3
	Else
		**Bank
		If fact.accmst_cld = 'Bank                   '
			Repl mact.scode With 'C1'
		Else
			**Cash in Hand
			If fact.accmst_cld = 'Cash                   '
				Repl mact.scode With 'C2'
			Else
				**Sundry Debtors
				If fact.accmst_cld = 'Customer               ' .Or. fact.accmst_cld = 'Customer-Supplier      '
					Repl mact.scode With 'C6'   &&iif(fact.accmst_nco#0,mgrp.ordno,'C6')
					Repl mact.rate With 'F'
				Else
					**Fixed Assets
					If fact.accmst_cld = 'Asset                  ' &&.and. fact.accmst_ngr = 2469
						Repl mact.scode With 'E'
					Else
						**Deposit & Advances (Assets)
						If fact.accmst_cld = 'Asset                  ' &&.and. fact.accmst_ngr = 2470
							Repl mact.scode With 'C4'
						Else
							**Loan (Capital Account)
							If fact.accmst_cld = 'Liability              '&& .and. fact.accmst_ngr = 2466
								Repl mact.scode With 'B'
							Else
								**Loan (Liability)
								If fact.accmst_cld = 'Liability              ' &&.and. fact.accmst_ngr = 2448
									Repl mact.scode With 'G3'
								Else
									If fact.accmst_cld = 'Expense                '
										Repl mact.scode With 'J12'
									Endif
								Endif
							Endif
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
	Repl mact.ordno With Str(fact.accmst_NAC,6)
	Repl mact.parnam  With Substr(Upper(fact.accmst_sac),1,30)+Upper(Alltrim(facd.town))
	Repl mact.paradd With Upper(Alltrim(facd.address1))
	Repl mact.paradd1 With Upper(Alltrim(facd.address2))+' '+Upper(Alltrim(facd.town))
	Repl mact.paradd2 With Upper(Alltrim(facd.district))
	Repl mact.sthed With  'TIN No.'
	Repl mact.csthed With 'CST No.'
	Repl mact.gsthed With 'GST No.'
	Repl mact.cstno With facd.vat_tinno
	Repl mact.stno With ''
	Repl mact.gstno With facd.gstno
	Repl mact.dlno With Alltrim(facd.d20b) +' * '+ Alltrim(facd.d21b)
	Repl mact.mailnam With Upper(fact.accmst_sac)
	Repl mact.ref With 'Mr.'
	Repl mact.phone1 With facd.phno1
	Repl mact.phone2 With facd.phno2
	Repl mact.phone3 With facd.cellno
	Repl mact.fax2 With fact.accmst_cod
	Repl mact.Confir With facd.personname
	Repl mact.area With Str(facd.area,6)
	Repl mact.price With 'A'
	Repl mact.city With facd.town
	Repl mact.mr With 'S'+Alltrim(Str(facd.salesman_i,5))
	Repl mact.Status With 'Y'
	Repl mact.duedays With Val(facd.crdays)
	Repl mact.limit With Val(facd.crlimit)
	Repl mact.adhed With 'Discount'
	Repl mact.addis With 0
	Repl mact.opning With Iif(fact.accmst_ccu='C',-fact.accmst_dcu,fact.accmst_dcu)
	*repl mact.balance with iif(fact.accu='C',-fact.accmst_dcu,fact.accmst_dcu)

	Sele msup
	Seek 'ORDER   ' + '  1' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 1
	Repl remark With Substr(msup.remark,1,70)+Iif(facd.mode=0,'C',Iif(facd.mode=1,'R','C'))+Substr(msup.remark,72,100)
	&& Updating State
	Sele msup
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',mstatecode,Subs(mact.gstno,1,2))+'                                           '
	&& LOCAL && CENTRAL  MARK IN LEDGER.
	Select msup
	Appe Blan
	Repl aliase With 'LBTDETAI'
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl Heading With Iif(Subs(mact.gstno,1,2)=mstatecode Or Subs(mact.gstno,1,2)='  ','   ','L            ON          ')
	Appen Blan
	Repl Type With 'F',aliase With 'ORDER',lcode With mact.ordno,sno With 12
	Repl  Heading With Iif(Len(Alltrim(mact.gstno))=0,'                00000UG  ','                00000NG  ')
	*!*	    && UPDATING SUPPORT FOR LEDGER  DIFFERENCE
	*!*		Sele msup
	*!*		Appe Blank
	*!*		Repl Type With "#",aliase With "DAT/F-LD",lcode With mact.ordno,Value With mact.balance
	Sele fact
	Skip
Endd
Close Table All
Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer SALES MAN"
fd=datatransferpath + 'salesmen.dbf'
td=datdev+ '\order.'+datext

Sele a
Use &fd Alias fact

Sele b
Use &td Alias mact

Sele fact
Go Top
Do While .Not. Eof()

	Sele mact
	Append Blank
	Repl mact.rate With 'N'
	Repl mact.scode With 'D32'
	Repl mact.ordno With 'S'+Alltrim(Str(fact.salesman_i,5)),;
		mact.parnam  With Upper(fact.salesman_n),;
		mact.paradd With Upper(fact.salesman_a)
	Sele fact
	Skip
Enddo
Close Table All
*!*	Wait Wind Nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+Chr(13)+"Transfer PARTY DISCOUNT MASTER"
*!*	fd=datatransferpath +'dis_structure.dbf'
*!*	td=datdev+'\order.'+datext
*!*	Sele a
*!*	Use &fd Alias fpcm
*!*	Set Filt To Empty(ic_id) .And. Empty(grp_id)
*!*	Sele b
*!*	Use &td Alias mpcm
*!*	Index On ordno To mpcm
*!*	Sele fpcm
*!*	Go Top

*!*	Do While .Not. Eof()
*!*		Sele mpcm
*!*		Seek Substr(Str(fpcm.accmst_naccno,6),1,6)
*!*		If Found()
*!*			If fpcm.ws_discount#0
*!*				Repl mpcm.disc1 With fpcm.ws_discount
*!*			Endif
*!*			If fpcm.rs_discount#0
*!*				Repl mpcm.disc1 With fpcm.rs_discount
*!*			Endif
*!*		Endif
*!*		Sele fpcm
*!*		Skip
*!*	Enddo
*!*	Close Table All


Func mdbsqlconvert(mdbsqlpara1,datapath)
If Empty(datapath)
	datapath=datatransferpath
Endif
newdatapath=datapath
Do Case
Case mdbsqlpara1=1
	If datatransfermdb='Y'
		mrgmdbfile=Alltrim(Getfile('mdb'))
		=mdbsqlconvert(2,datapath)
	Endif
Case mdbsqlpara1=2 And datatransfermdb='Y'
	newdatapath=datapath
	mrgmdbfile=Alltrim(mrgmdbfile)
	mrgmdbpwd='' &&alltrim(mrgmdbpwd)
	mrgexit=0
	If Empty(mrgmdbfile)
		=Messagebox("Please Enter Access File Name !!",100,'Check MDB File Path')
		mrgexit=1
	Endif
	If !File(mrgmdbfile)
		=Messagebox("Access File not found. Please Check !!",100,'Check MDB File Path')
		mrgexit=1
	Endif
	If Empty(newdatapath)
		=Messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	Endif
	If mrgexit=1
		=Messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		Return
	Endif
	lnconnhandle=0
	merrno=0
	Try
		If Empty(mrgmdbpwd)
			lnconnhandle=Sqlstringconnect('DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		Else
			lnconnhandle=Sqlstringconnect('PWD='+Trim(mrgmdbpwd)+';DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		Endif
	Catch To oexp
		merrno=1
	Endtry
	If merrno=1
		=Messagebox('Invalid MS-Access data file or invalid password.',48,'Will Quit Now')
		Retu
	Endif
	Wait Wind newdatapath+"--------0"
	If !Directo(Alltrim(newdatapath))
		Md &newdatapath
	Endif
	newdatapath=Addbs(newdatapath)
	If lnconnhandle>0
		@07,10 Say 'Converting Access File to DBF. Please Wait......' Font 'courier',16
		dvfp_tflds=0
		Sele Sele(1)
		lnresult=SQLTables(lnconnhandle,'TABLE')
		tblfnd=0
		If lnresult > 0
			Sele sqlresult
			Scan
				Try
					msqltabl=Uppe(Allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					Sele Sele(1)
					lngetdata=SQLExec(lnconnhandle,lcsqlcommand,'NEWDATA')
					If lngetdata>0
						lcdbffilenm=Allt(newdatapath)+msqltabl+'.dbf'
						lcdbffilenm=Chrtran(lcdbffilenm," "+Chr(9),"")
						Sele newdata
						Copy To &lcdbffilenm
						Wait Wind lcdbffilenm Nowait
						Use
					Endif
				Catch To oerr
					merrno=1
					=Messagebox(oerr.Message,64)
					*!*						susp
				Endtry
				If merrno=1
					*exit
				Endif
			Endscan
		Endif
		=SQLDisconnect(lnconnhandle)
		@ 16,20 Say "Access File Successfully Converted to DBF."
	Else
		=Messagebox('Unable to read from Connection',48,'Marg ')
		Retu
	Endif
	Rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	If merrno=1
		=Messagebox('Error encountered while importing data.',48)
		Retu
	Endif
	Clear
	@07,10 Say 'Removing Null Values..Please Wait......' Font 'courier',16
	totfiles=Adir(fhandle,newdatapath+'*.dbf')
	For cfile = 1 To totfiles
		Use newdatapath+fhandle(cfile,1)
		If Reccount()>0
			Do rem_null
		Endif
	Next
Case mdbsqlpara1=3
	Clear
	mrgsqlfile=Alltrim(mrgsqlfile)
	mrgsqluserid=Alltrim(mrgsqlpwd)
	mrgsqlpwd=Alltrim(mrgsqlpwd)
	datatransferpath=Alltrim(datatransferpath)
	mrgexit=0
	If Empty(mrgsqlfile)
		=Messagebox("Please Enter SQL Database Name !!",100,'Check File Name')
		mrgexit=1
	Endif
	If Empty(datatransferpath)
		=Messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	Endif
	If mrgexit=1
		=Messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		Return
	Endif
	lnconnhandle=0
	merrno=0
	Try
		lnconnhandle=Sqlstringconnect("DRIVER=Sql Server;SERVER=SANTOSH-LP\SQLEXPRESS;UID="+mrgsqluserid+";PWD="+mrgsqlpwd+";APP=Microsoft Visual FoxPro;WSID=MARG01;DATABASE="+mrgsqlfile)
	Catch To oexp
		merrno=1
	Endtry
	If merrno=1
		=Messagebox('Invalid data file or invalid password.',48,'Will Quit Now')
		Retu
	Endif
	If !Directo(datatransferpath)
		Md &datatransferpath
	Endif
	datatransferpath=Addbs(datatransferpath)
	If lnconnhandle>0
		Clear
		@07,10 Say 'Converting SQL Database to DBF. Please Wait......' Font 'courier',16
		dvfp_tflds=0
		Sele Sele(1)
		lnresult=SQLTables(lnconnhandle,'TABLE')
		tblfnd=0
		If lnresult > 0
			Sele sqlresult
			Scan
				Try
					msqltabl=Uppe(Allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					Sele Sele(1)
					lngetdata=SQLExec(lnconnhandle,lcsqlcommand,'NEWDATA')
					If lngetdata>0
						lcdbffilenm=Allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=Chrtran(lcdbffilenm," "+Chr(9),"")
						Sele newdata
						Copy To &lcdbffilenm
						Use
					Endif
				Catch To oerr
					merrno=1
					=Messagebox(oerr.Message,64)
				Endtry
				If merrno=1
					*exit
				Endif
			Endscan
		Endif
		=SQLDisconnect(lnconnhandle)
		@ 16,20 Say "SQL DataBase  Successfully Converted to DBF."

	Else
		=Messagebox('Unable to read from Connection',48,'Marg ')
		Retu
	Endif
	Rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	If merrno=1
		=Messagebox('Error encountered while importing data.',48)
		Retu
	Endif
	@04,10 Say 'Removing Null Values..Please Wait......' Font 'courier',16
	totfiles=Adir(fhandle,newdatapath+'*.dbf')
	For cfile = 1 To totfiles
		Use newdatapath+fhandle(cfile,1)
		If Reccount()>0
			Do rem_null
		Endif
	Next
Endcase


Proc rem_null
a = Afields(arr)
For imarg = 1 To a
	mfldname = arr(imarg, 1)
	Do Case
	Case Inlist(arr(imarg,2), "C","V")
		Replace All &mfldname With '' For Isnull(&mfldname)
	Case Inlist(arr(imarg,2), "B","N","I","F","Y")
		Replace All &mfldname With 0 For Isnull(&mfldname)
	Case Inlist(arr(imarg,2), "D","T")
		Replace All &mfldname With Ctod('') For Isnull(&mfldname)
	Endcase
Endfor
