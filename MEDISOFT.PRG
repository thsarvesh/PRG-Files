*!*	BOF : Medisoft Software.PRG (PHARMA WHOLESALE).....CREATED By Salman     Dated    : 06/04/2021
*!* STATE : GUJRAT(24)
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
CLOSE TABLe all
set talk off
set date to brit
set cent on
set dele on
set safe off
if type('FINALCP')='U'
 firstdate=ctod('01/04/2024')  	               && Un-Comment this for run from VFP
 lastdate =ctod('31/03/2025')  	               && Un-Comment this for run from VFP
 datdev='d:\transfer\'                 && Un-Comment this for run from VFP
 datext='dbf'		                                && Un-Comment this for run from VFP
endif
datatransferpath =substr('D:\2025\Feb\manish\data\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='24'
sure='SURE'
removenull='No '

Clear
CLOSE TABLe all
@ 02,22 Say 'Piping Medisoft Software.PRG (PHARMA WHOLESALE) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 to 21,115 doub
@ 06,10 Say 'Medisoft Data Path      :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 07,10 Say 'Medisoft Extension      :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 09,10 Say 'F.Y. BEGIN Date         :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 10,10 Say 'F.Y. End   Date         :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 11,10 Say 'State Code              :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 12,10 Say 'Removenull              :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 13,10 Say 'Type SURE               :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18

Read
Clear
CLOSE TABLe all
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
*=starttransfer()        &&&&Comment it for run in VFP
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

@ 02,22 Say 'Please Wait Importing Medisoft Software.PRG (PHARMA WHOLESALE) To Marg.....' Font 'Arial',14 Colo 'W+/G'

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
CLOSE TABLe all
Set Colo To

@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\scsitm alias fitm
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + parnam + str(igst,5,2) tO mpcm
sele fitm
go top
scan
   last=recno()
   sele mitm
   append blank 
   repl mitm.code with fitm.itmsr
   repl mitm.name with alltri(str(fitm.itmsr))
   repl mitm.product with fitm.itmnam
   repl mitm.billname with fitm.itmnam
   repl mitm.packing with fitm.ipack
   repl mitm.unit with fitm.ibrief
   repl mitm.pack with val(fitm.isize)
   repl mitm.rackno with fitm.icode
   repl rackno2 with fitm.iloc
   repl gcode with padr(fitm.icomsr,6)
   repl gcode3 with padr(fitm.idrgsr,6)
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.mrp with fitm.imrp
   repl mitm.prate with fitm.ipurrt
   repl mitm.ratea with fitm.isalrt
   repl mitm.purtax with fitm.sgst
   repl mitm.saltax with fitm.sgst
   repl mitm.cgst with fitm.cgst
   repl mitm.igst with fitm.igst
&&HSN
sele mpcm
seek 'COMMCD' + substr(fitm.sacno+space(15),1,15) + str(mitm.igst,5,2)
if !found()
   append blank
   repl mpcm.sgcode with 'COMMCD',;
        mpcm.scode  with 'HH'+alltrim(str(last)),;
        mpcm.sname  with substr(fitm.sacno+space(15),1,15)+ substr(fitm.sacno,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
        mpcm.parnam with fitm.sacno,;
        mpcm.tax with mitm.saltax,;
        mpcm.cgst with mitm.cgst,;
        mpcm.igst with mitm.igst,;
        mpcm.tcode with 'No'
endif
repl mitm.gcode6 with mpcm.scode
&&category
sele mpcm
seek 'CATEGO' + substr(fitm.idep+space(15),1,15)
if !found()
   append blank
   repl mpcm.sgcode with 'CATEGO',;
        mpcm.scode  with 'CT'+alltrim(str(last)),;
        mpcm.sname  with substr(fitm.idep+space(15),1,15),;
        mpcm.parnam with fitm.idep,;
        mpcm.tcode with 'No'
endif
repl mitm.gcode5 with mpcm.scode
ENDSCAN
CLOSE TABLE ALL
@Rowno,22 say 'Importing Company Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\scscsd alias fpcm 
sele sele(1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode='ZZZZZZ'
sele fpcm
scan
	sele mpcm
	appen blank
	repl sgcode with 'ZZZZZZ'
	repl scode with padr(fpcm.cssrno,6)
	repl parnam with upper(fpcm.csname)
	repl sname with upper(fpcm.csname)
	repl tcode with 'No'
	repl tax with 1
endscan
close table all    

@Rowno,22 say 'Importing Salt Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\scsdrg alias fpcm 
sele sele(1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode='SALT  '
sele fpcm
scan
	sele mpcm
	appen blank
	repl sgcode with 'SALT  '
	repl scode with padr(fpcm.idrgsr,6)
	repl parnam with upper(fpcm.cn_name)
	repl sname with upper(fpcm.cn_name)
	repl tname with substr(upper(fpcm.cn_name),41,40)
	repl tcode with 'No'
	repl tax with 1
endscan
close table all    

@Rowno,22 say 'Importing Batch Opening .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\scsiop alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
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
   sele mitm
   seek str(fsbal.itmsr,9)
   sele msbal
   seek str(fsbal.itmsr,9)+substr(fsbal.batchno+space(12),1,12)
   if !found()   
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.unit with mitm.unit
      repl msbal.pack with mitm.pack
      repl msbal.decimal with 'Y'
      repl msbal.batchno with fsbal.batchno
      repl msbal.exp with fsbal.expirydt
      repl msbal.mrp with fsbal.mrp
      repl msbal.ratea with fsbal.salrt
      repl msbal.prate with fsbal.purrt
      repl msbal.Lprate with fsbal.purrt
     repl msbal.opening with (fsbal.totstk)
      repl msbal.balance with (fsbal.totstk)
      repl msbal.o_a with (fsbal.totstk)
      repl msbal.b_a with (fsbal.totstk)
    else
      repl msbal.opening with msbal.opening + (fsbal.totstk),;
           msbal.balance with msbal.balance + (fsbal.totstk),;
           msbal.o_a with msbal.o_a + (fsbal.totstk),;
           msbal.b_a with msbal.b_a + (fsbal.totstk)
    endif
endscan
close table all

@Rowno,22 say 'Importing Batch In .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\scsitr alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
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
scan for inout=1
   sele mitm
   seek str(fsbal.itmsr,9)
   sele msbal
   seek str(fsbal.itmsr,9)+substr(fsbal.batchno+space(12),1,12)
   if !found()   
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.unit with mitm.unit
      repl msbal.pack with mitm.pack
      repl msbal.decimal with 'Y'
      repl msbal.batchno with fsbal.batchno
      repl msbal.exp with fsbal.expirydt
      repl msbal.mrp with fsbal.mrp
      repl msbal.ratea with fsbal.salpr
      repl msbal.prate with fsbal.purpr
      repl msbal.Lprate with fsbal.purpr
     repl msbal.opening with (fsbal.qty+fsbal.free)
      repl msbal.balance with (fsbal.qty+fsbal.free)
      repl msbal.o_a with (fsbal.qty+fsbal.free)
      repl msbal.b_a with (fsbal.qty+fsbal.free)
    else
      repl msbal.opening with msbal.opening +(fsbal.qty+fsbal.free),;
           msbal.balance with msbal.balance +(fsbal.qty+fsbal.free),;
           msbal.o_a with msbal.o_a +(fsbal.qty+fsbal.free),;
           msbal.b_a with msbal.b_a +(fsbal.qty+fsbal.free)
    endif
endscan
close table all

@Rowno,22 say 'Importing Batch Out.....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\scsitr alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
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
scan for inout=2
   sele mitm
   seek str(fsbal.itmsr,9)
   sele msbal
   seek str(fsbal.itmsr,9)+substr(fsbal.batchno+space(12),1,12)
   if !found()   
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.unit with mitm.unit
      repl msbal.pack with mitm.pack
      repl msbal.decimal with 'Y'
      repl msbal.batchno with fsbal.batchno
      repl msbal.exp with fsbal.expirydt
      repl msbal.mrp with fsbal.mrp
      repl msbal.ratea with fsbal.salpr
      repl msbal.prate with fsbal.purpr
      repl msbal.Lprate with fsbal.purpr
     repl msbal.opening with -(fsbal.qty+fsbal.free)
      repl msbal.balance with -(fsbal.qty+fsbal.free)
      repl msbal.o_a with -(fsbal.qty+fsbal.free)
      repl msbal.b_a with (fsbal.qty+fsbal.free)
    else
      repl msbal.opening with msbal.opening -(fsbal.qty+fsbal.free),;
           msbal.balance with msbal.balance -(fsbal.qty+fsbal.free),;
           msbal.o_a with msbal.o_a -(fsbal.qty+fsbal.free),;
           msbal.b_a with msbal.b_a -(fsbal.qty+fsbal.free)
    endif
endscan
close table all


@Rowno,22 say 'Importing Supplier.....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\scsmst alias fact
sele sele(1)
use &datatransferpath\scsadd alias fadd
inde on srno to fadd
sele sele(1) 
use &datdev\order.&datext alias mact 
Sele sele(1)
Use &datdev\support.&datext Alias tsupp
Index On aliase + Str(sno,3) + lcode To tsupp
sele fact
go top
scan for grp_rec=14
last=recno()
=seek(fact.supsr,'fadd')    	
	sele mact
   	append blank
   	repl mact.rate with 'Y'   	
   	repl mact.ordno with padr(fact.a_rec_no,6)
   	repl fax2 with alltri(str(fact.supsr))
   	repl mact.mailNam with fact.a_name
    repl mact.parNam with fact.a_name
    repl paradd with upper(fadd.addr)
    repl paradd1 with substr(upper(fadd.addr),41,40)
    repl paradd2 with fadd.city
    repl dsm with fadd.pin
    repl confir with fadd.cont_perso
    repl dlno with alltri(fadd.pano)
    repl mact.ref with 'Mr.'  	
   	repl mact.price with 'A'
   	repl mact.status with 'Y' 
   	repl mact.phone2 with fadd.tel
   	repl phone1 with fadd.mob
   	repl phone4 with fadd.mob
   	repl gstno with upper(fadd.a_gsttinno)
    repl opning with fact.a_curr_bal
    repl balance with fact.a_curr_bal

    if fact.grp_rec = 14
    repl scode with 'D31'
    ELSE
    if fact.grp_rec = 5
    repl scode with 'C6'
    ENDIF
    ENDIF   	  	  	
    

 
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

&&EOF : VS-SOFT.PRG .....Author Salman