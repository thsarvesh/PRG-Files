*!*	BOF : JHA.PRG .....Varanasi(Pharma Wholesale)  Dated    : 15/03/2019   Author : Santosh K Srivastava
*!* datatransferpath="e:\datafrom\"+space(45)
*!* datatransferext="dbf"
*!* for bill difference ## in support -> repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!* for item difference ## in support -> repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for item batch difference ## in support -> repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for ledger difference ## in support -> repl type with "#",aliase with "DAT/F-LD",Lcode with mact.ordno,value with TOT
*!* ******************
*!* Your Commands
*!* ******************
*!* if LastKey()=27
*!*  Return
*!* endif
*!* =starttransfer()
*!* ******************
*!*	*!* your commands
clear
set cpdialog off
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
*!*	sele sele(1)
*!*	create curs mycurs  (setup c(50),value c(4))
*!*	sele mycurs
*!*	appe blank
*!*	repl  setup with 'Item Wise Double Discount ',value with 'Y'
*!*	appen blank
*!*	repl  setup with 'Volume discount 1st ',value with 'L'
*!*	brow font 'COURIER',18    nomodify

if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev=substr('d:\transfer\'+space(100),1,100)   && Un-Comment this for run from VFP
	datext='dbf'
endif
datatransferext='DBF'
datatransferpath =substr('D:\MIGRATION_DATA\MAR\GT_PHARMA_PINTU\DBF_FILES\'+space(100),1,100)
*!*	datatransferpath1=substr(''+space(100),1,100)
*!*	datatransferpath2=substr(''+space(100),1,100)
*!*	datatransferpath3=substr(''+space(100),1,100)
datatransferext='DBF'
old_2 = '04'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
vatgst = 'GST'
softtype='Wholesale'
scalc='2'
pcalc='2'
mstatecode='09'
sure='SURE'
removenull='No '
clear
close data
datatransfermdb='No '
mtrade='Pharma'
datatransfermdb='No '
@ 05,10 say 'Convert dbf from MDB :' font 'Courier',18  get datatransfermdb pict '@M No ,Yes'  font 'courier',18
@ 06,10 say 'Jha  Data Path       :' font 'Courier',18  get datatransferpath  font 'courier',18 
read
clear gets
IF  datatransfermdb='Y' 
 =mdbsqlconvert(1)
Endif
iscomposition='No ' 
@ 07,10 say 'Jha  Extension       :' font 'Courier',18  get datatransferext  font 'courier',18
@ 08,10 say 'With Outstanding Y/N :' font 'Courier',18  get old_3 pict '@m YES,NO '  font 'Courier',18
@ 09,10 say 'No-Full Yes-Master   :' font 'Courier',18  get old_4 pict '@m No,Yes'  font 'Courier',18
@ 10,10 say 'F.Y.BEGIN Date       :' font 'Courier',18  get old_5  font 'Courier',18
@ 11,10 say 'F.Y.End   Date       :' font 'Courier',18  get old_6   font 'Courier',18
@ 12,10 say 'G-GST  V-Vat         :' font 'Courier',18  get vatgst pict '@M GST,VAT'  font 'Courier',18
@ 13,10 say 'State Code           :' font 'Courier',18  get mstatecode   font 'Courier',18
@ 14,10 say 'Sales Calculation    :' font 'Courier',18  get scalc   font 'Courier',18
@ 15,10 say 'Purch Calculation    :' font 'Courier',18  get pcalc   font 'Courier',18
@ 16,10 say 'Wholesale/Retail     :' font 'Courier',18  get softtype pict '@m Wholesale,Retail   '   font 'Courier',18
@ 17,10 say 'Removenull           :' font 'Courier',18  get removenull pict '@m No ,Yes'   font 'Courier',18
@ 18,10 say 'Trade                :' font 'Courier',18  get mtrade pict '@M Pharma,FMCG ' font 'Courier',18
@ 19,10 say 'Composition Dealer   :' font 'Courier',18  get isComposition pict '@M No ,Yes' font 'Courier',18
@ 20,10 say 'Type SURE            :' font 'courier',18  get sure pict '@x!' font 'courier',18
read
clear
close data
datatransferpath=alltrim(datatransferpath)
if removenull='Y'
	clear
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif
*!*	datatransferpath3=alltrim(datatransferpath3)
*!*	datatransferpath2=alltrim(datatransferpath2)
*!*	datatransferpath1=alltrim(datatransferpath1)
if !right(datatransferpath,1)='\'
	datatransferpath=alltrim(datatransferpath)+'\'
endif
datatransferext=alltrim(datatransferext)
datdev= alltrim(datdev)
datext= alltrim(datext)
datatransferext='.'+datatransferext
old_2=subs(right(datatransferpath,3),1,2)
if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
if type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
endif
rowno=1
@00,22 say 'Please Wait Importing Jha,Varanasi Data To Marg.....' font 'Arial',14 colo 'W+/G'
set colo to
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
use &datdev\glmonth.&datext
zap
use &datdev\ggmonth.&datext
zap
use &datdev\chiller.&datext
zap
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F'
dele all for aliase='ORDER'
pack
close data
set colo to

@rowno,10 say '**** Importing Area ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\area alias farea
sele sele(1)
use &datdev\saletype.&datext alias stype

sele farea
scan
	sele stype
	appen blank
	repl sgcode with 'AREA'
	repl scode with alltrim(str(farea.code))
	repl parnam with farea.name
	repl sname with farea.name
endscan
close data

@rowno,10 say '**** Importing Product ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock alias fitm
sele sele(1)
use &datdev\pro.&datext alias mitm
sele sele(1)
use &datdev\saletype.&datext alias stype
index on sgcode+parnam+str(igst,6,2) to stype
sele fitm
scan
	sele mitm
	appen blank
	repl code with fitm.code
	repl name with alltrim(str(fitm.code))
	repl product with fitm.product
	repl packing with fitm.pack
	repl billname with subs(fitm.product,1,30)+fitm.pack
	repl pack with fitm.pack_qty
	repl opening with fitm.opening
	repl balance with fitm.quantity
	repl o_a with fitm.opening
	repl b_a with fitm.quantity
	repl prate with fitm.purchase
	repl ratea with fitm.sale_rate
	repl mrp with fitm.m_r_p
	repl lprate with fitm.purchase/iif(mitm.pack>0 AND SOFTTYPE='R',mitm.pack,1)
	repl deal with fitm.deal
	repl free with fitm.dealt
	repl saldis with fitm.saledisc
	repl rackno with fitm.rack
	if vatgst='G'
		repl saltax with fitm.plocaltax
		repl cgst with fitm.plocaltax
		repl igst with fitm.plocaltax*2
	else
		repl saltax with fitm.plocaltax
	endif
	sele stype
	seek 'ZZZZZZ'+subs(fitm.mfgby+space(15),1,15)
	if !found()
		appen blank
		repl sgcode with 'ZZZZZZ'
		repl scode with alltrim(str(recno()))
		repl parnam with fitm.mfgby
		repl sname with fitm.mfgby
	endif
	sele mitm
	repl gcode with stype.scode
	sele stype
	seek 'COMMCD'+subs(fitm.hsncode+spac(15),1,5)+str(fitm.plocaltax*2,6,2)
	if !found()
		appen blank
		repl sgcode with 'COMMCD'
		repl scode with alltrim(str(recno()))
		repl parnam with fitm.hsncode
		repl sname with  fitm.hsncode
		repl igst with fitm.plocaltax*2
		repl tax with fitm.plocaltax
		repl cgst with fitm.plocaltax
	endif
	sele mitm
	repl gcode6 with stype.scode
endscan
close data


@rowno,10 say '**** Importing Stock ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\stockdt alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code)+batchno to msbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on code to mitm
sele sele(1)
use &datdev\support.&datext alias support
sele fsbal
scan
	=seek(code,'mitm')
	sele msbal
	seek str(fsbal.code)+subs(fsbal.batch+space(12),1,12)
	if !found()
		appen blank
		repl code with mitm.code
		repl name with mitm.name
		repl product with mitm.product
		repl billname with mitm.billname
		repl packing with mitm.packing
		repl pack with mitm.pack
		repl batchno with fsbal.batch
		if softtype='Wholesale'
		repl opening with iif(old_4='Y',fsbal.quantity,fsbal.opening)
		repl o_a with iif(old_4='Y',fsbal.quantity,fsbal.opening)
		else
		repl opening with iif(old_4='Y',fsbal.quantity,fsbal.opening*iif(pack#0,pack,1))
		repl o_a with iif(old_4='Y',fsbal.quantity,fsbal.opening*iif(pack#0,pack,1))
        endi
		repl balance with  fsbal.quantity
		repl b_a with fsbal.quantity
		repl ratea with fsbal.sale_rate
		repl prate with fsbal.purchase   &&&/IIF(mitm.pack>0,mitm.pack,1)
		repl mrp  with fsbal.m_r_p
		repl deal with fsbal.sche
		repl free with fsbal.schet
		repl exp with fsbal.exp_date
		repl lprate with fsbal.purchase/iif(mitm.pack>0 and softtype='R',mitm.pack,1)
	else
		repl ratea with fsbal.sale_rate
		repl prate with fsbal.purchase
		repl mrp  with fsbal.m_r_p
		if softtype='Wholesale'
		repl opening with opening+iif(old_4='Y',fsbal.quantity,fsbal.opening)
		repl o_a with o_a+iif(old_4='Y',fsbal.quantity,fsbal.opening)
		else
		repl opening with opening+iif(old_4='Y',fsbal.quantity,fsbal.opening*iif(pack#0,pack,1))
		repl o_a with o_a+iif(old_4='Y',fsbal.quantity,fsbal.opening*iif(pack#0,pack,1))
        endi 
		repl balance with  balance+fsbal.quantity
		repl b_a with b_a+fsbal.quantity
	endif
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with msbal.batchno,value with msbal.balance
endscan
sele mitm
scan
	sele msbal
	seek str(mitm.code)
	sum balance to tot while code=mitm.code
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,heading with msbal.batchno,value with tot
endscan
close data

@rowno,10 say '**** Importing Account Ledger  ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\customer alias fact
sele sele(1)
use &datatransferpath\cdgroup alias acg
index on gcode to acg
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	=seek(group,'acg')
	msname=acg.ggroup
	sele mact
	appen blank
	REPL RATE WITH OLD_3
	repl ordno with alltrim(str(fact.code))
	repl mailnam with fact.name
	repl parnam with fact.name
	repl paradd with fact.address1
	repl paradd1 with fact.address2
	repl paradd2 with fact.address3
	repl city with fact.city_pin
	repl fax1 with fact.fax
	repl phone1 with fact.mobile
	repl dlno with alltrim(fact.dlno1)+iif(len(alltrim(fact.dlno1))>0,'/',' ')+alltrim(fact.dlno2)
	repl gsthed with 'GST No:'
	repl gstno with fact.tin
	repl area with alltrim(str(fact.area))
	repl disc1 with fact.disc
	if old_4='Y'
		repl opning with iif(fact.cdc='D',fact.closing,-fact.closing)
		repl balance  with iif(fact.cdc='D',fact.closing,-fact.closing)
	else
		repl opning with iif(fact.odc='D',fact.opening,-fact.opening)
		repl balance  with iif(fact.odc='D',fact.closing,-fact.closing)
	endif
	repl docu with fact.through
	repl trans with fact.transport
	repl docu1 with fact.bank
	wacctgroup=''
	wgroupcode=''
	parentgrup=''
	wcurrentaccount=alltrim(upper(msname))
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
	case 'SUPPLIER'$wcurrentaccount
		wgroupcode='D31 '
	case 'SUNDRY DEBTOR'$wcurrentaccount &&&or fdet.mastertype=7
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
	sele support
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 12
	repl remark with substr(fact.email,1,40)+substr(remark,41,100),;
		heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
&&State
	appe blank
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(substr(mact.gstno,1,2)=mstatecode,mstatecode,'00')+substr(remark,42)
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with mact.balance
endscan
close data
IF SOFTTYPE='R'
	@rowno,10 say '**** Importing Doctor  ****' font 'Arial',12
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\customer alias fact
	set filt to type='D'
	sele sele(1)
	use &datdev\maorder.&datext alias mact
	sele fact
	scan
		sele mact
		appen blank
		repl scode with 'PRE#$~'
		repl ordno with alltrim(str(fact.code))
		repl parnam with fact.name
		repl form with alltrim(str(fact.code))
	endscan
	close data
ENDIF

if old_3='Y'
	@rowno,10 say '**** Importing Debtors Outstanding  ****' font 'Arial',12
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\custout alias fout
	sele sele(1)
	use &datdev\pendings.&datext alias pend
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	mvoucher=voucher+5
	msvoucher=svoucher+4
	sele fout
	scan
		if old_4='N' and vdate=>old_5
			loop
		endif
		mvoucher=mvoucher+5
		msvoucher=msvoucher+4
		sele pend
		appen blank
		repl  voucher  with mvoucher
		repl  ord with alltrim(str(fout.code))
		repl  vcn with fout.invoice
		repl  ddate with fout.date
		repl  final with fout.amount
		repl  balance with fout.due
		repl svoucher with  msvoucher
		repl invtype with 'O'
		repl acgroup with 'C6'
	endscan
	sele sele(1)
	sele fout
	use

	@rowno,10 say '**** Importing Creditors Outstanding  ****' font 'Arial',12
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\suplout alias fout
	sele fout
	scan
		if old_4='N' and vdate=>old_5
			loop
		endif
		mvoucher=mvoucher+5
		msvoucher=msvoucher+4
		sele pend
		appen blank
		repl  voucher  with mvoucher
		repl  ord with alltrim(str(fout.code))
		repl  vcn with fout.invoice
		repl  ddate with fout.date
		repl  final with fout.amount
		repl  balance with fout.due
		repl svoucher with  msvoucher
		repl invtype with 'O'
		repl acgroup with 'D31'
	endscan
	close data

endif
if old_4='N'
	do import_transactions
endif


proc import_transactions
@rowno,10 say '**** Importing Inventory Transactions  ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
mvoucher=voucher+5
msvoucher=svoucher+4
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datdev\pro.&datext alias pro
index on code to pro
sele sele(1)
use &datdev\probat.&datext alias probat
index on str(code)+batchno to probat
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord

sele select(1)
use &datdev\support.&datext alias support 
index on type+aliase to  support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)



@rowno,10 say '**** Importing Purchase ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\purcode alias pur
sele sele(1)
use &datatransferpath\purdt alias pld
index on voucher to pld

sele pur
scan for between(vdate,old_5,old_6)
	=seek(subs(alltrim(str(code))+space(06),1,6),'ord')
	mvoucher=mvoucher+5
	sele mdis
	appen blank
	repl  voucher with mvoucher
	repl type with 'P'
	repl vcn with repli('0',7-len(alltrim(str(pur.voucher))))+alltrim(str(pur.voucher))
	repl date with pur.vdate
	repl pm with pur.invoice
	repl lrda with pur.date
	repl codep with alltrim(str(pur.code))
	if pur.type='Cd' OR pur.type='Ca'
		repl vcn with repli('0',7-len(alltrim(str(pur.voucher))))+alltrim(str(pur.voucher))
		repl date with pur.vdate
    else
       IF PUR.TYPE='Ch'
        REPL type with 'D'
		repl challan with repli('0',7-len(alltrim(str(pur.voucher))))+alltrim(str(pur.voucher))
		repl chdate with pur.vdate
	   endif	
	endif
	  if pur.type='Cd'
		repl  final with pur.amount
		repl  cash with 0
	  else
	   if pur.type='Ca'
		repl  final with 0
		repl  cash with pur.amount
	   endif
	  endif 	

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl freight with pur.fraight
	repl round with pur.miscadj
	repl account with 'N'
	repl sale with 'z' &&IIF(SOFTTYPE='W','z','Z')
	repl godwon with 'A'
	repl discafter with 'N'
	repl  ltype with pcalc
	repl discafter with 'N'
	isigst=0
	if pur.remark='E'
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif

   && UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SN",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	sele pld
	seek pur.voucher
	scan while voucher=pur.voucher
		=seek(code,'pro')
		sele dis
		appen blank
		repl voucher with mdis.voucher
		repl code with pld.code
		repl flg with mdis.type
		repl vcn with iif(pur.type='Ch',mdis.challan,mdis.vcn)
		repl date with iif(pur.type='Ch',mdis.chdate,mdis.date)
		repl codep with mdis.codep
		repl batch with pld.batch
		repl exp with pld.exp
        if softtype='Wholesale'
        repl qty with pld.quant
		repl free with pld.free
		else
		repl pack WITH pro.pack
		repl qty with pld.quant*iif(pack#0,pack,1)
		repl free with pld.free*iif(pack#0,pack,1)
		endi
		repl deal with pld.deal
		repl freeDEAL with pld.dealt
IF pld.quant#0		
		repl rate with pld.trade/pld.quant
endif		
		repl mrp with pld.mrp
		repl disc1 with pld.disc
        repl tax with 'T'
		if vatgst='G'
			if isigst=1
				repl ssta with IIF(PLD.PCTAX#0,pld.pctax,pld.ctax)*2
			else
				repl ssta with iif(pld.pctax#0,pld.pctax,pld.Ctax)
				repl cgst with iif(pld.pctax#0,pld.pctax,pld.Ctax)
			endif
		else
			repl ssta with pld.ltax
		endif
       if seek(str(dis.code)+dis.batch,'probat')
             repl  probat.supcode WITH dis.codep
      		 repl  probat.supdat WITH dis.date    
             repl  probat.supinvo WITH dis.vcn    
             repl  probat.deal with pld.deal
             repl  probat.free  with pld.dealt
             repl  probat.PURdeal with pld.deal
             repl  probat.PURfree with pld.dealt
             
       endif
	endscan
endscan
sele mslip
repl voucher with mvoucher,svoucher with msvoucher
sele sele(1)
sele pur
use
sele pld
use

@rowno,10 say '**** Importing Sales  ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\salcode alias sal
sele sele(1)
use &datatransferpath\saldt alias sld
index on voucher to sld

sele sal
scan for between(vdate,old_5,old_6)
	=seek(subs(alltrim(str(code))+space(06),1,6),'ord')
	mvoucher=mvoucher+5
	sele mdis
	appen blank
	repl  voucher with mvoucher
IF 	softtype='W'
	if sal.type='Cd'
		repl type with 'S'
		repl vcn with alltrim(sal.invoice)
		repl date with sal.vdate
	ELSE
	  repl type with 'L'
	  repl challan with alltrim(sal.invoice)
	  repl chdate with sal.vdate
	endif
else
	if sal.type='C'
		repl type with 'S'
		repl vcn with alltrim(sal.invoice)
		repl date with sal.vdate
	ELSE
	  repl type with 'R'
		repl vcn with alltrim(sal.invoice)
		repl date with sal.vdate
	endif

endif	
	repl codep with alltrim(str(sal.code))
	if sal.type='Cd'
		repl  final with sal.amount
		repl cash with 0
	else
		repl cash with sal.amount
		repl final with 0
	endif

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl freight with -sal.fraight
	repl round with sal.miscadj
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
	repl  ltype with scalc
	repl discafter with 'N'
	isigst=0
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif
   && UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SN",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	sele sld
	seek sal.voucher
	scan while voucher=sal.voucher
		=seek(code,'pro')
		sele dis
		appen blank
		repl voucher with mdis.voucher
		repl code with sld.code
if sOFTtype='W'		
		repl flg with iif(sal.type='Cd','G','L')
		repl vcn with iif(sal.type='Cd',mdis.vcn,mdis.challan)
		repl date with iif(sal.type='Cd',mdis.date,mdis.CHDATE)
else
		repl flg with iif(sal.type='C','G','R')
		repl vcn with  mdis.vcn
		repl date with mdis.date
endif		
		repl codep with mdis.codep
		repl batch with sld.batch
		repl exp with sld.exp
IF Softtype='R'
		repl qty with round(sld.quant*sld.pack_qty,0)
        repl pack with sld.pack_qty 
else		
		repl qty with sld.quant
endif		
		repl free with sld.free
		repl deal with sld.deal
		repl free with sld.dealt
		repl rate with sld.rate
		repl mrp with sld.mrp
		repl disc1 with sld.disc
        repl tax with 'T'
IF sld.deal#0 and sld.dealt#0 
        repl rsm with allt(str(sld.deal))+'+'+allt(str(sld.dealt))
endif        
		if vatgst='G'
		  if iscomposition='N'
			if isigst=1
				repl ssta with sld.ctax
			else
				repl ssta with sld.ltax
				repl cgst with sld.ltax
			endif
		  endif	
		else
			repl ssta with sld.ltax
		endif
	endscan
endscan
sele mslip
repl voucher with mvoucher,svoucher with msvoucher
sele sele(1)
sele sal
use
sele sld
use
@rowno,10 say '**** Importing Sales Return ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\salretcode alias sal
sele sele(1)
use &datatransferpath\salretdt alias sld
index on voucher to sld
sele sal
scan for between(vdate,old_5,old_6)
	=seek(subs(alltrim(str(code))+space(06),1,6),'ord')
	mvoucher=mvoucher+5
	sele mdis
	appen blank
	repl  voucher with mvoucher
	repl type with 'R'
	repl vcn with alltrim(sal.invoice)
	repl date with sal.vdate
	repl codep with alltrim(str(sal.code))
	if sal.type='Cd'
		repl  final with sal.amount
		repl  cash with 0
	else
		repl  cash with sal.amount
		repl  final with 0
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl freight with -sal.fraight
	repl round with sal.miscadj
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
	repl  ltype with scalc
	repl discafter with 'N'
	isigst=0
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif
   && UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SN",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	sele sld
	seek sal.voucher
	scan while voucher=sal.voucher
		=seek(code,'pro')
		sele dis
		appen blank
		repl voucher with mdis.voucher
		repl code with sld.code
		repl flg with mdis.type
		repl vcn with mdis.vcn
		repl date with mdis.date
		repl codep with mdis.codep
		repl batch with sld.batch
		repl exp with sld.exp
		repl qty with sld.quant
		repl free with sld.free
		repl deal with sld.deal
		repl free with sld.dealt
		repl rate with sld.rate
		repl mrp with sld.mrp
		repl disc1 with sld.disc
        repl tax with 'T'
		IF sld.deal#0 and sld.dealt#0 
	        repl rsm with allt(str(sld.deal))+'+'+allt(str(sld.dealt))
		endif        

		if vatgst='G'
			if isigst=1
				repl ssta with sld.pctax*2
			else
				repl ssta with sld.pltax
				repl cgst with sld.pltax
			endif
		else
			repl ssta with sld.pltax
		endif
	endscan
endscan
sele mslip
repl voucher with mvoucher,svoucher with msvoucher

@rowno,10 say '**** Importing Purchase Return ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\purretcode alias pur
sele sele(1)
use &datatransferpath\purretdt alias pld
index on voucher to pld
sele pur
scan for between(vdate,old_5,old_6)
	=seek(subs(alltrim(str(code))+space(06),1,6),'ord')
	mvoucher=mvoucher+5
	sele mdis
	appen blank
	repl  voucher with mvoucher
	repl type with 'B'
	repl vcn with  alltrim(pur.invoice)
	repl date with pur.vdate
	repl codep with alltrim(str(pur.code))
	if sal.type='Cd'
		repl  final with pur.amount
		repl  cash with 0
	else
		repl  cash with sal.amount
		repl  final with 0
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl freight with -pur.fraight
	repl round with pur.miscadj
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
	repl  ltype with pcalc
	repl discafter with 'N'
	isigst=0
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif
   && UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	Sele Support
	Appen Blank
	Repl Type With "#",aliase With "DAT/F-SN",pcode With mdis->voucher,Value With mdis->Final+mdis->cash

	sele pld
	seek pur.voucher
	scan while voucher=pur.voucher
		=seek(code,'pro')
		sele dis
		appen blank
		repl voucher with mdis.voucher
		repl code with pld.code
		repl flg with mdis.type
		repl vcn with mdis.vcn
		repl date with mdis.date
		repl codep with mdis.codep
		repl batch with pld.batch
		repl exp with pld.exp
		repl qty with pld.quant
		repl free with pld.free
		repl deal with pld.deal
		repl free with pld.dealt
		repl rate with pld.rate
		repl mrp with pld.mrp
		repl disc1 with pld.disc
		        repl tax with 'T'

		if vatgst='G'
			if isigst=1
				repl ssta with pld.ctax*2
			else
				repl ssta with pld.ltax
				repl cgst with pld.ltax
			endif
		else
			repl ssta with pld.ltax
		endif
	endscan
endscan
sele mslip
repl voucher with mvoucher,svoucher with msvoucher
slast5=msvoucher+5
close data
@rowno,10 say '**** Importing Account ( From Sales ) ****' font 'Arial',12
rowno=rowno+1
af     =datdev + '\gledger.'+datext
pend   =datdev + '\pend.'+datext
mdis   =datdev + '\mdis.'+datext
pending=datdev + '\pendings.'+datext
sele g
use &pending alias pending
sele f
use &pend alias pend excl
zap
sele b
use &af alias gledger excl
zap
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord
sele d
use &mdis alias mdis
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
msvoucher=svoucher+5
slast5=msvoucher
sele d
go top
do while .not. eof()
	=seek(mdis.codep,'ord')
	sele d
	if vcn=space(12)
		skip
		loop
	endif
	last1=mdis.codep
	if mdis.final#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		if d.type='P'
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
		repl gcode with ord.scode
**** for outstanding
		if old_3='Y'
			sele f
			appe blank
			repl ord with mdis.codep
			repl ddate with mdis.date
			repl duedays with mdis.duedays
			repl vcn with mdis.vcn
			if d.type='P'
				repl final with -mdis.final
			else
				repl final with mdis.final
			endif
			repl type with 'N'
			repl voucher with mdis.voucher
			repl adjvoucher with mdis.voucher
			repl svoucher with slast5
			slast5=slast5+5
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
			repl acgroup with ord.scode
		endif
	endif
	if mdis.cash#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		if d.type='P'
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
		appe blank
		repl voucher with mdis.voucher
		if d.type#'P'
			repl cd with 'C'
			repl credit with (mdis.final+mdis.cash)
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
		repl remark1 with mdis.vcn
		repl book with 'S'
		repl type with 'Y'
		repl code1 with last1
	endif
	sele gledger
	sele d
	skip
enddo
sele gledger
sele mslip
repl svoucher with msvoucher
close data

@rowno,10 say '**** Importing Receipts/Payments ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
mvoucher=voucher+5
msvoucher=svoucher+5
sele sele(1)
use &datdev\gledger.&datext alias gle
sele sele(1)
use &datdev\pendings.&datext alias pendings
index on ord+vcn to pendings
sele sele(1)
use &datdev\pend.&datext alias pend
sele sele(1)
use &datatransferpath\acvoucher alias led
index on voucher to led for inlist(vtype,'R','P') and between(vdate,old_5,old_6)
sele sele(1)
  use &datatransferpath\acvoucherdt alias det 
  index on voucher to det 
sele led
mvno=99999999999999999
go top
do while!eof()
	if voucher#mvno
		mvno=voucher
		mvoucher=mvoucher+5
	endif
	do while voucher=mvno and !eof()
		sele gle
		appen blank
		repl voucher with mvoucher
		repl book with led.vtype
		repl vcsno with alltrim(str(led.voucher))
		repl code with alltrim(str(led.lcode))
		repl code1 with  alltrim(str(led.againstcod))
		repl date with led.vdate
		if led.drcr='C'
			repl credit with led.amount
			repl cd with 'C'
		else
			repl debit with led.amount
			repl cd with 'D'
		endif
		repl remark1 with led.narration
			if old_3='Y'
					sele det
					seek led.voucher 
					osfound=iif(found(),1,0)
					do while voucher=led.voucher .and. !eof()
						sele pendings
						if led.ltype='C'
							mvcn=subs(det.billno+space(20),1,20)
						else
							mvcn=subs(det.billno+space(20),1,20)
	                        mvch=repli('0',7-len(alltrim(str(det.Billvouche))))+alltrim(str(det.billvouche))
						endif	
						l3= mvcn &&Bt.bnk2+'-'+replicate('0',10-l2)+l1
						sele pendings
						seek subs(alltrim(str(led.lcode))+space(06),1,6)+subs(l3+space(20),1,20)
						if !found()
						endif
						if found()
							sele pend
							appe blank
							repl voucher with mvoucher
							repl ord with gle.code
							repl ddate with gle.date
							repl vcn with l3
							if led.vtype='R'
								repl final with -det.amount
							else
								repl final with det.amount
							endif
							repl type with 'A'
							repl adjvoucher with pendings.voucher
							repl svoucher with pendings.svoucher
						else
						endif
						sele det
						skip
					enddo
			endif
		
		sele led
		skip
	enddo
enddo
sele mslip
repl voucher with mvoucher
close data





func mdbsqlconvert(mdbsqlpara1)
do case
case mdbsqlpara1=1
	if datatransfermdb='Y'
		mrgmdbfile=alltrim(getfile('mdb'))
		datatransferpath=alltrim(datatransferpath)
		=mdbsqlconvert(2)
	endif
case mdbsqlpara1=2 and datatransfermdb='Y'
	mrgmdbfile=alltrim(mrgmdbfile)
	mrgmdbpwd='' &&alltrim(mrgmdbpwd)
	datatransferpath=subs(alltrim(datatransferpath)+'mdb_data\'+space(80),1,80)
	datatransferpath=alltrim(datatransferpath)
	mrgexit=0
	if empty(mrgmdbfile)
		=messagebox("Please Enter Access File Name !!",100,'Check MDB File Path')
		mrgexit=1
	endif
	if !file(mrgmdbfile)
		=messagebox("Access File not found. Please Check !!",100,'Check MDB File Path')
		mrgexit=1
	endif
	if empty(datatransferpath)
		=messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	endif
	if mrgexit=1
		=messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		return
	endif
	lnconnhandle=0
	merrno=0
	try
		if empty(mrgmdbpwd)
			lnconnhandle=sqlstringconnect('DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		else
			lnconnhandle=sqlstringconnect('PWD='+trim(mrgmdbpwd)+';DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		endif
	catch to oexp
		merrno=1
	endtry
	if merrno=1
		=messagebox('Invalid MS-Access data file or invalid password.',48,'Will Quit Now')
		retu
	endif
	if !directo(alltrim(datatransferpath))
		md &datatransferpath
	endif
	datatransferpath=addbs(datatransferpath)
	if lnconnhandle>0
		clear
		@07,10 say 'Converting Access File to DBF. Please Wait......' font 'courier',16
		dvfp_tflds=0
		sele sele(1)
		lnresult=sqltables(lnconnhandle,'TABLE')
		tblfnd=0
		if lnresult > 0
			sele sqlresult
			scan
				try
					msqltabl=uppe(allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					sele sele(1)
					lngetdata=sqlexec(lnconnhandle,lcsqlcommand,'NEWDATA')
					if lngetdata>0
						lcdbffilenm=allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=chrtran(lcdbffilenm," "+chr(9),"")
						sele newdata
						copy to &lcdbffilenm
						wait wind lcdbffilenm nowait
						use
					endif
				catch to oerr
					merrno=1
					=messagebox(oerr.message,64)
*!*						susp
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "Access File Successfully Converted to DBF."
	else
		=messagebox('Unable to read from Connection',48,'Marg ')
		retu
	endif
	rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	if merrno=1
		=messagebox('Error encountered while importing data.',48)
		retu
	endif
	clear
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
case mdbsqlpara1=3
	clear
	mrgsqlfile=alltrim(mrgsqlfile)
	mrgsqluserid=alltrim(mrgsqlpwd)
	mrgsqlpwd=alltrim(mrgsqlpwd)
	datatransferpath=alltrim(datatransferpath)
	mrgexit=0
	if empty(mrgsqlfile)
		=messagebox("Please Enter SQL Database Name !!",100,'Check File Name')
		mrgexit=1
	endif
	if empty(datatransferpath)
		=messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	endif
	if mrgexit=1
		=messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		return
	endif
	lnconnhandle=0
	merrno=0
	try
		lnconnhandle=sqlstringconnect("DRIVER=Sql Server;SERVER=SANTOSH-LP\SQLEXPRESS;UID="+mrgsqluserid+";PWD="+mrgsqlpwd+";APP=Microsoft Visual FoxPro;WSID=MARG01;DATABASE="+mrgsqlfile)
	catch to oexp
		merrno=1
	endtry
	if merrno=1
		=messagebox('Invalid data file or invalid password.',48,'Will Quit Now')
		retu
	endif
	if !directo(datatransferpath)
		md &datatransferpath
	endif
	datatransferpath=addbs(datatransferpath)
	if lnconnhandle>0
		clear
		@07,10 say 'Converting SQL Database to DBF. Please Wait......' font 'courier',16
		dvfp_tflds=0
		sele sele(1)
		lnresult=sqltables(lnconnhandle,'TABLE')
		tblfnd=0
		if lnresult > 0
			sele sqlresult
			scan
				try
					msqltabl=uppe(allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					sele sele(1)
					lngetdata=sqlexec(lnconnhandle,lcsqlcommand,'NEWDATA')
					if lngetdata>0
						lcdbffilenm=allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=chrtran(lcdbffilenm," "+chr(9),"")
						sele newdata
						copy to &lcdbffilenm
						use
					endif
				catch to oerr
					merrno=1
					=messagebox(oerr.message,64)
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "SQL DataBase  Successfully Converted to DBF."

	else
		=messagebox('Unable to read from Connection',48,'Marg ')
		retu
	endif
	rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	if merrno=1
		=messagebox('Error encountered while importing data.',48)
		retu
	endif
	clear
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
*datatransferpath=subs(alltrim(datatransferpath)+space(80),1,80)
endcase


proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

*!*	EOF : JHA.PRG .....Varanasi Dated    : 15/03/2019
