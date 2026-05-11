*!*	BOF : TFMEDIVISION.PRG .....Author Santosh Srivastava
*****Last Change By Santosh K Srivastava       Dated    : 12/12/2018
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
*!* your commands
sele sele(1)
  create curs mycurs  (setup c(50),value c(4)) 
  sele mycurs 
  appe blank 
  repl  setup with 'Item Wise Double Discount ',value with 'Y'
  appen blank
  repl  setup with 'Volume discount 1st ',value with 'L'
  appen blank
  repl  setup with 'Volume discount 2nd ',value with 'U'
  appen blank 
  repl  setup with 'Bill Discount',value with 'Y'
  brow FONT 'COURIER',18    NOMODIFY   

clear
set talk off
set date to brit
set cent on
set dele on
set safe off
set cpdi off
set color to
*!*	firstdate=ctod('01/04/2024')
*!*	lastdate=ctod('31/03/2025')
*!*	datdev='d:\transfer\'
*!*	datext='DBF'
*!*	margprmfmt='Courier'
*!*	margprmkkrfsz=18
*save SCREE to simple   &&&REMOVE
close data
sure = space(4)
sure='SURE'
datatransferpath=SubStr('D:\DM\Mar\banglore_medivision\2024\'+space(99),1,99)
datatransferext='dbf'
old_3 = 'YES'
old_4 = 'NO '
old_5 = FIRSTDATE 
old_9 = LASTDATE 
old_6 = '2'
old_7 = 'Y'
old_8 = '#'
scalc='2'
pcalc='2'
old_1="INV"
mstatecode='27'
updateitemdisc='No '
vatgst='GST'
Removecharfrombillno=0
mVersion='01'
@ 05,10 say 'MEDIVISION OLD DATA FROM     :' font 'COURIER',15 get datatransferpath font 'COURIER',15
@ 06,10 say 'MEDIVISION OLD DATA EXTENSON :' font 'COURIER',15 get datatransferext font 'COURIER',15
@ 07,10 say 'WITH O/S                     :' font 'COURIER',15 get old_3 pict '@m YES,NO '  font 'COURIER',15
@ 08,10 say 'MASTER-Y FULL-N              :' font 'COURIER',15 get old_4 pict '@m YES,NO '  font 'COURIER',15
@ 09,10 say 'F.Y.BEGIN FROM               :' font 'COURIER',15 get old_5 font 'COURIER',15
@ 10,10 say 'F.Y.END                      :' font 'COURIER',15 get old_9  font 'COURIER',15
@ 11,10 say 'Calculation(Sale)            :' font 'COURIER',15 get scalc font 'COURIER',15
@ 12,10 say 'Calculation(Purc)            :' font 'COURIER',15 get pcalc  font 'COURIER',15
*@ 19,10 say 'VAT/GST                     :' font 'COURIER',15 get vatgst  font 'COURIER',15 pict '@M GST,VAT'
*@ 16,10 say 'Update Item Discount(Excel)  :' font 'COURIER',15 get updateitemdisc  pict '@M No ,Yes'  font 'COURIER',15
@ 13,10 say 'Billno Start from character  :' font 'COURIER',15 get Removecharfrombillno  pict '99'  font 'COURIER',15
@ 14,10 say 'Version                      :' font 'COURIER',15 get mVersion  pict '@m 01,02'  font 'COURIER',15
@ 15,10 say 'Type SURE                    :' font 'COURIER',15 get sure pict '@x!' font 'COURIER',15
read
datatransferpath=addbs(alltrim(datatransferpath))
datdev=addbs(alltrim(datdev))
datext=alltrim(datext)
if lastkey()=27 .or. sure#'SURE'
    retu
endif
CLEAR
	=starttransfer()
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
dele all for type='#' and aliase='DAT/F'
pack
close data

if old_4 = 'Y'
   do margO
else 
   do margA
endif
     
     
proc margO
use &datdev\pro.&datext excl
zap
use &datdev\probat.&datext  excl
zap
use &datdev\saletype.&datext  excl
ZAP
use &datdev\gledger.&datext excl
zap
use &datdev\mdis.&datext  excl
zap
use &datdev\dis.&datext excl
zap
use &datdev\pend.&datext  excl
zap
use &datdev\pendings.&datext excl
zap
use &datdev\order.&datext excl
dele all
recal all for scode="J"
use &datdev\support.&datext alias support 
dele all for aliase='DAT/'
pack 
close data
rowno=5
@ 02,22 say 'Please Wait Importing Medivision Data To Marg.....' font 'Arial',14 colo 'W+/b'
@rowno,10 say 'Importing Company'  font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'company.dbf'
td=datdev+'saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to
dele all for sgcode = 'ZZZZZZ'
pack
index on scode to mpcm
sele fpcm
go top
do while not eof()
   *@rowno-1,50 say str(recno(),10)   font 'Arial',12
   sele mpcm
   appe blan
   repl mpcm.sgcode with 'ZZZZZZ',;
        mpcm.scode  with ltri(str(fpcm.compcode,6)),;
        mpcm.sname  with fpcm.compname,;
        mpcm.parnam with fpcm.compname,;
        mpcm.tcode with 'No',;
        mpcm.tax with 1

sele fpcm
skip
enddo
clos data
eras mpcm.idx


@rowno,10 say 'Importing Category'    font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'category.dbf'
if file(fd)
   td=datdev+'saletype.'+datext
   sele a
   use &fd alias categ
   sele b
   use &td alias mpcm
   dele all for sgcode = 'CATEGO'
   pack
   index on scode to mpcm
   sele categ
   go top
   do while !eof()
      *@rowno-1,50 say str(recno(),10)   font 'Arial',12
      sele mpcm
      appe blan
      repl mpcm.sgcode with 'CATEOG',;
           mpcm.scode  with ltri(str(categ.catcode,6)),;
           mpcm.sname  with upper(categ.catname),;
           mpcm.parnam with upper(categ.catname),;
            mpcm.tcode with 'No',;
            mpcm.tax with 1
    sele categ
    skip
    enddo
    clos data
    eras mpcm.idx
endif

@rowno,10 say 'Importing Area'   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'area.dbf'
td=datdev+'saletype.'+datext
if file(fd)
   sele a
   use &fd alias fpcm
   sele b
   use &td alias mpcm
   dele all for sgcode = 'AREA  '
   pack
   index on scode to mpcm
   sele fpcm
   go top
   do while !eof()
      *@rowno-1,50 say str(recno(),10)   font 'Arial',12
      sele mpcm
      appe blan
      repl mpcm.sgcode with 'AREA  ',;
           mpcm.scode  with ltri(str(fpcm.areacode,6)),;
           mpcm.sname  with upper(fpcm.areaname),;
           mpcm.parnam with upper(fpcm.areaname),;
           mpcm.tcode with 'No',;
           mpcm.tax with 1
    sele fpcm
    skip
    enddo
    clos data
    eras mpcm.idx
endif


@rowno,10 say 'Importing Godwon'   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'godown.dbf'
td=datdev+'saletype.'+datext
if file(fd)
   sele a
   use &fd alias fpcm
   sele b
   use &td alias mpcm
   set filt to sgcode='GODWON'
   dele all
   pack
   index on scode to mpcm
   sele fpcm
   go top
   do while not eof()
      *@rowno-1,50 say str(recno(),10)  font 'Arial',12
      sele mpcm
      appe blan
      repl mpcm.sgcode with 'GODWON',;
           mpcm.scode  with ltri(str(fpcm.godocode,6)),;
           mpcm.parnam with upper(fpcm.godoname),;
           mpcm.sname  with upper(fpcm.godoname),;
           mpcm.tcode with 'No',;
           mpcm.tax with 1
    sele fpcm
    skip
    enddo
    clos data
    eras mpcm.idx
endif


@rowno,10 say 'Importing Salesman'   font 'Arial',12
rowno=rowno+1
fa=datatransferpath+'salesman.dbf'
td=datdev+'order.'+datext
if file(fd)
   sele sele(1)
   use &fa alias salesman
   sele sele(1)
   use &td alias order
   zap
   slno=1
   sele salesman
   do whil !eof()
      *@rowno-1,50 say str(recno(),10)  font 'Arial',12
      sele order
      appe blan
      repl scode with 'D32',ordno with 'S'+alltri(str(salesman.smancode)),;
           parnam with upper(salesman.smanname),mailnam with upper(salesman.smanname),;
           paradd with salesman.add1,paradd1 with salesman.add2,;
           paradd2 with salesman.add3
    sele salesman
    skip
    enddo
    close data
endif


@rowno,10 say 'Importing A/C Ledgers'   font 'Arial',12
rowno=rowno+1
fa=datatransferpath+'account.DBF'
db=datatransferpath+'daybal.DBF'
gn=datatransferpath+'group.dbf'
td=datdev+'order.'+datext
sele sele(1)
use &db alias daybal
sele c
use &gn alias group
index on grcode to fdet
sele a
use &fa alias fact
sele b
use &td alias mact
sele sele(1)
  use &datdev\support.&datext alias msup
index on aliase + str(sno,3) + lcode to msup
dele all for aliase = 'ORDER   '
dele all for aliase = 'ORDERsms'
pack
cshfnd=.f.
sele fact
go top
do while !eof()
   *@rowno-1,50 say str(recno(),10)  font 'Arial',12
   sele group
   seek fact.grcode
   sele daybal
   loca for accode = fact.accode .and. day = 0
   if drtot#0
      opbal = -drtot
   else
      opbal = -crtot
   endif
   sum -drtot-crtot for accode=fact.accode to ledtot
   sele mact
   appe blan
   repl mact.rate with 'Y',opning with ledtot
   if fact.grcode = 26
      repl mact.scode with 'C6'
   else
      if fact.grcode=25
         repl mact.scode with 'D31'
      else
         if fact.grcode=22
            repl mact.scode with 'J6'
         else
            if fact.grcode=5
               repl mact.scode with 'C2'
            else
               if fact.grcode=1
                  repl mact.scode with 'C1'
               else
                  if fact.grcode=4
                     repl mact.scode with 'B'
                  else
                     if fact.grcode=20
                        repl mact.scode with 'J5'
                     else
                        if fact.grcode=11
                           repl mact.scode with 'J12'
                        endif      
                     endif
                  endif
               endif
            endif
         endif
      endif
   endif
   repl mact.fax2 with ltri(str(fact.accode)),;
        mact.ordno with alltrim(str(fact.accode))
   repl mact.mailnam with upper(fact.acname)
    *    mact.area with ltri(str(fact.areacode,6))
repl        mact.paradd with upper(fact.add1),;
        mact.paradd1 with trim(upper(fact.add2))+' '+allt(upper(fact.add3)),;
        mact.paradd2 with upper(fact.add4),;
        mact.phone1 with fact.tel,;
        mact.itno with fact.pan,;
        mact.dlno with trim(fact.dlno),;
        mact.parnam with subs(upper(fact.acname),1,30)+subs(upper(fact.prnadd),1,15);
        mact.ref with 'Mr.',;
        mact.confir with fact.propname,;
        mact.phone1 with fact.tel,;
        mact.phone4 with fact.mobile,;
        mact.price with 'A',;
        mact.city with upper(fact.prnadd),;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        limit with fact.crlimit,;
        mr with 'S'+alltrim(str(fact.smancode)),;
        area with alltrim(str(fact.areacode)),;
        duedays with fact.dueperiod,;
        disc2 with fact.partycd
if mversion='01'
   repl mact.sthed with  'TIN No.',;
        mact.csthed with 'CST No.',;
        mact.cstno with fact.cst,;
        mact.stno with fact.bst,;
        mact.gstno with fact.gst

  else
     repl mact.gsthed with  'GSTNO '
     repl sthead  with 'TIN No:'
     repl mact.stno with fact.bst
     repl mact.gstno with fact.gstin

endif          
        
        && Email ID
        sele msup
        seek 'ORDER   '+ ' 12' +  mact.ordno
        append blank
        repl aliase with 'ORDER   '
        repl type with 'F'
        repl lcode with mact.ordno
        repl sno with 12
        repl remark with SUBSTR(ALLTRIM(fact.email),1,75)
        repl heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
        
        
sele fact
skip
enddo
SELE MACT 
APPE blank 
repl ordno with 'DS9999' 
repl parnam with 'DISCOUNT DR/CR ADJUSTED' 
repl mailnam with 'DISCOUNT DR/CR ADJUSTED' 
*!*	sele sele(1)
*!*	   use &datatransferpath\bank alias bnk 
*!*	   sele bnk
*!*	   scan
*!*	    sele mact
*!*	    appen blank 
*!*	    repl scode with 'C2'
*!*	    repl ordno with 'BB'+alltrim(str(bnk.bankcode))
*!*	    repl mailnam with bnk.bankname
*!*	    repl parnam with bnk.bankname
*!*	   endsc
    
close data
eras fdet.idx


@rowno,10 say 'Importing Products'   font 'Arial',12
rowno=rowno+1

mf=datatransferpath+'mfg.dbf'
fd=datatransferpath+'product.dbf'
ft=datatransferpath+'taxcategorytran.dbf'
fh=datatransferpath+'hsncategory.dbf'
td=datdev+'pro.'+datext
ts = datdev+'saletype.'+datext
    
sele sele(1)
use &fh alias fhsn
index on str(hsncode,5) to fhsn 
    
sele sele(1)
use &ts alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm

sele sele(1)
use &datdev\support.&datext alias support
dele all for type = 'F' and aliase = 'PRODUCT' and lcode = 'TAXPER' and sno = 1
pack
sele sele(1)
use &mf alias mfg
sele sele(1)
use &fd alias fitm

select select(1)
use &ft alias ftax
index on taxcatcode to ftax
set filter to taxcode = 1
sele sele(1)
use &td alias mitm
zap
index on name to mitm

sele fitm
go top
do while !eof()
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last=recno()
    sele mfg
    loca for mfgcode=fitm.mfgcode
    select ftax
    seek fitm.taxcatcode
    
    sele fhsn
    seek str(fitm.hsncode,5)
    
    sele mitm
    seek str(fitm.prodcode,10)
    if !found()
       appe blan
       repl code with fitm.prodcode
       repl name with str(fitm.prodcode,10)
       repl product with fitm.prodname
       repl packing with fitm.unit
       repl billname with allt(fitm.prodname)+' '+trim(fitm.unit)
       repl unit with fitm.unit
       repl formulano with left(mfg.mfgname,15)
       repl gcode with ltri(str(fitm.compcode,6))
       repl gcode3 with ltri(str(fitm.drugcode,6))
       repl gcode5 with ltri(str(fitm.catcode,6))
       repl gcode6 with ltri(str(fitm.hsncode,6))
       repl taxl with iif(fitm.salestax#0,'T','E')
       repl taxc with 'T'
       repl decimal with 'Y'
       repl salfix with 'N'
       repl minimum with fitm.minqty
       repl maximum with fitm.maxqty
       repl halfsche with 'A'
       repl qtrsche with 'Y'
       repl saltax with ftax.taxperc
       repl cgst with ftax.taxperc
       repl igst with ftax.taxperc*2
       repl status with 'Y'
       repl misc5 with substr(misc5,1,32)+IIF(fitm.prodtype=3,'Y','N')+substr(misc5,43,100)
       if fitm.lbtperc#0
          sele support
          appe blank
          repl type with "F",aliase with "PRODUCT"
          repl lcode with "TAXPER",pcode with mitm.code,sno with 1
          repl remark with subs(remark,1,26)+str(fitm.lbtperc,5,2)+subs(remark,32)
       endif
       
       &&For HSN
       sele mpcm
       seek 'COMMCD' + substr(fhsn.hsncatcode+space(15),1,15) + str(mitm.igst,5,2)
       if !found()
          append blank
          repl mpcm.sgcode with 'COMMCD',;
               mpcm.scode  with 'C'+alltrim(str(last)),;
               mpcm.sname  with substr(fhsn.hsncatcode+space(15),1,15)+ substr(fhsn.hsncatcode,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
               mpcm.parnam with substr(fhsn.hsncatcode,1,15),;
               mpcm.tax with mitm.saltax,;
               mpcm.cgst with mitm.cgst,;
               mpcm.igst with mitm.igst,;
               mpcm.tcode with 'No'
       endif
       repl mitm.gcode6 with mpcm.scode
    endif
sele fitm
skip
enddo
clos data
eras mitm.idx



@rowno,10 say 'Importing Batch/Stock '   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'stock.dbf'
pd=datatransferpath+'product.dbf'
td=datdev+'probat.'+datext
mi=datdev+'pro.'+datext
fs=datatransferpath+'scheme.dbf'
sele sele(1)
use &fs alias sch
index on str(prodcode,10)+str(stockid,10) to sch
sele sele(1)
use &fd alias batchmst
sele sele(1)
use &mi alias pro
inde on name to pro
sele sele(1)
use &td alias probat
inde on name+batchno to probat
r=0
sele batchmst
go top
do while !eof()
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    =seek(str(batchmst.prodcode,10),'pro')
    =seek(str(batchmst.prodcode,10)+str(batchmst.stockid,10),'sch')
    sele probat
    seek str(batchmst.prodcode,10)+padr(batchmst.batchcode+space(12),12)
    if !found()
       appe blank
       repl code     with pro.code,;
            name     with pro.name,;
            billname with pro.billname,;
            product  with pro.product,;
            pack     with pro.pack,;
            packing  with pro.packing,;
            unit2    with pro.unit2,;
            unit     with pro.unit,;
            decimal  with 'Y',;
            batchno  with batchmst.batchcode,;
            exp      with batchmst.expdate,;
            lprate   with batchmst.purccost1,;
            prate    with batchmst.purrate,;
            ratea    with batchmst.wrate,;
            rateb    with batchmst.Rrate,; 
            ratec    with batchmst.Orate,; 
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl probat.opening with batchmst.balance,;
            probat.balance with batchmst.balance,;
            b_a with batchmst.balance,;
            o_a with batchmst.balance,;
            claim with batchmst.balance
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate,;
            purdeal with sch.qty1,;
            purfree with sch.free1,;
            purdis with batchmst.dlessperc
    else
       repl probat.opening with probat.opening+batchmst.balance,;
            probat.balance with probat.balance+batchmst.balance,;
            b_a with b_a + batchmst.balance,;
            o_a with o_a + batchmst.balance
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate,;
            purdeal with sch.qty1,;
            purfree with sch.free1,;
            purdis with batchmst.dlessperc,;
            claim with claim + batchmst.balance
    endif
sele batchmst
skip
enddo
sele probat
repl all date with old_5-1 for balance=0
clos data
eras pro.idx
eras probat.idx


@rowno,10 say 'Importing Batch/Stock (History)'   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'ratehist.dbf'
pd=datatransferpath+'product.dbf'
td=datdev+'probat.'+datext
mi=datdev+'pro.'+datext
sele sele(1)
use &fd alias batchmst
sele sele(1)
use &mi alias pro
inde on name to pro
sele sele(1)
use &td alias probat
inde on name+batchno to probat
r=0
sele batchmst
go top
do while !eof()
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    =seek(str(batchmst.prodcode,10),'pro')
    sele probat
    seek str(batchmst.prodcode,10)+padr(batchmst.batchcode+space(12),12)
    if !found()
       appe blank
       repl code     with pro.code,;
            name     with pro.name,;
            billname with pro.billname,;
            product  with pro.product,;
            pack     with pro.pack,;
            packing  with pro.packing,;
            unit2    with pro.unit2,;
            unit     with pro.unit,;
            decimal  with 'Y',;
            batchno  with batchmst.batchcode,;
            exp      with batchmst.expdate,;
            prate    with batchmst.purrate,;
            ratea    with batchmst.wrate,;
            rateb    with batchmst.rrate,;
            ratec    with batchmst.orate,;
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl purdis with batchmst.dlessperc
    else
       repl purdis with batchmst.dlessperc
    endif
sele batchmst
skip
enddo
sele probat
repl all date with old_5-1 for balance=0
clos data
eras pro.idx
eras probat.idx


@rowno,10 say 'Importing SALT/Composition'   font 'Arial',12
rowno=rowno+1
sele sele(1)
  use &datatransferpath\drug alias drug  
sele sele(1)
  use &datdev\saletype.&datext alias stype 
sele drug
scan
  sele stype
  appen blank 
  repl sgcode with 'SALT'
  repl scode with alltrim(str(drug.drugcode))
  repl sname with subs(drug.drugname,1,40)
  repl tname with subs(drug.drugname,41)
endscan
close table all

*!* @rowno,10 say 'Importing Outstanding '   font 'Arial',12
*!* rowno=rowno+1

*!* if old_3='Y'
*!*    af=datdev + 'pend.'+datext
*!*    sele a
*!*    use &af alias mpend
*!*    zap
*!*    af=datdev + 'gledger.'+datext
*!*    sele a
*!*    use &af alias mpend
*!*    zap
*!*    af=datdev + 'dis.'+datext
*!*    sele a
*!*    use &af alias mpend
*!*    zap
*!*    af=datdev + 'mdis.'+datext
*!*    sele a
*!*    use &af alias mpend
*!*    zap
*!*    af=datdev + 'pendings.'+datext
*!*    sele a
*!*    use &af alias mpend
*!*    zap
*!*    fa=datatransferpath + 'opbill.dbf'
*!*    t1=datdev + 'pendings.'+datext
*!*    t2=datdev + 'slipno.'+datext
*!*    sele a
*!*    use &fa alias fout
*!*    sele c
*!*    use &t1 alias mpending
*!*    sele e
*!*    use &t2 alias mslip
*!*    go bott
*!*    vou  = voucher + 10
*!*    svou = svoucher + 10
*!*    sele fout
*!*    set filt to enttype = 4 .or. enttype = 3 .or. enttype = 5 .or. enttype = 22
*!*    go top
*!*    do while !eof()
*!*       sele c
*!*       append blank
*!*       repl mpending.acgroup with iif(fout.enttype=4,'C6','D31'),;
*!*            mpending.ord with alltrim(str(fout.accode)),;
*!*            mpending.ddate with fout.date,;
*!*            mpending.vcn with fout.billno,;
*!*            mpending.invtype with 'O',;
*!*            mpending.voucher  with vou,;
*!*            mpending.svoucher with svou,;
*!*            mpending.duedate with fout.duedate,;
*!*            mpending.duedays with duedate-ddate,;
*!*            mpending.name with fout.billno
*!*            
*!*            if fout.enttype = 4 .or. fout.enttype = 5 .or. fout.enttype = 22
*!*               repl mpending.itemope with 0,;
*!*                    mpending.final with fout.billamt,;
*!*                    mpending.balance with fout.billamt,;
*!*                    mpending.acgroup with 'C6'
*!*            else
*!*               if fout.enttype = 3
*!*                  repl mpending.itemope with 0,;
*!*                       mpending.final with -fout.billamt,;
*!*                       mpending.balance with -fout.billamt,;
*!*                       mpending.acgroup with 'D31'
*!*               endif
*!*            endif
*!*    vou=vou+5
*!*    svou=svou+5
*!*    sele fout
*!*    skip
*!*    enddo
*!* sele c
*!* sele mslip
*!* repl voucher  with vou+5
*!* repl svoucher with svou+5
*!* close data
*!* endif


proc margA
clear

 
rowno=3    
@02,22 say 'Please Wait Importing Medivision Data To Marg.....' font 'Arial',14 colo 'W+/b'
@Rowno,10 say 'Importing Company'  font 'Arial',12
Rowno=Rowno+1

fd=datatransferpath+'company.dbf'
td=datdev+'\saletype.'+datext

sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to
dele all for sgcode = 'ZZZZZZ'
pack
index on scode to mpcm
sele fpcm
go top
do while not eof()
   sele mpcm
   appe blan
   repl mpcm.sgcode with 'ZZZZZZ',;
        mpcm.scode  with ltri(str(fpcm.compcode,6)),;
        mpcm.sname  with fpcm.compname,;
        mpcm.parnam with fpcm.compname,;
        mpcm.tcode with 'No',;
        mpcm.tax with 1
sele fpcm
skip
enddo
clos data
eras mpcm.idx



@rowno,10 say 'Importing Category'    font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'category.dbf'
if file(fd)
   td=datdev+'\saletype.'+datext
   sele a
   use &fd alias categ
   sele b
   use &td alias mpcm
   dele all for sgcode = 'CATEGO'
   pack
   index on scode to mpcm
   sele categ
   go top
   do while !eof()
      sele mpcm
      appe blan
      repl mpcm.sgcode with 'CATEGO',;
           mpcm.scode  with alltri(str(categ.catcode,6)),;
           mpcm.sname  with upper(categ.catname),;
           mpcm.parnam with upper(categ.catname),;
            mpcm.tcode with 'No',;
            mpcm.tax with 1
    sele categ
    skip
    enddo
    clos data
    eras mpcm.idx
endif

@rowno,10 say 'Importing Area'   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'area.dbf'
td=datdev+'\saletype.'+datext
if file(fd)
   sele a
   use &fd alias fpcm
   sele b
   use &td alias mpcm
   dele all for sgcode = 'AREA  '
   pack
   index on scode to mpcm
   sele fpcm
   go top
   do while !eof()
      *@rowno-1,50 say str(recno(),10)   font 'Arial',12
      sele mpcm
      appe blan
      repl mpcm.sgcode with 'AREA  ',;
           mpcm.scode  with ltri(str(fpcm.areacode,6)),;
           mpcm.sname  with upper(fpcm.areaname),;
           mpcm.parnam with upper(fpcm.areaname),;
           mpcm.tcode with 'No',;
           mpcm.tax with 1
    sele fpcm
    skip
    enddo
    clos data
    eras mpcm.idx
endif


@rowno,10 say 'Importing Godwon'   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'godown.dbf'
td=datdev+'\saletype.'+datext
if file(fd)
   sele a
   use &fd alias fpcm
   sele b
   use &td alias mpcm
   set filt to sgcode='GODWON'
   dele all
   pack
   index on scode to mpcm
   sele fpcm
   go top
   do while not eof()
      *@rowno-1,50 say str(recno(),10)  font 'Arial',12
      sele mpcm
      appe blan
      repl mpcm.sgcode with 'GODWON',;
           mpcm.scode  with ltri(str(fpcm.godocode,6)),;
           mpcm.parnam with upper(fpcm.godoname),;
           mpcm.sname  with upper(fpcm.godoname),;
           mpcm.tcode with 'No',;
           mpcm.tax with 1
    sele fpcm
    skip
    enddo
    clos data
    eras mpcm.idx
endif


@rowno,10 say 'Importing Salesman'   font 'Arial',12
rowno=rowno+1
fa=datatransferpath+'salesman.dbf'
td=datdev+'\order.'+datext
if file(fd)
   sele sele(1)
   use &fa alias salesman
   sele sele(1)
   use &td alias order
   zap
   slno=1
   sele salesman
   do whil !eof()
      *@rowno-1,50 say str(recno(),10)  font 'Arial',12
      sele order
      appe blan
      repl scode with 'D32',ordno with 'S'+alltri(str(salesman.smancode)),;
           parnam with upper(salesman.smanname),mailnam with upper(salesman.smanname),;
           paradd with salesman.add1,paradd1 with salesman.add2,;
           paradd2 with salesman.add3
    sele salesman
    skip
    enddo
    close data
endif


@rowno,10 say 'Importing A/C Ledgers'   font 'Arial',12
rowno=rowno+1
fa=datatransferpath+'account.DBF'
db=datatransferpath+'daybal.DBF'
gn=datatransferpath+'group.dbf'
td=datdev+'\order.'+datext
sele sele(1)
use &db alias daybal
sele c
use &gn alias group
index on grcode to fdet
sele a
use &fa alias fact
sele b
use &td alias mact
cshfnd=.f.

sele sele(1) 
  use &datdev\support.&datext alias supp 
  index on aliase + str(sno,3) + lcode to supp 
         dele all for aliase = 'ORDER   '
         dele all for aliase = 'ORDERsms'

sele fact
go top
do while !eof()
   *@rowno-1,50 say str(recno(),10)  font 'Arial',12
   sele group
   seek fact.grcode
   sele daybal
   loca for accode = fact.accode .and. day = 0
   if drtot#0
      opbal = -drtot
   else
      opbal = -crtot
   endif
   sum -drtot-crtot for accode=fact.accode to ledtot
   sele mact
   appe blan
   repl mact.rate with 'Y',opning with opbal,balance with opbal,target with ledtot,COUT WITH LEDTOT
   if fact.grcode = 26
      repl mact.scode with 'C6'
   else
      if fact.grcode=25
         repl mact.scode with 'D31'
      else
         if fact.grcode=22
            repl mact.scode with 'J6'
         else
            if fact.grcode=5 OR FACT.GRCODE=2
               repl mact.scode with 'C2'
            else
               if fact.grcode=1
                  repl mact.scode with 'C1'
               else
                  if fact.grcode=4
                     repl mact.scode with 'B'
                  else
                     if fact.grcode=20
                        repl mact.scode with 'J5'
                     else
                        if fact.grcode=11
                           repl mact.scode with 'J12'
                        endif      
                     endif
                  endif
               endif
            endif
         endif
      endif
   endif
   repl mact.fax2 with allt(fact.alias)
   repl mact.ordno with alltrim(str(fact.accode))
   repl mact.mailnam with upper(fact.acname)
    REPL  mact.area with ltri(str(fact.areacode,6))
repl        mact.paradd with upper(fact.add1),;
        mact.paradd1 with trim(upper(fact.add2))+' '+allt(upper(fact.add3)),;
        mact.phone1 with fact.tel,;
        mact.dlno with trim(fact.dlno),;
        mact.ref with 'Mr.'
     REPL mact.confir with fact.propname
repl        mact.phone1 with fact.tel,;
        mact.phone4 with fact.tel,;
        mact.price with 'A',;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        limit with fact.crlimit
REPL    mr with 'S'+alltrim(str(fact.smancode))
    REPL    area with alltrim(str(fact.areacode))
repl        duedays with fact.dueperiod
REPL        disc1 with fact.partycd 

if mversion='01'
   repl mact.sthed with  'TIN No.',;
        mact.csthed with 'CST No.',;
        mact.cstno with fact.cst,;
        mact.stno with fact.bst,;
        mact.gstno with fact.gst,;
        mact.itno with fact.pan,;
        mact.city with upper(fact.prnadd),;
        mact.parnam with subs(upper(fact.acname),1,30)+subs(upper(fact.prnadd),1,15)

  else
    sele mact
     repl mact.gsthed with  'GSTNO '
     repl sthed  with 'TIN No:'
     repl mact.stno with fact.bstno
     repl mact.gstno with fact.gstin
     repl         mact.parnam with subs(upper(fact.acname),1,30)


endif          

    sele supp 
    appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '

    && Email ID
        sele supp 
        seek 'ORDER   '+ ' 12' +  mact.ordno
        append blank
        repl aliase with 'ORDER   '
        repl type with 'F'
        repl lcode with mact.ordno
        repl sno with 12
        repl remark with SUBSTR(ALLTRIM(fact.email),1,75)
        repl heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')
   

sele fact
skip
enddo
SELE MACT 
APPE blank 
repl ordno with 'DS9999' 
repl parnam with 'DISCOUNT DR/CR ADJUSTED' 
repl mailnam with 'DISCOUNT DR/CR ADJUSTED' 
APPEN BLANK
REPL ORDNO WITH 'OTHER1'
repl scode with 'J12'
repl parnam with 'Others'
repl mailnam with 'Others'
sele sele(1)
   use &datatransferpath\bank alias bnk 
   sele bnk
   scan
    sele mact
    appen blank 
    repl scode with 'C2'
    repl ordno with 'BB'+alltrim(str(bnk.bankcode))
    repl mailnam with bnk.bankname
    repl parnam with bnk.bankname
   endsc


close data
eras fdet.idx

@rowno,10 say 'Importing SALT/Composition'   font 'Arial',12
rowno=rowno+1
sele sele(1)
  use &datatransferpath\drug alias drug  
sele sele(1)
  use &datdev\saletype.&datext alias stype 
sele drug
scan
  sele stype
  appen blank 
  repl sgcode with 'SALT'
  repl scode with alltrim(str(drug.drugcode))
  repl sname with subs(drug.drugname,1,40)
  repl tname with subs(drug.drugname,41)
endscan
close table all 
    

@rowno,10 say 'Importing Products'   font 'Arial',12
rowno=rowno+1

mf=datatransferpath+'mfg.dbf'
fd=datatransferpath+'product.dbf'
ft=datatransferpath+'taxcategorytran.dbf'
fh=datatransferpath+'hsncategory.dbf'
td=datdev+'\pro.'+datext
ts = datdev+'\saletype.'+datext
    
sele sele(1)
use &fh alias fhsn
index on str(hsncode,5) to fhsn 
    
sele sele(1)
use &ts alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm

sele sele(1)
use &datdev\support.&datext alias support
dele all for type = 'F' and aliase = 'PRODUCT' and lcode = 'TAXPER' and sno = 1
pack
if mVersion='01'
sele sele(1)
use &mf alias mfg
endif
sele sele(1)
use &fd alias fitm

select select(1)
use &ft alias ftax
index on taxcatcode to ftax
set filter to taxcode = 1
sele sele(1)
use &td alias mitm
zap
index on name to mitm

sele fitm
go top
do while !eof()
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last=recno()
if mversion='01'    
    sele mfg
    loca for mfgcode=fitm.mfgcode
endif    
    select ftax
    seek fitm.taxcatcode
    
    sele fhsn
    seek str(fitm.hsncode,5)
    
    sele mitm
    seek str(fitm.prodcode,10)
    if !found()
       appe blan
       repl code with recno()  &&&&fitm.prodcode
       repl name with str(fitm.prodcode,10)
       
       repl product with fitm.prodname
       repl packing with fitm.unit
       repl billname with allt(fitm.prodname)+' '+trim(fitm.unit)
       repl unit with fitm.unit
if mversion='01'       
       repl formulano with left(mfg.mfgname,15)
endif       
       repl gcode with ltri(str(fitm.compcode,6))
       repl gcode5 with alltri(str(fitm.catcode,6))
       repl gcode6 with ltri(str(fitm.hsncode,6))
       repl gcode3 with alltrim(str(fitm.drugcode))
       repl taxl with iif(fitm.salestax#0,'T','E')
       repl taxc with 'T'
       repl decimal with 'Y'
       repl salfix with 'N'
if mversion='01'       
*       repl minimum with fitm.minqty
*       repl maximum with fitm.maxqty
endif       
       repl halfsche with 'A'
       repl qtrsche with 'Y'
       repl saltax with ftax.taxperc
       repl cgst with ftax.taxperc
       repl igst with ftax.taxperc*2
       repl status with 'Y'
       repl misc6 with str(fitm.balqty,10,2)
if mversion='01'       
       if fitm.lbtperc#0
          sele support
          appe blank
          repl type with "F",aliase with "PRODUCT"
          repl lcode with "TAXPER",pcode with mitm.code,sno with 1
          repl remark with subs(remark,1,26)+str(fitm.lbtperc,5,2)+subs(remark,32)
       endif
endif       
SELE SUPPORT
APPEN BLANK 
repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,value with FITM.BALQTY

       &&For HSN
       sele mpcm
       seek 'COMMCD' + substr(fhsn.hsncatcode+space(15),1,15) + str(mitm.igst,5,2)
       if !found()
          append blank
          repl mpcm.sgcode with 'COMMCD',;
               mpcm.scode  with 'C'+alltrim(str(last)),;
               mpcm.sname  with substr(fhsn.hsncatcode+space(15),1,15)+ substr(fhsn.hsncatcode,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
               mpcm.parnam with substr(fhsn.hsncatcode,1,15),;
               mpcm.tax with mitm.saltax,;
               mpcm.cgst with mitm.cgst,;
               mpcm.igst with mitm.igst,;
               mpcm.tcode with 'No'
       endif
       repl mitm.gcode6 with mpcm.scode
    endif
sele fitm
skip
enddo
clos data
eras mitm.idx
close data 
if updateitemdisc='Y'
  * do UpdateDiscount 
endif
close data 



@rowno,10 say 'Importing Batch/Stock (Opening) '   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'opstock.dbf'
pd=datatransferpath+'product.dbf'
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
fs=datatransferpath+'scheme.dbf'
sele sele(1)
use &fs alias sch
index on str(prodcode,10)+str(stockid,10) to sch

sele sele(1)
use &fd alias batchmst
sele sele(1)
use &mi alias pro
inde on name to pro
sele sele(1)
use &td alias probat
zap
inde on name+batchno to probat
r=0
sele batchmst
go top
do while not eof()
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    =seek(str(batchmst.prodcode,10),'pro')
    =seek(str(batchmst.prodcode,10)+str(batchmst.stockid,10),'sch')
    sele probat
    seek str(batchmst.prodcode,10)+padr(batchmst.batchcode+space(12),12)
    if !found()
       appe blan
       repl code     with pro.code,;
            name     with pro.name,;
            billname with pro.billname,;
            product  with pro.product,;
            pack     with pro.pack,;
            packing  with pro.packing,;
            unit2    with pro.unit2,;
            unit     with pro.unit,;
            decimal  with 'Y',;
            batchno  with batchmst.batchcode
       repl exp      with batchmst.expdate
       repl lprate   with iif(mversion='01',batchmst.purccost1,batchmst.purrate),;
            prate    with batchmst.purrate,;
            ratea    with iif(mversion='01',batchmst.wrate,batchmst.salerate1),;&&&batchmst.wrate &&&
            rateb    with batchmst.ptr,;&&&batchmst.rrate &&&
            ratec    with iif(mversion='01',batchmst.purccost2,batchmst.salerate2),;&&&batchmst.orate 
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl probat.opening with batchmst.qty,;
            probat.balance with batchmst.qty,;
            b_a with batchmst.qty,;
            o_a with batchmst.qty
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate,;
            purdeal with sch.qty1,;
            purfree with iif(mversion='01',sch.free1,sch.schqty1),;
            purdis with batchmst.dlessperc
            
    else
        repl probat.opening with probat.opening+batchmst.qty,;
             probat.balance with probat.balance+batchmst.qty,;
             b_a with b_a + batchmst.qty,;
             o_a with o_a+batchmst.qty
        repl supinvo with batchmst.billno,;
             supdat   with batchmst.billdate,;
             purdeal with sch.qty1,;
             purfree with iif(mversion='01',sch.free1,sch.schqty1),;
             purdis with batchmst.dlessperc
    endif
sele batchmst
skip
enddo
sele probat
repl all date with old_5-1 for balance=0
clos data
eras pro.idx
eras probat.idx



@rowno,10 say 'Importing Batch/Stock '   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'stock.dbf'
pd=datatransferpath+'product.dbf'
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
fs=datatransferpath+'scheme.dbf'
sele sele(1)
use &fs alias sch
index on str(prodcode,10)+str(stockid,10) to sch
sele sele(1)
use &fd alias batchmst
sele sele(1)
use &mi alias pro
inde on name to pro
sele sele(1)
use &td alias probat
inde on name+batchno to probat
r=0
sele batchmst
go top
do while !eof()
    **@rowno-1,50 say str(recno(),10)  font 'Arial',12
    =seek(str(batchmst.prodcode,10),'pro')
    =seek(str(batchmst.prodcode,10)+str(batchmst.stockid,10),'sch')
    sele probat
    seek str(batchmst.prodcode,10)+padr(batchmst.batchcode+space(12),12)
    if !found()
       appe blank
       repl code     with pro.code,;
            name     with pro.name,;
            billname with pro.billname,;
            product  with pro.product,;
            pack     with pro.pack,;
            packing  with pro.packing,;
            unit2    with pro.unit2,;
            unit     with pro.unit,;
            decimal  with 'Y',;
            batchno  with batchmst.batchcode,;
            exp      with batchmst.expdate,;
            lprate   with iif(mversion='01',batchmst.purccost1,batchmst.purrate),;
            prate    with batchmst.purrate,;
            ratea    with iif(mversion='01',batchmst.wrate,batchmst.salerate1),;
            rateb    with batchmst.ptr,;
            ratec    with iif(mversion='01',batchmst.purccost2,batchmst.salerate2),;
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl probat.opening with 0,;
            probat.balance with 0,;
            b_a with 0,;
            o_a with 0,;
            claim with batchmst.balance
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate,;
            purdeal with sch.qty1,;
            purfree with iif(mversion='01',sch.free1,sch.schqty1),;
            purdis with batchmst.dlessperc
    else
       repl probat.opening with probat.opening+0,;
            probat.balance with probat.balance+0,;
            b_a with b_a + 0,;
            o_a with o_a + 0
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate,;
            purdeal with sch.qty1,;
            purfree with iif(mversion='01',sch.free1,sch.schqty1),;
            purdis with batchmst.dlessperc,;
            claim with claim + batchmst.balance
    endif
    SELE PRO 
    REPL misc6 with str(val(misc6)+batchmst.balance,10,2)
sele batchmst
skip
enddo
sele probat
repl all date with old_5-1 for balance=0
clos data
eras pro.idx
eras probat.idx


@rowno,10 say 'Importing Batch/Stock (History)'   font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'ratehist.dbf'
pd=datatransferpath+'product.dbf'
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
sele sele(1)
use &fd alias batchmst
sele sele(1)
use &mi alias pro
inde on name to pro
sele sele(1)
use &td alias probat
inde on name+batchno to probat
r=0
sele batchmst
go top
do while !eof()
    =seek(str(batchmst.prodcode,10),'pro')
    sele probat
    seek str(batchmst.prodcode,10)+padr(batchmst.batchcode+space(12),12)
    if !found()
       appe blank
       repl code     with pro.code,;
            name     with pro.name,;
            billname with pro.billname,;
            product  with pro.product,;
            pack     with pro.pack,;
            packing  with pro.packing,;
            unit2    with pro.unit2,;
            unit     with pro.unit,;
            decimal  with 'Y',;
            batchno  with batchmst.batchcode,;
            exp      with batchmst.expdate,;
            prate    with batchmst.purrate,;
            ratea    with batchmst.wrate &&iif(mversion='01',batchmst.wrate,batchmst.salerate1),;
            rateb    with batchmst.rrate,; &&batchmst.ptr,;
            ratec    with batchmst.orate,; &&batchmst.ptr,;
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl purdis with batchmst.dlessperc
    else
       repl purdis with batchmst.dlessperc
    endif
sele batchmst
skip
enddo
sele probat
repl all date with old_5-1 for balance=0
clos data
eras pro.idx
eras probat.idx


@rowno,10 say 'Importing Outstanding '   font 'Arial',12
rowno=rowno+1

if old_3='Y'
   af=datdev + '\pend.'+datext
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
   af=datdev + '\pendings.'+datext
   sele a
   use &af alias mpend
   zap
   fa=datatransferpath + 'opbill.dbf'
   t1=datdev + '\pendings.'+datext
   t2=datdev + '\slipno.'+datext
   sele a
   use &fa alias fout
   sele c
   use &t1 alias mpending
   sele e
   use &t2 alias mslip
   go bott
   vou  = voucher + 10
   svou = svoucher + 10
  sele sele(1)
    use &datatransferpath\btra alias btr 
    index on billintern to btr 
    
   sele fout
   set filt to enttype = 4 .or. enttype = 3 .or. enttype = 5 .or. enttype = 22 OR ENTTYPE=1
  
  SELE FOUT

   go top
   do while !eof()
      sele btr
      seek fout.internal
      sum amount to tot while billintern=fout.internal 
      
      sele c
      append blank
      repl mpending.acgroup with iif(fout.enttype=4,'C6','D31'),;
           mpending.ord with alltrim(str(fout.accode)),;
           mpending.ddate with fout.date,;
           mpending.vcn with fout.billno,;
           mpending.invtype with 'O',;
           mpending.voucher  with vou,;
           mpending.svoucher with svou,;
           mpending.duedate with fout.duedate,;
           mpending.duedays with duedate-ddate,;
           mpending.name with fout.billno
           
           if fout.enttype = 4 .or. fout.enttype = 5 .or. fout.enttype = 22 OR FOUT.ENTTYPE=1
              repl mpending.itemope with 0,;
                   mpending.final with IIF(FOUT.ENTTYPE=1,-FOUT.BILLAMT,fout.billamt),;
                   mpending.balance with IIF(FOUT.ENTTYPE=1,-FOUT.BILLAMT,fout.billamt),;
                   mpending.acgroup with 'C6'
           else
              if fout.enttype = 3
                 repl mpending.itemope with tot,;
                      mpending.final with -fout.billamt,;
                      mpending.balance with -fout.billamt,;
                      mpending.acgroup with 'D31'
              endif
           endif
   vou=vou+5
   svou=svou+5
   sele fout
   skip
   enddo
sele c
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close data
endif



@rowno,10 say 'Importing Purchases'   font 'Arial',12
rowno=rowno+1
slp=datdev+'\slipno.'+datext
sele sele(1)
use &slp  alias mslip
sele mslip
go top
last4 = voucher + 10
slast5= svoucher + 10

probat= datdev + '\probat.'+datext
pro   = datdev + '\pro.'+datext
gled  = datdev + '\gledger.'+datext
dis   = datdev + '\dis.'+datext
mdis  = datdev + '\mdis.'+datext
ordr  = datdev + '\order.'+datext

sele sele(1)
use &datatransferpath\gstaxtran alias gst
index on str(internal,9) + str(prodcode,9) to gst

sele sele(1)
use &probat alias probat
index on str(code)+batchno to probat
sele sele(1)
use &gled alias gledger
dele for book = 'A'
pack
sele sele(1)
use &dis alias dis
zap
sele sele(1)
use &mdis alias mdis
zap
sele sele(1)
use &ordr alias order

purc=datatransferpath+'purc'
pudt=datatransferpath+'putr'
acct=datatransferpath+'account'
trns=datatransferpath+'transport'

sele sele(1)
use &acct alias acct
index on accode to acct
sele sele(1)
use &purc alias purc
set filter to (date >= old_5 and date<=old_9)
sele sele(1)
use &pudt alias putr
inde on internal to putr
if mversion='01'
sele sele(1)
use &trns alias transport
endif

sele sele(1)
  use &datdev\support.&datext alias support
  INDEX on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

sele sele(1)
  use &datdev\pro.&datext alias pro  
  index on name to pro 
*!*	sele sele(1)
*!*	  use &datdev\probat.&datext alias msbal 
*!*	  index on str(code)+batchno to msbal
sele purc
go top
do while !eof()
   **@rowno-1,50 say str(recno(),10)  font 'Arial',12
   last1  = vchno
   sele acct
   seek purc.accode
   sele mdis
   append blank
   last4=last4+5
   repl type with 'P'
if mversion='01'   
   if purc.totcst=0 and purc.tottax=0 and purc.totsurc=0
      repl misc3 with subs(misc3,1,53)+'R'+substr(misc3,55)
   else
      repl misc3 with subs(misc3,1,53)+'T'+substr(misc3,55)
   endif
endif   
   repl vcn with iif(empty(last1),purc.billno,last1)
   repl date with purc.date
   repl pm with purc.billno
   repl lrda with purc.billdate
   repl codep with alltrim(str(purc.accode))
   repl amountt with (purc.net)
   repl salun with ''
   repl staxun with 'SZTZOZ'
if mversion='01'   
   repl discount with purc.totdisc
   repl other with PURC.cradjamt
   repl freight with -purc.lessamt
   repl round with purc.rnd
   REPL bddis with purc.percdisc
endif   
	repl packing with purc.others
	repl othun with 'OTHER1'
   repl ltype with pcalc
   repl voucher with last4
   if purc.trantype=1
      repl cash with purc.net+purc.dradjamt
   else
      repl final with purc.net+purc.dradjamt
   endif
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
*   repl addis with purc.percdisc
   repl duedays with 0
   repl account with 'N'
   repl sale with 'Z'
   repl godwon with 'A'
   repl ltype with pcalc
   repl discafter with 'N'
   repl remark4 with last1
   repl remark1 with str(purc.net,12,2)
if mversion='01'   
   if purc.trptcode#0
      sele transport
      loca for trptcode=purc.trptcode
      sele mdis
      repl transport with transport.trptname
   endif
endif   
sele support
APPE blank
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

   sele putr
   seek purc.internal
   do while internal = purc.internal .and. !eof()
      =seek(str(internal,9)+str(prodcode,9),'gst')
      =seek(str(prodcode,10),'pro')
      sele dis
      appe blan
      repl codep with mdis.codep
      repl vcn with mdis.vcn
      repl date with mdis.date
      repl voucher with mdis.voucher
      repl code with pro.code
      repl tax with iif(putr.dstperc#0,'T','E')
      repl qty with putr.qty
      repl free with iif(mversion='01',putr.free,putr.schqty)
      repl exp with putr.expdate
      repl batch with putr.batchcode
      repl misc4 with substr(misc4,1,14)+'M'+substr(misc4,16)
      repl flg with 'P'
      repl rate with putr.purrate
      repl disc1 with putr.dlessperc
if mversion='01'      
      repl disc2 with putr.sdperc
      repl svdis with putr.schdisc              
  if putr.dlessamt#0
    repl svdis1 with putr.dlessamt
  endif  
endif      
repl misc4 with subs(misc4,1,43)+'LU'+subs(misc4,46)

      repl mrp with putr.mrp
      repl half with 'A'
      repl godwon with mdis.godwon
      repl tax with "T"
      repl ssta with iif(mversion='01',putr.taxperc1,putr.rstperc)
      repl cgst with iif(mversion='01',IIF(inlist(PUTR.taxperc1,5,12,18,28),0,putr.taxperc2),putr.rstperc)
	  lcl=IIF(inlist(PUTR.taxperc1,5,12,18,28),'C','N')
if mversion='01'      
    IF putr.taxamt3#0 and putr.qty#0   
      repl cessinrs with val(str(putr.taxamt3/putr.qty,9,2))
    endif
endif    
    if seek(str(dis.code)+dis.batch,'probat')
      repl probat.deal with dis.qty,probat.free with dis.free
      repl probat.PURdeal with dis.qty,probat.PURfree with dis.free
    endif
   sele putr
   skip
   enddo
 repl MDIS.misc3 with substr(MDIS.misc3,1,64)+lcl+substr(mdis.misc3,66)
   
sele purc
skip
enddo
close data
eras putr.idx
close data


@rowno,10 say 'Importing Stock Adj(Self Receive)'   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\gstaxtran alias gst
index on str(internal,9) + str(prodcode,9) to gst
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datatransferpath\stock alias stock
index on stockid to stock
sele sele(1)
use &datatransferpath\stadj alias adj
sele sele(1)
use &datatransferpath\stadjtr alias adjtrn
index on internal to adjtrn
sele sele(1)
  use &datdev\pro.&datext alias pro  
  index on name to pro 
sele sele(1)
  use &datdev\support.&datext alias support 
  
sele adj
set filter to date>=old_5 and date<=old_9
go top
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    sele mdis
    appe blank
    repl voucher with last4
    repl codep with "STACO3"
    repl type with "D"
    repl challan with adj.vchno
    repl chdate with adj.date
    repl final with adj.net
    repl remark1 with adj.reason
    repl ltype with pcalc
    repl godwon with 'A'
    repl remark4 with adj.vchno
    repl remark1 with str(adj.net,12,2)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
    
sele support
APPE blank
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
    
    sele adjtrn
    seek adj.internal
    scan while internal=adj.internal
         =seek(str(internal,9)+str(prodcode,9),'gst')
         =seek(str(prodcode,10),'pro')
         sele dis
         appen blank
         repl voucher with mdis.voucher
         repl codep with mdis.codep
         repl vcn with mdis.challan
         repl date with mdis.chdate
         repl flg with "D"
         repl tax with "T"
         repl code with pro.code
         repl qty with iif(adjtrn.altype=1,adjtrn.qty,-adjtrn.qty)
         repl batch with adjtrn.batchcode
         repl exp with adjtrn.expdate
         repl rate with iif(mversion='01',adjtrn.rate,adjtrn.salerate1)
         repl mrp with adjtrn.mrp
         repl godwon with 'A'
*!*	            repl ssta with gst.taxperc
*!*	            repl cgst with gst.taxperc
    endscan
endscan

@rowno,10 say 'Importing Credit Note (Sales Return) '   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\crnote alias crn
sele sele(1)
use &datatransferpath\crnotr alias cled
index on internal to cled
sele sele(1)
use &datatransferpath\account alias acct
index on accode to acct
sele sele(1)
use &datdev\order.&datext alias ord
index on parnam to ord
*!*	sele sele(1) 
*!*	  use &datdev\pro.&datext alias pro 
*!*	  index on name to pro 
sele sele(1)
  use &datatransferpath\btra alias btr  
  index on billintern to btr 
sele crn
set filter to date>=old_5 and date<=old_9

go top
scan
*!*	  sele btr
*!*	  seek crn.internal
*!*	   mchallan=iif(found(),1,0)
*!*	*!*	   if crn.internal=7272 or crn.internal=29884
*!*	*!*	      ?found()
*!*	*!*	      ?crn.internal
*!*	*!*	      wait
*!*	*!*	   endif   
*!*	sele crn
    **@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    ptycod=accode
    sele acct
    seek crn.accode
    sele mdis
    appen blank
    repl voucher with last4
*!*	IF mchallan=1
    repl VCN with iif(empty(crn.vchno),'CN-'+alltrim(str(recno())),crn.vchno)
    repl date with crn.date

*!*	ELSE    
*!*	    repl challan with crn.vchno
*!*	    repl chdate with crn.date
*!*	ENDIF    
    repl type with  "R"
    repl ltype with scalc
    repl codep with alltrim(str(crn.accode))
    repl cash with  0  &&CRN.NET &&iif(crn.balamt=0,crn.net,0) &&-crn.balamt    
    repl final with crn.NET
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
if mversion='01'    
    repl mr with 'S'+alltri(str(crn.smancode))
endif    
    repl ltype with scalc ,godwon with 'A',addis with crn.lessperc
    repl remark4 with crn.vchno
    repl remark1 with str(crn.net,12,2)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
sele support
APPE blank
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

    
    sele cled
    seek crn.internal
    scan while internal=crn.internal
         =seek(stockid,"stock")
         =seek(str(internal,9)+str(prodcode,9),'gst')
         =seek(str(prodcode,10),'pro')
         sele dis
         appen blank
         repl voucher with mdis.voucher
         repl vcn with IIF(DAY(MDIS.DATE)=0,mdis.challan,mdis.vcn)
         repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date)
         repl codep with alltrim(str(crn.accode))
         repl code with pro.code
         repl tax with "T"
         repl batch with cled.batchcode
         repl qty with cled.qty
         repl free with cled.schqty

*!*	         repl disc1   with iif(subs(pro.misc5,33,1)='N' and updateitemdisc='Y' ,0,cled.percdedu)
*!*	         repl disc2   with iif(subs(pro.misc5,33,1)='N' and updateitemdisc='Y',0,crn.lessperc)
if mversion='01'
         repl disc1   with iif(subs(pro.misc5,33,1)='N',0,cled.percdedu)
else
         repl disc1   with iif(subs(pro.misc5,33,1)='N',0,cled.lessperc)
endif         
         repl disc2   with iif(subs(pro.misc5,33,1)='N',0,crn.lessperc)
         repl exp     with cled.expdate
         repl rate    with iif(mversion='01',cled.returate,cled.salerate1)
         repl mrp     with cled.mrp
         repl disc2   with iif(subs(pro.misc5,33,1)='N',0,iif(mversion='01',cled.schdisc,0))
         
            repl ssta with iif(mversion='01',cled.taxperc1,cled.itemtax)
            repl cgst with iif(mversion='01',cled.taxperc2,cled.itemtax)
         if cled.reason = 1
            repl flg with 'R'
            repl godwon with 'A'
         else
            repl flg with 'R'   &&&&&
            repl godwon with 'A'
         endif              
    endscan
endscan
sele sele(1)

sele acct
use
sele ord
use
sele btr
use 
@rowno,10 say 'Importing Debit Note (Purchase Return) '   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\godown alias god
index on substr(alltrim(str(godocode)),1,1) to god

sele sele(1)
use &datatransferpath\drnote alias drn
sele sele(1)
use &datatransferpath\drnotr alias dled
index on internal to dled
sele sele(1)
use &datatransferpath\account alias acct
index on accode to acct

sele sele(1)
use &datdev\order.&datext alias ord
index on parnam to ord

SELE SELE(1)
  USE &DATATRANSFERPATH\btra alias btr
  index on billintern to btr 
*!*	sele sele(1)
*!*	  use &datdev\pro.&datext alias pro 
*!*	  index on name to pro
sele drn
set filter to date>=old_5 and date<=old_9
go top
scan
  sele btr
  seek drn.internal
  mchallan=iif(found(),1,0)

   sele drn 
   
 *   @rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    =seek(substr(alltrim(str(drn.internal)),1,1),'god')
    sele mdis
    appen blank
    repl voucher with last4
if mchallan=1
    repl vcn with drn.vchno
    repl date with drn.date

else    
    repl challan with drn.vchno
    repl chdate with drn.date
endif    
    repl type with  "B"
    repl ltype with scalc
    repl codep with alltrim(str(drn.accode))        
    repl final with drn.net
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
    
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
*!*	    repl ltype with '5',;
*!*	         godwon with god.mcode,;
*!*	         addis with -drn.addperc,;
*!*	         bddis with drn.lessperc
    repl ltype with '5',;
         addis with -drn.addperc,;
         bddis with drn.lessperc

    repl remark4 with drn.vchno
    repl remark1 with str(drn.net,12,2)
    
sele support
APPE blank
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
    
    sele dled
    seek drn.internal
    scan while internal=drn.internal
        =seek(stockid,'stock')
        =seek(str(prodcode,9)+str(internal,12),'gst') 
        =seek(str(prodcode,10),'pro')
        sele dis
        appen blank
        repl voucher with mdis.voucher
        repl vcn with iif(day(mdis.date)=0,mdis.challan,mdis.vcn)
        repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date)
        repl codep with alltrim(str(drn.accode))
        repl code with pro.code
        repl tax with "T"
        repl flg with "B"
        repl batch with stock.batchcode
        repl exp with stock.expdate        
        repl qty with dled.qty
        repl free with dled.schqty
        repl disc1 with dled.percdedu
        repl rate with dled.returate
        repl mrp with stock.mrp
        repl flg with 'B'
        repl godwon with mdis.godwon
        if mdis.date >= ctod('01/07/2017')
         IF !FOUND('GST')
            =seek(str(dled.prodcode,9),'gst')
         ENDI
         repl ssta with dled.taxperc1
         repl cgst with dled.taxperc1
      ELSE       
         repl ssta with dled.vatperc
      endif               
*!*         if dled.reason = 1
*!*            repl flg with 'B'
*!*            repl godwon with 'A'
*!*         endif   
*!*         else
*!*            repl flg with 'Q'
*!*            repl godwon with 'Y'
*!*         endif              

    endscan
endscan
sele drn
use
sele dled
use
sele acct
use
sele ord
use


SELE sele(1)
  use &datatransferpath\dnexpiry alias drn 
  
SELE sele(1)
  use &datatransferpath\dnexpirytr alias dled 
index on internal to dled
sele drn
set filter to date>=old_5 and date<=old_9
go top
scan
  sele btr
  seek drn.internal
  mchallan=iif(found(),1,0)

   sele drn 
   
 *   @rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    =seek(substr(alltrim(str(drn.internal)),1,1),'god')
    sele mdis
    appen blank
    repl voucher with last4
*!*	if mchallan=1
*!*	    repl vcn with drn.vchno
*!*	    repl date with drn.date

*!*	else    
*!*	    repl challan with drn.vchno
*!*	    repl chdate with drn.date
*!*	endif    
    repl vcn with drn.vchno
    repl date with drn.date

    repl type with  "Q"
    repl ltype with scalc
    repl codep with alltrim(str(drn.accode))        
    repl final with drn.net
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
    
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
*!*	    repl ltype with '5',;
*!*	         godwon with god.mcode,;
*!*	         addis with -drn.addperc,;
*!*	         bddis with drn.lessperc
    repl ltype with '5',;
         addis with -drn.addperc
*         bddis with drn.lessperc

    repl remark4 with drn.vchno
    repl remark1 with str(drn.net,12,2)
    
sele support
APPE blank
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
    
    sele dled
    seek drn.internal
    scan while internal=drn.internal
*        =seek(stockid,'stock')
        =seek(str(prodcode,9)+str(internal,12),'gst') 
        =seek(str(prodcode,10),'pro')
        sele dis
        appen blank
        repl voucher with mdis.voucher
        repl vcn with iif(day(mdis.date)=0,mdis.challan,mdis.vcn)
        repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date)
        repl codep with alltrim(str(drn.accode))
        repl code with pro.code
        repl tax with "T"
        repl flg with "B"
        repl batch with dled.batchcode
        repl exp with dled.expdate        
        repl qty with dled.qty
        repl free with dled.schqty
*        repl disc1 with dled.percdedu
        repl rate with dled.rate
        repl mrp with stock.mrp
        repl flg with mdis.type &&'B'
        repl godwon with mdis.godwon
     if (mdis.date >= ctod('01/07/2017')) or (mdis.chdate >= ctod('01/07/2017'))
         IF !FOUND('GST')
            =seek(str(dled.prodcode,9),'gst')
         ENDI
         repl ssta with dled.taxperc1
         repl cgst with dled.taxperc1
      ELSE       
         repl ssta with dled.vatperc
      endif               
*!*         if dled.reason = 1
*!*            repl flg with 'B'
*!*            repl godwon with 'A'
*!*         endif   
*!*         else
*!*            repl flg with 'Q'
*!*            repl godwon with 'Y'
*!*         endif              

    endscan
endscan
sele drn
use
sele dled
use



@rowno,10 say 'Importing Debit Note (Purchase Return) '   font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\drcomp alias drn
sele sele(1)
use &datatransferpath\drcomptr alias dled
index on internal to dled
sele sele(1)
use &datatransferpath\account alias acct
index on accode to acct
sele sele(1)
use &datdev\order.&datext alias ord
index on parnam to ord
*!*	sele sele(1)
*!*	 use &datdev\pro.&datext alias pro 
*!*	 index on name to pro 
sele drn
set filter to date >= old_5 and date <= old_9

go top
scan
  sele btr
  seek drn.internal
  mchallan=iif(found(),1,0)
sele drn  
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    ptycod=accode
    sele mdis
    appen blank
    repl voucher with last4
if mchallan=1
    repl vcn with drn.vchno
    repl date with drn.date
else    
    repl challan with drn.vchno
    repl chdate with drn.date
endif    
    repl type with  "B"
    repl ltype with scalc
    repl codep with alltrim(str(drn.accode))        
    repl final with drn.net
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
    
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
    repl ltype with PCALC,;
         godwon with 'A',;
         addis with drn.addperc,;
         bddis with drn.percdisc
         
    repl remark4 with drn.vchno
    repl remark1 with str(drn.net,12,2)
sele support
APPE blank
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
    
    
    sele dled
    seek drn.internal
    scan while internal=drn.internal
        =seek(str(internal,9)+str(prodcode,9),'gst')
        =seek(str(prodcode,10),'pro')   
        sele dis
        appen blank
        repl voucher with mdis.voucher
        repl vcn with iif(mchallan=1,mdis.vcn,mdis.challan)
        repl date with iif(mchallan=1,mdis.date,mdis.chdate)
        repl codep with alltrim(str(drn.accode))
        repl code with pro.code
        repl tax with "T"
        repl flg with "B"
        repl batch with dled.batchcode
        repl exp with dled.expdate        
        repl qty with dled.qty
        repl free with dled.schqty
        repl disc1 with 0
        repl exp with dled.expdate
        repl rate with dled.rate
        repl mrp with dled.mrp
           repl ssta with dled.taxperc1
           repl cgst with dled.taxperc2
        
        if dled.reason = 1
           repl flg with 'B'
           repl godwon with 'A'
        else
           repl flg with 'Q'
           repl godwon with 'Y'
        endif              
    endscan
endscan



@rowno,10 say 'Importing Sales '   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\sale alias sal
set filter to date>=old_5 and date<=old_9

sele sele(1)
use &datatransferpath\scheme alias fscheme
index on prodcode to fscheme

sele sele(1)
use &datatransferpath\satr alias sld
index on internal to sld

*!*	sele sele(1)
*!*	  use &datdev\pro.&datext alias pro  
*!*	  index on name to pro  
last4=last4+5
sele sal
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    ptycod=accode
    sele acct
    seek sal.accode
    sele mdis
    appen blank
    repl voucher with last4
    if sal.vchno='ES'
    repl challan with ALLT(SUBSTR(sal.vchno,Removecharfrombillno+1,12))
    repl chdate with sal.date
    repl type with "L"
    else
    repl vcn with ALLT(SUBSTR(sal.vchno,Removecharfrombillno+1,12))
    repl date with sal.date
    repl type with "S"
    endi
    repl codep with alltrim(str(sal.accode))
    repl final with sal.net-sal.cashamt+sal.cradjamt 
    repl cash with sal.cashamt
    if sal.accode=1
       repl codep with "STACO3"
       repl docu with subs(docu,1,10)+subs(sal.acname,1,30)
       repl docu1 with subs(docu1,1,10)+subs(sal.address,1,30)
    endif
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
*    repl addis with sal.percdisc

if mversion='01'   
    repl other with -sal.octroi,;    
         othun with 'OCTROI',;
         packing with sal.dradjamt+sal.others,;
         pacun with 'CRN'
endif         
    repl ltype with scalc
    repl mr with 'S'+alltri(str(sal.smancode))
    repl remark4 with sal.vchno
    repl remark1 with str(sal.net,12,2)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
	repl mr with 'S'+alltri(str(sal.smancode))

sele support
APPE blank
repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
    
    
    sele sld
    seek sal.internal
    scan while internal=sal.internal
        =seek(stockid,"stock")
        =seek(str(internal,9)+str(prodcode,9),'gst')
        =seek(str(prodcode,10),'pro')
        sele dis
        appen blank
        repl voucher with mdis.voucher
        repl vcn with iif(empty(mdis.vcn),mdis.challan,mdis.vcn)
        repl date with iif(empty(mdis.date),mdis.chdate,mdis.date)
        repl codep with mdis.codep
        repl tax with "T"
        repl code with pro.code
        repl batch with stock.batchcode
        repl exp with stock.expdate
        repl mrp with stock.mrp
        repl qty with sld.qty
        repl free with sld.schqty
        repl rate with iif(sld.amount#0,sld.amount/sld.qty,sld.salerate)
        repl flg with iif(mdis.type='S','G',mdis.type)
        
        repl disc1 with sld.itemdisc
IF SLD.AMOUNT#SLD.TAXABLE        
        repl disc2 with iif(mversion='01',sal.percdisc,sal.lessperc)
ENDIF        
	    repl svdis with sld.schdisc

*!*		 sele fscheme
*!*		 seek sld.prodcode
*!*		 	if foun()
*!*		 		mysch=(fscheme.qty1*sld.salerate)/(fscheme.qty1+fscheme.free1)   
*!*		 		mschamt=sld.salerate-mysch
*!*		 	sele dis
*!*			    repl svdis1 with iif(sld.schqty#0,0,mschamt)
*!*			endif	 
		sele dis  
	    repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,45)
        repl sssc with iif(mversion='01',sld.percoct,0)
        repl ssta with iif(mversion='01',sld.taxperc1,sld.itemtax)
        repl cgst with iif(mversion='01',sld.taxperc2,sld.itemtax)

if mversion='01'           
      IF sld.taxamt3#0 and sld.qty#0   
      repl cessinrs with val(str(sld.taxamt3/sld.qty,9,2))
    endif   
endif
    endscan
endscan
select sal
use
select sld
use


@rowno,10 say 'Importing Sales Through Challan'   font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\sadc alias sal
sele sele(1)
use &datatransferpath\sadctr alias sld
index on internal to sld
*!*	sele sele(1)
*!*	 use &datdev\pro.&datext alias pro 
*!*	 index on name to pro  
 
last4=last4+5
sele sal
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    ptycod=accode
    sele acct
    seek sal.accode
    
    sele mdis
    appen blank
    repl voucher with last4
    repl vcn with sal.vchno
    repl date with sal.date
    repl type with "S"
    repl codep with alltrim(str(sal.accode))        
    repl final with sal.net-sal.cashamt
    repl cash with sal.cashamt
    &&  repl addis with sal.percdisc
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
    repl mr with 'S'+alltri(str(sal.smancode))    
    repl ltype with scalc,;
         godwon with 'A'
    repl other with -sal.octroi,;    
         othun with 'OCTROI',;
         packing with +sal.dradjamt,;
         pacun with 'CRN'
         
    repl remark4 with sal.vchno
    repl remark1 with str(sal.net,12,2)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
    
    
    sele sld
    seek sal.internal
    scan while internal=sal.internal
        =seek(stockid,"stock")
        =seek(str(internal,9)+str(prodcode,9),'gst')
        =seeK(str(prodcode,10),'pro')
        sele dis
        appen blank
        repl voucher with mdis.voucher
        repl vcn with mdis.vcn
        repl date with mdis.date
        repl codep with mdis.codep
        repl tax with "T"
        repl code with pro.code
        repl batch with stock.batchcode
        repl exp with stock.expdate
        repl mrp with stock.mrp
        repl qty with sld.qty
        repl free with sld.schqty
        repl rate with sld.salerate
        repl flg with "G"
        repl disc1 with iif(subs(pro.misc5,33,1)='N',0,sld.itemdisc)
        repl disc2 with iif(subs(pro.misc5,33,1)='N',0,iif(sld.schdisc#0,0,sal.percdisc))
        repl svdis with iif(subs(pro.misc5,33,1)='N',0,sld.schdisc)
        repl sssc with sld.percoct
        repl godwon with 'A'
           repl ssta with sld.taxperc1
           repl cgst with sld.taxperc2
    endscan
endscan
select sal
use
select sld
use



@rowno,10 say 'Importing Sales Challan'   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\dcsa alias sal
set filt to empty(sainternal)
sele sele(1)
use &datatransferpath\dcsatr alias sld
index on internal to sld
*!*	sele sele(1)
*!*	 use &datdev\pro.&datext alias pro 
*!*	 index on name to pro 
last4=last4+5
sele sal
scan
    last4=last4+5
    ptycod=accode
    sele acct
    seek sal.accode
    sele mdis
    appen blank
    repl voucher with last4
    repl challan with sal.vchno
    repl chdate with sal.date
    repl type with "S"
    repl codep with alltrim(str(sal.accode))        
    repl final with sal.net
*!*if sal.accode=0
*!*  repl codep with "STACO3"
*!*  repl docu with subs(docu,1,10)+subs(sal.acname,1,30)
*!*  repl docu1 with subs(docu1,1,10)+subs(sal.address,1,30)
*!*endif
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
    repl mr with 'S'+alltri(str(sal.smancode))
    repl ltype with scalc,;
         godwon with 'A'
    repl other with 0,;    
         othun with 'OCTROI',;
         packing with 0,;
         pacun with 'CRN'
    repl remark4 with sal.vchno
    repl remark1 with str(sal.net,12,2)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
    sele sld
    seek sal.internal
    scan while internal=sal.internal
        =seek(stockid,"stock")
        =seek(str(internal,9)+str(prodcode,9),'gst')
        =seeK(str(prodcode,10),'pro')
        sele dis
        appen blank
        repl voucher with mdis.voucher
        repl vcn with mdis.challan
        repl date with mdis.chdate
        repl codep with mdis.codep
        repl tax with "T"
        repl code with pro.code
        repl batch with stock.batchcode
        repl exp with stock.expdate
        repl mrp with stock.mrp
        repl qty with sld.qty
        repl free with sld.schqty
        repl rate with sld.salerate
        repl flg with "G"
        repl disc1 with iif(subs(pro.misc5,33,1)='N',sld.itemdisc,0)
        repl disc2 with iif(subs(pro.misc5,33,1)='N',iif(sld.schdisc#0,0,sal.salcd),0)
        repl svdis with iif(subs(pro.misc5,33,1)='N',sld.schdisc,0)
        repl sssc with 0
        repl godwon with 'A'
        repl ssta with iif(inlist(sld.itemtax,5,12,18,28),sld.itemtax/2,sld.itemtax)
        repl cgst with iif(inlist(sld.itemtax,5,12,18,28),sld.itemtax/2,sld.itemtax)
    endscan
endscan
close data




@rowno,10 say 'Importing Account From Sales'   font 'Arial',12
rowno=rowno+1
af     =datdev + '\gledger.'+datext
pend   =datdev + '\pend.'+datext
mdis   =datdev + '\mdis.'+datext
pending=datdev + '\pendings.'+datext
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

sele sele(1)
  use &datatransferpath\btra alias btr  
  index on internal to btr  
  
sele sele(1)
  use &datatransferpath\sale alias sal 
  index on vchno to sal 
sele sele(1)
  use &datatransferpath\crnote alias crn  
  index on internal to crn  
sele sele(1)
  use &datatransferpath\drnote alias drn  
  index on internal to drn  
sele sele(1)
  use &datatransferpath\purc alias pur 
  index on vchno to pur
sele sele(1)
  use &datatransferpath\opbill alias opb 
  index on internal to opb
SELECT SELECT(1)
sele sele(1)
  use &datatransferpath\DRCOMP alias DRN1 
  index on internal to DRN1

sele mdis
sele mdis 
INDEX ON DATE TO MDIS 
go top
do while !eof()
  if (Mdis.TYPE$'SP')
      skip 
      loop 
  endif    

   if vcn=space(12)
      skip
      loop
   endif
   last1=mdis.codep
   if mdis.final#0
      sele b
      appe blank
      repl voucher with mdis.voucher
      if d.type $ 'RPW'
         repl cd with 'C'
         repl credit with mdis.final
         if d.type $ 'PW'
            repl book with 'A'
         else
            if d.type = 'R'
               repl book with 'E'
            endif
         endif
   else
      if d.type $ 'SBQ'
         repl cd with 'D',;
         debit with mdis.final
         if d.type $ 'SQ'
            repl book with 'S'
         else
            if d.type = 'B'
               repl book with 'D'
            endif
         endif      
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
   **** For Outstanding
   if old_3='Y'
     store 0 to mcrnamt,mdrnamt 
*!*	   if mdis.type='S'
*!*	      sele sal
*!*	      seek subs(mdis.vcn+space(20),1,20)
*!*	      mCrnamt=CRADJAMT
*!*	   else
*!*	     if mdis.type='P'
*!*	     sele pur 
*!*	     seek subs(mdis.vcn+space(20),1,20)
*!*	     mdrnamt=dradjamt 
*!*	     endif
*!*	   endif     
      
      sele f
      appe blank
      repl ord with mdis.codep
      repl ddate with mdis.date
      repl duedays with mdis.duedays
      repl vcn with mdis.vcn
      if d.type='PRW'
         repl final with -(mdis.final-mcrnamt)
      else
         repl final with (mdis.final-mcrnamt)
      endif
      repl type with 'N'
      repl voucher with mdis.voucher
      repl adjvoucher with mdis.voucher
      repl svoucher with slast5
      slast5=slast5+5
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

      if mcrnamt#0 and mdis.type='S'
      sele btr
      seek sal.internal
      DO WHILE internal=sal.internal and !eof()
      sele crn 
      seek BTR.BILLINTERN
      
         sele f
         appe blank
         repl ord with mdis.codep
         repl ddate with mdis.date
         repl duedays with mdis.duedays
         repl vcn with crn.vchno
         repl final with btr.amount
         repl type with 'A'
         repl voucher with mdis.voucher
         sele pending
         seek f.ord+crn.vchno 
         if found()
      		repl f.adjvoucher with pending.voucher
            repl f.svoucher with pending.svoucher
         endif   
       sele btr
       skip 
       enddo  
      endif
      if mdrnamt#0 and mdis.type='P'
      sele btr
      seek pur.internal
      DO WHILE internal=pur.internal and !eof()
      sele drn 
      seek BTR.BILLINTERN
      
         sele f
         appe blank
         repl ord with mdis.codep
         repl ddate with mdis.date
         repl duedays with mdis.duedays
         repl vcn with drn.vchno
         repl final with btr.amount
         repl type with 'A'
         repl voucher with mdis.voucher
         sele pending
         seek f.ord+drn.vchno 
         if found()
      		repl f.adjvoucher with pending.voucher
            repl f.svoucher with pending.svoucher
         endif   
       sele btr
       skip 
       enddo  
      endif
   endif
 endif
 if mdis.cash#0
    sele b
    appe blank
    repl voucher with mdis.voucher
    if (d.type $ 'PRW')
       repl cd with 'C'
       repl credit with mdis.cash
       if d.type $ 'PW'
          repl book with 'A'
       else
          if d.type = 'R'
             repl book with 'E'
          endif
       endif
    else
       if d.type $ 'SBQ'
          repl cd with 'D'
          repl debit with mdis.cash
          if d.type $ 'SQ'
             repl book with 'S'
          else
             if d.type = 'B'
                repl book with 'D'
             endif
          endif      
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
 if (mdis.final+mdis.cash)#0
    sele b
    appe blank
    repl voucher with mdis.voucher
    if d.type $ 'PRW'
       repl cd with 'D'
       repl debit with (mdis.final+mdis.cash)
       if d.type $ 'WP'
          repl book with 'A'
       else
          if d.type = 'R'
             repl book with 'E'
          endif
       endif
    else
       if (d.type $ 'SBQ')
          repl cd with 'C'
          repl credit with (mdis.final+mdis.cash)
          if d.type $ 'SQ'
             repl book with 'S'
          else
             if d.type = 'B'
                repl book with 'D'
             endif
          endif
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
sele d
skip
enddo


sele mdis 
INDEX ON DATE TO MDIS 
go top
do while !eof()
  if !(Mdis.TYPE$'SP')
      skip 
      loop 
  endif    
   if vcn=space(12)
      skip
      loop
   endif
   last1=mdis.codep
   if mdis.final#0
      sele b
      appe blank
      repl voucher with mdis.voucher
      if d.type $ 'RPW'
         repl cd with 'C'
         repl credit with mdis.final
         if d.type $ 'PW'
            repl book with 'A'
         else
            if d.type = 'R'
               repl book with 'E'
            endif
         endif
   else
      if d.type $ 'SBQ'
         repl cd with 'D',;
         debit with mdis.final
         if d.type $ 'SQ'
            repl book with 'S'
         else
            if d.type = 'B'
               repl book with 'D'
            endif
         endif      
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
   **** For Outstanding
   if old_3='Y'
     store 0 to mcrnamt,mdrnamt 
   if mdis.type='S'
      sele sal
      seek subs(mdis.vcn+space(20),1,20)
      mCrnamt=CRADJAMT
   else
     if mdis.type='P'
     sele pur 
     seek subs(mdis.vcn+space(20),1,20)
     mdrnamt=dradjamt 
     endif
   endif     
      
      sele f
      appe blank
      repl ord with mdis.codep
      repl ddate with mdis.date
      repl duedays with mdis.duedays
      repl vcn with mdis.vcn
      if d.type='PRW'
         repl final with -(mdis.final-mcrnamt)
      else
         repl final with (mdis.final-mcrnamt)
      endif
      repl type with 'N'
      repl voucher with mdis.voucher
      repl adjvoucher with mdis.voucher
      repl svoucher with slast5
      slast5=slast5+5
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

      if mcrnamt#0 and mdis.type='S'
      sele btr
      seek sal.internal
      DO WHILE internal=sal.internal and !eof()
               if btr.billtype=0
                  =seek(btr.billintern,'opb')
               else
                  =seek(btr.billintern,'crn')   
               endif   
      MVCN=IIF(BTR.BILLTYPE=0,opb.billno,crn.vchno)
       SELE BTR
         sele f
         appe blank
         repl ord with mdis.codep
         repl ddate with mdis.date
         repl duedays with mdis.duedays
         repl vcn with MVCN
         repl final with btr.amount
         repl type with 'A'
         repl voucher with mdis.voucher
         sele pending
         seek f.ord+MVCN 
         if found()
      		repl f.adjvoucher with pending.voucher
            repl f.svoucher with pending.svoucher
         endif   
       sele btr
       skip 
       enddo  
      endif
      if mdrnamt#0 and mdis.type='P'
      sele btr
      seek pur.internal
      DO WHILE internal=pur.internal and !eof()
         MVCN=''
         MFOUND=0
         IF btr.billtype=0
           SELECT OPB
           SEEK btr.billintern
           IF FOUND()
              MVCN=billno 
           ENDIF
         ELSE
             SELECT DRN 
             SEEK btr.billintern
             IF FOUND()
                MVCN=VCHNO 
             ELSE    
	             SELECT DRN1 
	             SEEK btr.billintern
	             IF FOUND()
	                MVCN=VCHNO 
	             ENDIF
	         ENDIF    
         ENDIF        
*      MVCN=IIF(BTR.BILLTYPE=0,opb.billno,drn.vchno)
         sele f
         appe blank
         repl ord with mdis.codep
         repl ddate with mdis.date
         repl duedays with mdis.duedays
         repl vcn with mvcn
         repl final with -btr.amount
         repl type with 'A'
         repl voucher with mdis.voucher
         sele pending
         seek f.ord+mvcn 
         if found()
      		repl f.adjvoucher with pending.voucher
            repl f.svoucher with pending.svoucher
         endif   
       sele btr
       skip 
       enddo  
      endif
   endif
 endif
 if mdis.cash#0
    sele b
    appe blank
    repl voucher with mdis.voucher
    if (d.type $ 'PRW')
       repl cd with 'C'
       repl credit with mdis.cash
       if d.type $ 'PW'
          repl book with 'A'
       else
          if d.type = 'R'
             repl book with 'E'
          endif
       endif
    else
       if d.type $ 'SBQ'
          repl cd with 'D'
          repl debit with mdis.cash
          if d.type $ 'SQ'
             repl book with 'S'
          else
             if d.type = 'B'
                repl book with 'D'
             endif
          endif      
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
 if (mdis.final+mdis.cash)#0
    sele b
    appe blank
    repl voucher with mdis.voucher
    if d.type $ 'PRW'
       repl cd with 'D'
       repl debit with (mdis.final+mdis.cash)
       if d.type $ 'WP'
          repl book with 'A'
       else
          if d.type = 'R'
             repl book with 'E'
          endif
       endif
    else
       if (d.type $ 'SBQ')
          repl cd with 'C'
          repl credit with (mdis.final+mdis.cash)
          if d.type $ 'SQ'
             repl book with 'S'
          else
             if d.type = 'B'
                repl book with 'D'
             endif
          endif
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
sele d
skip
enddo


@rowno,10 say 'Importing Contra Entries'   font 'Arial',12
rowno=rowno+1
last4  = last4 + 10
slast5 = slast5 + 10

sele sele(1)
use &datatransferpath\account alias acct
index on accode to acct 
sele sele(1)
use &datatransferpath\contra alias contra
set filter to date>=old_5 and date<=old_9

sele sele(1)
use &datdev\order.&datext alias ord


sele contra
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    sele acct
    seek contra.draccode
    
    sele gledger
    appen blank
    repl voucher with last4
    repl code with alltrim(str(contra.draccode))
    repl remark1 with subs(contra.vchno,1,15)+contra.narration
    repl cd with "D"
    repl debit with contra.amount
    repl date with contra.date
    repl book with "C"

    appen blank
    repl voucher with last4
    repl code with alltrim(str(contra.craccode))
    repl remark1 with subs(contra.vchno,1,15)+contra.narration
    repl cd with "C"
    repl credit with contra.amount
    repl date with contra.date
    repl book with "C"
endscan

@rowno,10 say 'Importing Journal Entries'   font 'Arial',12
rowno=rowno+1
last4  = last4 + 10
slast5 = slast5 + 10

SELE SELE(1)
  sele drn1
  use
sele sele(1)
use &datatransferpath\jrnl alias jrnl
set filter to date>=old_5 and date<=old_9
sele sele(1)
use &datatransferpath\jrnltr alias jled
index on internal to jled

sele sele(1)
  use &datatransferpath\DRCOMP alias DRN1 
  index on internal to DRN1

sele jrnl
go top
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    sele jled
    seek jrnl.internal
    scan while internal = jrnl.internal
    IF jled.cradjamt#0
        LOOP
    endif
         sele gledger
         appen blank
         repl voucher with last4
         repl code with alltrim(str(jled.accode))
         repl date with jrnl.date
         repl remark1 with subs(jrnl.vchno,1,15)+jrnl.narration
         repl book with 'J'
         if jled.amount>0
            repl cd with 'C'
            repl credit with abs(jled.amount)
         else
            repl cd with 'D'
            repl debit with abs(jled.amount)
        endif
    endscan

   **** For Outstanding
   if old_3='Y'
  if mversion='01'         
            sele btr
            seek JRNL.internal
            do while internal = jrnl.internal .and. !eof()
            maccode=0
         MVCN=''
         MFOUND=0
         IF btr.billtype=0
           SELECT OPB
           SEEK btr.billintern
           IF FOUND()
              MVCN=billno 
              maCCODE=ACCODE
           ENDIF
         ELSE
             SELECT DRN 
             SEEK btr.billintern
             IF FOUND()
                MVCN=VCHNO 
                MACCODE=ACCODE
             ELSE    
	             SELECT DRN1 
	             SEEK btr.billintern
	             IF FOUND()
	                MVCN=VCHNO
	                MACCODE=ACCODE 
	             ENDIF
	         ENDIF    
         ENDIF     
               sele f
               appe blank
               repl ord with alltrim(str(MACCODE))
               repl ddate with jrnl.date
               repl vcn with MVCN
               repl final with btr.amount
*!*	              IF BTR.INTERNAL=43154
               sele g
               seek f.ord+f.vcn &&+ iif(btr.billtype=0,dtos(opb.date),dtos(pur.date))
*!*	                 ?FOUND()
*!*	                 ?JRNL.INTERNAL,BTR.BILLINTERN
*!*	                 ?MVCN
*!*	                 ?f.vcn
*!*	                 ?jled.accode,MACCODE
*!*	                 WAIT 'SANTOSH'
*!*	             ENDIF    
               if found()
                  sele f
                  repl type with 'A'
                  repl voucher with gledger.voucher
                  repl adjvoucher with g.voucher
                  repl svoucher with g.svoucher
               endif
            sele btr
            skip
            enddo
endif    
   
   ENDIF
endscan

sele sele(1)
  sele sal
  use
  sele btr
  use
  sele pur
  use
  sele opb
  use  
@rowno,10 say 'Importing Multi Receipt'   font 'Arial',12
rowno=rowno+1
last4  = last4 + 10
slast5 = slast5 + 10
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext
sele sele(1)
use &datatransferpath\btra alias btr
index on internal to btr

sele g
index on ord + substr(name,1,12) + dtos(ddate) to rou2
sele f

sele sele(1)
use &datatransferpath\purc alias pur
index on internal to pur
sele sele(1)
use &datatransferpath\sale alias sal
index on internal to sal
sele sele(1)
use &datatransferpath\opbill alias opb
index on internal to opb


if mversion='01'

sele sele(1)
use &datatransferpath\multrcpt alias mrcpt
set filter to date>=old_5 and date<=old_9
sele sele(1)
use &datatransferpath\multrcpttr alias mrcptl
index on internal to mrcptl

sele mrcpt
go top
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    sele mrcptl
    seek mrcpt.internal
    scan while internal = mrcpt.internal
         sele gledger
         appen blank
         repl voucher with last4
         repl code with alltrim(str(mrcptl.accode))
         repl date with mrcpt.date
         repl remark1 with subs(mrcpt.vchno,1,15)+mrcpt.narration
         repl book with 'R'
         if mrcptl.amount > 0
            repl cd with 'C'
            repl credit with abs(mrcptl.amount)
         else
            repl cd with 'D'
            repl debit with abs(mrcptl.amount)
         endif
        
         ** Outstanding Adjustment
         if mrcptl.amount>0 .and. old_3 = 'Y'
            sele btr
            seek mrcptl.internal
            do while mrcptl.internal = btr.internal .and. !eof()
               if btr.billtype=0
                  =seek(btr.billintern,'opb')
               else
                  =seek(btr.billintern,'sal')   
               endif   
               sele f
               appe blank
               repl ord with alltrim(str(mrcptl.accode))
               repl ddate with mrcpt.date
               repl vcn with iif(btr.billtype=0,opb.billno,sal.vchno)
               if mrcptl.amount>0
                  repl final with -btr.amount
                                 endif
               
               sele g
               seek f.ord+substr(f.vcn,1,12) + iif(btr.billtype=0,dtos(opb.date),dtos(sal.date))
               if found()
                  sele f
                  repl type with 'A'
                  repl voucher with b.voucher
                  repl adjvoucher with g.voucher
                  repl svoucher with g.svoucher
               endif
            sele btr
            skip
            enddo
         endif
         
    endscan
endscan



@rowno,10 say 'Importing Multi Payment'   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\multpymt alias mpymt
set filter to date>=old_5 and date<=old_9
sele sele(1)
use &datatransferpath\multpymttr alias mpymtl
index on internal to mpymtl

sele mpymt
go top
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    sele mpymtl
    seek mpymt.internal
    scan while internal = mpymt.internal
         sele gledger
         appen blank
         repl voucher with last4
         repl code with alltrim(str(mpymtl.accode))
         repl date with mpymt.date
         repl remark1 with subs(mpymt.vchno,1,15)+mpymt.narration
         repl book with 'P'
         if mpymtl.amount > 0
            repl cd with 'C'
            repl credit with abs(mpymtl.amount)
         else
            repl cd with 'D'
            repl debit with abs(mpymtl.amount)
        endif
        
         ** Outstanding Adjustment
         if mrcptl.amount<0 .and. old_3 = 'Y'
            sele btr
            seek mrcptl.internal
            do while mrcptl.internal = btr.internal .and. !eof()
               if btr.billtype=0
                  =seek(btr.billintern,'opb')
               else
                  =seek(btr.billintern,'pur')   
               endif   
               sele f
               appe blank
               repl ord with alltrim(str(mrcptl.accode))
               repl ddate with mrcpt.date
               repl vcn with iif(btr.billtype=0,opb.billno,pur.vchno)
               if mrcptl.amount<0
                  repl final with btr.amount
               endif
               
               sele g
               seek f.ord+substr(f.vcn,1,12) + iif(btr.billtype=0,dtos(opb.date),dtos(pur.date))
               if found()
                  sele f
                  repl type with 'A'
                  repl voucher with b.voucher
                  repl adjvoucher with g.voucher
                  repl svoucher with g.svoucher
               endif
            sele btr
            skip
            enddo
         endif
        
    endscan
endscan

endif



@rowno,10 say 'Importing Receipts'   font 'Arial',12
rowno=rowno+1
sele btr 
index on internal to btr
sele sele(1)
use &datatransferpath\receipt alias rcpt
set filter to date>=old_5 and date<=old_9 and vchno#'ESRC'
sele rcpt
go top
scan  
   * @rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    ptycod=draccode
    sele gledger    
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl remark1 with subs(rcpt.vchno,1,15)+rcpt.narration
    repl book with "R"
    repl cd with "C"
    repl credit with (rcpt.amount)
    repl code with alltrim(str(rcpt.craccode))
         ** Outstanding Adjustment
         if rcpt.amount>0 .and. old_3 = 'Y'
            sele btr     &&&&SANTOSH -> WRONG FILE WAS SELECTED . 
            seek rcpt.internal
            do while btr.internal=rcpt.internal .and. !eof()
               if btr.billtype=0
                  =seek(BILLINTERN,'opb')    &&& INSTEAD OF INTERNAL->BILLINTERN FIELD USED 
               else
                  =seek(billintern,'sal')   
               endif   
*!*	               if INLIST(btr.INTERNAL,6527,9201,11040,11041)
*!*	                  wait wind 'here-1'
*!*	               endif   
               sele f
               appe blank
               repl ord with alltrim(str(rcpt.craccode))
               repl ddate with rcpt.date
               repl vcn with iif(btr.billtype=0,opb.billno,sal.vchno)
               if rcpt.amount>0
                  repl final with -btr.amount
               endif
               
               sele g
               seek f.ord+substr(f.vcn,1,12) + iif(btr.billtype=0,dtos(opb.date),dtos(sal.date))
               if found()
                  sele f
                  repl type with 'A'
                  repl voucher with b.voucher
                  repl adjvoucher with g.voucher
                  repl svoucher with g.svoucher
               endif
            sele btr
            skip
            enddo
         endif

    sele gledger
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl remark1 with subs(rcpt.vchno,1,15)+rcpt.narration
    repl book with "R"
    repl cd with "D"
    repl debit with rcpt.amount
    repl code with alltrim(str(rcpt.draccode))

if mversion='01' 
*!*	if  rcpt.discamt#0
*!*	    sele gledger    
*!*	    appen blank
*!*	    repl voucher with last4
*!*	    repl date with rcpt.date
*!*	    repl remark1 with subs(rcpt.vchno,1,15)+rcpt.narration
*!*	    repl book with "R"
*!*	    repl cd with "C"
*!*	    repl CREDIT with rcpt.discamt
*!*	    repl code with alltrim(str(rcpt.Craccode))
*!*	  
*!*	         ** Outstanding Adjustment
*!*	         if rcpt.DISCAMT>0 .and. old_3 = 'Y'
*!*	            sele btr
*!*	            seek rcpt.internal
*!*	            do while internal=rcpt.internal .and. !eof()
*!*	               if btr.billtype=0
*!*	                  =seek(billintern,'opb')
*!*	               else
*!*	                  =seek(billintern,'sal')   
*!*	               endif   
*!*	               sele f
*!*	               appe blank
*!*	               repl ord with alltrim(str(rcpt.craccode))
*!*	               repl ddate with rcpt.date
*!*	               repl vcn with iif(btr.billtype=0,opb.billno,sal.vchno)
*!*	               if rcpt.amount>0
*!*	                  repl final with -btr.amount
*!*	               endif
*!*	               sele g
*!*	               seek f.ord+substr(f.vcn,1,12) + iif(btr.billtype=0,dtos(opb.date),dtos(sal.date))
*!*	               if found()
*!*	                  sele f
*!*	                  repl type with 'A'
*!*	                  repl voucher with b.voucher
*!*	                  repl adjvoucher with g.voucher
*!*	                  repl svoucher with g.svoucher
*!*	               endif
*!*	            sele btr
*!*	            skip
*!*	            enddo
*!*	         endif
*!*	endif
*!*	sele gledger  
*!*	    appen blank
*!*	    repl voucher with last4
*!*	    repl date with rcpt.date
*!*	    repl remark1 with subs(rcpt.vchno,1,15)+rcpt.narration
*!*	    repl book with "R"
*!*	    repl cd with "D"
*!*	    repl debit with rcpt.discamt
*!*	    repl code with 'DS9999'

ENDIF
endscan
****** &Discount in receipt 
sele rcpt
go top
scan for discamt#0  
    last4=last4+5
    ptycod=draccode
    sele gledger    
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl remark1 with subs(rcpt.vchno,1,15)+rcpt.narration
    repl book with "R"
    repl cd with "C"
    repl credit with rcpt.discamt
    repl code with alltrim(str(rcpt.craccode))
    repl code1 with  'DS9999'
  
         ** Outstanding Adjustment
         if rcpt.DISCAMT>0 .and. old_3 = 'Y'
            sele btr
            seek rcpt.internal
            do while internal=rcpt.internal .and. !eof()
               if btr.billtype=0
                  =seek(billintern,'opb')
               else
                  =seek(billintern,'sal')   
               endif   
               sele f
               appe blank
               repl ord with alltrim(str(rcpt.craccode))
               repl ddate with rcpt.date
               repl vcn with iif(btr.billtype=0,opb.billno,sal.vchno)
               if rcpt.amount>0
                  repl final with -btr.DISCOUNT
               endif
               sele g
               seek f.ord+substr(f.vcn,1,12) + iif(btr.billtype=0,dtos(opb.date),dtos(sal.date))
               if found()
                  sele f
                  repl type with 'A'
                  repl voucher with b.voucher
                  repl adjvoucher with g.voucher
                  repl svoucher with g.svoucher
               endif
            sele btr
            skip
            enddo
         endif
sele gledger  
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl remark1 with subs(rcpt.vchno,1,15)+rcpt.narration
    repl book with "R"
    repl cd with "D"
    repl debit with rcpt.discamt
    repl code with 'DS9999'
    repl code1 with alltrim(str(rcpt.craccode))
endscan

******
@rowno,10 say 'Importing Bank Slip'   font 'Arial',12
rowno=rowno+1
sele btr 
index on internal to btr

sele sele(1)
use &datatransferpath\bsrcpt  alias brcpt
set filter to date>=old_5 and date<=old_9

SELE sele(1)
  use &datatransferpath\bankslip alias bnk 
  index on internal to bnk
sele pending
index on ord+vcn to pending
sele brcpt
go top
scan  
 =seek(slipintern,'bnk')
   * @rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
*    ptycod=accode
    sele gledger
    appen blank
    repl voucher with last4
    repl date with brcpt.date
    repl remark1 with subs(brcpt.vchno,1,15)+brcpt.narration
    repl VCSno with subs(brcpt.vchno,1,15)
    repl book with "R"
    repl cd with "D"
    repl debit with brcpt.amount-BRCPT.DISCAMT
    repl code with alltrim(str(bnk.accode))
    repl code1 with alltrim(str(brcpt.accode))
    sele gledger    
    appen blank
    repl voucher with last4
    repl date with brcpt.date
    repl remark1 with subs(brcpt.vchno,1,15)+brcpt.narration
    repl VCSno with subs(brcpt.vchno,1,15)
    repl book with "R"
    repl cd with "C"
    repl credit with brcpt.amount
    repl code with alltrim(str(brcpt.accode))
    repl addfield1 with brcpt.chqno 
    repl code1 with alltrim(Str(bnk.accode))
         ** Outstanding Adjustment
         if brcpt.amount>0 .and. old_3 = 'Y'
            sele btr     &&&&SANTOSH -> WRONG FILE WAS SELECTED . 
            seek brcpt.internal
            do while btr.internal=brcpt.internal .and. !eof()
               if btr.billtype=0
                  =seek(BILLINTERN,'opb')    &&& INSTEAD OF INTERNAL->BILLINTERN FIELD USED 
               else
                  =seek(billintern,'sal')   
               endif   
               sele f
               appe blank
               repl ord with alltrim(str(brcpt.accode))
               repl ddate with brcpt.date
               repl vcn with iif(btr.billtype=0,opb.billno,sal.vchno)
               repl final with -btr.amount
               sele g
               seek f.ord+substr(f.vcn,1,20)   &&&&+ iif(btr.billtype=0,dtos(opb.date),dtos(sal.date))
               if found()
                  sele f
                  repl type with 'A'
                  repl voucher with b.voucher
                  repl adjvoucher with g.voucher
                  repl svoucher with g.svoucher
               endif
            sele btr
            skip
            enddo
         endif


if mversion='01' 
if  brcpt.discamt#0
    sele gledger    
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl remark1 with subs(brcpt.vchno,1,15)+brcpt.narration
    repl VCSno with subs(brcpt.vchno,1,15)

    repl book with "R"
    repl cd with "C"
    repl CREDIT with brcpt.discamt
    repl code with alltrim(str(brcpt.accode))
  
         ** Outstanding Adjustment
         if brcpt.DISCAMT>0 .and. old_3 = 'Y'
            sele btr
            seek brcpt.internal
            do while internal=brcpt.internal .and. !eof()
               if btr.billtype=0
                  =seek(billintern,'opb')
               else
                  =seek(billintern,'sal')   
               endif   
               sele f
               appe blank
               repl ord with alltrim(str(brcpt.accode))
               repl ddate with brcpt.date
               repl vcn with iif(btr.billtype=0,opb.billno,sal.vchno)
               if brcpt.amount>0
                  repl final with -btr.amount
               endif
               sele g
               seek f.ord+substr(f.vcn,1,12) + iif(btr.billtype=0,dtos(opb.date),dtos(sal.date))
               if found()
                  sele f
                  repl type with 'A'
                  repl voucher with b.voucher
                  repl adjvoucher with g.voucher
                  repl svoucher with g.svoucher
               endif
            sele btr
            skip
            enddo
         endif
endif
sele gledger  
    appen blank
    repl voucher with last4
    repl date with brcpt.date
    repl remark1 with subs(brcpt.vchno,1,15)+rcpt.narration
    repl VCSno with subs(brcpt.vchno,1,15)

    repl book with "R"
    repl cd with "D"
    repl debit with brcpt.discamt
    repl code with 'DS9999'

   ENDIF
endscan


@rowno,10 say 'Importing Payments'   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\payment   alias pymt
set filter to date>=old_5 and date<=old_9
sele pymt
go top
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    sele gledger
    appe blan
    repl voucher with last4
    repl date with pymt.date
    repl remark1 with subs(pymt.vchno,1,15)+pymt.narration
    repl book with 'P'
    repl cd with 'D'
    repl debit with pymt.amount
    repl code with alltrim(str(pymt.draccode))
         ** Outstanding Adjustment
  if mversion='01'         
         if PYMT.amount#0 .and. old_3 = 'Y'
            sele btr
            seek pymt.internal
            do while internal = pymt.internal .and. !eof()
               if btr.billtype=0
                  =seek(btr.billintern,'opb')
               else
                  =seek(btr.billintern,'pur')   
               endif   
               sele f
               appe blank
               repl ord with alltrim(str(PYMT.DRaccode))
               repl ddate with pymt.date
               repl vcn with iif(btr.billtype=0,opb.billno,pur.vchno)
               repl final with btr.amount
               
               sele g
               seek f.ord+f.vcn &&+ iif(btr.billtype=0,dtos(opb.date),dtos(pur.date))
               if found()
                  sele f
                  repl type with 'A'
                  repl voucher with b.voucher
                  repl adjvoucher with g.voucher
                  repl svoucher with g.svoucher
               endif
            sele btr
            skip
            enddo
         endif
endif    
    sele gledger
    appe blan
    repl voucher with last4
    repl date with pymt.date
    repl remark1 with subs(pymt.vchno,1,15)+pymt.narration
    repl book with 'P'
    repl cd with 'C'
    repl credit with pymt.amount
    repl code with alltrim(str(pymt.craccode))    
endscan


@rowno,10 say 'Importing Esimate Receipts'   font 'Arial',12
rowno=rowno+1
sele btr 
index on internal to btr
select select(1)
use &datdev\chiller.&datext alias gle
select g
index on issueto+vcn to pending
sele rcpt
set filter to date>=old_5 and date<=old_9 and vchno='ESRC'
go top
scan  
    last4=last4+5
    ptycod=draccode
    sele gle
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl codep with alltrim(str(rcpt.craccode))
    repl code1  with 'STACO3'
    repl cash with 'R'
    repl ammount with -rcpt.amount
    repl remark with subs(rcpt.vchno,1,15)+rcpt.narration

         ** Outstanding Adjustment
         if rcpt.amount>0 .and. old_3 = 'Y'
            sele btr     &&&&SANTOSH -> WRONG FILE WAS SELECTED . 
            seek rcpt.internal
            do while btr.internal=rcpt.internal .and. !eof()
               if btr.billtype=0
                  =seek(BILLINTERN,'opb')    &&& INSTEAD OF INTERNAL->BILLINTERN FIELD USED 
               else
                  =seek(billintern,'sal')   
               endif   
               sele f
               appe blank
               repl ord with alltrim(str(rcpt.craccode))
               repl ddate with rcpt.date
               repl vcn with iif(btr.billtype=0,opb.billno,sal.vchno)
               repl final with -btr.amount
               repl advance with 'R'
               repl type with 'A'
               repl voucher with gle.voucher
              
               sele g
               seek f.ord+substr(f.vcn,1,12) + iif(btr.billtype=0,dtos(opb.date),dtos(sal.date))
               if found()
                  sele f
                  repl voucher with g.voucher
                  repl adjvoucher with g.voucher
               endif

            sele btr
            skip
            enddo
         endif
    sele gle
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl codep  with 'STACO3'
    repl cash with 'R'
    repl ammount with rcpt.amount
    repl remark with subs(rcpt.vchno,1,15)+rcpt.narration
    repl code1 with alltrim(str(rcpt.craccode))

endscan
close tables all


bf=datdev + '\slipno.'+datext
use &bf
go top
repl voucher with last4+20
repl svoucher with slast5+20

close data 

proc UpdateDiscount
****proc Update Discount not allowed Values  
mfile=getfile("*.csv") 
sele sele(1) 
  create curs tpro ( product c(30),packing c(15),company c(30),discountyn c(10))
  appen from (mfile) type csv 

sele sele(1) 
  use &datdev\pro.&datext alias pro 
  index on product+packing to pro 
sele pro 
brow
sele tpro 
brow 
scan for len(alltrim(discountyn))>0
  sele tpro
  
  
*!*	  IF discountyn='Y'
*!*	  REPLACE ALL discountyn WITH 'N'
*!*	  ELSE
*!*	  IF discountyn='N'
*!*	  REPLACE ALL discountyn WITH 'Y'
*!*	  ENDIF
*!*	  ENDIF
  mdiscount=alltrim(discountyn)
*  ?mdiscount,mdiscount='Y'
  sele pro 
  seek subs(alltrim(tpro.product)+space(30),1,30)+subs(alltrim(tpro.packing)+space(15),1,15) 
  if found()    
      repl misc5 with substr(misc5,1,32)+IIF(mdiscount='N','Y','N')+substr(misc5,43,100)
      *wait  
  Endif
  ?pro.misc5
  
*!*	  if mdiscount='N' 
*!*	    ?tpro.product 
*!*	  Endif    
endscan

close data

*!*	EOF : TFMEDIVISION.PRG .....Author Santosh Srivastava

