*!*	BOF : NXGEN RX.PRG .....Dated    : 21-04-2026   Author : SARVESH
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
datatransferpath=substr('D:\MIGRATION_DATA\APR\NXGEN\25-2026\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_6 = lastdate
old_7 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='03'
removenull = 'NO'
@13,10 say 'NEX GEN Data Path       :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'NEX GEN Extension       :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing NX GEN Data To Marg.....' font 'courier',14 colo 'W+/b'
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
@rowno,10 say '**** Importing Ledger Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\Master alias fact
sele sele(1)
use &datatransferpath\City alias CityMst
Index on ci_id to CityMst
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
		Do case
			Case Fact.Ma_group=2
				Mscode='C6'
			Case Fact.Ma_group=23
				Mscode='C1'
			Case Fact.Ma_group=3
				Mscode='D31'
			Otherwise
				Mscode='J12'
		Endcase
	repl mact.scode with Mscode
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.Ma_id))
	repl mact.fax2 with alltri(str(fact.Ma_id))
	repl mact.parnam  with Substr(Fact.Ma_acname,1,30)+Alltri(CityMst.Ci_city)
	repl mact.mailnam with fact.Ma_acname
	repl mact.paradd with fact.Ma_add1
	repl mact.paradd1 with fact.Ma_add2
	if seek(Fact.Ma_cityid,'CityMst')
		repl mact.paradd2 with CityMst.Ci_city
		repl mact.city with CityMst.Ci_city
	Endif
	repl confir with Fact.Ma_person
	repl mact.dsm with alltri(str(fact.Ma_pin))
	repl phone1 with Fact.Ma_phoneo
	repl phone2 with fact.Ma_phone
	Repl phone3 with Fact.Ma_phoner
	Repl Phone4 with fact.ma_mobile
	replace cstno with fact.Ma_cstno
	replace Stno with Fact.Ma_stno
	replace Area with padr(Fact.Ma_cityid,6)
	replace Gstno with Fact.Ma_gstno
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
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
@rowno,10 say '**** Importing City Master  ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\City.dbf alia CityMst
sele CityMst
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA  '
	repl mpcm.scode  with padr(CityMst.Ci_id,6)
	repl mpcm.sname  with CityMst.Ci_city	
	repl mpcm.parnam with CityMst.Ci_city
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\item alias fitm
sele sele(1)
use &datatransferpath\hsnset alias HsnMst
Index on h_id to HsnMst
sele sele(1)
use &datatransferpath\Taxes alias TaxMst
Index on Tx_id to TaxMst
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
	repl code with fitm.it_id
	repl name with alltri(str(fitm.it_id))
	repl product with fitm.it_name
	repl packing with ''
	repl billname with fitm.it_name
	repl pack with 0
	repl rackno with fitm.It_partno
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
*!*		repl mitm.gcode with padr(fitm.company,6)
*!*		repl mitm.gcode3 with padr(fitm.generic,6)
*!*		repl mitm.maximum with fitm.maxlevel
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.it_mrate
	repl mitm.ratea with fitm.it_s_rate
	repl mitm.lprate with fitm.it_p_rate
	repl mitm.prate with fitm.it_p_rate
	if seek(Fitm.it_sgst,'TaxMst')
		repl saltax with TaxMst.Tx_percnt
		repl cgst   with TaxMst.Tx_percnt
		repl igst   with TaxMst.Tx_percnt*2
	Endif
	if seek(fitm.it_Hsn,'HsnMst')
		mhsn=HsnMst.H_code
	else
		mHsn=''
	endif
	&&&HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(mhsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'H'+alltrim(str(recno())),;
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
=messagebox('Master Transfer has been done,Please check the data','MargErp')
retu
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\mtbcompany.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ  '
	repl mpcm.scode  with padr(fpcm.code,6)
	repl mpcm.sname  with fpcm.name
	repl mpcm.parnam with fpcm.name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Salt ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\mtbgeneric.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'SALT  '
	repl mpcm.scode  with padr(fpcm.code,9)
	repl mpcm.sname  with fpcm.name
	repl mpcm.parnam with fpcm.name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ttbpurdet alias fsbal
sele sele(1)
use &datdev\malter.&datext  alias altr 
dele all
pack 
index on code+batch+substr(name,1,20) to altr
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
do while !eof()
	sele mitm
	seek str(fsbal.item_id,9)
	sele msbal
	seek str(fsbal.item_id,9)+substr(fsbal.batch_no+space(12),1,12)
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
			msbal.opening with fsbal.bal_qty,;
			msbal.balance with fsbal.bal_qty,;
			msbal.o_a with fsbal.bal_qty,;
			msbal.b_a with fsbal.bal_qty,;
			msbal.batchno with fsbal.batch_no,;
			msbal.mycode with alltrim(str(fsbal.track_no))
		    repl msbal.exp with ctod('01/'+substr(fsbal.exp_dt,1,3)+'20'+substr(fsbal.exp_dt,4,2)),;
			msbal.mrp with fsbal.mrp_price,;
			msbal.prate with fsbal.bill_price,;
			msbal.ratea with fsbal.mrp_price,;
			msbal.lprate with fsbal.cost_price/iif(mitm.pack#0,mitm.pack,1),;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
			
	else
		repl msbal.opening with msbal.opening + fsbal.bal_qty,;
			msbal.balance with msbal.balance + fsbal.bal_qty,;
			msbal.o_a with msbal.o_a + fsbal.bal_qty,;
			msbal.b_a with msbal.b_a + fsbal.bal_qty,;
			msbal.mycode with alltrim(str(fsbal.track_no))

	endif
	&&Multi Barcode
	sele altr 
	seek str(msbal.code,9)+msbal.batchno+subs(alltrim(str(fsbal.track_no,20))+space(20),1,20)
	if !found()   
	appen blank
		repl type with 'BTBRCD'
		repl code with STR(msbal.code,9)
		repl batch with msbal.batchno
		repl name with alltrim(str(fsbal.track_no,20))
	endif   
	sele fsbal
	skip
enddo
sele msbal
close table all
@rowno,10 say '**** Importing Doctor Master****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\mtbdoctor.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PRE#$~'
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PRE#$~',;
		mdoc.ordno with alltrim(str(fdoc.code)),;
		mdoc.parnam with fdoc.name,;
		mdoc.city with upper(fdoc.clinicadd1),;
		mdoc.form with alltrim(str(fdoc.code))
endsc
close data all
@rowno,10 say '**** Importing Patient Master  ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\mtbpatient.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PET#$~'
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PET#$~',;
		mdoc.ordno with alltrim(str(fdoc.code)),;
		mdoc.parnam with fdoc.name,;
		mdoc.city with upper(fdoc.add1),;
		mdoc.form with alltrim(str(fdoc.code))
endsc
close data all
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
*!*	EOF : NXGEN RX.PRG .....Dated    : 21-04-2026   Author : SARVESH
