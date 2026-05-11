*!*	BOF : soft trend.PRG (PHARMA RETAIL).....CREATED By Sarvesh Thakur     Dated    : 01-04-2024
clear
set cpdialog off
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
if type('FINALCP')='U'
	firstdate=ctod('01/04/2021')  		&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2022')  		&& Un-Comment this for run from VFP
	datdev='D:\transfer'   && Un-Comment this for run from VFP
	datext='dbf'						&& Un-Comment this for run from VFP
endif
datatransferext='DBF'
datatransferpath =substr('D:\DM\Mar\Softtrend\957A848E\SOFTREND\20182100.1\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='33'
sure='SURE'
removenull='No '

Clear
Close Data
@ 02,22 Say 'Piping soft trend (PHARMA) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 to 21,115 doub
@ 06,10 Say 'SOFT trend Data Path :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 07,10 Say 'SOFT trend Extension :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 09,10 Say 'F.Y.BEGIN Date       :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 10,10 Say 'F.Y.End   Date       :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 11,10 Say 'State Code           :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 12,10 Say 'Removenull           :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 13,10 Say 'Type SURE            :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18

Read
Clear
Close Data
datatransferpath=alltrim(datatransferpath)
datatransferpath=Alltrim(datatransferpath)
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
if type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
endif
if removenull='Y'
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	@ 02,22 Say 'Please wait removing null values'
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next                           
Endif
clear
rowno=5
@ 02,22 Say 'Please Wait Importing soft trend (PHARMA) To Marg.....' Font 'Arial',14 Colo 'W+/G'
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
close table all
@Rowno,22 say 'Importing Product_Master .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\itemas alias fitm
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + sname + str(igst,5,2) to mpcm 
sele fitm
go top
scan
   @rowno-1,80 say str(recno(),10)   font 'Arial',12
   last=recno()
   sele mitm
   append blank
   repl mitm.code with last
   repl mitm.name with alltri(fitm.itec)
   repl mitm.product with upper(fitm.name)
   repl mitm.packing with fitm.nature
   repl mitm.unit with 'Pcs'
   repl mitm.pack with 0
   repl mitm.billname with mitm.product+' '+mitm.packing
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.rackno with fitm.barcode
   repl mitm.purtax with fitm.tax/2
   repl mitm.saltax with fitm.tax/2
   repl mitm.cgst with fitm.tax/2
   repl mitm.igst with fitm.tax
   &&HSN
   sele mpcm
   seek 'COMMCD' + substr(fitm.hsncode+space(40),1,40) + str(mitm.igst,5,2)
   if !found()
      append blank
      repl mpcm.sgcode with 'COMMCD',;
           mpcm.scode  with 'HH'+alltrim(str(last)),;
           mpcm.sname  with fitm.hsncode,;
           mpcm.parnam with fitm.hsncode,;
           mpcm.tax with mitm.saltax,;
           mpcm.cgst with mitm.cgst,;
           mpcm.igst with mitm.igst,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode6 with mpcm.scode
   &&COMPANY
   sele mpcm
   seek 'ZZZZZZ' + substr(fitm.company+space(40),1,40)
   if !found()
      append blank
      repl mpcm.sgcode with 'ZZZZZZ',;
           mpcm.scode  with 'CO'+alltrim(str(last)),;
           mpcm.parnam with fitm.company,;
           mpcm.sname with fitm.company,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode with mpcm.scode
   &&SALT
   sele mpcm
   seek 'SALT  ' + substr(fitm.combinat+space(40),1,40)
   if !found()
      append blank
      repl mpcm.sgcode with 'SALT  ',;
           mpcm.scode  with 'CO'+alltrim(str(last)),;
           mpcm.parnam with fitm.combinat,;
           mpcm.sname with fitm.combinat,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode3 with mpcm.scode

   &&Ccategory
   sele mpcm
   seek 'CATEGO' + substr(fitm.category+space(40),1,40)
   if !found()
      append blank
      repl mpcm.sgcode with 'CATEGO',;
           mpcm.scode  with 'CA'+alltrim(str(last)),;
           mpcm.parnam with fitm.category,;
           mpcm.sname with fitm.category,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode5 with mpcm.scode

endscan
close table all

@Rowno,22 say 'Importing Batch_Master.....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\stkmas alias fsbal
sele sele(1)
	use &datdev\probat.&datext alias msbal
	index on name + batchno to msbal
sele sele(1)
	use &datdev\pro.&datext alias mitm
	index on name to mitm
sele sele(1)
	use &datdev\support.&datext
  	dele all for type='#' and aliase='DAT/F-BT'
 	pack
r=0
sele fsbal
go top
scan
   @rowno-1,80 say str(recno(),10)   font 'Arial',12
   sele mitm
   seek substr(fsbal.itec,1,10)
   sele msbal
   seek substr(fsbal.itec,1,10) + substr(fsbal.batch,1,12)
   if !found()   
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.packing with mitm.packing
      repl msbal.decimal with 'Y'
      repl msbal.batchno with fsbal.batch
      repl msbal.exp with ctod('01/'+substr(fsbal.expiry,1,2)+'/'+substr(fsbal.expiry,3,4))
      repl msbal.prate with fsbal.pprice
      repl msbal.lprate with fsbal.purcost
      repl msbal.mycode with fsbal.barcode
      repl msbal.ratea with fsbal.sprice
      repl msbal.mrp with fsbal.mrp
      repl msbal.supcode with alltri(fsbal.cusc)
      repl msbal.supinvo with alltri(fsbal.invoice)
      repl msbal.supdat with fsbal.pdate
      repl msbal.misc1 with mitm.gcode
      repl msbal.opening with fsbal.qty
      repl msbal.balance with fsbal.qty
      repl msbal.o_a with fsbal.qty
      repl msbal.b_a with fsbal.qty
    else
      repl msbal.opening with msbal.opening + fsbal.qty,;
           msbal.balance with msbal.balance + fsbal.qty,;
           msbal.o_a with msbal.o_a + fsbal.qty,;
           msbal.b_a with msbal.b_a + fsbal.qty
    endif
endscan
close table all
@Rowno,22 say 'Importing Ledger_Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\cusmas alias fact
sele sele(1)
	use &datdev\order.&datext alias mact 
Sele sele(1)
	Use &datdev\support.&datext Alias tsupp
	Index On aliase + Str(sno,3) + lcode To tsupp
sele fact
go top
scan
   @rowno-1,80 say str(recno(),10)   font 'Arial',12
	last=recno()
	sele mact
   	append blank
   	if fact.grpname='SUNDRY CREDITORS   '
	repl mact.scode with 'D31'
	else
		if fact.grpname='SUNDRY DEBTORS-SHOP ' or fact.grpname='SUNDRY DEBTORS  ' or fact.grpname='SUNDRY DEBTORS-DISTRIBUTO   ' or fact.grpname='SUNDRY DEBTORS-DISTRIBUTOR  '
		repl mact.scode with 'C6'
	else 
	repl mact.scode with 'J12'
		endif
	endif
   	repl mact.rate with 'Y'   	
   	repl mact.ordno with alltri(fact.cuscod)
   	repl mact.parnam  with fact.cusnam
   	repl mact.paradd with fact.adrone
   	repl mact.paradd1 with fact.adrtwo
   	repl mact.paradd2 with fact.adrthr
   	repl mact.city with fact.zname
   	repl mact.sthed with 'TIN No.'
  	repl mact.gsthed with 'GST No.'
  	repl mact.csthed with 'CST  No.'
  	repl mact.gstno with fact.tin
  	repl dlno with alltri(fact.dlno1)+' '+alltri(fact.dlno2)
   	repl mact.mailNam with fact.cusnam
   	repl mact.ref with 'Mr.'  	
   	repl mact.price with 'A'
   	repl mact.status with 'Y' 
	repl mact.phone1 with fact.phone
*	repl mact.opning with iif(mact.scode='D31',fact.c_bal,fact.c_bal)
	&& Updating State
	Sele tsupp
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	repl remark with subs(remark,1,32)+"DEF"+iif(substr(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+substr(remark,42)
endscan
close tables all
*!*	@Rowno,22 say 'Importing Outstanding .....' font 'Courier',14 
*!*	rowno=rowno+1
*!*	sele sele(1)
*!*	use &datdev\pendings.&datext alias mpend
*!*	sele sele(1)
*!*	use &datdev\order.&datext alias mord
*!*	inde on ordno to mord
*!*	sele sele(1)
*!*	use &datdev\slipno.&datext alias mslip
*!*	sele sele(1)
*!*	use &datatransferpath\public_outstandings alias fout
*!*	sele mslip 
*!*	go top
*!*	vou =voucher  + 10
*!*	svou=svoucher + 10
*!*	sele fout
*!*	go top
*!*	scan
*!*	   sele mord
*!*	   seek padr(fout->party_act,6)
*!*	   sele mpend
*!*	   appen blan
*!*	   repl acgroup with mord->scode
*!*	   repl ord with padr(fout->party_act,6)
*!*	   repl ddate with fout->bill_dt
*!*	   repl vcn with fout->bill_no
*!*	   repl invtype with 'O'
*!*	   repl voucher  with vou
*!*	   repl svoucher with svou
*!*	   repl final with iif(acgroup='D31',-abs(fout->bal_due),abs(fout->bal_due))
*!*	   repl balance with iif(acgroup='D31',-abs(fout->bal_due),abs(fout->bal_due))
*!*	   repl itemope with final-balance
*!*	   repl name with vcn
*!*	   vou=vou+5
*!*	   svou=svou+5
*!*	endsc
*!*	sele mslip 
*!*	repl voucher  with vou+5
*!*	repl svoucher with svou+5
*!*	close table all

proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T","M")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor
*!*	EOF : soft trend.PRG (PHARMA RETAIL).....CREATED By Sarvesh Thakur     Dated    : 01-04-2024
