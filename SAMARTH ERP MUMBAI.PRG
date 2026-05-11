*!*	BOF : Samarth Erp.PRG .....Dated    : 28/02/2025   Author : SARVESH
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
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='d:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\samarth\new\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_6 = lastdate
old_7 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='27'
removenull = 'NO'
@13,10 say 'Samarth Data Path       :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'Samarth Extension       :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_6    font 'courier',18
@18,10 say 'GST/VAT                 :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code          :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Removenull              :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@21,10 say 'Type SURE               :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
read
datatransferpath  = alltrim(datatransferpath)
datdev  = alltrim(datdev)
datext = alltrim(datext)
if lastkey()=27 &&.or. sure#'SURE'
	return
endif
if type('FINALCP')#'U'
	=starttransfer()
endif
clear
rowno=5
@ 02,25 say 'Please Wait..Importing Samarth Data To Marg.....' font 'courier',14 colo 'W+/b'
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
close table all
rowno=5
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemmaster alias fitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
	sele mitm
	appen blank
	repl code with fitm.itemid
	repl name with alltri(str(fitm.itemid))
	repl product with  HexToText(fitm.itemname)
	repl packing with HexToText(fitm.pack)
	repl billname with mitm.product+mitm.packing
	repl pack with fitm.perpackqty
	repl rackno with ''
	repl unit with HexToText(fitm.unit)
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.gcode with padr(fitm.mfgcompany,6)
*!*		repl mitm.gcode3 with padr(fitm.generic,6)
	repl mitm.gcode5 with padr(fitm.itemgroupn,6)
*!*		repl mitm.maximum with fitm.stocklavelmax
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.mrp
	repl mitm.ratea with fitm.discounted
	repl mitm.lprate with fitm.landingrat
	repl mitm.prate with fitm.purchasera
	repl saltax with fitm.gstper/2
	repl cgst   with fitm.gstper/2
	repl igst   with fitm.gstper
	mhsn=HexToText(fitm.hsn)
	&&&HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(mhsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with mhsn,;
			mpcm.parnam with mhsn,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\itemmfgcompanies.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ  '
	repl mpcm.scode  with padr(fpcm.mfgcomp000,6)
	repl mpcm.sname  with HexToText(fpcm.mfgcompany)
	repl mpcm.parnam with HexToText(fpcm.mfgcompany)
	repl mpcm.tcode with 'No'
endscan
close table all

@rowno,10 say '**** Importing Generic****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\Genericmaster.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'SALT  '
	repl mpcm.scode  with padr(fpcm.genericid,6)
	repl mpcm.sname  with HexToText(fpcm.genericcon)
	repl mpcm.parnam with HexToText(fpcm.genericcon)
	repl mpcm.tname with substr(HexToText(fpcm.genericcon),41,40)
	repl mpcm.tcode with 'No'
endscan
close table all

@rowno,10 say '**** Importing Category****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\itemgroups.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO'
	repl mpcm.scode  with padr(fpcm.itemgro000,6)
	repl mpcm.sname  with HexToText(fpcm.itemgroupn)
	repl mpcm.parnam with HexToText(fpcm.itemgroupn)
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itembatchmaster alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan
	xbatch=HexToText(fsbal.batchno)
	sele mitm
	seek str(fsbal.itemid,9)
	sele msbal
	seek str(fsbal.itemid,9)+substr(xbatch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.packing with mitm.packing,;
			msbal.pack with mitm.pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with fsbal.currentsto,;
			msbal.balance with fsbal.currentsto,;
			msbal.o_a with fsbal.currentsto,;
			msbal.b_a with fsbal.currentsto,;
			msbal.batchno with xbatch
		    repl msbal.exp with fsbal.expdate,;
			msbal.mrp with fsbal.mrp,;
			msbal.prate with fsbal.purchasera,;
			msbal.ratea with fsbal.discounted,;
			msbal.lprate with fsbal.landingrat,;
			msbal.misc1 with mitm.gcode,;
			msbal.mycode with HexToText(fsbal.barcodeno),;
			msbal.supcode with padr(fsbal.supplierno,6),;
			msbal.supdat with fsbal.lastpurcha,;
			msbal.date with fsbal.lastpurcha
	else
		repl msbal.opening with msbal.opening + fsbal.currentsto,;
			msbal.balance with msbal.balance + fsbal.currentsto,;
			msbal.o_a with msbal.o_a + fsbal.currentsto,;
			msbal.b_a with msbal.b_a + fsbal.currentsto,;
			msbal.supcode with padr(fsbal.supplierno,6),;
			msbal.supdat with fsbal.lastpurcha,;
			msbal.date with fsbal.lastpurcha
	endif
endscan
sele msbal
close table all
@rowno,10 say '**** Importing Doctor Master****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\doctormaster.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PRE#$~'
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PRE#$~',;
		mdoc.ordno with HexToText(fdoc.mobile),;
		mdoc.parnam with HexToText(fdoc.doctorname),;
		mdoc.city with HexToText(fdoc.address),;
		mdoc.form with alltrim(str(fdoc.doctorno))
endsc
close data all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ledgermaster alias fact
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
	repl mact.scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with padr(fact.ledgerno,6)
	repl mact.fax2 with HexToText(fact.refrencele)
	repl mact.parnam  with HexToText(fact.ledgername)
	repl mact.mailnam with HexToText(fact.ledgername)
	repl mact.paradd with HexToText(fact.address1)
	repl mact.paradd1 with HexToText(fact.address2)
	repl mact.paradd2 with HexToText(fact.city)
	repl mact.confir with HexToText(fact.refrencepe)
	repl mact.city with HexToText(fact.city)
	repl phone1 with HexToText(fact.phoneno)
	repl phone4 with HexToText(fact.phoneno)
	repl dlno with fact.gaon
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.gstno with upper(hexToText(fact.gstin))
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.opning with fact.currentbal
	*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having
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
Endproc

FUNCTION HexToText(tcHexString)
    LOCAL lcHex, lcResult, lnLen, lnVal, i, lcPair
    lcResult = ""
    lcHex = ALLTRIM(tcHexString)
    *-- Remove 0x if present
    IF LEFT(UPPER(lcHex),2) = "0X"
        lcHex = SUBSTR(lcHex,3)
    ENDIF
    lnLen = LEN(lcHex)
    *-- Length even hona chahiye
    IF MOD(lnLen,2) # 0
        RETURN tcHexString
    ENDIF
    FOR i = 1 TO lnLen STEP 2        
        lcPair = SUBSTR(lcHex,i,2)
        *-- Check valid hex
        IF NOT BETWEEN(VAL("0x"+lcPair),0,255)
            RETURN tcHexString
        ENDIF
        lnVal = VAL("0x"+lcPair)
        lcResult = lcResult + CHR(lnVal)
    ENDFOR
    RETURN lcResult
ENDFUNC
*!*	EOF : Samarth Erp.PRG .....Dated    : 28/02/2025   Author : SARVESH
