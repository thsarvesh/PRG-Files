*!*	BOF : Xiama.PRG ....  Author : SARVESH
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
	firstdate=ctod('01/04/2022')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2023')                         && Un-Comment this for run from VFP
	datdev='D:\transfer'                                 && Un-Comment this for run from VFP
	datext='dbf'
ENDIF

sure= space(4)
datatransferpath=substr('D:\April\A049BF07\master\'+space(95),1,95) &&rpos_path
datatransferpath1=substr('D:\April\A049BF07\data\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
datatransferext1='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='07'
removenull = 'NO'
@12,10 say 'MASTER Data Path        :'  font 'Courier',18 get datatransferpath  font 'courier',18
@13,10 say 'TRAN Data Path          :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'MD Extension            :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_9    font 'courier',18
@18,10 say 'GST/VAT                 :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code          :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Removenull              :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@21,10 say 'Type SURE               :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
read
datatransferpath  = alltrim(datatransferpath)
datatransferpath1 = alltrim(datatransferpath1)
datdev  = alltrim(datdev)
datext = alltrim(datext)
if lastkey()=27 &&.or. sure#'SURE'
	return
endif
if type('FINALCP')#'U'
	=starttransfer()
ENDIF
clear
rowno=5
@ 02,25 say 'Please Wait..Importing Xiama Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\mtrproduct alias fitm
sele sele(1)
use &datatransferpath1\mtrcategory alias fcat
index on categoryid to fcat
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
sele fitm
scan
	mfg=chrtran(mnf,chr(0),'')
		=seek(fitm.categoryid,'fcat')
	ctg=chrtran(fcat.category,chr(0),'')
	sele mitm
	appen blank
	repl code with recno()
	repl name with fitm.prodid
	repl product with chrtran(fitm.prodname,chr(0),'')
	repl packing with ''
	repl billname with chrtran(fitm.prodname,chr(0),'')
	repl pack WITH 0
	repl rackno with fitm.plucode
	repl unit with chrtran(fitm.mainunit,chr(0),'')
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with fitm.cgstper
	repl cgst   with fitm.cgstper
	repl igst   with fitm.cgstper*2
	replace mrp with fitm.mrp
	replace prate with fitm.prate
	replace ratea with fitm.srate
	
*!*	&&& HSN and Tax Mast
*!*		sele mpcm
*!*		seek 'COMMCD' + substr(fitm.generic+space(40),1,40) + str(mitm.igst,5,2)
*!*		if !found()
*!*			append blank
*!*			repl mpcm.sgcode with 'COMMCD',;
*!*				mpcm.scode  with 'HH'+alltrim(str(recno())),;
*!*				mpcm.sname  with fitm.generic,;
*!*				mpcm.parnam with fitm.generic,;
*!*				mpcm.tax with mitm.saltax,;
*!*				mpcm.cgst with mitm.cgst,;
*!*				mpcm.igst with mitm.igst,;
*!*				mpcm.tcode with 'No'
*!*		endif
*!*		repl mitm.gcode6 with mpcm.scode
&&& COMPANY
	sele mpcm
	seek 'ZZZZZZ' + substr(mfg+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'p'+alltrim(str(recno())),;
			mpcm.sname  with mfg,;
			mpcm.parnam with mfg,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
&&& CATEGORY
	sele mpcm
	seek 'CATEGO' + substr(ctg+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with ctg,;
			mpcm.parnam with ctg,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode5 with mpcm.scode
endscan
close table all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\trsstock alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
*set filt to productid=31176
go top
do while !eof()
   sele mitm
   seek  substr(fsbal.itemid+space(10),1,10)
   sele msbal
   seek  substr(fsbal.itemid+space(10),1,10)+substr(fsbal.batch+space(12),1,12)
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
           msbal.opening with (fsbal.qtyin-fsbal.qtyout),;
           msbal.balance with (fsbal.qtyin-fsbal.qtyout),;
           msbal.o_a with (fsbal.qtyin-fsbal.qtyout),;
           msbal.b_a with (fsbal.qtyin-fsbal.qtyout),;
           msbal.batchno with fsbal.batch
     	repl msbal.exp with CTOD(''),;
           msbal.mrp with fsbal.mrp,;
           msbal.prate with fsbal.prate,;
           msbal.ratea with fsbal.srate,;
           msbal.lprate with fsbal.cost,;           
           msbal.mrp with fsbal.mrp,;
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with 'S'+alltri(str(fsbal.lid))
        repl msbal.supinvo with fsbal.invno
        repl msbal.supdat with fsbal.invdate
        repl msbal.date with fsbal.invdate
	   else
          repl msbal.opening with msbal.opening + (fsbal.qtyin-fsbal.qtyout),;
	           msbal.balance with msbal.balance +(fsbal.qtyin-fsbal.qtyout),;
	           msbal.o_a with msbal.o_a +(fsbal.qtyin-fsbal.qtyout),;
	           msbal.b_a with msbal.b_a +(fsbal.qtyin-fsbal.qtyout)
   endif
sele fsbal
skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\mtrledger alias fact

sele sele(1)
use &datatransferpath1\mtrarea alias fpcm
index on areaid to fpcm
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	mparnam=chrtran(ledger,chr(0),'')
	mmailnam=chrtran(ledgername,chr(0),'')
	mphone1=chrtran(contactno,chr(0),'')
	mphone4=chrtran(phoneno,chr(0),'')
	mparadd=chrtran(address,chr(0),'')
	=seek (fact.areaid,'fpcm')
	sele mact
	appen blank
	repl mact.scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with 'S'+fact.lid
	repl mact.parnam  with mparnam
	repl mact.mailnam with mmailnam
	repl mact.paradd with substr(mparadd,1,30)
	repl mact.paradd1 with substr(mparadd,31,30)
	repl phone1 with mphone1
	repl phone4 with mphone4
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having  
***STATE
	    sele support
	    appen blank
		repl aliase with 'ORDER   '
		repl type with 'F'
		repl lcode with mact.ordno
		repl sno with 7
		repl pcode with 15
		repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
endscan
close tables all
return
@rowno,10 say '**** Importing A/C Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\sales1 alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
set filter to balance#0
	go top
scan 
	mvcn=alltr(str(fout.salno))
	sele mord
	seek substr(alltri(str(fout.pa_code))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->net),abs(fout->net))
	repl balance with iif(acgroup='D31',-abs(fout.balance),abs(fout.balance))
	repl itemope with iif(acgroup='D31',-abs(fout->net-fout.balance),abs(fout->net-fout.balance))
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

	@rowno,10 say '**** Importing Ledger Balance  ****' font 'Arial',10
	rowno=rowno+1
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

*!*	EOF : Xiama.PRG ....  Author : SARVESH
