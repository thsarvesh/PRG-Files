*!*	**BOF : CPS.PRG .....UP(Pharma Wholesale)  Dated    : 08/08/2019   Author : Santosh K Srivastava
*!*	 datatransferpath="e:\datafrom\"+space(45)
*!*	 datatransferext="dbf"
*!*	 for bill difference ## in support -> repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!*	 for item difference ## in support -> repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!*	 for item batch difference ## in support -> repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!*	 for ledger difference ## in support -> repl type with "#",aliase with "DAT/F-LD",Lcode with mact.ordno,value with TOT
*!*	 ******************
*!*	 Your Commands
*!*	 ******************
*!*	 if LastKey()=27
*!*	  Return
*!*	 endif
*!*	 =starttransfer()
 ******************
*!* your commands
*!*	clear
set cpdialog off
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
sele sele(1)
create curs mycurs  (setup c(50),value c(4))
sele mycurs
appe blank
repl  setup with 'Item Wise Double Discount ',value with 'Y'
appen blank
repl  setup with 'Volume discount 1st ',value with 'L'
brow font 'COURIER',18    nomodify

if type('FINALCP')='U'
datdev='e:\umeshmarg\whol\'                          && Un-Comment this for run from VFP
datext='DBF'
firstdate=ctod('01/04/2024')                         && Un-Comment this for run from VFP
lastdate =ctod('31/03/2025')                         && Un-Comment this for run from VFP
endi
Sure = 'SURE'
datatransferpath=substr('D:\Umesh_2425\July\Cps\uttn\go3\'+space(150),1,150) &&&NIsar
datatransferext="dbf"
datatransferpath1="24   "
old_3 = 'YES'
mvat  = 'NO '
old_4 = 'No '
old_5 = firstdate
old_9 = lastdate
old_8 = '#'
old_7 ='F'
old_10='W'
mtrade='Pharma'
rem_dupl='No '
LotRate='Yes'
transferestimate='Yes'
Clear
@ 10,15 say 'CPS Data Path         :' font 'courier',18 get datatransferpath     font 'courier',18 
@ 11,15 say 'CPS Data Year Ext.    :' font 'courier',18 get datatransferpath1   font 'courier',18 
@ 12,15 say 'CPS Data Ext.         :' font 'courier',18 get datatransferext  font 'courier',18 
@ 13,15 say 'WITH O/S              :' font 'courier',18 get old_3 pict '@m YES,NO '  font 'courier',18 
*@ 14,15 say 'N-Full Y-Master       :' font 'courier',18 get old_4 pict '@m No ,Yes'  font 'courier',18 
@ 15,15 say 'F/Y BEGIN Date        :' font 'courier',18 get old_5  font 'courier',18 
@ 16,15 say 'F/Y End Date          :' font 'courier',18 get old_9  font 'courier',18 
@ 17,15 say 'Batch Seperator       :' font 'courier',18 get old_8 pict '!'  font 'courier',18 
@ 18,15 say 'Trade                 :' font 'courier',18 get mtrade pict '@M Pharma ,FMCG ,Other '  font 'courier',18 
@ 19,15 say 'R-Retail W-Whole Sale :' font 'courier',18 get old_10 pict '@m W,R'  font 'courier',18 
@ 20,15 say 'FIRM                  :' font 'courier',18 get old_7 pict '@M F,A' font 'Courier',18   
@ 21,15 say 'Transfer Estimate     :' font 'courier',18 get transferestimate pict '@M No ,Yes' font 'Courier',18   
@ 22,15 say 'Remove Duplicate      :' font 'courier',18 get Rem_dupl pict '@M No ,Yes' font 'Courier',18 
@ 23,15 say 'Lot Rate              :' font 'courier',18 get LotRate pict '@M Yes,No ' font 'Courier',18 
@ 24,15 say 'Type SURE             :' font 'courier',18 get sure pict '@x!'  font 'courier',18 
read
old_11=IIF(old_7='F','01','02')
datatransferpath =alltrim(datatransferpath)
datatransferpath1 =alltrim(datatransferpath1)
datatransferpath2 =subs(alltrim(datatransferpath1),3)
datatransferext=allt(datatransferext)
datdev =alltrim(datdev)
datext = alltrim(datext)
if lastkey()=27 .and. sure # 'SURE'
   return
endif
if rem_dupl='Y'
   =rem_dupl()
endif
clear
set colo to
sele sele(1)
use &datdev\glmonth.&datext
zap
use &datdev\ggmonth.&datext
zap
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
use &datdev\CHILLER.&datext
zap

use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F'
DELE ALL FOR ALIASE='BATCHP'
pack

close data
set colo to


if type('FINALCP')#'U'
=starttransfer()
endif
wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer ITEM"
fd=datatransferpath + 'PMS'+datatransferpath1+'.' + datatransferext
ft=datatransferpath + 'gstst'+datatransferpath2+'.' + datatransferext
td=datdev+'\pro.'+datext
ts=datdev+'\saletype.'+datext

sele d
use &ts alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm
sele a
use &fd alias fitm
try
sele c
use &ft alias ftax
index on p_code to ftax
catch
merror=1
endtry
sele b
use &td alias mitm
zap
index on name to mitm
sele fitm
go top
do while !eof()
   last=recno()
   if fitm.p_code = '$'
      skip
      loop
   endif
   try
   =seek(fitm.p_code,'ftax')
   catch
   merror=1
   endtry
   sele mitm
   seek substr(fitm.p_code+space(10),1,10)
   if !found()
      append blank
      repl mitm.code with last
      repl mitm.name with fitm.p_code
      repl mitm.product with fitm.p_name
      repl mitm.packing with fitm.p_packing
      repl mitm.billname with alltrim(fitm.p_name) +'  '+ alltrim(fitm.p_packing)
      repl mitm.unit with 'Pcs'
      repl mitm.pack with iif(old_10='R',iif(val(fitm.p_packing)=1,0,val(fitm.p_packing)),fitm.f_perbox)
      repl mitm.onqtyfree with fitm.f_case
      repl mitm.gcode with  substr(fitm.f_mfd,1,4)+substr(fitm.p_code,2,2)
      repl mitm.taxl with 'T'
      repl mitm.taxc with 'T'
      repl mitm.decimal with 'Y'
      repl mitm.salfix with 'N'
      repl mitm.minimum with fitm.f_minstock
      repl mitm.halfsche with 'A'
      repl mitm.qtrsche with 'Y'
*!*	try
      repl rackno with fitm.f_rackNO
*!*	catch
*!*	merror=1
*!*	endtry
            
try      
      repl mitm.saltax with ftax.f_sgst
      repl mitm.cgst with ftax.f_cgst
      repl mitm.igst with ftax.f_igst
      repl mitm.purtax with ftax.f_sgst
catch
merror=1
endtry
try
      repl mitm.saltax with ftax.f_vatper/2
      repl mitm.cgst with ftax.f_vatper/2
      repl mitm.igst with ftax.f_vatper
      repl mitm.purtax with ftax.f_vatper/2
catch
merror=1
endtry      
      repl mitm.status with 'Y'
      repl mitm.mrp with fitm.mrp
      repl mitm.ratea with val(allt(fitm.f_strate))
      repl mitm.prate with val(allt(fitm.f_trade))
      repl mitm.lprate with fitm.f_netpur
      repl mitm.formulano with substr(fitm.f_ormfd,1,15)+substr(mitm.formulano,16,25)
      &&HSN
try      
      sele mpcm
      seek 'COMMCD' + substr(ftax.f_hsn+space(15),1,15) + str(ftax.f_igst,5,2)
      if !found()
         append blank
         repl mpcm.sgcode with 'COMMCD',;
              mpcm.scode  with 'C'+alltrim(str(last)),;
              mpcm.sname  with substr(ftax.f_hsn+space(15),1,15)+ substr(ftax.f_hsn,1,15) +' '+ alltrim(str(mitm.igst,5,2)),;
              mpcm.parnam with substr(ftax.f_hsn,1,15),;
              mpcm.tax with mitm.saltax,;
              mpcm.cgst with mitm.cgst,;
              mpcm.igst with mitm.igst,;
              mpcm.tcode with 'No'
              
      endif
         repl mitm.gcode6 with mpcm.scode

catch
merror=1
endtry      
*!*	try      
*!*	      sele mpcm
*!*	      seek 'COMMCD' + substr(fitm.f_ormfd+space(15),1,15) + str(fitm.f_vatper,5,2)
*!*	      if !found()
*!*	         append blank
*!*	         repl mpcm.sgcode with 'COMMCD',;
*!*	              mpcm.scode  with 'C'+alltrim(str(last)),;
*!*	              mpcm.sname  with substr(fitm.f_ormfd+space(15),1,15)+ substr(fitm.f_ormfd,1,15) +' '+ alltrim(str(mitm.igst,5,2)),;
*!*	              mpcm.parnam with substr(ftax.f_ormfd,1,15),;
*!*	              mpcm.tax with mitm.saltax,;
*!*	              mpcm.cgst with mitm.cgst,;
*!*	              mpcm.igst with mitm.igst,;
*!*	              mpcm.tcode with 'No'
*!*	      endif
*!*	catch
*!*	merror=1
*!*	endtry      

*!*	      repl mitm.gcode6 with mpcm.scode
   endif
sele fitm   
skip
enddo
close data

try
if old_10='R'
   wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Doctor"   
   fd=datatransferpath + 'doctor.'+datatransferext
   td=datdev + '\maorder.'+datext

   sele a
   use &fd alias fdoc

   sele b
   use &td alias mdoc 
   set filt to scode='PRE#$~'
   dele all
   pack
   index on scode to mdoc 

   sele fdoc
   go top
   do while !eof()
   l=recno()
   sele mdoc
   append blank
   repl mdoc.scode with 'PRE#$~',;
        mdoc.form with allt(str(l)),;
        mdoc.parnam with substr(fdoc.dr_name+space(25),1,25)
   sele fdoc
   skip
   enddo
   close data
endif
catch
merror=1
endtry

try

if old_10='R'

   wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Patient"
   fd=datatransferpath + 'dms'+datatransferpath1+'.'+datatransferext
   td=datdev + '\maorder.'+datext
   sele a
   use &fd alias fdoc 
   sele b
   use &td alias mdoc 
   set filt to scode='PET#$~'
   dele all
   pack
   index on scode to mdoc 

   sele fdoc
   go top
   do while !eof()
   sele mdoc
   append blank
   repl mdoc.scode with 'PET#$~',;
        mdoc.ordno with fdoc.d_code,;
        mdoc.parnam with fdoc.d_name,;
        mdoc.city with alltrim(fdoc.d_address1+' '+fdoc.d_address2),;
        mdoc.form with alltrim(fdoc.d_code)
   sele fdoc
   skip
   enddo
   close data
endif
catch
merror=1
endtry
   

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Company"
fd=datatransferpath + 'pms'+datatransferpath1+'.' + datatransferext
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
pack
index on f_mfd + substr(p_code,2,2) to fpcm unique
sele b
use &td alias mpcm
set filt to sgcode = 'ZZZZZZ'
dele all
pack
index on scode to mpcm
sele fpcm
go top
do while !eof()
   sele mpcm
   seek substr(substr(fpcm.f_mfd,1,4)+substr(fpcm.p_code,2,2),1,6)
   if ! found()
      append blank
      repl mpcm.sgcode with 'ZZZZZZ',;
           mpcm.scode  with substr(fpcm.f_mfd,1,4)+substr(fpcm.p_code,2,2),;
           mpcm.sname  with substr(alltrim(fpcm.f_mfd)+' ('+substr(fpcm.p_code,2,2)+')',1,15),;
           mpcm.parnam with substr(alltrim(fpcm.f_mfd)+' ('+substr(fpcm.p_code,2,2)+')',1,15),;
           mpcm.tcode with 'No'
   endif
sele fpcm
skip
enddo
close data



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer AREA"
fd=datatransferpath + 'dms'+datatransferpath1+'.' + datatransferext
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
pack
index on substr(d_code,1,3) to fpcm unique
sele b
use &td alias mpcm
set filt to sgcode = 'AREA  '
dele all
pack
index on scode to mpcm

sele fpcm
go top
do while !eof()
   sele mpcm
   seek substr(fpcm.d_code,1,3)
   if !found()
      append blank
      repl mpcm.sgcode with 'AREA  ',;
           mpcm.scode  with substr(fpcm.d_code,1,3),;
           mpcm.sname  with substr(fpcm.d_code,1,3),;
           mpcm.parnam with substr(fpcm.d_code,1,3),;
           mpcm.tcode with 'No'
   endif
sele fpcm
skip
enddo
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Discount Master"
fd=datatransferpath + 'dis'+datatransferpath1+'.'+datatransferext
td=datdev+'\rate.'+datext
ti=datdev+'\pro.'+datext

sele c
use &ti alias mpro
index on name to mpro
sele a
use &fd alias fdis
sele b
use &td alias mpcm
zap

sele fdis
go top
do while ! eof()
   =seek(substr(fdis.f_product+space(10),1,10),'mpro')
   sele mpcm
   append blank
   repl mpcm.pcode with fdis.f_pcode,;
        mpcm.gcode with iif(len(alltrim(fdis.f_product))=3,substr(fdis.f_product,2,2),''),;
        mpcm.disc1 with fdis.f_disc
        if len(alltrim(fdis.f_product))=6
           repl mpcm.code with mpro.code
        endif   
sele fdis
skip
enddo
close data


wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Batch"
fd=datatransferpath+'ppt'+datatransferpath1+'.'+datatransferext
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

set order to supp

sele a
use &fd alias fsbal
index on p_code + bat_no to fsbal
sele b
use &mi alias mitm
index on name to mitm
sele c
use &td alias msbal
zap
index on name + batchno  to msbal

r=0
sele fsbal
*set filt to f_recdt < old_5
go top
px=0
sx=0
x=1
xpcode =p_code
xbat_no='zzzzz99999999'
do while ! eof()
   x=0
   xp_code=p_code
   xbat_no=bat_no
   do while p_code+Bat_No=p_code+xbat_no and !eof()
      x=x+1
      px=0
      sx=0
      edt1 = '01/'+substr(f_expdt,1,2)+'/20'+substr(f_expdt,4,2)
      edt2 = ctod(edt1)
	   &&Pur Deal Calculation
	   if at('+',fsbal.f_pdeal)>0
	      px=at('+',fsbal.f_pdeal)
	      pdq = val(substr(fsbal.f_pdeal,1,px-1))
	      pdf = val(substr(fsbal.f_pdeal,px+1,7))
	   endif
	   &&Sale Deal Calculation
	   if at('+',fsbal.f_sdeal)>0
	      sx=at('+',fsbal.f_sdeal)
	      sdq = val(substr(fsbal.f_sdeal,1,sx-1))
	      sdf = val(substr(fsbal.f_sdeal,sx+1,7))
	   endif

	   =seek(substr(fsbal.p_code+space(4),1,10),'mitm')
       REPL mitm.rackno with fsbal.f_rackno	    
	   sele msbal
	   append blank
	   repl msbal.code with mitm.code,;
	        msbal.date with fsbal.f_recdt,;
	        msbal.name with mitm.name,;
	        msbal.billname with mitm.billname,;
	        msbal.product with mitm.product,;
	        msbal.pack with iif(old_10='R',iif(val(fsbal.p_packing)=1,0,val(fsbal.p_packing)),mitm.pack),;
	        msbal.unit2 with mitm.unit2,;
	        msbal.unit with mitm.unit,;
	        msbal.decimal with 'Y',;
	        msbal.exp with edt2,;
	        msbal.lprate with fsbal.f_qnt/IIF(old_10='R' and mitm.pack#0,mitm.pack,1),;
	        msbal.prate with fsbal.f_strate,;
	        msbal.ratea with fsbal.f_trade,;
	        msbal.mrp with fsbal.f_mrp,;
	        msbal.ratef with fsbal.f_qnt,;
	        msbal.misc1 with mitm.gcode
	try        
	   repl msbal.misc3 with str(fsbal.f_svatper,5,2)+space(5)+'T'+substr(msbal.misc3,15,100)
	catch
	mError=1
	ENdtry
	        
	   repl msbal.purdis with fsbal.f_disc_bef,msbal.supcode with fsbal.f_pcode,msbal.supinvo with fsbal.invoice_no,msbal.supdat with fsbal.f_date
	if fsbal.f_sttype='C'  and transferestimate='Y'      
	        mmybatch=iif(mtrade='P',iif(fsbal.f_sttype=old_7,substr(fsbal.bat_no,1,10)+str(x,2),old_8+substr(fsbal.bat_no,1,9)+str(x,2)),str(fsbal.f_mrp,9,2))
	else
	        mmybatch=iif(mtrade='P',iif(fsbal.f_sttype=old_7,substr(fsbal.bat_no,1,10)+str(x,2),substr(fsbal.bat_no,1,8)+str(x,2)),str(fsbal.f_mrp,9,2))
	endif  
	REPL  batchno with mmybatch      
	repl  msbal.mybatch with  allt(str(fsbal.f_recsto))
	        
	        if at('+',fsbal.f_pdeal)>0
	           repl msbal.purdeal with pdq,;
	                msbal.purfree with pdf
	        else
	           if at('%',fsbal.f_pdeal)>0
	              repl msbal.purdeal with round(( (100*100)/(val(fsbal.f_pdeal)*100)),0)-1,;
	                   msbal.purfree with 1
	           endif      
	        endif
	           
	        if sx>0
	           repl msbal.deal with sdq,;
	                msbal.free with sdf
	        endif
	*!*	        if (fsbal.f_recdt < old_5 and fsbal.f_sttype=old_7 )or fsbal.f_pcode = 'AOPENI'
repl tqty with fsbal.p_qnt	
	if transferestimate='N' and fsbal.f_sttype='C'
	else   
	        if (fsbal.f_recdt < old_5 )or fsbal.f_pcode = 'AOPENI'

	           repl msbal.opening with ( fsbal.p_qnt),;
	                msbal.balance with ( fsbal.p_qnt),;
	                msbal.o_a with ( fsbal.p_qnt),;
	                msbal.b_a with ( fsbal.p_qnt)
	        endif
	endif        
	   sele support
	   appe blank
	   repl type with "#",aliase with "DAT/F-BT",lcode with "MEDIBT",pcode with mitm.code,heading with msbal.batchno,value with (fsbal.p_qnt - fsbal.f_qnt13 + fsbal.f_bqnt13)

sele fsbal
skip
enddo
*!*	if xp_code # fsbal.p_code or xbat_no # fsbal.bat_no
*!*	   xp_code = fsbal.p_code
*!*	   xbat_no= fsbal.bat_no
*!*	   x=1
*!*	endif
enddo
sele msbal
repl all date with old_5-1 for balance = 0 and empty(date)
close data



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Credit Party"
fd=datatransferpath + 'dms'+datatransferpath1+'.'+datatransferext
td=datdev + '\order.'+datext
ts=datdev + '\support.'+datext

sele c
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup
dele all for aliase = 'ORDER   '
pack

sele a
use &fd alias fact
sele b
use &td alias mact
zap

sele fact
pack
go top
do while ! eof()
   sele mact
   append blank
   repl mact.scode with 'C6',;
        mact.rate with 'Y',;
        mact.ordno with fact.d_code,;
        mact.parnam  with fact.d_name,;
        mact.ordno with fact.d_code,;
        mact.paradd with fact.d_address1,;
        mact.paradd1 with fact.d_address2,;        
        mact.paradd2 with alltrim(fact.city)+' '+alltrim(fact.district),;
        mact.sthed with  'GST No.',;
        mact.csthed with 'CST  No.',;
        mact.dlno with alltrim(fact.d_l_no)+ iif(!empty(alltrim(fact.d_l_no_2)),','+alltrim(fact.d_l_no_2),''),;
        mact.phone1 with fact.ph_no_off,;
        mact.phone4 with fact.f_mobile,;
        mact.confir with fact.p_to_con,;
        mact.trans with fact.f_trname,;
        mact.duedays with fact.f_duedt,;
        mact.limit with fact.f_limit,;
        mact.mailnam with fact.d_name,;
        mact.ref with 'Mr.',;
        mact.price with 'A',;
        mact.city with fact.city,;
        mact.area with substr(fact.d_code,1,2),;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        mact.opning with IIF(old_11='01',-(fact.Op_bal_val),-(fact.Ap_bal_val))
        
if transferestimate='Y'        
        repl openingc with -fact.cp_bal_val
        repl balancec with -fact.cp_bal_val
endif        
       * mact.openingc with -(fact.Ap_bal_val)
try
        repl mact.itno with fact.f_pan
        repl mact.gstno with fact.f_gstin
catch
merror=1
endtry
try
        repl mact.gstno with fact.f_upst
catch
merror=1
endtry
        
        
        tot = -(fact.Ap_bal_val+fact.credit1+fact.credit2+fact.credit3+;
                fact.credit4+fact.credit5+fact.credit6+fact.credit7+;
                fact.credit8+fact.credit9+fact.credit10+fact.credit11+;
                fact.credit12-fact.debit1-fact.debit2-fact.debit3-fact.debit4-;
                fact.debit5-fact.debit6-fact.debit7-fact.debit8-fact.debit9-;
                fact.debit10-fact.debit11-fact.debit12)
                 
        sele msup
        appe blank
        repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with tot
        
        
        &&Cash/Credit party  
        sele msup
        seek 'ORDER   ' + '  1' +  mact.ordno
        append blank
        repl aliase with 'ORDER   ',;
             type with 'F',;
             lcode with mact.ordno,;
             sno with 1,;
             remark with substr(msup.remark,1,70)+'R'+substr(msup.remark,72,100)
             
        && Email ID
        sele msup
        append blank
        repl aliase with 'ORDER   ',;
             type with 'F',;
             lcode with mact.ordno,;
             sno with 12,;
             remark with fact.f_email,;
             heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
             
        &&State Code        
        sele msup
        appe blank
        repl type with 'F'
        repl lcode with mact.ordno
        repl sno with 7
        repl pcode with 15
        repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ','09',subs(mact.gstno,1,2))
sele fact
skip
enddo
sele mact
appen blank 
repl scode with 'J12' 
repl ordno with 'CNADJ9' 
repl parnam with 'C/N Adj' 
repl mailnam with 'C/N ADJ'

appen blank 
repl scode with 'J12' 
repl ordno with 'DIS999' 
repl parnam with 'DISCOUNT ON BILLS ' 
repl mailnam with 'DISCOUNT ON BILLS '
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Cash Party"
fd=datatransferpath + 'bms'+datatransferpath1+'.'+datatransferext
td=datdev + '\order.'+datext
ts=datdev + '\support.'+datext

sele c
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup

sele a
use &fd alias fact
sele b
use &td alias mact

sele fact
pack
go top
do while ! eof()
   sele mact
   append blank
   repl mact.scode with 'C6',;
        mact.rate with 'Y',;
        mact.ordno with fact.b_code,;
        mact.parnam  with alltrim(fact.b_name)+ '(Cash)',;
        mact.ordno with fact.b_code,;
        mact.paradd with fact.d_address1,;
        mact.paradd1 with fact.d_address2
try                
   repl      mact.paradd2 with alltrim(fact.city)+' '+alltrim(fact.district),;
        mact.city with fact.city
   

catch
mError=1
endtry   
try
repl         mact.sthed with  'GST No.',;
        mact.csthed with 'CST  No.',;
        mact.dlno with alltrim(fact.d_l_no)+ iif(!empty(alltrim(fact.d_l_no_2)),','+alltrim(fact.d_l_no_2),'')
catch
merror=1
endtry        
repl        mact.phone1 with fact.ph_no_off,;
        mact.phone4 with fact.f_mobile,;
        mact.confir with fact.p_to_con,;
        mact.mailnam with fact.b_name,;
        mact.ref with 'Mr.',;
        mact.price with 'A',;
        mact.mr with '',;
        mact.status with 'Y',;
        mact.adhed with 'Discount'
if transferestimate='Y'        
        repl mact.openingc with -(fact.cp_bal_val)
endif

try
        repl mact.itno with fact.f_pan
        repl mact.gstno with fact.f_gstin
catch
merror=1
endtry
try
        repl mact.gstno with fact.f_upst
catch
merror=1
endtry
        
        sele msup
        appe blank
        repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with 0
        
        
        &&Cash/Credit party  
        sele msup
        seek 'ORDER   ' + '  1' +  mact.ordno
        append blank
        repl aliase with 'ORDER   ',;
             type with 'F',;
             lcode with mact.ordno,;
             sno with 1,;
             remark with substr(msup.remark,1,70)+'R'+substr(msup.remark,72,100)
             
        && Email ID
        sele msup
        append blank
        repl aliase with 'ORDER   ',;
             type with 'F',;
             lcode with mact.ordno,;
             sno with 12,;
             remark with fact.f_email,;
             heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
             
        &&State Code        
        sele msup
        appe blank
        repl type with 'F'
        repl lcode with mact.ordno
        repl sno with 7
        repl pcode with 15
        repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ','09',subs(mact.gstno,1,2))
sele fact
skip
enddo
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Supplier"
fd=datatransferpath + 'cms'+datatransferpath1+'.'+datatransferext
td=datdev + '\order.'+datext
ts=datdev + '\support.'+datext

sele c
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup

sele a
use &fd alias fact
sele b
use &td alias mact

sele fact
pack
go top
do while ! eof()
   sele mact
   append blank
   repl mact.scode with 'D31',;
        mact.rate with 'Y',;
        mact.ordno with fact.c_code,;
        mact.parnam  with fact.c_name,;
        mact.ordno with fact.c_code,;
        mact.parnam  with fact.c_name,;
        mact.paradd with fact.d_address1,;
        mact.paradd1 with fact.d_address2,;        
        mact.sthed with  'GST No.',;
        mact.csthed with 'CST  No.',;
        mact.phone1 with fact.ph_no_off,;
        mact.phone4 with fact.f_mobile,;
        mact.confir with fact.p_to_con,;
        mact.mailnam with fact.c_name,;
        mact.ref with 'Mr.',;
        mact.price with 'A',;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        mact.opning with IIF(OLD_11='01',-(fact.Op_bal_val),-(fact.Ap_bal_val))
if transferestimate='Y'        
        repl mact.openingc with -(fact.cp_bal_val)
endif        
        
       * mact.openingc with -(fact.Ap_bal_val)
try
        repl mact.itno with fact.f_pan
        repl mact.gstno with fact.f_gstin
        repl mact.dlno with alltrim(fact.d_l_no)+' '+alltrim(fact.d_l_no_2),;
        mact.paradd2 with alltrim(fact.city)+' '+alltrim(fact.district),;
                mact.city with fact.city

        
catch
merror=1
endtry
try
        repl mact.gstno with fact.f_upst
catch
merror=1
endtry

        tot = -(fact.op_bal_val+fact.credit1+fact.credit2+fact.credit3+;
                fact.credit4+fact.credit5+fact.credit6+fact.credit7+;
                fact.credit8+fact.credit9+fact.credit10+fact.credit11+;
                fact.credit12-fact.debit1-fact.debit2-fact.debit3-fact.debit4-;
                fact.debit5-fact.debit6-fact.debit7-fact.debit8-fact.debit9-;
                fact.debit10-fact.debit11-fact.debit12)
        
        sele msup
        appe blank
        repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with tot
        
        
        &&Cash/Credit party  
        sele msup
        seek 'ORDER   ' + '  1' +  mact.ordno
        append blank
        repl aliase with 'ORDER   ',;
             type with 'F',;
             lcode with mact.ordno,;
             sno with 1,;
             remark with substr(msup.remark,1,70)+'R'+substr(msup.remark,72,100)
             
        && Email ID
        sele msup
        append blank
        repl aliase with 'ORDER   ',;
             type with 'F',;
             lcode with mact.ordno,;
             sno with 12,;
             remark with fact.f_email,;
             heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
             
        &&State Code        
        sele msup
        appe blank
        repl type with 'F'
        repl lcode with mact.ordno
        repl sno with 7
        repl pcode with 15
        repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ','09',subs(mact.gstno,1,2))
sele fact
skip
enddo
close data



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Generatl Account Master"
fd=datatransferpath + 'ams'+datatransferpath1+'.'+datatransferext
td=datdev + '\order.'+datext
ts=datdev + '\support.'+datext

sele c
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup

sele a
use &fd alias fact
sele b
use &td alias mact

sele fact
go top
do while !eof()
   sele mact
   append blank
   repl mact.rate with 'N'

   
   do case
   **Bank
   case fact.f_rsche= 1015
      replace mact.scode with 'C1'
   &&Current Assets   
   case fact.f_rsche = 1013
      repl mact.scode with 'C'
   &&Deposit   
   case fact.f_rsche = 1014
      repl mact.scode with 'C3'
   &&Fix Assets   
   case fact.f_rsche = 1010
      repl mact.scode with 'E'
   &&Investment   
   case fact.f_rsche = 1013
      repl mact.scode with 'F'
   &&Loan & Advance (Assets)   
   case fact.f_rsche = 1007
      repl mact.scode with 'C4'
   &&Opening Stock   
   case fact.f_rsche = 1000
      repl mact.scode with 'C5'
   &&Partner Capital   
   case fact.f_rsche = 1006
      repl mact.scode with 'B'
   &&Profit & Loss   
   case fact.f_rsche = 1005
      repl mact.scode with 'J12'
   &&Secured Loan
   case fact.f_rsche = 1008
      repl mact.scode with 'G2'
   &&Sundry Creditor
   case fact.f_rsche = 1009
      repl mact.scode with 'D31'
   &&Sundry Debtors         
   case fact.f_rsche = 1012
      repl mact.scode with 'C6'
   case fact.f_rsche = 1004
      repl mact.scode with 'D32'
   otherwise
      replace mact.scode with 'C6'
      replace mact.rate with old_3
   endcase
   
   repl mact.rate with 'N'
   repl mact.ordno with fact.a_code,;
        mact.parnam  with fact.a_name,;
        mact.paradd with fact.d_address1,;
        mact.paradd2 with fact.city,;
        mact.sthed with  'TIN NO',;
        mact.csthed with 'TIN No.',;
        mact.mailnam with fact.a_name,;
        mact.ref with 'Mr.',;
        mact.phone1 with fact.ph_no_off,;
        mact.confir with fact.p_to_con,;
        mact.price with 'A',;
        mact.city with fact.city,;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        mact.opning with -(fact.op_bal)
        *mact.openingc with -(fact.cp_bal)

        tot = -(fact.op_bal+fact.credit1+fact.credit2+fact.credit3+;
                fact.credit4+fact.credit5+fact.credit6+fact.credit7+;
                fact.credit8+fact.credit9+fact.credit10+fact.credit11+;
                fact.credit12-fact.debit1-fact.debit2-fact.debit3-fact.debit4-;
                fact.debit5-fact.debit6-fact.debit7-fact.debit8-fact.debit9-;
                fact.debit10-fact.debit11-fact.debit12)
                
        sele msup
        appe blank
        repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with tot
                
        
sele fact
skip
enddo
close data



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Customer Opening"
af = datdev + '\pend.'+datext
sele a
use &af alias mpend
zap
af=datdev + '\gledger.'+datext
sele a
use &af alias mpend
zap
af=datdev + '\dis.'+datext
sele a
use &af alias mpend
zap
af=datdev + '\mdis.'+datext
sele a
use &af alias mpend
zap
af = datdev + '\pendings.'+datext
bf = datdev + '\slipno.'+datext
cf = datatransferpath + 'sbt'+datatransferpath1+'.'+datatransferext
sele a
use &af alias mpend
zap
sele b
use &bf alias mslip
sele c
use &cf alias fout
if old_3='Y'
   sele mslip
   go top
   vou  = voucher  + 10
   svou = svoucher + 10
   sele fout
   set filter to substr(f_pcode,1,1) = 'D' .and. f_date < old_5 &&&&&&AND F_PCODE='DVN005' &&&&.and. f_comp=old_7
   go top
   do while ! eof()
      IF F_comp='C' AND transferestimate='N'
         skip 
         loop 
      endif
      if f_comp<>'C' and f_comp#old_7    
         skip 
         loop 
      endif   
      sele mpend
      append blank
      repl mpend.acgroup with 'C6',;
           mpend.ddate with fout.f_date,;
           mpend.vcn with fout.bill_no,;
           mpend.invtype with iif(fout.f_comp=old_7,'O','r'),;
           mpend.duedate with fout.f_date,;
           mpend.duedays with duedate-ddate,;
           mpend.final with fout.bil_tot_am,;
           mpend.balance with (fout.bil_tot_am-fout.f_laspdamt),;
           mpend.itemope with fout.f_laspdamt,;
           mpend.name with fout.bill_no
           if fout.f_comp='C'
              repl mpend.voucher  with vou,;
                   mpend.itempro with svou,;
                   mpend.issueto with fout.f_pcode
           else
              repl mpend.voucher  with vou,;
                   mpend.svoucher with svou,;
                   mpend.ord with fout.f_pcode
           endif
      vou = vou + 5
      svou= svou+ 5
   sele fout
   skip
   enddo
   SELE mslip 
   repl voucher with vou,svoucher with svou
   
   
   close data
   

   wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Supplier Opening"
   af = datdev + '\pendings.'+datext
   bf = datdev + '\slipno.'+datext
   df = datatransferpath + 'pit'+datatransferpath1+'.'+datatransferext
   sele a
   use &af alias mpend
   sele b
   use &bf alias mslip
   vou  = voucher  + 10
   svou = svoucher + 10
   
   sele c
   use &df alias fout
   sele fout
   set filter to substr(c_code,1,1) = 'C' .and. f_recdt < old_5 
   
   go top
   do while !eof()
      IF F_STTYPE='C' AND transferestimate='N'
         skip 
         loop 
      endif
      if F_STTYPE<>'C' and F_STTYPE#old_7    
         skip 
         loop 
      endif   
   
      sele mpend
      append blank
      repl mpend.acgroup with 'D31',;
           mpend.ddate with fout.f_recdt,;
           mpend.vcn with fout.invoice_no,;
           mpend.invtype with iif(fout.f_sttype=old_7,'O','r'),;
           mpend.duedate with fout.f_recdt,;
           mpend.duedays with duedate-ddate,;
           mpend.final with -abs(fout.inv_tot_am),;
           mpend.balance with -abs((fout.inv_tot_am-fout.f_pdamt)),;
           mpend.itemope with -abs(fout.f_pdamt),;
           mpend.name with fout.invoice_no
           if fout.f_sttype='C'
              repl mpend.voucher  with vou,;
                   mpend.itempro with svou,;
                   mpend.issueto with fout.c_code
           else
              repl mpend.voucher  with vou,;
                   mpend.svoucher with svou,;
                   mpend.ord with fout.c_code
           endif
      vou = vou + 5
      svou= svou+ 5
   sele fout
   skip
   enddo

   sele mslip
   repl voucher  with vou + 5
   repl svoucher with svou+ 5
endif
close data



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Inventory Transaction"
*****Import transactionss 

mdis=datdev+ '\mdis.'+datext
af  =datdev + '\gledger.'+datext
bf  =datdev + '\slipno.'+datext
dis =datdev + '\dis.'+datext
pro =datdev + '\pro.'+datext
prb =datdev + '\probat.'+datext
mord=datdev + '\maorder.'+datext
**Sales**
sal=datatransferpath + 'sbt'+datatransferpath1+'.'+datatransferext
sld=datatransferpath + 'spt'+datatransferpath1+'.'+datatransferext
**Sales Challan**
chd=datatransferpath + 'tpt'+datatransferpath1+'.'+datatransferext
**Sales Return**
sgr=datatransferpath + 'rbt'+datatransferpath1+'.'+datatransferext
sgl=datatransferpath + 'rpt'+datatransferpath1+'.'+datatransferext
**Purchase**
pur=datatransferpath + 'pit'+datatransferpath1+'.'+datatransferext
pld=datatransferpath + 'ppt'+datatransferpath1+'.'+datatransferext

sele sele(1)
use &pld 
copy to myppt 
use
**Purchase Return Fresh
pgr=datatransferpath + 'dbt'+datatransferpath1+'.'+datatransferext
pgl=datatransferpath + 'dpt'+datatransferpath1+'.'+datatransferext


sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

sele i
use &bf alias mslip
 
go top
last4  = voucher + 10
slast5 = svoucher + 10

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Sales"
last4 = last4 + 20

sele b
use &mord alias mord
index on scode + substr(parnam+space(25),1,25) to mord

sele f
use &prb alias prb
index on str(code)+mybatch  to prb

sele e
use &pro alias pro
index on name to pro

sele c
use &sal alias sal
sele h
use &sld alias sld
set filt to (f_date>=old_5 and f_date<=old_9) and f_sttype=old_7  &&&f_sttype $ 'F'
    index on dtoc(f_date)+bill_no to sld
sele g
use &dis alias dis
zap
sele d
use &mdis alias mdis
zap

SELE sele(1)
fpro=datatransferpath + 'pms'+datatransferpath1+'.' + datatransferext

  use &fpro alias fpro 
  index on p_code to fpro 
  
SELE SELE(1)
CREATE CURS TMP (CGST  N(10,2))  

*!*	sele sele(1)
*!*	use &myppt alias myppt
*!*	index on p_code+str(f_recsto) to myppt


sele c
set filt to (f_date>=old_5 and f_date<=old_9) and f_comp=old_7 and f_cansel # .t.
go top
do while !eof()
   last1=c.bill_no
   =seek(substr('PRE#$~'+c.f_doct+space(25),1,25),'mord')
   sele d
   appe blank
   repl type with 'S'
   repl misc3 with substr(misc3,1,53)+iif(c.bil_taxabl=0,'T','R')+substr(misc3,55,100)
   repl docu with iif(len(allt(c.f_pcode))>1,substr(c.f_pcode+space(10),1,10)+c.f_name1,space(10)+c.f_name1)
   repl docu1 with substr(mord.form+space(10),1,10)+c.f_doct
   repl vcn with c.bill_no
   repl date with c.f_date
   repl codep with iif(c.f_pcode= 'D     ','STACO3',c.f_pcode)
   repl voucher with last4
   repl account with iif(c.f_cansel=.t.,'C','N')
   last4=last4+5
   repl amountp with (c.bil_tot_am)
   repl salun with ''
   repl staxun with 'SZTZOZ'
try   
*!*	   repl other with iif(substr(c.f_form31,8,1)='C' and c.f_spamt#0,-c.f_spamt,c.f_spamt)
*!*	   repl othun with iif(substr(c.f_form31,8,1)='C' and c.f_spamt#0,substr(c.f_form31,1,6),'')
   repl freight with c.f_dramt  &&&&-c.f_cramt
   repl freun with 'ABRSET'
catch
merror=1
endtry   
   if c.cash_crdt='C'
      repl cash with c.bil_tot_am,;
           round with c.f_round
   else
      repl final with c.bil_tot_am,;
           round with c.f_round
   endif
*!*	   if c.cash_crdt='C'
*!*	      repl cash with c.bil_tot_am-c.f_cramt,;
*!*	           round with c.f_round
*!*	   else
*!*	      repl final with c.bil_tot_am-c.f_cramt,;
*!*	           round with c.f_round
*!*	   endif
   
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl godwon with 'A'
   repl sale with 'Z'   
   repl ltype with iif(old_10='W' ,'2','9')
*!*	   IF c.f_billtype='R'
*!*	*!*	      repl ltype with '9'
*!*	      REPL SALE WITH 'z'
*!*	   endif
         
   repl discafter with 'N',;
        mr with c.f_quot
if c.bil_taxabl=1
*    repl mdis.ltype with '9' 
endif       
   &&Central Sale
   repl misc3 with iif(c.f_billtype='E',substr(misc3,1,64)+'C'+substr(misc3,66),substr(misc3,1,64)+'N'+substr(misc3,66))
   
   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

   sq=0
   dq=0
   df=0
   x=0
   
   sele h
   seek dtoc(c.f_date)+c.bill_no &&last1
   do while dtoc(f_date)+bill_no =dtoc(c.f_date)+c.bill_no and !eof()
     =seek(p_code,'fpro')
      sq=0
      dq=0
      df=0
      msvdis=0
      
try
      MGROSS=val(alltrim(h.s_qnt))*h.f_rate 
      MDISC=MGROSS*h.F_DISC*0.01 
      MCGST=(MGROSS-MDISC)*h.F_CGSTRATE*0.01
catch
merror=1
endtry      
try
      MGROSS=val(alltrim(h.s_qnt))*h.f_rate 
      MDISC=MGROSS*h.F_DISC*0.01 
      MCGST=(MGROSS-MDISC)*(h.F_vatper/2)*0.01
catch
merror=1
endtry
      SELE H
      x=0
      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_expdt,1,2)+'/'
      yy = '20'+substr(h.f_expdt,4,2)
      edt= ctod(dd+mm+yy)
      **Deal Calculation
      if at('+',h.f_qnt)>0
         x=at('+',h.f_qnt)
         sq = val(h.s_qnt)
         dq = val(substr(h.f_qnt,1,x-1))
         df = val(substr(h.f_qnt,x+1,8))
      else
         if at('%',h.f_qnt)>0
            sq = val(h.s_qnt)
            dq = round(( (100*100)/(val(h.f_qnt)*100)),0)-1
            df = 1
         else
            sq = val(h.s_qnt)
            dq = val(h.s_qnt)
            msvdis=val(alltrim(h.f_qnt))
            df =0 
         endif   
      endif
      last=substr(h.p_code+space(10),1,10)
      
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif      
*!*	IF !FOUND()
*!*	?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 1"
*!*	WAIT
*!*	ENDIF
      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.vcn
      repl date with d.date
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl free with iif(at('+',h.f_qnt)>0 .or. at('%',h.f_qnt)>0,0,iif(msvdis#0,val(alltrim(h.f_qnt)),0))
      repl exp with edt
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
  if transferestimate='Y'  and  h.f_sttype='C'
    repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
  else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
  endif
endif

      repl misc4 with substr(misc4,1,14)+'M'+substr(misc4,16,100)
      repl rate with h.f_rate &&&iif(old_10='R',h.f_mrp,h.f_rate)
IF old_10='R'      
      if ROUND(H.F_RATE*VAL(H.S_QNT),2)>h.amount
      repl disc1 with h.f_disc   
      endif
         
else
      repl disc1 with h.f_disc
      repl disc2 with h.f_disc2 
endif      
*!*	      IIF(h.F_DISC2#0,h.f_disc2,H.F_SCH1)
TRY      
      REPL svdis with H.f_SCH1
      repl misc4 with subs(misc4,1,43)+'U'+subs(misc4,45)
CATCH
ENDTRY
*!*	     IF OLD_10='R'
*!*	        repl rate with h.f_rate
*!*	     endif     
      repl sssc with 0
      repl ssex with 0
      repl mrp with h.f_mrp
if lotrate='Y'      
      repl rsm with h.f_qnt
endif      
      repl half with 'A'
      repl godwon with d.godwon
      
      &&Tax
try      
      if c.f_billtype='E'      
         repl ssta with h.f_igstrate,;
              sssc with 0,;
              cessinrs with 0
      else
         repl ssta with h.f_sgstrate,;
              cgst with h.f_cgstrate
      endif
catch
merror=1
endtry      
         
      if h.f_whattodo = 'R'
         repl flg with 'R'
      else
         if h.f_whattodo $ 'FN'
            repl flg with 'G'
         endif
      endif
      if at('%',h.f_qnt)>0
         repl deal with dq,freedeal with df
      else
          if at('+',h.f_qnt)>0    
             repl deal with dq,freedeal with df
          else                 
             repl deal with dq,freedeal with df
          endif          
      endif    
*!*	try      
*!*	      if msvdis#0 AND MCGST#H.F_CGST
*!*	        *repl svdis with val(h.f_qnt)*IIF(e.pack=0,1,E.PACK)
*!*	        repl misc4 with subs(misc4,1,43)+'U'+subs(misc4,45)
*!*	      endif
*!*	catch
*!*	merror=1
*!*	endtry      
      IF H.BILL_NO='N00014' 
*!*	        ?SVDIS,VCN,RATE,QTY

*!*	        WAIT
      ENDIF     
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4+5
repl svoucher with slast5+4 

close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Challan"
last4 = last4 + 20
sele sele(1)
use &datdev\slipno.&datext alias mslip 
sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb


sele e
use &pro alias pro
index on name to pro

sele h
use &chd alias chd
pack
set filt to  (f_date>=old_5 and f_date<=old_9) and F_sttype=old_7
index on dtos(f_date) to chd
copy to chl.dbf

sele c
use chl.dbf alias chl
pack
index on dtos(f_date) to chl unique

sele g
use &dis alias dis
sele d
use &mdis alias mdis
sele c
set filt to (f_date>=old_5 and f_date<=old_9)
go top

do while ! eof()
   last1=dtos(c.f_date)
   sele d
   appe blank
   repl type with 'L'
   repl misc3 with substr(misc3,1,53)+'R'+substr(misc3,55,100)
   repl challan with last1
   repl chdate with c.f_date
   repl codep with 'STACex'
   repl voucher with last4
   last4=last4+5
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl godwon with 'A'
   repl sale with 'Z'   
   repl ltype with iif(old_10='W','2','C')
   repl discafter with 'N'
   repl remark4 with c.bill_no
   
   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek last1
   do while ! eof() and dtos(f_date) = last1
      sq=0
      dq=0
      df=0
      x=0
      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_expdt,1,2)+'/'
      yy = '20'+substr(h.f_expdt,4,2)
      edt= ctod(dd+mm+yy)
      **Deal Calculation
      if at('+',h.f_qnt)>0
         x=at('+',h.f_qnt)
         sq = val(h.s_qnt)
         dq = val(substr(h.f_qnt,1,x-1))
         df = val(substr(h.f_qnt,x+1,8))
      else
         if at('%',h.f_qnt)>0
            sq = val(h.s_qnt)
            dq = round(( (100*100)/(val(h.f_qnt)*100)),0)-1
            df = 1
         else
            sq = val(h.s_qnt)
            dq = val(h.s_qnt)
            df = val(alltrim(h.f_qnt))
         endif   
      endif
      last=substr(h.p_code+space(10),1,10)
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
*!*	IF !FOUND()
*!*	?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 2"
*!*	WAIT
*!*	ENDIF


      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif
      =seek(last,'pro')
      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.challan
      repl date with d.chdate
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with abs(val(h.s_qnt))
      repl free with iif(at('+',h.f_qnt)>0 .or. at('%',h.f_qnt)>0,0,abs(val(alltrim(h.f_qnt))))      
      repl pack with iif(old_10='R',iif(f.pack=1,0,f.pack),0) &&&e.pack)*!*	&&      repl batch with iif(batchfound=.t.,f.batchno,iif(h.f_sttype='F',h.bat_no,old_8+alltrim(h.bat_no)))
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif
      repl misc4 with substr(misc4,1,14)+'M'+substr(misc4,16,100)
      repl rate with iif(old_10='R',h.f_mrp,h.f_rate)
      repl disc1 with h.f_disc
      repl sssc with 0
      repl ssex with 0
      repl mrp with iif(old_10='R',h.f_mrp,h.f_rate)
      repl half with 'A'
      repl godwon with d.godwon
      repl rsm with h.f_qnt
      if val(h.s_qnt) > 0
         repl flg with 'G'
      else
         if val(h.s_qnt) < 0
            repl flg with 'R'
         endif
      endif
      if at('%',h.f_qnt)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_qnt)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
      
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4 

close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Stock Less (Estimate)"
sele sele(1)
use &datdev\slipno.&datext alias mslip 
last4 = last4 + 20
sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb


sele e
use &pro alias pro
index on name to pro

sele c
use &sal alias sal
sele h
use &sld alias sld
index on dtoc(f_date) + bill_no to sld

sele g
use &dis alias dis
sele d
use &mdis alias mdis

sele c
set filt to (f_date>=old_5 and f_date<=old_9) and f_comp='C' and old_7='F'  and c.f_cansel#.t.        &&and f_billtype = 'N'
go top
do while ! eof()
   last1=c.bill_no
   last9=dtoc(c.f_date)
   sele d
   appe blank
   repl type with 'L'
   repl misc3 with substr(misc3,1,53)+iif(c.bil_taxabl=0,'T','R')+substr(misc3,55,100)
   repl challan with c.bill_no
   repl chdate with c.f_date
   repl codep with iif(c.f_pcode= 'D     ','STACO3',c.f_pcode)
   repl voucher with last4
   repl account with iif(c.f_cansel=.t.,'C','N')
   last4=last4+5
   repl amountp with (c.bil_tot_am)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl other with iif(substr(c.f_form31,8,1)='C' and c.f_spamt#0,-c.f_spamt,c.f_spamt)
   repl othun with iif(substr(c.f_form31,8,1)='C' and c.f_spamt#0,substr(c.f_form31,1,6),'')
   repl freight with c.f_dramt-c.f_cramt
   repl freun with 'ABRSET'
   if c.cash_crdt='C'
      repl cash with c.bil_tot_am,;
           round with c.f_round
   else
      repl final with c.bil_tot_am,;
           round with c.f_round
   endif
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl godwon with 'A'
   repl sale with 'Z'
   repl ltype with iif(old_10='W','2','C')
   repl discafter with 'N'
   repl remark4 with c.bill_no
   &&Central Sale
   repl misc3 with iif(c.f_billtype='E',substr(misc3,1,64)+'C'+substr(misc3,66),substr(misc3,1,64)+'N'+substr(misc3,66))
   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek last9 + last1
   do while h.bill_no = last1 and dtoc(h.f_date) = last9 and !eof()
     if f_sttype#'C'
        skip 
        loop 
     endif     &&&&By Santosh   
      sq=0
      dq=0
      df=0
      x=0

      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_expdt,1,2)+'/'
      yy = '20'+substr(h.f_expdt,4,2)
      edt= ctod(dd+mm+yy)
      **Deal Calculation
      if at('+',h.f_qnt)>0
         x=at('+',h.f_qnt)
         sq = val(h.s_qnt)
         dq = val(substr(h.f_qnt,1,x-1))
         df = val(substr(h.f_qnt,x+1,8))
      else
         if at('%',h.f_qnt)>0
            sq = val(h.s_qnt)
            dq = round(( (100*100)/(val(h.f_qnt)*100)),0)-1
            df = 1
         else
            sq = val(h.s_qnt)
            dq = val(h.s_qnt)
            df = val(alltrim(h.f_qnt))
         endif   
      endif

      last=substr(h.p_code+space(10),1,10)
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
*!*	IF !FOUND()
*!*	?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 3"
*!*	WAIT
*!*	ENDIF

      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif
      =seek(last,'pro')
      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.challan
      repl date with d.chdate
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl free with iif(at('+',h.f_qnt)>0 .or. at('%',h.f_qnt)>0,0,val(alltrim(h.f_qnt)))
repl pack with iif(old_10='R',iif(f.pack=1,0,f.pack),0) &&&e.pack)      repl exp with edt
*      repl batch with iif(batchfound=.t.,f.batchno,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)))
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif

      repl misc4 with substr(misc4,1,14)+'P'+substr(misc4,16,100)
      repl rate with iif(old_10='R',h.f_mrp,h.f_rate)
      repl disc1 with h.f_disc
      repl disc2 with h.f_disc2
      repl sssc with 0
      repl ssex with 0
      repl mrp with h.f_mrp
      repl rsm with h.f_qnt
      repl half with 'A'
      repl godwon with d.godwon
      
      &&Tax
      if c.f_billtype='E'      
         repl ssta with h.f_igstrate,;
              sssc with 0,;
              cessinrs with 0
      else
         repl ssta with h.f_cgstrate/2,;
              cgst with h.f_cgstrate/2
      endif         
      
      if h.f_whattodo = 'R'
         repl flg with 'R'
      else
         if h.f_whattodo $ 'FN'
            repl flg with 'G'
         endif
      endif
      if at('%',h.f_qnt)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_qnt)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
      
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4
close data



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Sales Return Challan (G/R Received from customer Credit Note not Generated"
sele sele(1)
use &datdev\slipno.&datext alias mslip 
repl voucher with last4 

last4 = last4 + 20

*!*	sal=datatransferpath + 'sbt'+datatransferpath1+'.'+datatransferext
*!*	sld=datatransferpath + 'spt'+datatransferpath1+'.'+datatransferext
*!*	**Sales Challan**
*!*	chd=datatransferpath + 'tpt'+datatransferpath1+'.'+datatransferext
*!*	**Sales Return**
*!*	sgr=datatransferpath + 'rbt'+datatransferpath1+'.'+datatransferext
*!*	sgl=datatransferpath + 'rpt'+datatransferpath1+'.'+datatransferext
*!*	**Purchase**
*!*	pur=datatransferpath + 'pit'+datatransferpath1+'.'+datatransferext
*!*	pld=datatransferpath + 'ppt'+datatransferpath1+'.'+datatransferext
*!*	**Purchase Return Fresh
*!*	pgr=datatransferpath + 'dbt'+datatransferpath1+'.'+datatransferext
*!*	pgl=datatransferpath + 'dpt'+datatransferpath1+'.'+datatransferext

sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb


sele e
use &pro alias pro
index on name to pro

sele h
use &sgl alias sgl
pack
set filt to !empty(f_pcode) and (f_date <=old_9) and empty(f_crnote)  &&&&BY SANTOSH 
index on f_rptno + dtoc(f_date) to sgl

**Sale Return Challan (SRC.DBF)
copy to src.dbf

sele c
use src.dbf alias sgr
pack
index on f_rptno + dtoc(f_date) to sgr unique

sele g
use &dis alias dis
sele d
use &mdis alias mdis

sele c
go top
do while ! eof()
   IF F_STTYPE#OLD_7
     SKIP 
     LOOP 
   ENDIF   
   last1=c.f_rptno
   sele d
   appe blank
   repl type with 'W'
   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
   repl challan with last1
   repl chdate with iif(c.f_date < old_5,old_5,c.f_date)
   repl codep with c.f_pcode
   repl voucher with last4
   last4=last4+5
   repl amountp with (c.amount)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl final with c.amount
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl godwon with 'A'
   repl sale with 'Z'
   repl ltype with iif(old_10='W','2','C')
   repl discafter with 'N'
   repl remark4 with last1


   sq=0
   dq=0
   df=0
   x=0
XfINAL=0   
   sele h
   seek last1 + dtoc(c.f_date)
   do while h.f_rptno = last1 and dtoc(h.f_date) = dtoc(c.f_date) and !eof() 
      sq=0
      dq=0
      df=0
      x=0
      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_exp,1,2)+'/'
      yy = '20'+substr(h.f_exp,4,2)
      edt= ctod(dd+mm+yy)

      **Deal Calculation
      if at('+',h.f_qnt)>0
         x=at('+',h.f_qnt)
         sq = h.s_qnt
         dq = val(substr(h.f_qnt,1,x-1))
         df = val(substr(h.f_qnt,x+1,8))
      else
         if at('%',h.f_qnt)>0
            sq = h.s_qnt
            dq = round(( (100*100)/(val(h.f_qnt)*100)),0)-1
            df = 1
         else
            sq = h.s_qnt
            dq = h.s_qnt
            df = val(alltrim(h.f_qnt))
         endif   
      endif

      last=substr(h.p_code+space(10),1,10)
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      sele pro
      seek last
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
*!*	IF !FOUND()
*!*	?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 4"
*!*	WAIT
*!*	ENDIF

      
      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif
      =seek(last,'pro')

      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.challan
      repl date with d.chdate
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl free with iif(at('+',h.f_qnt)>0 .or. at('%',h.f_qnt)>0,0,val(alltrim(h.f_qnt)))
repl pack with iif(old_10='R',iif(f.pack=1,0,f.pack),0) &&&e.pack)      repl exp with edt
*      repl batch with iif(batchfound=.t.,f.batchno,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)))
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif
      if h.f_stat $ 'EBNDSQRLU'
         repl flg with 'W'
      else
         if h.f_stat = 'F'
            repl flg with 'R'
         endif
      endif
      repl rate with iif(old_10='R',h.f_mrp,h.f_rate)
      repl disc1 with h.f_sdisc
      repl sssc with 0
      repl ssex with 0
      repl mrp with h.f_mrp
      repl rsm with h.f_qnt
      repl half with 'A'
      repl godwon with d.godwon
      if h.f_tax='Y' 
         repl ssta with h.f_sgstrate
         repl cgst with h.f_cgstrate
      endif
      
      &&For Privious Year Return Challan Should be in Rate Diff
      if h.f_date < old_5
         repl flg with 'X'
         repl supplied with 'O'
         repl flag with '5'
      endif
      if at('%',h.f_qnt)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_qnt)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
   sele h
   xfinal=xfinal+h.amount
   skip
   enddo
sele mdis
repl final with xfinal
   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

sele c
skip
enddo
sele mslip 
repl voucher with last4
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Return Challan (G/R Received from customer Credit Note Generated but Not Adjusted in Bill"
last4 = last4 + 20
sele sele(1)
use &datdev\slipno.&datext alias mslip 

sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 
sele f
use &prb alias prb
index on str(code)+mybatch  to prb

sele e
use &pro alias pro
index on name to pro
sele h
use &sgl alias sgl
pack
index on str(f_crnote,5) + dtoc(f_crdate) to sgl
sele c
use &sgr alias sgr
pack
index on str(f_crnote,5) + dtoc(f_date) to sgr
sele g
use &dis alias dis
sele d
use &mdis alias mdis
sele c
set filt to (f_date <=old_9) and !empty(f_crnote) &&&&&and empty(f_adjbill)
go top
do while !eof()
if F_Comp#Old_7
   skip 
   loop
endif      
   last1=str(c.f_crnote,5)
   l1  = alltrim(str(c.f_crnote))
   l2  = len(l1)
   l3  = 'R-'+replicate('0',5-l2)+l1       
   sele d
   appe blank
   repl type with 'W'
   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
   
if C.F_Acrnote='A'  &&&empty(c.f_adjbill)   
   repl vcn with l3
   repl Date with iif(c.f_date < old_5,old_5,c.f_date)
else

   repl challan with l3
   repl chdate with iif(c.f_date < old_5,old_5,c.f_date)

endif   
   
   repl codep with c.f_pcode
   repl voucher with last4
   last4=last4+5
   repl amountp with (c.amount)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl final with c.f_totamt
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl sale with 'Z'
   repl godwon with 'A'
   repl sale with 'Z'
   repl ltype with iif(old_10='W','2','C')
   repl discafter with 'N'
   repl remark4 with last1
   repl crnorem with c.f_adjbill 
   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek last1 + dtoc(c.f_date)
   do while str(h.f_crnote,5) = last1 and dtoc(h.f_crdate) = dtoc(c.f_date) and !eof() 
      sq=0
      dq=0
      df=0
      x=0
      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_exp,1,2)+'/'
      yy = '20'+substr(h.f_exp,4,2)
      edt= ctod(dd+mm+yy)
      **Deal Calculation
      if at('+',h.f_qnt)>0
         x=at('+',h.f_qnt)
         sq = h.s_qnt
         dq = val(substr(h.f_qnt,1,x-1))
         df = val(substr(h.f_qnt,x+1,8))
      else
         if at('%',h.f_qnt)>0
            sq = h.s_qnt
            dq = round(( (100*100)/(val(h.f_qnt)*100)),0)-1
            df = 1
         else
            sq = h.s_qnt
            dq = h.s_qnt
            df = val(alltrim(h.f_qnt))
         endif   
      endif

      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
*!*	IF !FOUND()
*!*	?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 5"
*!*	WAIT
*!*	ENDIF

      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif

      
      sele g
      appe blank
      repl codep with d.codep
      repl vcn with iif(day(mdis.date)=0,d.challan,d.vcn)
      repl date with iif(day(mdis.date)=0,d.chdate,mdis.date)
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl free with iif(at('+',h.f_qnt)>0 .or. at('%',h.f_qnt)>0,0,val(alltrim(h.f_qnt)))
repl pack with iif(old_10='R',iif(f.pack=1,0,f.pack),0) &&&e.pack)      repl exp with edt
 *     repl batch with iif(batchfound=.t.,f.batchno,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)))
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif

      if h.f_stat $ 'EBNDSQRLU'
         repl flg with 'W'
      else
         if h.f_stat = 'F'
            repl flg with 'R'
         endif
      endif
      repl rate with iif(old_10='R',h.f_mrp,h.f_rate)
      repl disc1 with h.f_sdisc
      repl sssc with 0
      repl ssex with 0
      repl mrp with h.f_mrp
      repl rsm with h.f_qnt
      repl half with 'A'
      repl godwon with d.godwon
      if h.f_tax='Y' 
         repl ssta with h.f_sgstrate
         repl cgst with h.f_cgstrate
      endif
      
      &&For Privious Year Return Challan Should be in Rate Diff
      if h.f_date < old_5
         repl flg with 'X'
         repl supplied with 'O'
         repl flag with '5'
      endif
      if at('%',h.f_qnt)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_qnt)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
         
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4,svoucher with slast5
close data


wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase Challan"
sele sele(1)
use &datdev\slipno.&datext alias mslip 
sele mslip
last4 = voucher + 20
slast5=svoucher+4
sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb


sele e
use &pro alias pro
index on name to pro


sele h
use &pld alias pld
pack
set filt to (f_recdt >=old_5 and f_recdt <=old_9) and invoice_no = '#Blank         ' and F_sttype=old_7
copy to phl
index on f_pcode + dtos(f_recdt) to pld


sele c
use phl alias phl
pack
index on f_pcode + dtos(f_recdt) to phl unique

sele g
use &dis alias dis
sele d
use &mdis alias mdis
sele c
go top
do while ! eof()
   last1=dtos(c.f_recdt)
   sele d
   appe blank
   repl type with 'P'
   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
   repl challan with last1
   repl chdate with c.f_recdt
   repl pm with last1
   repl lrda with c.f_recdt
   repl codep with c.f_pcode
   repl voucher with last4
   last4=last4+5
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl godwon with 'A'
   repl sale with iif(old_10='W','Z','z')
   repl ltype with '2'
   repl discafter with 'N'
   repl remark4 with c.invoice_no

   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek c.f_pcode + last1
   do while h.f_pcode = c.f_pcode and dtos(f_recdt) = last1 and !eof()
      sq=0
      dq=0
      df=0
      x=0

      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_expdt,1,2)+'/'
      yy = '20'+substr(h.f_expdt,4,2)
      edt= ctod(dd+mm+yy)

      **Deal Calculation
      if at('+',h.f_pdeal)>0
         x=at('+',h.f_pdeal)
         sq = h.p_qnt
         dq = val(substr(h.f_pdeal,1,x-1))
         df = val(substr(h.f_pdeal,x+1,8))
      else
         if at('%',h.f_pdeal)>0
            sq = h.p_qnt
            dq = round(( (100*100)/(val(h.f_pdeal)*100)),0)-1
            df = 1
         else
            sq = h.p_qnt
            dq = h.p_qnt
            df = val(alltrim(h.f_pdeal))
         endif   
      endif

      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      last=substr(h.p_code+space(10),1,10)
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
IF !FOUND()
?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 6"
WAIT
ENDIF

      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif
      

      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.challan
      repl date with d.chdate
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl pack with iif(old_10='R',iif(val(h.p_packing)=1,0,val(h.p_packing)),0) &&&&&&e.pack)
      repl exp with edt
*!*	      repl batch with iif(batchfound=.f.,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)),f.batchno)
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif

      repl free with iif(at('+',h.f_pdeal)>0 .or. at('%',h.f_pdeal)>0,0,val(alltrim(h.f_pdeal)))
      repl flg with 'P'
      repl rate with h.f_strate
      repl disc1 with h.f_disc_bef
      repl disc2 with h.f_disc_aft
      repl mrp with h.f_mrp
      repl rsm with h.f_pdeal
      repl half with 'A'
      repl godwon with d.godwon

      &&Tax
      if c.f_exup='E'      
         repl ssta with h.f_igstrate,;
              sssc with 0,;
              cessinrs with 0
      else
         repl ssta with h.f_sgstrate,;
              cgst with h.f_cgstrate
      endif
      if at('%',h.f_pdeal)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_pdeal)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4,svoucher with slast5
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase"
sele sele(1)
use &datdev\slipno.&datext alias mslip 
sele mslip
last4 = voucher + 20
slast5=svoucher+4

sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb


sele e
use &pro alias pro
index on name to pro

sele c
use &pur alias pur
sele h
use &pld alias pld
set filt to (f_recdt >=old_5 and f_recdt <=old_9) and f_sttype=old_7
index on STR(f_rec_pit)+F_PCODE to pld



sele g
use &dis alias dis
sele d
use &mdis alias mdis
sele c
set filt to (f_recdt >=old_5 and f_recdt <=old_9) and f_sttype=old_7
go top
do while ! eof()
   u1 = alltrim(str(c.f_rec_pit,8))
   u2 = len(alltrim(u1))
   u3 = replicate('0',8-u2)+u1
   last1=c.f_rec_pit
   sele d
   appe blank
   repl type with 'P'
   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
   repl vcn with u3
   repl date with c.f_recdt
   repl pm with c.invoice_no
   repl lrda with c.inv_date
   repl codep with c.c_code
   repl voucher with last4
   last4=last4+5
   repl amountp with (c.inv_tot_am)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl other with -c.f_dramt+c.f_cramt-c.f_cashdisc
   repl freight with c.f_freight
   if c.f_csdr='C'
      repl cash with c.inv_tot_am,;
           round with c.inv_adj_am
   else
      repl final with c.inv_tot_am,;
           round with c.inv_adj_am
   endif
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl account with 'N'
   repl godwon with 'A'
   repl sale with iif(old_10='R','z','Z')
   repl ltype with '2'
   repl discafter with 'N'
   repl remark4 with pm
   repl misc3 with iif(c.f_exup='E',substr(misc3,1,64)+'C'+substr(misc3,66),substr(misc3,1,64)+'N'+substr(misc3,66))
      
   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek STR(C.F_REC_PIT)+C.C_CODE
   do while !eof() and STR(h.f_rec_pit)+F_PCODE =STR(C.F_REC_PIT)+C.C_CODE
*!*	      IF F_NORMAL#'N'
*!*	         skip 
*!*	         loop 
*!*	      endif   
      sq=0
      dq=0
      df=0
      x=0
      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_expdt,1,2)+'/'
      yy = '20'+substr(h.f_expdt,4,2)
      edt= ctod(dd+mm+yy)

      **Deal Calculation
      if at('+',h.f_pdeal)>0
         x=at('+',h.f_pdeal)
         sq = h.p_qnt
         dq = val(substr(h.f_pdeal,1,x-1))
         df = val(substr(h.f_pdeal,x+1,8))
      else
         if at('%',h.f_pdeal)>0
            sq = IIF(H.P_QNT=0,h.pur_qnt,h.p_qnt)
            dq = round(( (100*100)/(val(h.f_pdeal)*100)),0)-1
            df = 1
         else
            sq = IIF(H.P_QNT=0,h.pur_qnt,h.p_qnt)
            dq = IIF(H.P_QNT=0,h.pur_qnt,h.p_qnt)
            df = val(alltrim(h.f_pdeal))
         endif   
      endif

      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
IF !FOUND()
?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 7"
WAIT
ENDIF

      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif
      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.vcn
      repl date with d.date
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
IF OLD_10='R'
      repl pack with E.PACK &&&0
else            
      repl pack with iif(old_10='R',iif(val(h.p_packing)=1,0,val(h.p_packing)),0) &&&&e.pack)
endif      
      repl exp with edt
*!*	      repl batch with iif(batchfound=.f.,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)),f.batchno)
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif

     if  h.f_normal='R'
      repl free with sq
      repl qty with 0
     
     ELSE
       repl free with iif(at('+',h.f_pdeal)>0 .or. at('%',h.f_pdeal)>0,0,val(alltrim(h.f_pdeal)))
     endif
      repl flg with 'P'
      repl rate with h.f_strate
      repl disc1 with h.f_disc_bef
      repl disc2 with h.f_disc_aft
      repl mrp with h.f_mrp
      repl rsm with h.f_pdeal
      repl half with 'A'
      repl godwon with d.godwon
      if at('%',h.f_pdeal)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_pdeal)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
IF H.F_normal='F'
    repl free with free+qty 
    repl qty with  0 
endif    
      &&Tax
try      
      if c.f_exup='E'      
         repl ssta with h.f_igstrate,;
              sssc with 0,;
              cessinrs with 0
      else
         repl ssta with h.f_sgstrate,;
              cgst with h.f_cgstrate
      endif
catch
merror=1
endtry      
*!*	try      
*!*	      if c.f_exup='E'      
*!*	         repl ssta with h.f_vatper,;
*!*	              sssc with 0,;
*!*	              cessinrs with 0
*!*	      else
*!*	         repl ssta with h.f_vatper/2,;
*!*	              cgst with h.f_vatper/2
*!*	      endif
*!*	catch
*!*	merror=1
*!*	endtry      

   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4,svoucher with slast5
close data



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase Estimate"
sele sele(1)
use &datdev\slipno.&datext alias mslip 
sele mslip
last4 = voucher + 20
slast5=svoucher+4
sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb


sele e
use &pro alias pro
index on name to pro


sele c
use &pur alias pur
sele h
use &pld alias pld
set filt to (f_recdt >=old_5 and f_recdt <=old_9) and f_sttype='C' and old_7='F'
index on f_rec_pit to pld

sele g
use &dis alias dis
sele d
use &mdis alias mdis
sele c
set filt to (f_recdt >=old_5 and f_recdt <=old_9) and f_sttype='C' and old_7='F'
go top

do while ! eof()
   u1 = alltrim(str(c.f_rec_pit,8))
   u2 = len(alltrim(u1))
   u3 = replicate('0',8-u2)+u1

   last1=c.f_rec_pit

   sele d
   appe blank
   repl type with 'D'
   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
   repl challan with u3
   repl chdate with c.f_recdt
   repl pm with c.invoice_no
   repl lrda with c.inv_date
   repl codep with c.c_code
   repl voucher with last4
   last4=last4+5
   repl amountp with (c.inv_tot_am)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl other with -c.f_dramt+c.f_cramt-c.f_cashdisc
   repl freight with c.f_freight   
   if c.f_csdr='C'
      repl cash with c.inv_tot_am,;
           round with c.inv_adj_am
   else
      repl final with c.inv_tot_am,;
           round with c.inv_adj_am
   endif
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl account with 'N'
   repl godwon with 'A'
   repl sale with iif(old_10='R','z','Z')   
   repl ltype with '2'
   repl discafter with 'N'
   repl remark4 with pm
   repl misc3 with iif(c.f_exup='E',substr(misc3,1,64)+'C'+substr(misc3,66),substr(misc3,1,64)+'N'+substr(misc3,66))

   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek last1
   do while !eof() and h.f_rec_pit = last1
      sq=0
      dq=0
      df=0
      x=0

      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_expdt,1,2)+'/'
      yy = '20'+substr(h.f_expdt,4,2)
      edt= ctod(dd+mm+yy)

      **Deal Calculation
      if at('+',h.f_pdeal)>0
         x=at('+',h.f_pdeal)
         sq = h.p_qnt
         dq = val(substr(h.f_pdeal,1,x-1))
         df = val(substr(h.f_pdeal,x+1,8))
      else
         if at('%',h.f_pdeal)>0
            sq = h.p_qnt
            dq = round(( (100*100)/(val(h.f_pdeal)*100)),0)-1
            df = 1
         else
            sq = h.p_qnt
            dq = h.p_qnt
            df = val(alltrim(h.f_pdeal))
         endif   
      endif

      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
*!*	IF !FOUND()
*!*	?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 8"
*!*	WAIT
*!*	ENDIF

      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif
      


      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.challan
      repl date with d.chdate
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl free with iif(at('+',h.f_pdeal)>0 .or. at('%',h.f_pdeal)>0,0,val(alltrim(h.f_pdeal)))
      repl pack with iif(old_10='R',iif(val(h.p_packing)=1,0,val(h.p_packing)),0)
      repl exp with edt
*!*	      repl batch with iif(batchfound=.f.,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)),f.batchno)
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif

      repl free with iif(at('+',h.f_pdeal)>0 .or. at('%',h.f_pdeal)>0,0,val(alltrim(h.f_pdeal)))
      repl flg with 'D'
      repl rate with h.f_strate
      repl disc1 with h.f_disc_bef
      repl disc2 with h.f_disc_aft
      repl mrp with h.f_mrp
      repl rsm with h.f_pdeal
      repl half with 'A'
      repl godwon with d.godwon
      if at('%',h.f_pdeal)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_pdeal)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
      
      &&Tax
      if c.f_exup='E'      
         repl ssta with h.f_igstrate,;
              sssc with 0,;
              cessinrs with 0
      else
         repl ssta with h.f_sgstrate,;
              cgst with h.f_cgstrate
      endif
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4,svoucher with slast5
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase Return (Fresh)"
sele sele(1)
use &datdev\slipno.&datext alias mslip 
sele mslip
last4 = voucher + 20
slast5=svoucher+4

sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb


sele e
use &pro alias pro
index on name to pro

sele c
use &pgr alias pgr
sele h
use &pgl alias pgl
set filt to (f_date>=old_5 and f_date<=old_9)  and f_sttype=old_7
index on bill_no to pgl

sele g
use &dis alias dis
sele d
use &mdis alias mdis

sele c
set filt to (f_date>=old_5 and f_date<=old_9) and f_sttype=old_7
go top

do while ! eof()
if f_cansel=.t.
   skip 
   loop 
endif   
   last1=c.bill_no

   sele d
   appe blank
   repl type with 'B'
   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
   repl challan with last1
   repl chdate with c.f_date
   repl codep with c.f_pcode
   repl voucher with last4
   last4=last4+5
   repl amountp with (c.inv_tot_am)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl final with c.inv_tot_am
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl godwon with 'A'
   repl sale with iif(old_10='R','z','Z')
   repl ltype with '2'
   repl discafter with 'N'
   repl remark4 with last1


   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek last1
   do while ! eof() and h.bill_no = last1
      sq=0
      dq=0
      df=0
      x=0

      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_expdt,1,2)+'/'
      yy = '20'+substr(h.f_expdt,4,2)
      edt= ctod(dd+mm+yy)

      **Deal Calculation
      if at('+',h.f_pdeal)>0
         x=at('+',h.f_pdeal)
         sq = val(allt(h.p_qnt))
         dq = val(substr(h.f_pdeal,1,x-1))
         df = val(substr(h.f_pdeal,x+1,8))
      else
         if at('%',h.f_pdeal)>0
            sq = val(allt(h.p_qnt))
            dq = round(( (100*100)/(val(h.f_pdeal)*100)),0)-1
            df = 1
         else
            sq = val(allt(h.p_qnt))
            dq = val(allt(h.p_qnt))
            df = val(alltrim(h.f_pdeal))
         endif   
      endif

      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
*!*	IF !FOUND()
*!*	?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 9"
*!*	WAIT
*!*	ENDIF
      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif

      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.challan
      repl date with d.chdate
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl free with iif(at('+',h.f_pdeal)>0 .or. at('%',h.f_pdeal)>0,0,val(alltrim(h.f_pdeal)))      
      repl pack with iif(old_10='R',iif(f.pack=1,0,f.pack),0)      
      repl exp with edt
*!*	      repl batch with iif(batchfound=.f.,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)),f.batchno)
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif

      repl flg with 'B'
      repl rate with h.f_strate
      repl disc1 with h.f_disc_bef
      repl ssta with h.f_sgstrate
      repl cgst with h.f_cgstrate
      repl ssex with h.f_exdper
      repl mrp with h.f_mrp
      repl rsm with h.f_pdeal
      repl half with 'A'
      repl godwon with d.godwon
      if at('%',h.f_pdeal)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_pdeal)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4,svoucher with slast5

close data



*!*	wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase Return (Fresh) Estimate"
*!*	last4 = last4 + 20
*!*	sele j
*!*	use &datdev\support.&datext alias support
*!*	index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

*!*	sele f
*!*	use &prb alias prb
*!*	index on mycode to prb

*!*	sele e
*!*	use &pro alias pro
*!*	index on name to pro

*!*	sele h
*!*	use &pgl alias pgl
*!*	set filt to (f_date>=old_5 and f_date<=old_9)  and f_sttype='C' and old_7='F'
*!*	index on bill_no to pgl

*!*	sele c
*!*	use &pgr alias pgr
*!*	sele g
*!*	use &dis alias dis
*!*	sele d
*!*	use &mdis alias mdis

*!*	sele c
*!*	set filt to (f_date>=old_5 and f_date<=old_9) and f_sttype=old_7
*!*	go top

*!*	do while !eof()
*!*	   last1=c.bill_no

*!*	   sele d
*!*	   appe blank
*!*	   repl type with 'L'
*!*	   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
*!*	   repl challan with last1
*!*	   repl chdate with c.f_date
*!*	   repl codep with c.f_pcode
*!*	   repl voucher with last4
*!*	   last4=last4+5
*!*	   repl amountp with (c.inv_tot_am)
*!*	   repl salun with ''
*!*	   repl staxun with 'SZTZOZ'
*!*	   repl final with c.inv_tot_am
*!*	   if final=0 and cash#0
*!*	      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
*!*	   else
*!*	      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
*!*	   endif
*!*	   repl duedays with 0
*!*	   repl lrda with c.f_date
*!*	   repl account with 'N'
*!*	   repl godwon with 'A'
*!*	   repl sale with iif(old_10='R','z','Z')
*!*	   repl ltype with '2'
*!*	   repl discafter with 'N'
*!*	   repl remark4 with last1

*!*	   sele support
*!*	   appe blank
*!*	   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

*!*	   sq=0
*!*	   dq=0
*!*	   df=0
*!*	   x=0
*!*	   sele h
*!*	   seek last1
*!*	   do while ! eof() and h.bill_no = last1
*!*	      sq=0
*!*	      dq=0
*!*	      df=0
*!*	      x=0

*!*	      **Exp Date
*!*	      dd = '27'+'/'
*!*	      mm = substr(h.f_expdt,1,2)+'/'
*!*	      yy = '20'+substr(h.f_expdt,4,2)
*!*	      edt= ctod(dd+mm+yy)

*!*	      **Deal Calculation
*!*	      if at('+',h.f_pdeal)>0
*!*	         x=at('+',h.f_pdeal)
*!*	         sq = val(allt(h.p_qnt))
*!*	         dq = val(substr(h.f_pdeal,1,x-1))
*!*	         df = val(substr(h.f_pdeal,x+1,8))
*!*	      else
*!*	         if at('%',h.f_pdeal)>0
*!*	            sq = val(allt(h.p_qnt))
*!*	            dq = round(( (100*100)/(val(h.f_pdeal)*100)),0)-1
*!*	            df = 1
*!*	         else
*!*	            sq = val(allt(h.p_qnt))
*!*	            dq = val(allt(h.p_qnt))
*!*	            df = val(alltrim(h.f_pdeal))
*!*	         endif   
*!*	      endif

*!*	      last=substr(h.p_code+space(10),1,10)
*!*	      =seek(last,'pro')
*!*	      sele f
*!*	      seek substr(allt(str(h.f_recsto))+space(20),1,20)
*!*	      if found()
*!*	         batchfound=.t.
*!*	      else
*!*	         batchfound=.f.
*!*	      endif
*!*	      

*!*	      sele g
*!*	      appe blank
*!*	      repl codep with d.codep
*!*	      repl vcn with d.challan
*!*	      repl date with d.chdate
*!*	      repl voucher with d.voucher
*!*	      repl code with e.code
*!*	      repl tax with 'T'
*!*	      repl qty with sq
*!*	      repl free with iif(at('+',h.f_pdeal)>0 .or. at('%',h.f_pdeal)>0,0,val(alltrim(h.f_pdeal)))      
*!*	      repl pack with iif(old_10='R',iif(f.pack=1,0,f.pack),e.pack)      
*!*	      repl exp with edt
*!*	      repl batch with iif(batchfound=.f.,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)),f.batchno)
*!*	      repl flg with 'B'
*!*	      repl rate with h.f_strate
*!*	      repl disc1 with h.f_disc_bef
*!*	      repl ssta with h.f_sgstrate
*!*	      repl cgst with h.f_cgstrate
*!*	      repl ssex with h.f_exdper
*!*	      repl mrp with h.f_mrp
*!*	      repl rsm with h.f_pdeal
*!*	      repl half with 'A'
*!*	      repl godwon with d.godwon
*!*	      if at('%',h.f_pdeal)>0
*!*	         repl deal with dq,;
*!*	              freedeal with df
*!*	      else
*!*	          if at('+',h.f_pdeal)>0    
*!*	             repl deal with dq,;
*!*	                  freedeal with df
*!*	          else                 
*!*	             repl deal with dq,;
*!*	                  freedeal with df
*!*	          endif          
*!*	      endif    
*!*	      
*!*	   sele h
*!*	   skip
*!*	   enddo
*!*	sele c
*!*	skip
*!*	enddo
*!*	close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase Return Expiry/Brk"
sele sele(1)
use &datdev\slipno.&datext alias mslip 
sele mslip
last4 = voucher + 20
slast5=svoucher+4
sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb


sele e
use &pro alias pro
index on name to pro

sele c
use &sgr alias sgr
sele h
use &sgl alias sgl
set filt to (f_dbdate <=old_9) and !empty(f_dbnote)
index on str(f_dbnote,6) + dtoc(f_dbdate) to sgl for f_sttype=old_7

sele g
use &dis alias dis
sele d
use &mdis alias mdis

sele c
try
set filt to (f_dbgrdt <=old_9) and !empty(f_dbnote) and f_comp=old_7
catch
merror=1
endtry
go top

do while ! eof()
   last1= str(c.f_dbnote,6)
   u1 = alltrim(str(c.f_dbnote))
   u2 = len(alltrim(u1))
   u3 = 'CCN'+replicate('0',5-u2)+u1
   sele d
   appe blank
   repl type with 'Q'
   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
   repl challan with u3
   repl chdate with c.f_dbgrdt
   repl codep with c.f_pcode
   repl voucher with last4
   last4=last4+5
   repl amountp with (c.f_totamt)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl final with c.f_totamt
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl godwon with 'A'
   repl sale with iif(old_10='R','z','Z')
   repl ltype with '2'
   repl discafter with 'N'
   repl remark4 with u3

   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek last1 + dtoc(c.f_dbgrdt)
   do while str(h.f_dbnote,6) = last1 and c.f_dbgrdt = h.f_dbdate and ! eof()
      sq=0
      dq=0
      df=0
      x=0

      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_exp,1,2)+'/'
      yy = '20'+substr(h.f_exp,4,2)
      edt= ctod(dd+mm+yy)

      **Deal Calculation
      if at('+',h.f_pdeal)>0
         x=at('+',h.f_pdeal)
         sq = h.s_qnt
         dq = val(substr(h.f_pdeal,1,x-1))
         df = val(substr(h.f_pdeal,x+1,8))
      else
         if at('%',h.f_pdeal)>0
            sq = h.s_qnt
            dq = round(( (100*100)/(val(h.f_pdeal)*100)),0)-1
            df = 1
         else
            sq = h.s_qnt
            dq = h.s_qnt
            df = val(alltrim(h.f_pdeal))
         endif   
      endif

      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)
*!*	IF !FOUND()
*!*	?H.P_CODE+" - "+H.BAT_NO+" -- "+ALLT(STR(H.F_RECSTO))+"  -> 10"
*!*	WAIT
*!*	ENDIF

      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif
      

      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.challan
      repl date with d.chdate
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl free with iif(at('+',h.f_pdeal)>0 .or. at('%',h.f_pdeal)>0,0,val(alltrim(h.f_pdeal)))      
      repl pack with iif(old_10='R',iif(f.pack=1,0,f.pack),0)      
      repl exp with edt
*!*	      repl batch with iif(batchfound=.f.,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)),f.batchno)
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif
      if h.f_stat $ 'EBNDSQRLU'
         repl flg with 'Q'
      else
         if h.f_stat = 'F'
            repl flg with 'B'
         endif
      endif
      if h.f_entry = 'PP'
         repl rate with h.f_prate
      else
         if h.f_entry = 'TP'
            repl rate with h.f_trade
         else
            if h.f_entry $ 'GSWP'
               repl rate with h.f_strate
            endif
         endif
      endif
      repl disc1 with h.f_pdisc
      if c.f_exup='E'      
         repl ssta with h.f_igstrate,;
              sssc with 0,;
              cessinrs with 0
      else
         repl ssta with h.f_sgstrate,;
              cgst with h.f_cgstrate
      endif

      repl mrp with h.f_mrp
      repl rsm with h.f_pdeal
      repl half with 'A'
      repl godwon with d.godwon
      if at('%',h.f_pdeal)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_pdeal)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif    
      
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip 
repl voucher with last4,svoucher with slast5
close data



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Self Expiry Breakage"

sele sele(1)
use &datdev\slipno.&datext alias mslip 
sele mslip
last4 = voucher + 20
slast5=svoucher+4

sele j
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp 

sele f
use &prb alias prb
index on str(code)+mybatch  to prb

sele e
use &pro alias pro
index on name to pro

sele h
use &sgl alias sgl
pack
set filt to empty(f_pcode) and (f_date >=old_5 and f_date <=old_9)
index on f_rptno to sgl
**Sale Return Challan (SRC.DBF)
copy to src.dbf

sele c
use src.dbf alias sgr
pack
index on f_rptno to sgr unique

sele g
use &dis alias dis
sele d
use &mdis alias mdis

sele c
go top
do while ! eof()
   last1=c.f_rptno
   
   sele d
   appe blank
   repl type with 'L'
   repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
   repl challan with last1
   repl chdate with c.f_date
   repl codep with 'STACsl'
   repl voucher with last4
   last4=last4+5
   repl amountp with (c.amount)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   repl final with c.amount
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
   repl duedays with 0
   repl lrda with c.f_date
   repl account with 'N'
   repl sale with 'Z'
   repl godwon with 'A'
   repl ltype with '2'
   repl discafter with 'N'
   repl remark4 with last1

   sele support
   appe blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

   sq=0
   dq=0
   df=0
   x=0
   sele h
   seek last1
   do while ! eof() and h.f_rptno = last1
      sq=0
      dq=0
      df=0
      x=0

      **Exp Date
      dd = '27'+'/'
      mm = substr(h.f_exp,1,2)+'/'
      yy = '20'+substr(h.f_exp,4,2)
      edt= ctod(dd+mm+yy)

      
      **Deal Calculation
      if at('+',h.f_qnt)>0
         x=at('+',h.f_qnt)
         sq = h.s_qnt
         dq = val(substr(h.f_qnt,1,x-1))
         df = val(substr(h.f_qnt,x+1,8))
      else
         if at('%',h.f_qnt)>0
            sq = h.s_qnt
            dq = round(( (100*100)/(val(h.f_qnt)*100)),0)-1
            df = 1
         else
            sq = h.s_qnt
            dq = h.s_qnt
            df = val(alltrim(h.f_qnt))
         endif   
      endif
      

      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      last=substr(h.p_code+space(10),1,10)
      =seek(last,'pro')
      SELE PRB
      SEEK str(pro.code)+substr(allt(str(h.f_recsto))+space(20),1,20)


      if found()
         batchfound=.t.
      else
         batchfound=.f.
      endif


      sele g
      appe blank
      repl codep with d.codep
      repl vcn with d.challan
      repl date with d.chdate
      repl voucher with d.voucher
      repl code with e.code
      repl tax with 'T'
      repl qty with sq
      repl free with iif(at('+',h.f_qnt)>0 .or. at('%',h.f_qnt)>0,0,val(alltrim(h.f_qnt)))      
      repl pack with iif(old_10='R',iif(f.pack=1,0,f.pack),0)      
*!*	      repl pack with e.pack
      repl exp with edt
*!*	      repl batch with iif(batchfound=.f.,iif(h.f_sttype=old_7,h.bat_no,old_8+alltrim(h.bat_no)),f.batchno)
if batchfound=.t.
      Repl BATCH WITH prb.batchno &&&ALLT(STR(H.F_RECSTO))
else
if transferestimate='Y' and h.f_sttype='C'
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
else
   repl batch with iif(h.f_sttype=old_7,subs(h.bat_no,1,10)+str(1,2),old_8+subs(h.bat_no,1,9)+str(1,2))
endif
endif


      repl flg with 'L'
      repl rate with iif(old_10='R',h.f_mrp,h.f_rate)
      repl disc1 with h.f_disc
      repl ssta with h.f_sgstrate
      repl cgst with h.f_cgstrate
      repl sssc with 0
      repl ssex with 0
      repl mrp with h.f_mrp
      repl rsm with h.f_qnt
      repl half with 'A'
      repl godwon with d.godwon
      repl rsm with h.f_qnt
      if at('%',h.f_qnt)>0
         repl deal with dq,;
              freedeal with df
      else
          if at('+',h.f_qnt)>0    
             repl deal with dq,;
                  freedeal with df
          else                 
             repl deal with dq,;
                  freedeal with df
          endif          
      endif          
   sele h
   skip
   enddo
sele c
skip
enddo
sele mslip
repl voucher with last4,svoucher with slast5
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Accounts From Sales "
af      = datdev + '\gledger.' +datext
pend    = datdev + '\pend.' +datext
mdis    = datdev + '\mdis.' +datext
pending = datdev + '\pendings.' +datext
chiler  = datdev + '\chiller.' +datext
sele a
use &chiler alias chiler
zap
sele g
use &pending alias pending
index on ord+vcn to pending
sele f
use &pend alias pend
zap
sele b
use &af alias gledger
zap
sele d
use &mdis alias mdis
go top
do while .not. eof()
   if !(d.type $ 'LDSP')
      skip
      loop
   endif
   last1 = mdis.codep
   if mdis.final#0
      if (d.type $ 'SP')
         sele b
         appe blank
         repl voucher with mdis.voucher
         if d.type $ 'P'
            repl cd with 'C'
            repl credit with mdis.final
            repl book with 'A'
         else
            if d.type='S'
               repl cd with 'D'
               repl debit with mdis.final
               repl book with 'S'
            endif   
         endif
         repl date with mdis.date
         repl code with mdis.codep
         last1=mdis.codep
         repl remark1 with mdis.vcn
         repl type with 'Y'
         if mdis.salun=space(6)
            repl code1 with 'SP#20 '
         else
            repl code1 with mdis.salun
         endif
      endif
      &&Chiller
   if d.type $ 'LD'
         sele a
         append blank
         repl date with mdis.chdate
         repl remark with mdis.challan
         repl ammount with iif(d.type='L',mdis.final,-mdis.final)
         repl cash with 'r'
         repl codep with mdis.codep
         repl voucher with mdis.voucher
         repl code1 with 'SP#20 '
         sele mdis
      endif    
   
      **** for outstanding
      if old_3='Y'
         &&Pend
         sele f
         appe blank
         repl ord with mdis.codep
         repl duedays with mdis.duedays
         if d.type $ 'DP'
            repl final with -mdis.final
         else
            if d.type $ 'SL'
               repl final with mdis.final
            endif   
         endif
         repl vcn with iif(d.type $ 'SP',mdis.vcn,mdis.challan)
         repl ddate with iif(d.type $ 'SP',mdis.date,mdis.chdate)
         repl advance with iif(d.type $ 'LD','R','')
         repl type with 'N'
         repl voucher with mdis.voucher
         repl adjvoucher with mdis.voucher
         repl svoucher with slast5
         slast5 = slast5 + 5
         &&Pendings  
         Sele g
         appe blank
         if d.type $ 'SP'
            repl ord with f.ord
            repl svoucher with f.svoucher
            repl invtype with 'I'
         else
            if d.type $ 'LD'
               repl issueto with f.ord
               repl itempro with f.svoucher
               repl invtype with 'R'
            endif    
         endif         
         repl ddate with f.ddate
         repl vcn with f.vcn
         repl voucher with f.voucher
         repl duedays with f.duedays
         repl duedate with ddate+duedays
         repl final with f.final
         repl balance with f.final
         if d.type $ 'DP'
            repl name with d.pm
         else
            if d.type = 'S'
               repl name with d.vcn
            else
               if d.type = 'L'
                  repl name with d.challan
               endif
            endif
         endif
      endif
   endif   
   if mdis.cash#0
      if (d.type $ 'SP')
         sele b
         append blank
         repl voucher with mdis.voucher
         if d.type = 'P'
            repl cd with 'C'
            repl credit with mdis.cash
            repl book WITH 'A'
         else
            if d.type = 'S'
               repl cd with 'D'
               repl debit with mdis.cash
               repl book WITH 'S'       
            endif   
         endif
         repl date with mdis.date
         repl code with 'STACO3'
         last1='STACO3'
         repl remark1 with mdis.vcn
         repl type with 'Y'
         if mdis.salun=space(6)
            repl code1 with 'SP#20 '
         else
            repl code1 with mdis.salun
         endif
      endif   
      if d.type $ 'LD'
         sele a
         append blank
         repl date with mdis.chdate
         repl remark with mdis.challan
         repl ammount with iif(d.type='L',mdis.final,-mdis.final)
         repl cash with 'r'
         repl codep with mdis.codep
         repl voucher with mdis.voucher
         repl code1 with 'SP#20 '
         sele mdis
      endif  
   **** for outstanding
   if old_3='Y'
      sele f
      appe blank
      repl ord with mdis.codep
      repl duedays with mdis.duedays
      if d.type $ 'P'
         repl final with -mdis.cash
      else
         if d.type $ 'S'
            repl final with mdis.cash
         endif   
      endif
      repl vcn with iif(d.type $ 'SP',mdis.vcn,mdis.challan)
      repl ddate with iif(d.type $ 'SP',mdis.date,mdis.chdate)
      repl advance with iif(d.type $ 'SP','R','')
      repl type with 'N'
      repl voucher with mdis.voucher
      repl adjvoucher with mdis.voucher
      repl svoucher with slast5
      slast5 = slast5 + 5
      sele g
      appe blank
      if d.type $ 'SP'
         repl ord with f.ord
         repl svoucher with f.svoucher
         repl invtype with 'R'
      endif
      repl ddate with f.ddate
      repl vcn with f.vcn
      repl voucher with f.voucher
      repl duedays with f.duedays
      repl duedate with ddate+duedays
      repl final with f.final
      repl balance with f.final
      repl name with iif(d.type$'DP',mdis.pm,mdis.vcn)
   endif
   endif
   if (mdis.final+mdis.cash)#0
      if mdis.type $ 'SP'
         sele b
         append blank
         repl voucher with mdis.voucher
         if d.type='P'
            repl cd with 'C'
            repl credit with (mdis.final + mdis.cash)
            repl book with 'P'    
         else
            if d.type='S'
               repl cd with 'D'
               repl debit with (mdis.final+mdis.cash)
               repl book with 'S'
            endif   
         endif
         repl date with mdis.date
         if mdis.salun=space(6)
            repl code with 'SP#20 '
         else
            repl code with mdis.salun
         endif
         repl remark1 with mdis.vcn
         repl type with 'Y'
         repl code1 with last1
      endif   
   endif
sele d
skip
enddo

Wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Accounts from sales Return"

sele mdis
set filt to type$'RW' &&&&&&&ND VCN='C0028'
go top
do while ! eof()
   if vcn=space(12)
      skip
      loop
   endif
   last1 = mdis.codep
   if mdis.final#0
	  sele b
	  append blank
	  repl voucher with mdis.voucher
	  if d.type = 'P'
	     repl cd with 'C'
	     repl credit with mdis.final
	     repl book with 'A'
	  else
		 repl cd with 'D'
		 repl debit with mdis.final
	     repl book with 'S'
	  endif
	  repl date with mdis.date
	  repl code with mdis.codep
	  last1=mdis.codep
	  repl remark1 with mdis.vcn
      repl type with 'Y'
	  if mdis.salun=space(6)
		 repl code1 with 'SP#20 '
	  else
		 repl code1 with mdis.salun
	  endif
       **** for OUTSTANDING
		if old_3='Y'
			if len(alltrim(mdis.CRNOREM))>0
				sele g
				seek mdis.codep+subs(mdis.CRNOREM+space(20),1,20)
				if found()
					sele f
					appe blank
					repl ord with mdis.codep
					repl ddate with mdis.date
					repl duedays with mdis.duedays
					repl vcn with mdis.CRNOREM
					repl final with -mdis.final
					repl type with 'A'
					repl voucher with mdis.voucher
					repl adjvoucher with g.voucher
					repl svoucher with g.svoucher
				endif
			endif
		else
			sele f
			appe blank
			repl ord with mdis.codep
			repl ddate with mdis.date
			repl duedays with mdis.duedays
			repl vcn with mdis.vcn
			if d.type $ 'RP'
				repl final with -mdis.final
			else
				repl final with mdis.final
			endif
			repl type with 'N'
			repl voucher with mdis.voucher
			repl adjvoucher with mdis.voucher
			repl svoucher with slast5
			slast5 = slast5 + 5
			sele g
			appe blank
			repl ord with f.ord
			repl ddate with f.ddate
			repl vcn with f.vcn
			repl invtype with 'I'
			repl voucher with f.voucher
			repl duedays with f.duedays
			repl duedate with ddate+duedays
			repl final with f.final
			repl balance with f.final
			repl svoucher with f.svoucher
			repl name with mdis.remark4
		endif
	endif

	if mdis.cash#0
	   sele b
	   append blank
	   repl voucher with mdis.voucher
	   if d.type='P'
	      repl cd with 'C'
		  repl credit with mdis.cash
	   else
		  repl cd with 'D'
		  repl debit with mdis.cash
	   endif
	   repl date with mdis.date
	   repl code with 'STACO3'
	   last1='STACO3'
	   repl remark1 with mdis.vcn
	   repl book with 'S'
	   repl type with 'Y'
	   if mdis.salun=space(6)
	      repl code1 with 'SP#20 '
	   else
	      repl code1 with mdis.salun
	   endif
	endif
	if (mdis.final+mdis.cash)#0
	   sele b
	   appe blank
	   repl voucher with mdis.voucher
	   if d.type#'P'
		  repl cd with 'C'
		  repl credit with (mdis.final+mdis.cash)
	   else
		  repl cd with 'D'
		  repl debit with (mdis.final+mdis.cash)
	   endif
	   repl date with mdis.date
	   if mdis.salun=space(6)
	      repl code with 'SP#20 '
	   else
	      repl code with mdis.salun
	   endif
	   repl remark1 with mdis.vcn
	   repl book with 'S'
	   repl type with 'Y'
	   repl code1 with last1
	endif
	sele d
	skip
enddo
CLOSE TABLE ALL

Wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer CASH Realization/Receive"
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext

sele sele(1)
use &datdev\slipno.&datext alias mslip 
last4 = Voucher+10
slast5= svoucher+10

sele g
use &pending alias pending
index on ord + substr(name,1,15) to pending

sele f
use &pend alias pend
sele b
use &af alias gledger

sele a
use &cf alias led
index on dtos(date)+a_code to led
set filt to (entry='CR' or entry='PV' ) and f_comp = OLD_7 &&OR entry='PC'
go top
xf_amount = 0
last1 = date
last2 = a_code
last3 = dbt_cdt
last7 = entry
last4 = last4 + 4
do while ! eof()
      
   if last1#a.date or last2#a.a_code
      sele b
      append blank
      REPL VCSNO WITH A.F_CONTROL
      repl voucher with last4
      repl date with last1
      repl code with last2
      repl remark1 with ''
      if last3='C'
         repl cd with 'C'
         repl credit with xf_amount
      else   
         if last3='D'
            repl cd with 'D'
            repl debit with xf_amount
         endif   
      endif
      if last7='CR'
         repl book with 'R'
      else
         if last7='PV' or last7='PC'
            repl book with 'P'
         ELSE
           if last7='RP'
             repl book with 'D'
           endif     
         endif
      endif      
            
      **CONTRA ENTRY
      sele b
      append blank
      REPL VCSNO WITH A.F_CONTROL
      repl voucher with last4
      repl date with last1
      repl code with 'STACO3'
      repl remark1 with ''
      if last3='D'
         repl cd with 'C'
         repl credit with xf_amount
      else   
         if last3='C'
            repl cd with 'D'
            repl debit with xf_amount
         endif   
      endif
      if last7='CR'
         repl book with 'R'
      else
         if last7='PV' or last7='PC'
            repl book with 'P'
         endif
      endif      
      
      xf_amount = 0
      last1 = a.date
      last2 = a.a_code
      last3 = a.dbt_cdt
      last7 = a.entry
      last4 = last4 + 4
   endif
   
   xf_amount = xf_amount + a.amount

   ** OUTSTANDING PAYMENT ADJUSTMENT
   if old_3='Y'
      **PEND
      sele f
      appe blank
      repl ord with a.a_code
      repl ddate with a.date
      repl vcn with IIF(A.ENTRY='CR',a.v_no,SUBS(A.PARTICULAR,27))
      repl final with IIF(A.ENTRY='CR',-a.amount,A.AMOUNT)

      **PENDINGS
      sele g
      seek f.ord+substr(f.vcn+space(15),1,15)
      if found()
         sele f
         repl type with 'A'
         repl voucher with last4
         repl adjvoucher with g.voucher
         repl svoucher with g.svoucher
      endif
   endif
   
sele a
skip
if eof()
   sele b
   append blank
   REPL VCSNO WITH A.F_CONTROL
   repl voucher with last4
   repl date with last1
   repl code with last2
   repl remark1 with ''
   if last3='C'
      repl cd with 'C'
      repl credit with xf_amount
   else   
      if last3='D'
         repl cd with 'D'
         repl debit with xf_amount
      endif   
   endif
   if last7='CR'
      repl book with 'R'
   else
      if last7='PV' or last7='PC'
         repl book with 'P'
      endif
   endif      
   
            
   **CONTRA ENTRY
   sele b
   append blank
   REPL VCSNO WITH A.F_CONTROL
   
   repl voucher with last4
   repl date with last1
   repl code with 'STACO3'
   repl remark1 with ''
   if last3='D'
      repl cd with 'C'
      repl credit with xf_amount
   else   
      if last3='C'
         repl cd with 'D'
         repl debit with xf_amount
      endif   
   endif
   if last7='CR'
      repl book with 'R'
   else
      if last7='PV' or last7='PC'
         repl book with 'P'
      endif
   endif      
endif
sele a
enddo
sele mslip 
repl voucher with last4,svoucher with slast5 
close data

*!*	wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer CASH Realization/Receive"
*!*	af      = datdev + '\gledger.'+datext
*!*	bf      = datdev + '\slipno.'+datext
*!*	cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
*!*	df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
*!*	ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
*!*	pend    = datdev + '\pend.'+datext
*!*	pending = datdev + '\pendings.'+datext

*!*	sele g
*!*	use &pending alias pending
*!*	index on ord + substr(name,1,15) to pending
*!*	last4 = last4+10
*!*	slast5= last4+10

*!*	sele f
*!*	use &pend alias pend
*!*	sele b
*!*	use &af alias gledger

*!*	sele a
*!*	use &cf alias led
*!*	index on dtos(date)+a_code to led
*!*	set filt to (entry='CR' or entry='PV') and f_comp = OLD_7
*!*	go top
*!*	xf_amount = 0
*!*	do while ! eof()
*!*	last1 = date
*!*	last2 = a_code
*!*	last3 = dbt_cdt
*!*	last7 = entry
*!*	last4 = last4 + 4

*!*	      sele b
*!*	      append blank
*!*	      repl voucher with last4
*!*	      repl date with last1
*!*	      repl code with last2
*!*	      repl remark1 with ''
*!*	      if last3='C'
*!*	         repl cd with 'C'
*!*	         repl credit with xf_amount
*!*	      else   
*!*	         if last3='D'
*!*	            repl cd with 'D'
*!*	            repl debit with xf_amount
*!*	         endif   
*!*	      endif
*!*	      if last7='CR'
*!*	         repl book with 'R'
*!*	      else
*!*	         if last7='PV'
*!*	            repl book with 'P'
*!*	         endif
*!*	      endif      
*!*	            
*!*	      **CONTRA ENTRY
*!*	      sele b
*!*	      append blank
*!*	      repl voucher with last4
*!*	      repl date with last1
*!*	      repl code with 'STACO3'
*!*	      repl remark1 with ''
*!*	      if last3='D'
*!*	         repl cd with 'C'
*!*	         repl credit with xf_amount
*!*	      else   
*!*	         if last3='C'
*!*	            repl cd with 'D'
*!*	            repl debit with xf_amount
*!*	         endif   
*!*	      endif
*!*	      if last7='CR'
*!*	         repl book with 'R'
*!*	      else
*!*	         if last7='PV'
*!*	            repl book with 'P'
*!*	         endif
*!*	      endif      
*!*	      
*!*	      xf_amount = 0
*!*	   
*!*	   xf_amount = xf_amount + a.amount

*!*	   ** OUTSTANDING PAYMENT ADJUSTMENT
*!*	   if old_3='Y'
*!*	      **PEND
*!*	      sele f
*!*	      appe blank
*!*	      repl ord with a.a_code
*!*	      repl ddate with a.date
*!*	      repl vcn with a.v_no
*!*	      repl final with -a.amount

*!*	      **PENDINGS
*!*	      sele g
*!*	      seek f.ord+substr(f.vcn+space(15),1,15)
*!*	      if found()
*!*	         sele f
*!*	         repl type with 'A'
*!*	         repl voucher with last4
*!*	         repl adjvoucher with g.voucher
*!*	         repl svoucher with g.svoucher
*!*	      endif
*!*	   endif
*!*	   
*!*	sele a
*!*	skip
*!*	if eof()
*!*	   sele b
*!*	   append blank
*!*	   repl voucher with last4
*!*	   repl date with last1
*!*	   repl code with last2
*!*	   repl remark1 with ''
*!*	   if last3='C'
*!*	      repl cd with 'C'
*!*	      repl credit with xf_amount
*!*	   else   
*!*	      if last3='D'
*!*	         repl cd with 'D'
*!*	         repl debit with xf_amount
*!*	      endif   
*!*	   endif
*!*	   if last7='CR'
*!*	      repl book with 'R'
*!*	   else
*!*	      if last7='PV'
*!*	         repl book with 'P'
*!*	      endif
*!*	   endif      
*!*	            
*!*	   **CONTRA ENTRY
*!*	   sele b
*!*	   append blank
*!*	   repl voucher with last4
*!*	   repl date with last1
*!*	   repl code with 'STACO3'
*!*	   repl remark1 with ''
*!*	   if last3='D'
*!*	      repl cd with 'C'
*!*	      repl credit with xf_amount
*!*	   else   
*!*	      if last3='C'
*!*	         repl cd with 'D'
*!*	         repl debit with xf_amount
*!*	      endif   
*!*	   endif
*!*	   if last7='CR'
*!*	      repl book with 'R'
*!*	   else
*!*	      if last7='PV'
*!*	         repl book with 'P'
*!*	      endif
*!*	   endif      
*!*	endif
*!*	sele a

*!*	enddo
*!*	close data

if transferestimate='Y'
wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer CASH Receipts/Payments (Estimate)"
af      = datdev + '\chiller.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext
sele g
use &pending alias pending
index on issueto + substr(name,1,15) to pending
last4 = last4+10
slast5= last4+10

sele f
use &pend alias pend
sele b
use &af alias gledger

sele a
use &cf alias led
index on dtos(date)+a_code to led
set filt to (entry='CR' ) and f_comp = 'C' &&&&AND A_CODE='CVY087'or entry='PC'


go top
xf_amount = 0
last1 = date
last2 = a_code
last3 = dbt_cdt
last7 = entry
do while ! eof()
   if last1#a.date or last2#a.a_code
      sele b
      append blank
      REPL VCSNO with a.f_control
      repl voucher with last4
      repl date  with last1
      repl codep with last2
      repl code1  with 'STACO3'
      repl cash with 'R'
      if last3='C'
         repl ammount with -xf_amount
      else   
         if last3='D'
            repl ammount with xf_amount
         endif   
      endif

      xf_amount = 0
      last1 = a.date
      last2 = a.a_code
      last3 = a.dbt_cdt
      last7 = a.entry
      last4 = last4 + 4
   endif
   xf_amount = xf_amount + a.amount
   ** Outstanding Payment Adjustment **
   if old_3='Y'
      ** Pend **
      sele f
      appe blank
      repl ord with a.a_code
      repl ddate with a.date
      repl vcn with IIF(A.ENTRY='CR',a.v_no,SUBS(A.PARTICULAR,27))
      repl final with IIF(A.ENTRY='CR',-a.amount,A.AMOUNT)
      repl advance with 'R'
      sele g
      seek f.ord+substr(f.vcn,1,15)  
      if found()
         sele f
         repl type with 'A'
         repl voucher with last4
         repl adjvoucher with g.voucher
         repl svoucher with g.itempro
      endi
   endi
sele a
skip
if eof()
   sele b
   appen blan
   repl vcsno with a.f_control   
   repl voucher with last4
   repl date  with last1
   repl codep with last2
   repl code1  with 'STACO3'
   repl cash with 'R'
   if last3='C'
      repl ammount with -xf_amount
   else   
      if last3='D'
         repl ammount with xf_amount
      endif   
   endif
endif
sele a
enddo
close data
endi

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer CHEQUE Realization/Receive"
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext

sele g
use &pending alias pending
index on ord + substr(name,1,15) to pending

last4 = last4+10
slast5= last4+10

sele f
use &pend alias pend
sele b
use &af alias gledger

sele a
use &ef alias led
index on dtos(date)+a_code+f_bcode+f_chqno to led
set filt to  entry = 'CH' and F_COMP=OLD_7
go top
xf_amount = 0
last1 = date
last2 = a_code
last5 = f_bcode
lastx = f_chqno
last3 = dbt_cdt
last10= f_bdate
last11= f_chqdt
last12= f_bank

do while !eof()
   if last1#a.date or last2#a.a_code or last5#a.f_bcode or lastx#a.f_chqno
      if !empty(last5)
         sele b
         append blank
         repl voucher with last4
         repl date with last10
         repl code with last2
         repl book with 'R'
         repl remark1 with substr(lastx,1,12)+' Dt. '+substr(dtoc(last11),19,10)+' Bank : '+substr(last12,37,14)
         repl cd with 'C'
         repl credit with xf_amount
         repl addfield1 with lastx         
 
         **CONTRA ENTRY
         sele b
         append blank
         repl voucher with last4
         repl date with last10
         repl code with last5
         repl book with 'R'
         repl remark1 with substr(lastx,1,12)+' Dt. '+substr(dtoc(last11),19,10)+' Bank : '+substr(last12,37,14)
         repl cd with 'D'
         repl debit with xf_amount
         repl addfield1 with lastx
      
         xf_amount = 0
         last1 = a.date
         last2 = a.a_code
         last5 = a.f_bcode
         lastx = a.f_chqno
         last3 = a.dbt_cdt
         last10= a.f_bdate
         last11= a.f_chqdt
         last12= a.f_bank
         last4 = last4 + 4
      else
         sele b
         append blank
         repl voucher with last4
         repl pdate with last1
         repl code with last2
         repl book with 'R'
         repl remark1 with substr(lastx,1,12)+' Dt. '+substr(dtoc(last11),18,10)+' Bank : '+substr(last12,29,14)         
         repl cd with 'C'
         repl credit with xf_amount
         repl addfield1 with lastx
         repl adate with last11
         repl advance with 'Y'
         repl dsm with 'STACex'
         repl type with ' C'
         
         xf_amount = 0
         last1 = a.date
         last2 = a.a_code
         last5 = a.f_bcode
         lastx = a.f_chqno
         last3 = a.dbt_cdt
         last10= a.f_bdate
         last11= a.f_chqdt
         last12= a.f_bank
         last4 = last4 + 4
      endif
   endif
   xf_amount = xf_amount + a.amount

   ** OUTSTANDING PAYMENT ADJUSTMENT
   if old_3='Y'
      **PEND
      sele f
      appe blank
      repl ord with a.a_code
      repl ddate with a.date
      repl vcn with a.v_no
      repl final with -a.amount

      **PENDINGS
      sele g
      seek f.ord+substr(f.vcn,1,15)
      if found()
         sele f
         repl type with 'A'
         repl voucher with last4
         repl adjvoucher with g.voucher
         repl svoucher with g.svoucher
      endi
   endi   
sele a
skip
if eof()
   sele b
   append blank
   repl voucher with last4
   repl date with last1
   repl code with last2
   repl book with 'R'
   repl remark1 with 'Chq No. '+ lastx
   repl cd with 'C'
   repl credit with xf_amount

   **CONTRA ENTRY
   sele b
   append blank
   repl voucher with last4
   repl date with last1
   repl code with last5
   repl book with 'R'
   repl remark1 with 'Chq No. '+ lastx
   repl cd with 'D'
   repl debit with xf_amount
endif
sele a
enddo
close data

************* New breakage expiry voucher adjustment*************
wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Credit/Journal Note(expiry) voucher"
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext

sele g
use &pending alias pending
index on ord + substr(name,1,15) to pending
last4 = last4+10
slast5= last4+10

sele f
use &pend alias pend
sele b
use &af alias gledger

sele a
use &cf alias led
set filt to (entry $ 'GR') and f_comp = old_7
inde on dtoc(date)+ref_no to led
go top
last1=ctod('  /  /    ')
last2='$$$$$$$$$$$'
do while ! eof()
   if last1 # date or last2#ref_no
      last4 = last4+4
   endif
   last1 = date
   last2=ref_no
   sele b
   append blank
   repl voucher with last4
   if a.dbt_cdt = 'C'
      repl cd with 'C'
      repl credit with a.amount
   else
      repl cd with 'D'
      repl debit with a.amount
   endif
   repl date with a.date
   repl code with a.a_code
   repl remark1 with a.particular
   repl vcsno with allt(a.ref_no)
   DO CASE 
      CASE a.entry='GR'
         repl book with 'J'
      case a.entry='PT'
         repl book with 'P' 
      case a.entry='PV'
         repl book with 'C'
   endcase            

   ** OUTSTANDING PAYMENT ADJUSTMENT **
   if old_3='Y'
      **PEND
      sele f
      appe blank
      repl ord with b.code
      repl ddate with b.date
      repl vcn with a.v_no
      if a.dbt_cdt = 'C'
         repl final with -a.amount
      else
         repl final with a.amount
      endif
      **PENDINGS
      sele g
      seek f.ord+substr(f.vcn,1,15)
      if found()
         sele f
         repl type with 'A'
         repl voucher with b.voucher
         repl adjvoucher with g.voucher
         repl svoucher with g.svoucher
      endif
   endif
sele a
skip
enddo
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer CASH/CHEQUE Paid to Supplier (Payment)"
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext

sele g
use &pending alias pending
index on ord + substr(name,1,15) to pending

last4 = last4+10
slast5= last4+10

sele f
use &pend alias pend
sele b
use &af alias gledger

sele a
use &df alias led
index on dtos(f_date)+f_pcode+f_bank+f_chqno to led
set filt to entry = 'CH' AND F_COMP=OLD_7
go top
xf_amount = 0
last1 = f_date
last2 = f_pcode
last5 = f_bank
lastx = f_chqno
last3 = dbt_cdt
do while ! eof()

   if last1#a.f_date or last2#a.f_pcode or last5#a.f_bank or lastx#a.f_chqno
      sele b
      append blank
      repl voucher with last4
      repl date with last1
      repl code with last2
      repl book with 'P'
      repl remark1 with 'Chq No. '+ lastx
      if last3='C'
         repl cd with 'C'
         repl credit with xf_amount
      else   
         if last3='D'
            repl cd with 'D'
            repl debit with xf_amount
         endif   
      endif
      
      **CONTRA ENTRY
      sele b
      append blank
      repl voucher with last4
      repl date with last1
      repl code with iif(last5='ACCASH','STACO3',last5)
      repl book with 'P'
      repl remark1 with 'Chq No. '+ lastx
      if last3='C'
         repl cd with 'D'
         repl debit with xf_amount
      else
         if last3='D'
            repl cd with 'C'
            repl credit with xf_amount
         endif
      endif

      xf_amount = 0
      last1 = a.f_date
      last2 = a.f_pcode
      last5 = a.f_bank
      lastx = a.f_chqno
      last3 = a.dbt_cdt
      last4 = last4 + 4
   endif
   xf_amount = xf_amount + a.f_amount
   ** OUTSTANDING PAYMENT ADJUSTMENT
   if old_3='Y'
      **PEND
      sele f
      appe blank
      repl ord with a.f_pcode
      repl ddate with a.f_date
      repl vcn with a.inv_no
      repl final with a.f_amount

      **PENDINGS
      sele g
      seek f.ord+substr(f.vcn,1,15)
      if found()
         sele f
         repl type with 'A'
         repl voucher with last4
         repl adjvoucher with g.voucher
         repl svoucher with g.svoucher
      endif
   endif
   
sele a
skip
if eof()
   sele b
   append blank
   repl voucher with last4
   repl date with last1
   repl code with last2
   repl book with 'P'
   repl remark1 with 'Chq No. '+ lastx
   if last3='C'
      repl cd with 'C'
      repl credit with xf_amount
   else   
      if last3='D'
         repl cd with 'D'
         repl debit with xf_amount
      endif   
   endif
      
   **CONTRA ENTRY
   sele b
   append blank
   repl voucher with last4
   repl date with last1
   repl code with iif(last5='ACCASH','STACO3',last5)
   repl book with 'P'
   repl remark1 with 'Chq No. '+ lastx
   if last3='C'
      repl cd with 'D'
      repl debit with xf_amount
   else
      if last3='D'
         repl cd with 'C'
         repl credit with xf_amount
      endif
   endif
endif
sele a
enddo
close data




*!*	wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer CASH/CHEQUE Paid to Supplier (Estimate Payment)"
*!*	af      = datdev + '\chiller.'+datext
*!*	bf      = datdev + '\slipno.'+datext
*!*	cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
*!*	df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
*!*	ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
*!*	pend    = datdev + '\pend.'+datext
*!*	pending = datdev + '\pendings.'+datext

*!*	sele g
*!*	use &pending alias pending
*!*	index on issueto + substr(name,1,15) to pending

*!*	last4 = last4+10
*!*	slast5= last4+10

*!*	sele f
*!*	use &pend alias pend
*!*	sele b
*!*	use &af alias gledger

*!*	sele a
*!*	use &df alias led
*!*	index on dtos(f_date)+f_pcode+f_bank+f_chqno to led
*!*	set filt to f_comp = OLD_7 and entry = 'CH'
*!*	go top
*!*	xf_amount = 0
*!*	last1 = f_date
*!*	last2 = f_pcode
*!*	last5 = f_bank
*!*	lastx = f_chqno
*!*	last3 = dbt_cdt
*!*	do while ! eof()
*!*	   if last1#a.f_date or last2#a.f_pcode or last5#a.f_bank or lastx#a.f_chqno
*!*	      sele b
*!*	      append blank
*!*	      repl voucher with last4
*!*	      repl date with last1
*!*	      repl codep with last2
*!*	      repl code1 with 'STACO3'
*!*	      repl cash with 'R'
*!*	      if last3='C'
*!*	         repl ammount with -xf_amount
*!*	      else   
*!*	         if last3='D'
*!*	            repl ammount with xf_amount
*!*	         endif   
*!*	      endif

*!*	      xf_amount = 0
*!*	      last1 = a.f_date
*!*	      last2 = a.f_pcode
*!*	      last5 = a.f_bank
*!*	      lastx = a.f_chqno
*!*	      last3 = a.dbt_cdt
*!*	      last4 = last4 + 4
*!*	   endif
*!*	   xf_amount = xf_amount + a.f_amount
*!*	   ** OUTSTANDING PAYMENT ADJUSTMENT
*!*	   if old_3='Y'
*!*	      **PEND
*!*	      sele f
*!*	      appe blank
*!*	      repl ord with a.f_pcode
*!*	      repl ddate with a.f_date
*!*	      repl vcn with a.inv_no
*!*	      repl final with a.f_amount
*!*	      repl advance with 'R'

*!*	      **PENDINGS
*!*	      sele g
*!*	      seek f.ord+substr(f.vcn,1,15)
*!*	      if found()
*!*	         sele f
*!*	         repl type with 'A'
*!*	         repl voucher with last4
*!*	         repl adjvoucher with g.voucher
*!*	         repl svoucher with g.itempro
*!*	      endif
*!*	   endif
*!*	sele a
*!*	skip
*!*	if eof()
*!*	   sele b
*!*	   append blank
*!*	   repl voucher with last4
*!*	   repl date with last1
*!*	   repl codep with last2
*!*	   repl code1 with 'STACO3'
*!*	   repl cash with 'R'
*!*	   if last3='C'
*!*	      repl ammount with -xf_amount
*!*	   else   
*!*	      if last3='D'
*!*	         repl ammount with xf_amount
*!*	      endif   
*!*	   endif
*!*	endif
*!*	sele a
*!*	enddo
*!*	close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer JOURNAL" &&&&& New code on 06th,oct,2020 by Umesh Nath Goswami
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext
sele g
use &pending alias pending
index on ord + VCN to pending
last4 = last4+10
slast5= last4+10
sele c
use &df alias pym
index on f_chqno to pym
sele d
use &ef alias rpt
index on f_chqno to rpt
sele f
use &pend alias pend
sele b
use &af alias gledger

sele a
 use &cf alias led
 set filt to (entry $ 'JV') and f_comp = OLD_7 &&&&AND REF_NO='J0236'
 inde on dtos(date) to led 

sele led
go top
last1=ctod('  /  /    ')
do while ! eof()
   if last1 # date 
      last4 = last4+4
      last1 = date
      mdbt_cdt=dbt_cdt 

   endif
   mmamt=0      
   sele b
   append blank
   repl voucher with last4
if mdbt_cdt='D'   
   repl cd with 'D'
   repl debit with led.amount
   mmamt=led.amount
else
   repl cd with 'C'
   repl Credit with led.amount
   mmamt=led.amount
endif   
   repl date with led.date
   repl code with led.a_code
   repl remark1 with led.particular
   repl book with 'J'
   REPL VCSNO WITH A.REF_NO
   sele led
   skip
   mmcode=a_code
   sele b
   appen blank 
   repl voucher with last4   
if mdbt_cdt='D'   
   repl cd with 'C'
   repl credit with MMAMT
   mmamt=led.amount
else
   repl cd with 'D'
   repl debit with MMAMT
   mmamt=led.amount
endi   
   repl date with led.date
   repl code with led.a_code
   repl remark1 with led.particular
   repl book with 'J'
   repl vcsno WITH A.REF_NO
   mdbt_cdt=LED.dbt_cdt
   ** OUTSTANDING PAYMENT ADJUSTMENT  &&&&& New code for Adjustment on 06th,oct,2020 by Umesh Nath Goswami
   if old_3='Y'
   sele led 
do while dtos(date)+dbt_cdt=dtos(last1)+mdbt_cdt and !eof()
      **PEND   
      sele f
      appe blank
      repl ord with b.code
      repl ddate with b.date
      repl vcn with iif(empty(a.f_billno),a.v_no,a.f_billno)   &&Updated on 05th,oct,2020 By Umesh 
      if a.dbt_cdt = 'C'
         repl final with -a.amount
      else
         repl final with a.amount
      endi
      **Pendings**
      sele g
      seek f.ord+f.vcn   &&&substr(f.vcn,1,15)
      if found()
         sele f
         repl type with 'A'
         repl voucher with b.voucher
         repl adjvoucher with g.voucher
         repl svoucher with g.svoucher
      endif
      sele led
      skip 
   enddo
   endif
      last4 = last4+4
      mdbt_cdt=dbt_cdt 
   
sele led
*!*	skip
enddo
close data
last4 = last4+10
slast5= last4+10

**Purchase accounting voucher code**
wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase Accounting Vouchers" &&&&& New code on 12th,July,2024 by Umesh Nath Goswami
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext
subdis  = datdev + '\subdis.'+datext
sltyp   = datdev + '\saletype.'+datext
cf=datatransferpath + 'pit'+datatransferpath1+'.'+datatransferext

Sele g
Use &pending Alias pending
Index On ord + Substr(Name,1,15) To pending
last4 = last4+10
slast5= last4+10
Sele F
Use &pend Alias pend
Sele b
Use &af Alias gledger
Sele Sele(1)
Use &subdis Alia subdis

Sele Sele(1)
Use &sltyp Alias sltyp
Index On sgcode+parnam+Str(igst,5,2) To stype
Sele Sele(1)
Use &cf Alia led
set filte to inv_date<old_5 and f_recdt=old_5 And f_sttype = old_7 And F_BILLTYPE $ 'B'
Inde On invoice_no To led
Sele led
Go Top
last1=Ctod('  /  /    ')
last2='$$$'
last3='%%%%%%%%%'
Do Whil !Eof()
	If last1#led->inv_date .Or. last2# (led->invoice_no) .Or. last3# led.ams_id
		last4=last4+10
	Endi
	last1=led->inv_date
	last2=led->invoice_no
	last3=led->c_code
	
	Sele gledger
	Appen Blan
	Repl voucher With last4
	Repl credit With led->inv_tot_am
	Repl Cd With 'C'
*	Repl book With 'E'
*	Repl Type With 'F'
	Repl book With 'A'
	Repl Type With 'E'
	Repl Code With led->c_code
	Repl vcsno With right(alltr(led->invoice_no),9)
	Repl Date With led->f_recdt
	Repl remark1 With led->invoice_no
	
	Appen Blan
	Repl voucher With last4
	If led->inv_adj_am<0
		Repl credit With Abs(led->inv_adj_am)
		Repl Cd With 'C'
	Else
		Repl debit With led->inv_adj_am
		Repl Cd With 'D'
	Endi
	Repl book With 'A'
	Repl Type With 'E'
	Repl Code With 'AROUND'
	Repl vcsno With right(alltr(led->invoice_no),9)
	Repl Date With led->f_recdt
	Repl remark1 With led->invoice_no

**** for outstanding
		If old_3='Y'
&&Pend
			Sele F
			Appe Blank
			Repl ord With led->c_code
*			Repl duedays With mdis.duedays
			Repl Final With -(led->inv_tot_am)
			Repl vcn With led->invoice_no
			Repl ddate With led->f_recdt
			Repl advance With ''
			Repl Type With 'N'
			Repl voucher With last4
			Repl adjvoucher With last4
			Repl svoucher With slast5
			slast5 = slast5 + 5

&&Pendings
			Sele g
			Appe Blank
			Repl ord With F.ord
			Repl svoucher With F.svoucher
			Repl invtype With 'I'
			Repl ddate With F.ddate
			Repl vcn With F.vcn
			Repl voucher With F.voucher
			Repl duedays With F.duedays
			Repl duedate With ddate+duedays
			Repl Final With F.Final
			Repl balance With F.Final
			Repl Name With f.vcn
		Endif
	
	If !Empt(led->f_tgst0)     &&net amt(0%)
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->F_Tgst0
		Repl Cd With 'D'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'AGSP00'    &&GST PURCHASE 0%
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
	ENDIF
	
	If !Empt(led->f_tcsg5)     &&net amt(5%)
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->F_TCSG5
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'AGSP05'    &&GST PURCHASE 5%
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->f_sgst5
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'ASGT05'    &&SGST PURCHASE TAX 2.5 %
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->f_cgst5
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'ACGT05'    &&CGST PURCHASE TAX 2.5 %
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
	Endi

	If !Empt(led->f_tcsg12)     &&net amt(12%)
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->F_TCSG12
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'AGSP12'    &&GST PURCHASE 12%
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->f_sgst12
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'ASGT12'    &&SGST PURCHASE TAX 6 %
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->f_cgst12
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'ACGT12'    &&CGST PURCHASE TAX 6 %
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
	Endi

	If !Empt(led->F_TCSG18)     &&net amt(18%)
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->F_TCSG18
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'AGSP18'    &&GST PURCHASE 18%
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->f_sgst18
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'ASGT18'    &&SGST PURCHASE TAX 9 %
	    repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->f_cgst18
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'ACGT18'    &&CGST PURCHASE TAX 9 %
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
	Endi

	If !Empt(led->f_tcsg28)     &&net amt(28%)
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->F_TCSG28
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'AGSP28'    &&GST PURCHASE 28%
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recd
		Repl remark1 With led->invoice_no
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->f_sgst28
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'ASGT28'    &&SGST PURCHASE TAX 14 %
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
		Sele gledger
		Appen Blan
		Repl voucher With last4
		Repl debit With led->f_cgst28
		Repl Cd With 'D'
*		Repl book With 'E'
*		Repl Type With 'F'
		Repl book With 'A'
		Repl Type With 'E'
		Repl Code With 'ACGT28'    &&CGST PURCHASE TAX 14 %
	Repl vcsno With right(alltr(led->invoice_no),9)
		Repl Date With led->f_recdt
		Repl remark1 With led->invoice_no
	ENDIF
	
	Sele led
	Skip
Endd
***Hsn wise voucher detail**
psrl=1
Sele gledger
Set Filte To book='A' And Type='E'
Inde On Subst(remark1,1,15) To gledger
Sele led
Go Top
Scan
	Sele gledger
	Seek SUBSTR(led->invoice_no,1,15)
	msgst=0
	migst=0
	mtaxable=0
	mtaxamou=0
	xhsn='3004 '&&led->f_hsn
	Sele sltyp
	Seek 'COMMCD'+Subst(xhsn+Spac(15),1,15)+Str(migst,5,2)
	If !Found()
		Append Blank
		Repl sltyp.sgcode With 'COMMCD'
		Repl sltyp.scode  With 'PS'+Alltrim(Str(psrl))
		Repl sltyp.sname  With Substr(xhsn+Space(15),1,15)+ Substr(xhsn,1,15) +' '+ Alltrim(Str(migst,5,2))
		Repl sltyp.parnam With Substr(xhsn+Space(15),1,15)
		Repl sltyp.tax With migst/2
		Repl sltyp.cgst With migst/2
		Repl sltyp.igst With migst
		Repl sltyp.tcode With 'No'
		psrl=psrl+1
	ENDIF
	mhsncode=sltyp.scode
	
	Sele subdis
	Appen Blan
	Repl Codep With led->c_code
	Repl vcn With led->invoice_no
	Repl Date With led->f_recdt
	Repl voucher With gledger->voucher
	Repl Type With '2'
	Repl dsm With '#COMB#'
	Repl misc1 With ''
	Repl book With 'AD'				&&	'EDA'
	Repl rtqt With vcn
	If !Empt(led->F_TCSG5)
		msgst=2.5
		migst=5
		mnettotal=led->F_TCSG5
		msgstamt=led->f_sgst5
		
		Sele sltyp
		Seek 'COMMCD'+Subst(xhsn+Spac(15),1,15)+Str(migst,5,2)
		If !Found()
			Append Blank
			Repl sltyp.sgcode With 'COMMCD'
			Repl sltyp.scode  With 'PS'+Alltrim(Str(psrl))
			Repl sltyp.sname  With Substr(xhsn+Space(15),1,15)+ Substr(xhsn,1,15) +' '+ Alltrim(Str(migst,5,2))
			Repl sltyp.parnam With Substr(xhsn+Space(15),1,15)
			Repl sltyp.tax With migst/2
			Repl sltyp.cgst With migst/2
			Repl sltyp.igst With migst
			Repl sltyp.tcode With 'No'
			psrl=psrl+1
		ENDIF
		mhsncode=sltyp.scode
	
		Sele subdis
		Appen Blan
		Repl Codep With led->c_code
		Repl vcn With led->invoice_no
		Repl Date With led->f_recdt
		Repl voucher With gledger->voucher
		Repl Type With '2'
		Repl dsm With '#COMD#'
		Repl misc1 With Str(msgst,6,2)
		Repl book With 'AD'				&&	'EDA'
		mrtqt=mhsncode+'LT'+Str(msgst,6,2)+';2;'+Alltrim(Str(mnettotal,12,2))+';'
		mrtqt=mrtqt+Alltrim(Str(mnettotal,12,2))+';'+Alltrim(Str(msgstamt,12,2))+';;;'
		mrtqt=mrtqt+Alltr(Str(led->f_tqty))+';;'+Alltrim(Str(msgstamt,12,2))+';'
		Repl rtqt With mrtqt
	Endi

	If !Empt(led->F_TCSG12)
		msgst=6
		migst=12
		mnettotal=led->F_TCSG12
		msgstamt=led->f_sgst12
		Sele sltyp
		Seek 'COMMCD'+Subst(xhsn+Spac(15),1,15)+Str(migst,5,2)
		If !Found()
			Append Blank
			Repl sltyp.sgcode With 'COMMCD'
			Repl sltyp.scode  With 'PS'+Alltrim(Str(psrl))
			Repl sltyp.sname  With Substr(xhsn+Space(15),1,15)+ Substr(xhsn,1,15) +' '+ Alltrim(Str(migst,5,2))
			Repl sltyp.parnam With Substr(xhsn+Space(15),1,15)
			Repl sltyp.tax With migst/2
			Repl sltyp.cgst With migst/2
			Repl sltyp.igst With migst
			Repl sltyp.tcode With 'No'
			psrl=psrl+1
		ENDIF
		mhsncode=sltyp.scode
	
		Sele subdis
		Appen Blan
		Repl Codep With led->c_code
		Repl vcn With led->invoice_no
		Repl Date With led->f_recdt
		Repl voucher With gledger->voucher
		Repl Type With '2'
		Repl dsm With '#COMD#'
		Repl misc1 With Str(msgst,6,2)
		Repl book With 'AD'				&&	'EDA'
		mrtqt=mhsncode+'LT'+Str(msgst,6,2)+';2;'+Alltrim(Str(mnettotal,12,2))+';'
		mrtqt=mrtqt+Alltrim(Str(mnettotal,12,2))+';'+Alltrim(Str(msgstamt,12,2))+';;;'
		mrtqt=mrtqt+Alltr(Str(led->f_tqty))+';;'+Alltrim(Str(msgstamt,12,2))+';'
		Repl rtqt With mrtqt
	Endi

	If !Empt(led->F_TCSG18)
		msgst=9
		migst=18
		mnettotal=led->F_TCSG18
		msgstamt=led->f_sgst18
		Sele sltyp
		Seek 'COMMCD'+Subst(xhsn+Spac(15),1,15)+Str(migst,5,2)
		If !Found()
			Append Blank
			Repl sltyp.sgcode With 'COMMCD'
			Repl sltyp.scode  With 'PS'+Alltrim(Str(psrl))
			Repl sltyp.sname  With Substr(xhsn+Space(15),1,15)+ Substr(xhsn,1,15) +' '+ Alltrim(Str(migst,5,2))
			Repl sltyp.parnam With Substr(xhsn+Space(15),1,15)
			Repl sltyp.tax With migst/2
			Repl sltyp.cgst With migst/2
			Repl sltyp.igst With migst
			Repl sltyp.tcode With 'No'
			psrl=psrl+1
		ENDIF
		mhsncode=sltyp.scode
	
		Sele subdis
		Appen Blan
		Repl Codep With led->c_code
		Repl vcn With led->invoice_no
		Repl Date With led->f_recdt
		Repl voucher With gledger->voucher
		Repl Type With '2'
		Repl dsm With '#COMD#'
		Repl misc1 With Str(msgst,6,2)
		Repl book With 'AD'				&&	'EDA'
		mrtqt=mhsncode+'LT'+Str(msgst,6,2)+';2;'+Alltrim(Str(mnettotal,12,2))+';'
		mrtqt=mrtqt+Alltrim(Str(mnettotal,12,2))+';'+Alltrim(Str(msgstamt,12,2))+';;;'
		mrtqt=mrtqt+Alltr(Str(led->f_tqty))+';;'+Alltrim(Str(msgstamt,12,2))+';'
		Repl rtqt With mrtqt
	Endi
	If !Empt(led->F_TCSG28)
		msgst=14
		migst=28
		mnettotal=led->F_TCSG28
		msgstamt=led->f_sgst28
		
		Sele sltyp
		Seek 'COMMCD'+Subst(xhsn+Spac(15),1,15)+Str(migst,5,2)
		If !Found()
			Append Blank
			Repl sltyp.sgcode With 'COMMCD'
			Repl sltyp.scode  With 'PS'+Alltrim(Str(psrl))
			Repl sltyp.sname  With Substr(xhsn+Space(15),1,15)+ Substr(xhsn,1,15) +' '+ Alltrim(Str(migst,5,2))
			Repl sltyp.parnam With Substr(xhsn+Space(15),1,15)
			Repl sltyp.tax With migst/2
			Repl sltyp.cgst With migst/2
			Repl sltyp.igst With migst
			Repl sltyp.tcode With 'No'
			psrl=psrl+1
		ENDIF
		mhsncode=sltyp.scode
		Sele subdis
		Appen Blan
		Repl Codep With led->c_code
		Repl vcn With led->invoice_no
		Repl Date With led->f_recdt
		Repl voucher With gledger->voucher
		Repl Type With '2'
		Repl dsm With '#COMD#'
		Repl misc1 With Str(msgst,6,2)
		Repl book With 'AD'				&&	'EDA'
		mrtqt=mhsncode+'LT'+Str(msgst,6,2)+';2;'+Alltrim(Str(mnettotal,12,2))+';'
		mrtqt=mrtqt+Alltrim(Str(mnettotal,12,2))+';'+Alltrim(Str(msgstamt,12,2))+';;;'
		mrtqt=mrtqt+Alltr(Str(led->f_tqty))+';;'+Alltrim(Str(msgstamt,12,2))+';'
		Repl rtqt With mrtqt
	Endi
Ends
Close Tables All

*!*	wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase Vouchers" &&&&& New code on 06th,oct,2020 by Umesh Nath Goswami
*!*	af      = datdev + '\gledger.'+datext
*!*	bf      = datdev + '\slipno.'+datext
*!*	cf      = datatransferpath + 'fat'+datatransferpath1+'.'+datatransferext
*!*	df      = datatransferpath + 'pch'+datatransferpath1+'.'+datatransferext
*!*	ef      = datatransferpath + 'chq'+datatransferpath1+'.'+datatransferext
*!*	pend    = datdev + '\pend.'+datext
*!*	pending = datdev + '\pendings.'+datext
*!*	sele g
*!*	use &pending alias pending
*!*	index on ord + substr(name,1,15) to pending
*!*	last4 = last4+10
*!*	slast5= last4+10
*!*	sele c
*!*	use &df alias pym
*!*	index on f_chqno to pym
*!*	sele d
*!*	use &ef alias rpt
*!*	index on f_chqno to rpt
*!*	sele f
*!*	use &pend alias pend
*!*	sele b
*!*	use &af alias gledger

*!*	sele a
*!*	 use &cf alias led
*!*	 set filt to (entry $ 'RP') and f_comp  = OLD_7  and dbt_cdt='C'
*!*	 inde on dtos(date) to led for f_bdate<old_5

*!*	last4=last4+5
*!*	slast5=slast5+4
*!*	sele led
*!*	go top
*!*	last1=ctod('  /  /    ')
*!*	last2='$$$$$$$$$$'
*!*	do while ! eof()
*!*	   if last1 # date or last2#particular
*!*	      last4 = last4+4
*!*	   endif
*!*	   last1 = date
*!*	   last2=particular
*!*	   mdbt_cdt=dbt_cdt 
*!*	   
*!*	   sele b
*!*	   append blank
*!*	   repl voucher with last4
*!*	if led.dbt_cdt='D'   
*!*	   repl cd with 'D'
*!*	   repl debit with led.amount
*!*	else
*!*	   repl cd with 'C'
*!*	   repl Credit with led.amount

*!*	endif   
*!*	   repl date with led.date
*!*	   repl code with led.a_code
*!*	   repl remark1 with led.particular
*!*	   repl book with 'A'
*!*	   repl vcsno with led.particular
*!*	   ** OUTSTANDING PAYMENT ADJUSTMENT  &&&&& New code for Adjustment on 06th,oct,2020 by Umesh Nath Goswami
*!*	   if old_3='Y'
*!*	      **PEND   
*!*	      sele f
*!*	      appe blank
*!*	      repl ord with b.code
*!*	      repl ddate with b.date
*!*	      repl vcn with iif(empty(a.f_billno),a.v_no,a.f_billno)   &&Updated on 05th,oct,2020 By Umesh 
*!*	      if a.dbt_cdt = 'C'
*!*	         repl final with -a.amount
*!*	      else
*!*	         repl final with a.amount
*!*	      endi
*!*	      **PENDINGS**
*!*	      sele g
*!*	      seek f.ord+substr(f.vcn,1,15)
*!*	      if found()
*!*	         sele f
*!*	         repl type with 'A'
*!*	         repl voucher with b.voucher
*!*	         repl adjvoucher with g.voucher
*!*	         repl svoucher with g.svoucher
*!*	      endif
*!*	   endif
*!*	   sele b
*!*	   append blank
*!*	   repl voucher with last4
*!*	if led.dbt_cdt='D'   
*!*	   repl cd with 'C'
*!*	   repl credit with led.amount
*!*	else
*!*	   repl cd with 'D'
*!*	   repl debit with led.amount

*!*	endif   
*!*	   repl date with led.date
*!*	   repl code with 'CNADJ9'
*!*	   repl remark1 with led.particular
*!*	   repl book with 'A'
*!*	   repl vcsno with led.particular
*!*	sele led
*!*	skip
*!*	enddo
*!*	close tabl all

*!*	last4=last4+5
*!*	slast5=slast5+4

*!*	sele sele(1)
*!*	use &datdev\slipno.&datext 
*!*	repl voucher with last4+20
*!*	repl svoucher with slast5+20


bf=datdev+ '\mdis.'+datext
use &bf
repl misc4 with ' '
close data
bf=datdev+ '\pendings.'+datext
use &bf
repl all vcn with '*'+vcn for invtype='O' and ddate<=old_5
close data


** Transfer CALCULATION FIELD OF MARG TRANSACTION FILE
dis=datdev + '\dis.'+datext
use &dis
go top
do while ! eof()
   repl sfrate with rate+val(substr(dis.misc4,1,6))
   repl ssscamo with round((sfrate*qty)*sssc/100,2)
   repl sstaamo with round((sfrate*qty+ssscamo)*ssta/100,2)
   repl sfrate with sfrate+round(sfrate*sssc/100,2)
   repl sfrate with sfrate+round(sfrate*ssta/100,2)
   repl shalfamo with rate*halffree
   tot=rate*qty-vdisamo-shalfamo
   totd=round(tot*disc1/100,2)
   repl sdiscount with totd
   tot=tot-totd
   totd=round(tot*disc2/100,2)
   repl sdiscount with sdiscount+totd
   tot=(rate-ssex)*qty-sdiscount-shalfamo-vdisamo
   totd=round(tot*addis/100,2)
   repl ammmount with sfrate*qty-sdiscount-shalfamo-vdisamo
   repl ssscamo with ssscamo+(sfrate*qty-rate*qty)-(ssscamo+sstaamo)
skip
enddo
close data

proc rem_dupl
sele sele(1)
crea curs dbffile (filepath varchar(100),filname varchar(35),filsel n(1))
defpath=alltrim(datatransferpath) &&GETDIR(sys(5)+sys(2003),'Select Path for Backup','Select Path',64)
if empty(defpath)
   m.dbfpath=alltrim(datatransferpath) &&curdir()
   retu
endif
m.dbfpath=defpath
tlen=adir(dmarr,defpath+'\*.DBF')
Sele DBFFILE
       appe blan
       repl filepath with dbfpath,filname with 'RBT23.DBF',filsel with 1
       appe blan
       repl filepath with dbfpath,filname with 'RPT23.DBF',filsel with 1

*zap
*!*	for icOUNT=1 to tlen
*!*	    if 'FOXUSER.'$dmarr(iCount,1)
*!*	       loop
*!*	    endif
*!*	    if file(dbfpath+'\'+dmarr(iCount,1))
*!*	       appe blan
*!*	       repl filepath with dbfpath,filname with dmarr(iCount,1),filsel with 1
*!*	    endif
*!*	next
sele dbffile
go top
tmptabl=sys(2023)+'\'+sys(3)+'.DBF'
do whil file(tmptabl)
   tmptabl=sys(2023)+'\'+sys(3)+'.DBF'
enddo
=strtofil('DD',tmptabl)
tmpfil=sys(2023)+'\'+sys(3)+'.TMP'
do whil file(tmpfil)
   tmpfil=sys(2023)+'\'+sys(3)+'.TMP'
enddo
=strtofil('DD',tmpfil)
*----------------------------------------*
scntabl=sys(2023)+'\'+sys(3)+'.DBF'
do whil file(scntabl)
   scntabl=sys(2023)+'\'+sys(3)+'.DBF'
enddo
=strtofil('DD',scntabl)
scnfil=sys(2023)+'\'+sys(3)+'.TMP'
do whil file(scnfil)
   scnfil=sys(2023)+'\'+sys(3)+'.TMP'
enddo
=strtofil('DD',scnfil)
eras "&tmptabl"
eras "&tmpfil"
eras "&scntabl"
eras "&scnfil"
*----------------------------------------*
if used('MYTEMP')
   use in MYTEMP
endif
sele sele(1)
**crea curs MyTemp (field_name c(10),field_type c(1),field_len n(3),field_dec n(3))
crea curs MyTemp (FIELD_NAME C(10),;
                  FIELD_TYPE C(1),;
                  FIELD_LEN N(3),;
                  FIELD_DEC N(3),;
                  FIELD_NULL L,;
                  FIELD_NOCP L,;
                  FIELD_DEFA M,;
                  FIELD_RULE M,;
                  FIELD_ERR M,;
                  TABLE_RULE M,;
                  TABLE_ERR M,;
                  TABLE_NAME C(128),;
                  INS_TRIG M,;
                  UPD_TRIG M,;
                  DEL_TRIG M,;
                  TABLE_CMT M,;
                  FIELD_NEXT I,;
                  FIELD_STEP I)

Sele DBFFILE

coun to tot for filsel=1
wait wind tot
if tot=0
   =messagebox('No file(s) selected for conversion.',64,'Marg')
   retu
endif
*set notif off
m.errno=0
**on error m.errno=error()
totfiles=0
if file('MYCMD.TXT')
   eras &mycmd.txt
endif
sele dbffile 
scan for filsel=1
*!*	if alltrim(upper(table_name))='MFAC_MST'
     m.errno=0
     filnm=addbs(rtri(dbfpath))+filname
     
     filsc=justpath(filnm)+juststem(filnm)+"_2nd."+justext(filnm)
     if at(' ',filnm)>0
        filnm='"'+filnm+'"'
     endif
     if at(' ',filsc)>0
        filsc='"'+filsc+'"'
     endif
     try
     sele sele(1)
     use &filnm
     catch to oexp
           m.errno=oexp.ErrorNo
     endtry
     if m.errno=0
        use
        loop
     endif
     fp=fopen(filnm)
     if fp<0
        =messagebox('Error opening File :'+chr(13)+dbffile->filname+CHR(13)+'Please check whether utility is already running.',64,'Marg')
        loop
     endif
     wait wind 'Processing '+dbffile->filname+chr(13)+'Please wait.....' at 2,2 nowa
     =fseek(fp,0,0)
     filtyp=fread(fp,1)
     lstdat=fread(fp,3)
     norecs=fread(fp,4)
     frstrec=fread(fp,2)
     reclength=fread(fp,2)
     reserve=fread(fp,16)
     table_flag=fread(fp,1)
     code_page=fread(fp,1)
     hdr_end=fread(fp,2)
     frstrec=asc(left(frstrec,1))+256*asc(subs(frstrec,2,1))
     ** noflds=(frstrec-296)/32
     noflds=(frstrec-32)/32
     norecs=asc(left(norecs,1))+256*asc(subs(norecs,2,1))+65536*asc(subs(norecs,3,1))+16777216*asc(subs(norecs,4,1))
     **cmd='CREATE CURS TMP ('
     reco_len=asc(left(reclength,1))+asc(subs(reclength,2,1))*256
     if noflds>250
        acflds=250
        dime fldarray(250,4)
     else
        acflds=noflds
        dime fldarray(noflds,4)
     endif
     for dvfp_i=1 to acflds
         fname=PADR(fread(fp,10),10)
         resv=fread(fp,1)
         fltyp=fread(fp,1)
         resv=fread(fp,4)
         flen=asc(fread(fp,1))
         fdeci=asc(fread(fp,1))
         resv2=fread(fp,14)
         fldarray(dvfp_i,1)=fltyp
         fldarray(dvfp_i,2)=flen
         fldarray(dvfp_i,3)=fdeci
         newfldnm=''
         for dvfp_j=1 to 10
             _chr=subs(fname,dvfp_j,1)
             if isalpha(_chr) or isdigit(_chr) or _chr='_'
                newfldnm=newfldnm+_chr
             else
                *exit
             endif
         next
         fldarray(dvfp_i,4)=newfldnm  && allt(chrtran(fname,chr(0),''))
         **=STRTOFILE(fname+' '+fldarray(dvfp_i,4)+CHR(13)+CHR(10),'MYCMD.txt',1)
     next
     duplfnd=.F.
     newnum=1
     for dvfp_i=1 to acflds-1
         for dvfp_j=dvfp_i+1 to acflds
             dvfp_f1=allt(fldarray(dvfp_i,4))
             dvfp_f2=allt(fldarray(dvfp_j,4))
             if dvfp_f1=dvfp_f2
                duplfnd=.T.
                if newnum<100
                   nnm=left(dvfp_f2,8)+subs(str(100+newnum,3),2)
                else
                   nnm=left(dvfp_f2,7)+subs(str(1000+newnum,4),2)
                endif
                fldarray(dvfp_j,4)=nnm
                newnum=newnum+1
             endif
         next
     next
     if !duplfnd
        =fclos(fp)
        wait clea
        loop
     endif
     dvfp_len=1
     for dvfp_i=1 to acflds
         *if dvfp_i>250
         *   exit
         *endif
         flen=fldarray(dvfp_i,2)
         fdeci=fldarray(dvfp_i,3)
         **cmd=cmd+fldarray(dvfp_i,4)+' '+allt(fldarray(dvfp_i,1))+'('+ltri(str(flen,3))+;
         **    iif(fdeci>0,','+ltri(str(fdeci,3)),'')+'),'
         dvfp_len=dvfp_len+flen
         Sele MyTemp
         appe blan
         repl field_name with fldarray(dvfp_i,4),field_type with fldarray(dvfp_i,1),;
              field_len with flen,field_dec with fdeci
     next
     if used('TMP')
        Sele TMP
        use
     endif
     mt_250=.f.
     Sele MyTemp
     if recc()<251
        copy to "&tmptabl"
        if file("&tmpfil")
           eras "&tmpfil"
        endif
        sele sele(1)
        use "&tmptabl"
        use
        sele sele(1)
        crea "&tmpfil" from "&tmptabl"
        use
        use "&tmpfil" alias TMP
        eras "&tmptabl"
     else
        mt_250=.t.
        copy to "&tmptabl" for recn()<251
        if file("&tmpfil")
           eras "&tmpfil"
        endif
        sele sele(1)
        use "&tmptabl"
        use
        sele sele(1)
        crea "&tmpfil" from "&tmptabl"
        use
        use "&tmpfil" alias TMP
        eras "&tmptabl"
        Sele MyTemp
        copy to "&scntabl" for recn()>250
        if file("&scnfil")
           eras "&scnfil"
        endif
        sele sele(1)
        use "&scntabl"
        use
        sele sele(1)
        crea "&scnfil" from "&scntabl"
        use
        use "&scnfil" alias TMP2
        eras "&scntabl"
     endif
     Sele MyTemp
     zap

     =fseek(fp,frstrec,0)
     for i=1 to norecs
         delmrk=fread(fp,1)
         if mt_250
            Sele TMP2
            appe blan
         endif
         Sele TMP
         appe blan
         for j=1 to noflds
             if j>250
                =fread(fp,reco_len-dvfp_len)
                *for _k=j to noflds
                    *fldval=fread(fp,fldarray(_k,2))
                    *if len(fldval)<fldarray(j,2)
                    *   i=norecs+1
                    *   exit
                    *endif
                    *if fldarray(j,1)$'INFBY'
                    *   fldval=val(fldval)
                    *endif
                    *if fldarray(j,1)='D'
                    *   fldval=ctod('^'+left(fldval,4)+'/'+subs(fldval,5,2)+'/'+subs(fldval,7))
                    *endif
                    *if fldarray(j,1)='L'
                    *   if vartype(fldval)='C'
                    *      if fldval$'Yy1'
                    *         fldval=.T.
                    *      else
                    *         fldval=.F.
                    *      endif
                    *   else
                    *      if vartype(fldval)$'INF'
                    *         if fldval=1
                    *            fldval=.T.
                    *         else
                    *            fldval=.F.
                    *         endif
                    *      else
                    *         fldval=.F.
                    *      endif
                    *   endif
                    *endif
                    *Sele TMP2
                    *fnam=field(_k-250)
                    *repl &fnam with fldval in TMP2
                *next
                *if delmrk='*'
                *   dele in TMP2
                *endif
                exit
             endif
             fldval=fread(fp,fldarray(j,2))
             if len(fldval)<fldarray(j,2)
                i=norecs+1
                exit
             endif
             if fldarray(j,1)$'INFBY'
                fldval=val(fldval)
             endif
             if fldarray(j,1)='D'
                fldval=ctod('^'+left(fldval,4)+'/'+subs(fldval,5,2)+'/'+subs(fldval,7))
             endif
             if fldarray(j,1)='L'
                if vartype(fldval)='C'
                   if fldval$'Yy1'
                      fldval=.T.
                   else
                      fldval=.F.
                   endif
                else
                   if vartype(fldval)$'INF'
                      if fldval=1
                         fldval=.T.
                      else
			             fldval=.F.
                      endif
                   else
                   	  fldval=.F.
                   endif
                endif
             endif
             Sele TMP
             fnam=field(j)
             repl &fnam with fldval in TMP
         next
         if delmrk='*'
            dele in TMP
         endif
     next
     =fclos(fp)
     wait clea
     Sele TMP
     copy to &filnm
     use
     eras "&tmpfil"
     if mt_250
        Sele TMP2
        copy to &filsc
        use
        eras "&scnfil"
     endif
     wait wind 'File converted successfully !'+chr(13)+dbffile->filname at 2,2 time 2
     totfiles=totfiles+1
*!*	endif     
Endscan
on error
if totfiles>0
   =messagebox('Total '+ltri(str(totfiles,5))+' file(s) converted',48,'Marg')
else
   =messagebox('No files found with duplicate fields.',64,'Marg')
endif
Sele MyTemp
use
