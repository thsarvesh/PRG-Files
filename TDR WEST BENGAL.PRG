***BOF ||SOFTWARE NAME: TDR|| DATE 24-03-2025 || TRADE : PHARMA WHOLESALE/RETAIL|| AUTHOR : SARVESH||
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
Sele mycurs
Appe Blank
Repl  Setup With 'Item Wise Double Discount ',Value With 'Y'
Brow Font 'COURIER',18    Nomodify
IF TYPE('FINALCP')='U'
	datdev=substr('d:\transfer\'+space(80),1,80)
	datext='dbf'
	firstdate=ctod('01/04/2025')
	lastdate =ctod('31/03/2026')
ENDIF

datatransferpath=Substr('D:\MIGRATION_DATA\MAR\TDR\DATA_FILES\'+Space(100),1,100)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'Yes'
old_5 = firstdate
old_6 = lastdate
OLD_7 = 'G'
softtype='Wholesale'
scalc='9'
pcalc='2'
mstatecode='19'
sure='SURE'

Clear
Close Data
mVersion='V04'

@ 08,10 Say 'MARG Data Path       :' Font 'Courier',18  Get datdev  Font 'courier',18

@ 09,10 Say 'TDR      Data Path   :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 10,10 Say 'TDR      Extension   :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 11,10 Say 'With Outstanding Y/N :' Font 'Courier',18  Get old_3 Pict '@m YES,NO '  Font 'Courier',18
@ 12,10 Say 'No-Full Yes-Master   :' Font 'Courier',18  Get old_4 Pict '@m No,Yes'  Font 'Courier',18
@ 13,10 Say 'F.Y.BEGIN Date       :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 14,10 Say 'F.Y.End   Date       :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 15,10 Say 'G-GST  V-Vat         :' Font 'Courier',18  Get OLD_7  Font 'Courier',18
@ 16,10 Say 'Sales Calculation    :' Font 'Courier',18  Get scalc   Font 'Courier',18
@ 17,10 Say 'Purch.Calculation    :' Font 'Courier',18  Get pcalc   Font 'Courier',18
@ 18,10 Say 'Wholesale            :' Font 'Courier',18  Get softtype Pict '@m Retail   ,Wholesale'   Font 'Courier',18
@ 19,10 Say 'State Code           :' Font 'Courier',18  Get mstatecode Font 'Courier',18
*@ 21,10 Say 'Version              :' Font 'Courier',18  Get mVersion  Pict '@^ V01,V02,V03,V04' Font 'Courier',18
@ 23,10 Say 'Type SURE            :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18
Read
Clear
Close Data
datatransferpath=Alltrim(datatransferpath)
If !Right(datatransferpath,1)='\'
	datatransferpath=Alltrim(datatransferpath)+'\'
Endif
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
DATEXT= Alltrim (DATEXT)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
CodeEven=0
CodeODD=0
*=DECR_PST()
IF TYPE('FINALCP')#'U'
	=starttransfer()
ENDIF
rowno=5
@ 02,22 Say 'Please Wait Importing MediCare '+alltri(softtype)+' To Marg.....' Font 'Arial',14 Colo 'W+/G'
Set Colo To
Sele Sele(1)
Use &datdev\glmonth.&DATEXT
Zap
Use &datdev\ggmonth.&DATEXT
Zap
Use &datdev\pro.&DATEXT
Zap
Use &datdev\Order.&DATEXT
Zap
Use &datdev\saletype.&DATEXT
Zap
Use &datdev\gledger.&DATEXT
Zap
Use &datdev\pendings.&DATEXT
Zap
Use &datdev\pend.&DATEXT
Zap
Use &datdev\probat.&DATEXT
Zap
Use &datdev\maorder.&DATEXT
Zap
Use &datdev\sborder.&DATEXT
Zap
Use &datdev\mdis.&DATEXT
Zap
Use &datdev\RATE.&DATEXT
Zap
Use &datdev\dis.&DATEXT
Zap
Use &datdev\glmonth.&DATEXT
Zap
Use &datdev\ggmonth.&DATEXT
Zap
Use &datdev\Support.&DATEXT
Dele All For Type='#' And aliase='DAT/F'
Pack
Close Data
Set Colo To

*!*	@rowno,22 Say 'Importing Composition/Salt.....' Font 'Courier',14
*!*	rowno=rowno+1
*!*	Sele Sele(1)
*!*	Use &datatransferpath\composit&datatransferext   Alias slt
*!*	Sele Sele(1)
*!*	Use &datdev\saletype.&DATEXT Alias stype
*!*	Sele slt
*!*	Scan
*!*		Sele stype
*!*		Appen Blan
*!*		Repl sgcode With 'SALT'
*!*		Repl sname With slt.composite
*!*		Repl scode With Alltrim(Str(slt.Code))
*!*		Repl igst With 0
*!*	Endscan

*!*	Close Data


@rowno,22 Say 'Importing Product .....' Font 'Courier',14
rowno=rowno+1

fd=datatransferpath+'PRODUCT'+datatransferext
td=datdev+'\pro.'+DATEXT
ts=datdev+'\saletype.'+DATEXT

Sele c
Use &ts Alias mpcm
Dele All For sgcode = 'CATEGO'
Dele All For sgcode = 'COMMCD'
Dele All For sgcode = 'ZZZZZZ'
Pack
Index On sgcode + parnam + Str(igst,5,2) Tag  mpcm
Index On sgcode + sname Tag mpcm1
Sele a
Use &fd Alias fitm

Sele b
Use &td Alias mitm
Zap
Index On Name To mitm
Sele fitm
Pack
Go Top
nam = Space(30)

Do While !Eof()
	If Len(Alltrim(P_NAME))=0 Or Empty(P_name)
		Skip
		Loop
	Endif
	Last=Recno()

	nam = uppe(fitm.P_name)

	unt = Right(nam,6)			&&	decrypt(fitm->unit)
	Sele mitm
	Append Blank
	Repl mitm.Code With Last
	Repl mitm.Name With ALLTRIM(STR(LAST))
	Repl mitm.Product With (NAM)
*	Repl mitm.packing With Right(nam,6)
	Repl mitm.billname With Alltrim(NAM)
	Repl mitm.unit With 'PCS'
	Repl mitm.unit2 With 'STRP'
	Repl mitm.Pack With iif(softtype='R',fitm.packqty,0)
*	Repl rackno With fitm.rack_no
*	Repl mitm.gcode3 With Alltrim(Str(fitm.comp_code))
	Repl mitm.taxl With 'T'
	Repl mitm.taxc With 'T'
	Repl mitm.Decimal With 'Y'
	Repl mitm.salfix With 'N'
	Repl mitm.halfsche With 'A'
	Repl mitm.qtrsche With 'Y'
	Repl mitm.Status With 'Y'
	If OLD_7 = 'G'
		Repl mitm.saltax With fitm.sgst
		Repl mitm.cgst With fitm.sgst
		Repl mitm.igst With fitm.sgst*2
	Endif

	&&HSN
	Sele mpcm
	Set Order To Tag mpcm
	Seek 'COMMCD' + Substr(fitm.p_code+Space(15),1,15) + Str(mitm.igst,5,2)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'COMMCD',;
			mpcm.scode  With 'H'+Alltrim(Str(Last)),;
			mpcm.sname  With Substr(fitm.p_code+Space(15),1,15)+ Substr(fitm.p_code,1,15) +' '+ Alltrim(Str(mitm.igst,5,2)) ,;
			mpcm.parnam With fitm.p_code,;
			mpcm.tax With mitm.saltax,;
			mpcm.cgst With mitm.cgst,;
			mpcm.igst With mitm.igst,;
			mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode6 With mpcm.scode

	&&COMPANY
	Sele mpcm
	Set Order To Tag mpcm1
	Seek 'ZZZZZZ' + Substr(fitm.co_name+Space(40),1,40)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'ZZZZZZ'
		Repl mpcm.scode  With 'C'+Alltrim(Str(Last))
		Repl mpcm.sname  With fitm.co_name
		Repl mpcm.parnam With fitm.co_name
		Repl mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode With mpcm.scode

&&CATEGORY
	Sele mpcm
	Set Order To Tag mpcm1
	Seek 'CATEGO' + Substr(fitm.MAF_BY+Space(40),1,40)
	If !Found()
		Append Blank
		Repl mpcm.sgcode With 'CATEGO'
		Repl mpcm.scode  With 'G'+Alltrim(Str(Last))
		Repl mpcm.sname  With fitm.maf_by
		Repl mpcm.parnam With fitm.maf_by
		Repl mpcm.tcode With 'No'
	Endif
	Repl mitm.gcode5 With mpcm.scode

	Sele fitm
	Skip
Enddo
Close Data


@rowno,22 Say 'Importing Batch Batches  .....' Font 'Courier',14
rowno=rowno+1

fd=datatransferpath+'batch'+datatransferext
td=datdev+'\probat.'+DATEXT
mi=datdev+'\pro.'+DATEXT
sp=datdev+'\support.'+DATEXT

Sele Sele(1)
Use &sp Alias Support
Dele All For Type='#' And aliase='DAT/F-BT'
Pack

Sele a
Use &fd Alias fsbal

Sele b
Use &mi Alias mitm
Index On product To mitm
Sele c
Use &td Alias msbal
Index On Name + batchno To msbal

r=0
Sele fsbal
Go Top
Do While !Eof()
	Sele mitm
	Seek Substr(ALLTRIM(UPPER(fsbal.items))+Space(30),1,30)
	
	Sele msbal
	Seek Substr(Alltrim(mitm.name)+Space(10),1,10) + Substr(fsbal.batch_no+Space(12),1,12)
	If !Found()
		Append Blank
		Repl msbal.Code With mitm.Code
		Repl msbal.Name With mitm.Name
		Repl msbal.billname With mitm.billname
		Repl msbal.Product With mitm.Product
		Repl msbal.Pack With mitm.Pack
		Repl msbal.unit2 With mitm.unit2
		Repl msbal.unit With mitm.unit
		Repl msbal.Decimal With 'Y'
		Repl msbal.batchno With fsbal.batch_no
		Repl msbal.Exp With CTOD("01/"+ALLTRIM(fsbal.expiry_dat))
		Repl msbal.prate With fsbal.p_rate
		Repl msbal.mrp With fsbal.mrp
		Repl msbal.rateA With fsbal.t_rate
		Repl msbal.misc1 With mitm.gcode
		Repl msbal.purdis With iif(isnull(fsbal.disc),0,fsbal.disc)
		If old_4='Y'
			Repl msbal.opening With Iif(old_4='Y',(fsbal.qoh),opqoh)
			repl msbal.balance With Iif(old_4='Y',(fsbal.qoh),opqoh)
			repl msbal.o_a With Iif(old_4='Y',(fsbal.qoh),opqoh)
			repl msbal.b_a With Iif(old_4='Y',(fsbal.qoh),opqoh)
			repl msbal.tqty With (fsbal.qoh)
		Endif
	Else
		If old_4='Y'
			Repl msbal.opening With msbal.opening + Iif(old_4='Y',(fsbal.qoh),opqoh)
			repl msbal.balance With msbal.balance + Iif(old_4='Y',(fsbal.qoh),opqoh)
			repl msbal.o_a With msbal.o_a + Iif(old_4='Y',(fsbal.qoh),opqoh)
			repl msbal.b_a With msbal.b_a + Iif(old_4='Y',(fsbal.qoh),opqoh)
			repl msbal.tqty With msbal.tqty + (fsbal.qoh)
		Endif
	Endif

	Sele fsbal
	Skip
Enddo
Sele msbal
Repl Date With old_5-1 For balance=0
Sele mitm
*!*	Scan
*!*		Sele fsbal
*!*		Seek Subs(mitm.Name,1,6)
*!*		Sum cur_qty To tot While Code=Subs(mitm.Name,1,6)
*!*		Sele mitm
*!*		Repl misc6 With Str(tot,10,2)
*!*	Endscan
Close Data


@rowno,22 Say 'Importing Accounts  .....' Font 'Courier',14
rowno=rowno+1
fd=datatransferpath+'ledger'+datatransferext
fs=datatransferpath+'supplier'+datatransferext
fv=datatransferpath+'vender'+datatransferext

td=datdev+'\order.'+DATEXT
ts=datdev+'\support.'+DATEXT

Sele F
Use &ts Alias msup
Index On aliase + Str(sno,3) + lcode To msup
Dele All For aliase = 'ORDER   '
Dele All For sno=7
Dele All For (Type='#' And aliase='DAT/F-LD')
Pack

SELECT SELECT(1)
USE &fs alias supp
INDEX on v_name TO supp

SELECT SELECT(1)
USE &fv alias vend
INDEX on v_name TO vend

Sele a
Use &fd Alias fact
Sele b
Use &td Alias mact
Zap

Sele fact
Pack
Go Top
Do While .Not. Eof()
	last = RECNO()
	
	Sele mact
	Append Blank
	Repl mact.rate With 'N'
	Do Case
		Case ATC('CRED',ALLTRIM(fact.under))#0
			Repl mact.scode With 'D31'
			Repl mact.rate With old_3
		Case ATC('DEBT',ALLTRIM(fact.under)) # 0
			Repl mact.scode With 'C6'
		Case  ATC('BANK',ALLTRIM(fact.under)) # 0 Or ATC('CASH',ALLTRIM(fact.under)) # 0
			Repl scode With "C1" 
		Case ATC('PURC',ALLTRIM(fact.under)) # 0
			Repl scode With 'J5'
		Case ATC('SALES',ALLTRIM(fact.under)) # 0
			Repl scode With 'J6'
		Case ATC('ADMN.SALES & DISTRIBUTION EXP.',ALLTRIM(fact.under)) # 0
			Repl scode With 'J11'
	Endcase
	Repl mact.ordno   With Alltrim(STR(last))
	repl mact.parnam  With UPPER(fact.ledname)
	REPL mact.opning With Iif(old_4='Y',fact.closebal,fact.opbal)
	repl mact.balance With Iif(old_4='Y',fact.closebal,fact.opbal)
	if seek (fact.ledname,'supp')
		repl mact.paradd  With IIF(ATC("UNKNOWN",supp.add)=0,supp.add,"")
		repl mact.paradd1 With IIF(ATC("UNKNOWN",supp.ph_no1)=0,supp.ph_no1,"")
		repl mact.paradd2 With IIF(ATC("UNKNOWN",supp.ph_no2)=0,supp.ph_no2,"")
		REPL mact.dlno    With IIF(ATC("UNKNOWN",supp.dl_no_bio)=0,Alltrim(supp.dl_no_bio)+Alltrim(supp.dl_no_nbio),"")
		repl mact.ITNO   With IIF(ATC("UNKNOWN",supp.itn)=0,supp.itn,"")
		repl mact.gstno   With IIF(ATC("UNKNOWN",supp.vat)=0,supp.vat,"")
	endif 
	if seek(fact.ledname,'vend')
		repl mact.paradd  With IIF(ATC("UNKNOWN",vend.add)=0,vend.add,"")
		repl mact.paradd1 With IIF(ATC("UNKNOWN",vend.ph_no1)=0,vend.ph_no1,"")
		repl mact.paradd2 With IIF(ATC("UNKNOWN",vend.ph_no2)=0,vend.ph_no2,"")
		REPL mact.dlno    With IIF(ATC("UNKNOWN",vend.dl_no_bio)=0,Alltrim(vend.dl_no_bio)+Alltrim(vend.dl_no_nbio),"")
		repl mact.ITNO   With IIF(ATC("UNKNOWN",vend.itn)=0,vend.itn,"")
		repl mact.gstno   With IIF(ATC("UNKNOWN",vend.vat)=0,vend.vat,"")
	ENDIF 
	Repl mact.sthed   With  'TIN No.'
	repl mact.csthed  With 'CST  No.'
	repl mact.mailnam With fact.ledname
	repl mact.Trans With ''
	repl mact.ref With 'Mr.'
	repl mact.price With 'A'
	repl mact.Status With 'Y'
	repl mact.adhed With 'Discount'
	repl mact.GSTHED With 'GST NO'
	&& UPDATED SUPPORT FOR LEDGER  DIFFERENCE
	Sele msup
	Appe Blank
	Repl Type With "#",aliase With "DAT/F-LD",lcode With mact.ordno,Value With fact.closebal

	Sele fact
	Skip
Enddo
Close Data

*!*	@rowno,22 Say 'Importing Doctors  .....' Font 'Courier',14
*!*	rowno=rowno+1
*!*	fd=datatransferpath+'cas014'+datatransferext
*!*	td=datdev+'\maorder.'+DATEXT

*!*	Sele a
*!*	Use &fd Alias fact
*!*	Sele b
*!*	Use &td Alias mact
*!*	Zap

*!*	Sele fact
*!*	Pack
*!*	Go Top
*!*	Do While .Not. Eof()
*!*		Sele mact
*!*		Append Blank
*!*		Repl scode With 'PRE#$~'
*!*		Repl mact.ordno With fact.dr_code,;
*!*			mact.parnam  With Alltrim(fact.dr_name)+' '+Alltrim(fact.address1),;
*!*			mact.city With fact.address+fact.address1,;
*!*			form With fact.dr_code
*!*		Sele fact
*!*		Skip
*!*	Enddo
*!*	Close Data

*!*	@rowno,22 Say 'Importing PATIENT  .....' Font 'Courier',14
*!*	rowno=rowno+1

*!*	Close Database
*!*	Set Talk Off
*!*	Sele a
*!*	Use &datdev\maorder.&DATEXT
*!*	Sele b
*!*	Use &datatransferpath\CAS034
*!*	Go Top
*!*	Do While .Not. Eof()
*!*		Sele a
*!*		Appe Blank
*!*		Repl scode With "PET#$~",ordno With b->Code,parnam With b->Name,;
*!*			city With Alltrim(b->address+b->address1),Form With b->Code
*!*		Sele b
*!*		Skip
*!*	Enddo
*!*	Close Database


If old_4='N'
	Do import_transactions
Endif

Proc import_transactions
RETURN

@rowno,22 Say 'Importing Ledger Transactions .....' Font 'Courier',14
rowno=rowno+1

mdis=datdev+'\mdis.'+DATEXT
af =datdev+'\gledger.'+DATEXT
bf =datdev+'\slipno.'+DATEXT
dis=datdev+'\dis.'+DATEXT
pro=datdev+'\pro.'+DATEXT
sp=datdev+'\support.'+DATEXT
prb=datatransferpath+'cas015'+datatransferext
cf =datatransferpath+'cas003a'+datatransferext
*Sales
sal=datatransferpath+'cas004'+datatransferext
sld=datatransferpath+'cas004a'+datatransferext
*Sales Return
sgr=datatransferpath+'cas006'+datatransferext
sgl=datatransferpath+'cas006a'+datatransferext
*Purchase
pur=datatransferpath+'cas005'+datatransferext
pul=datatransferpath+'cas005a'+datatransferext
*Purchase Return
pgr=datatransferpath+'cas007'+datatransferext
pgl=datatransferpath+'cas007a'+datatransferext

Sele Sele(1)
Use &sp Alias Support
Dele All For Type='#'  And aliase="DAT/F-SL"
Pack


Sele i
Use &bf
Go Top
last4  = voucher + 10
slast5 = svoucher + 10


@rowno,22 Say 'Importing Sales  .....' Font 'Courier',14
rowno=rowno+1

last4 = last4 + 20

Sele F
Use &prb Alias prb
Index On Code + batch_no To prb
Sele e
Use &pro Alias pro
Index On Name To pro

Sele c
Use &sal Alias sal
Set Filter To (invoice_dt>=old_5 And invoice_dt<=old_6)
Sele h
Use &sld Alias sld
Index On INV_TYpE+Str(bill) To sld

Sele d
Use &mdis Alias mdis
Zap
Sele g
Use &dis Alias dis
Zap

Sele Sele(1)
Use &datdev\probat.&DATEXT Alias msbal
Index On Name+batchno To msbal
Sele c
Go Top
Do While !Eof()
	l1 = Alltrim(Str(c.invoice))
	l2 = Len(l1)
	l3 = INV_TYpE+Replicate('0',6-l2)+l1

	Sele d
	Appe Blank
	Repl Type With 'S'
	*  repl misc3 with substr(misc3,1,53)+iif(substr(c.billno_&old_9,1,1)='T','T','R')+substr(misc3,55,100)
	Repl vcn With l3
	Repl Date With c.invoice_dt
	Repl Codep With c.party_code
	Repl voucher With last4
	last4=last4+5
	Repl amountp With c.bill_amt
	Repl salun With ''
	Repl staxun With 'SZTZOZ'
	*  repl other with c.oth_exp_&old_9
	If c.INV_TYpE = 'C'
		Repl cash With Round(c.bill_amt,0)
		Repl Round With 0
	Else
		Repl Final With Round(c.bill_amt,0)
		Repl Round With 0
	Endif
	If Final=0 .And. cash#0
		Repl misc3 With Substr(misc3,1,34)+'C'+Substr(misc3,36,100)
	Else
		Repl misc3 With Substr(misc3,1,34)+'R'+Substr(misc3,36,100)
	Endif
	*   repl mr with 'S'+alltrim(c.agent)
	Repl Docu  With Subs(c.party_code+Space(10),1,10)+Alltrim(c.PARTY_NAME)
	Repl docu2 With Subs(c.dr_code+Space(10),1,10)
	Repl duedays With 0
	Repl lrda With c.invoice_dt
	Repl account With 'N'
	Repl sale With 'Z'
	Repl godwon With 'A'
	Repl ltype With scalc
	Repl discafter With 'N'
	Repl remark4 With l3
	Repl remark1 With Str(Round(c.bill_amt,0),12,2)

	&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SL",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	Sele h
	Seek c.INV_TYpE+Str(c.invoice)
	Do While  INV_TYpE+Str(bill) = c.INV_TYpE+Str(c.invoice) .And. !Eof()
		Sele e
		Seek Substr(h.Code+Space(10),1,10)
		Sele g
		Appe Blank
		Repl Codep With d.Codep
		Repl vcn With d.vcn
		Repl Date With d.Date
		Repl voucher With d.voucher
		Repl Code With e.Code
		Repl tax With 'T'
		Repl qty With h.quantity
		Repl Exp With h.exp_dt
		Repl Batch With h.batch_no
		XXRATE=h.rate*Iif(e.Pack#0,e.Pack,1)
		XXRATE1=h.rate/Iif(e.Pack#0,e.Pack,1)
		If e.Pack#0
			If h.quantity/e.Pack=Int(h.quantity/e.Pack)
				Repl rate With h.rate,Pack With e.Pack
			Else
				Repl rate With h.rate*e.Pack,Pack With e.Pack
			Endif
		Else
			Repl rate With h.rate,Pack With 0
		Endif
		*!*	*     repl rate with ABS(h.amount)/h.quantity,pack with 0
		*!*
		*!*	     IF H.RATE*H.QUANTITY=H.AMOUNT
		*!*	        REPL rate with h.rate,pack with 0
		*!*	     else
		*!*	       if xxrate*h.quantity=h.amount
		*!*	          repl
		*!*	  DO CASE
		*!*	     CASE H.QUANTITY*XXRATE=H.AMOUNT
		*!*	           REPL RATE WITH XXRATE
		*!*	           REPL PACK WITH E.PACK
		*!*	     CASE H.QUANTITY*H.RATE=H.AMOUNT
		*!*	           REPL RATE WITH H.RATE
		*!*	           REPL PACK WITH 0
		*!*	  ENDCASE
		Repl disc1 With h.disc_per
		*      repl disc2 with h.sp_disper
		Repl mrp With h.m_r_p
		If OLD_7 = 'G'
			Repl ssta With Abs(h.tax_rate)
			Repl cgst With (h.tax_rate1)
		Else
			Repl ssta With (h.tax_rate)+(h.tax_rate1)
			Repl sssc With 0
		Endif

		If h.Entry_type='S'
			Repl flg With 'G'
		Else
			Repl flg With 'R'
		Endif
		Repl Half With 'A'
		Repl godwon With d.godwon
		Sele h
		Skip
	Enddo
	Sele c
	Skip
Enddo




@rowno,22 Say 'Importing Sales Return (FRESH).....' Font 'Courier',14
rowno=rowno+1

last4 = last4 + 20
Sele F
Use &prb Alias prb
Index On Code + batch_no To prb
Sele e
Use &pro Alias pro
Index On Name To pro

Sele c
Use &sgr Alias sret
Set Filter To (invoice_dt>=old_5 And invoice_dt<=old_6)


Sele h
Use &sgl  Alias srld
Index On bill To srld

Sele d
Use &mdis Alias mdis
Sele g
Use &dis Alias dis


Sele c
Go Top
Do While !Eof()
	*!*	   if saleable#'F'
	*!*	     skip
	*!*	     loop
	*!*	   endif
	l1 = Alltrim(Str(c.invoice))
	l2 = Len(l1)
	l3 = l1  &&replicate('0',6-l2)+l1

	Sele d
	Appe Blank
	Repl Type With 'R'
	*  repl misc3 with substr(misc3,1,53)+iif(substr(c.billno_&old_9,1,1)='T','T','R')+substr(misc3,55,100)
	*!*	if len(alltrim(c.invoice))=0
	*!*	   repl challan with l3
	*!*	   repl cdate  with c.note_dt
	*!*
	*!*	else
	Repl vcn With l3
	Repl Date With c.invoice_dt
	*!*	endif
	isOld=Iif(c.invoice_dt<old_5,1,0)
	Repl Codep With c.party_code
	Repl voucher With last4
	last4=last4+5
	Repl amountp With (c.return_amt)
	Repl salun With ''
	Repl staxun With 'SZTZOZ'
	*  repl other with c.oth_exp_&old_9
	*!*	   if c.cashcredit = 'C'
	*!*	      repl cash with round(c.bill_amt,0)
	*!*	      repl round with 0
	*!*	   else
	Repl Final With Round(c.return_amt,0)
	*!*	      repl round with 0
	*!*	   endif
	If Final=0 .And. cash#0
		Repl misc3 With Substr(misc3,1,34)+'C'+Substr(misc3,36,100)
	Else
		Repl misc3 With Substr(misc3,1,34)+'R'+Substr(misc3,36,100)
	Endif
	*   repl mr with 'S'+alltrim(c.agent)
	Repl duedays With 0
	Repl lrda With c.invoice_dt
	Repl account With 'N'
	Repl sale With 'Z'
	Repl godwon With 'A'
	Repl ltype With scalc
	Repl discafter With 'N'
	Repl remark4 With l3
	Repl remark1 With Str(Round(c.return_amt,0),12,2)
	*REPL OTHER WITH -C.C_NOTE_AMT

	*!*	   REPL CRNOREM WITH iif(len(alltrim(c.invoice))>0,alltrim(c.invoice),'')+;
	*!*	      iif(day(c.invoice_dt)>0,'/'+dtoc(c.invoice_dt),'')

	&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SL",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	Sele h
	Seek c.invoice
	Do While  h.bill = c.invoice .And. !Eof()
		Sele e
		Seek Substr(h.Code+Space(10),1,10)
		Sele g
		Appe Blank
		Repl Codep With d.Codep
		Repl vcn With d.vcn
		Repl Date With d.Date
		Repl voucher With d.voucher
		Repl Code With e.Code
		Repl tax With 'T'
		Repl qty With Iif(h.Free<1,h.quantity-h.Free,h.quantity)
		Repl Free With h.Free
		Repl Pack With e.Pack
		Repl Exp With h.exp_dt
		Repl Batch With h.batch_no
		Repl rate With h.rate
		*!*	      repl disc1 with h.disc_rate &&+h.sp_disper
		*      repl disc2 with h.sp_disper
		*!*	      REPL DEAL WITH H.LOT_QTY1
		*!*	      REPL FREEDEAL WITH H.LOT_QTY2
		Repl ssex With 0
		Repl mrp With h.m_r_p
		If OLD_7 = 'G'
			Repl ssta With h.tax_rate
			Repl cgst With h.tax_rate1
		Else
			Repl ssta With h.tax_rate+h.tax_rate1
			Repl sssc With 0
		Endif

		If h.sale_type='F'
			Repl flg With 'R'
			Repl godwon With "A"
		Else
			Repl flg With 'W'
			Repl godwon With 'Y'
		Endif
		Repl Half With 'A'
		If isOld=1
			Sele msbal
			Seek Subs(h.Code+Space(10),1,10)+Subs(h.batch_no+Space(12),1,12)
			If !Found()
				Sele msbal
				Appen Blank
				Repl Code With e.Code,batchno With h.batch_no,Name With e.Name,Product With e.Product
				Repl billname  With e.billname,packing With e.packing
				Repl Date With old_5-5.rateA With h.rate,mrp With h.m_r_p
			Endif
			Repl msbal.opening With msbal.opening-(h.quantity+h.Free)
			Repl msbal.balance With msbal.balance-(h.quantity+h.Free)
			Repl msbal.o_a With msbal.o_a-(h.quantity+h.Free)
			Repl msbal.b_a With msbal.b_a-(h.quantity+h.Free)


		Endif
		*repl godwon with d.godwon
		Sele h
		Skip
	Enddo
	Sele c
	Skip
Enddo





@rowno,22 Say 'Importing Sales Replacement(issued).....' Font 'Courier',14
rowno=rowno+1

last4=last4+20
Sele c
Use
Use &datatransferpath\cas033 Alias sal
Set Filter To (invoice_dt>=old_5 .And. invoice_dt<=old_6)

Sele h
Use
Use &datatransferpath\cas033A  Alias sld
Index On bill To sld


Sele c
Go Top
Do While !Eof()
	l1 = Alltrim(Str(c.invoice))
	l2 = Len(l1)
	l3 = Replicate('0',6-l2)+l1
	Sele d
	Appe Blank
	Repl Type With 'O'
	Repl vcn With l3
	Repl Date With c.invoice_dt
	Repl Codep With c.party_code
	Repl voucher With last4
	last4=last4+5
	Repl salun With ''
	Repl staxun With 'SZTZOZ'
	Repl pacun With 'STAC23'
	If Final=0 .And. cash#0
		Repl misc3 With Substr(misc3,1,34)+'C'+Substr(misc3,36,100)
	Else
		Repl misc3 With Substr(misc3,1,34)+'R'+Substr(misc3,36,100)
	Endif
	Repl duedays With 0
	Repl account With 'N'
	Repl sale With 'Z'
	Repl ltype With scalc
	Repl godwon With 'A'
	Repl discafter With 'N'
	&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SL",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	Sele h
	Seek c.invoice
	Do While  bill = c.invoice .And. !Eof()
		Sele e
		Seek Substr(h.Code+Space(10),1,10)
		Sele g
		Appe Blank
		Repl Codep With d.Codep
		Repl vcn With d.vcn
		Repl Date With d.Date
		Repl voucher With d.voucher
		Repl Code With e.Code
		Repl tax With 'T'
		*repl qty with h.quantity
		Repl Free With h.quantity &&+h.free
		Repl Batch With h.batch_no
		Repl Exp With h.exp_dt
		Repl Pack With e.Pack
		Repl rate With h.rate
		Repl disc1 With h.disc_rate
		*!*	      repl disc2 with h.sp_dis
		Repl ssex With 0
		Repl mrp With h.m_r_p
		If OLD_7 = 'G'
			*!*	         repl ssta with iif(h.tax_amt#0,h.tax_rate/2,0)
			*!*	         repl cgst with iif(h.tax_amt#0,h.tax_rate/2,0)
		Else
			*!*	         repl ssta with iif(h.tax_amt#0,h.tax_rate,0)
		Endif
		Repl Half With 'A'
		Repl flg With Iif(h.sale_type$'EB','W','O')
		Repl godwon With Iif(h.sale_type$'EB','Y','A')
		*repl supplied with 'R'
		Sele h
		Skip
	Enddo
	Sele c
	Skip
Enddo


@rowno,22 Say 'Importing Purchase .....' Font 'Courier',14
rowno=rowno+1

last4=last4+20
Sele c
Use
Use &pur Alias pur
Set Filter To (recd_date>=old_5 .And. recd_date<=old_6)

Sele h
Use
Use &pul Alias pul
Index On Str(serial,6) To pul

Sele c
Go Top
Do While !Eof()
	l1 = Alltrim(Str(c.serial))
	l2 = Len(l1)
	l3 = Replicate('0',6-l2)+l1

	Sele d
	Appe Blank
	*  repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	Repl Type With 'P'
	Repl transfer With 'P'
	Repl vcn With l3
	Repl Date With c.recd_date
	Repl lrda With c.bill_dt
	Repl pm With c.bill_no
	Repl Codep With c.party_code
	Repl voucher With last4
	last4=last4+5
	Repl amountp With ( c.bill_amt )
	Repl salun With ''
	Repl staxun With 'SZTZOZ'
	Repl Other With ( -(c.tt_amt6+c.TT_AMT5))
	Repl pacun With 'STAC23'
	Repl Final With Round(c.bill_amt,0)
	Repl Round With c.tt_amt7
	If Final=0 .And. cash#0
		Repl misc3 With Substr(misc3,1,34)+'C'+Substr(misc3,36,100)
	Else
		Repl misc3 With Substr(misc3,1,34)+'R'+Substr(misc3,36,100)
	Endif
	Repl duedays With 0
	Repl account With 'N'
	Repl sale With 'z'
	Repl ltype With pcalc
	Repl godwon With 'A'
	Repl discafter With 'N'
	Repl remark4 With Str(c.serial,6)
	Repl remark1 With Str(Round(c.bill_amt,0),12,2)
	&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SL",pcode With mdis->voucher,Value With mdis->Final+mdis->cash


	Sele h
	Seek Str(c.serial,6)
	Do While  Str(h.serial,6) = Str(c.serial,6) .And. !Eof()
		Sele e
		Seek Substr(h.Code+Space(10),1,10)

		Sele g
		Appe Blank
		Repl Codep With d.Codep
		Repl vcn With d.vcn
		Repl Date With d.Date
		Repl voucher With d.voucher
		Repl Code With e.Code
		Repl tax With 'T'
		Repl qty With h.quantity*Iif(e.Pack#0,e.Pack,1)
		Repl Free With h.Free*Iif(e.Pack#0,e.Pack,1)
		Repl rate With h.rate
		Repl Pack With e.Pack

		Repl Batch With h.batch_no
		Repl Exp With h.exp_dt
		Repl disc1 With h.disc_rate+h.sp_disper
		Repl ssex With 0
		Repl mrp With h.m_r_p
		If OLD_7 = 'G'
			Repl ssta With h.tax_rate
			Repl cgst With h.tax_rate1
		Endif
		Repl Half With 'A'
		Repl flg With d.Type
		Repl godwon With d.godwon

		If h.DUE_QTY#0
			Scat To ROUGH_A
			Repl qty With qty-h.DUE_QTY
			Appen Blank
			Gath From ROUGH_A
			Repl qty With h.DUE_QTY,Free With 0
			Repl flg With 'X',SUPPLIED With 'S'
		Endi
		Sele h
		Skip
	Enddo
	Sele c
	Skip
Enddo

@rowno,22 Say 'Importing Purchase Return(Fresh).....' Font 'Courier',14
rowno=rowno+1

last4=last4+20
Sele c
Use
Use &datatransferpath\cas007 Alias pur
Set Filter To (note_dt>=old_5 .And. note_dt<=old_6)
Sele h
Use
Use &datatransferpath\cas007A  Alias pul
Index On bill To pul

Sele c
Go Top
Do While !Eof()
	*!*	    if saleable#'Y'
	*!*	       skip
	*!*	       loop
	*!*	    Endif
	l1 = Alltrim(c.note_no)
	l2 = Len(l1)
	l3 = Replicate('0',6-l2)+l1

	Sele d
	Appe Blank
	*  repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	Repl Type With 'B'
	Repl transfer With 'P'
	Repl vcn With l3
	Repl Date With c.note_dt
	Repl lrda With c.note_dt
	Repl pm With c.bill_no
	Repl Codep With Alltrim(c.party_code)
	Repl voucher With last4
	last4=last4+5
	Repl amountp With ( c.bill_amt )
	Repl salun With ''
	Repl staxun With 'SZTZOZ'
	*!*	   repl other with ( -c.tt_amt6)
	Repl pacun With 'STAC23'
	Repl Final With Round(c.bill_amt,0)
	*   repl round with c.tt_amt7
	If Final=0 .And. cash#0
		Repl misc3 With Substr(misc3,1,34)+'C'+Substr(misc3,36,100)
	Else
		Repl misc3 With Substr(misc3,1,34)+'R'+Substr(misc3,36,100)
	Endif
	Repl cash With c.ADJ_AMOUNT
	Repl duedays With 0
	Repl account With 'N'
	Repl sale With 'z'
	Repl ltype With pcalc
	Repl godwon With 'A'
	Repl discafter With 'N'
	Repl remark4 With c.note_no
	Repl remark1 With Str(Round(c.bill_amt,0),12,2)
	&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SL",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	Sele h
	Seek c.note_no
	Do While  bill = c.note_no .And. !Eof()
		Sele e
		Seek Substr(h.Code+Space(10),1,10)

		Sele g
		Appe Blank
		Repl Codep With d.Codep
		Repl vcn With d.vcn
		Repl Date With d.Date
		Repl voucher With d.voucher
		Repl Code With e.Code
		Repl tax With 'T'
		Repl qty With h.quantity
		Repl Free With h.Free
		Repl Batch With h.batch_no
		Repl Exp With h.exp_dt
		*repl pack with e.pack
		Repl rate With h.rate
		Repl disc1 With h.disc_rate
		*!*	      repl disc2 with h.sp_dis
		Repl ssex With 0
		Repl mrp With h.m_r_p
		If OLD_7 = 'G'
			Repl ssta With Iif(h.tax_amt#0,h.tax_rate/2,0)
			Repl cgst With Iif(h.tax_amt#0,h.tax_rate/2,0)
		Else
			Repl ssta With Iif(h.tax_amt#0,h.tax_rate,0)
		Endif
		Repl Half With 'A'
		Repl flg With d.Type
		Repl godwon With d.godwon
		Sele h
		Skip
	Enddo
	Sele c
	Skip
Enddo


@rowno,22 Say 'Importing Stock Adjustments(Add/Less).....' Font 'Courier',14
rowno=rowno+1

last4=last4+20
Sele c
Use
Use &datatransferpath\cas008 Alias pur
Set Filter To (Date>=old_5 .And. Date<=old_6)

Sele h
Use
Use &datatransferpath\cas008A  Alias pul
Index On sl_no To pul

Sele c
Go Top
Do While !Eof()
	*!*	    if sale_type='E'
	*!*	       skip
	*!*	       loop
	*!*	    Endif
	l1 = Alltrim(Str(c.serial))
	l2 = Len(l1)
	l3 = Replicate('0',6-l2)+l1

	Sele d
	Appe Blank
	*  repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	Repl Type With 'D'
	Repl vcn With l3
	Repl Date With c.Date
	Repl Codep With "STOCex"
	Repl voucher With last4
	last4=last4+5
	*!*	   repl amountp with ( c.bill_amt )
	Repl salun With ''
	Repl staxun With 'SZTZOZ'
	*!*	   repl other with ( -c.tt_amt6)
	Repl pacun With 'STAC23'
	*   repl final with round(c.bill_amt,0)
	*   repl round with c.tt_amt7
	*!*	   if final=0 .and. cash#0
	*!*	      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	*!*	   else
	*!*	      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	*!*	   endif
	*!*	   repl duedays with 0
	Repl account With 'N'
	Repl sale With 'Z'
	Repl ltype With '2'
	Repl godwon With 'A'
	Repl discafter With 'N'
	*!*	   repl remark4 with c.note_no
	*!*	   repl remark1 with str(round(c.bill_amt,0),12,2)

	&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SL",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	Sele h
	Seek c.serial
	Do While  sl_no=c.serial .And. !Eof()
		Sele e
		Seek Substr(h.Code+Space(10),1,10)

		Sele g
		Appe Blank
		Repl Codep With d.Codep
		Repl vcn With d.vcn
		Repl Date With d.Date
		Repl voucher With d.voucher
		Repl Code With e.Code
		Repl tax With 'T'
		Repl Free With h.quantity &&+h.free
		Repl Batch With h.batch_no
		Repl Exp With h.exp_date
		Repl Pack With e.Pack
		Repl rate With h.m_r_p &&iif(h.add_less='L',h.whole_rate,h.pur_rate)
		*!*	      repl disc1 with h.disc_rate
		*!*	*!*	      repl disc2 with h.sp_dis
		*!*	      repl ssex with 0
		Repl mrp With h.m_r_p
		*!*	      if old_7 = 'G'
		*!*	*!*	         repl ssta with iif(h.tax_amt#0,h.tax_rate/2,0)
		*!*	*!*	         repl cgst with iif(h.tax_amt#0,h.tax_rate/2,0)
		*!*	      else
		*!*	*!*	         repl ssta with iif(h.tax_amt#0,h.tax_rate,0)
		*!*	      endif
		Repl Half With 'A'
		Repl flg With Iif(h.add_less='L','L','D')
		Repl godwon With d.godwon

		Sele h
		Skip
	Enddo
	Sele c
	Skip
Enddo


@rowno,22 Say 'Importing Accounts From Sales   .....' Font 'Courier',14
rowno=rowno+1

af      = datdev+'\gledger.'+DATEXT
pend    = datdev+'\pend.'+DATEXT
mdis    = datdev+'\mdis.'+DATEXT
pending = datdev+'\pendings.'+DATEXT
Sele g
Use &pending Alias pending
Sele F
Use &pend Alias pend
Zap
Sele b
Use &af Alias gledger
Zap
Sele d
Use &mdis Alias mdis
Go Top
Do While !Eof()
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

@rowno,22 Say 'Importing Accounting Transactions  .....' Font 'Courier',14
rowno=rowno+1

af      = datdev+'\gledger.'+DATEXT
bf      = datdev+'\slipno.'+DATEXT
pend    = datdev+'\pend.'+DATEXT
pending = datdev+'\pendings.'+DATEXT

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
Use &datatransferpath\cas003 Alias led
Sele Sele(1)
Use &datatransferpath\cas003A Alias fgl
Index On sl_no To fgl

*!*	use &cf alias led
*!*	inde on dtoc(vdate) + vtype + vno to rough
*!*	set filt to sts # 'S' .and. sts # 'P' .and. ctype = old_9
Sele a

Go Top
*!*	last5=vmode
last1=Ctod('  /  /    ')
last2='$'
last3='%%%%%%'
Do While !Eof()
	mmvoucher=voucher
	last4 = last4+4
	Sele b
	Appe  Blank
	Repl voucher With last4
	Repl vcsno With a.voucher
	Repl Date With a.Date
	Sele fgl
	Seek a.serial
	Do While sl_no=a.serial And !Eof()
		Sele b
		Appe  Blank
		Repl voucher With last4
		Repl vcsno With a.voucher
		Repl Date With a.Date
		Repl book With Iif(fgl.Dr_cr='D','P','R')
		Repl Code With fgl.sub_code
		Repl code1 With fgl.Code
		If fgl.Dr_cr='D'
			Repl Cd With 'D'
			Repl debit With fgl.amount
		Else
			Repl Cd With 'C'
			Repl credit With fgl.amount
		Endif
		Repl addfield1 With fgl.chk_no
		Appe  Blank
		Repl voucher With last4
		Repl vcsno With a.voucher
		Repl Date With a.Date
		Repl book With Iif(fgl.Dr_cr='D','R','C')
		Repl Code With fgl.Code
		Repl code1 With fgl.sub_code
		If fgl.Dr_cr='D'
			Repl Cd With 'C'
			Repl credit With fgl.amount
		Else
			Repl Cd With 'D'
			Repl debit With fgl.amount
		Endif
		Repl addfield1 With fgl.chk_no

		Sele fgl
		Skip
	Enddo
	Sele a
	If mmvoucher=voucher
		Skip
	Else
		Loop
	Endif
Enddo
Close Data

bf=datdev+'\slipno.'+DATEXT
Use &bf
Go Top
Repl voucher With last4+20
Repl svoucher With slast5+20
bf=datdev+'\mdis.'+DATEXT
Use &bf
Repl misc4 With ' '
bf=datdev+'\pendings.'+DATEXT
Use &bf
Repl All vcn With '*'+vcn For invtype='O' .And. ddate<=old_5
Close Data

** Transfer CALCULATION FIELD OF MARG TRANSACTION FILE
dis=datdev+'\dis.'+DATEXT
Use &dis
Go Top
Do While !Eof()
	Repl sfrate With rate+Val(Substr(dis.misc4,1,6))
	Repl ssscamo With Round((sfrate*qty)*sssc/100,2)
	Repl sstaamo With Round((sfrate*qty+ssscamo)*ssta/100,2)
	Repl sfrate With sfrate+Round(sfrate*sssc/100,2)
	Repl sfrate With sfrate+Round(sfrate*ssta/100,2)
	Repl shalfamo With rate*halffree
	tot=rate*(QTY/Iif(Pack#0,Pack,1))-vdisamo-shalfamo                 &&&&&& MODIFY BY GOUTAM
	totd=Round(tot*disc1/100,2)
	Repl sdiscount With totd
	tot=tot-totd
	totd=Round(tot*disc2/100,2)
	Repl sdiscount With sdiscount+totd
	tot=(rate-ssex)*qty-sdiscount-shalfamo-vdisamo
	totd=Round(tot*addis/100,2)
	Repl ammmount With sfrate*qty-sdiscount-shalfamo-vdisamo
	Repl ssscamo With ssscamo+(sfrate*qty-rate*qty)-(ssscamo+sstaamo)
	Skip
Enddo
Close Data
***EOF ||SOFTWARE NAME: TDR|| DATE 24-03-2025 || TRADE : PHARMA WHOLESALE/RETAIL|| AUTHOR : SARVESH||
