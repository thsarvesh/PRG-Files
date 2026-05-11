*!*	BOF : Melody SOFTWARE.PRG (Pharma).....CREATED By Salman Dated    : 15/11/2021
*!*	Edit By  :  RAJESH  DATED  25/11/2022 , DELHI
*!* STATE : HYDERABAD(36)
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
	firstdate=ctod('01/04/2022')  		&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2023')  		&& Un-Comment this for run from VFP
	datdev='d:\transfer\'   && Un-Comment this for run from VFP
	datext='DBF'						&& Un-Comment this for run from VFP
endif
datatransferext='DBF'
datatransferpath=substr('D:\2025\Mar\Melody\FERNS\fernsdb\'+space(100),1,100)
datatransferpath1=substr('D:\2025\Mar\Melody\FERNS\fantacy\'+space(100),1,100)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='32'
sure='SURE'
removenull='No '

Clear
Close Data
@ 02,22 Say 'Piping Melody SOFTWARE.PRG (Pharma Retail) To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 to   21,115 doub
@ 06,10 Say 'Melody SOFTWARE Data Path    :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 07,10 Say 'Melody SOFTWARE Data Path    :' Font 'Courier',18  Get datatransferpath1  Font 'courier',18
@ 08,10 Say 'Melody SOFTWARE Extension    :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 09,10 Say 'F.Y. BEGIN Date              :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 10,10 Say 'F.Y. End   Date              :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 11,10 Say 'State Code                   :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 12,10 Say 'Removenull                   :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 13,10 Say 'Type SURE                    :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18
Read
if type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
endif
Clear
Close Data
datatransferpath=alltrim(datatransferpath)
datatransferpath1=Alltrim(datatransferpath1)
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
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

@ 02,22 Say 'Please Wait Importing Melody SOFTWARE.PRG (Pharma) To Marg.....' Font 'Arial',14 Colo 'W+/G'

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
Set Colo To
clos tabl all
@Rowno,22 say 'Importing Product .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\items.sft alias fitm
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + parnam + str(igst,5,2) tag hsn of mpcm
    index on sgcode + sname tag mpcm1 of mpcm

sele fitm
go top
scan
   last=recno()
   sele mitm
   *IF !(FOUND)
   append blank
   repl mitm.code with Last
   repl mitm.name with (fitm.i_cod)
   repl mitm.product with fitm.i_des
   repl mitm.packing with fitm.i_pac
   repl mitm.pack with fitm.i_q_p
   repl mitm.billname with fitm.i_des
   repl mitm.unit with fitm.i_q_d
   repl mitm.gcode WITH fitm.i_com
   repl mitm.gcode3 WITH fitm.i_gen     
   repl mitm.minimum with fitm.i_min
   repl mitm.maximum with fitm.i_max
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.mrp with fitm.i_mrp
   repl mitm.prate with fitm.i_brt
   repl mitm.rateb with fitm.i_ptr
   repl mitm.lprate with fitm.i_lrt
   repl mitm.ratea with fitm.i_srt
   repl mitm.purtax with fitm.i_gst/2
   repl mitm.saltax with fitm.i_gst/2
   repl mitm.cgst with fitm.i_gst/2
   repl mitm.igst with fitm.i_gst
   
 &&HSN
sele mpcm
set order to hsn
seek 'COMMCD' + substr(fitm.i_abr+space(15),1,15) + str(mitm.igst,5,2)
if !found()
   append blank
   repl mpcm.sgcode with 'COMMCD',;
        mpcm.scode  with 'HH'+alltrim(str(last)),;
        mpcm.sname  with substr(fitm.i_abr+space(15),1,15)+ substr(fitm.i_abr,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
        mpcm.parnam with fitm.i_abr,;
        mpcm.tax with mitm.saltax,;
        mpcm.cgst with mitm.cgst,;
        mpcm.igst with mitm.igst,;
        mpcm.tcode with 'No'
endif
repl mitm.gcode6 with mpcm.scode
endscan
CLOSE TABLE ALL

@Rowno,22 say 'Importing Salt Master .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
  use &datatransferpath\items.sft alias fsal 
sele sele(1)
  use &datdev\saletype.&datext alias stype
  
sele fsal
scan
 sele stype
 appen blank
 repl sgcode with 'SALT  '
 repl scode with fsal.i_gen
 repl parnam with fsal.i_ged
 repl sname with fsal.i_ged 
 repl tcode with 'No'
    repl tax with 1
endscan
close table all    



@Rowno,22 say 'Importing Company Master .....' font 'Courier',14 
rowno=rowno+1

sele sele(1)
  use &datatransferpath\items.sft alias fcomp 
sele sele(1)
  use &datdev\saletype.&datext alias stype
  
sele fcomp
scan
 sele stype
 appen blank
 repl sgcode with 'ZZZZZZ'
 repl scode with fcomp.i_com
 repl parnam with fcomp.i_cde
 repl sname with fcomp.i_cde 
 repl tcode with 'No'
 repl tax with 1
endscan
close table all    


@Rowno,22 say 'Importing Batch .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\stock.sft alias fsbal
	SET Filter To S_TYP#'E'
	GOTO TOP
sele sele(1)
	use &datdev\probat.&datext alias msbal
	index on + name + batchno to msbal
	
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
   sele mitm
   SEEK SUBSTR(fsbal.s_cod+SPACE(10),1,10)
   sele msbal
   *SEEK SUBSTR(fsbal.s_cod+SPACE(10),1,10)+SUBSTR(fsbal.s_bth+SPACE(12),1,12)
      *if .not. found()
      append blank
      repl msbal.date with date()
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      REPL MSBAL.PACKING WITH MITM.PACKING
      repl msbal.pack with mitm.pack
      repl msbal.unit with mitm.unit
      repl msbal.pack with mitm.pack
      repl msbal.decimal with 'Y'
      repl msbal.batchno with fsbal.s_bth
      repl msbal.exp with CTOD(ALLTRIM('01')+'/'+SUBSTR(ALLTRIM(fsbal.s_exp),1,2)+'/'+SUBSTR(ALLTRIM(fsbal.s_exp),3,2))
      repl msbal.ratea with fsbal.s_wrt
      repl msbal.mrp with fsbal.s_srt
      repl msbal.prate with fsbal.s_brt
      repl msbal.misc1 with mitm.gcode
      repl msbal.opening with fsbal.s_qty
      repl msbal.balance with fsbal.s_qty
      repl msbal.o_a with fsbal.s_qty
      repl msbal.b_a with fsbal.s_qty
*!*	    else
*!*	      repl msbal.opening with msbal.opening + fsbal.s_qty,;
*!*	           msbal.balance with msbal.balance + fsbal.s_qty,;
*!*	           msbal.o_a with msbal.o_a + fsbal.s_qty,;
*!*	           msbal.b_a with msbal.b_a + fsbal.s_qty
    * endif
endscan
close table all

@Rowno,22 say 'Importing MR .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath1\party.sft alias fact
index on ter to fact uniq
sele sele(1)
use &datdev\order.&datext alias mact 
sele fact 
go top
scan
	sele mact
	appen blank
	repl scode with 'D32'
	repl parnam with fact.ter
	repl mailnam with parnam
	repl ordno with fact.ter
endsc
close table all

@Rowno,22 say 'Importing Ledger (Sundry Debtor) .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath1\fas02.sft alias fact
	INDEX on ALLTRIM(h_des) TO fact

 sele sele(1)
 use &datatransferpath1\party.sft alias fadr
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode+sname to mpcm
sele sele(1)
	use &datdev\order.&datext alias mact 
Sele sele(1)
	Use &datdev\support.&datext Alias tsupp
	Index On aliase + Str(sno,3) + lcode To tsupp

SELECT fadr
go top
scan
last=recno()
	sele fact
	SEEK ALLTRIM(fadr.des)
    sele mact
    append blank
    repl mact.scode with 'C6'
   	repl mact.rate with 'Y'   	
   	repl mact.ordno with "C"+ALLTRIM(fadr.cod)
   	repl mact.parnam  with fadr.des
    repl mact.mailNam with fadr.des
   	repl mact.paradd with fadr.ad1
   	repl mact.paradd1 with fadr.ad2
   	repl mact.paradd2 with fadr.ad3
   	repl mact.city with fadr.plc 	
   	repl mact.gsthed with  'GST No.'
  	repl mact.gstno with fadr.csn
  	repl mact.stno with fadr.stn
    repl mact.dlno with  alltrim(fadr.dl1)+' '+ALLTRIM(fadr.dl2) 
    repl mact.DSM with  ''&&fadR.PIN
    repl mact.phone1 with getwordnum(fadr.pho,1,'/')
    repl mact.phone2 with substr(alltri(fadr.pho),1,10)
    repl mact.phone3 with substr(alltri(fadr.pho),11,10)
   	repl mact.ref with 'Mr.' 
   	repl mr with fadr.ter 	
   	repl mact.price with 'A'
   	repl mact.status with 'Y' 
    repl mact.confir with 'contact person'
   	repl mact.phone4 with getwordnum(fadr.pho,2,'/')
   	repl mact.adhed with 'Discount'
    repl      mact.opning with fact.h_cba &&-(fact.h_bal)
    repl      mact.balance with fact.h_cba
    &&&route    
    SELE mpcm
	Seek 'ROUT  ' + substr(allt(Upper(fadr.ARE))+space(40),1,40)
	If !Found()
		Append Blank
		Repl sgcode With 'ROUT  '
		Repl scode  With Allt(Str(Recno()))
		Repl parnam  With Substr(Upper(Allt(fadr.ARE))+Space(40),1,15)
		Repl sname With Substr(Upper(Allt(fadr.ARE))+Space(40),1,40)
	Endif
	Repl mact.rout With mpcm.scode 
	&&&area	
	SELE mpcm
	Seek 'AREA  ' + substr(allt(Upper(fadr.plc))+space(40),1,40)
	If !Found()
		Append Blank
		Repl sgcode With 'AREA  '
		Repl scode  With Allt(Str(Recno()))
		Repl parnam  With Substr(Upper(Allt(fadr.plc))+Space(40),1,15)
		Repl sname With Substr(Upper(Allt(fadr.plc))+Space(40),1,40)
	Endif
	Repl mact.AREA With mpcm.scode 
    sele fadr	
 	endscan
 	close tables all  
 @Rowno,22 say 'Importing Ledger (Sundry Creditor) .....' font 'Courier',14 
 rowno=rowno+1 
sele sele(1)
use &datatransferpath1\fas02.sft alias fact
index on h_des TO fact
sele sele(1)
 use &datatransferpath1\suppl.sft alias facr
 index on cod to facr uniq
sele sele(1)
	use &datdev\order.&datext alias mact 

Sele sele(1)
	Use &datdev\support.&datext Alias tsupp
	Index On aliase + Str(sno,3) + lcode To tsupp

SELECT facr
go top
scan
last=recno()
	sele fact
	SEEK facr.des
    sele mact
    append blank
   repl      mact.scode with 'D31'	 
   repl      mact.rate with 'Y'
   repl      mact.ordno WITH facr.cod
   repl      mact.parnam  with facr.des
   repl      mact.paradd with facr.ad1
   repl      mact.paradd1 with facr.ad2
   repl      mact.paradd2 with facr.ad3
   repl      mact.sthed with  'TIN No.'
   repl      mact.csthed with 'CST  No.'
   repl      mact.gsthed with 'GST  No.'
   repl      mact.gstno with fact.h_abr
   repl      mact.mailNam with facr.des
   repl      mact.phone1 with SUBSTR(ALLTRIM(facr.pho),1,10)
   repl      mact.ref with 'Mr.'
   repl mact.gstno with facr.csn
   repl mact.stno with facr.stn
   repl      mact.price with 'A'
   repl      mact.city with facr.plc
   repl      mact.status with 'Y'
   repl      mact.adhed with 'Discount'
   repl      mact.opning with fact.h_cba &&-(fact.h_bal)
   repl      mact.balance with fact.h_cba
endscan
close tables all

 	
    
*!*		&& Updating State
*!*		Sele tsupp
*!*		Seek 'ORDER   ' + '  7' +  mact.ordno
*!*		Append Blank
*!*		Repl aliase With 'ORDER   '
*!*		Repl Type With 'F'
*!*		Repl lcode With mact.ordno
*!*		Repl sno With 7
*!*		Repl pcode With 15
*!*		Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(mact.gstno,1,2)='  ',MSTATECODE,Subs(mact.gstno,1,2))+'                                           '  	
close tables all
 @Rowno,22 say 'Importing Customer Outstandings .....' font 'Courier',14 
 rowno=rowno+1 
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath1\fas05.sft alias fout
SET FILTER TO dte>old_5
sele sele(1)
use &datatransferpath\ADJUST.SFT alias fcn
set Filter To adj#'Y' AND vdt>old_5
goto top
sele mslip 
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
   sele mpend
   append blank
   repl acgroup with 'C6'
   repl ord with 'C'+fout->cod
   repl ddate with fout->dte
   repl vcn with fout->bno
   repl invtype with 'O'
   repl voucher  with vou
   repl svoucher with svou
   repl final with (fout->amd)
   repl itemope with (fout->amr)+FOUT.ADJ
   repl balance with (final-itemope)
   repl name with vcn
   vou=vou+5
   svou=svou+5
endsc
sele fcn
go top
scan
   sele mpend
   append blank
   repl acgroup with 'C6'
   repl ord with 'C'+fcn.cod
   repl ddate with fcn.vdt
   repl vcn with Alltrim(fcn.vno)
   repl invtype with 'O'
   repl voucher  with vou
   repl svoucher with svou
   repl final with -(fcn.amt)
   repl itemope with 0
   repl balance with (final-itemope)
   repl name with vcn
   vou=vou+5
   svou=svou+5
endsc

sele mslip 
repl voucher  with vou+5
repl svoucher with svou+5
close table all

 @Rowno,22 say 'Importing Supplier Outstandings .....' font 'Courier',14 
 rowno=rowno+1 
sele sele(1)
use &datdev\pendings.&datext alias mpend
INDEX on vcn+ord TO mpend
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\bills.sft alias fout
SET FILTER TO rdt>old_5 
sele mslip 
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
   sele mpend
   seek SUBSTR(fout.bno+SPACE(20),1,20)+SUBSTR(fout.cod+spac(6),1,6)
   IF !FOUND() 
   append blank
   repl acgroup with 'D31'
   repl ord with fout->cod
   repl ddate with fout->rdt
   repl vcn with fout->bno
   repl invtype with 'O'
   repl voucher  with vou
   repl svoucher with svou
   repl final with -(fout->amt)
   repl itemope with 0
   repl balance with final
   repl name with vcn
   ELSE
   repl final with -(fout->amt)
   repl itemope with 0
   repl balance with final
   endi	
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

&&EOF : Melody.PRG .....rajesh