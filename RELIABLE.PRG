*!*	BOF : Reliable.PRG (PHARMA )..... Dated    : 05/05/2022
*!* STATE : ASSAM (18)


clear
set cpdialog off
close tables all
set talk off
set stat off
set date brit
set cent on
set dele on
set safe off
set confirm off

sele sele(1)
create curs mycurs  (setup c(50),value c(4))
sele mycurs
appe blank
repl  setup with 'Item Wise Double Discount ',value with 'Y'
appe blank
repl  setup with 'Volume Discount-1 ',value with 'L'
appe blank
repl  setup with 'LOT',value with 'l'
appe blank
repl  setup with 'Ask Discount in Amount',value with 'N'
brow font 'COURIER',18  nomodify
if type('FINALCP')='U'
	firstdate=ctod('01/04/2024')		  			&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2025')  					&& Un-Comment this for run from VFP
	datdev=substr('d:\transfer\'+space(50),1,50)    && Un-Comment this for run from VFP
	datext='dbf'									&& Un-Comment this for run from VFP
endif
datatransferext='DBF'
datatransferpath =substr('D:\Data_Migration\Nov\Reliable\Dbf\'+space(70),1,70)
*old_2 = '04'
old_3 = 'YES'
old_4 = 'NO '
old_5 = firstdate
old_6 = lastdate
mstatecode='30'
old_8 = 'Wholesale'
scalc = '2'
pcalc = '2'
sure='SURE'
removenull='No '
old_11='Pharma'
mtrade='WholeSale'
clear
close tables all
memotochar='No '
OpeningStock='No '
@ 02,22 say 'Please Wait Importing Relydata To Marg.....' font 'Arial',14 colo 'W+/G'
@ 04,08 to 21,200 doub
@ 06,10 say 'Relydata Data Path   :' font 'Courier',18  get datatransferpath  font 'courier',18
@ 07,10 say 'Relydata Extension   :' font 'Courier',18  get datatransferext  font 'courier',18
@ 08,10 say 'WITH O/S             :' font 'Courier',18  get old_3 pict '@m YES,NO ' font 'courier',18
@ 09,10 say 'N-Full Y-Master      :' font 'Courier',18  get old_4 pict '@m YES,NO ' font 'courier',18
@ 10,10 say '[W]holesale [R]etail :' font 'Courier',18  get old_8 pict '@m Wholesale,Retail   ' font 'Courier',18
@ 11,10 say 'Sales Calculation    :' font 'Courier',18  get scalc font 'Courier',18
@ 12,10 say 'Pur.Calulation       :' font 'Courier',18  get pcalc font 'Courier',18
@ 13,10 say 'Trade                :' font 'Courier',18  get old_11 pict '@M Pharma,FMCG  ' font 'Courier',18
@ 14,10 say 'F.Y.BEGIN Date       :' font 'Courier',18  get old_5  font 'Courier',18
@ 15,10 say 'F.Y.End   Date       :' font 'Courier',18  get old_6   font 'Courier',18
@ 16,10 say 'State Code           :' font 'Courier',18  get mstatecode font 'Courier',18
@ 18,10 say 'Remove Null          :' font 'courier',18  get removenull pict '@m Yes,No ' font 'courier',18
@ 19,10 SAY 'Memo to Character    :' font 'Courier',18  get memotochar pict '@M No ,Yes' font 'Courier',18 
@ 20,10 SAY 'Calculate Opening    :' font 'Courier',18  get OpeningStock pict '@M No ,Yes' font 'Courier',18 
@ 21,10 say 'Type SURE            :' font 'courier',18  get sure pict '@x!' font 'courier',18

read
if type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
endif
clear
close tables all
mtrade=old_8
datatransferpath=alltrim(datatransferpath)
if removenull='Y'
	clear
	@05,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif
old_11=substr(old_11,1,1)
datatransferpath=alltrim(datatransferpath)
If memotochar='Y'
	@07,10 Say 'Converting Memo to Char..Please Wait......' Font 'courier',16
	totfiles=Adir(fhandle,datatransferpath+'*.dbf')
	For cfile = 1 To totfiles
		Use datatransferpath+fhandle(cfile,1)
		If Reccount()>0
			Do memo2char
		Endif
	Next
Endif
CLEAR
*!*	If !Right(datatransferpath,1)='\'
*!*		datatransferpath=Alltrim(datatransferpath)+'\'
*!*	Endif
datatransferext='.'+alltrim(datatransferext)
datdev= alltrim (datdev)
datext= alltrim (datext)
if lastkey() = 27 or upper( sure ) # 'SURE'
	return
endif
clear


rowno=5

@ 02,22 say 'Please Wait Importing Reliable To Marg.....' font 'Arial',14 colo 'W+/G'

set colo to
sele sele(1)
use &datdev\slipno.&datext
go top
replace voucher with 5
replace svoucher with 10

sele sele(1)
use &datdev\glmonth.&datext
zap
use &datdev\ggmonth.&datext
zap
use &datdev\pro.&datext
zap
use &datdev\order.&datext
zap
use &datdev\saletype.&datext
zap
use &datdev\gledger.&datext
zap
use &datdev\pendings.&datext
zap
use &datdev\pend.&datext
zap
use &datdev\probat.&datext
zap
use &datdev\maorder.&datext
zap
use &datdev\sborder.&datext
zap
use &datdev\mdis.&datext
zap
use &datdev\dis.&datext
zap
use &datdev\rate.&datext
zap
use &datdev\ggmonth.&datext
zap
use &datdev\support.&datext
dele all 				&&	For Type='#' And aliase='DAT/F'
pack
close tables all
sele select(1)
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
set colo to
close tables all

@rowno,10 say '**** Importing Company****' font 'Arial',12
rowno=rowno+1


sele sele(1)
use &datatransferpath\company alias fcom
sele sele(1)
use &datdev\saletype.&datext alias mcom

sele fcom
go top
scan
	sele mcom
	append blank
	repl mcom.sgcode with 'ZZZZZZ'
	repl mcom.scode  with alltrim(fcom.comcode)
	repl mcom.sname  with fcom.comname
	repl mcom.parnam with fcom.comname
	repl mcom.tcode with 'No'
endscan
close tables all

@rowno,10 say '**** Importing Salt****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\generic alias fgrp
sele sele(1)
use &datdev\saletype.&datext alias mgrp

sele fgrp
go top
scan
	sele mgrp
	append blank
	repl mgrp.sgcode with 'SALT  '
	repl mgrp.scode  with alltrim(fgrp.gencode)
	repl mgrp.sname  with fgrp.genname
	repl mgrp.parnam with fgrp.genname
	repl mgrp.tcode with 'No'
endscan
close tables all


@rowno,10 say '**** Importing Product****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\product alias fitm

if mtrade='W'
	sele sele(1)
	use &datatransferpath\productplus alias fitm1
	index on prdcode to fitm1
endif
sele sele(1)
use &datdev\pro.&datext alias mitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode + parnam + str(igst,5,2) tag  mpcm
index on sgcode + parnam tag mpcm1
N_SCHEDULEH ='  N#       N     NNM'
N_SCHEDULEH1='  NN       #     NNM'
N_NARCO     ='  #N       N     NNM'
N_TBITEM    ='  NN       #     NNMT    '


sele fitm
go top
scan
	last=recno()
	if mtrade='W'
		select fitm1
		seek fitm.prdcode
	endif
	sele mitm
	append blank
	repl mitm.code with recno()
	repl mitm.name with fitm.prdcode
	repl mitm.product with upper(alltrim(fitm.prdname))
	repl mitm.billname with upper(alltrim(fitm.prdname))+' '+alltrim(fitm.case1)
	repl mitm.packing with fitm.case1
	repl mitm.unit with 'Pcs'
	repl mitm.unit2 with iif(fitm.unit1>1,'STRI','Pcs')
	repl mitm.pack with iif(old_8='W',1,fitm.unit2)
	repl mitm.taxl with 'T'
	repl mitm.taxc with 'T'
if fitm.sched='H1'
    repl mitm.gcode4 with N_SCHEDULEH1

else
   if fitm.sched='H'
      repl mitm.gcode4 with N_SCHEDULEH

   endif   
endif          	
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.status with 'Y'
	repl mitm.saltax with fitm.gst/2
	repl mitm.purtax with fitm.gst/2
	repl mitm.cgst   with fitm.gst/2
	repl mitm.igst   with fitm.gst
	repl rackno with fitm.rackno 
	
	if vart(fitm.comcode)='N'
		repl mitm.gcode  with allt(str(fitm.comcode))
	else
		repl mitm.gcode  with allt(fitm.comcode)

	endif
	if vart(fitm.gencode1)='N'
		repl mitm.gcode3 with 'S'+allt(str(fitm.gencode1))
	else
		repl mitm.gcode3 with 'S'+allt(fitm.gencode1)
	endif
	try
		if mtrade='W'
			repl mitm.mrp with fitm1.mrp
			repl mitm.ratea with fitm1.srate
			repl mitm.rateb with fitm1.trrate
			repl mitm.prate with fitm1.prate
		else
			repl mitm.mrp with fitm.srate
			repl mitm.ratea with fitm.srate
			repl mitm.rateb with fitm.trrate
			repl mitm.prate with fitm.prate

		endif
	catch
		merror=1
	endtry
	repl mitm.maximum with fitm.maxqty

&&HSN
	if !empty(fitm.hsncode)
		xhsn=alltrim(fitm.hsncode)
	else
		xhsn='3004'
	endif

	sele mpcm
	set order to tag mpcm
	seek 'COMMCD' + substr(alltrim(xhsn)+space(15),1,15) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD'
		repl mpcm.scode  with 'H'+alltrim(str(recno()))
		repl mpcm.sname  with substr(alltrim(xhsn)+space(15),1,15)+ substr(xhsn+space(15),1,15) +' '+ alltrim(str(mitm.igst,5,2))
		repl mpcm.parnam with alltrim(xhsn)
		repl mpcm.tax with mitm.saltax
		repl mpcm.cgst with mitm.cgst
		repl mpcm.igst with mitm.igst
		repl mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode

*!*	&&CATEGORY
*!*		Sele mpcm
*!*		Set Order To Tag mpcm1
*!*		Seek 'CATEGO' + Substr(Alltrim(fitm.catagory)+Space(15),1,15)
*!*		If !Found()
*!*			Append Blank
*!*			Repl mpcm.sgcode With 'CATEGO',;
*!*				mpcm.scode  With 'G'+Alltrim(Str(Recno())),;
*!*				mpcm.sname  With Alltrim(fitm.catagory) ,;
*!*				mpcm.parnam With Alltrim(fitm.catagory),;
*!*				mpcm.tcode With 'No'
*!*		Endif
*!*		Repl mitm.gcode5 With mpcm.scode

endscan
close tables all

@rowno,10 say '**** Importing Area****' font 'Arial',12
rowno=rowno+1

fd=datatransferpath + 'area.dbf'
td=datdev + '\saletype.'+datext
sele select(1)
use &fd alias fpcm
sele select(1)
use &td alias mpcm

sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA  '
	repl mpcm.scode  with iif(vart(fpcm.areacode)='N',alltrim(str(fpcm.areacode)),alltrim(fpcm.areacode))
	repl mpcm.sname  with upper(fpcm.areaname)
	repl mpcm.parnam with upper(fpcm.areaname)
	repl mpcm.tcode with 'No'
	repl mpcm.tax with 1
	sele fpcm
	skip
enddo
close table all

@rowno,10 say '**** Importing Salt****' font 'Arial',12
rowno=rowno+1

fd=datatransferpath + 'generic.dbf'
td=datdev + '\saletype.'+datext
sele select(1)
use &fd alias fpcm
sele select(1)
use &td alias mpcm

sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'SALT'
	repl mpcm.scode  with 'S'+fpcm.gencode
	repl mpcm.sname  with upper(fpcm.genname)
	repl mpcm.parnam with upper(fpcm.genname)
	repl mpcm.tcode with 'No'
	repl mpcm.tax with 1
	sele fpcm
	skip
enddo
close table all

@rowno,10 say '**** Importing Salesman****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\rep alias rep
sele sele(1)
use &datdev\order.&datext alias ord
sele rep
scan
	sele ord
	appen blank
	repl scode with 'D32'
	repl ordno with 'S'+iif(vart(rep.repcode)='C',allt(rep.repcode),allt(str(rep.repcode)))
	repl parnam with allt(rep.repname)
	repl mailnam with allt(rep.repname)
endsc
close table all

@rowno,10 say '**** Importing Account Masters****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\ledger alias led
if vart(accode)='N'
	index on subs(allt(str(accode))+space(20),1,20) to led
else
	index on accode to led
endif

sele sele(1)
use datdev+'\support.'+datext  alias tsupp
index on aliase + str(sno,3) + lcode to tsupp

sele sele(1)
use &datatransferpath\acmaster alias fact
sele sele(1)
use &datatransferpath\groups alias fgrp
index on grpcode to fgrp
sele sele(1)
use &datdev\order.&datext alias mact

sele fact
go top
scan
	mopening=0
	mbalance=0
	if vart(led.accode)='C'
		sele led
		seek fact.accode
		scan for  inlist(trntype,'OP','Sr','Sv','Rv','Pu','Pv') and trndate<old_5 while accode=fact.accode
			if old_4='N' and trndate<old_5
				mopening=mopening+amt
			endif
			mbalance=mbalance+amt
		endscan
	else
		sele led
		seek fact.accode
		scan for inlist(trntype,'OP','Sr','Sv','Rv','Pu','Pv') and trndate<old_5 while subs(allt(str(accode))+space(20),1,20)=fact.accode
			if old_4='N' and trndate<old_5
				mopening=mopening+amt
			endif
			mbalance=mbalance+amt
		endscan

	endif
*!*	if fact.accode='24 '
*!*	  wait wind mopening
*!*	endif
	if old_4='Y'
		mopening=mbalance
	endif
	sele mact
	append blank
	repl mact.ordno with alltrim(fact.accode)
	repl mact.parnam  with upper(alltrim(fact.acname))
	repl mact.mailnam with upper(alltrim(fact.acname))
	repl mact.paradd with fact.adr1
	repl mact.paradd1 with fact.adr2
	repl mact.paradd2 with fact.adr3
	repl mact.city with fact.place
	repl mact.dsm with fact.pin
	repl mact.dlno with allt(fact.dlno1)+','+allt(fact.dlno2)+iif(!empty(fact.dlno3),',','')+allt(fact.dlno3)+iif(!empty(fact.dlno4),',','')+allt(fact.dlno4)

	repl mact.gstno with fact.gstno
	merror=0
	try
		repl mact.itno with fact.panno
	catch
		merror=1
	endtry
	repl mact.cstno with fact.cst
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.phone1 with fact.ph
	repl mact.phone2 with fact.mob
	try
		repl mact.fax1 with fact.ph2
	catch
		merror=1
	endtry
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.duedays with fact.crday
	repl mact.area with iif(vart(fact.areacode)='N',alltrim(str(fact.areacode)),alltrim(fact.areacode))
	repl mact.opning with mopening			&&	Iif(old_4='N',fact.opbl,fact.dr)
	repl mact.balance with mbalance
	repl limit with fact.crlmt
	repl disc1 with fact.disc
	repl mact.docu with substr(fact.bnkname,1,24)+' '+allt(fact.bnkbranch)
	repl mact.docu1 with allt(fact.bnkbranch)			&& Address
	repl disc1 with fact.disc
	repl mr with 'S'+allt(fact.repcode)
&& Email ID
	if !empty(fact.email)
		sele tsupp
		append blank
		repl aliase with 'ORDER   '
		repl type with 'F'
		repl lcode with mact.ordno
		repl sno with 12
		repl remark with fact.email
		repl heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
	endif

&& Updating State
	sele tsupp
	seek 'ORDER   ' + '  7' +  mact.ordno
	if !found()
		append blank
		repl aliase with 'ORDER   '
		repl type with 'F'
		repl lcode with mact.ordno
		repl sno with 7
		repl pcode with 15
		repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	endif
	wacctgroup=''
	wgroupcode=''
	parentgrup=''
	select fgrp
	seek fact.grpcode
	wcurrentaccount=alltrim(upper(fgrp.grpname))

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
	case 'SUNDRY CREDITOR'$wcurrentaccount
		wgroupcode='D31 '
	case 'SUPPLIER'$wcurrentaccount or 'VENDOR'$wcurrentaccount or 'CRED'$wcurrentaccount
		wgroupcode='D31 '
	case 'SUNDRY DEBTOR'$wcurrentaccount or 'CUSTOMER'$wcurrentaccount or 'DEBT'$wcurrentaccount
		wgroupcode='C6 '
	case 'DEPOSITS'$wcurrentaccount
		wgroupcode='C3 '
	case 'INVESTMENT'$wcurrentaccount
		wgroupcode='F '
	case "BANK"$wcurrentaccount and 'ACCOU'$wcurrentaccount and !('ODD'$wcurrentaccount) and !('OCC'$wcurrentaccount)
		wgroupcode='C1   '
	case "CASH"$wcurrentaccount and 'IN'$wcurrentaccount and 'HAND'$wcurrentaccount
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
		wgroupcode="J12  "
	endcase
	repl mact.scode with wgroupcode
	repl mact.rate with iif((wgroupcode='C6' or wgroupcode='D31'),'Y','N')


	sele fact
endscan
sele mact
appen blank
repl scode with 'D12'
repl ordno with 'DN999#'
repl parnam with 'D/N PURCHASE'
repl mailnam with 'D/N PURCHASE'
appen blank
repl scode with 'D12'
repl ordno with 'CN999#'
repl parnam with 'C/N PURCHASE'
repl mailnam with 'C/N PURCHASE'
appen blank
repl scode with 'D12'
repl ordno with 'CN998#'
repl parnam with 'C/N SALES'
repl mailnam with 'C/N SALES'
appen blank
repl scode with 'D12'
repl ordno with 'FR998#'
repl parnam with 'FREIGHT CHARGE'
repl mailnam with 'FREIGHT CHARGE'
close tables all
if old_3='Y'
	@rowno,10 say '**** Importing Outstanding(Debtors)****' font 'Arial',12
	rowno=rowno+1
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	mvoucher=voucher+115
	msvoucher=svoucher+105

	sele sele(1)
	use &datdev\pendings.&datext alias mpend
	index on ord to mpend

	sele sele(1)
	use &datdev\order.&datext alias ord
	index on ordno to ord

	sele sele(1)
	use &datatransferpath\ledger alias fout
	copy to rcpt
	
	if old_4='N'
		set filt to trndate<old_5 and inlist(trntype,'Sv','Sr')
	endif
	
	sele sele(1)
	use rcpt alias rcpt

	sele sele(1)
	use &datatransferpath\adjdetails alias adj
	if old_4='N'
		set filt to trndate<old_5
	endif
	if vart(accode)='C'
	    if vart(billvouno)='C'
			index on  str(val(billvouno))+dtoc(billtrndt)+str(val(accode)) to adj
		else
			index on  str(billvouno)+dtoc(billtrndt)+str(val(accode)) to adj
		
		endif	
	else
		index on  str(billvouno)+dtoc(billtrndt)+str(accode) to adj
	endif
	sele fout
	scan for inlist(trntype,'Sv','Sr') &&&&&and vouno='1094 ' and accode='4398 '&&&for cuscode='31 ' and invno=7322
		maccode=iif(vart(accode)='N',alltrim(str(accode)),alltrim(accode))
		=seek(subs(maccode+space(6),1,6),'ord')
		mvoucher=mvoucher+5
		msvoucher=msvoucher+4

		sele adj
		seek str(val(fout.vouno))+dtoc(fout.trndate)+str(val(fout.accode))
		srfound=0
		SrFound=iif(found(),1,0)
*!*	if fout.trntype='Sr' and srfound=0
*!*	    loop 
*!*	endif     
		if vart(adj.accode)='C'
		   if vart(billvouno)='C'
			sum abs(amt) to tot for trndate<old_5 while str(val(billvouno))+dtoc(billtrndt)+str(val(accode))= str(val(fout.vouno))+dtoc(fout.trndate)+str(val(fout.accode))
		   else
		   			sum abs(amt) to tot for trndate<old_5 while str(billvouno)+dtoc(billtrndt)+str(val(accode))= str(val(fout.vouno))+dtoc(fout.trndate)+str(val(fout.accode))
		   endif	
		else
			sum abs(amt) to tot for trndate<old_5 while str(billvouno)+dtoc(billtrndt)+str(accode)=str(val(fout.vouno))+dtoc(fout.trndate)+str(val(fout.accode))
		endif


		sele mpend
		appen blank
		repl voucher  with mvoucher
		repl svoucher with msvoucher
		repl vcn      with iif(val(fout.billno)>0,padl(int(val(fout.billno)),6,'0'),fout.billno)
		repl ddate    with iif(day(fout.billdt)=0,fout.trndate,fout.billdt)
		if fout.trntype='Sv'
			repl final    with fout.amt
		   if tot=0 and year(fout.trndate)<2021			
			  repl itemope  with tot+fout.pamt
			  repl balance  with fout.amt-tot-fout.pamt
		   else
			  repl itemope  with tot
			  repl balance  with fout.amt-tot
		   endif			
		else
			repl final    with -abs(fout.amt)
			repl itemope  with -tot-fout.disc
			repl balance  with -(abs(fout.amt)-tot)
		endif
		repl invtype  with 'O'
		repl ord      with ord.ordno
		repl acgroup  with ord.scode
	endscan
	sele mslip
	repl voucher with mvoucher
	repl svoucher with msvoucher
	close table all

	@rowno,10 say '**** Importing Outstanding(Suppliers)****' font 'Arial',12
	rowno=rowno+1
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	mvoucher=voucher+115
	msvoucher=svoucher+105
	sele sele(1)
	use &datdev\pendings.&datext alias mpend
	index on ord to mpend

	sele sele(1)
	use &datdev\order.&datext alias ord
	index on ordno to ord

	sele sele(1)
	use &datatransferpath\ledger alias fout
	if old_4='N'
		set filt to trndate<old_5 and inlist(trntype,'PB','Pu')
	endif
	sele sele(1)
	use &datatransferpath\adjdetails alias adj
	if vart(accode)='C'
	  if vart(billvouno)='C'
		index on  str(val(billvouno))+dtoc(billtrndt)+str(val(accode)) to adj
	  else
		index on  str(billvouno)+dtoc(billtrndt)+str(val(accode)) to adj
	  
	  endif	
	else
		index on  str(billvouno)+dtoc(billtrndt)+str(accode) to adj

	endif

	sele fout
	scan &&&for cuscode='31 ' and invno=7322
		maccode=iif(vart(accode)='N',alltrim(str(accode)),alltrim(accode))
		=seek(subs(maccode+space(6),1,6),'ord')
		mvoucher=mvoucher+5
		msvoucher=msvoucher+4

		sele adj
        mdate=iif(day(fout.billdt)=0,fout.trndate,fout.billdt)
		seek str(val(fout.vouno))+dtoc(mdate)+str(val(fout.accode))
*!*	?found()
		if vart(adj.accode)='C'
		  if vart(billvouno)='C'
			sum abs(amt) to tot for trndate<old_5 while str(val(billvouno))+dtoc(billtrndt)+str(val(accode))= str(val(fout.vouno))+dtoc(mdate)+str(val(fout.accode))
          else
			sum abs(amt) to tot for trndate<old_5 while str(billvouno)+dtoc(billtrndt)+str(val(accode))= str(val(fout.vouno))+dtoc(mdate)+str(val(fout.accode))
          endif			
		else
			sum abs(amt) to tot for trndate<old_5 while str(billvouno)+dtoc(billtrndt)+str(accode)= str(val(fout.vouno))+dtoc(mdate)+str(val(fout.accode))

		endif


		sele mpend
		appen blank
		repl voucher  with mvoucher
		repl svoucher with msvoucher
		repl vcn      with fout.billno
		repl ddate    with iif(day(fout.billdt)=0,fout.trndate,fout.billdt)
		if ord.scode='C6'
			repl final    with abs(fout.amt)
			repl itemope  with ABS(fout.pamt)
			repl balance  with abs(fout.amt)-ABS(fout.pamt)

		else
			repl final    with -abs(fout.amt)
			repl itemope  with fout.pamt
			repl balance  with -(abs(fout.amt)-fout.pamt)
		endif
		repl invtype  with 'O'
		repl ord      with ord.ordno
		repl acgroup  with ord.scode

	endscan
	sele mslip
	repl voucher with mvoucher
	repl svoucher with msvoucher
*!*	sele ord
*!*	scan
*!*	 sele mpend
*!*	 seek ord.ordno
*!*	 sum balance to tot while ord=ord.ordno
*!*	 sele ord
*!*	 repl opning with tot
*!*	endscan

endif
close table all

@rowno,10 say '**** Importing Batch/Stock****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\batch alias fsbal

sele sele(1)
use &datdev\probat.&datext alias msbal
index on name + batchno to msbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F-BT'
pack

sele fsbal
totrec=reccount()
go top
scan
	sele mitm
	seek substr(fsbal.prdcode+space(10),1,10)
	sele msbal
	seek substr(fsbal.prdcode+space(10),1,10)+substr(fsbal.batch,1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.pack with mitm.pack
		repl msbal.packing with mitm.packing
		repl msbal.unit2 with mitm.unit2
		repl msbal.unit with mitm.unit
		repl msbal.exp with fsbal.exdt
		repl msbal.decimal with 'Y'
		repl msbal.batchno with fsbal.Batch
		repl msbal.lprate with (fsbal.prate-((fsbal.prate*fsbal.pdis)/100))
		repl msbal.prate with fsbal.prate*IIF(FSBAL.UNIT#0 AND OLD_8='R',FSBAL.UNIT,1)
		repl msbal.mrp with fsbal.mrp
		repl msbal.ratea with fsbal.srate*iif(fsbal.unit#0 and old_8='R',fsbal.unit,1)
		repl msbal.rateb with fsbal.splrate
		repl msbal.ratec with fsbal.trrate
		repl msbal.misc1 with mitm.gcode
		repl tqty with fsbal.stock
		repl msbal.opening with 0
		repl msbal.balance with 0
		repl msbal.o_a with 0
		repl msbal.b_a with 0
	else
		repl msbal.tqty with tqty+fsbal.stock
		repl msbal.opening with opening+0
		repl msbal.balance with balance+0
		repl msbal.o_a with o_a+0
		repl msbal.b_a with b_a+0
	endif	
endscan

close tables all

@rowno,10 say '**** Importing Bank Master****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\bank alias fact

sele sele(1)
use &datdev\order.&datext alias mact
index on ordno to mact

sele fact
go top
scan
	sele mact
	append blank
	repl mact.scode with 'C1'
	repl mact.rate with 'N'
	repl mact.ordno with 'B'+alltrim(str(fact.bnkcode))
	repl mact.parnam  with upper(fact.bnkname)
	repl mact.mailnam with upper(fact.bnkname)
	sele fact
endscan
close tables all

mpatient=datatransferpath+'PATIENT.DBF'
if file(mpatient)
	@rowno,10 say '**** Importing Patient Master****' font 'Arial',12
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\patient alias fpat
	sele sele(1)
	use &datdev\maorder.&datext alias maord
	sele fpat
	scan
		sele maord
		appen blank
		repl scode with 'PET#$~'
		repl parnam with upper(fpat.patname)
		repl form  with fpat.patcode
		repl city with alltrim(fpat.adr1)+' '+alltrim(fpat.place)

	endscan
	close tabl all
endif

IF OLD_8='R'
? '** Importing Doctors  .....'
fd=datatransferpath+'docTOR'+datatransferext
td=datdev+'\maorder.'+DATEXT

Sele a
Use &fd Alias fact
Sele b
Use &td Alias mact
Zap

Sele fact
Pack
Go Top
Do While .Not. Eof()
	Sele mact
	Append Blank
	Repl scode With 'PRE#$~'
	Repl mact.ordno With ALLTRIM(fact.doccode),;
		mact.parnam  With Alltrim(fact.docname),;
		mact.CITY with  fact.spec,;
		form With ALLTRIM(fact.doccode)
	Sele fact
	Skip
Enddo
Close TABLES ALL
endif

if old_4='N'
	do import_transactions
endi
close data

proce import_transactions

@rowno,10 say '**** Importing Transactions****' font 'Arial',12
rowno=rowno+1

mdis=datdev + '\mdis.'+datext
af =datdev  + '\gledger.'+datext
bf =datdev  + '\slipno.'+datext
dis=datdev  + '\dis.'+datext
pro=datdev  + '\pro.'+datext
ord=datdev  + '\order.'+datext
pbat=datdev + '\probat.'+datext
msub=datdev +'\subdis.'+datext

** Sales
sal=datatransferpath + 'INVTOTAL'+datatransferext
sld=datatransferpath + 'invdetails'+datatransferext
** Purchase
pur=datatransferpath + 'purchase'+datatransferext
pld=datatransferpath + 'batch'+datatransferext

sele sele(1)
use &pld alias pld
copy to mbatch
sele pld
use

use mbatch alias mbatch
index on subs(prdcode+space(15),1,15)+batchid to mbatch
sp =datdev+'\support.'+datext

sele sele(1)
use &sp alias support
dele all for type='#'  and aliase="DAT/F-SL"
pack

sele sele(1)
use &msub alias msub

sele i
use &bf
go top
last4  = voucher + 10
slast5 = svoucher + 10


@rowno,10 say '**** Importing Sales****' font 'Arial',12
rowno=rowno+1

last4 = last4 + 20

sele e
use &pro alias pro
index on name to pro
sele j
use &ord alias ord
index on ordno to ord

sele c
use &sal alias sal
set filter to invdt>=old_5 and invdt<=old_6 and inlist(type,'21','22','32','61') &&AND INVNO=58
index on invno to sal

sele h
use &sld alias sld
index on str(invno)+type+DTOC(INVDT) to sld
set filter to invdt>=old_5 and invdt<=old_6 

select select(1)
use &pbat alias pbat
index on name+batchno to pbat

sele d
use &mdis alias mdis
sele g
use &dis alias dis

oinvno=0
ocust=''
sele c
go top
do while !eof()
  IF CANCELLED=.T.
     skip 
     loop 
  endif   
*!*		if netamt=0
*!*			skip
*!*			loop
*!*		endif
	if type='E'
		skip
		loop
	endif
	oinvno=c.invno
	ocust =c.cuscode
	=seek(substr(alltrim(c.cuscode)+space(6),1,6),'ord')
	l1 = alltrim(str(invno))
	last1 = c.invno
	sele d
	appe blank
	repl type with iif(atc('32',c.type)#0,'R','S')
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl vcn with padl(c.invno,6,'0') &&&ALLT(c.prefix)+l3
	repl pm with alltrim(str(c.invno))
	repl date with c.invdt
	repl codep with alltrim(c.cuscode)
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.amt1)
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl othun with 'CN998#'
	repl freun with 'FR998#'
	repl other with c.addamt   &&&&&+C.AQUIRE
	repl freight with -c.dedamt
	repl mr with 'S'+iif(vart(c.repcode)='C',allt(c.repcode),allt(str(c.repcode)))
	repl area with iif(vart(c.areacode)='C',allt(c.areacode),allt(str(c.areacode)))
	if mtrade='R'
		repl docu with space(10)+subs(c.name,1,30)
		repl docu1 with space(10)+c.docname
	endif

*!*		If Upper(Alltrim(c.type)) = '21'
*!*			Repl cash With c.netamt
*!*	*		Repl Round With c.recive
*!*		Else
	repl final with c.netamt
*		Repl cash With c.amtpaid

*		Repl Round With c.recive
*!*		Endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
*	Repl duedays With c.duedate-c.invdate
	repl lrda with c.invdt
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with iif(mdis.type='W','Y','A')
	repl ltype with scalc
	repl discafter with 'N'
	repl remark4 with alltrim(str(c.invno))			&&	l3
	repl remark1 with str(round(c.netamt,2))
*	Repl mr With Iif(!Empty(c.sm_Code),"S"+Alltrim(Str(c.sm_Code)),'')

	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

	isigst=0
	sele d
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif

*!*	****Tcs Addition****
*!*		Try
*!*			If c.tcs_amt#0
*!*				Sele msub
*!*				Appen Blan
*!*				Repl Codep With d.Codep
*!*				Repl vcn With d.vcn
*!*				Repl Date With d.Date
*!*				Repl voucher With d.voucher
*!*				Repl Type With '9'
*!*				Repl dsm With 'RETTCS'
*!*				Repl rtqt With Str(c.tcs_amt,12)+' '+'0.075'
*!*			Endif
*!*		Catch

*!*		Endtry

	sele h
	seek str(c.invno)+c.type+DTOC(c.invdt)
	scan while str(invno)+type+dtoc(invdt)=str(c.invno)+c.type+dtoc(c.invdt) .and. !eof()
	    IF CANCELLED=.T.
	       LOOP
	    ENDIF   
		=seek(substr(alltrim(h.prdcode)+space(10),1,10),'pro')
		=seek(substr(alltrim(h.prdcode)+space(10),1,10)+substr(h.batch+space(12),1,12),'pbat')
		=seek(h.prdcode+h.batchid,'mbatch')
		sele g
		appe blank
		repl codep with d.codep
		repl vcn with d.vcn
		repl date with d.date
		repl voucher with d.voucher
		repl code with e.code
		repl tax with 'T'
		repl qty with abs(h.qty)
try		
			repl free with h.free
		catch
			merror=1
		endtry
		repl pack with e.pack
		repl exp with h.exdt
        repl batch with h.batch
if old_8='R'        
		repl flg with iif(mdis.type='S','G',mdis.type) &&&iif(atc('32',c.type)#0 or h.qty<0,'R','G')
		repl godwon with 'A'
else
IF H.SRTYPE=2
        repl flg with 'W'
        repl godwon with 'Y'        
else        
		repl flg with iif(mdis.type='S','G',mdis.type) &&&iif(atc('32',c.type)#0 or h.qty<0,'R','G')
		repl godwon with 'A'
endif		
endif
		repl rate with iif(old_8="W",h.srate,iif(e.pack#0,e.pack*h.srate,h.srate))
		repl lprate with pbat.lprate
		repl disc1 with h.bdis
		repl disc2 with h.pdis
		if isigst=0
			repl ssta with h.st/2
			repl cgst with h.st/2
		else
			repl ssta with h.st
			repl sssc with 0
		endif
		repl sssc with iif(h.pdis=100,0,h.surchrg)
		try
			repl mrp with iif(old_8="W",h.mrp,iif(e.pack#0,e.pack*h.mrp,h.mrp))
		catch
			merror=1
		endtry
try		
		if val(h.scheme)#0 and h.type#'32 '
			repl rsm with chrtran(h.scheme,' ','')
		endif
catch
merror=1
endtry		
		if h.type='32 '
			repl disc1 with 0
			repl disc2 with 0
			try
				repl rate with h.svalue/h.qty
			catch
				merror=1
			endtry
		endif
		if h.svalue=0
			repl qty with 0
			repl free with h.qty+h.free
		endif
		repl half with 'A'
	sele h
	endscan
	sele c
	skip
enddo
close tables all



@rowno,10 say '**** Importing Purchase****' font 'Arial',12
rowno=rowno+1

last4 = last4 + 20
pur=datatransferpath + 'purchase'+datatransferext
pld=datatransferpath + 'batch'+datatransferext

use mbatch alias mbatch
index on prdcode+batchid to mbatch

select select(1)
use &pbat alias pbat
index on name+batchno to pbat

sele sele(1)
use &msub alias msub

sele e
use &pro alias pro
index on name to pro
sele j
use &ord alias ord
index on ordno to ord

sele c
use &pur alias pur
set filter to pdate>=old_5 and pdate<=old_6
sele h

use &pld alias pld
if vart(rctno)='N'
	index on str(rctno)+billno to pld
	isnumeric=1
else
	index on rctno+billno to pld
	isnumeric=0
endif

set filter to pdate>=old_5 and pdate<=old_6

sele d
use &mdis alias mdis
sele g
use &dis alias dis
sp =datdev+'\support.'+datext
sele sele(1)
use &sp alias support
sele c
go top
do while !eof()
	if type#'12'
		skip
		loop
	endif
	=seek(substr(alltrim(str(c.supcode))+space(6),1,6),'ord')
	l1 = alltrim(rctno)
	l2 = len(l1)
	l3 = replicate('0',6-l2)+l1
	last1 = allt(rctno)
	sele d
	appe blank
	repl type with 'P'
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl vcn with l3
	repl date with c.pdate
	repl pm with c.billno
	repl lrda with c.billdt
	repl codep with j.ordno
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.rctamt)
	repl salun with ''
	repl staxun with 'SZTZOZ'

*!*		repl othun with 'DN999#'
*!*		repl freight with c.dbn
	try
		repl other with -(c.ded+c.crn)
	catch
		try
			repl other with -c.ded
		catch
			merror=1
		endtry
	endtry
	repl freight with c.addi
	repl freun with 'FR998#'

	repl final with c.rctamt
*	Repl cash With c.amtpaid

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl duedays with 0
	repl lrda with c.billdt
	repl account with 'N'
	repl sale with iif(old_8='R','z','Z')
	repl godwon with 'A'
	repl ltype with pcalc
	repl discafter with 'N'
	repl remark4 with alltrim(c.rctno)				&&	c.billno
	repl remark1 with str(c.rctamt,12,2)

	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

	isigst=0
	sele d
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif

****Tcs Addition****
	try
		if c.ptcsamt#0
			sele msub
			appen blan
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl type with '9'
			repl dsm with 'RETTCS'
			repl rtqt with str(c.ptcsamt,10,2)+' '+iif(len(alltrim(ord.itno))#0,'0.075','0.100')
		endif
	catch
	endtry
	if isnumeric=1

		sele h
		seek str(val(c.rctno))+c.billno
		do while str(rctno)+billno = str(val(c.rctno))+c.billno .and. !eof()
			=seek(substr(alltrim(h.prdcode)+space(10),1,10),'pro')
			=seek(substr(alltrim(h.prdcode)+space(10),1,10)+substr(h.batch+space(12),1,12),'pbat')
			=seek(h.prdcode+h.batchid,'mbatch')

			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			if mtrade='W' OR OLD_8='W'
				repl qty with  iif(old_8="W",h.rqty,iif(e.pack#0,e.pack*h.rqty,h.rqty))
				repl free with iif(old_8='W',h.fqty,iif(e.pack#0,e.pack*h.fqty,h.fqty))
			else
				repl qty with  H.RQTY   &&&*h.unit &&&iif(old_8="W",h.rqty,iif(e.pack#0,e.pack*h.rqty,h.rqty))
				repl free with h.fqty   &&&*h.unit &&&&iif(old_8='W',h.fqty,iif(e.pack#0,e.pack*h.fqty,h.fqty))

			endif
			repl pack with e.pack
			repl exp with h.exdt
            repl batch with h.batch
			
			repl flg with 'P'
			repl rate with h.prate   &&&&*h.unit
			repl disc1 with h.pdis
			repl disc2 with h.bdis
			try
				repl svdis with h.pschdis
				repl misc4 with subs(misc4,1,43)+'P'+subs(misc4,45)
			catch
				merror=1
			endtry
			if isigst=0
				repl ssta with h.ssgst
				repl cgst with h.scgst
			else
				repl ssta with h.gst
				repl sssc with 0
			endif
			repl sssc with iif(h.pdis=100,0,h.psurchrg)
			
			try
				repl mrp with iif(old_8="W",h.mrp,iif(e.pack#0,e.pack*h.mrp,h.mrp))
			catch
				merror=1
			endtry

			repl deal with iif((h.rqty#0 and h.fqty#0),h.rqty/h.fqty,0)
			repl freedeal with iif((h.rqty#0 and h.fqty#0),h.fqty/h.fqty,0)
			repl half with 'A'
			repl godwon with d.godwon
			try
				repl svdis1 with h.psch
				repl misc4 with subs(misc4,1,44)+'L'+subs(misc4,46)
			catch
				merror=1
			endtry
			sele h
			skip
		enddo
	else
		sele h
		seek c.rctno+c.billno
		do while rctno+billno = c.rctno+c.billno .and. !eof()
			=seek(substr(alltrim(h.prdcode)+space(10),1,10),'pro')
			=seek(substr(alltrim(h.prdcode)+space(10),1,10)+substr(h.batch+space(12),1,12),'pbat')
			=seek(h.prdcode+h.batchid,'mbatch')

			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			if mtrade='W' or old_8='W'
				repl qty with  iif(old_8="W",h.rqty,iif(e.pack#0,e.pack*h.rqty,h.rqty))
				repl free with iif(old_8='W',h.fqty,iif(e.pack#0,e.pack*h.fqty,h.fqty))
			else
				repl qty with  h.rqty   &&&*h.unit &&&iif(old_8="W",h.rqty,iif(e.pack#0,e.pack*h.rqty,h.rqty))
				repl free with h.fqty   &&&*h.unit &&iif(old_8='W',h.fqty,iif(e.pack#0,e.pack*h.fqty,h.fqty))

			endif
            repl batch with h.batch
			repl pack with e.pack
			repl exp with h.exdt
			repl flg with 'P'
			repl rate with h.prate*IIF(OLD_8='R' and e.pack#0,E.pack,1)
			repl disc1 with h.pdis
			repl disc2 with h.bdis
			try
				repl svdis with h.pschdis
				repl misc4 with subs(misc4,1,43)+'P'+subs(misc4,45)
			catch
				merror=1
			endtry
			if isigst=0
				repl ssta with h.ssgst
				repl cgst with h.scgst
			else
				repl ssta with h.gst
				repl sssc with 0
			endif
			try
				repl mrp with iif(old_8="W",h.mrp,iif(e.pack#0,e.pack*h.mrp,h.mrp))
			catch
				merror=1
			endtry

			repl deal with iif((h.rqty#0 and h.fqty#0),h.rqty/h.fqty,0)
			repl freedeal with iif((h.rqty#0 and h.fqty#0),h.fqty/h.fqty,0)
			repl half with 'A'
			repl godwon with d.godwon
			try
				repl svdis1 with h.psch
				repl misc4 with subs(misc4,1,44)+'L'+subs(misc4,46)
			catch
				merror=1
			endtry
			sele h
			skip
		enddo
	endif
	sele c
	skip
enddo


sele sele(1)
use &datatransferpath\purchasereturn alias pret
index on prno to pret

sele c
go top
do while !eof()
	if type#'41'
		skip
		loop
	endif
	=seek(substr(alltrim(str(c.supcode))+space(6),1,6),'ord')
	l1 = alltrim(rctno)
	l2 = len(l1)
	l3 = replicate('0',6-l2)+l1
	last1 = allt(rctno)
	sele d
	appe blank
	repl type with 'B'
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl vcn with l3
	repl date with c.PDATE
	repl pm with c.billno
	repl lrda with c.billdt
	repl codep with j.ordno
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.rctamt)
	repl salun with ''
	repl staxun with 'SZTZOZ'

	repl othun with 'DN999#'
	repl freun with 'FR998#'
*	repl freight with -c.rctamt
	try
		repl other with -(c.ded+c.crn)
	catch
		try
			repl other with -c.ded
		catch
			merror=1
		endtry
	endtry
*	Repl Freight With (c.Freight)

	repl final with c.rctamt
*	Repl cash With c.amtpaid

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl duedays with 0
	repl lrda with c.billdt
	repl account with 'N'
	repl sale with iif(old_8='R','z','Z')
	repl godwon with 'A'
	repl ltype with pcalc
	repl discafter with 'N'
	repl remark4 with alltrim(c.rctno)				&&	c.billno
	repl remark1 with str(c.rctamt,12,2)

	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

	isigst=0
	sele d
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif

*!*	****Tcs Addition****
*!*		Try
*!*			If c.tcs_amt#0
*!*				Sele msub
*!*				Appen Blan
*!*				Repl Codep With d.Codep
*!*				Repl vcn With d.vcn
*!*				Repl Date With d.Date
*!*				Repl voucher With d.voucher
*!*				Repl Type With '9'
*!*				Repl dsm With 'RETTCS'
*!*				Repl rtqt With Str(c.tcs_amt,12)+' '+'0.075'
*!*			Endif
*!*		Catch
*!*		Endtry

	sele pret
	seek c.rctno
	do while prno = c.rctno .and. !eof()
		if mtrade='W'
			=seek(substr(alltrim(pret.prdcode)+space(10),1,10),'pro')
			=seek(substr(alltrim(pret.prdcode)+space(10),1,10)+substr(pret.batch+space(12),1,12),'pbat')
			=seek(h.prdcode+h.batchid,'mbatch')

		else
			=seek(substr(alltrim(pret.code)+space(10),1,10),'pro')
			=seek(substr(alltrim(pret.code)+space(10),1,10)+substr(pret.batch+space(12),1,12),'pbat')
			=seek(h.prdcode+h.batchid,'mbatch')

		endif

		sele g
		appe blank
		repl codep with d.codep
		repl vcn with d.vcn
		repl date with d.date
		repl voucher with d.voucher
		repl code with e.code
		repl tax with 'T'
		if mtrade='W'
			repl qty with  iif(old_8="W",pret.rqty,iif(e.pack#0,e.pack*pret.rqty,pret.rqty))
			repl free with iif(old_8='W',pret.fqty,iif(e.pack#0,e.pack*pret.fqty,pret.fqty))
		else
		   
			repl qty with   (pret.exqty+pret.brqty)*IIF(E.PACK#0,E.PACK,1)
			repl free with val(pret.fqty)*IIF(e.pack#0,e.pack,1)
		endif
		repl pack with e.pack
		repl exp with pret.exdt
		repl batch with pret.batch
        repl batch with h.batchid
		
		repl flg with 'B'
		repl rate with iif(mtrade='W',pret.prate,pret.rate)
		try
			repl disc1 with pret.pdis
			repl disc2 with pret.bdis

			if isigst=0
				repl ssta with pret.ssgst
				repl cgst with pret.scgst
			else
				repl ssta with pret.gst
				repl sssc with 0
			endif
		catch
			merror=1
		endtry
		try
			repl mrp with iif(old_8="W",pret.mrp,iif(e.pack#0,e.pack*pret.mrp,pret.mrp))
		catch
			merror=1
		endtry
		try
			repl deal with iif((pret.rqty#0 and pret.fqty#0),pret.rqty/pret.fqty,0)
			repl freedeal with iif((pret.rqty#0 and pret.fqty#0),pret.fqty/pret.fqty,0)
		catch
			merror=1
		endtry
		repl half with 'A'
		repl godwon with d.godwon

		try
			repl svdis with pret.psch
			repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,45)
		catch
			merror=1
		endtry

*!*			Sele pbat
*!*			Seek Substr(Alltrim(h.prdcode)+Space(10),1,10)+Substr(h.batch+Space(12),1,12)
*!*			If Found()
*!*				Repl pbat.o_a With pbat.o_a-(dis.qty+dis.Free)
*!*				Repl deal With iif((h.rqty#0 and h.fqty#0),h.rqty/h.fqty,0)
*!*				Repl Free With iif((h.rqty#0 and h.fqty#0),h.fqty/h.fqty,0)
*!*				Repl purdeal With iif((h.rqty#0 and h.fqty#0),h.rqty/h.fqty,0)
*!*				Repl purfree With iif((h.rqty#0 and h.fqty#0),h.fqty/h.fqty,0)
*!*			Endif

		sele pret
		skip
	enddo
	sele c
	skip
enddo

close tables all

close tables all

*****
@rowno,10 say '**** Importing Stock Adjustments(Add/Less)****' font 'Arial',12
rowno=rowno+1


last4=last4+20
sele select(1)
use &datatransferpath\stockadj alias apur
index on dtos(adjdt) to apur
set filter to adjdt>=old_5 and adjdt<=old_6

sele select(1)
use &datatransferpath\batch alias fsbal
index on batchid to fsbal

sele sele(1)
use &datdev\pro.&datext alias mitm
inde on name to mitm

sele sele(1)
use &datdev\probat.&datext alias msbal
inde on name+batchno to msbal

sele sele(1)
use mbatch alias mbatch
index on prdcode+batchid to mbatch
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis

last=1
odate={}
sele apur
go top
do while !eof()
	if odate#apur.adjdt
		l1 = alltrim(str(last))
		l2 = len(l1)
		if l2<6
			l3 = replicate('0',6-l2)+l1
		else
			l3 = right(l1,6)
		endif
		last=last+1
		odate=apur.adjdt
		sele mdis
		appe blank
		repl type with 'D'
		repl vcn with l3
		repl date with apur.adjdt
		repl codep with "STOCex"
		repl voucher with last4
		last4=last4+5
		repl salun with ''
		repl staxun with 'SZTZOZ'
		repl pacun with 'STAC23'
		repl account with 'N'
		repl sale with 'Z'
		repl ltype with '2'
		repl godwon with 'A'
		repl discafter with 'N'
		repl remark4 with l1
	endif

	select fsbal
	seek apur.batchid

	sele mitm
	seek substr(alltrim(apur.prdcode)+space(10),1,10)
	sele msbal
	seek substr(alltrim(apur.prdcode)+space(10),1,10) + substr(fsbal.batch+space(12),1,12)
	sele dis
	appe blank
	repl codep with mdis.codep
	repl vcn with mdis.vcn
	repl date with mdis.date
	repl voucher with mdis.voucher
	repl code with mitm.code
	repl tax with 'T'
	repl free with abs(apur.qty)
    repl batch with fsbal.batch
	
	repl exp with fsbal.exdt
	repl pack with mitm.pack
	repl half with 'A'
	repl flg with iif(apur.qty<0,'L','D')
	repl godwon with mdis.godwon
try	
	REPL mrp with fsbal.mrp
catch
merror=1
endtry	
	sele apur
	skip
enddo
close tables all
******
*!*	if old_4='Y' 
*!*		@rowno,10 say '**** Importing OPENING STOCK ****' font 'Arial',12
*!*		rowno=rowno+1
*!*		sele sele(1)
*!*		use &datdev\probat.&datext alias probat
*!*		repl all opening with 0 ,o_a with 0
*!*		sele sele(1)
*!*		use &datdev\dis.&datext alias dis
*!*		sele dis
*!*		index on str(code)+batch to dis for godwon='A'
*!*		sele probat
*!*		scan
*!*			sele dis
*!*			seek str(probat.code)+probat.batchno
*!*			sum iif(flg$'PMRD',qty+free,0),iif(flg$'GLOBIJ',qty+free,0) to tot1,tot2 while str(code)+batch=str(probat.code)+probat.batchno
*!*			sele probat
*!*			repl opening with TQTY-tot1+tot2
*!*			repl o_a with opening
*!*		endscan
*!*		close table all

*!*	endif
&&SARVESH
?'**Transfer Stock Opening**' font 'Arial',12
sele sele(1)
use datdev+'\probat.'+datext alias prb
inde on batchno+str(code) to prb


sele sele(1)
use datdev + '\dis.'+datext alias dis
inde on str(code)+batch to dis


sele prb
go top
scan &&&&&for product='ML'
	sele dis
	seek str(prb.code)+prb->batchno
	sum iif(flg$'PMRDW',qty+free,0),iif(flg$'GLIBJQ',qty+free,0) to tot1,tot2  for  godwon#'Y' while str(code)+batch=str(prb.code)+prb.batchno
	sele prb
	repl opening with tqty+tot2-tot1
	repl O_A     with tqty+tot2-tot1
*!*	if product='2-FL' &&&&and tqty#0
*!*	   ?   product,batchno,tqty,tot2,tot1,'Opoening ',opening
*!*	*!*	   wait
*!*	endif	
	
endsc
sele dis
clos tables all


@rowno,10 say '**** Importing Account from Sales ****' font 'Arial',12
rowno=rowno+1

af      = datdev + '\gledger.'+datext
pend    = datdev + '\pend.'+datext
mdis    = datdev + '\mdis.'+datext
pending = datdev + '\pendings.'+datext
sele g
use &pending alias pending
sele f
use &pend alias pend

sele b
use &af alias gledger

sele d
use &mdis alias mdis
go top
do while !eof()
	if vcn=space(12)
		skip
		loop
	endif
	if !mdis.type$'SP'
		skip
		loop
	endif
	last1 = mdis.codep
	if mdis.final#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		if d.type = 'P' or d.type = 'R'
			repl cd with 'C'
			repl credit with mdis.final
			repl book with 'A'
		else
			repl cd with 'D'
			repl debit with mdis.final
			repl book with 'S'
		endif
		repl date with mdis.date
		repl code with mdis.codep
		last1=mdis.codep
		repl remark1 with mdis.vcn
		repl type with 'Y'
		if mdis.salun=space(6)
			repl code1 with 'SP#20 '
		else
			repl code1 with mdis.salun
		endif

**** for outstanding
		if old_3='Y'
			sele f
			appe blank
			repl ord with mdis.codep
			repl ddate with mdis.date
			repl duedays with mdis.duedays
			repl vcn with mdis.vcn
			if d.type = 'P' or d.type = 'R'
				repl final with -mdis.final
			else
				repl final with mdis.final
			endif
			repl type with 'N'
			repl voucher with mdis.voucher
			repl adjvoucher with mdis.voucher
			repl svoucher with slast5
			slast5 = slast5 + 5
			sele g
			appe blank
			repl ord with f.ord
			repl ddate with f.ddate
			repl vcn with f.vcn
			repl invtype with 'I'
			repl voucher with f.voucher
			repl duedays with f.duedays
			repl duedate with ddate+duedays
			repl final with f.final
			repl balance with f.final
			repl svoucher with f.svoucher
			repl name with mdis.remark4
		endif
	endif

	if mdis.cash#0
		sele b
		append blank
		repl voucher with mdis.voucher
		if d.type = 'P' or d.type = 'R' or d.type = 'W'
			repl cd with 'C'
			repl credit with mdis.cash
		else
			repl cd with 'D'
			repl debit with mdis.cash
		endif
		repl date with mdis.date
		repl code with 'STACO3'
		last1='STACO3'
		repl remark1 with mdis.vcn
		repl book with 'S'
		repl type with 'Y'
		if mdis.salun=space(6)
			repl code1 with 'SP#20 '
		else
			repl code1 with mdis.salun
		endif
	endif

	if (mdis.final+mdis.cash)#0
		sele b
		append blank
		repl voucher with mdis.voucher
		if d.type='S' or d.type = 'B' or d.type = 'Q'
			repl cd with 'C'
			repl credit with (mdis.final + mdis.cash)
		else
			repl cd with 'D'
			repl debit with (mdis.final+mdis.cash)
		endif
		repl date with mdis.date
		if mdis.salun=space(6)
			repl code with 'SP#20 '
		else
			repl code with mdis.salun
		endif
		repl date with mdis.date
		repl remark1 with mdis.vcn
		repl book with 'S'
		repl type with 'Y'
		repl code1 with last1
	endif
	sele d
	skip
enddo
close tables all

@rowno,10 say '**** Importing Account from Sales Return****' font 'Arial',12
ROWNO=ROWNO+1
*!*	rowno=rowno+1
af      = datdev + '\gledger.'+datext
pend    = datdev + '\pend.'+datext
mdis    = datdev + '\mdis.'+datext
pending = datdev + '\pendings.'+datext

sele sele(1)
use &datatransferpath\adjdetails  alias adj
if vart(accode)='C'
  if vart(vouno)='C'
	index on str(val(vouno))+str(val(accode))+dtoc(trndate)  to adj
  else
	index on str(vouno)+str(val(accode))+dtoc(trndate)  to adj
  endif	
else
	index on str(vouno)+str(accode)+dtoc(trndate)  to adj

endif


sele g
use &pending alias pending
index on ord+vcn  to pending
sele f
use &pend alias pend
sele b
use &af alias gledger
sele d
use &mdis alias mdis
*!*	set filt to vcn='000073'
*!*	brow
go top
do while .not. eof()
	if type$'SPLD'
		skip
		loop
	endif
	if vcn=space(12)
		skip
		loop
	endif
	last1 = mdis.codep
	if mdis.final#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		if d.type $ 'RW'
			repl cd with 'C'
			repl credit with mdis.final
			repl book with 'E'
		else
			repl cd with 'D'
			repl debit with mdis.final
			repl book with 'D'
		endif
		repl date with mdis.date
		repl code with mdis.codep
		last1=mdis.codep
		repl remark1 with mdis.vcn
		repl type with 'Y'
		if mdis.salun=space(6)
			repl code1 with 'SP#20 '
		else
			repl code1 with mdis.salun
		endif
**** For Outstanding
		if old_3 = 'Y'
			sele adj
			if vart(accode)='C'
				maccode=str(val(accode))
			else
				maccode=str(accode)
			endif
			seek str(val(mdis.vcn))+str(val(mdis.codep))+dtoc(mdis.date)
			if found()
				scan while str(vouno)+maccode+dtoc(trndate)=str(val(mdis.vcn))+str(val(mdis.codep))+dtoc(mdis.date)
					mvcn=''
					mvcn=padl(adj.billvouno,6,'0')
					sele f
					appe blank
					repl voucher with mdis.voucher
					repl ord with mdis.codep
					repl ddate with mdis.date
					repl duedays with mdis.duedays
					repl vcn with mvcn
					if (d.type $ 'RW')
						repl final with -abs(adj.amt)  &&&mdis.final
					else
						repl final with abs(adj.amt)
					endif
					repl type with 'A'
					sele g
					seek f.ord+subs(mvcn+space(20),1,20)
					sele f
					repl vcn with g.vcn
					repl adjvoucher with g.voucher
					repl svoucher with g.svoucher
* 				  repl svoucher with slast5

				endscan
			else
				sele f
				appe blank
				repl ord with mdis.codep
				repl ddate with mdis.date
				repl duedays with mdis.duedays
				repl vcn with mdis.vcn
				if d.type $ 'RW'
					repl final with -mdis.final
				else
					repl final with mdis.final
				endif
				repl type with 'N'
				repl voucher with mdis.voucher
				repl adjvoucher with mdis.voucher
				repl svoucher with slast5
				slast5 = slast5 + 5
				sele g
				appe blank
				repl ord with f.ord
				repl ddate with f.ddate
				repl vcn with f.vcn
				repl invtype with 'I'
				repl voucher with f.voucher
				repl duedays with f.duedays
				repl duedate with ddate+duedays
				repl final with f.final
				repl balance with f.final
				repl svoucher with f.svoucher
				repl name with mdis.remark4
			endif
		endif
	endif
	if mdis.cash#0
		sele b
		append blank
		repl voucher with mdis.voucher
		if d.type $ 'P'
			repl cd with 'C'
			repl credit with mdis.cash
		else
			repl cd with 'D'
			repl debit with mdis.cash
		endif
		repl date with mdis.date
		repl code with 'STACO3'
		last1='STACO3'
		repl remark1 with mdis.vcn
		repl book with 'S'
		repl type with 'Y'
		if mdis.salun=space(6)
			repl code1 with 'SP#20 '
		else
			repl code1 with mdis.salun
		endif
	endif
	if (mdis.final+mdis.cash)#0
		sele b
		append blank
		repl voucher with mdis.voucher
		if d.type$'RW'
			repl cd with 'D'
			repl debit with (mdis.final + mdis.cash)
			repl book with 'E'
		else
			repl cd with 'C'
			repl credit with (mdis.final+mdis.cash)
			repl book with 'D'
		endif
		repl date with mdis.date
		if mdis.salun=space(6)
			repl code with 'SP#20 '
		else
			repl code with mdis.salun
		endif
		repl remark1 with mdis.vcn
		repl type with 'Y'
		repl code1 with last1
	endif
	sele d
	skip
enddo
close data


@rowno,10 say '**** Importing Accounting Transactions ****' font 'Arial',12
rowno=rowno+1


@rowno,10 say '**** Importing Payments****' font 'Arial',12
rowno=rowno+1

al      = datdev + '\order.'+datext
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath +'ledger'+datatransferext
ca      = datatransferpath +'ADJDETAILS'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext

select c
use &al alias ledg
index on ordno to ledg

sele g
use &pending alias pending
index on ord + substr(name,1,20) to rou2

last4  = last4 + 10
slast5 = slast5 + 10

sele f
use &pend alias pend
sele b
use &af alias gledger

*!*	SELECT SELECT(1)
*!*	Use &cA Alias ledA
*!*	Set Filter To trndate>=old_5 And trndate<=old_6 AND trntype='Pv'
*!*	if vart(vouno)='C'
*!*	INDEX on trntype+vouno TO leda

*!*	else
*!*	INDEX on trntype+STR(vouno) TO leda
*!*	endif

sele a
use &cf alias led
set filter to trndate>=old_5 and trndate<=old_6 and trntype='Pv'
index on vouno to led
go top
last1=ctod('  /  /    ')
last2='$'
last3='%%%%%%'
ovouno=''
do while !eof()
	if ovouno#a.vouno
		last4=last4+5
		ovouno=a.vouno
	endif

*!*		SELECT c
*!*		SEEK SUBSTR(ALLTRIM(a.accode)+SPACE(6),1,6)

	sele b
	append blank
	repl vcsno with 'P'+alltrim(a.vouno)
	repl voucher with last4
	if a.amt>0
		repl cd with 'D'
		repl debit with abs(a.amt)
	else
		repl cd with 'C'
		repl credit with abs(a.amt)
	endif
	repl date with a.trndate
	repl code with alltrim(a.accode)
	repl remark1 with a.othno+' '+dtoc(a.othdt)
	repl book with 'P'

*!*		If old_3='Y' AND (c.SCODE='C6' OR C.SCODE='D31')
*!*			SELECT leda
*!*			SEEK 'Pv'+STR(VAL(a.vouno))
*!*			DO WHILE !EOF() AND vouno=VAL(a.vouno) AND trytype='Pv'
*!*				Sele pend
*!*				Appen Blank
*!*				Repl voucher With b.voucher
*!*				Repl ddate With b.Date
*!*				Repl Final With Iif(b.book='P',ABS(a.amt),-ABS(a.amt))
*!*				Repl ord With c.ordno
*!*				Repl vcn With IIF(!EMPTY(leda.billvouno),ALLTRIM(STR(leda.billvouno)),a.vouno)
*!*				Repl Type With 'A'

*!*				xinv=IIF(!EMPTY(leda.billvouno),ALLTRIM(STR(leda.billvouno)),ALLTRIM(STR(leda.billvouno)))
*!*				Sele pending
*!*				Seek Subs(c.ordno+Space(6),1,6)+Subs(xinv+Space(20),1,20)
*!*				If Found()
*!*					Sele pend
*!*					Repl vcn With pending.vcn
*!*					Repl adjvoucher With pending.voucher
*!*					Repl svoucher With pending.svoucher
*!*				ENDIF
*!*				SELECT leda
*!*				SKIP
*!*			ENDDO
*!*		ENDIF

	sele a
	skip
enddo
close tables all


al      = datdev + '\order.'+datext
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath +'ledger'+datatransferext
ca      = datatransferpath +'ADJDETAILS'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext

select c
use &al alias ledg
index on ordno to ledg

sele g
use &pending alias pending
index on ord + vcn+dtoc(ddate) to rou2

last4  = last4 + 10
slast5 = slast5 + 10

sele f
use &pend alias pend
sele b

use &af alias gledger

select select(1)
use &datatransferpath\adjdetails alias adj
if vart(accode)='C'
   if vart(vouno)='C'
	index on str(val(vouno))+dtoc(trndate)+str(val(accode)) to adj
   else
	index on str(vouno)+dtoc(trndate)+str(val(accode)) to adj
   endif   	
else
	index on str(vouno)+dtoc(trndate)+str(accode) to adj

endif

@rowno,10 say '**** Importing Receipts****' font 'Arial',12
rowno=rowno+1

&&&&Receipts
*!*	sele leda
*!*	Set Filter To trndate>=old_5 And trndate<=old_6 AND trntype='Rv' &&INLIST(TRNTYPE,'Rv','Jv','Pv')
sele a
use &cf alias led
set filter to trndate>=old_5 and trndate<=old_6 and trntype='Rv' &&&and val(vouno)=752 and accode='5763 ' &&&&&AND VAL(VOUNO)=297 AND ACCODE='31 '&&INLIST(TRNTYPE,'Rv','Jv','Pv') &&&&&and vouno='2081 '
index on vouno   to led  for seq<300 &&&&and val(vouno)=990

copy to myled  

sele sele(1)
use myled alias  myled 
index on vouno to myled

copy to templed

sele sele(1)
use templed
if vart(vouno)='N'
	index on trntype+str(vouno) to templed
else
	index on trntype+str(val(vouno)) to templed
endif

sele led
go top
last1=ctod('  /  /    ')
last2='$'
last3='%%%%%%'
ovouno=''
do while !eof()
	if ovouno#a.vouno
		last4=last4+5
		ovouno=a.vouno
	endif
	first=1
	AdjustmentInDiscount=0
	do while ovouno=vouno and !eof()
	   if amt<0 
		  sele myled 
		  seek led.vouno
		  sum abs(amt) to tot for accode=led.accode and trntype='Rv' while vouno=led.vouno 
		  if abs(tot)#abs(led.amt)
		    AdjustmentIndiscount=1
		  endif
	  endif	     
	  
	  sele led
	  
	select c
	seek substr(alltrim(a.accode)+space(6),1,6)
	sele b
	mord=substr(alltrim(a.accode)+space(6),1,6)
	append blank
	repl vcsno with 'R'+alltrim(a.vouno)
	repl voucher with last4
	if a.amt>0
		repl cd with 'D'
		repl debit with abs(a.amt)
	else
		repl cd with 'C'
		repl credit with abs(a.amt)
	endif
	repl date with a.trndate
	repl code with alltrim(a.accode)
	repl remark1 with a.othno+' '+dtoc(a.othdt)
	repl book with 'R'
****New
	if old_3='Y' &&&&AND (c.SCODE='C6' OR C.SCODE='D31')
		select adj
		if vart(accode)='C'
			maccode=str(val(accode))
			seek str(val(led.vouno))+dtoc(led.trndate)+str(val(led.accode))
			scan while str(vouno)+dtoc(trndate)+str(val(accode))=str(val(led.vouno))+dtoc(led.trndate)+str(val(led.accode))
				mvcn=padl(billvouno,6,'0')
				sele pend
				appen blank
				repl voucher with b.voucher
				repl ddate with b.date
*!*					repl final with iif(b.book='P',abs(adj.amt),-abs(adj.amt))
if AdjustmentinDiscount=0
				repl final with iif(b.book='P',abs(adj.amt),-abs(adj.amt))
else
				repl final with iif(b.book='P',abs(b.debit),-abs(b.credit))
endif				
				repl ord with c.ordno
				repl vcn with mvcn &&IIF(!EMPTY(leda.billvouno),ALLTRIM(STR(leda.billvouno)),a.vouno)
				repl type with 'A'
				sele pending
				seek mord+subs(mvcn+space(20),1,20)+dtoc(adj.billtrndt)
				if found()
					sele pend
					repl vcn with pending.vcn
					repl adjvoucher with pending.voucher
					repl svoucher with pending.svoucher
				endif
				select adj

			endscan
		else
			maccode=str(accode)
			seek str(val(led.vouno))+dtoc(led.trndate)+str(val(led.accode))
			scan while str(vouno)+dtoc(trndate)+str(accode)=str(val(led.vouno))+dtoc(led.trndate)+str(val(led.accode))
				mvcn=padl(billvouno,6,'0')
				sele pend
				appen blank
				repl voucher with b.voucher
				repl ddate with b.date
*!*					repl final with iif(b.book='P',abs(adj.amt),-abs(adj.amt))
if AdjustmentinDiscount=0
				repl final with iif(b.book='P',abs(adj.amt),-abs(adj.amt))
else
				repl final with iif(b.book='P',abs(b.debit),-abs(b.credit))
endif				

				repl ord with c.ordno
				repl vcn with mvcn &&IIF(!EMPTY(leda.billvouno),ALLTRIM(STR(leda.billvouno)),a.vouno)
				repl type with 'A'
				sele pending
				seek mord+subs(mvcn+space(20),1,20)+dtoc(adj.billtrndt)
				if found()
					sele pend
					repl vcn with pending.vcn
					repl adjvoucher with pending.voucher
					repl svoucher with pending.svoucher
				endif
				select adj

			endscan
        endif 
    endif    
    sele led
    skip 
	enddo
enddo	

@rowno,10 say '**** Importing Receipts(Amount Adjusted with Promptational A/C ****' font 'Arial',12
rowno=rowno+1

&&&&Receipts
*!*	sele leda
*!*	Set Filter To trndate>=old_5 And trndate<=old_6 AND trntype='Rv' &&INLIST(TRNTYPE,'Rv','Jv','Pv')
sele a
use &cf alias led
set filter to trndate>=old_5 and trndate<=old_6 and trntype='Rv' &&&and val(vouno)=752 and accode='5763 ' &&&&&AND VAL(VOUNO)=297 AND ACCODE='31 '&&INLIST(TRNTYPE,'Rv','Jv','Pv') &&&&&and vouno='2081 '
index on vouno   to led for seq>300


sele led
go top
last1=ctod('  /  /    ')
last2='$'
last3='%%%%%%'
ovouno=''
do while !eof()
	if ovouno#a.vouno
		last4=last4+5
		ovouno=a.vouno
	endif
	Curcount=0 
	first=1
	AdjustedInDiscount=0
	do while ovouno=vouno and !eof()
	   if amt<0 
		  sele myled 
		  seek led.vouno
		  sum abs(amt) to tot for accode=led.accode and trntype='Rv' while vouno=led.vouno 
		  if abs(tot)#abs(led.amt)
		    AdjustmentIndiscount=1
		  endif
	  endif	     
	
	select c
	seek substr(alltrim(a.accode)+space(6),1,6)
	sele b
	mord=substr(alltrim(a.accode)+space(6),1,6)
	append blank
	repl vcsno with 'R'+alltrim(a.vouno)+'_Adj'
	repl voucher with last4
	if a.amt>0
		repl cd with 'D'
		repl debit with abs(a.amt)
	else
		repl cd with 'C'
		repl credit with abs(a.amt)
	endif
	repl date with a.trndate
	repl code with alltrim(a.accode)
	repl remark1 with a.othno+' '+dtoc(a.othdt)
	repl book with 'R'
****New
	if old_3='Y' &&&&AND (c.SCODE='C6' OR C.SCODE='D31')
		select adj
		if vart(accode)='C'
			maccode=str(val(accode))
			seek str(val(led.vouno))+dtoc(led.trndate)+str(val(led.accode))
			scan while str(vouno)+dtoc(trndate)+str(val(accode))=str(val(led.vouno))+dtoc(led.trndate)+str(val(led.accode))
				mvcn=padl(billvouno,6,'0')
				sele pend
				appen blank
				repl voucher with b.voucher
				repl ddate with b.date
*!*					repl final with iif(b.book='P',abs(adj.amt),-abs(adj.amt))
if AdjustmentinDiscount=0
				repl final with iif(b.book='P',abs(adj.amt),-abs(adj.amt))
else
				repl final with iif(b.book='P',abs(b.debit),-abs(b.credit))
endif				

				repl ord with c.ordno
				repl vcn with mvcn &&IIF(!EMPTY(leda.billvouno),ALLTRIM(STR(leda.billvouno)),a.vouno)
				repl type with 'A'
				sele pending
				seek mord+subs(mvcn+space(20),1,20)+dtoc(adj.billtrndt)
				if found()
					sele pend
					repl vcn with pending.vcn
					repl adjvoucher with pending.voucher
					repl svoucher with pending.svoucher
				endif
				select adj

			endscan
		else
			maccode=str(accode)
			seek str(val(led.vouno))+dtoc(led.trndate)+str(val(led.accode))
			scan while str(vouno)+dtoc(trndate)+str(accode)=str(val(led.vouno))+dtoc(led.trndate)+str(val(led.accode))
				mvcn=padl(billvouno,6,'0')
				sele pend
				appen blank
				repl voucher with b.voucher
				repl ddate with b.date
*!*					repl final with iif(b.book='P',abs(adj.amt),-abs(adj.amt))
if AdjustmentinDiscount=0
				repl final with iif(b.book='P',abs(adj.amt),-abs(adj.amt))
else
				repl final with iif(b.book='P',abs(b.debit),-abs(b.credit))
endif				

				repl ord with c.ordno
				repl vcn with mvcn &&IIF(!EMPTY(leda.billvouno),ALLTRIM(STR(leda.billvouno)),a.vouno)
				repl type with 'A'
				sele pending
				seek mord+subs(mvcn+space(20),1,20)+dtoc(adj.billtrndt)
				if found()
					sele pend
					repl vcn with pending.vcn
					repl adjvoucher with pending.voucher
					repl svoucher with pending.svoucher
				endif
				select adj

			endscan
        endif 
    endif    
    sele led
    skip 
	enddo
enddo	



	@rowno,10 say '**** Importing Journal****' font 'Arial',12
	rowno=rowno+1

&&&&Journal
*!*	sele leda
*!*	Set Filter To trndate>=old_5 And trndate<=old_6 AND trntype='Jv' &&INLIST(TRNTYPE,'Rv','Jv','Pv')
	sele a
	use &cf alias led
	set filter to trndate>=old_5 and trndate<=old_6 and trntype='Jv' &&INLIST(TRNTYPE,'Rv','Jv','Pv') &&&&&and vouno='2081 '
	index on vouno to led
	go top
	last1=ctod('  /  /    ')
	last2='$'
	last3='%%%%%%'
	ovouno=''
	do while !eof()
		if ovouno#a.vouno
			last4=last4+5
			ovouno=a.vouno
		endif
		select c
		seek substr(alltrim(a.accode)+space(6),1,6)
		sele b
		append blank
		repl vcsno with 'J'+alltrim(a.vouno)
		repl voucher with last4
		if a.amt>0
			repl cd with 'D'
			repl debit with abs(a.amt)
		else
			repl cd with 'C'
			repl credit with abs(a.amt)
		endif
		repl date with a.trndate
		repl code with alltrim(a.accode)
		repl remark1 with a.othno+' '+dtoc(a.othdt)
		repl book with 'J'
*!*		If old_3='Y' AND (c.SCODE='C6' OR C.SCODE='D31')
*!*			SELECT leda
*!*			SEEK 'Jv'+STR(VAL(LED.vouno))+STR(VAL(LED.ACCODE))
*!*			SCAN while ALLTRIM(trntype)+STR(vouno)+str(accode)='Rv'+STR(VAL(LED.vouno))+STR(VAL(LED.ACCODE))
*!*				Sele pend
*!*				Appen Blank
*!*				Repl voucher With b.voucher
*!*				Repl ddate With b.Date
*!*				Repl Final With Iif(b.book='P',ABS(LEDA.amt),-ABS(LEDA.amt))
*!*				Repl ord With c.ordno
*!*				Repl vcn With IIF(!EMPTY(leda.billvouno),ALLTRIM(STR(leda.billvouno)),a.vouno)
*!*				Repl Type With 'A'
*!*				xinv=IIF(!EMPTY(leda.billvouno),ALLTRIM(STR(leda.billvouno)),ALLTRIM(STR(leda.billvouno)))
*!*				Sele pending
*!*				Seek Subs(c.ordno+Space(6),1,6)+Subs(xinv+Space(20),1,20)
*!*				If Found()
*!*					Sele pend
*!*					Repl vcn With pending.vcn
*!*					Repl adjvoucher With pending.voucher
*!*					Repl svoucher With pending.svoucher
*!*				ENDIF
*!*
*!*				SELECT leda
*!*			endscan
*!*		ENDIF
*!*
		sele a
		skip
	enddo
	close tables all

	close tables all


*!*	?'** Transfer Journal'
*!*	al      = datdev + '\order.'+datext
*!*	af      = datdev + '\gledger.'+datext
*!*	bf      = datdev + '\slipno.'+datext
*!*	cf      = datatransferpath +'journal'+datatransferext
*!*	ci      = datatransferpath +'jitems'+datatransferext
*!*	pend    = datdev + '\pend.'+datext
*!*	pending = datdev + '\pendings.'+datext

*!*	Select c
*!*	Use &al Alias ledg
*!*	Index On ordno To ledg

*!*	Sele g
*!*	Use &pending Alias pending
*!*	Index On ord + Substr(Name,1,20) To rou2

*!*	last4  = last4 + 10
*!*	slast5 = slast5 + 10

*!*	Sele F
*!*	Use &pend Alias pend
*!*	Sele b
*!*	Use &af Alias gledger
*!*	Sele a
*!*	Use &cf Alias led

*!*	Select Select(1)
*!*	Use &ci Alias ldd
*!*	Index On v_id To ldd

*!*	Sele a
*!*	Go Top
*!*	last1=Ctod('  /  /    ')
*!*	last2='$'
*!*	last3='%%%%%%'
*!*	Do While !Eof()
*!*		last4 = last4+4

*!*		Select ldd
*!*		Seek a.v_id
*!*		Do While !Eof() And v_id=a.v_id
*!*			iparty=ldd.head_id
*!*			If !Empty(ldd.VEND_Id)
*!*				iparty='V'+Alltrim(Str(ldd.VEND_Id))
*!*			Else
*!*				If !Empty(ldd.CUST_Id)
*!*					iparty='C'+Alltrim(Str(ldd.CUST_Id))
*!*				Else
*!*					iparty=ldd.head_id
*!*				Endif
*!*			Endif
*!*			Sele b
*!*			Append Blank
*!*			Repl vcsno With 'J'+Alltrim(Str(a.v_id))
*!*			Repl VOUCHER With last4
*!*			If ldd.credit#0
*!*				Repl Cd With 'C'
*!*				Repl credit With ldd.credit
*!*			Else
*!*				Repl Cd With 'D'
*!*				Repl debit With ldd.debit
*!*			Endif
*!*			Repl Date With a.Date
*!*			Repl Code With iparty
*!*			Repl remark1 With a.narration
*!*			Repl book With 'J'

*!*			Select ldd
*!*			Skip
*!*		Enddo

*!*		Sele a
*!*		Skip
*!*	Enddo
*!*	Close TABLES ALL

	bf=datdev + '\slipno.'+datext
	use &bf
	go top
	repl voucher with last4+20
	repl svoucher with slast5+20
	bf=datdev+ '\mdis.'+datext
	use &bf
	repl misc4 with ' '
	bf=datdev+ '\pendings.'+datext
	use &bf
	repl all vcn with '*'+vcn for invtype='O' .and. ddate<=old_5
	close tables all

** Transfer CALCULATION FIELD OF MARG TRANSACTION FILE
	try
		dis=datdev + '\dis.'+datext
		use &dis
		go top
		do while !eof()
			repl sfrate with rate+val(substr(dis.misc4,1,6))
			repl ssscamo with round((sfrate*qty)*sssc/100,2)
			repl sstaamo with round((sfrate*qty+ssscamo)*ssta/100,2)
			repl sfrate with sfrate+round(sfrate*sssc/100,2)
			repl sfrate with sfrate+round(sfrate*ssta/100,2)
			repl shalfamo with rate*halffree
			tot=rate*qty-vdisamo-shalfamo
			totd=round(tot*disc1/100,2)
			repl sdiscount with totd
			tot=tot-totd
			totd=round(tot*disc2/100,2)
			repl sdiscount with sdiscount+totd
			tot=(rate-ssex)*qty-sdiscount-shalfamo-vdisamo
			totd=round(tot*addis/100,2)
			repl ammmount with sfrate*qty-sdiscount-shalfamo-vdisamo
			repl ssscamo with ssscamo+(sfrate*qty-rate*qty)-(ssscamo+sstaamo)
			skip
		enddo
	catch
		merror=1
	endtry
	close tables all
	close data



proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","M","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T","M")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

Proc  memo2char
tbl=Alia()
a = Afields(arr)
For i = 1 To a
	mfldname = arr(i, 1)
	Do Case
	Case Inlist(arr(i,2),"M")
		Alter Table &tbl Alter Column &mfldname c(254)
		Repl All &mfldname With Chrtran(&mfldname,Chr(0),'')
	Case Inlist(arr(i,2),"C")
		Repl All &mfldname With Chrtran(&mfldname,Chr(0),'')
	Endcase
Endf
Clos Table All

*!*	BOF : Reliable.PRG (PHARMA )..... Dated    : 05/05/2022
