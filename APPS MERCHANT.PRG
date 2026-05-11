*!*	BOF : APPS MERCHANT.PRG .....Dated    : 21/11/2024   Author : SARVESH
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
	datdev='D:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Feb\Appmarchent\data\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='20'
removenull = 'NO'
@13,10 say 'APPS MERCHANT Data Path  :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'APPS MERCHANT Extension  :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                 :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM           :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO                :'  font 'courier',18 get old_9    font 'courier',18
@18,10 say 'GST/VAT                  :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code           :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Removenull               :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@21,10 say 'Type SURE                :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing APPS MERCHANT Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\stock alias fitm
sele sele(1)
use &datatransferpath\tax_type alias ftax
index on tax_id to ftax
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
	repl code with recno()
	repl name with fitm.item_cd
	repl product with fitm.item_name
	repl packing with fitm.packing
	repl billname with fitm.item_name
	repl unit with fitm.unit
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with 0
	repl mitm.maximum with 0
	repl mitm.prate with fitm.p_rate
	repl mitm.ratea with fitm.s_rate
	repl mitm.mrp with fitm.s_mrp
	repl mitm.lprate with fitm.p_rate2
	repl mitm.deal with fitm.bonus_1
	repl mitm.free with fitm.bonus_2
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
		if seek(fitm.tax_id,'ftax')
			repl saltax with ftax.tax/2
			repl cgst   with ftax.tax/2
			repl igst   with ftax.tax
		endif
mhsn=fitm.hsn
&&& HSN and Tax Mast
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
&&& COMPANY
	sele mpcm
	seek 'ZZZZZZ' + substr(fitm.gr_name+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'Z'+alltrim(str(recno())),;
			mpcm.sname  with fitm.gr_name,;
			mpcm.parnam with fitm.gr_name,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode with mpcm.scode
msalt=''
&&& salt
	sele mpcm
	seek 'SALT  ' + substr(msalt+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'S'+alltrim(str(recno())),;
			mpcm.sname  with msalt,;
			mpcm.parnam with msalt,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode3 with mpcm.scode
&&& Category
	sele mpcm
	seek 'CATEGO' + substr(fitm.com_type+space(40),1,40) 
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'C'+alltrim(str(recno())),;
			mpcm.sname  with fitm.com_type,;
			mpcm.parnam with fitm.com_type,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode5 with mpcm.scode

endscan
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\batch_dt alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
go top
scan
   sele mitm
   seek substr(fsbal.item_cd+space(10),1,10)
   sele msbal
   seek substr(fsbal.item_cd+space(10),1,10)+substr(fsbal.batch_no+space(12),1,12)
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
           msbal.opening with fsbal.c_bal,;
           msbal.balance with fsbal.c_bal,;
           msbal.o_a with fsbal.c_bal,;
           msbal.b_a with fsbal.c_bal,;
           msbal.batchno with fsbal.batch_no
        repl msbal.deal with fsbal.bonus_1
        repl msbal.free with fsbal.bonus_2
        repl purdeal with fsbal.bonus_1
        repl purfree with fsbal.bonus_2
     	repl msbal.exp with fsbal.exp_dt,;
           msbal.mrp with fsbal.s_mrp,;
           msbal.prate with fsbal.p_rate,;
           msbal.ratea with fsbal.s_rate,;
           msbal.lprate with fsbal.p_rate2,;           
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
        repl supdat with fsbal.op_date
        repl supinvo with ''
	   else
          repl msbal.opening with msbal.opening +fsbal.c_bal,;
	           msbal.balance with msbal.balance +fsbal.c_bal,;
	           msbal.o_a with msbal.o_a + fsbal.c_bal,;
	           msbal.b_a with msbal.b_a + fsbal.c_bal
   endif
endscan
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ledger alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
		do case
			case fact.ac_gr_cd='AG00007'
				repl mact.scode with 'C6'
			case fact.ac_gr_cd='AG00009'
				repl mact.scode with 'D31'
			case fact.ac_gr_cd='AG00003'
				repl mact.scode with 'C2'
			otherwise
				repl mact.scode with 'J12'
		endcase
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(recno()))
	repl mact.fax2 with fact.ac_code
	repl mact.parnam  with fact.ac_name
	repl mact.mailnam with fact.ac_name
	repl mact.paradd with substr(fact.add1,1,40)
	repl mact.paradd1 with substr(fact.add1,41,40)
	repl mact.paradd2 with substr(fact.add1,81,40)
	repl mact.city with fact.area
	repl confir with fact.ac_name2
	repl mact.dlno with alltri(fact.dl_no)+' '+alltri(fact.dl_no1)
	repl gstno with fact.tin_no
	repl gstdate with fact.gstin_exp
	repl phone1 with fact.phone_no
	repl phone4 with fact.phone_no
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.opning with iif(fact.c_sign='D',fact.c_bal,-fact.c_bal)
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
***update dl no expiry date
	    sele support
	    appen blank
		repl aliase with 'ORDER   '
		repl type with 'F'
		repl lcode with mact.ordno
		repl sno with 12
		repl heading with dtoc(fact.dl_exp)
&&&area update 
	sele mpcm
	seek 'AREA  '+substr(fact.area+space(40),1,40)
	if !found()
		appen blank
		repl scode with 'A'+alltri(str(recno()))
		repl sgcode with 'AREA  '
		repl sname with fact.area
		repl parnam with fact.area
	endif
repl mact.area with mpcm.scode
endscan
close tables all
=Messagebox('Master Transfer has been done,Please check the data','MargErp')
retu

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
*!*	EOF : MDSOFT.PRG .....Dated    : 21/11/2024   Author : SARVESH
