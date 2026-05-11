*!*	BOF : || PharmaEasy || Dated : 27/02/2026 || Author : SARVESH || State :Maharashtra||
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
datatransferpath=substr('D:\MIGRATION_DATA\MAR\PHARMA_EASY\dbf\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_6 = lastdate
old_7 = '2'
old_8 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='27'
removenull = 'NO'
@13,10 say 'Pharma Easy Data Path   :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'Pharma Easy Extension   :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing Pharma Easy Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datatransferpath\masterproduct alias fitm
sele sele(1)
use &datatransferpath\mastercompany alias fcomp
index on compid tag indcomp
sele sele(1)
use &datatransferpath\mastergenericcategory alias fdrug
index on genericcategoryid tag inddrug
sele sele(1)
use &datatransferpath\masterproductcategory alias catmst
index on productcategoryid tag Indcat
sele sele(1)
use &datatransferpath\mastershelf alias frk
index on shelfid tag indrk
sele sele(1)
use &datatransferpath\taxmaster alias ftax
index on taxid tag indtax

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
	repl name with alltri(str(recno()))
	repl product with fitm.prodname
	repl packing with fitm.prodpack
	repl billname with fitm.prodname
	repl pack with fitm.prodloosepack
	repl rackno with frk.shelfcode
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with fitm.prodminlevel
	repl mitm.maximum with fitm.prodmaxlevel
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.gcode with fitm.prodcompid,;
		 mitm.gcode5 with fitm.prodcategoryid
	if seek(fitm.prodshelfid,'frk','indrk')
		repl mitm.rackno with frk.shelfcode
	endif
	repl mitm.mrp with fitm.prodlastpurchasemrp
	repl mitm.ratea with fitm.prodlastpurchasesalerate
	repl mitm.lprate with fitm.prodlastpurchasetraderate
	repl mitm.prate with fitm.prodlastpurchasetraderate
	if seek(fitm.taxid,'ftax','indtax')
		repl saltax with ftax.percentage/2
		repl cgst   with ftax.percentage/2
		repl igst   with ftax.percentage
	endif
	mhsn=fitm.hsncode
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
*--Company Master Import
	if seek(fitm.prodcompid,'fcomp','indcomp')
		sele mpcm
		seek 'ZZZZZZ' + substr(fcomp.compname+space(40),1,40)
		if !found()
			append blank
			repl mpcm.sgcode with 'ZZZZZZ',;
				mpcm.scode  with 'C'+alltrim(str(recno())),;
				mpcm.sname  with fcomp.compname,;
				mpcm.parnam with fcomp.compname,;
				mpcm.tcode with 'No'
		endif
		sele mitm
		repl mitm.gcode with mpcm.scode
	endif
*--Salt Master Import
	if seek(fitm.proddrugid,'fdrug','inddrug')
		sele mpcm
		seek 'SALT  '+ substr(fdrug.genericcategoryname+space(40),1,40)
		if !found()
			append blank
			repl mpcm.sgcode with 'SALT  ',;
				mpcm.scode  with 'S'+alltrim(str(recno())),;
				mpcm.sname  with fdrug.genericcategoryname,;
				mpcm.parnam with fdrug.genericcategoryname,;
				mpcm.tcode with 'No'
		endif
		sele mitm
		repl mitm.gcode3 with mpcm.scode
		repl mitm.formulano with substr(mpcm.parnam,1,15)
	endif
*--Category Master Import
	if seek(fitm.prodcategoryid,'catmst','Indcat')
		sele mpcm
		seek 'CATEGO' + substr(catmst.productcategoryname+space(40),1,40)
		if !found()
			append blank
			repl mpcm.sgcode with 'CATEGO',;
				mpcm.scode  with 'S'+alltrim(str(recno())),;
				mpcm.sname  with catmst.productcategoryname,;
				mpcm.parnam with catmst.productcategoryname,;
				mpcm.tcode with 'No'
		endif
		sele mitm
		repl mitm.gcode5 with mpcm.scode
	endif
endscan
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\masteraccount alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
		do case
			case inlist(fact.accgroupid,'28')
				mscode='C6'
			case inlist(fact.accgroupid,'31')
				mscode='D31'
			case inlist(fact.accgroupid,'38')
				mscode='C1'
			case inlist(fact.accgroupid,'44')
				mscode='J11'
			case inlist(fact.accgroupid,'45')
				mscode='J12'
			otherwise
				mscode='J12'
		endcase
	repl mact.scode with mscode
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(recno()))
	repl mact.fax2 with fact.accountcode
	repl mact.parnam  with fact.accname
	repl mact.mailnam with fact.accname
	repl mact.paradd with fact.accaddress1
	repl mact.paradd1 with fact.accaddress2
	repl mact.confir with fact.acccontactperson
	repl phone1 with fact.mobilenumberforsms
	repl phone2 with fact.acctelephone
	repl phone4 with fact.mobilenumberforsms
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.stno with fact.accvattinnumber
	repl mact.dlno with fact.accdln
	repl mact.itno with fact.accpan
	repl mact.gstno with fact.accgst
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	repl mact.opning with fact.accclosingdebit-fact.accclosingcredit
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
	&& Email ID UPDATE
    Sele support
    Append Blank
    Repl aliase With 'ORDER   ',;
        type With 'F',;
        lcode With mact.ordno,;
        sno With 12,;
        remark With fact->accemailid,;
        heading With Substr(Heading,1,21)+Iif(Empty(mact->gstno),'UG','NG')
endscan
close tables all

@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\tblstock alias fsbal
sele sele(1)
use &datatransferpath\masterproduct alias fitm
index on productid tag indfitm
sele sele(1)
use &datatransferpath\masteraccount alias fact
index on accountid tag Indfact

sele sele(1)
use &datdev\malter.&datext  alias altr 
dele all
pack 
index on code+batch+substr(name,1,20) to altr
sele sele(1)
use &datdev\order.&datext alias mact
index on parnam to fact

sele sele(1)
use &datdev\pro.&datext alias mitm
index on billname to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on billname+batchno to msbal
sele fsbal
go top
scan
	=seek(fsbal.productid,'fitm','indfitm')
	=seek(fsbal.lastpurchaseaccountid,'fact','Indfact')
	=seek(substr(fact.accname+space(45),1,45),'mact')
	sele mitm
	seek substr(fitm.prodname+space(45),1,45)
	sele msbal
	seek substr(fitm.prodname+space(45),1,45)+substr(fsbal.batchnumber+space(12),1,12)
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
			msbal.opening with fsbal.closingstock,;
			msbal.balance with fsbal.closingstock,;
			msbal.o_a with fsbal.closingstock,;
			msbal.b_a with fsbal.closingstock,;
			msbal.batchno with fsbal.batchnumber
		    repl msbal.exp with ctod('01/'+substr(fsbal.expiry,1,3)+'20'+substr(fsbal.expiry,4,2)),;
			msbal.mrp with fsbal.mrp,;
			msbal.prate with fsbal.purchaserate,;
			msbal.ratea with fsbal.salerate,;
			msbal.lprate with fsbal.traderate/iif(mitm.pack#0,mitm.pack,1),;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with mact.ordno
	   repl msbal.supinvo with fsbal.lastpurchasebillnumber
	   repl msbal.supdat with ctod(substr(fsbal.lastpurchasedate,7,2)+'/'+substr(fsbal.lastpurchasedate,5,2)+'/'+substr(fsbal.lastpurchasedate,1,4))
	   repl msbal.date with ctod(substr(fsbal.lastpurchasedate,7,2)+'/'+substr(fsbal.lastpurchasedate,5,2)+'/'+substr(fsbal.lastpurchasedate,1,4))
	else
		repl msbal.opening with msbal.opening + fsbal.closingstock,;
			msbal.balance with msbal.balance + fsbal.closingstock,;
			msbal.o_a with msbal.o_a + fsbal.closingstock
	   repl msbal.supinvo with fsbal.lastpurchasebillnumber
	   repl msbal.date with ctod(substr(fsbal.lastpurchasedate,7,2)+'/'+substr(fsbal.lastpurchasedate,5,2)+'/'+substr(fsbal.lastpurchasedate,1,4))
	   repl msbal.supdat with ctod(substr(fsbal.lastpurchasedate,7,2)+'/'+substr(fsbal.lastpurchasedate,5,2)+'/'+substr(fsbal.lastpurchasedate,1,4))
	   repl msbal.b_a with msbal.b_a + fsbal.closingstock
	   repl	msbal.supcode with mact.ordno
	endif
endscan
close table all
@rowno,10 say '**** Importing Doctor Master****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\masterdoctor.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PRE#$~'
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PRE#$~',;
		mdoc.ordno with alltrim(str(recno())),;
		mdoc.parnam with fdoc.docname,;
		mdoc.city with upper(fdoc.docaddress),;
		mdoc.form with alltrim(str(recno()))
endsc
close data all
@rowno,10 say '**** Importing Patient Master  ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\masterpatient.dbf alias fdoc
sele sele (1)
use &datdev\maorder.&datext alias mdoc
delete all for scode='PET#$~'
sele fdoc
go top
scan
	sele mdoc
	append blank
	repl mdoc.scode with 'PET#$~',;
		mdoc.ordno with alltrim(str(recno())),;
		mdoc.parnam with fdoc.patientname,;
		mdoc.city with upper(fdoc.patientaddress1),;
		mdoc.form with alltrim(str(recno()))
endsc
close data all
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
*!*	EOF : || PharmaEasy || Dated : 27/02/2026 || Author : SARVESH || State :Maharashtra||
