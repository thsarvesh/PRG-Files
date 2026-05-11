*!*	BOF : KEY STROK.PRG .....Dated    : 23/02/2026   Author : SARVESH
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
datatransferpath=substr('D:\2025\Feb\Keystrok\data\KEYSTROKE\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_6 = lastdate
old_7 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='32'
removenull = 'NO'
@12,10 say 'KEYSTROK Data Path      :'  font 'Courier',18 get datatransferpath  font 'courier',18
@13,10 say 'KEYSTROK Extension      :'  font 'Courier',18 get datatransferext  font 'courier',18
@14,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@15,10 say 'TRANSFER TYPE           :'  font 'courier',18 get old_4 pict '@m Master Only,Full Migration' font 'courier',18
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
@ 02,25 say 'Please Wait..Importing KEYSTROK Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\party alias master
sele sele (1)
select * from master where pa_company=.T. into curs fpcm readwr
index on pa_code to fpcm

sele sele(1)
use &datatransferpath\item alias fitm
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
	repl name with fitm.it_code
	repl product with fitm.it_name
	repl packing with fitm.it_packing
	repl billname with fitm.it_name
	repl pack with 0
	repl rackno with fitm.it_barcode
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.maximum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.it_mrp
	repl saltax with fitm.it_gst/2
	repl cgst   with fitm.it_gst/2
	repl igst   with fitm.it_gst
	mhsn=fitm.it_hsncode
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
	=seek(fitm.it_company,'fpcm')
	mcomp=fpcm.pa_name
	&&&Company Master
	sele mpcm
	seek 'ZZZZZZ' + substr(mcomp+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with mcomp,;
			mpcm.parnam with mcomp,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
endscan
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\subpurch alias fsbal
sele sele(1)
use &datdev\malter.&datext  alias altr 
dele all
pack 
index on code+batch+substr(name,1,20) to altr
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
go top
scan
	mexp=ctod('')
	texp=alltri(str(fsbal.sp_expdt))
	if len(texp)=4
		mexp=ctod('01/'+substr(texp,1,2)+'/20'+substr(texp,3,2))
	endif
	if len(texp)=3
		mexp=ctod('01/0'+substr(texp,1,1)+'/20'+substr(texp,2,2))
	endif
	if len(texp)<3
		mexp=ctod('')
	endif
	
	sele mitm
	seek substr(fsbal.sp_item+space(10),1,10)
	sele msbal
	seek substr(fsbal.sp_item+space(10),1,10)+substr(fsbal.sp_batch+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.packing with mitm.packing,;
			msbal.pack with fsbal.sp_pack,;
			mitm.pack with fsbal.sp_pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with (fsbal.sp_qty_tot-fsbal.sp_qty_sld),;
			msbal.balance with (fsbal.sp_qty_tot-fsbal.sp_qty_sld),;
			msbal.o_a with (fsbal.sp_qty_tot-fsbal.sp_qty_sld),;
			msbal.b_a with (fsbal.sp_qty_tot-fsbal.sp_qty_sld),;
			msbal.batchno with fsbal.sp_batch
		    repl msbal.exp with mexp,;
			msbal.mrp with fsbal.sp_discper,;
			msbal.mrp with fsbal.sp_mrp,;
			msbal.prate with fsbal.sp_purrate,;
			msbal.ratea with fsbal.sp_mrp,;
			msbal.lprate with msbal.prate/iif(mitm.pack#0,mitm.pack,1),;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
			
	else
		repl msbal.opening with msbal.opening +(fsbal.sp_qty_tot-fsbal.sp_qty_sld),;
			msbal.balance with msbal.balance +(fsbal.sp_qty_tot-fsbal.sp_qty_sld),;
			msbal.o_a with msbal.o_a +(fsbal.sp_qty_tot-fsbal.sp_qty_sld),;
			msbal.b_a with msbal.b_a +(fsbal.sp_qty_tot-fsbal.sp_qty_sld)

	endif
endscan
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\party alias master
sele sele (1)
select * from master where pa_stokist=.T. into curs fact readwr
index on pa_code to fact

sele sele(1)
use &datatransferpath\FaTRAN alias fbal
index on ft_party to fbal

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
	repl mact.ordno with alltri(str(recno()))
	repl mact.fax2 with fact.pa_code
	repl mact.parnam  with fact.pa_name
	repl mact.mailnam with fact.pa_name
	repl mact.paradd with fact.pa_add1
	repl mact.paradd1 with fact.pa_add2
	repl mact.paradd2 with fact.pa_add3
	repl mact.city with fact.pa_city
	repl mact.dsm with alltri(str(fact.pa_pin))
	repl phone1 with fact.pa_phone
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.cstno with fact.pa_cst
	repl mact.dlno with alltri(fact.pa_dlno1)+' '+alltri(fact.pa_dlno2)+alltri(fact.pa_dlno3)
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	sele fbal
	seek fact.pa_code
	sum ft_amount to tot1 while ft_party=fact.pa_code
	
	sele mact
	repl opning with -(abs(fact.pa_opbal_y)+tot1)
	
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
=messagebox('Master Transfer has been done,Please check the data','MargErp')
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
*!*	EOF : KEY STROK.PRG .....Dated    : 23/02/2026   Author : SARVESH
