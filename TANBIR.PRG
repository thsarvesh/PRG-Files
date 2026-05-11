*!*	BOF TFTANBIR.PRG     Author     Sarvesh Thakur
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
	datdev='d:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Nov\Tanveer\Dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master'
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='20'
removenull = 'NO'
@13,10 say 'TANBIR Data Path        :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'TANBIR Extension        :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'MASTER TYPE             :'  font 'courier',18 get old_4 pict '@m Master ,Full   'font 'courier',18
@17,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@18,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_9    font 'courier',18
@19,10 say 'GST/VAT                 :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@20,10 say 'State GST Code          :'  font 'courier',18 get mstatecode    font 'courier',18
@21,10 say 'Removenull              :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@22,10 say 'Type SURE               :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing TANBIR To Marg.....' font 'courier',14 colo 'W+/b'
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
@rowno,10 say '**** Importing Products****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\products.&datatransferext alias fitm
SELECT SELECT(1)
use &datdev\pro.&datext alias mitm
index on code to mitm
select select(1)
use &datdev\saletype.&datext alias mpcm
delete all for inlist(sgcode,'COMMCD','ZZZZZZ','CATEGO','SALT')
pack
index on sgcode+parnam+str(igst,5,2) to mpcm
sele fitm
pack
go top
do while !eof()
    last=recno()
    SELECT mitm
    SEEK fitm.psrl
    if !found() 												
        append blank
        repl mitm.code with fitm.psrl
        repl mitm.name with alltrim(str(fitm.psrl))
        repl mitm.product with UPPER(fitm.item)
        repl mitm.packing with fitm.pack
        repl mitm.billname with subs(UPPER(fitm.item),1,30)+' '+(fitm.pack)
        repl mitm.unit with 'PCS'
        repl mitm.gcode WITH alltri(str(fitm.cno))
        repl mitm.gcode3 WITH alltri(str(fitm.gno))
        repl mitm.taxl with 'T'
        repl mitm.taxc with 'T'
        repl mitm.decimal with 'Y'
        repl mitm.salfix with 'N'
        repl mitm.halfsche with 'A'
        repl mitm.qtrsche with 'Y'
        repl mitm.status with 'Y'
        repl mitm.saltax With fitm.sgst
        repl mitm.purtax With fitm.sgst
        repl mitm.cgst With fitm.cgst
        repl mitm.igst With fitm.igst
        repl mitm.prate with fitm.prate
        repl mitm.ratea with fitm.srate
        repl mitm.mrp With fitm.mrp
        repl mitm.misc5 With '            0.0000             YN 1B%             '
    endif
   &&&???? For HSN
    sele mpcm
    seek 'COMMCD' + substr(fitm.hsncode+space(15),1,15) + str(mitm.igst,5,2)
    if !found()
        append blank
        repl mpcm.sgcode with 'COMMCD',;
        mpcm.scode  with 'H'+alltrim(str(last)),;
        mpcm.sname  with substr(fitm.hsncode+space(15),1,15)+substr(fitm.hsncode,1,15) +' '+ alltrim(str(mitm.igst,5,2))+'%',;
        mpcm.parnam with substr(fitm.hsncode,1,15),;
        mpcm.tax with mitm.saltax,;
        mpcm.cgst with mitm.cgst,;
        mpcm.igst with mitm.igst,;
        mpcm.tcode with 'No'
    endif 
    repl mitm.gcode6 with mpcm.scode 
sele fitm
skip
enddo
close table all   
@rowno,10 say '**** Importing Product category ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemgroups.&datatransferext alias fpcm 
sele sele(1) 
use &datdev\saletype.&datext alias mpcm
sele fpcm 
scan
    sele mpcm
    appen blank 
    repl sgcode with 'SALT  ',scode with alltrim(Str(fpcm.gno))
    repl sname with alltrim(fpcm.gname),parnam with alltrim(fpcm.gname) 
endscan    
close table all

@rowno,10 say '**** Importing Product Company ****' font 'Arial',10
rowno=rowno+1
sele sele(1) 
use &datatransferpath\company.&datatransferext alias fpcm 
sele sele(1) 
use &datdev\saletype.&datext alias mpcm 
sele fpcm
go top
scan
    sele mpcm
    appe blank
    repl mpcm.sgcode with 'ZZZZZZ',;
         mpcm.scode with alltrim((fpcm.msrl)),;
         mpcm.sname  with UPPER(fpcm.mname),;
         mpcm.parnam with UPPER(fpcm.code),;
         mpcm.tcode with 'No',;
         mpcm.igst with 0
sele fpcm
Endscan
close table all
@rowno,10 say '**** Importing Batch Wise Stock****' font 'Arial',10
rowno=rowno+1
sele sele(1) 
use &datatransferpath\stock.&datatransferext alias fsbal 
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm   
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+ batchno to msbal
r=0
sele fsbal
go top
do while .not. eof()
    mExp='01/'+iif(emonth<9,'0','')+alltrim(Str(emonth))+'/20'+alltrim(Str(eYear))
	sele mitm
	seek str(fsbal.psrl,9)
    sele msbal
	seek str(fsbal.psrl,9)+substr(fsbal.batch+space(12),1,12)
    if ! found()
        appe blan
        repl msbal.date with date()
        repl msbal.code with mitm.code
        repl msbal.name with mitm.name
        repl msbal.billname with mitm.billname
        repl msbal.product with mitm.product
        repl msbal.packing with mitm.packing
        repl msbal.pack with mitm.pack
        repl msbal.unit2 with mitm.unit2
        repl msbal.unit with mitm.unit
        repl msbal.decimal with 'Y'
        repl msbal.batchno with fsbal.batch
        repl msbal.exp with ctod(mExp)
        frmdeal=AT('+',fsbal.lot)
        repl msbal.deal with val(alltri(substr(fsbal.lot,1,frmdeal-1)))
        repl msbal.free with val(alltr(subst(fsbal.lot,frmdeal+1,10)))
        repl msbal.prate with fsbal.prate
        repl msbal.ratea with fsbal.srate
        repl msbal.misc1 with mitm.gcode
        repl msbal.lprate with fsbal.cost
        repl msbal.mrp with fsbal.mrp
        repl msbal.opening with iif(old_4='M',fsbal.qty,fsbal.oqty)
        repl msbal.o_a with iif(old_4='M',fsbal.qty,fsbal.oqty)
        repl msbal.balance with iif(old_4='M',fsbal.qty,fsbal.oqty)
        repl msbal.b_a with iif(old_4='M',fsbal.qty,fsbal.oqty)
    else
        repl msbal.opening with opening+iif(old_4='M',fsbal.qty,fsbal.oqty)
        repl msbal.o_a with o_a+iif(old_4='M',fsbal.qty,fsbal.oqty)
        repl msbal.balance with balance+iif(old_4='M',fsbal.qty,fsbal.oqty)
        repl msbal.b_a with b_a+iif(old_4='M',fsbal.qty,fsbal.oqty)
     
    endif    
    sele fsbal
    skip
ENDDO
sele msbal
close table all
@rowno,10 say '**** Importing Account Master****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ledger.&datatransferext  alias fact
sele sele(1)
use &datatransferpath\states.&datatransferext  alias fstate
index on tin to fstate
sele sele(1) 
use &datdev\order.&datext alias mact
sele sele(1) 
use &datdev\support.&datext alias support
dele all for sno=7 
pack  
sele fact
go top
do while .not. eof()
last=recno()
=seek(statecode,'fstate')
store '' to mscode
	do case 
	    case fact.gid=1 
	        mscode='D31' 
	    case fact.gid=2
	        mscode='C6' 
	    case fact.gid=3 
	        mscode='D1' 
	    case fact.gid=4 or fact.gid=5 
	        mscode='C1' 
	    case fact.gid=6 
	        mscode='J6' 
	    case fact.gid=7
	        mscode='J5'
	    otherwise
	     	mscode='J12'
	endcase 
    sele mact
    appe blan
    repl mact.scode with mscode
    repl mact.rate with 'Y'
    repl mact.ordno WITH (fact.cno)
    repl mact.parnam  with UPPER(fact.name)
    repl mact.paradd with upper(substr(fact.address,1,40))
    repl mact.paradd1 with upper(substr(fact.address,41,40))
    repl mact.paradd2 with upper(fstate.statename)
    repl mact.sthed with  'TIN No.'
    repl mact.csthed with 'CST  No.'
    repl mact.gsthed with 'GST  No.'
    repl mact.gstno with upper(fact.gstin)
    repl mact.dlno with UPPER(alltrim(fact.dlno))
    repl mact.itno with fact.pan
    repl mact.mailNam with UPPER(fact.name)
    repl mact.phone1 with ALLTRIM(fact.Phone)
    repl mact.ref with 'Mr.'
    repl mact.price with 'A'
    repl mact.status with 'Y'
    repl mact.adhed with 'Discount'
    repl rate with iif(old_3='O','N',iif(old_3='B','Y','F'))
    repl disc1 with fact.saledisc
    if old_4='Y' 
        repl mact.opning with  iif(fact.drcr='D',fact.balance,-fact.balance)
        repl mact.balance with iif(fact.drcr='D',fact.balance,-fact.balance)
    Else
        repl mact.opning with  iif(fact.opdrcr='D',fact.opbalance,-fact.opbalance)
        repl mact.balance with iif(fact.drcr='D',fact.balance,-fact.balance) 
    Endif
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
sele fact
skip
enddo
close table all
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

*!*	EOF TFTANBIR.PRG     Author     SARVESH THAKUR