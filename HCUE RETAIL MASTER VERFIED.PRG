*!*	BOF : HCUE.PRG (PHARMA RETAIL).....CREATED By JEEVAN PREET SAINI     Dated    : 22/05/2019
*!* STATE : Tamilnadu (33)
clear
set cpdialog off
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
IF TYPE ('FINALCP')='U'
	firstdate=ctod('01/04/2025')  		&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')  		&& Un-Comment this for run from VFP
	datdev=substr('d:\TRANSFER\'+space(70),1,70)     && Un-Comment this for run from VFP
	datext='dbf'
ENDIF
datatransferpath =substr('D:\MIGRATION_DATA\MAR\HCUE\DBF_FILES\'+space(70),1,70)
datatransferext='dbf'
old_2 = '04'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='33'
sure='SURE'
removenull='No '
Clear
Close Data
@ 02,22 Say 'Please Wait Importing Hcue Pharmacy(Retail) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 to 21,140 doub
@ 06,10 Say 'HCUE Data Path       :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 07,10 Say 'HCUE Extension       :' Font 'Courier',18  Get datatransferext  Font 'courier',18
*@ 08,10 Say 'TRANSFER Data Path   :' Font 'Courier',18  Get datdev  Font 'courier',18
@ 09,10 Say 'F.Y.BEGIN Date       :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 10,10 Say 'F.Y.End   Date       :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 11,10 Say 'State Code           :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 12,10 Say 'Removenull           :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 13,10 Say 'Type SURE            :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18

Read
Clear
Close Data
datatransferpath=alltrim(datatransferpath)
if removenull='Y'
	clear
	@05,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif
datatransferpath=Alltrim(datatransferpath)
*!*	If !Right(datatransferpath,1)='\'
*!*		datatransferpath=Alltrim(datatransferpath)+'\'
*!*	Endif
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
CLEAR
IF TYPE ('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
ENDIF
rowno=5

@ 02,22 Say 'Please Wait Importing Hcue Pharmacy(Retail) To Marg.....' Font 'Arial',14 Colo 'W+/G'

Set Colo To
Sele Sele(1)
Use &datdev\glmonth.&datext
Zap
Use &datdev\ggmonth.&datext
Zap
Use &datdev\pro.&datext
Zap
Use &datdev\Order.&datext
Zap
Use &datdev\saletype.&datext
Zap
Use &datdev\gledger.&datext
Zap
Use &datdev\pendings.&datext
Zap
Use &datdev\pend.&datext
Zap
Use &datdev\probat.&datext
Zap
Use &datdev\maorder.&datext
Zap
Use &datdev\sborder.&datext
Zap
Use &datdev\mdis.&datext
Zap
Use &datdev\dis.&datext
Zap
Use &datdev\glmonth.&datext
Zap
Use &datdev\ggmonth.&datext
Zap
Use &datdev\Support.&datext
Dele All For Type='#' And aliase='DAT/F'
Pack
Close Data
Set Colo To

@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\product alias fitm
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + parnam + str(igst,5,2) tag  mpcm
	index on sgcode + sname tag mpcm1

sele fitm
go top
scan
   last=recno()
   sele mitm
   append blank
   repl mitm.code with last
   repl mitm.name with substr(fitm.id,1,6)
   repl mitm.product with fitm.name
   repl mitm.packing with fitm.packing	
   repl mitm.billname with fitm.name
   repl mitm.pack with fitm.packagesize
   repl rackno with fitm.rackno
   repl fixdis with fitm.discount
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.saltax with fitm.sgst
   repl mitm.cgst with fitm.cgst
   repl mitm.igst with fitm.igst
   do case
   		case fitm.schedule='H'
   			repl mitm.gcode4 with '  N#       N     NNM'
   		case fitm.schedule='H1'
   			repl mitm.gcode4 with '  NN       #     NNM'
   endcase
   &&HSN
   sele mpcm
   set order to tag mpcm
   seek 'COMMCD' + substr(fitm.hsncode+space(15),1,15) + str(mitm.igst,5,2)
   if !found()
      append blank
      repl mpcm.sgcode with 'COMMCD',;
           mpcm.scode  with 'H'+alltrim(str(last)),;
           mpcm.sname  with substr(fitm.hsncode+space(15),1,15)+ substr(fitm.hsncode,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
           mpcm.parnam with fitm.hsncode,;
           mpcm.tax with mitm.saltax,;
           mpcm.cgst with mitm.cgst,;
           mpcm.igst with mitm.igst,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode6 with mpcm.scode
   &&COMPANY
   sele mpcm
   set order to tag mpcm1
   seek 'ZZZZZZ' + substr(fitm.manufacturer+space(40),1,40)
   if !found()
      append blank
      repl mpcm.sgcode with 'ZZZZZZ',;
           mpcm.scode  with 'C'+alltrim(str(last)),;
           mpcm.sname  with fitm.manufacturer,;
           mpcm.parnam with fitm.manufacturer,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode with mpcm.scode
   
    &&SALT
   sele mpcm
   set order to tag mpcm1		
   seek 'SALT  ' + substr(fitm.genericname+space(40),1,40)
   if !found()
      append blank
      repl mpcm.sgcode with 'SALT  ',;
           mpcm.scode  with 'S'+alltrim(str(last)),;
           mpcm.sname  with fitm.genericname,;
           mpcm.parnam with fitm.genericname,;
           mpcm.tname with fitm.genericname,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode3 with mpcm.scode  
endscan
close table all
@Rowno,22 say 'Importing Batch .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\productstock alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name + batchno to msbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele fsbal
go top
scan
   sele mitm
   seek substr(fsbal.productid,1,6)
   sele msbal
   seek substr(fsbal.productid,1,6) + fsbal.batchno
   if !found()   
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.pack with fsbal.packagesize
      repl mitm.pack with fsbal.packagesize
      repl msbal.unit2 with mitm.unit2
      repl msbal.unit with mitm.unit
      repl msbal.exp with ctod(substr(fsbal.expiredate,9,2)+'/'+substr(fsbal.expiredate,6,2)+'/'+substr(fsbal.expiredate,1,4))
      repl msbal.decimal with 'Y'
      repl msbal.batchno with fsbal.batchno
      repl msbal.lprate with fsbal.purchaseprice
      repl msbal.prate with fsbal.packagepurchaseprice
      repl msbal.mrp with fsbal.mrp*iif(mitm.pack#0,mitm.pack,1)
      repl msbal.ratea with fsbal.sellingprice*iif(mitm.pack#0,mitm.pack,1)
      repl msbal.misc1 with mitm.gcode
      repl msbal.opening with fsbal.stock
      repl msbal.balance with fsbal.stock
      repl msbal.o_a with fsbal.stock
      repl msbal.b_a with fsbal.stock
    else
      repl msbal.opening with msbal.opening + fsbal.stock,;
           msbal.balance with msbal.balance + fsbal.stock,;
           msbal.o_a with msbal.o_a + fsbal.stock,;
           msbal.b_a with msbal.b_a + fsbal.stock     
    endif
endscan
close table all
@Rowno,22 say 'Importing Doctors  .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\doctor alias fdoc
sele sele(1)
	use &datdev\maorder.&datext alias mdoc
sele fdoc
go top
scan
   sele mdoc
   append blank
   repl scode with 'PRE#$~'
   repl mdoc.ordno with substr(fdoc.id,10,4)
   repl mdoc.parnam  with fdoc.name
   repl mdoc.city with fdoc.city
   repl mdoc.form with substr(fdoc.id,10,4)     
endscan
close table all
@Rowno,22 say 'Importing PATIENT  .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\patient alias fpat
sele sele(1)
	use &datdev\maorder.&datext alias mpat
sele fpat
go top
scan
	sele mpat
	append blank
	repl scode with "PET#$~"
	repl mpat.ordno with substr(fpat.id,10,4)
	repl mpat.parnam with fpat.name 
	repl mpat.city with fpat.city
	repl mpat.form with substr(fpat.id,10,4)
endscan
close table all
@Rowno,22 say 'Importing ACCOUNTS LEDGER .....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
use &datatransferpath\vendor alias fact
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
	repl mact.scode with 'D31'
   	repl mact.rate with 'Y'
   	repl mact.ordno with substr(fact.id,10,4)
   	repl mact.parnam  with fact.name
   	repl mact.paradd with fact.address
   	repl mact.dsm with fact.pincode
   	repl mact.sthed with  'TIN No.'
   	repl mact.csthed with 'CST  No.'
   	repl mact.gsthed with 'GST No.'
   	repl mact.stno With fact.tinno
   	repl mact.gstno with fact.gstinno
   	repl mact.dlno with alltrim(fact.druglicenseno)
   	repl mact.mailNam with fact.name
   	repl mact.ref with 'Mr.'
   	repl mact.price with 'A'
   	repl mact.confir with fact.contactperson
   	repl mact.desi with fact.designation
    repl mact.city with fact.city
   	repl mact.status with 'Y'
    repl mact.area with fact.area
   	repl mact.adhed with 'Discount'
   	repl mact.phone1 with fact.mobile
   	repl mact.phone2 with fact.phone
   	repl mact.phone3 with fact.mobile1
   	repl mact.phone4 with fact.mobile2
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
close table all
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
use &datatransferpath\vendorpurchase alias fout

sele sele(1)
use &datatransferpath\payment alias fpay
index on vendorid+vendorpurchaseid to fpay

sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan for paymenttype='Credit '
	mvcn=alltri(fout.invoiceno)
	mdate=ctod(substr(invoicedate,9,2)+'/'+substr(invoicedate,6,2)+'/'+substr(invoicedate,1,4))
	vendorid=substr(fout.vendorid,10,4)
	sele fpay
	seek fout.vendorid+fout.id
	sum debit to trec while vendorid+vendorpurchaseid=fout.vendorid+fout.id
	sele mord
	seek substr(vendorid+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with mdate
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->netvalue),abs(fout->netvalue))
	repl itemope with iif(acgroup='D31',-abs(trec),abs(trec))
	repl balance with iif(acgroup='D31',-abs(fout.netvalue-trec),abs(fout.netvalue-trec))
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
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","M","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T","M")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

&&EOF : HCUE.PRG .....Author JEEVAN PREET SAINI
