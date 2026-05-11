*!*	BOF : POS.PRG (Supermarket).....CREATED By Salman     Dated    : 18/06/2020
*!* STATE : Supermarket(34)
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
if type('FINALCP')='U'
	firstdate=ctod('01/04/2021')  		&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2022')  		&& Un-Comment this for run from VFP
	datdev='D:\TRANSFER\'   && Un-Comment this for run from VFP
	datext='dbf'						&& Un-Comment this for run from VFP
ENDIF

datatransferext='DBF'
datatransferpath =substr('D:\july\POSBEAN\data\dbf\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='34'
sure='SURE'
removenull='No '

Clear
Close Data
@ 02,22 Say 'Piping POS(Supermarket) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 to 21,115 doub
@ 06,10 Say 'POS Data Path        :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 07,10 Say 'POS Extension        :' Font 'Courier',18  Get datatransferext  Font 'courier',18
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
*!*	If !Right(datatransferpath,1)='\'
*!*		datatransferpath=Alltrim(datatransferpath)+'\'
*!*	Endif
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
if type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
ENDIF
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

@ 02,22 Say 'Please Wait Importing pos To Marg.....' Font 'Arial',14 Colo 'W+/G'

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

@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\m_materialname alias fitm
	
sele sele(1) 
	use &datatransferpath\materialmaster alias fcod
	index on mn_id to fcod
sele sele(1) 
	use &datatransferpath\Material_Transaction alias ftax
	index on m_id to ftax

sele sele(1) 
	use &datatransferpath\hsnmaster alias fhsn
	index on hsid to fhsn	
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + parnam + str(igst,5,2) to mpcm


sele fitm
go top
scan
   last=recno()
sele fcod
seek fitm.mn_id
sele ftax
seek fcod.m_id
   sele mitm
   append blank
   repl mitm.code with (fitm.mn_id)
   repl mitm.name with fcod.m_id
   repl mitm.product with fitm.materialname 
   repl mitm.billname with fitm.materialname 
   repl mitm.gcode with padr(fcod.b_id,6)
   repl mitm.gcode3 with padr(fcod.d_id,6)
   repl mitm.gcode5 with padr(fcod.mc_id,6)
   repl mitm.gcode6 with padr(fcod.hsid,6)
   repl mitm.mrp with fitm.mrp
   repl mitm.ratea with fitm.recentsalesprice
   repl mitm.prate with fitm.recentcostprice
   repl mitm.unit with 'PCS'
   repl mitm.lprate with fitm.recentcostprice
   repl rackno with ftax.mbarcode
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.purtax with ftax.tax/2
   repl mitm.saltax with ftax.tax/2
   repl mitm.cgst with ftax.tax/2
   repl mitm.igst with ftax.tax
	=seek (fcod.hsid,'fhsn')
        sele mpcm
        seek 'COMMCD' + substr(fhsn.hsncode+space(15),1,15) + str(mitm.igst,5,2)
        if !found()
           append blank
           repl mpcm.sgcode with 'COMMCD',;
                mpcm.scode  with 'C'+alltrim(str(last)),;
                mpcm.sname  with substr(fhsn.hsncode+space(15),1,15)+ substr(fhsn.hsncode,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
                mpcm.parnam with substr(fhsn.hsncode,1,15),;
                mpcm.tax with mitm.saltax,;
                mpcm.cgst with mitm.cgst,;
                mpcm.igst with mitm.igst,;
                mpcm.tcode with 'No'
        endif
        repl mitm.gcode6 with mpcm.scode
endscan
close table all

@Rowno,22 say 'Importing Company.....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
 use &datatransferpath\m_brandname alias fcomp
sele sele(1)
 use &datdev\saletype.&datext alias mcomp
 index on sgcode + parnam to  mcomp

sele fcomp
go top
scan
   sele mcomp
   seek 'ZZZZZZ' + substr(fcomp.brandname+space(40),1,40)
   if !found()
      append blank
      repl mcomp.sgcode with 'ZZZZZZ',;
           mcomp.scode  with padr(fcomp.b_id,6),;
           mcomp.sname  with fcomp.brandname,;
           mcomp.parnam with fcomp.brandname,;
           mcomp.tcode with 'No'
   endif
endscan
close table all

@Rowno,22 say 'Importing Design .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
 use &datatransferpath\m_design alias fcomp
sele sele(1)
 use &datdev\saletype.&datext alias mcomp
 index on sgcode + parnam to  mcomp

sele fcomp
go top
scan
   sele mcomp
   seek 'SALT  ' + substr(fcomp.designname+space(40),1,40)
   if !found()
      append blank
      repl mcomp.sgcode with 'SALT  ',;
           mcomp.scode  with padr(fcomp.d_id,6),;
           mcomp.sname  with fcomp.designname,;
           mcomp.parnam with fcomp.designname,;
           mcomp.tcode with 'No'
   endif
endscan
close table all



@Rowno,22 say 'Importing Category .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\m_materialcategory alias fcat
sele sele(1)
	use &datdev\saletype.&datext alias mcat
	index on sgcode + parnam to  mcat

sele fcat
go top
scan
   sele mcat
   seek 'CATEGO' + substr(fcat.materialcategory+space(40),1,40)
   if !found()
      append blank
      repl mcat.sgcode with 'CATEGO',;
           mcat.scode  with padr(fcat.mc_id,6),;
           mcat.sname  with fcat.materialcategory,;
           mcat.parnam with fcat.materialcategory,;
           mcat.tcode with 'No'
   endif
endscan
close table all

@Rowno,22 say 'Importing Batch .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\Material_Transaction alias fsbal

sele sele(1)
	use &datatransferpath\purchase alias pur
	index on str(m_trid,9) to pur
sele sele(1)
	use &datatransferpath\stockadjustmentdetail alias adj
	index on str(m_trid,9) to adj

sele sele(1)
	use &datatransferpath\sales_items alias sale
	index on str(val(sal_mtrid),9) to sale

sele sele(1)
	use &datdev\probat.&datext alias msbal
	index on str(code,9)+ mycode to msbal
sele sele(1)
	use &datdev\pro.&datext alias mitm
	index on str(code,9) to mitm
sele sele(1)
	use &datdev\support.&datext
  	dele all for type='#' and aliase='DAT/F-BT'
 	pack

r=0
sele fsbal
go top
scan
prdcode=val(m_trid)
	sele pur
    seek str(prdcode,9)
    sum pe_quantity to tot1 while str(m_trid,9)=str(prdcode,9)
    
	sele adj
    seek str(prdcode,9)
    sum qtyminus,qtyplus to totl,totp while str(m_trid,9)=str(prdcode,9)
    
	sele sale
    seek str(prdcode,9)
    sum sal_qty to tot2 while str(val(sal_mtrid),9)=str(prdcode,9)
	mbalance=((tot1+totp)-(tot2+totl))
	sele mitm	
   	seek str(prdcode,9)
   sele msbal
   seek str(prdcode,9)+substr(fsbal.batchcode,1,20)
   if !found()   
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.packing with mitm.packing
      repl msbal.decimal with 'Y'
      repl msbal.mycode with fsbal.batchcode
      repl msbal.prate with fsbal.purchaserate
      repl msbal.mrp with fsbal.mrprate
      repl msbal.ratea with fsbal.salesrate
      repl msbal.rateb with fsbal.wholesalerate
      repl msbal.lprate with fsbal.purchaserate
      repl msbal.misc1 with mitm.gcode
   repl msbal.opening with mbalance
   repl msbal.balance with mbalance
   repl msbal.o_a with mbalance
   repl msbal.b_a with mbalance
 else
   repl msbal.opening with msbal.opening +mbalance,;
        msbal.balance with msbal.balance +mbalance,;
        msbal.o_a with msbal.o_a +mbalance,;
        msbal.b_a with msbal.b_a +mbalance
    endif
endscan
close table all


@Rowno,22 say 'Importing Supplier .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
 use &datatransferpath\supplier alias fact
sele sele(1)
 use &datdev\order.&datext alias mact 
Sele sele(1)
 Use &datdev\support.&datext Alias tsupp
 Index On aliase + Str(sno,3) + lcode To tsupp

sele fact
go top
scan
*!*  sele fgrp
*!*  seek fact.groupcode
*!*  msname=alltrim(upper(fgrp.groupname))
 sele mact
    append blank
    repl mact.rate with 'Y'    
    repl mact.ordno with STR(fact.s_id,6)
    repl mact.parnam  with fact.s_suppliername
    repl mact.paradd with fact.s_address
    repl mact.mailNam with fact.s_suppliername
    repl mact.ref with 'Mr.'   
    repl mact.price with 'A'
    repl mact.status with 'Y' 
    *repl mact.phone4 with fact.contact_person
    repl mact.phone1 with fact.S_mobileno      
    repl mact.scode with 'D31'
 
 && Updating State
 Sele tsupp
 Seek 'ORDER   ' + '  7' +  mact.ordno
 Append Blank
 Repl aliase With 'ORDER   '
 Repl Type With 'F'
 Repl lcode With mact.ordno
 Repl sno With 7
 Repl pcode With 15
 Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',MSTATECODE,Subs(mact.gstno,1,2))+'                                           '   
endscan
close tables all

@Rowno,22 say 'Transfer Customer .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
 use &datatransferpath\customer alias fact
 
sele sele(1)
 use &datdev\order.&datext alias mact 
 
Sele sele(1)
 Use &datdev\support.&datext Alias tsupp
 Index On aliase + Str(sno,3) + lcode To tsupp
sele fact
go top
do while .not. eof()
   sele mact
   append blank
   repl mact.scode with 'C6',;
        mact.ordno with 'R'+alltri(str(fact.cu_id)),;
        mact.parnam  with upper(fact.cu_customername),;
        mact.paradd  with substr(upper(fact.cu_address),1,40),;
        mact.paradd1  with substr(upper(fact.cu_address),41,40),;
        mact.paradd2  with substr(upper(fact.cu_address),81,40),;
        mact.phone4 with fact.cu_mobileno
   repl mact.sthed with  'TIN No.'
   repl mact.gsthed with  'GST No.'
   repl mact.csthed with 'CST  No.'
   repl mact.gstno with fact.gstno
   repl mact.itno with fact.panno
   repl mact.ref with 'Mr.'  	
   repl mact.price with 'A'
   repl mact.status with 'Y' 
   repl mact.confir with fact.pname
   repl mact.mailnam with upper(fact.cu_customername)
   repl fax2 with fact.cu_code
 && Updating State
 Sele tsupp
 Seek 'ORDER   ' + '  7' +  mact.ordno
 Append Blank
 Repl aliase With 'ORDER   '
 Repl Type With 'F'
 Repl lcode With mact.ordno
 Repl sno With 7
 Repl pcode With 15
 Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',MSTATECODE,Subs(mact.gstno,1,2))+'                                           '   
sele fact
skip
enddo
close data

&&EOF : POS.PRG .....Author salman