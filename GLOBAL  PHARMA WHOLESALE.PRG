*!*	BOF || SOFTWARE NAME : GLOBAL || DATE 09-03-2026 || AUTOR: SARVESH || TRADE : PHARMA WHOLESALE ||
set talk off
set date to brit
set cent on
set dele on
set safe off
set cpdi off
set color to
if type('FINALCP')='U'
	firstdate=ctod('01/04/2020')
	lastdate =ctod('31/03/2021')
	datdev='d:\transfer'
	datext='DBF'
endif
clear
if type('FINALCP')#'U'
	REST SCREEN FROM SIMPLE 
	colofhed="GLOBAL RETAIL FULL TRANSFER"
	=colofil(03,08,18,70,10)
endif
Sure = 'SURE'
datatransferpath=substr('D:\2025\March\Global\'+Space(80),1,80)
datatransferpath1=substr(''+Space(80),1,80)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'NO '
old_5 = firstdate
old_6 = lastdate
vatgst = 'GST  '
MSTATECODE='37'
softtype='Retail    '
SCALC='9'
PCALC='2'
NSCHEDULEH ='1     '
NSCHEDULEH1='00003 '
NNARCO     ='2     '
Addvalue='No '
fmcg='N'
ISBARCODE='No '
@04,10 say 'CARE  DATA PATH       :' font 'courier',18 get DataTransferPath   font 'courier',18
@05,10 say 'Old  DATA Extension   :' font 'courier',18 get DataTransferExt   font 'courier',18
@06,10 say 'WITH O/S              :' font 'courier',18 get Old_3 pict '@m YES,NO '  font 'courier',18
@07,10 say 'ONLY BALANCE          :' font 'courier',18 get Old_4 pict '@m YES,NO '  font 'courier',18
@08,10 say 'F.Y.BEGIN FROM        :' font 'courier',18 get Old_5  font 'courier',18 
@09,10 say 'F.Y.Upto              :' font 'courier',18 get Old_6  font 'courier',18 
@10,10 say 'GST/VAT               :' font 'courier',18 get vatgst pict '@M GST  ,VAT  ' font 'courier',18 
@11,10 SAY 'SALES CALULATION TYPE :' font 'courier',18 GET SCALC  font 'courier',18 
@12,10 SAY 'PUR CALULATION TYPE   :' font 'courier',18 GET PCALC  font 'courier',18 
@13,10 SAY 'YOUR STATE CODE       :' font 'courier',18 GET MSTATECODE  WHEN vatgst='G' VALID !EMPTY(MSTATECODE) font 'courier',18 
@14,10 say 'Type SURE             :' font 'courier',18 get Sure pict '@x!' font 'courier',18 
Read
datatransferpath = alltrim(datatransferpath)
datatransferpath1 = alltrim(datatransferpath1)

datdev=alltrim(datdev)
datext=alltrim(datext)
if type('FINALCP')#'U'
	=starttransfer()
endif
if lastkey()=27 or sure # 'SURE'
   return
endif
Clear
close data 
rowno=5
@02,22 say 'Please Wait Importing Global Data....' font 'Arial',14 colo 'W+/G'
Sele Sele(1) 
  use &datdev\Pro.&datext 
  zap
  use &datdev\Order.&datext
  zap
  use &datdev\SaleType.&datext
  zap 
  use &datdev\Gledger.&datext
  zap
  use &datdev\Pendings.&datext
  zap
  use &datdev\Pend.&datext
  zap
  use &datdev\Probat.&datext 
  zap
  use &datdev\maOrder.&datext
  zap 
  use &datdev\sBorder.&datext
  zap
  USE &datdev\MDIS.&datext 
  ZAP
  USE &datdev\DIS.&datext 
  ZAP
  USE &datdev\GLMONTH.&datext 
  ZAP
  USE &datdev\GGMONTH.&datext 
  ZAP
  USE &datdev\saletype.&datext  
  DELE ALL FOR INLIST(SGCODE,'ZZZZZZ','COMMCD','SALT','CATEGO','AREA','ROUT')  
  USE &DATDEV\SUPPORT.&DATEXT  
   DELE ALL FOR TYPE='#' AND ALIASE='DAT/F'
   pack
  close data 

@Rowno,10 say '**** Importing Area Master  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
  use &datdev\saletype.&datext alias stype 
  index on sgcode+parnam to stype
sele sele(1)
 use &datatransferpath\areamast alias are
sele are
scan
  sele stype
  seek 'AREA  '+subs(are.areaname,1,15)
  if !found()
    appen blank 
    repl sgcode with 'AREA'
    repl scode with alltrim(Str(recno()))
    repl parnam with are.areaname
    repl sname with are.areaname
 endif    
endscan
close table all 
@Rowno,10 say '**** Importing Company Master  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
  use &datdev\saletype.&datext alias stype 
  index on sgcode+parnam to stype
sele sele(1)
 use &datatransferpath\compmast alias fpcm
sele fpcm
scan
  sele stype
    appen blank 
    repl sgcode with 'ZZZZZZ'
    repl scode with fpcm.compcode
    repl parnam with fpcm.compname
    repl sname with fpcm.compname
endscan
close table all 


@Rowno,10 say '**** Importing Product Master  ****' font 'Arial',10
rowno=rowno+1

sele sele(1)
  use &datdev\pro.&datext alias mitm 
sele sele(1)
  use &datdev\saletype.&datext alias stype 
  index on sgcode+sname+str(igst,6,2) to stype 
sele sele(1)
  use &datatransferpath\prodmast alia fitm
sele fitm
scan
sele mitm
appen blank
repl code with recno()
repl name with fitm.prodcode
repl product with fitm.prodname
repl packing with fitm.prodpack 
repl billname with mitm.product+mitm.packing
repl taxl with 'T'
repl unit with 'PCS'
repl decimal with 'N'
repl saltax with fitm.gst/2
repl cgst with fitm.gst/2
repl igst with fitm.gst
repl gcode with subs(fitm.prodcode,1,2)
repl prate with fitm.pinitrate
repl ratea with fitm.sinitrate
repl rateb with fitm.nprate
repl ratec with fitm.nsrate
repl mrp with   fitm.mrp
 sele stype
 seek 'COMMCD'+subs(fitm.hsncode+space(40),1,40)+str(mitm.igst,6,2)
 if !found()
   appen blank 
   repl sgcode with 'COMMCD'
   repl scode with alltrim(str(recno()))
   repl parnam with fitm.hsncode
   repl sname with fitm.hsncode
   repl igst with mitm.igst
   repl cgst with mitm.cgst
   repl tax with mitm.cgst
 endif
 repl mitm.gcode6 with stype.scode
endscan
close table all 
@Rowno,10 say '**** Importing Stock/Batches  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
inde on name+batchno to msbal
sele sele(1)
use &datatransferpath\stockmst alias fsbal  
sele fsbal
scan
=seek(subs(prodcode+space(10),1,10),'mitm')
sele msbal
seek subs(fsbal->prodcode+space(10),1,10)+subs(fsbal->batch,1,12)
if !foun() 
	appe blank
	repl code with mitm.code
	repl name with mitm.name
	repl product with mitm.product
	repl billname with mitm.billname
	repl packing with mitm.packing 
	repl batchno with fsbal.batch
	repl exp with fsbal.expdate 
	repl mrp with fsbal.mrp
	repl prate with fsbal.pinitrate
	repl ratea with fsbal.sinitrate
	repl rateb with fsbal.nprate
	repl ratec with fsbal.nsrate
	repl deal with fsbal.schqty
	repl free with fsbal.schfree
	repl msbal.opening with ((fsbal.opqty+fsbal.opfree+fsbal.recqty+fsbal.recfree)-(fsbal.issqty+fsbal.issfree))
	repl msbal.balance with ((fsbal.opqty+fsbal.opfree+fsbal.recqty+fsbal.recfree)-(fsbal.issqty+fsbal.issfree))
	repl msbal.o_a with ((fsbal.opqty+fsbal.opfree+fsbal.recqty+fsbal.recfree)-(fsbal.issqty+fsbal.issfree))
	repl msbal.b_a with ((fsbal.opqty+fsbal.opfree+fsbal.recqty+fsbal.recfree)-(fsbal.issqty+fsbal.issfree))
*!*		repl opening with fsbal.prsqty+fsbal.prsfree    
*!*		repl balance with fsbal.prsqty+fsbal.prsfree
*!*		repl o_a with fsbal.prsqty+fsbal.prsfree
*!*		repl b_a with fsbal.prsqty+fsbal.prsfree
	repl supdat with fsbal.purdate
	repl date with fsbal.purdate
	repl supinvo with fsbal.pinvno
else
	repl msbal.opening with msbal.opening + ((fsbal.opqty+fsbal.opfree+fsbal.recqty+fsbal.recfree)-(fsbal.issqty+fsbal.issfree)),;
		msbal.balance with msbal.balance +((fsbal.opqty+fsbal.opfree+fsbal.recqty+fsbal.recfree)-(fsbal.issqty+fsbal.issfree)),;
		msbal.o_a with msbal.o_a + ((fsbal.opqty+fsbal.opfree+fsbal.recqty+fsbal.recfree)-(fsbal.issqty+fsbal.issfree)),;
		msbal.b_a with msbal.b_a + ((fsbal.opqty+fsbal.opfree+fsbal.recqty+fsbal.recfree)-(fsbal.issqty+fsbal.issfree))
*!*		repl opening with opening+fsbal.prsqty+fsbal.prsfree
*!*		repl balance with balance+fsbal.prsqty+fsbal.prsfree
*!*		repl o_a with o_a+fsbal.prsqty+fsbal.prsfree
*!*		repl b_a with b_a+fsbal.prsqty+fsbal.prsfree
	repl supdat with fsbal.purdate
	repl date with fsbal.purdate
	repl supinvo with fsbal.pinvno
endi
endscan
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\accmast alias fact
sele sele(1)
use &datatransferpath\acctran alias fbal
inde on accode to fbal
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='AREA  '
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
	wacctgroup=''
	wgroupcode=''
	parentgrup=''
	wcurrentaccount=alltrim(upper(fact.schname))
	do case
	case 'BRANCH'$wcurrentaccount or 'DIVISION'$wcurrentaccount
		wgroupcode='A '
	case 'CAPITAL'$wcurrentaccount and ('A/C'$wcurrentaccount or 'ACCOUNT'$wcurrentaccount)
		wgroupcode='B '
	case 'RESERVE'$wcurrentaccount and 'SURPLUS'$wcurrentaccount
		wgroupcode='B '
	case 'CURRENT ASSET'$wcurrentaccount
		wgroupcode='C '
	case 'FIXED'$wcurrentaccount and 'ASSET'$wcurrentaccount
		wgroupcode='E '
	case 'INVESTMENT'$wcurrentaccount
		wgroupcode='F   '
	case 'CURRENT LIABILIT'$wcurrentaccount
		wgroupcode='D '
	case ('DUTY'$wcurrentaccount or 'DUTIES'$wcurrentaccount) and 'TAXES'$wcurrentaccount
		wgroupcode='D '
	case 'SALES TAX'$wcurrentaccount and 'CENTRAL'$wcurrentaccount
		wgroupcode='D11'
	case 'SALES TAX'$wcurrentaccount and 'LOCAL'$wcurrentaccount
		wgroupcode='D12 '
	case 'PROVISIONS'$wcurrentaccount
		wgroupcode='D  '
	case 'LOAN' $wcurrentaccount and 'LIABILITY' $wcurrentaccount
		wgroupcode='G   '
	case 'MISC. EXPENSES' $wcurrentaccount and 'ASSET'$wcurrentaccount
		wgroupcode='H   '
	case 'PROFIT & LOSS A/C'$wcurrentaccount
		wgroupcode='I   '
	case 'REVENUE'$wcurrentaccount
		wgroupcode='J   '
	case 'SUNDRY CREDITOR'$wcurrentaccount OR 'CREDITOR'$wcurrentaccount
		wgroupcode='D31 '
	case 'SUPPLIER'$wcurrentaccount
		wgroupcode='D31 '
	case 'SUNDRY DEBTOR'$wcurrentaccount OR 'DEBTOR'$wcurrentaccount or 'SUNDRY DEBITORS'$wcurrentaccount
		wgroupcode='C6 '
	case 'DEPOSITS'$wcurrentaccount
		wgroupcode='C3 '
	case 'INVESTMENT'$wcurrentaccount
		wgroupcode='F '
	case "BANK"$wcurrentaccount &&and 'ACCOU'$wcurrentaccount and !('ODD'$wcurrentaccount) and !('OCC'$wcurrentaccount)
		wgroupcode='C1   '
	case "CASH"$wcurrentaccount and ('IN'$wcurrentaccount OR 'A/C'$wcurrentaccount or 'AC'$wcurrentaccount) and 'HAND'$wcurrentaccount
		wgroupcode='C2   '
		wgroupcode='C2   '
		parentgrup='C '
	case "STOCK" $ wcurrentaccount and ('CURRENT'$wcurrentaccount or 'IN-HAND'$wcurrentaccount or 'IN HAND'$wcurrentaccount)
		wacctgroup='C5 '
		wgroupcode='C   '
		parentgrup='C '
	case "BANK OD A/C" $wcurrentaccount or "BANK OCC A/C" $wcurrentaccount
		wgroupcode="G1 "
	case "LOAN" $wcurrentaccount and "ADVANCE" $wcurrentaccount
		wgroupcode="C4  "
	case "SECURED LOAN" $wcurrentaccount
		wgroupcode="G2  "
	case "UNSECURED LOAN" $wcurrentaccount
		wgroupcode="G3  "
	case "DIRECT" $wcurrentaccount and !("INDIRECT"$wcurrentaccount)
		if "INCOME"$wcurrentaccount
			wgroupcode="J3 "
		endif
		if "EXPENSE" $wcurrentaccount
			wacctgroup='J11 '
			wgroupcode="J1  "
			parentgrup='J1 '
		endif
	case "INDIRECT" $wcurrentaccount
		if "INCOME" $wcurrentaccount
			wgroupcode="J4 "
		endif
		if "EXPENSE" $wcurrentaccount
			wgroupcode="J12  "
		endif
	case 'SALE'$wcurrentaccount
		if "CENTRAL"$wcurrentaccount or "CST"$wcurrentaccount
			wgroupcode='J61  '
		else
			wgroupcode='J62  '
		endif
	case 'PURCHASE'$wcurrentaccount
		if "CENTRAL"$wcurrentaccount or "CST"$wcurrentaccount
			wgroupcode="J51  "
		else
			wgroupcode="J52  "
		endif
	otherwise
	endcase
	repl mact.scode with wgroupcode
	repl mact.rate with 'Y'
	repl mact.ordno with fact.accode
	repl mact.fax2 with fact.accode
	repl mact.parnam  with fact.accname
	repl mact.mailnam with fact.accname
	repl mact.paradd with fact.address1
	repl mact.paradd1 with fact.address2
	repl mact.paradd2 with alltri(fact.town)+' '+alltr(fact.state)
	repl confir with fact.cperson
	repl mact.city with fact.town
	repl mact.dsm with fact.pin
	repl phone1 with fact.phone
	repl dlno with alltri(fact.licno1)+' '+alltri(fact.licno2)
	repl stno with fact.tin
	repl cstno with fact.cst
	repl gstno with fact.gstno,itno with fact.pan
	repl trans with fact.transport
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	&&BALANCE
    sele fbal
    seek fact.accode
    sum iif(credit#0,credit,0),iif(debit#0,debit,0)to cr,dr whil accode=fact.accode
	sele mact
	replace mact.opning with iif(scode='D31',-abs(cr-dr),abs(dr-cr))
	&&&STATE
	sele support
	appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	&&Local/Central Update
	select support
	appe blan
	repl aliase with 'LBTDETAI'
	repl type with 'F'
	repl lcode with mact.ordno
	repl heading with iif(mstatecode=left(mact.gstno,2) and empty(mact.gstno),'L            LN','L            ON ')
	&&&&& Area Master
	sele mpcm
	seek 'AREA  '+substr(upper(fact.areaname)+space(40),1,40)
	if !found()
		appen blank
		repl sgcode with 'AREA  '
		repl scode with 'A'+alltri(str(recno()))
		repl sname with upper(fact.areaname)
		repl parnam with sname
	endif
	repl mact.area with mpcm.scode
endscan
close tables all

proc rem_null
	totfields = afields(arr)
	for imarg = 1 to totfields
		mfldname = arr(imarg, 1)
		do case
			case inlist(arr(imarg,2), "C","V","M")
				replace all &mfldname with '' for isnull(&mfldname)
			case inlist(arr(imarg,2), "B","N","I","F","Y")
				replace all &mfldname with 0 for isnull(&mfldname)
			case inlist(arr(imarg,2), "D","T")
				replace all &mfldname with ctod('') for isnull(&mfldname)
		endcase
	endfor
*!*	EOF || SOFTWARE NAME : GLOBAL || DATE 09-03-2026 || AUTOR: SARVESH || TRADE : PHARMA WHOLESALE ||
