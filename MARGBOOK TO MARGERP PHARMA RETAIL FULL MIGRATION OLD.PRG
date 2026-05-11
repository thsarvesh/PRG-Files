*!*	BOF : MD.PRG .....Dated    : 03/11/2022   Author : SARVESH
*!* datatransferpath="e:\datafrom\"+space(45)
*!* datatransferext="dbf"
*!* for bill difference ## in support -> repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!* for item difference ## in support -> repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,heading with iif(old_11="B",t_batchmaster.batchno,str(t_batchmaster.mrp,9,2)),value with t_batchmaster.stock
*!* for item batch difference ## in support -> repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with iif(old_11="B",t_batchmaster.batchno,str(t_batchmaster.mrp,9,2)),value with t_batchmaster.stock
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
sele sele(1)
close tables all

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
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)

*!*	define wind wDataMigration ;
*!*		from 0,0 TO 25, 80 STYLE 'BI' ;
*!*			TITLE "MARGBOOK TO MARG ERP MIGRATION"
datatransferpath=substr('D:\2025\Aug\Jitendermargbook\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
styp='W'
old_3 = 'Yes'
old_4 = 'Full Migration'
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
scalc='9'
pcalc='9'
outsonly='No '
old_12 = 'GST'
mstatecode='09'
xmultimode='N'	
removenull = 'NO'
mlinkid=space(30)
flinkid=space(30)
mychoice=1
=Get_Firm()
@01,5 say 'MARGBOOK TO MARGERP 9 + MIGRATION TOOL '  font 'ARIAL BOLD',12 COLOR RGB(197,91,49)
@04,5 say 'COMPANY MASTER LINKID   :'  font 'COURIER new',12 get mlinkid font 'COURIER new',12
@05,5 say 'FINANCIAL YEAR LINKID   :'  font 'COURIER new',12 get Flinkid font  'COURIER new',12
@06,5 say 'MARG BOOK Data Path     :'  font 'COURIER new',12 get datatransferpath font  'COURIER new',12
@07,5 say 'MARG BOOK Extension     :'  font 'COURIER new',12 get datatransferext  font  'COURIER new',12
@08,5 say 'WITH O/S                :'  font 'COURIER new',12 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'COURIER new',12
@09,5 say 'MIGRATION TYPE          :'  font 'COURIER new',12 get old_4 pict '@m Master,Full Migration' font 'COURIER new',12
@10,5 say 'F.Y.BEGIN FROM          :'  font 'COURIER new',12 get old_5  font 'COURIER new',12
@11,5 say 'F.Y.UP TO               :'  font 'COURIER new',12 get old_9  font 'COURIER new',12
@12,5 say 'PURCHASE CALCULATION    :'  font 'COURIER new',12 get pcalc pict '@m 2,9' font 'COURIER new',12
@13,5 say 'SALE CALCULATION        :'  font 'COURIER new',12 get scalc pict '@m 2,9' font 'COURIER new',12
@14,5 say 'Multi Mode of Payment   :'  font 'COURIER new',12 get xmultimode pict '@m Y,N' font 'COURIER new',12
@15,5 say 'SOFTWARE TYPE           :'  font 'COURIER new',12 get styp  pict '@m R,W'    font 'COURIER new',12
@16,5 say 'State GST Code          :'  font 'COURIER new',12 get mstatecode   font 'COURIER new',12
@17,5 say 'Removenull              :'  font 'COURIER new',12 get removenull pict '@M No ,Yes'    font 'COURIER new',12
@19,5 say 'Type SURE               :'  font 'COURIER new',12 get sure pict '@x!'  font 'COURIER new',12
read
datatransferpath  = alltrim(datatransferpath)
datdev  = alltrim(datdev)
datext = alltrim(datext)
if lastkey()=27 or mychoice=2
	return
endif

*!*	release WINDOW wDataMigration 
if type('FINALCP')#'U'
	=starttransfer()
endif
clear
rowno=5
@ 02,25 say 'Please Wait..Importing MARGBOOK Data To Marg.....' font 'courier',14 colo 'W+/b'
rowno=rowno+1
set colo to
if removenull='Y'
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next

endif
close data

set colo to
sele sele(1)
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
use &datdev\support.&datext
dele all for type='#' or aliase='ORDER'
pack
close data

@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemmaster alias t_itemmaster
set filt to complinkid=mlinkid
sele sele(1)
use &datatransferpath\unitmaster alias t_unitmaster
set filt to complinkid=mlinkid
index on linkid to t_unitmaster

sele sele(1)
use &datatransferpath\taxcategorymaster alias t_tax_master
set filt to complinkid=mlinkid
index on salepurtypelinkid to t_tax_master

sele sele(1)
use &datatransferpath\hsnmaster alias t_hsnmaster
set filt to complinkid=mlinkid
index on linkid to t_hsnmaster

sele sele(1)
use &datatransferpath\itemcompanymaster alias t_companymaster
set filt to complinkid=mlinkid
index on linkid to t_companymaster

sele sele(1)
use &datatransferpath\saltmaster alias t_saltmaster
set filt to complinkid=mlinkid
index on linkid to t_saltmaster

sele sele(1)
use &datatransferpath\categorymaster alias t_categorymaster
set filt to complinkid=mlinkid
index on linkid to t_categorymaster

sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
sele t_itemmaster
scan
	=seek(t_itemmaster.taxcategorylinkid,'t_tax_master')
	=seek(t_itemmaster.hsnlinkid,'t_hsnmaster')
	=seek(t_itemmaster.itemcomplinkid,'t_companymaster')
	=seek(t_itemmaster.saltlinkid,'t_saltmaster')
	=seek(t_itemmaster.categorylinkid,'t_categorymaster')
	sele mitm
	appen blank
	repl code with recno()
	repl name with t_itemmaster.itemcode
	repl product with chrtran(t_itemmaster.product,chr(0),'')
	repl packing with chrtran(t_itemmaster.packing,chr(0),'')
	repl billname with mitm.product+mitm.packing
	repl pack WITH t_itemmaster.conversion
	repl bookname with t_itemmaster.linkid
	repl unit with 'PCS'
	repl rackno with t_itemmaster.barcode
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with t_itemmaster.minimumquantity
	repl maximum with t_itemmaster.maximumquantity
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with t_tax_master.sgst
	repl cgst   with t_tax_master.cgst
	repl igst   with t_tax_master.igst
	replace mrp with t_itemmaster.mrp
	replace prate with t_itemmaster.prate
	replace ratea with t_itemmaster.ratea,rateb with t_itemmaster.rateb,ratec with t_itemmaster.ratec,rated with t_itemmaster.rated,;
			ratee with t_itemmaster.ratee,ratef with t_itemmaster.ratef,rateg with t_itemmaster.rateg,rateh with t_itemmaster.rateh
	replace lprate with t_itemmaster.cost
&&& HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(t_hsnmaster.hsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with t_hsnmaster.hsn,;
			mpcm.parnam with t_hsnmaster.hsn,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
&&& COMPANY
	sele mpcm
	seek 'ZZZZZZ' + substr(t_companymaster.cname+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'CO'+alltrim(str(recno())),;
			mpcm.sname  with t_companymaster.cname,;
			mpcm.parnam with t_companymaster.cname,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
&&& group
	sele mpcm
	seek 'SALT  ' + substr(t_saltmaster.name+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'SA'+alltrim(str(recno())),;
			mpcm.sname  with t_saltmaster.name,;
			mpcm.parnam with t_saltmaster.name,;
			mpcm.tname with substr(t_saltmaster.name,41,40),;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
&&& CATEGORY
	sele mpcm
	seek 'CATEGO' + substr(t_categorymaster.name+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'CAT'+alltrim(str(recno())),;
			mpcm.sname  with t_categorymaster.name,;
			mpcm.parnam with t_categorymaster.name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode5 with mpcm.scode
endscan
close table all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\batchmaster alias t_batchmaster
set filt to complinkid=mlinkid 
sele sele(1)
use &datdev\pro.&datext alias mitm
index on substr(bookname,1,20) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on substr(mycode,1,20)+batchno to msbal
sele t_batchmaster
go top
do while !eof()
   sele mitm
   seek substr(t_batchmaster.itemmasterlinkid,1,20)
   sele msbal
   seek substr(t_batchmaster.itemmasterlinkid,1,20)+ substr(t_batchmaster.batchname+space(12),1,12)
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
           mycode with t_batchmaster.itemmasterlinkid,;
           msbal.opening with iif(old_4='F',t_batchmaster.totalbalancequantity,t_batchmaster.totalbalancequantity),;
           msbal.balance with iif(old_4='F',t_batchmaster.totalbalancequantity,t_batchmaster.totalbalancequantity),;
           msbal.o_a with iif(old_4='F',t_batchmaster.totalbalancequantity,t_batchmaster.totalbalancequantity),;
           msbal.b_a with iif(old_4='F',t_batchmaster.openingquantity,t_batchmaster.totalbalancequantity),;
           msbal.batchno with iif(t_batchmaster.batchname='AutoBatch','',t_batchmaster.batchname)
        REPL msbal.tqty with t_batchmaster.totalbalancequantity
     	repl msbal.exp with ctod(substr(t_batchmaster.expirydate,9,2)+'/'+substr(t_batchmaster.expirydate,6,2)+'/'+substr(t_batchmaster.expirydate,1,4))
        repl msbal.mrp with t_batchmaster.mrp,;
             msbal.prate with 0.00
		replace ratea with t_batchmaster.ratea,rateb with t_batchmaster.rateb,ratec with t_batchmaster.ratec,rated with t_batchmaster.rated,;
			    ratee with t_batchmaster.ratee,ratef with t_batchmaster.ratef,rateg with t_batchmaster.rateg,rateh with t_batchmaster.rateh
        replace msbal.lprate with t_batchmaster.costperpcs,;           
	            msbal.mrp with t_batchmaster.mrp,;
	            msbal.misc1 with mitm.gcode,;
	            msbal.supcode with ''
         repl msbal.supinvo with t_batchmaster.purchasebillno
         repl msbal.supdat with t_batchmaster.billdate
	   else
          repl msbal.opening with msbal.opening + iif(old_4='F',t_batchmaster.openingquantity,t_batchmaster.totalbalancequantity),;
	           msbal.balance with msbal.balance +iif(old_4='F',t_batchmaster.openingquantity,t_batchmaster.totalbalancequantity),;
	           msbal.o_a with msbal.o_a +iif(old_4='F',t_batchmaster.openingquantity,t_batchmaster.totalbalancequantity),;
	           msbal.b_a with msbal.b_a +iif(old_4='F',t_batchmaster.openingquantity,t_batchmaster.totalbalancequantity)
          repl msbal.tqty with tqty+t_batchmaster.totalbalancequantity

	   endif
sele t_batchmaster
skip
enddo
sele msbal
close table all
if styp='R'
@rowno,10 say '**** Importing Patient Master  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\patientmaster alias fpat
set filt to complinkid=mlinkid

sele sele (1)
use &datdev\maorder.&datext alias mdoc
set filt to scode='PET#$~'
dele all
pack
index on scode to mdoc 
sele fpat 
go top
scan
   sele mdoc 
   append blank
   repl mdoc.scode with 'PET#$~',;
        mdoc.parnam with fpat.name,;
        mdoc.city with (fpat.address),;
        mdoc.form with alltrim(fpat.mobileno)
endscan
close data all
@rowno,10 say '**** Importing Patient Master  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\doctormaster alias fdoc
set filt to complinkid=mlinkid
sele sele (1)
use &datdev\maorder.&datext alias mdoc
set filt to scode='PRE#$~'
dele all
pack
index on scode to mdoc 
sele fdoc
go top
scan
   sele mdoc 
   append blank
   repl mdoc.scode with 'PRE#$~',;
        mdoc.parnam with fdoc.name,;
        mdoc.form with alltrim(fdoc.mobileno)
endscan
close data all
endif
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ledgermaster alias t_accountmaster
set filt to complinkid=mlinkid
sele sele(1)
use &datatransferpath\accountgroupmaster alias t_accountgroup
*set filt to complinkid=mlinkid
index on linkid to t_accountgroup
sele sele(1)
use &datatransferpath\stationmaster alias t_stationmaster
set filt to complinkid=mlinkid
index on linkid to t_stationmaster

sele sele(1)
use &datatransferpath\areamaster alias t_areamaster
set filt to complinkid=mlinkid
index on linkid to t_areamaster

sele sele (1)
use &datatransferpath\routemaster alias t_routmaster
set filt to complinkid=mlinkid
index on linkid to t_routmaster

sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele t_accountmaster
scan
	=seek(t_accountmaster.arealinkid,'t_areamaster')
	=seek(t_accountmaster.routlinkid,'t_routmaster')
	=seek(t_accountmaster.accountgrouplinkid,'t_accountgroup')
	=seek(t_accountmaster.stationlinkid,'t_stationmaster')
	sele mact
	appen blank
	wacctgroup=''
	wgroupcode=''
	parentgrup=''
	wcurrentaccount=alltrim(upper(t_accountgroup.name))
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
	case 'SUPPLIER'$wcurrentaccount or 'VENDOR'$wcurrentaccount
		wgroupcode='D31 '
	case 'SUNDRY DEBTOR'$wcurrentaccount or 'CUSTOMER'$wcurrentaccount 
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
	repl mact.rate with 'Y'
	repl mact.ordno with 'A'+alltri(str(recno()))
	repl mact.fax2 with t_accountmaster.linkid
	repl mact.margcode with t_accountmaster.linkid
	repl mact.parnam  with t_accountmaster.ledgername
	repl mact.mailnam with t_accountmaster.mailto
	repl mact.paradd with t_accountmaster.address1
	repl mact.paradd1 with t_accountmaster.address2
	repl mact.paradd2 with t_accountmaster.address3
	repl mact.city with t_stationmaster.stationname
	repl mact.dsm with t_accountmaster.postalcode
	repl mact.confir with t_accountmaster.firstname
	repl mact.desi with t_accountmaster.designation
	repl mact.phone1 with t_accountmaster.phoneno
	repl mact.phone2 with t_accountmaster.mobile2
	repl mact.phone4 with t_accountmaster.mobile1
	repl mact.gstno with t_accountmaster.gstno
	repl mact.stno with t_accountmaster.vatno
	repl itno with t_accountmaster.panno
	repl mact.dlno with t_accountmaster.dlno
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl opning with iif(t_accountmaster.openingiscreditdebit=2,-t_accountmaster.opening,t_accountmaster.opening)
***STATE
	    sele support
	    appen blank
		repl aliase with 'ORDER   '
		repl type with 'F'
		repl lcode with mact.ordno
		repl sno with 7
		repl pcode with 15
		repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
&&&&&area
	sele mpcm
	seek 'AREA  ' + substr(t_areamaster.areaname+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'AREA  ',;
			mpcm.scode  with 'AR'+alltrim(str(recno())),;
			mpcm.sname  with t_areamaster.areaname,;
			mpcm.parnam with t_areamaster.areaname,;
			mpcm.tcode with 'No'
	endif
	repl mact.area with mpcm.scode
&&&&&rout
	sele mpcm
	seek 'ROUT  ' + substr(t_routmaster.routename+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'ROUT  ',;
			mpcm.scode  with 'RO'+alltrim(str(recno())),;
			mpcm.sname  with t_routmaster.routename,;
			mpcm.parnam with t_routmaster.routename,;
			mpcm.tcode with 'No'
	endif
	repl mact.rout with mpcm.scode

endscan
close tables all

*!*	@rowno,10 say '**** Importing A/C Outstandings  ****' font 'Arial',10
*!*	rowno=rowno+1
*!*	sele sele(1)
*!*	use &datdev\pendings.&datext alias mpend
*!*	sele sele(1)
*!*	use &datdev\order.&datext alias mord
*!*	inde on substr(margcode,1,20) to mord

*!*	sele sele(1)
*!*	use &datatransferpath\SaleChallanBill alias t_saleheader
*!*	set filt to complinkid=mlinkid
*!*	index on linkid to t_saleheader
*!*	sele sele(1)
*!*	use &datatransferpath\PurchaseChallanBill alias t_purchaseheader
*!*	set filt to complinkid=mlinkid
*!*	index on linkid to t_purchaseheader
*!*	sele sele(1)
*!*	use &datdev\slipno.&datext alias mslip
*!*	sele sele(1)
*!*	use &datatransferpath\outstanding alias t_outstanding
*!*	if old_4='F'
*!*		set filt to complinkid=mlinkid and datatype=101 
*!*	else
*!*		set filt to complinkid=mlinkid
*!*	endif
*!*	sele mslip
*!*	go top
*!*	vou =voucher  + 10
*!*	svou=svoucher + 10
*!*	sele t_outstanding
*!*	go top
*!*	scan
*!*	mvcn=''
*!*	if seek(t_outstanding.saleorpurchaselinkid,'t_saleheader')
*!*		mvcn=alltr(t_saleheader.entryno)
*!*	endif
*!*	if seek(t_outstanding.saleorpurchaselinkid,'t_purchaseheader')
*!*		mvcn=alltr(t_purchaseheader.partybillno)
*!*	endif
*!*		mdate=ctod(substr(t_outstanding.billdate,9,2)+'/'+substr(t_outstanding.billdate,6,2)+'/'+substr(t_outstanding.billdate,1,4))
*!*		sele mord
*!*		seek substr(t_outstanding.ledgerlinkid+space(20),1,20)
*!*		sele mpend
*!*		appen blan
*!*		repl acgroup with mord->scode
*!*		repl ord with mord.ordno
*!*		repl ddate with mdate
*!*		repl vcn with iif(empty(mvcn),'Opening',mvcn)
*!*		repl invtype with 'O'
*!*		repl voucher  with vou
*!*		repl svoucher with svou
*!*		repl final with iif(acgroup='D31',-abs(t_outstanding->totalamount),abs(t_outstanding->totalamount))
*!*		repl balance with iif(acgroup='D31',-abs(t_outstanding.balanceamount),abs(t_outstanding.balanceamount))
*!*		repl itemope with iif(acgroup='D31',-abs(t_outstanding->receiveamount),abs(t_outstanding->receiveamount))
*!*		repl name with vcn
*!*		vou=vou+5
*!*		svou=svou+5
*!*	endsc
*!*	sele mslip
*!*	repl voucher  with vou+5
*!*	repl svoucher with svou+5
*!*	close table all

*!*	@rowno,10 say '**** Importing Ledger Balance  ****' font 'Arial',10
*!*	rowno=rowno+1
*!*	sele sele(1)
*!*	use &datdev\order.&datext alias mord
*!*	inde on ordno to mord 
*!*	sele sele(1)
*!*	use &datdev\pendings.&datext alias mpend
*!*	inde on ord to mpend 
*!*	sele mord
*!*	go top
*!*		scan
*!*		sele mpend
*!*		seek mord->ordno
*!*		sum balance to mbal whil ord=mord->ordno and !eof()
*!*		sele mord
*!*		repl opning with mbal
*!*	endsc
*!*	clos table all

if old_4='F' 
	do Inward_trf
	do Outward_trf
	do STOCK_UPDT
	do Invertory_voucher
	do Account_voucher
endif


Proce Inward_trf
@rowno,10 say '**** Importing Purchase Transactions  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\pro.&datext alias pro     
index on substr(bookname,1,20) to pro
sele sele(1)
use &datdev\order.&datext alia ord    
inde on substr(margcode+space(20),1,20) to ord
sele sele(1)
use &datdev\dis.&datext alias dis     
sele sele(1)
use &datdev\mdis.&datext alias mdis   
sele sele(1)
use &datdev\probat.&datext alias prb  
index on substr(mycode,1,20)+batchno to prb
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20

sele sele(1)
use &datatransferpath\batchmaster alia t_batchmaster
set filte to complinkid=mlinkid
index on itemmasterlinkid+linkid to t_batchmaster
sele sele(1)
use &datatransferpath\accountingdetails alia t_otheraddless
set filte to CompLinkId=mlinkid 
index on saleorpurchaselinkid to t_otheraddless 
sele sele(1)
sele * from  &datatransferpath\accountingdetails into curs tmode readwr
set filte to CompLinkId=mlinkid and finyear=year(firstdate) and isdelete#1
index on saleorpurchaselinkid+str(creditordebit,3)+str(datatype,3) to tmode

sele sele(1)
use &datatransferpath\purchasechallanbill alia t_purchaseheader
set filte to CompLinkId=mlinkid and FinancialYearLinkId=flinkid and isdelete#1
sele sele(1)
use &datatransferpath\purchasechallanbillDetail alia t_purchasedetail
set filte to CompLinkId=mlinkid and FinancialYearLinkId=flinkid and isdelete#1
index on purchasechallanlinkid to t_purchasedetail
i=1
sele t_purchaseheader
go top
scan for isdelete#1
	f_purchasedate=ctod(substr(t_purchaseheader.billdate,9,2)+'/'+substr(t_purchaseheader.billdate,6,2)+'/'+substr(t_purchaseheader.billdate,1,4))
	f_entrydate=ctod(substr(t_purchaseheader.partysalebilldate,9,2)+'/'+substr(t_purchaseheader.partysalebilldate,6,2)+'/'+substr(t_purchaseheader.partysalebilldate,1,4))
	l2='P-'+padl(i,6,'0')
	l3=partybillno
	i=i+1
	=seek(substr(t_purchaseheader.partyinfolinkid+space(20),1,20),'ord')
	sele mdis
	appen blan
	do case
		case t_purchaseheader.datatype=16
			repl type with 'P'
			repl pm with l3
			repl challan with l2
			repl chdate with f_purchasedate
			repl lrda with f_entrydate
		case inlist(t_purchaseheader.datatype,17)
			repl type with 'P'
			repl vcn with l2
			repl pm with l3
			repl date with f_purchasedate
			repl lrda with f_entrydate
		case t_purchaseheader.datatype=18
			repl type with 'X'
			repl challan with l3
			repl lrda with f_entrydate
			repl chdate with f_purchasedate
		case t_purchaseheader.datatype=23
			repl type with 'Q'
			repl challan with l3
			repl chdate with f_purchasedate
			repl pm with l2
			repl lrda with f_purchasedate
		case t_purchaseheader.datatype=22
			repl type with 'Q'
			repl vcn with l3
			repl date with f_purchasedate
			repl pm with l2
			repl lrda with f_purchasedate
		case t_purchaseheader.datatype=21
			repl type with 'B'
			repl challan with l3
			repl chdate with f_purchasedate
			repl pm with alltri(t_saleheader.partybillno)
			repl lrda with f_entrydate
		case t_purchaseheader.datatype=20
			repl type with 'B'
			repl vcn with l3
			repl date with f_purchasedate
			repl pm with l3
			repl lrda with f_entrydate
		case t_purchaseheader.datatype=19
			repl type with 'D'
			repl challan with l2
			repl chdate with f_purchasedate
			repl pm with l3
			repl lrda with f_entrydate
	endcase
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl codep with ord.ordno
	repl ltype with pcalc
	repl voucher with last4
	last4=last4+5
	repl rout with ' '
	repl area with ' '
	repl addis with 0
	repl sale with 'Z'
	repl account with 'N'
	repl godwon with 'A'
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
	repl amountp with t_purchaseheader.totalinvoiceamount
	repl final with t_purchaseheader.totalinvoiceamount
	repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	sele tmode
	seek t_purchaseheader.linkid+str(2,3)+str(69,3)
	if found()
		sele mdis 
		repl cash with tmode.amount
		repl final with final-tmode.amount
	endif

	
&&other expenses
	sele t_otheraddless
	seek t_purchaseheader.linkid 
		scan for isadditionalexp=1  while saleorpurchaselinkid=t_purchaseheader.linkid 
		=seek(substr(ledgerlinkid+space(20),1,20),'ord')
	       if mdis.packing=0
		       repl mdis.pacun with ord.ordno
		       repl mdis.packing with iif(creditordebit=1,t_otheraddless.amount,-t_otheraddless.amount)
	       else
	       if mdis.other =0
		       repl mdis.othun with ord.ordno
		       repl mdis.other with iif(creditordebit=1,t_otheraddless.amount,-t_otheraddless.amount)
	       else
		       repl mdis.freun with ord.ordno
		       repl mdis.freight with iif(creditordebit=1,t_otheraddless.amount,-t_otheraddless.amount)
	       endi
	       endi
	endsc
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

sele t_purchasedetail
seek t_purchaseheader.linkid
scan while purchasechallanlinkid=t_purchaseheader.linkid 
	=seek(substr(t_purchasedetail.itemlinkid,1,20),'pro')
	=seek(t_purchasedetail.itemlinkid+t_purchasedetail.batchlinkid,'t_batchmaster')
		sele dis
		appen blan
		repl codep with mdis->codep
		repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
		repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
		repl voucher with mdis->voucher
		repl code with pro.code
		repl batch with iif(t_batchmaster.batchname='AutoBatch','',t_batchmaster.batchname)
     	repl exp with ctod(substr(t_batchmaster.expirydate,9,2)+'/'+substr(t_batchmaster.expirydate,6,2)+'/'+substr(t_batchmaster.expirydate,1,4))
		repl pack with pro.pack
		repl rate with  t_purchasedetail.purchaserate
		repl exp with prb.exp
		repl mrp with  t_purchasedetail.mrp
		repl qty with t_purchasedetail.quantity
		repl free with t_purchasedetail.free
		repl disc1 with t_purchasedetail.discount1
		repl disc2 with t_purchasedetail.discount2
		repl svdis with t_purchasedetail.volumediscount1
		repl svdis1 with t_purchasedetail.volumediscount2
		repl flg with iif(mdis.type='S','G',mdis.type)
		if !empty(disc1)
			repl tax with 'P'
			REPL MDIS.ltype with '2'
		else
			repl tax with 'T'
			REPL MDIS.ltype with '9'
		endif
			
			if isigst=1
				repl ssta with t_purchasedetail.igstper
			else
				repl ssta with t_purchasedetail.sgstper
				repl cgst with t_purchasedetail.cgstper
			endi
		repl half with 'A'
		repl godwon with mdis->godwon
endsc
endsc
sele sele(1)
sele mslip
go top
repl voucher with last4+10
repl svoucher with slast5+10
clos tabl all
retu


Proce Outward_trf
@rowno,10 say '**** Importing Sale Transactions  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\pro.&datext alias pro     
index on substr(bookname,1,20) to pro
sele sele(1)
use &datdev\order.&datext alia ord    
inde on substr(margcode+space(20),1,20) to ord
sele sele(1)
use &datdev\dis.&datext alias dis     
sele sele(1)
use &datdev\mdis.&datext alias mdis   
sele sele(1)
use &datdev\subdis.&datext alias msub
index on str(voucher,9)+dsm+type+substr(rtqt,1,6) to msub
sele sele(1)
use &datdev\probat.&datext alias prb  
index on substr(mycode,1,20)+batchno to prb
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20
if styp='R'
	sele sele(1)
	use &datatransferpath\patientmaster alia t_pat
	set filte to complinkid=mlinkid
	index on linkid to t_pat
	sele sele(1)
	use &datatransferpath\doctormaster alia t_doc
	set filte to complinkid=mlinkid
	index on linkid to t_doc
endif
sele sele(1)
use &datatransferpath\batchmaster alia t_batchmaster
set filte to complinkid=mlinkid
index on itemmasterlinkid+linkid to t_batchmaster


sele sele(1)
use &datatransferpath\accountingdetails alia t_otheraddless
set filte to CompLinkId=mlinkid 
index on saleorpurchaselinkid to t_otheraddless 

sele sele(1)
use &datatransferpath\SaleChallanBill alia t_saleheader
set filte to CompLinkId=mlinkid and FinancialYearLinkId=flinkid and isdelete#1

sele sele(1)
sele * from  &datatransferpath\accountingdetails into curs tmode readwr
set filte to CompLinkId=mlinkid and finyear=year(firstdate) and isdelete#1
index on saleorpurchaselinkid+str(creditordebit,3)+str(datatype,3) to tmode

sele sele(1)
use &datatransferpath\SaleChallanBillDetail alia tsaledetail
set filte to CompLinkId=mlinkid and FinancialYearLinkId=flinkid and isdelete#1
index on salechallanlinkid to tsaledetail

sele t_saleheader
go top
scan for isdelete#1 
	f_saledate=ctod(substr(t_saleheader.billdate,9,2)+'/'+substr(t_saleheader.billdate,6,2)+'/'+substr(t_saleheader.billdate,1,4))
	f_lrdate=ctod(substr(t_saleheader.deliverydate,9,2)+'/'+substr(t_saleheader.deliverydate,6,2)+'/'+substr(t_saleheader.deliverydate,1,4))
	l3 = entryno
	=seek(substr(t_saleheader.partyinfolinkid+space(20),1,20),'ord')
	sele mdis
	appen blan
	do case
		case t_saleheader.datatype=1
			repl type with 'S'
			repl challan with l3
			repl chdate with f_saledate
		case inlist(t_saleheader.datatype,2,9)
			repl type with 'S'
			repl vcn with l3
			repl date with f_saledate
		case t_saleheader.datatype=3
			repl type with 'V'
			repl challan with l3
			repl chdate with f_saleedate
		case t_saleheader.datatype=7
			repl type with 'W'
			repl challan with l3
			repl chdate with f_saledate
			repl pm with alltri(t_saleheader.partybillno)
			repl lrda with f_saleedate
		case t_saleheader.datatype=4
			repl type with 'W'
			repl vcn with l3
			repl date with f_saleedate
			repl pm with alltri(t_saleheader.partybillno)
			repl lrda with f_lrdate
		case t_saleheader.datatype=8
			repl type with 'R'
			repl challan with l3
			repl chdate with f_saleedate
			repl pm with alltri(t_saleheader.partybillno)
			repl lrda with f_lrdate
		case t_saleheader.datatype=6
			repl type with 'R'
			repl vcn with l3
			repl date with f_purchasedate
			repl pm with alltri(t_saleheader.partybillno)
			repl lrda with f_lrdate
		case t_saleheader.datatype=5
			repl type with 'L'
			repl challan with l3
			repl chdate with f_purchasedate
	endcase
	repl pm with l3
	repl lrda with f_lrdate
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl codep with ord.ordno
	repl ltype with scalc
	repl voucher with last4
	last4=last4+5
	repl rout with ' '
	repl area with ' '
	repl addis with t_saleheader.billdiscountinpercent
	repl sale with 'Z'
	repl account with 'N'
	repl godwon with 'A'
	repl discafter with 'M'
	repl othun with 'STAC23'
	repl other with 0
	repl pacun with ''
	repl packing with 0
if xmultimode='Y'	
	repl cash with t_saleheader.totalinvoiceamount
	repl misc3 with substr(misc3,1,34)+'M'+substr(misc3,36,100)
	sele tmode
	seek t_saleheader.linkid+str(1,3)+str(59,3)
	scan while saleorpurchaselinkid+str(tmode.creditordebit,3)+str(tmode.datatype,3)=t_saleheader.linkid+str(1,3)+str(59,3)
		=seek(substr(tmode.ledgerlinkid+space(20),1,20),'ord')
		sele msub
		seek (str(mdis.voucher,9)+'REMARK'+'V'+ord.ordno)
		if !found()
			appen blank
			repl codep with mdis.codep
			repl vcn with mdis.vcn
			repl date with mdis.date 
			repl voucher with mdis.voucher
			repl type with 'V'
			repl dsm with 'REMARK'
			repl rtqt with ord.ordno+str(abs(tmode.amount),12,2)
		endif
	endscan
else
	repl final with t_saleheader.totalinvoiceamount
	repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	sele tmode
	seek t_saleheader.linkid+str(1,3)+str(59,3)
	if found()
		sele mdis 
		repl cash with tmode.amount
		repl final with final-tmode.amount
	endif
endif
	if styp='R'
		sele mdis
		if seek(t_saleheader.patientlinkid,'t_pat')
			repl docu with substr(t_pat.mobileno+space(10),1,10)+alltri(t_pat.name)
		else
			repl docu with space(10)+alltri(t_saleheader.patientname)
		endif
		if seek(t_saleheader.doctorlinkid,'t_doc')
			repl docu1 with substr(alltri(t_doc.mobileno)+space(10),1,10)+alltri(t_doc.name)
		else
			repl docu1 with space(10)+alltri(t_saleheader.doctorname)
		endif
	endif
	sele mdis
***Local Central***
	isigst=0
	if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
		isigst=1
	endi
	repl misc3 with substr(misc3,1,54)+str(t_saleheader.totaldiscount,10,2)+substr(misc3,65,100)
	repl sale with 'ZYNYNGAYUN1N1INN M       '
	repl amountp with t_saleheader.totalinvoiceamount
&&other expenses
	sele t_otheraddless
	seek t_saleheader.linkid 
		scan for isadditionalexp=1  while saleorpurchaselinkid=t_saleheader.linkid 
		=seek(substr(ledgerlinkid+space(20),1,20),'ord')
	       if mdis.packing=0
	       repl mdis.pacun with ord.ordno
	       repl mdis.packing with iif(creditordebit=2,t_otheraddless.amount,-t_otheraddless.amount)
	       else
	       if mdis.other =0
	       repl mdis.othun with ord.ordno
	       repl mdis.other with iif(creditordebit=2,t_otheraddless.amount,-t_otheraddless.amount)
	       else
	       repl mdis.freun with ord.ordno
	       repl mdis.freight with iif(creditordebit=2,t_otheraddless.amount,-t_otheraddless.amount)
	       endi
	       endi
	endsc
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

sele tsaledetail
seek t_saleheader.linkid
scan while salechallanlinkid=t_saleheader.linkid 
	=seek(substr(tsaledetail.itemlinkid,1,20),'pro')
	=seek(tsaledetail.itemlinkid+tsaledetail.batchlinkid,'t_batchmaster')
		sele dis
		appen blan
		repl codep with mdis->codep
		repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
		repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
		repl voucher with mdis->voucher
		repl code with pro.code
		repl batch with iif(t_batchmaster.batchname='AutoBatch','',t_batchmaster.batchname)
     	repl exp with ctod(substr(t_batchmaster.expirydate,9,2)+'/'+substr(t_batchmaster.expirydate,6,2)+'/'+substr(t_batchmaster.expirydate,1,4))
		repl pack with pro.pack
		repl rate with  tsaledetail.salerate
		repl exp with prb.exp
		repl mrp with  tsaledetail.mrp
		repl qty with tsaledetail.quantity
		repl free with tsaledetail.free
		repl disc1 with tsaledetail.discount1
		repl disc2 with tsaledetail.discount2
		repl flg with iif(mdis.type='S','G',mdis.type)
		repl tax with 'T'
		if isigst=1
			repl ssta with tsaledetail.igstper
		else
			repl ssta with tsaledetail.sgstper
			repl cgst with tsaledetail.cgstper
		endi
		repl half with 'A'
		repl godwon with mdis->godwon
		if tsaledetail.rateunitsetting=1 and empty(tsaledetail.conversionformula)
			repl misc4 with substr(misc4,1,32)+'1'+substr(misc4,34,100)
		endif
endsc
endsc

sele mslip
go top
repl voucher with last4+10
repl svoucher with slast5+10
clos tabl all
retu
PROC STOCK_UPDT
@rowno,10 say '**** Importing Stock Opening****' font 'Arial',10
rowno=rowno+1
Sele Sele(1)
Use datdev + '\probat.'+datext Alias prb
Inde On batchno+Str(Code) To prb Uniq

Sele Sele(1)
Selec * From prb Into Curso bprb Readwr
Inde On batchno+Str(Code) To bprb

Sele Sele(1)
Use datdev + '\dis.'+datext Alias dis
Inde On Batch+Str(Code) To dis
Sele prb
Go Top
Scan
	Sele bprb
	Seek prb->batchno+Str(prb->Code)

	Sum tqty To mbalance While batchno+Str(Code)=prb.batchno+Str(prb.Code)
	Store 0 To xin,xin1,xout,xout1,xout2
	Sele dis
	Seek prb->batchno+Str(prb->Code)
	Scan For Date=>old_5 While Batch+Str(Code)=prb.batchno+Str(prb.Code)
		If dis.flg = 'P'
			xin = xin +(dis.qty) + (dis.Free)
		Else
			If dis.flg = 'R'
				xin1 = xin1 +(dis.qty) + (dis.Free)
			Else
				If dis.flg = 'G'
					xout = xout +(dis.qty) + (dis.Free)
				Else
					If dis.flg = 'B'
						xout1 = xout1 +(dis.qty) + (dis.Free)
                         Else
					         If dis.flg = 'O'
						         xout2 = xout2 +(dis.qty) + (dis.Free)
                       endi
					Endi
				Endi
			Endif
		Endif
	Endsc
	mopening=mbalance+xout+xout1+xout2-(xin+xin1)
	Sele prb
	Repl prb->opening With mopening
	Repl prb->o_a With mopening
Endsc
Clos Tables All
RETU
Proc Invertory_voucher
@rowno,10 say '**** Importing Account From Inventories ****' font 'Arial',10
rowno=rowno+1
af     =datdev + '\gledger.'+datext
pend   =datdev + '\pend.'+datext
mdis   =datdev + '\mdis.'+datext
pending=datdev + '\pendings.'+datext
Sele g
Use &pending Alias pending
Sele F
Use &pend Alias pend Excl
Sele b
Use &af Alias gledger Excl
Sele Sele(1)
Use &datdev\Order.&datext Alias ord
Index On ordno To ord
Sele d
Use &mdis Alias mdis
Sele Sele(1)
Use &datdev\slipno.&datext Alias mslip
Go Top
msvoucher=svoucher+5
slast5=msvoucher
Sele d
Go Top
Do While .Not. Eof()
 =Seek(mdis.Codep,'ord')
 Sele d
 If vcn=Space(12)
  Skip
  Loop
 Endif
 last1=mdis.Codep
 If mdis.Final#0
  Sele b
  Appe Blank
  Repl voucher With mdis.voucher
  If d.Type='P'
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
  Repl gcode With ord.scode
**** for outstanding
  If old_3='Y'
   Sele F
   Appe Blank
   Repl ord With mdis.Codep
   Repl ddate With mdis.Date
   Repl duedays With mdis.duedays
   Repl vcn With mdis.vcn
   If d.Type='P'
    Repl Final With -mdis.Final
   Else
    Repl Final With mdis.Final
   Endif
   Repl Type With 'N'
   Repl voucher With mdis.voucher
   Repl adjvoucher With mdis.voucher
   Repl svoucher With slast5
   slast5=slast5+5
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
   Repl acgroup With ord.scode
  Endif
 Endif
 If mdis.cash#0
  Sele b
  Appe Blank
  Repl voucher With mdis.voucher
  If d.Type='P'
   Repl Cd With 'C'
   Repl credit With mdis.cash
  else
   Repl Cd With 'D'
   Repl debit With mdis.cash
  endi
  Repl Date With mdis.Date
  Repl Code With 'STACO3'
  last1='STACO3'
  Repl remark1 With mdis.vcn
  Repl book With 'S'
  Repl Type With 'Y'
  if mdis.salun=Space(6)
   Repl code1 With 'SP#20 '
  else
   Repl code1 With mdis.salun
  endif
 endif
 if (mdis.Final+mdis.cash)#0
  sele b
  appe Blank
  repl voucher With mdis.voucher
  if d.Type#'P'
   repl Cd With 'C'
   repl credit With (mdis.Final+mdis.cash)
  else
   repl Cd With 'D'
   repl debit With (mdis.Final+mdis.cash)
  endif
  repl Date With mdis.Date
  if mdis.salun=Space(6)
   Repl Code With 'SP#20 '
  Else
   Repl Code With mdis.salun
  Endif
  Repl remark1 With mdis.vcn
  Repl book With 'S'
  Repl Type With 'Y'
  Repl code1 With last1
 Endif
 Sele gledger
 Sele d
 Skip
Enddo
Sele gledger
Sele mslip
Repl svoucher With msvoucher
clos tabl all
retu

proc Account_voucher
@rowno,10 say '**** Transfer other Accounting Entries ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\gledger.&datext alias gle     

sele sele(1)
use &datdev\order.&datext alia ord    
inde on substr(margcode+space(20),1,20) to ord

sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20

sele sele(1)
use &datatransferpath\voucher.&datatransferext alias tvoucherheader
set filte to CompLinkId=mlinkid and FinancialYearLinkId=flinkid
sele sele(1)
use &datatransferpath\accountingdetails.&datatransferext alias tvoucherdetail
set filte to CompLinkId=mlinkid and finyear=year(firstdate)
index on voucherlinkid to tvoucherdetail

Sele tvoucherheader
Scan for isdelete#1
	f_voucherdate=ctod(substr(tvoucherheader.entrydate,9,2)+'/'+substr(tvoucherheader.entrydate,6,2)+'/'+substr(tvoucherheader.entrydate,1,4))
	f_vouchernumber=tvoucherheader.voucherno
		sele tvoucherdetail
		seek tvoucherheader.linkid
		scan while voucherlinkid=tvoucherheader.linkid
		=seek(substr(tvoucherdetail.ledgerlinkid+space(20),1,20),'ord')
			sele gle
			appen Blank
			Repl voucher With last4
			Repl vcsno With f_vouchernumber
			Repl Code With ord.ordno
			Repl Date With f_voucherdate
			if tvoucherdetail.creditordebit=1
				Repl Cd With 'D'
				Repl debit With tvoucherdetail->amount+tvoucherdetail.shortamount
			else
			    Repl Cd With 'C'
				Repl credit With tvoucherdetail.amount+tvoucherdetail.shortamount
			endi
			Repl remark1 With chrtran(tvoucherdetail.remarks,chr(0),'')
			Repl remark2 With iif(tvoucherdetail.instype=2,'Cheque No : '+alltri(tvoucherdetail.insno),'')
				do case
					case inlist(tvoucherheader.datatype,53,54,63)
						repl book with 'R'
					case inlist(tvoucherheader.datatype,51,52,62)
						repl book with 'P'
					case inlist(tvoucherheader.datatype,55)
						repl book with 'C'
					case inlist(tvoucherheader.datatype,56)
						repl book with 'D'
					case inlist(tvoucherheader.datatype,57)
						repl book with 'E'
					case inlist(tvoucherheader.datatype,58)
						repl book with 'J'
				endcase
	endscan
last4=last4+10
endscan
Sele mslip
Repl voucher With last4+10
repl svoucher with slast5+10
clos tabl all

retu




PROCEDURE get_firm
Close Data
If Used('FIRM')
	Sele Sele(1)
	Sele firm
	Use
Endif
*!*	Sele Sele(1)
*!*	mfirm=Alltrim(datatransferpath)+'companymaster'
*!*	Use &mfirm Alias firm
*!*	Sele Sele(1)
*!*	mfirm1=Alltrim(datatransferpath)+'financialyearhistory'
*!*	Use &mfirm1 Alias firm1
 
datatransferpath=allt(datatransferpath)
select compm.linkid, compm.compname,lcomp.fincialyearfrom,;
lcomp.fincialyearto,lcomp.linkid as finlink from &datatransferpath\companymaster compm ;
left join &datatransferpath\financialyearhistory lcomp on lcomp.complinkid=compm.linkid into curs company

Defi Wind partybills From 1,0 To 15,200 Shadow Float Title "::Select Company ::" Font 'Courier',18
Browse Nomodi Wind partybills Field linkid :h="Company link Id":20,;
Compname :h="Company Name" :50,;
fincialyearfrom :h="Financial Start":20,;
fincialyearto :h="Financial End":20,;
Finlink :h="Financial Year LinkId" :20 font'tahoma',13
mlinkid=linkid
flinkid=finlink
release wind partybills 

*!*	ACTIVATE WINDOW wDataMigration 
Close Table All
retu



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
retu
