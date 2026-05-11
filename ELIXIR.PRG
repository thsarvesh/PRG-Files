*!*	BOF : Elixir.PRG (PHARMA Wholesale).....CREATED By PRITI SINGH    Dated    : 04/08/2020
*!* STATE : Kerla(29)
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
Close tables all
set talk off
set date to brit
set cent on
set dele on
set safe off
if type('FINALCP')='U'
datdev='D:\transfer\'
datext='DBF'
firstdate=ctod('01/04/2023')
lastdate=ctod('31/03/2024')
endi
datatransferext='DBF'
datatransferpath =substr('D:\DM\Mar\Elixer\New\dbf\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='29'
sure='SURE'
removenull='No '

Clear
Close tables all
@ 04,22 Say 'Piping Elixir(Wholesale) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 07,10 Say 'Elixir Data Path       :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 08,10 Say 'Elixir Extension       :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 09,10 Say 'F.Y.BEGIN Date         :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 10,10 Say 'F.Y.End   Date         :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 11,10 Say 'State Code             :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 12,10 Say 'Removenull             :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 13,10 Say 'Type SURE              :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18
read
Clear
Close tables all
datatransferpath=alltrim(datatransferpath)
*!*	If !Right(datatransferpath,1)='\'
*!*		datatransferpath=Alltrim(datatransferpath)+'\'
*!*	Endif
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
if lastkey() = 27 Or  Upper( sure ) # 'SURE'
	retu
endi
clea
if type('FINALCP')<>'U'
=starttransfer()        &&&&Comment it for run in VFP
endi
if removenull='Y'
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next                           
Endif
rowno=5

@ 02,22 Say 'Please Wait Importing Elixir(Wholesale) To Marg.....' Font 'Arial',14 Colo 'W+/G'

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
Close tables all
Set Colo To

@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\tblproduct alias fitm
	
sele sele(1) 
	use &datatransferpath\tblhsn alias ftax
	index on hsnid to ftax
	
sele sele(1) 
	use &datatransferpath\tblcompany alias fcomp
	index on comid to fcomp
	
sele sele(1) 
	use &datatransferpath\tblstock alias fstock
	index on prodid to fstock

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
   sele ftax
   seek fitm.hsn
   
   sele fcomp
   seek fitm.comid
   
   sele fstock
   seek fitm.prodid

   sele mitm
   append blank
   repl mitm.code with last
   repl mitm.name with alltrim(str(fitm.prodid))
   repl mitm.product with fitm.prodname
   repl mitm.pack with fitm.prodpack
   repl mitm.billname with fitm.prodname
   repl mitm.prate with fitm.purrate
   repl unit with 'PCS'
   repl mitm.ratea with fitm.selrate
   repl mitm.mrp with fitm.mrp
   repl mitm.gcode with alltrim(str(FITM.comid))
   repl mitm.gcode5 with alltrim(str(fcomp.comgrp_id))
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'N'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.purtax with ftax.gst/2
   repl mitm.saltax with ftax.gst/2
   repl mitm.cgst with ftax.gst/2
   repl mitm.igst with ftax.gst
   repl mitm.opening with fstock.balanceqty
   repl mitm.balance with fstock.balanceqty
   repl mitm.o_a with fstock.balanceqty
   repl mitm.b_a with fstock.balanceqty
   &&HSN
   sele mpcm
   set order to tag mpcm
   seek 'COMMCD' + substr(ftax.hsnname+space(15),1,15) + str(mitm.igst,5,2)
   if !found()
      append blank
      repl mpcm.sgcode with 'COMMCD',;
           mpcm.scode  with 'HH'+alltrim(str(last)),;
           mpcm.sname  with substr(ftax.hsnname+space(15),1,15)+ substr(ftax.hsnname,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
           mpcm.parnam with ftax.hsnname,;
           mpcm.tax with mitm.saltax,;
           mpcm.cgst with mitm.cgst,;
           mpcm.igst with mitm.igst,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode6 with mpcm.scode

endscan
close table all

@Rowno,22 say 'Importing Batch .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
  use &datatransferpath\tblstore alias fsbal 
sele sele(1)
  use &datdev\pro.&datext alias mitm 
  index on name to MITM
sele sele(1)
  use &datdev\probat.&datext alias msbal 
  index on name +subs(batchno,1,12) TO msbal 
sele sele(1)
  use &datdev\support.&datext alias support  
sele fsbal
scan
   sele mitm
   seek alltrim(str(fsbal.prodid))
   sele msbal
   seek alltrim(str(fsbal.prodid))+subs(fsbal.store_batch,1,12) 
   if !found() 
      appen blank 
      repl code with mitm.code  
      repl name with mitm.name
      repl product with mitm.product 
      repl billname with mitm.billname
      repl packing with mitm.packing
      repl pack with mitm.pack 
      repl unit with mitm.unit
      repl batchno with subs(fsbal.store_batch,1,12) 
      repl exp with fsbal.STORE_EXPDATE
      repl supcode with alltrim(str(fsbal.persid))
      repl supinvo with alltrim(str(fsbal.store_purslno))
      repl supdat with ctod(fsbal.store_purdate)
      repl mrp with fsbal.STORE_MRP
      repl ratea with fsbal.STORE_SELLRATE
      repl prate with fsbal.STORE_PURRATE 
      repl opening with fsbal.STORE_BALQTY
      repl balance with FSBAL.STORE_BALQTY
      repl o_a with FSBAL.STORE_BALQTY 
      repl b_A with FSBAL.STORE_BALQTY 
            
 else
 repl opening with opening+FSBAL.STORE_BALQTY 
 repl balance with balance+FSBAL.STORE_BALQTY 
 repl o_a with o_A+FSBAL.STORE_BALQTY 
 repl b_A with b_a+FSBAL.STORE_BALQTY 
endif 
endscan          
close data 


@Rowno,22 say 'Importing Company .....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
	use &datatransferpath\tblcompany alias fcomp
sele sele(1)
	use &datdev\saletype.&datext alias mcomp
	index on sgcode + parnam to  mcomp
sele fcomp
go top
scan
   sele mcomp
   seek 'ZZZZZZ' + substr(fcomp.comname+space(40),1,40)
   if !found()
      append blank
      repl mcomp.sgcode with 'ZZZZZZ',;
           mcomp.scode  with alltrim(str(fcomp.comid)),;
           mcomp.sname  with fcomp.comname,;
           mcomp.parnam with fcomp.comname,;
           mcomp.tcode with 'No'
   endif
endscan
close table all



@rowno,22 say 'Importing Category .....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
	use &datatransferpath\tblcomgrp alias fcat
sele sele(1)
	use &datdev\saletype.&datext alias mcat
	index on sgcode + parnam to  mcat
sele fcat
go top
scan
   sele mcat
   seek 'CATEGO' + substr(fcat.comgrp_name+space(40),1,40)
   if !found()
      append blank
      repl mcat.sgcode with 'CATEGO',;
           mcat.scode  with alltrim(str(fcat.comgrp_id)),;
           mcat.sname  with fcat.comgrp_name,;
           mcat.parnam with fcat.comgrp_name,;
           mcat.tcode with 'No'
   endif
endscan
close table all

@Rowno,22 say 'Importing Salesman .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
	use &datatransferpath\tblsalesexecutive alias fact

sele sele(1)
	use &datdev\order.&datext alias mact 

sele fact
go top
scan
	
	sele mact
   	append blank
   
   	repl mact.rate with 'Y' 
   	repl mact.scode with 'D32'  	
   	repl mact.ordno with 'S'+alltrim(str(fact.SALESEXEID))
   	repl mact.parnam  with fact.SALESEXENAME
   	repl mact.paradd with fact.SALESEXEADDR1
   	repl mact.paradd1 with fact.SALESEXEADDR2
   	REPL MACT.PARADD2 WITH FACT.SALESEXEADDR3
   	repl mact.sthed with  'TIN No.'
  	repl mact.gsthed with  'GST No.'
  	repl mact.csthed with 'CST  No.'
   	repl mact.mailNam with fact.SALESEXENAME
   	repl mact.ref with 'Mr.'  	
   	repl mact.price with 'A'
   	repl mact.status with 'Y' 
   	repl mact.phone1 with fact.SALESEXEPHONE
   	repl mact.phone2 with fact.SALESEXEMOBILE
   	
SELE FACT
endscan
close tables all


@Rowno,22 say 'Importing Area .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
  use &datatransferpath\tblarea  alias farea  
sele sele(1)
  use &datdev\saletype.&datext alias stype  
sele farea
scan
 sele stype
 appen blank
 repl sgcode with 'AREA'
 repl scode with alltrim(str(farea.areaid))
 repl parnam with alltrim(farea.areaname)
 repl sname with alltrim(farea.areaname)
endscan
CLOSE TABLES ALL   

@Rowno,22 say 'Importing Route .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
  use &datatransferpath\tblroute  alias farea  
sele sele(1)
  use &datdev\saletype.&datext alias stype  
sele farea
scan
 sele stype
 appen blank
 repl sgcode with 'ROUT'
 repl scode with alltrim(str(farea.ROUTE_ID))
 repl parnam with alltrim(farea.ROUTE_NAME)
 repl sname with alltrim(farea.ROUTE_NAME)
endscan
CLOSE TABLES ALL   
    
   	

@Rowno,22 say 'Importing Ledger .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
	use &datatransferpath\tblpersons alias fact
sele sele(1)
	use &datatransferpath\TBLROUTECUSTOMER alias FROUT
	INDEX ON PERSID TO FROUT
sele sele(1)
	use &datatransferpath\tblaccounthead alias fbal
	index on persid to fact

sele sele(1)
	use &datdev\order.&datext alias mact 
Sele sele(1)
	Use &datdev\support.&datext Alias tsupp
	Index On aliase + Str(sno,3) + lcode To tsupp
sele fact
go top
scan   
    sele frout
    seek fact.persid
	sele fbal
	seek fact.persid
	sele mact
   	appe blan
   	if fact.perscustorsupp='S'
   	replace mact.scode with 'D31'
   	ELSE
   	   	replace mact.scode with 'C6'
   	ENDIF
   	repl mact.rate with 'Y'   	
   	repl mact.ordno with alltrim(str(fBAL.AC_id))
   	repl mact.parnam  with fact.persname
   	repl mact.city with fact.persaddr1
   	repl mact.paradd with fact.persaddr1
   	repl mact.paradd1 with fact.persaddr2
   	repl mact.paradd1 with fact.persaddr3
   	repl mact.sthed with  'TIN No.'
  	repl mact.gsthed with  'GST No.'
  	repl mact.csthed with 'CST  No.'
   	repl mact.mailNam with fact.persname
   	repl mact.gstno with fact.perslicenceno1
   	repl mact.dlno with alltrim(fact.perslicenceno2)+" "+alltrim(fact.perslicenceno3)
   	repl mact.area with alltrim(str(fact.areaid))
   	REPL MACT.ROUT WITH ALLTRIM(STR(FROUT.ROUTE_ID))
   	repl mact.ref with 'Mr.'  	
   	repl mact.price with 'A'
   	repl mact.status with 'Y' 
   	repl mact.phone1 with fact.persphone
   	repl mact.phone2 with fact.persmobile
   	repl MACT.GSTNO WITH FACT.perslicenceno1
   	repl opning with iif(scode='D31',-abs(abs(fbal->ac_obalance)-fbal->ac_adjamount),abs(abs(fbal->ac_obalance)-fbal->ac_adjamount))
	** Updating State
	Sele tsupp
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.GSTNO,1,2)='  ',MSTATECODE,Subs(mact.GSTNO,1,2))+'                                           '  	
endsc
close tables all

@Rowno,22 say 'Importing Outstanding .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\tblBillAdjustment alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
	go top
scan 
	mvcn=alltr(str(fout.sbill_slno))
	sele mord
	seek substr(alltri(str(fout.ac_id))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.sbill_billdate
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->sbill_amount),abs(fout->sbill_amount))
	repl itemope with iif(acgroup='D31',-abs(fout->receiveamt),abs(fout->receiveamt))
	repl balance with iif(acgroup='D31',-abs(abs(final)-abs(itemope)),abs(final-itemope))
	repl name with mvcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

@Rowno,22 say 'Importing Ledger Balance .....' font 'Courier',14 
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
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T","M")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

&&EOF : Elixirh.PRG .....Author Priti Singh
