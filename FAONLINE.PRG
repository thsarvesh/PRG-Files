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
	firstdate=ctod('01/04/2024')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2025')                         && Un-Comment this for run from VFP
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Mar\FA\FAONLINE\DBF\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='09'
removenull = 'NO'
@13,10 say 'FA ONLINE Data Path     :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'FA ONLINE Extension     :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_9    font 'courier',18
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
@ 02,25 say 'Please Wait..Importing FA ONLINE Data To Marg.....' font 'courier',14 colo 'W+/b'
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
rowno=5
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemhead alias fitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
index on name to mitm
dele all
sele fitm
go top
scan
   last=recno()
   sele mitm
   seek substr(fitm.Itemcode+space(10),1,10)
      append blank
      repl mitm.code with VAL(FITM.ITEMCODE)
      repl mitm.name with fitm.Itemcode
      repl mitm.product with upper(fitm.Itemname)
      repl mitm.packing with upper(fitm.unit)
      repl mitm.billname with alltrim(upper(fitm.itemname)) +'  '+ alltrim(upper(fitm.unit))
      repl mitm.unit with 'Pcs'
      repl mitm.gcode with alltrim(fitm.itemcode) 
      repl mitm.gcode3 with alltrim(fitm.Itemgrcode) 
      repl mitm.minimum with fitm.Minlevel
      repl mitm.maximum with fitm.Maxlevel
      repl mitm.taxl with 'T'
      repl mitm.taxc with 'T'
      repl mitm.decimal with 'Y'
      repl mitm.salfix with 'N'
      repl mitm.halfsche with 'A'
      repl mitm.qtrsche with 'Y'
      repl mitm.salsc with fitm.cst
      repl mitm.status with 'Y'
      repl mitm.ratea with fitm.Salerate
      repl mitm.prate with fitm.Purchasera
      repl mitm.mrp with fitm.mrp
      repl mitm.qty with fitm.Obquantity
      repl mitm.tqty with fitm.Obquantity     
      repl mitm.saltax with fitm.cgstpercen
      repl mitm.cgst with fitm.cgstpercen
      repl igst with  fitm.cgstpercen*2
	&&&Hsn Code master
	sele mpcm
	seek ('COMMCD'+substr(upper(fitm.itemgstcod)+space(40),1,40))+str(mitm.igst,5,2)
	if !found()
		appen blank
		repl sgcode with 'COMMCD',;
			 scode with 'H'+alltri(str(recno())),;
			 sname with upper(fitm.itemgstcod),;
			 parnam with upper(fitm.itemgstcod),;
			 igst with mitm.igst
	endif
	repl mitm.gcode6 with mpcm.scode
	&&&company master
	sele mpcm
	seek ('ZZZZZZ'+substr(upper(fitm.manufactur)+space(40),1,40))
	if !found()
		appen blank
		repl sgcode with 'ZZZZZZ',;
			 scode with 'C'+alltri(str(recno())),;
			 sname with upper(fitm.manufactur),;
			 parnam with upper(fitm.manufactur)
	endif
	repl mitm.gcode with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Item Group Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemgroup alias fpcm
sele sele(1)
use &datdev\saletype.&datext alias  mpcm
dele all for sgcode='SALT  '
sele fpcm
go top
scan
	sele mpcm
	appen blank
	repl sgcode with 'SALT  ',;
		 sname with upper(fpcm.itemgrname),;
		 parnam with upper(fpcm.itemgrname),;
		 scode with fpcm.itemgrcode
endscan
close table all
@rowno,10 say '**** Importing Batch Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\Itembatches alias fsbal
sele sele(1)
use &datdev\pro.&datext alias  mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias  msbal
index on name+batchno to msbal
r=0
sele fsbal
go top
scan
   sele mitm
   seek substr(fsbal.Itemcode+space(10),1,10)
   sele msbal
   seek substr(fsbal.Itemcode+space(10),1,10) + substr(fsbal.Batchsno+space(12),1,12)
   if .not. found()
      append blank
      repl msbal.date with date()
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.packing with mitm.packing
      repl msbal.unit2 with mitm.unit2
      repl msbal.unit with mitm.unit
      repl msbal.decimal with 'Y'
      repl msbal.opening with fsbal.Cbquantity
      repl msbal.balance with fsbal.Cbquantity      
      repl msbal.o_a with fsbal.Cbquantity
      repl msbal.b_a with fsbal.Cbquantity      
      repl msbal.batchno with fsbal.Batchsno
      repl msbal.exp with fsbal.Expiry
      repl msbal.prate with fsbal.Purchasera
      repl msbal.ratea with fsbal.Salerate
      repl msbal.mrp with fsbal.mrp
      repl msbal.misc1 with mitm.gcode
      repl msbal.lprate with fsbal.mimrate         
    endif    
endscan
close table all
@rowno,10 say '**** Importing Batch Master In****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stockreg alias fsbal
sele sele(1)
use &datdev\pro.&datext alias  mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias  msbal
index on name+batchno to msbal
r=0
sele fsbal
go top
scan for riflag='R'
   sele mitm
   seek substr(fsbal.Itemcode+space(10),1,10)
   sele msbal
   seek substr(fsbal.Itemcode+space(10),1,10) + substr(fsbal.Batchsno+space(12),1,12)
   	if !found()
      append blank
      repl msbal.date with date()
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.packing with mitm.packing
      repl msbal.unit2 with mitm.unit2
      repl msbal.unit with mitm.unit
      repl msbal.decimal with 'Y'
      repl msbal.opening with fsbal.quantity+fsbal.freeqtty
      repl msbal.balance with fsbal.quantity+fsbal.freeqtty
      repl msbal.o_a with fsbal.quantity+fsbal.freeqtty
      repl msbal.b_a with fsbal.quantity+fsbal.freeqtty
      repl msbal.batchno with fsbal.Batchsno
    else
      repl msbal.opening with msbal.opening+(fsbal.quantity+fsbal.freeqtty)
      repl msbal.balance with msbal.balance+(fsbal.quantity+fsbal.freeqtty)
      repl msbal.o_a with msbal.o_a+(fsbal.quantity+fsbal.freeqtty)
      repl msbal.b_a with msbal.b_a+(fsbal.quantity+fsbal.freeqtty)
     
    endif    
endscan
close table all
@rowno,10 say '**** Importing Batch Master Out****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stockreg alias fsbal
sele sele(1)
use &datdev\pro.&datext alias  mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias  msbal
index on name+batchno to msbal
r=0
sele fsbal
go top
scan for riflag='I'
   sele mitm
   seek substr(fsbal.Itemcode+space(10),1,10)
   sele msbal
   seek substr(fsbal.Itemcode+space(10),1,10) + substr(fsbal.Batchsno+space(12),1,12)
   	if !found()
      append blank
      repl msbal.date with date()
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.packing with mitm.packing
      repl msbal.unit2 with mitm.unit2
      repl msbal.unit with mitm.unit
      repl msbal.decimal with 'Y'
      repl msbal.opening with -ABS((fsbal.quantity+fsbal.freeqtty))
      repl msbal.balance with -ABS((fsbal.quantity+fsbal.freeqtty))
      repl msbal.o_a with -ABS((fsbal.quantity+fsbal.freeqtty))
      repl msbal.b_a with -ABS((fsbal.quantity+fsbal.freeqtty))
      repl msbal.batchno with fsbal.Batchsno
    else
      repl msbal.opening with msbal.opening-ABS((fsbal.quantity+fsbal.freeqtty))
      repl msbal.balance with msbal.balance-ABS((fsbal.quantity+fsbal.freeqtty))
      repl msbal.o_a with msbal.o_a-ABS((fsbal.quantity+fsbal.freeqtty))
      repl msbal.b_a with msbal.b_a-ABS((fsbal.quantity+fsbal.freeqtty))
     
    endif    
endscan
close table all


@rowno,10 say '**** Importing Ledger Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\acchead alias fact
sele sele(1)
use &datatransferpath\vouchers alias fbal
index on acccode to fbal
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
go top
scan
   sele mact
   append blank
   	do case
   		case inlist(fact.accgrcode,'7 ','8 ')
	    	repl mact.scode with 'C6'
   		case inlist(fact.accgrcode,'18','19')
	    	repl mact.scode with 'D31'
   		case inlist(fact.accgrcode,'25','2 ')
	    	repl mact.scode with 'J6'
   		case inlist(fact.accgrcode,'23')
	    	repl mact.scode with 'J5'
   		case inlist(fact.accgrcode,'25')
	    	repl mact.scode with 'J12'
	    otherwise	
	    	repl mact.scode with 'J12'
	 endcase
   repl mact.ordno with fact.Acccode
   repl mact.parnam  with upper(fact.Accname)
   repl mact.paradd with upper(fact.Addr1)
   repl mact.paradd1 with upper(fact.Addr2)
   repl mact.dsm with fact.pin
   repl mact.sthed with  'TIN No.'
   repl mact.csthed with 'CST  No.'
   repl mact.gstno with fact.reglocal
   repl mact.stno with fact.regtin
   repl mact.confir with upper(fact.contperson)
   repl mact.city with upper(fact.city)
   repl mact.dlno with alltrim(fact.Regdl1)+'/'+ALLTRIM(fact.Regdl2)
   repl mact.phone1 with fact.Telno1
   repl mact.phone2 with fact.Telno2
   repl mact.phone4 with fact.Mobile
   repl mact.mailNam with fact.Accname
   repl mact.ref with 'Mr.'
   repl mact.area with fact.Area
   repl mact.price with 'A'
   repl mact.city with fact.City
   repl mact.status with 'Y'
   repl mact.adhed with 'Discount'
		sele fbal
		seek fact.acccode
		sum amount to tdebit for cdflag='D' while acccode=fact.acccode
		sele fbal
		seek fact.acccode
		sum amount to tcredit for cdflag='C' while acccode=fact.acccode
	repl mact.opning with tdebit-tcredit
	***STATE
	sele support
	appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
***area update
	sele mpcm
	seek ('AREA  '+substr(upper(fact.area)+space(40),1,40))
		if !found()
		appen blank
		repl sgcode with 'AREA  ',;
			 sname with upper(fact.area),;
			 parnam with upper(fact.area),;
			 scode with 'A'+alltri(str(recno()))
		endif
	repl mact.area with mpcm.scode
endscan
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
