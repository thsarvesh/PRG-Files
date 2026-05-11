*!*	BOF Essel_sql.prg (37)   Author-> Umesh Nath Goswami
*!* Dated 12th April,2024
Clos Tables All
Set Date To brit
Set Cent On
Set Dele On
Set Safe Off
Set Cpdi Off
Set Color To
Set Status Off
Set Talk Off
*For Execution in VFP Direct
if type('FINALCP')='U'
	firstdate=Ctod('01/04/2024')
	lastdate =Ctod('31/03/2025')
	datdev='d:\transfer\'
	datext='DBF'
endi
clea
SURE='SURE'
datatransferpath=Substr('D:\2025\March\Essel_\DMO20260312\Mast\'+Space(80),1,80)
datatransferpath1=Substr('D:\2025\March\Essel_\DMO20260312\sub\'+Space(80),1,80)
datatransferext='dbf'
old_3 = 'YES'
old_4 = 'NO '
old_5 = firstdate
old_6 = lastdate
old_7= ''
mstatecode='37'
if type('FINALCP')#'U'
rest screen from SIMPLE
colofhed="Essel Sql Transfer"
=colofil(03,08,13,70,10)
endi
@04,10 Say 'Essel Master Path :' Font 'courier',18 Get datatransferpath   Font 'courier',18
@05,10 Say 'Essel Stock Path  :' Font 'courier',18 Get datatransferpath1   Font 'courier',18
@06,10 Say 'Essel Data Ext.   :' Font 'courier',18 Get datatransferext   Font 'courier',18
@07,10 Say 'With O/S          :' Font 'courier',18 Get old_3 Pict '@^ YES,NO '  Font 'courier',12
@08,10 Say 'Only Balance      :' Font 'courier',18 Get old_4 Pict '@^ YES,NO '  Font 'courier',12
@09,10 Say 'F.Y.Begin From    :' Font 'courier',18 Get old_5  Font 'courier',18
@10,10 Say 'F.Y.Upto          :' Font 'courier',18 Get old_6  Font 'courier',18
@11,10 Say 'Your State Code   :' Font 'courier',18 Get mstatecode Font 'courier',18
@12,10 Say 'Type SURE         :' Font 'courier',18 Get SURE Pict '@x!' Font 'courier',18
Read
datatransferpath = Alltrim(datatransferpath)
datatransferpath1 = Alltrim(datatransferpath1)
datatransferext=Alltrim(datatransferext)
datdev=Alltrim(datdev)
datext=Alltrim(datext)
if type('FINALCP')#'U'
	=starttransfer()
endi
rowno=1
If Lastkey()=27 .And. SURE#'SURE'
	Return
Endif
Clear

@02,22 Say 'Please Wait Importing Essel Sql Data Into Marg....' Font 'Arial',14 Colo 'W+/G'
Sele Sele(1)
Use &datdev\Pro.&datext
zap
use &datdev\Order.&datext
zap
use &datdev\SaleType.&datext
zap
Use &datdev\Gledger.&datext
Zap
Use &datdev\Pendings.&datext
Zap
Use &datdev\Pend.&datext
Zap
Use &datdev\Probat.&datext
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
Use &datdev\saletype.&datext
Zap
Use &datdev\Support.&datext
Zap
clos table all
rowno=5
@rowno,10 Say '**** Importing Item Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\drugs_mast alia fitm
sele sele(1)
use &datatransferpath\Drug_Genric alia fgn
inde on gen_id to fgn
sele sele(1)
use &datatransferpath\mnf alia fmnf
inde on mnf_id to fmnf
sele sele(1)
use &datatransferpath\units alia fun
inde on unit_id to fun
sele sele(1)
use &datdev\pro.&datext alias mitm
sele sele(1)
use &datdev\saletype.&datext ALIAS mpcm
index on sgcode + sname + str(igst,5,2) to mpcm
sele fitm
pack
go top
do whil !eof()
   sele mitm
   appe blan
   repl code with fitm->drug_id
   repl name with alltr(str(fitm->drug_id))
   repl product with fitm->drug_name
   repl packing with fitm->drug_pack
   repl billname with product+packing
   =seek(fitm->ps_unit_id,'fun')
   repl unit with fun->unit_short	  
   repl pack with fun->unit_eq
   repl gcode5 with padr(fitm->cat_id,6)
   repl unit2 with ''
   repl taxl with 'T'
   repl taxc with 'T'
   repl decimal with 'Y'
   repl salfix with 'N'
   repl halfsche with 'A'
   repl qtrsche with 'Y'
   repl status with 'Y'
   repl minimum with fitm->min_stock
   repl maximum with fitm->max_stock
   repl rackno with fitm->drug_code
   repl rackno2 with fitm->rackno
   repl prate with 0
   repl ratea with 0
   repl mrp with 0
   repl saltax with fitm->gst/2
   repl cgst with saltax
   repl igst with fitm->gst
   if inlis(fitm->drug_h,'H','h')
   repl gcode4 with '  N#       N     NNMN    '
   endi
   if inlis(fitm->drug_h,'H1','h1')
   repl gcode4 with '  NN       #     NNMN    '
   endi
    
******Hsn Transfer*******
   sele mpcm
   seek 'COMMCD' + substr(fitm->hsncode+space(40),1,40) + str(mitm->igst,5,2)
   if !found()
      append blank
      repl sgcode with 'COMMCD'
      repl scode  with alltr(str(recno()))
      repl sname  with fitm->hsncode
      repl parnam with sname
      repl tax with mitm->saltax
      repl cgst with mitm->cgst
      repl igst with mitm->igst
   endi
   repl mitm->gcode6 with mpcm->scode

******Mnf Transfer*******
if seek(fitm->mnf_id,'fmnf')
   sele mpcm
   seek 'ZZZZZZ' + substr(fmnf->mnf_name+space(40),1,40)
   if !found()
      append blank
      repl sgcode with 'ZZZZZZ'
      repl scode  with alltr(str(fmnf->mnf_id))
      repl sname  with fmnf->mnf_name
      repl parnam with sname
   endi
   repl mitm->gcode with mpcm->scode
endi

******Salt Transfer*******
  if seek(fitm->gen_id,'fgn')
   sele mpcm
   seek 'SALT  ' + substr(fgn->gen_name+space(40),1,40)
   if !found()
      append blank
      repl sgcode with 'SALT'
      repl scode  with alltr(str(fgn->gen_id))
      repl sname  with fgn->gen_name
      repl parnam with sname
   endi
   repl mitm->gcode3 with mpcm->scode
endi
sele fitm
skip
endd
clos table all

@rowno,10 Say '**** Importing Category Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datdev\saletype.&datext alia mslt
index on sgcode+sname to mslt
sele sele(1)
use &datatransferpath\mnf alia fcat
go top
do while !eof()
if mnf_type#'C'
skip
loop
endi 
sele mslt
appen blan
repl sgcode with 'CATEGO'
repl scode with padr(fcat->mnf_id,6)
repl sname with fcat->mnf_name
repl parnam with sname
sele fcat
skip
endd
clos tabl all

@rowno,10 Say '**** Importing Batch Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath1\batch_closingstock alia fsbal
sele sele(1)
use &datdev\pro.&datext alia mitm
index on code to mitm
sele sele(1)
use &datdev\probat.&datext alia msbal
index on str(code) + batchno to msbal
sele fsbal
go top
do whil !eof()
	sele mitm
	seek fsbal->drug_id
	sele msbal
	seek str(fsbal->drug_id)+subs(fsbal->batch+spac(12),1,12)
	if !foun()
		appe blan
		repl code with mitm->code
		repl name with mitm->name
		repl product with mitm->product
		repl packing with mitm->packing
		repl billname with mitm->billname
		repl pack with fsbal->unit_eq
		repl mitm->pack with pack
		repl unit2 with mitm->unit2
		repl unit with mitm->unit
		repl decimal with 'Y'
		repl batchno with fsbal->batch
		mex=alltr(str(fsbal->exp_date))
		expdt=ctod(subs(mex,7,2)+'-'+subs(mex,5,2)+'-'+subs(mex,1,4))
		repl exp with expdt
		repl misc1 with mitm->gcode
		repl opening with 0
		repl o_a with opening
		repl b_a with o_a
		repl balance with b_a
		repl supcode with alltr(str(fsbal->act_id))
		endi
		if fsbal->unit_eq=1 and fsbal->stndeq>1
		repl prate with fsbal->prate
		repl ratea with fsbal->srate
		repl rateb with fsbal->ptr
		repl ratec with fsbal->pgrate
		repl mrp with fsbal->mrp
        else
        if fsbal->unit_eq>1 and fsbal->stndeq=1
        repl prate with fsbal->prate*fsbal->unit_eq
		repl ratea with fsbal->srate*fsbal->unit_eq
		repl rateb with fsbal->ptr*fsbal->unit_eq
		repl ratec with fsbal->pgrate*fsbal->unit_eq
		repl mrp with fsbal->mrp*fsbal->unit_eq
        endi
        endi

		sele fsbal
		skip
		endd
clos tabl all
@rowno,10 Say '**** Importing Batch Stock Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath1\doc_recd alia fsbal
sele sele(1)
use &datatransferpath1\doc_delv alia fdlv
inde on dr_id to fdlv
sele sele(1)
use &datdev\pro.&datext alia mitm
index on code to mitm
sele sele(1)
use &datdev\probat.&datext alia msbal
index on str(code) + batchno to msbal
sele fsbal
set filter to dcr_id=0
go top
do whil !eof()
	sele mitm
	seek fsbal->drug_id
	sele msbal
	seek str(fsbal->drug_id)+subs(fsbal->batch+spac(12),1,12)
	if !foun()
		appe blan
		repl code with mitm->code
		repl name with mitm->name
		repl product with mitm->product
		repl packing with mitm->packing
		repl billname with mitm->billname
		repl pack with iif(fsbal->unit_eq=1,fsbal->stnd_eq,fsbal->unit_eq)
		if mitm->pack=1
		repl mitm->pack with pack
		endi
		repl unit2 with mitm->unit2
		repl unit with mitm->unit
		repl decimal with 'Y'
		mex=alltr(str(fsbal->exp_date))
		expdt=ctod(subs(mex,7,2)+'-'+subs(mex,5,2)+'-'+subs(mex,1,4))
		repl exp with expdt
		repl batchno with fsbal->batch		
		repl misc1 with mitm->gcode
		repl supcode with alltr(str(fsbal->act_id))		
		repl opening with (fsbal.qty+fsbal.free)*iif(fsbal->stnd_eq#0,fsbal->stnd_eq,1)
		repl o_a with opening
		repl b_a with opening
		repl balance with b_a
		else
		repl opening with opening+(fsbal.qty+fsbal.free)*iif(fsbal->stnd_eq#0,fsbal->stnd_eq,1)
		repl o_a with opening
		repl b_a with opening
		repl balance with b_a		
		endi
		if fsbal->unit_eq=1 and fsbal->stnd_eq>1
		repl prate with fsbal->prate
		repl ratea with fsbal->srate
		repl rateb with fsbal->ptr
		repl ratec with fsbal->pgrate
		repl mrp with fsbal->mrp
        else
        if fsbal->unit_eq>1 and fsbal->stnd_eq=1
        repl prate with fsbal->prate*fsbal->unit_eq
		repl ratea with fsbal->srate*fsbal->unit_eq
		repl rateb with fsbal->ptr*fsbal->unit_eq
		repl ratec with fsbal->pgrate*fsbal->unit_eq
		repl mrp with fsbal->mrp*fsbal->unit_eq
        endi
        endi
		sele fdlv
		seek val(fsbal->dr_id)
		sum (qty+free)*iif(stnd_eq#0,stnd_eq,1) to msal whil dr_id=val(fsbal->dr_id)
		sele msbal
		repl opening with opening-msal
		repl o_a with opening
		repl b_a with o_a
		repl balance with b_a
		sele fsbal
		skip
		endd
clos tabl all

@rowno,10 Say '**** Importing Account Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alia mact
sele sele(1)
use &datatransferpath\accounts alia fact
sele sele(1)
use &datatransferpath1\daybook alia fbk
inde on act_id to fbk
sele sele(1)
Use &datdev\Support.&datext Alias Support
index On aliase + Str(sno,3) + lcode To Support
sele fact
go top
scan
last=recno()
   sele mact
   appe blan
   repl scode with icase(fact->acnt_id=768,'C1',fact->acnt_id=769,'C2',fact->acnt_id=774,'D31',fact->acnt_id=775,'C6','J12')
   repl rate with 'Y'
   repl ordno with alltr(str(fact->act_id))
   repl fax1 with ''
   repl fax2 with fact->act_short
   repl parnam  with fact->act_name
   repl paradd with fact->act_add1
   repl paradd1 with fact->act_add2
   repl paradd2 with fact->act_add3
   repl city with fact->act_town
   repl sthed with  'TIN No.'
   repl csthed with 'CST  No.'
   repl Gsthed with 'GST  No.'
   repl gstno with fact->act_apgst
   repl cstno with fact->act_cst
   repl itno with fact->panno
   repl phone1 with fact->act_ph2
   repl phone2 with ''   
   repl phone4 with fact->act_ph1
   repl confir with fact->act_contact
   repl dsm with ''
   repl dlno with allt(fact->act_d20b)+iif(!empty(fact->act_d21b),' '+fact->act_d21b,'')
   repl mailnam with parnam
   repl limit with fact->act_crlimit
   repl duedays with fact->act_crdays
   repl ref with 'Mr.'
   repl price with 'A'
   repl status with 'Y'
   repl adhed with 'Discount'
   sele fbk
   seek(fact->act_id) 
   sum iif(credit#0,credit,0),iif(debit#0,debit,0) to mcr,mdb whil act_id=fact->act_id
   sele mact
   repl opning with iif(scode='D31',-abs(mcr-mdb),abs(mcr-mdb))

*** for state code ***
	Sele Support
	Seek 'ORDER   ' + '  7' +  mact->ordno
	Append Blank
	Repl aliase with 'ORDER   '
	Repl Type with 'F'
	Repl lcode with mact->ordno
	Repl sno with 7
	Repl pcode with 15
	Repl remark with Subs(remark,1,32)+'DEF'+Iif(Subs(mact->Gstno,1,2)='  ',mstatecode,Subs(mact->Gstno,1,2))+'                                           '
***Email
	sele support
	appe blan
	repl aliase With 'ORDER   '
	repl type With 'F'
	repl lcode With mact.ordno
	repl sno With 12
	repl remark With fact->act_email
	repl heading With Substr(Heading,1,21)+Iif(Empty(mact->gstno),'UG','NG')
endsc
close tabl all



