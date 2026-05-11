*!* BOF : Csquare.PRG .....PharmaSoft 360 Karnataka
Sele Sele(1)
Create Curs mycurs  (Setup c(50),Value c(4))
Sele mycurs
Appe Blank
Repl  Setup With 'Volume Discount-1 ',Value With 'L'
Appe Blank
Repl  Setup With 'Ask Discount in Amount',Value With 'N'
Brow fields setup,value Font 'Arial Bold',14  Nomodify
Clear
Close Table All
Set Talk Off
Set Date To brit
Set Cent On
Set Dele On
Set Safe Off
Set Cpdia Off
If Type('FINALCP')='U'
	datdev='d:\transfer'
	datext='dbf'
	firstdate=Ctod('01/04/2025')
	lastdate=Ctod('31/03/2026')
Endif
datatransferpath=Substr('D:\2025\June\SKYWAY\'+Spac(99),1,99)
datatransferext='dbf'
old_3 = 'YES'
old_4 = 'No '
old_5 = firstdate
old_6 = lastdate
mStateCode='19'
sure='SURE'
removedupl='No '
scalc='9'
pCalc='2'
softtype='R'
vatgst='GST'
mtrade='Pharma'
msofttype='Wholesale   '
mVersion='V02'
@02,22 Say 'Pharmasoft(360) Data Import Into Marg ERP 9+'+Space(40) Font 'Arial Bold',14 Color Rgb(20,255,255,119,136,153)
@04,22 Say 'Pharmasoft(360) Data Path  :' Font 'Courier NEW',12  Get datatransferpath  Font 'Courier NEW',12
@05,22 Say 'Pharmasoft(360) Extension  :' Font 'Courier NEW',12  Get datatransferext  Font 'Courier NEW',12
@06,22 Say 'With Outstanding Y/N       :' Font 'Courier NEW',12  Get old_3 Pict '@m YES,NO '  Font 'Courier NEW',12
@07,22 Say 'Master Only                :' Font 'Courier NEW',12  Get old_4 Pict '@m No ,Yes'  Font 'Courier NEW',12
@08,22 Say 'From Date                  :' Font 'Courier NEW',12  Get old_5   Font 'Courier NEW',12
@09,22 Say 'To Date                    :' Font 'Courier NEW',12  Get old_6   Font 'Courier NEW',12
@10,22 Say 'State Code                 :' Font 'Courier NEW',12  Get mStateCode   Font 'Courier NEW',12
@11,22 Say 'Sales Calulation           :' Font 'Courier NEW',12  Get scalc   Font 'Courier NEW',12
@12,22 Say 'Purchase Calculation       :' Font 'Courier NEW',12  Get pCalc   Font 'Courier NEW',12
@13,22 Say 'Trade                      :' Font 'Courier NEW',12  Get mtrade Pict '@M Pharma,FMCG '   Font 'Courier NEW',12
@14,22 Say 'Remove Duplicted           :' Font 'Courier NEW',12  Get removedupl  Pict '@M No ,Yes'  Font 'Courier NEW',12
@15,22 Say 'Version                    :' Font 'Courier NEW',12  Get mVersion  Pict '@M V01,V02'  Font 'Courier NEW',12
@16,22 Say 'Wholesale/Retail           :' Font 'Courier NEW',12  Get msofttype Pict '@M Wholesale,Retail   '  Font 'Courier NEW',12
@17,22 Say 'Type SURE                  :' Font 'Courier NEW',12  Get sure   Font 'Courier NEW',12
Read
datatransferpath  = Alltrim(datatransferpath)
datdev  = Alltrim(datdev)
datext = Alltrim(datext)
If Type('FINALCP')#'U'
	REST SCREEN FROM SIMPLE
	colofhed="c-Square FULL TRANSFER"
	=colofil(03,08,19,70,10)
	=starttransfer()
Endif
If Lastkey()=27 .And. sure#'SURE'
	Return
Endif
Clear
If removedupl='Y'
	=rem_dupl()
Endif
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
Use &datdev\chiller.&datext
Zap
Use &datdev\Support.&datext
Dele All For Type='#' And aliase='DAT/F'
Dele All For aliase='ORDER'
Pack
Close Data
@03,22 Say 'Please Wait Importing cSquare(Pharmasoft-360)  Data To Marg.....' Font 'Arial Bold',14 Color Rgb(20,255,255,119,136,153)
Rowno=5

@Rowno,22 Say '**** Importing Item ****' Font 'Courier New',12
Rowno=Rowno+1
Sele Sele(1)
fd=datatransferpath+'item_mst.dbf'
ft=datatransferpath+'pack_mst'
td=datdev+'\pro.'+datext
Sele Sele(1)
Use &datatransferpath\gst_mst Alias gst
Index On c_code To gst
Sele Sele(1)
Use &datdev\saletype.&datext Alias stype
Index On sgcode+parnam+Str(igst,6,2) To stype
If mVersion='V02'
	Sele Sele(1)
	Use &datatransferpath\gst_item_det Alias gst1
	Index On c_item_cod  To gst1
Endif
ft=datatransferpath+'pack_mst.dbf'
If File(ft)
	Sele c
	Use &ft Alias fpac
	Index On c_code To fpac
Endif
Sele a
Use &fd Alias fitm
Sele b
Use &td Alias mitm
Zap
Index On Name To mitm
Sele fitm
Go Top
Do While .Not. Eof()
	Store 0 To msgst,mcgst,migst
	If mVersion='V02'
		=Seek(c_code,'gst1')
		msgst=Val(gst1.c_gst_code)/2
		mcgst=Val(gst1.c_gst_code)/2
		migst=Val(gst1.c_gst_code)
	Else
		=Seek(c_code,'sled')
		msgst=sled.n_sgst_per
		mcgst=sled.n_cgst_per
		migst=sled.n_igst_per
	Endif
	Last=Recno()
	If File(ft)
		Sele fpac
		Seek fitm.c_pack_cod
	Endif
	Sele mitm
	Seek Substr(fitm.c_code+Space(10),1,10)
	Append Blank
	Repl mitm.Code With Last
	Repl mitm.Name With fitm.c_code
	Repl mitm.Product With fitm.c_name
	If File(ft)
		Repl mitm.packing With fpac.c_name
	Else
		Repl mitm.packing With fitm.c_pack_cod
	Endif
	Repl mitm.billname With Product+packing &&alltrim(fitm.c_name) +'  '+ alltrim(fpac.c_name)
	Repl mitm.Pack With Iif(fitm.n_qty_per_=1,0,fitm.n_qty_per_)
	Repl mitm.unit With 'Pcs'
	Repl mitm.gcode With fitm.c_mfac_cod
	Repl mitm.gcode6 With Iif(mVersion='V02' Or mVersion='V02',Alltrim(Substr(fitm.C_HSN_SAC_,3,8)),Alltrim(fitm.c_hsn_code))
	Repl mitm->gcode3 With fitm->c_cont_cod
	repl mitm.gcode5 with fitm.c_group_co
	repl mitm.maximum with fitm.n_max_qty
	Repl mitm.Decimal With 'Y'
	Repl mitm.salfix With 'N'
	Repl mitm.halfsche With 'A'
	Repl mitm.qtrsche With 'Y'
	Repl mitm.Status With 'Y'
	repl prate with fitm.n_pur_rate
	repl mrp with fitm.n_mrp
	repl ratea with fitm.n_sale_rat
	Repl mitm.taxl With Iif(migst#0,'T','P')
	Repl mitm.saltax With msgst
	Repl mitm.cgst With mcgst
	Repl mitm.igst With migst
	** Hsn code **
	Sele stype
	Seek 'COMMCD'+Subs(fitm.C_HSN_SAC_+Space(15),1,15)+Str(migst,6,2)
	If !Found()
		Appen Blank
		Repl sgcode With 'COMMCD',scode With Alltrim(Str(Recno()))
		Repl parnam With fitm.C_HSN_SAC_
		Repl SNAME With fitm.C_HSN_SAC_
		Repl igst With migst,tax With msgst,cgst With msgst
	Endif
	Repl mitm.gcode6 With stype.scode

	Sele fitm
	Skip
Enddo
Sele stype
Close Data

@Rowno,22 Say '**** Importing Company ****' Font 'Courier New',12
Rowno=Rowno+1
fd=datatransferpath + 'mfac_mst.dbf'
td=datdev + '\saletype.' + datext
Sele a
Use &fd Alias fpcm
Sele b
Use &td Alias mpcm
Set Filt To sgcode = 'ZZZZZZ'
Dele All
Pack
Index On scode To mpcm

Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'ZZZZZZ',;
		mpcm.scode  With fpcm.c_code,;
		mpcm.SNAME  With fpcm.c_name,;
		mpcm.parnam With fpcm.c_name,;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele fpcm
	Skip
Enddo
Close Data


Try
	@Rowno,22 Say '**** Importing Salt/Composition ****' Font 'Courier New',12
	Rowno=Rowno+1
	If mVersion='V01'
		fd=datatransferpath + 'content_mst.dbf'
	Else
		fd=datatransferpath + 'cont_mst.dbf'
	Endif
	td=datdev + '\saletype.' + datext
	Sele a
	Use &fd Alias fsalt
	Sele b
	Use &td Alias msalt
	Set Filt To sgcode = 'SALT  '
	Dele All
	Pack
	Index On scode To msalt

	Sele fsalt
	Go Top
	Do While .Not. Eof()
		Sele msalt
		Append Blank
		Repl msalt->sgcode With 'SALT  ',;
			msalt->scode  With fsalt->c_code,;
			msalt->SNAME  With fsalt->c_name,;
			msalt->parnam With fsalt->c_name,;
			msalt->tcode With 'No',;
			msalt->tax With 1
		Sele fsalt
		Skip
	Enddo
	Close Data
Catch
	merror=1
Endtry

@Rowno,22 Say '**** Importing Category ****' Font 'Courier New',12
Rowno=Rowno+1
fd=datatransferpath + 'item_group_mst.dbf'
td=datdev + '\saletype.' + datext
Sele a
Use &fd Alias fpcm
Sele b
Use &td Alias mpcm
Set Filt To sgcode = 'CATEGO'
Dele All
Pack
Index On scode To mpcm
Sele fpcm
Go Top
Do While .Not. Eof()
	Sele mpcm
	Append Blank
	Repl mpcm.sgcode With 'CATEGO',;
		mpcm.scode  With fpcm.c_code,;
		mpcm.SNAME  With fpcm.c_name,;
		mpcm.parnam With fpcm.c_name,;
		mpcm.tcode With 'No',;
		mpcm.tax With 1
	Sele fpcm
	Skip
Enddo
Close Data


@Rowno,22 Say '**** Importing Batch Stock ****' Font 'Courier New',12
Rowno=Rowno+1
fd=datatransferpath + 'stock.dbf'
fi=datatransferpath + 'item_mst.dbf'
fs=datatransferpath + 'scheme_mst.dbf'
td=datdev + '\probat.'+datext
mi=datdev + '\pro.'+datext
Sele e
Use &fi Alias fitm
Index On c_code To fitm
Sele a
Use &fd Alias fsbal
Sele b
Use &mi Alias mitm
Index On Name To mitm
Sele c
Use &td Alias msbal
Zap
Index On Name+batchno To msbal
Sele Sele(1)
Use &datdev\Support.&datext Alias Support
r=0
Sele fsbal
Go Top
Do While .Not. Eof()
	mOpening=Iif(old_4='Y',n_balance_,n_opening_)
	mBalance=n_balance_ 
	Sele mitm
	Seek Substr(fsbal.c_item_cod,1,10)
	Sele msbal
	Seek Substr(fsbal.c_item_cod+Space(10),1,10)+Substr(fsbal.c_batch_no,1,12)
	If ! Found()
		Append Blank
		Repl msbal.Date With Date(),;
			msbal.Code With mitm.Code,;
			msbal.Name With mitm.Name,;
			msbal.billname With mitm.billname,;
			msbal.Product With mitm.Product,;
			msbal.unit2 With mitm.unit2,;
			msbal.unit With mitm.unit,;
			msbal.Decimal With 'Y',;
			msbal.opening With mOpening,;
			msbal.balance With mBalance,;
			msbal.o_a With mOpening,;
			msbal.b_a With mBalance ,;
			msbal.batchno With fsbal.c_batch_no,;
			msbal.Exp With fsbal->d_expiry_d,;
			msbal.prate With fsbal.n_purcha02,;
			msbal.ratea With fsbal.n_wh_rate,;
			msbal.rateb With fsbal.n_sale_rat,;
			msbal.mrp With fsbal.n_mrp,;
			msbal.misc1 With mitm.gcode
	Else
		Repl msbal.opening With opening+ mOpening
		Repl msbal.balance With balance+mBalance
		Repl msbal.o_a With o_a+mOpening     
		Repl msbal.b_a With b_a+mBalance     

	Endif


	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-BT",pcode With mitm.Code,Heading With Iif(mtrade="B",msbal.batchno,Str(msbal.mrp,9,2)),Value With msbal.balance
	Sele fsbal
	Skip
Enddo
If old_4='Y'
	Sele msbal
	Repl All balance With opening,o_a With opening,b_a With opening
Endif

Sele msbal
Go Top
Sele mitm
Scan
	Sele msbal
	Seek mitm.Name
	Sum balance To tot While Name=mitm.Name
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-IT",pcode With mitm.Code,Heading With '',Value With tot
	*!* for item batch difference ## in support -> repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with iif(mtrade="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
	*!* for ledger difference ## in support -> repl type with "#",aliase with "DAT/F-LD",Lcode with mact.ordno,value with TOT
Endscan
Close Data


If mVersion='V01'
	@Rowno,22 Say '**** Importing Salesman ****' Font 'Courier New',12
	Rowno=Rowno+1
	Sele Sele(1)
	Use &datatransferpath\sman_mst Alias sman
	Sele Sele(1)
	Use &datdev\Order.&datext Alias mact
	Zap
	Sele sman
	Scan
		Sele mact
		Appen Blank
		Repl scode  With 'D32'
		Repl ordno  With 'S'+sman.c_code
		Repl parnam With sman.c_name
		Repl mailnam  With sman.c_name

	Endscan
	Close Data
Endif
Try
	@Rowno,22 Say '**** Importing Doctor ****' Font 'Courier New',12
	Rowno=Rowno+1

	fd=datatransferpath + 'doctor_mst.dbf'
	td=datdev + '\maorder.' + datext
	Sele a
	Use &fd Alias fdoc
	Sele b
	Use &td Alias mdoc

	Sele fdoc
	Go Top
	Do While .Not. Eof()
		Sele mdoc
		Append Blank
		Repl mdoc->scode With 'PRE#$~',;
			mdoc->Form With fdoc->c_code,;
			mdoc->parnam  With fdoc->c_name
		Sele fdoc
		Skip
	Enddo
	Close Data
Catch
	merror=1
Endtry

@Rowno,22 Say '**** Importing Accounts ****' Font 'Courier New',12
Rowno=Rowno+1
fd=datatransferpath + 'act_mst.dbf'
cb=datatransferpath + 'bank_mst.dbf'
fb=datatransferpath + 'ledger.dbf'
Sele Sele(1)
Use &datatransferpath\act_balance  Alias led
Index On c_act_code To led
td=datdev + '\order.'+datext
Sele d
Use &cb Alias fbnk
Index On c_code To fbnk
Sele c
Use &fb Alias fbal
Set Filter To d_date<old_5
Index On c_act_code To fbal
Sele a
Use &fd Alias fact
Sele b
Use &td Alias mact
Try
	Sele Sele(1)
	Use &datatransferpath\ACT_head_mst Alias grp
	Index On c_grp_no To grp
Catch
	Try
		Sele Sele(1)
		Use &datatransferpath\grp_mst Alias grp
		Index On c_grp_no To grp
	Catch
		merror=1
	Endtry
Endtry

Sele Sele(1)
Use &datdev\Support.&datext Alias Support

Sele fact
Go Top
Do While .Not. Eof()
	mOpening=0
	If mVersion='V01'
		mOpening=Iif(c_credit_d='C',-n_op_bal,n_op_bal)
	Endif

	=Seek(c_grp_no,'grp')
	msname=grp.c_grp_name

	Sele fbnk
	Seek fact.c_bank_cod
	Sele mact
	Append Blank
	Replace mact.rate With 'Y'
	tot=0
	Sele mact
	Repl mact.ordno With fact.c_code,;
		mact.parnam  With Upper(Alltrim(fact.c_name)),;
		mact.paradd With Upper(Alltrim(fact.c_add_1)),;
		mact.paradd1 With Upper(Alltrim(fact.c_add_2)),;
		mact.paradd2 With Upper(Alltrim(fact.c_add_3+' '+fact.c_city)),;
		mact.sthed With  'LST No.',;
		mact.csthed With 'CST  No.',;
		mact.cstno With fact.c_cst_no,;
		mact.FAX2 With Alltrim(Substr(fact.c_code,1,6)),;
		mact.stno With fact.c_st_no,;
		mact.dlno With Alltrim(fact.c_drug_lic) + Alltrim(fact.c_drug_l01),;
		mact.phone1 With fact.c_phone_1,;
		mact.phone2 With fact.c_phone_2,;
		mact.phone3 With fact.c_mobile,;
		mact.gstno With fact.c_permanen,;
		mact.mailnam With Upper(Alltrim(fact.c_name)),;
		mact.area With fact.c_area_cod,;
		mact.ref With 'Mr.',;
		mact.price With 'A',;
		mact.city With fact.c_city,;
		mact.Status With 'Y',;
		mact.adhed With 'Discount',;
		mact.duedays With fact.n_credit_d,;
		mact.Docu With fbnk.c_name
		repl mact.dsm with fact.c_pin
*!*		If old_4='Y'
*!*			Sele led
*!*			Seek fact.c_code
*!*			Repl mact.opning With led.n_cur_bal
*!*			Repl mact.balance With led.n_cur_bal
*!*		Endi
	If old_4='N'
		Sele fbal
		Seek fact.c_code
		Sum n_amount To mop While c_act_code=fact.c_code
		Repl mact.opning With mop
	Endi
	Sele mact
	Repl FAX2 With fact.c_code

	wacctgroup=''
	wgroupcode=''
	parentgrup=''
	wcurrentaccount=Alltrim(Upper(msname))
	Do Case
		Case 'BRANCH'$wcurrentaccount Or 'DIVISION'$wcurrentaccount
			wgroupcode='A '
		Case 'CAPITAL'$wcurrentaccount And ('A/C'$wcurrentaccount Or 'ACCOUNT'$wcurrentaccount)
			wgroupcode='B '
		Case 'RESERVE'$wcurrentaccount And 'SURPLUS'$wcurrentaccount
			wgroupcode='B '
		Case 'CURRENT ASSET'$wcurrentaccount
			wgroupcode='C '
		Case 'FIXED'$wcurrentaccount And 'ASSET'$wcurrentaccount
			wgroupcode='E '
		Case 'INVESTMENT'$wcurrentaccount
			wgroupcode='F   '
		Case 'CURRENT LIABILIT'$wcurrentaccount
			wgroupcode='D '
		Case ('DUTY'$wcurrentaccount Or 'DUTIES'$wcurrentaccount) And 'TAXES'$wcurrentaccount
			wgroupcode='D '
		Case 'SALES TAX'$wcurrentaccount And 'CENTRAL'$wcurrentaccount
			wgroupcode='D11'
		Case 'SALES TAX'$wcurrentaccount And 'LOCAL'$wcurrentaccount
			wgroupcode='D12 '
		Case 'PROVISIONS'$wcurrentaccount
			wgroupcode='D  '
		Case 'LOAN' $wcurrentaccount And 'LIABILITY' $wcurrentaccount
			wgroupcode='G   '
		Case 'MISC. EXPENSES' $wcurrentaccount And 'ASSET'$wcurrentaccount
			wgroupcode='H   '
		Case 'PROFIT & LOSS A/C'$wcurrentaccount
			wgroupcode='I   '
		Case 'REVENUE'$wcurrentaccount
			wgroupcode='J   '
		Case 'SUNDRY CREDITOR'$wcurrentaccount
			wgroupcode='D31 '
		Case 'SUPPLIER'$wcurrentaccount
			wgroupcode='D31 '
		Case 'SUNDRY DEBTOR'$wcurrentaccount &&&or fdet.mastertype=7
			wgroupcode='C6 '
		Case 'DEPOSITS'$wcurrentaccount
			wgroupcode='C3 '
		Case 'INVESTMENT'$wcurrentaccount
			wgroupcode='F '
		Case "BANK"$wcurrentaccount &&and 'ACCOU'$wcurrentaccount and !('ODD'$wcurrentaccount) and !('OCC'$wcurrentaccount)
			wgroupcode='C1   '
		Case "CASH"$wcurrentaccount And ('IN'$wcurrentaccount Or 'A/C'$wcurrentaccount Or 'AC'$wcurrentaccount) And 'HAND'$wcurrentaccount
			wgroupcode='C2   '
			wgroupcode='C2   '
			parentgrup='C '
		Case "STOCK" $ wcurrentaccount And ('CURRENT'$wcurrentaccount Or 'IN-HAND'$wcurrentaccount Or 'IN HAND'$wcurrentaccount)
			wacctgroup='C5 '
			wgroupcode='C   '
			parentgrup='C '
		Case "BANK OD A/C" $wcurrentaccount Or "BANK OCC A/C" $wcurrentaccount
			wgroupcode="G1 "
		Case "LOAN" $wcurrentaccount And "ADVANCE" $wcurrentaccount
			wgroupcode="C4  "
		Case "SECURED LOAN" $wcurrentaccount
			wgroupcode="G2  "
		Case "UNSECURED LOAN" $wcurrentaccount
			wgroupcode="G3  "
		Case "DIRECT" $wcurrentaccount And !("INDIRECT"$wcurrentaccount)
			If "INCOME"$wcurrentaccount
				wgroupcode="J3 "
			Endif
			If "EXPENSE" $wcurrentaccount
				wacctgroup='J11 '
				wgroupcode="J1  "
				parentgrup='J1 '
			Endif
		Case "INDIRECT" $wcurrentaccount
			If "INCOME" $wcurrentaccount
				wgroupcode="J4 "
			Endif
			If "EXPENSE" $wcurrentaccount
				wgroupcode="J12  "
			Endif
		Case 'SALE'$wcurrentaccount
			If "CENTRAL"$wcurrentaccount Or "CST"$wcurrentaccount
				wgroupcode='J61  '
			Else
				wgroupcode='J62  '
			Endif
		Case 'PURCHASE'$wcurrentaccount
			If "CENTRAL"$wcurrentaccount Or "CST"$wcurrentaccount
				wgroupcode="J51  "
			Else
				wgroupcode="J52  "
			Endif
		Otherwise
	Endcase
	Repl mact.scode With wgroupcode
	Sele Support
	Append Blank
	Repl aliasE With 'LBTDETAI'
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl heading With iif(substr(mact.gstno,1,2)=mstatecode or empty(mact.gstno),'L            LN          ','L            ON          ')
	Appe Blank
	Repl aliasE With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl pcode With 15
	Repl sno With 7
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',mstatecode ,Subs(mact.gstno,1,2))
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-LD",lcode With mact.ordno,Value With mact.balance
	Sele fact
	Skip
Enddo
Sele mact
Appen Blank
Repl scode With 'J12'
Repl ordno With 'PU9999'
Repl parnam With 'OTHER ADD/LESS IN PURCHASE'
Repl mailnam With 'OTHER ADD/LESS IN PURCHASE'
Appen Blank
Repl scode With 'J12'
Repl ordno With 'PUU999'
Repl parnam With 'OTHER ADD/LESS-1 IN PURCHASE'
Repl mailnam With 'OTHER ADD/LESS-1 IN PURCHASE'
Appen Blank
Repl scode With 'J12'
Repl ordno With 'FR9999'
Repl parnam With 'OTHER ADD/LESS IN BILLS '
Repl mailnam With 'OTHER ADD/LESS IN BILLS'

Appen Blank
Repl scode With 'J12'
Repl ordno With 'OT9999'
Repl parnam With 'OTHER ADD/LESS IN BILLS '
Repl mailnam With 'OTHER ADD/LESS IN BILLS'
close table all
if old_3='Y'
	@Rowno,22 Say '**** Importing Customer Last Year Opening Bills ****' Font 'Courier New',12
	Rowno=Rowno+1
	sele sele(1)
	use &datdev\pendings.&datext alias mpend
	sele sele(1)
	use &datdev\order.&datext alias mord
	inde on ordno to mord
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	sele sele(1)
	use &datatransferpath\act_open_tran alias fout
	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10
	sele fout
	go top
	scan 
		mvcn=alltri(fout.c_prefix)+alltri(str(fout.n_srno))
		sele mord
		seek substr(alltri(fout.c_cust_cod)+space(6),1,6)
		sele mpend
		appen blan
		repl acgroup with mord->scode
		repl ord with mord.ordno
		repl ddate with fout.d_date
		repl vcn with mvcn
		repl invtype with 'O'
		repl voucher  with vou
		repl svoucher with svou
		repl final with iif(acgroup='D31',-abs(fout->n_amount),abs(fout->n_amount))
		repl balance with iif(acgroup='D31',-abs(fout.n_amount),abs(fout.n_amount))
		repl name with vcn
		vou=vou+5
		svou=svou+5
	endsc
	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5
	close table all

	@Rowno,22 Say '**** Importing Customer Outstanding ****' Font 'Courier New',12
	Rowno=Rowno+1
	sele sele(1)
	use &datdev\pendings.&datext alias mpend
	sele sele(1)
	use &datdev\order.&datext alias mord
	inde on ordno to mord
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	sele sele(1)
	use &datatransferpath\inv_mst alias fout
	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10
	sele fout
	go top
	scan 
		mvcn=alltri(fout.c_prefix)+alltri(str(fout.n_srno))
		sele mord
		seek substr(alltri(fout.c_cust_cod)+space(6),1,6)
		sele mpend
		appen blan
		repl acgroup with mord->scode
		repl ord with mord.ordno
		repl ddate with fout.d_date
		repl vcn with mvcn
		repl invtype with 'O'
		repl voucher  with vou
		repl svoucher with svou
		repl final with iif(acgroup='D31',-abs(fout->n_total),abs(fout->n_total))
		repl balance with iif(acgroup='D31',-abs(fout.n_inv_bal_),abs(fout.n_inv_bal_))
		repl itemope with iif(acgroup='D31',-abs(fout->n_total-fout.n_inv_bal_),abs(fout->n_total-fout.n_inv_bal_))
		repl name with vcn
		vou=vou+5
		svou=svou+5
	endsc
	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5
	close table all
	@Rowno,22 Say '**** Importing Supplier Outstanding ****' Font 'Courier New',12
	Rowno=Rowno+1
	sele sele(1)
	use &datdev\pendings.&datext alias mpend
	sele sele(1)
	use &datdev\order.&datext alias mord
	inde on ordno to mord
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	sele sele(1)
	use &datatransferpath\pur_mst alias fout
	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10
	sele fout
	go top
	scan 
		mvcn=alltri(fout.c_prefix)+alltri(str(fout.n_srno))
		sele mord
		seek substr(alltri(fout.c_supp_cod)+space(6),1,6)
		sele mpend
		appen blan
		repl acgroup with mord->scode
		repl ord with mord.ordno
		repl ddate with fout.d_date
		repl vcn with mvcn
		repl invtype with 'O'
		repl voucher  with vou
		repl svoucher with svou
		repl final with iif(acgroup='D31',-abs(fout->n_total),abs(fout->n_total))
		repl balance with iif(acgroup='D31',-abs(fout.n_bal_amt),abs(fout.n_bal_amt))
		repl itemope with iif(acgroup='D31',-abs(fout->n_total-fout.n_bal_amt),abs(fout->n_total-fout.n_bal_amt))
		repl name with vcn
		vou=vou+5
		svou=svou+5
	endsc
	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5
	close table all
	@Rowno,22 Say '**** Importing Credit Note Outstanding ****' Font 'Courier New',12
	Rowno=Rowno+1
	sele sele(1)
	use &datdev\pendings.&datext alias mpend
	sele sele(1)
	use &datdev\order.&datext alias mord
	inde on ordno to mord
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	sele sele(1)
	use &datatransferpath\crnt_mst alias fout
	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10
	sele fout
	go top
	scan 
		mvcn=alltri(fout.c_prefix)+alltri(str(fout.n_srno))
		sele mord
		seek substr(alltri(fout.c_cust_cod)+space(6),1,6)
		sele mpend
		appen blan
		repl acgroup with mord->scode
		repl ord with mord.ordno
		repl ddate with fout.d_date
		repl vcn with mvcn
		repl invtype with 'O'
		repl voucher  with vou
		repl svoucher with svou
		repl final with -(fout.nc_round_a+fout.n_non_taxa)
		repl balance with -(fout.nc_round_a+fout.n_non_taxa)
		repl itemope with 0
		repl name with vcn
		vou=vou+5
		svou=svou+5
	endsc
	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5
	close table all


	@Rowno,22 Say '**** Importing Ledger Balance****' Font 'Courier New',12
	Rowno=Rowno+1
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
endif


Proc rem_dupl
	Sele Sele(1)
	Crea Curs dbffile (filepath Varchar(100),filname Varchar(35),filsel N(1))
	defpath=Alltrim(datatransferpath) &&GETDIR(sys(5)+sys(2003),'Select Path for Backup','Select Path',64)
	If Empty(defpath)
		m.dbfpath=Alltrim(datatransferpath) &&curdir()
		Retu
	Endif
	m.dbfpath=defpath
	tlen=Adir(dmarr,defpath+'\*.DBF')
	Sele dbffile
	Appe Blan
	Repl filepath With dbfpath,filname With 'MFAC_mst.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'STOCK.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'ACT_MST.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'PUR_MST.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'PUR_DET.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'INV_MST.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'INV_DET.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'CRNT_MST.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'CRNT_DET.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'PACK_MST.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'ITEM_MST.DBF',filsel With 1
	Appe Blan
	Repl filepath With dbfpath,filname With 'ACT_MST.DBF',filsel With 1

	*zap
	*!*	for icOUNT=1 to tlen
	*!*	    if 'FOXUSER.'$dmarr(iCount,1)
	*!*	       loop
	*!*	    endif
	*!*	    if file(dbfpath+'\'+dmarr(iCount,1))
	*!*	       appe blan
	*!*	       repl filepath with dbfpath,filname with dmarr(iCount,1),filsel with 1
	*!*	    endif
	*!*	next
	Sele dbffile
	Go Top
	tmptabl=Sys(2023)+'\'+Sys(3)+'.DBF'
	Do Whil File(tmptabl)
		tmptabl=Sys(2023)+'\'+Sys(3)+'.DBF'
	Enddo
	=Strtofil('DD',tmptabl)
	Tmpfil=Sys(2023)+'\'+Sys(3)+'.TMP'
	Do Whil File(Tmpfil)
		Tmpfil=Sys(2023)+'\'+Sys(3)+'.TMP'
	Enddo
	=Strtofil('DD',Tmpfil)
	*----------------------------------------*
	scntabl=Sys(2023)+'\'+Sys(3)+'.DBF'
	Do Whil File(scntabl)
		scntabl=Sys(2023)+'\'+Sys(3)+'.DBF'
	Enddo
	=Strtofil('DD',scntabl)
	scnfil=Sys(2023)+'\'+Sys(3)+'.TMP'
	Do Whil File(scnfil)
		scnfil=Sys(2023)+'\'+Sys(3)+'.TMP'
	Enddo
	=Strtofil('DD',scnfil)
	Eras "&tmptabl"
	Eras "&tmpfil"
	Eras "&scntabl"
	Eras "&scnfil"
	*----------------------------------------*
	If Used('MYTEMP')
		Use In MyTemp
	Endif
	Sele Sele(1)
	**crea curs MyTemp (field_name c(10),field_type c(1),field_len n(3),field_dec n(3))
	Crea Curs MyTemp (FIELD_NAME c(10),;
		FIELD_TYPE c(1),;
		FIELD_LEN N(3),;
		FIELD_DEC N(3),;
		FIELD_NULL L,;
		FIELD_NOCP L,;
		FIELD_DEFA M,;
		FIELD_RULE M,;
		FIELD_ERR M,;
		TABLE_RULE M,;
		TABLE_ERR M,;
		TABLE_NAME c(128),;
		INS_TRIG M,;
		UPD_TRIG M,;
		DEL_TRIG M,;
		TABLE_CMT M,;
		FIELD_NEXT I,;
		FIELD_STEP I)

	Sele dbffile

	Coun To tot For filsel=1
	If tot=0
		=Messagebox('No file(s) selected for conversion.',64,'Marg')
		Retu
	Endif
	*set notif off
	m.errno=0
	**on error m.errno=error()
	totfiles=0
	If File('MYCMD.TXT')
		Eras &mycmd.txt
	Endif
	Sele dbffile
	Scan For filsel=1
		*!*	if alltrim(upper(table_name))='MFAC_MST'
		m.errno=0
		filnm=Addbs(Rtri(dbfpath))+filname

		filsc=Justpath(filnm)+Juststem(filnm)+"_2nd."+Justext(filnm)
		If At(' ',filnm)>0
			filnm='"'+filnm+'"'
		Endif
		If At(' ',filsc)>0
			filsc='"'+filsc+'"'
		Endif
		Try
			Sele Sele(1)
			Use &filnm
		Catch To oexp
			m.errno=oexp.ErrorNo
		Endtry
		If m.errno=0
			Use
			Loop
		Endif
		fp=Fopen(filnm)
		If fp<0
			=Messagebox('Error opening File :'+Chr(13)+dbffile->filname+Chr(13)+'Please check whether utility is already running.',64,'Marg')
			Loop
		Endif
		Wait Wind 'Processing '+dbffile->filname+Chr(13)+'Please wait.....' At 2,2 Nowa
		=Fseek(fp,0,0)
		filtyp=Fread(fp,1)
		lstdat=Fread(fp,3)
		norecs=Fread(fp,4)
		frstrec=Fread(fp,2)
		reclength=Fread(fp,2)
		Reserve=Fread(fp,16)
		table_flag=Fread(fp,1)
		code_page=Fread(fp,1)
		hdr_end=Fread(fp,2)
		frstrec=Asc(Left(frstrec,1))+256*Asc(Subs(frstrec,2,1))
		** noflds=(frstrec-296)/32
		noflds=(frstrec-32)/32
		norecs=Asc(Left(norecs,1))+256*Asc(Subs(norecs,2,1))+65536*Asc(Subs(norecs,3,1))+16777216*Asc(Subs(norecs,4,1))
		**cmd='CREATE CURS TMP ('
		reco_len=Asc(Left(reclength,1))+Asc(Subs(reclength,2,1))*256
		If noflds>250
			acflds=250
			Dime fldarray(250,4)
		Else
			acflds=noflds
			Dime fldarray(noflds,4)
		Endif
		For dvfp_i=1 To acflds
			fname=Padr(Fread(fp,10),10)
			resv=Fread(fp,1)
			fltyp=Fread(fp,1)
			resv=Fread(fp,4)
			flen=Asc(Fread(fp,1))
			fdeci=Asc(Fread(fp,1))
			resv2=Fread(fp,14)
			fldarray(dvfp_i,1)=fltyp
			fldarray(dvfp_i,2)=flen
			fldarray(dvfp_i,3)=fdeci
			newfldnm=''
			For dvfp_j=1 To 10
				_chr=Subs(fname,dvfp_j,1)
				If Isalpha(_chr) Or Isdigit(_chr) Or _chr='_'
					newfldnm=newfldnm+_chr
				Else
					*exit
				Endif
			Next
			fldarray(dvfp_i,4)=newfldnm  && allt(chrtran(fname,chr(0),''))
			**=STRTOFILE(fname+' '+fldarray(dvfp_i,4)+CHR(13)+CHR(10),'MYCMD.txt',1)
		Next
		duplfnd=.F.
		newnum=1
		For dvfp_i=1 To acflds-1
			For dvfp_j=dvfp_i+1 To acflds
				dvfp_f1=Allt(fldarray(dvfp_i,4))
				dvfp_f2=Allt(fldarray(dvfp_j,4))
				If dvfp_f1=dvfp_f2
					duplfnd=.T.
					If newnum<100
						nnm=Left(dvfp_f2,8)+Subs(Str(100+newnum,3),2)
					Else
						nnm=Left(dvfp_f2,7)+Subs(Str(1000+newnum,4),2)
					Endif
					fldarray(dvfp_j,4)=nnm
					newnum=newnum+1
				Endif
			Next
		Next
		If !duplfnd
			=Fclos(fp)
			Wait Clea
			Loop
		Endif
		dvfp_len=1
		For dvfp_i=1 To acflds
			*if dvfp_i>250
			*   exit
			*endif
			flen=fldarray(dvfp_i,2)
			fdeci=fldarray(dvfp_i,3)
			**cmd=cmd+fldarray(dvfp_i,4)+' '+allt(fldarray(dvfp_i,1))+'('+ltri(str(flen,3))+;
			**    iif(fdeci>0,','+ltri(str(fdeci,3)),'')+'),'
			dvfp_len=dvfp_len+flen
			Sele MyTemp
			Appe Blan
			Repl FIELD_NAME With fldarray(dvfp_i,4),FIELD_TYPE With fldarray(dvfp_i,1),;
				FIELD_LEN With flen,FIELD_DEC With fdeci
		Next
		If Used('TMP')
			Sele TMP
			Use
		Endif
		mt_250=.F.
		Sele MyTemp
		If Recc()<251
			Copy To "&tmptabl"
			If File("&tmpfil")
				Eras "&tmpfil"
			Endif
			Sele Sele(1)
			Use "&tmptabl"
			Use
			Sele Sele(1)
			Crea "&tmpfil" From "&tmptabl"
			Use
			Use "&tmpfil" Alias TMP
			Eras "&tmptabl"
		Else
			mt_250=.T.
			Copy To "&tmptabl" For Recn()<251
			If File("&tmpfil")
				Eras "&tmpfil"
			Endif
			Sele Sele(1)
			Use "&tmptabl"
			Use
			Sele Sele(1)
			Crea "&tmpfil" From "&tmptabl"
			Use
			Use "&tmpfil" Alias TMP
			Eras "&tmptabl"
			Sele MyTemp
			Copy To "&scntabl" For Recn()>250
			If File("&scnfil")
				Eras "&scnfil"
			Endif
			Sele Sele(1)
			Use "&scntabl"
			Use
			Sele Sele(1)
			Crea "&scnfil" From "&scntabl"
			Use
			Use "&scnfil" Alias TMP2
			Eras "&scntabl"
		Endif
		Sele MyTemp
		Zap

		=Fseek(fp,frstrec,0)
		For I=1 To norecs
			delmrk=Fread(fp,1)
			If mt_250
				Sele TMP2
				Appe Blan
			Endif
			Sele TMP
			Appe Blan
			For j=1 To noflds
				If j>250
					=Fread(fp,reco_len-dvfp_len)
					*for _k=j to noflds
					*fldval=fread(fp,fldarray(_k,2))
					*if len(fldval)<fldarray(j,2)
					*   i=norecs+1
					*   exit
					*endif
					*if fldarray(j,1)$'INFBY'
					*   fldval=val(fldval)
					*endif
					*if fldarray(j,1)='D'
					*   fldval=ctod('^'+left(fldval,4)+'/'+subs(fldval,5,2)+'/'+subs(fldval,7))
					*endif
					*if fldarray(j,1)='L'
					*   if vartype(fldval)='C'
					*      if fldval$'Yy1'
					*         fldval=.T.
					*      else
					*         fldval=.F.
					*      endif
					*   else
					*      if vartype(fldval)$'INF'
					*         if fldval=1
					*            fldval=.T.
					*         else
					*            fldval=.F.
					*         endif
					*      else
					*         fldval=.F.
					*      endif
					*   endif
					*endif
					*Sele TMP2
					*fnam=field(_k-250)
					*repl &fnam with fldval in TMP2
					*next
					*if delmrk='*'
					*   dele in TMP2
					*endif
					Exit
				Endif
				fldval=Fread(fp,fldarray(j,2))
				If Len(fldval)<fldarray(j,2)
					I=norecs+1
					Exit
				Endif
				If fldarray(j,1)$'INFBY'
					fldval=Val(fldval)
				Endif
				If fldarray(j,1)='D'
					fldval=Ctod('^'+Left(fldval,4)+'/'+Subs(fldval,5,2)+'/'+Subs(fldval,7))
				Endif
				If fldarray(j,1)='L'
					If Vartype(fldval)='C'
						If fldval$'Yy1'
							fldval=.T.
						Else
							fldval=.F.
						Endif
					Else
						If Vartype(fldval)$'INF'
							If fldval=1
								fldval=.T.
							Else
								fldval=.F.
							Endif
						Else
							fldval=.F.
						Endif
					Endif
				Endif
				Sele TMP
				fnam=Field(j)
				Repl &fnam With fldval In TMP
			Next
			If delmrk='*'
				Dele In TMP
			Endif
		Next
		=Fclos(fp)
		Wait Clea
		Sele TMP
		Copy To &filnm
		Use
		Eras "&tmpfil"
		If mt_250
			Sele TMP2
			Copy To &filsc
			Use
			Eras "&scnfil"
		Endif
		Wait Wind 'File converted successfully !'+Chr(13)+dbffile->filname At 2,2 Time 2
		totfiles=totfiles+1
		*!*	endif
	Endscan
	On Error
	If totfiles>0
		=Messagebox('Total '+Ltri(Str(totfiles,5))+' file(s) converted',48,'Marg')
	Else
		=Messagebox('No files found with duplicate fields.',64,'Marg')
	Endif
	Sele MyTemp
	Use
