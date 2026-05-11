*!*	BOF : TFMEDIVISION.PRG .....Author Santosh Srivastava
*****Last Change By Santosh K Srivastava       Dated    : 18/07/2019
*!* datatransferpath="e:\datafrom\"+space(45)
*!* datatransferext="dbf"
*!* for bill difference ## in support -> repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!* for item difference ## in support -> repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for item batch difference ## in support -> repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for ledger difference ## in support -> repl type with "#",aliase with "DAT/F-LD",Lcode with mact.ordno,value with TOT

sele sele(1)
  create curs mycurs  (setup c(50),value c(4)) 
  sele mycurs 
  appe blank 
  repl  setup with 'Item Wise Double Discount ',value with 'Y'
  appen blank
  repl  setup with 'Volume discount 1st ',value with 'L'
  appen blank
  repl  setup with 'Volume discount 2st ',value with 'L'
  appen blank 
  repl  setup with 'Bill Discount',value with 'Y'
  appen blank 
  repl  setup with 'Ask discount in amount ',value with 'N'
  brow FONT 'COURIER',18    NOMODIFY   
*!* ******************
*!* Your Commands
*!* ******************
*!* if LastKey()=27
*!*  Return
*!* endif
*!* =starttransfer()
*!* ******************
*!* your commands

clear
set talk off
set date to brit
set cent on
set dele on
set safe off
set cpdi off
set color to

IF TYPE ('FINALCP')='U'
firstdate=ctod('01/04/2023')
lastdate=ctod('31/03/2024')
datdev='d:\transfer'
datext='DBF'
ENDIF

*!*	margprmfmt='Courier'
*!*	margprmkkrfsz=18
*!*	*save SCREE to simple   &&&REMOVE
close data
sure = space(4)
sure='SURE'
datatransferpath=SubStr('D:\DM\Mar\Akhil_medivision\2023\'+space(99),1,99)
datatransferext='dbf'
old_3 = 'YES'
old_4 = 'No '
old_5 = FIRSTDATE 
old_9 = LASTDATE 
old_6 = '2'
old_7 = 'Y'
old_8 = '#'
scalc='9'
pcalc='2'
old_1="INV"
mstatecode='27'
updateitemdisc='No '
vatgst='GST'
mBusiness='Retail   '
Removecharfrombillno=0
@ 07,10 say 'MEDIVISION OLD DATA FROM     :' font 'COURIER',15 get datatransferpath font 'COURIER',15
@ 08,10 say 'MEDIVISION OLD DATA EXTENSON :' font 'COURIER',15 get datatransferext font 'COURIER',15
@ 10,10 say 'WITH O/S                     :' font 'COURIER',15 get old_3 pict '@m YES,NO '  font 'COURIER',15
@ 11,10 say 'MASTER-Y FULL-N              :' font 'COURIER',15 get old_4 pict '@m YES,NO '  font 'COURIER',15
@ 12,10 say 'F.Y.BEGIN FROM               :' font 'COURIER',15 get old_5 font 'COURIER',15
@ 13,10 say 'F.Y.END                      :' font 'COURIER',15 get old_9  font 'COURIER',15
@ 14,10 say 'Calculation(Sale)            :' font 'COURIER',15 get scalc font 'COURIER',15
@ 15,10 say 'Calculation(Purc)            :' font 'COURIER',15 get pcalc  font 'COURIER',15
@ 17,10 say 'Billno Start from character  :' font 'COURIER',15 get Removecharfrombillno  pict '99'  font 'COURIER',15
@ 18,10 say 'Business->Wholesale/Retail   :' font 'COURIER',15 get mBusiness  pict '@^ Wholesale,Retail   '  font 'COURIER',10
@ 19,10 say 'Type SURE                    :' font 'COURIER',15 get sure pict '@x!' font 'COURIER',15
read
datatransferpath=addbs(alltrim(datatransferpath))
datdev=addbs(alltrim(datdev))
datext=alltrim(datext)
if lastkey()=27 .or. sure#'SURE'
    retu
endif
clear

IF TYPE ('FINALCP')#'U'
=starttransfer()
ENDIF

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
zap
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
dele all for (sgcode="ZZZZZZ" or sgcode = "AREA  " or sgcode="SALT  " or;
              sgcode="COMMCD" or sgcode="ROUT  " or sgcode="STATIO  " or sgcode="CATEGO  ")
pack
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


@rowno,10 say 'Importing Salt'    font 'Arial',12
rowno=rowno+1
sele sele(1)
   use &datatransferpath\drug alias fsalt 
sele sele(1)
   use &datdev\saletype.&datext alias stype
sele fsalt
scan
  sele stype
  appen blank
  repl sgcode with 'SALT'
  repl scode with alltrim(str(fsalt.drugcode))
  repl sname with alltrim(fsalt.drugname)
  repl parnam with alltrim(fsalt.drugname)
endscan
close table all 
      


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

SELE SELE(1)
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
   repl mact.mailnam with upper(fact.acname),;
        mact.paradd with upper(fact.add1),;
        mact.paradd1 with trim(upper(fact.add2))+' '+allt(upper(fact.add3)),;
        mact.sthed with  'TIN No.',;
        mact.dlno with trim(fact.dlno),;
        mact.parnam with subs(upper(fact.acname),1,45),;
        mact.ref with 'Mr.',;
        mact.confir with fact.acname,;
        mact.price with 'A',;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        limit with fact.crlimit,mr with '',;
        area with alltrim(str(fact.areacode)),;
        duedays with fact.dueperiod,;
        disc2 with 0
        
        
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
 
close data
eras fdet.idx

if mBusiness='R'
@rowno,10 say 'Importing Patients'   font 'Arial',12
rowno=rowno+1
 sele sele(1)
   use &datatransferpath\patient alias pat 
 sele sele(1)
   use &datdev\maorder.&datext alias mord 
sele pat
scan
  sele mord
  appen blank 
  repl scode with 'PET#$~' 
  repl ordno with alltrim(str(pat.paticode)) 
  repl parnam with pat.patiname+pat.add1
  repl form with alltrim(str(pat.paticode))  
endscan       
endif
close data

if mBusiness='R'
@rowno,10 say 'Importing Doctor'   font 'Arial',12
rowno=rowno+1
 sele sele(1)
   use &datatransferpath\doctor alias doc 
 sele sele(1)
   use &datdev\maorder.&datext alias mord 
sele doc
scan
  sele mord
  appen blank 
  repl scode with 'PRE#$~' 
  repl ordno with alltrim(str(doc.doctcode)) 
  repl parnam with doc.doctname+doc.add1
  repl form with alltrim(str(doc.doctcode))  
endscan       
endif



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
       repl pack with fitm.pack
       repl billname with allt(fitm.prodname)+' '+trim(fitm.unit)
       repl unit with fitm.unit
       repl formulano with left(mfg.mfgname,15)
       repl gcode with ltri(str(fitm.compcode,6))
       repl gcode3 with ltri(str(fitm.drugcode,6))
       
       repl gcode5 with ltri(str(fitm.catcode,6))
       repl gcode6 with ltri(str(fitm.hsncode,6))
       repl taxl with iif(fitm.salestax#0,'T','E')
       *repl pack with fitm.packdesc
       repl taxc with 'T'
       repl decimal with 'Y'
       repl salfix with 'N'
       repl halfsche with 'A'
       repl qtrsche with 'Y'
       repl saltax with ftax.taxperc
       repl cgst with ftax.taxperc
       repl igst with ftax.taxperc*2
       repl status with 'Y'
*       repl misc5 with substr(misc5,1,32)+IIF(fitm.prodtype=3,'Y','N')+substr(misc5,43,100)
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
*    =seek(str(batchmst.prodcode,10)+str(batchmst.stockid,10),'sch')
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
            ratea    with batchmst.salerate,;
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl probat.opening with batchmst.balance,;
            probat.balance with batchmst.balance,;
            b_a with batchmst.balance,;
            o_a with batchmst.balance,;
            claim with batchmst.balance
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate
           * repl mycode with batchmst.barcode
            
    else
       repl probat.opening with probat.opening+batchmst.balance,;
            probat.balance with probat.balance+batchmst.balance,;
            b_a with b_a + batchmst.balance,;
            o_a with o_a + batchmst.balance
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate,;
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
            ratea    with batchmst.mrp,;
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
    else
    endif
sele batchmst
skip
enddo
sele probat
repl all date with old_5-1 for balance=0
clos data
eras pro.idx
eras probat.idx


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
RowNo=5
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

@rowno,10 say 'Importing Salt'    font 'Arial',12
rowno=rowno+1
sele sele(1)
   use &datatransferpath\drug alias fsalt 
sele sele(1)
   use &datdev\saletype.&datext alias stype
sele fsalt
scan
  sele stype
  appen blank
  repl sgcode with 'SALT'
  repl scode with alltrim(str(fsalt.drugcode))
  repl sname with alltrim(fsalt.drugname)
  repl parnam with alltrim(fsalt.drugname)
endscan
close table all 
      

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
if mBusiness='R'
@rowno,10 say 'Importing Patients'   font 'Arial',12
rowno=rowno+1
 sele sele(1)
   use &datatransferpath\patient ALIAS pat 
 sele sele(1)
   use &datdev\maorder.&datext alias mord 
sele pat
scan
  sele mord
  appen blank 
  repl scode with 'PET#$~' 
  repl ordno with alltrim(str(pat.paticode)) 
  repl parnam with pat.patiname+pat.add1
  repl form with alltrim(str(pat.paticode))  
endscan       
ENDIF
CLOSE data

if mBusiness='R'
@rowno,10 say 'Importing Doctor'   font 'Arial',12
rowno=rowno+1
 sele sele(1)
   use &datatransferpath\doctor ALIAS doc 
 sele sele(1)
   use &datdev\maorder.&datext alias mord 
sele doc
scan
  sele mord
  appen blank 
  repl scode with 'PRE#$~' 
  repl ordno with alltrim(str(doc.doctcode)) 
  repl parnam with doc.doctname+doc.add1
  repl form with alltrim(str(doc.doctcode))  
endscan       
endif

@Rowno,10 say 'Importing A/C Ledgers'   font 'Arial',12
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
         dele all for aliase = "DAT/F-LD"

sele fact
go top
do while !eof()
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
   repl mact.fax2 with allt(fact.alias),;
        mact.ordno with alltrim(str(fact.accode))
   repl mact.mailnam with upper(fact.acname),;
        mact.area with ltri(str(fact.areacode,6)),;
        mact.paradd with upper(fact.add1),;
        mact.paradd1 with trim(upper(fact.add2))+' '+allt(upper(fact.add3)),;
        mact.phone1 with fact.tel,;
        mact.sthed with  'TIN No.',;
        mact.gstno with fact.gstno,;
        mact.itno with fact.pan,;
        mact.dlno with trim(fact.dlno),;
        mact.parnam with subs(upper(fact.acname),1,45),;
        mact.ref with 'Mr.',;
        mact.confir with fact.acname,;
        mact.phone1 with fact.tel,;
        mact.phone4 with fact.mobile,;
        mact.price with 'A',;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        limit with fact.crlimit,;
        area with alltrim(str(fact.areacode))
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
    SELE SUPP 
    appen blan
    repl type with "#",aliase with "DAT/F-LD",Lcode with alltrim(str(fact.accode)),value with ledtot
sele fact
skip
enddo
close data
eras fdet.idx


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
       *REPL PACK WITH FITM.PACK
       repl unit with fitm.unit
       repl formulano with left(mfg.mfgname,15)
       repl gcode with ltri(str(fitm.compcode,6))
       repl gcode3 with ltri(str(fitm.drugcode,6))

       repl gcode5 with ltri(str(fitm.catcode,6))
       repl gcode6 with ltri(str(fitm.hsncode,6))
      * REPL RACKNO WITH ALLTRIM(STR(FITM.COMPBC,20))
       repl decimal with 'Y'
       repl salfix with 'N'
       repl minimum with fitm.minlevel
       repl maximum with fitm.maxlevel
       repl halfsche with 'A'
       repl qtrsche with 'Y'
       repl saltax with ftax.taxperc
       repl cgst with ftax.taxperc
       repl igst with ftax.taxperc*2
       repl taxl with iif(igst#0,'T','E')
       repl status with 'Y'
       repl misc6 with str(fitm.balqty,10,2)
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
close data 
if updateitemdisc='Y'
  * do UpdateDiscount 
endif
close data 



@Rowno,10 say 'Importing Batch/Stock (Opening) '   font 'Arial',12
Rowno=Rowno+1
fd=datatransferpath+'opstock.dbf'
pd=datatransferpath+'product.dbf'
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
fs=datatransferpath+'scheme.dbf'
IF mBusiness='W'
sele sele(1)
use &fs alias sch
index on str(prodcode,10)+str(stockid,10) to sch
endif
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
    =seek(str(batchmst.prodcode,10),'pro')
	if mBusiness='W'    
	    =seek(str(batchmst.prodcode,10)+str(batchmst.stockid,10),'sch')
	endif    
    sele probat
    seek str(batchmst.prodcode,10)+padr(batchmst.batchcode+space(12),12)
    if !found()
       appe blan
       repl code     with pro.code,;
            name     with pro.name,;
            billname with pro.billname,;
            product  with pro.product,;
            packing  with pro.packing,;
            unit2    with pro.unit2,;
            decimal  with 'Y',;
            batchno  with batchmst.batchcode
       repl exp      with batchmst.expdate,;
            prate    with iif(mBusiness='W',batchmst.purrate,batchmst.purcost),;
            ratea    with iif(mBusiness='W',batchmst.wrate,batchmst.salerate),;
            rateb    with iif(mBusiness='W',batchmst.ptr,0),;
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl probat.opening with batchmst.qty,;
            probat.balance with batchmst.qty,;
            b_a with batchmst.qty,;
            o_a with batchmst.qty
            *repl mycode with batchmst.barcode
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate
       *repl mycode with batchmst.barcode
     if mBusiness='W'
         repl    purdeal with sch.qty1,;
            purfree with sch.free1,;
            purdis with batchmst.dlessperc            
     endif            
    else
        repl probat.opening with probat.opening+batchmst.qty,;
             probat.balance with probat.balance+batchmst.qty,;
             b_a with b_a + batchmst.qty,;
             o_a with o_a+batchmst.qty
        repl supinvo with batchmst.billno,;
             supdat   with batchmst.billdate

     if mBusiness='W'
         repl    purdeal with sch.qty1,;
            purfree with sch.free1,;
            purdis with batchmst.dlessperc            
     endif            

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
SELE SELE(1) 
  use &datdev\support.&datext alias supp 
  index on aliase + str(sno,3) + lcode to SUPP 
  DELE ALL FOR ALIASE ='ORDER' AND SNO=7
  PACK 
if mBusiness='W'
sele sele(1)
use &fs alias sch
index on str(prodcode,10)+str(stockid,10) to sch
endif
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
if mBusiness='W'    
    =seek(str(batchmst.prodcode,10)+str(batchmst.stockid,10),'sch')
endif    
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
            unit     with pro.unit,mycode with batchmst.barcode,;
            decimal  with 'Y',;
            batchno  with batchmst.batchcode,;
            exp      with batchmst.expdate,;
            lprate   with iif(mBusiness='W',batchmst.purccost1,0),;
            prate    with batchmst.purrate,;
            ratea    with iif(mBusiness='W',batchmst.wrate,batchmst.salerate),;
            rateb    with iif(mBusiness='W',batchmst.ptr,batchmst.unitcost),;
            ratec    with iif(mBusiness='W',batchmst.purccost2,0),;
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl probat.opening with 0,;
            probat.balance with 0,;
            b_a with 0,;
            o_a with 0,;
            claim with batchmst.balance
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate
      if mBusiness='W'      
         repl purdeal with sch.qty1,;
            purfree with sch.free1,;
            purdis with batchmst.dlessperc
      endif   
      sele supp
	  appen blank
	  repl type with "#",aliase with "DAT/F-BT",lcode with "MEDIVI",pcode with pro.code,heading with batchmst.batchcode,value with batchmst.balance          
    else
       repl probat.opening with probat.opening+0,;
            probat.balance with probat.balance+0,;
            b_a with b_a + 0,;
            o_a with o_a + 0
       repl supinvo with batchmst.billno,;
            supdat   with batchmst.billdate,;
            claim with claim + batchmst.balance
      if mBusiness='W'      
         repl purdeal with sch.qty1,;
            purfree with sch.free1,;
            purdis with batchmst.dlessperc
      endif  
      sele supp
	*  appen blank
	  repl type with "#",aliase with "DAT/F-BT",lcode with "MEDIVI",pcode with pro.code,heading with batchmst.batchcode,value with value+batchmst.balance
		

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
            ratea    with iif(mBusiness='W',batchmst.wrate,batchmst.mrp),;
            rateb    with iif(mBusiness='W',batchmst.ptr,0),;
            mrp      with batchmst.mrp,;
            misc1    with pro.gcode
       repl purdis with iif(mBusiness='W',batchmst.dlessperc,0)
    else
       repl purdis with iif(mBusiness='W',batchmst.dlessperc,0)
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
   sele fout
   set filt to enttype = 4 .or. enttype = 3 .or. enttype = 5 .or. enttype = 22
   go top
   do while !eof()
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
           
           if fout.enttype = 4 .or. fout.enttype = 5 .or. fout.enttype = 22
              repl mpending.itemope with 0,;
                   mpending.final with fout.billamt,;
                   mpending.balance with fout.billamt,;
                   mpending.acgroup with 'C6'
           else
              if fout.enttype = 3
                 repl mpending.itemope with 0,;
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
DO counts


PROCE COUNTS
@rowno,10 say 'Importing Counter Sales'   font 'Arial',12
rowno=rowno+1
slp=datdev+'\slipno.'+datext
sele sele(1)
use &slp  alias mslip
sele mslip
go top
last4 = voucher + 10
slast5= svoucher + 10

sele sele(1)
use &datatransferpath\cntr alias sal
sele sele(1)
use &datatransferpath\cntrtr alia sld 
index on internal to sld
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datatransferpath\stock alias stock
index on stockid to stock
sele sele(1)
use &datatransferpath\gstaxtran alias gst
index on str(internal,9) + str(prodcode,9) to gst
sele sele(1)
  use &datdev\pro.&datext alias pro  
  index on name to pro 

sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

sele sal
last4=last4+5

scan
last4=last4+5
 sele mdis
 appen BLANK
    sele mdis
    appen blank
    repl voucher with last4
    repl vcn with sal.vchno
    repl date with sal.date
    repl type with "S"
    repl codep with 'STACO3'
    repl final with 0
    repl cash with sal.net
    &&  repl addis with sal.percdisc
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
    repl ltype with scalc
    repl godwon with 'A'
    repl remark4 with sal.vchno
    repl remark1 with str(sal.net,12,2)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
	sele support 
    appen blank
    repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash    
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
*        repl free with sld.schqty
        REPL PACK WITH IIF(sld.stockid=0,pro.pack,stock.PACK)
&&        REPL pack with pro.pack
        repl rate with sld.salerate
        repl flg with "G"
        repl godwon with 'A'
           repl ssta with sld.taxperc1
           repl cgst with sld.taxperc2
    endscan
ENDSCAN
clos tabl all

@rowno,10 say 'Importing Purchases'   font 'Arial',12
rowno=rowno+1

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

sele sele(1)
use &gled alias gledger
dele for book = 'A'
pack
sele sele(1)
use &dis alias dis
*zap
sele sele(1)
use &mdis alias mdis
*zap
sele sele(1)
use &ordr alias order
appen blank
repl ordno with 'otherl'
repl scode with 'J12'
repl parnam with 'Other Less'
repl mailnam with parnam
sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

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
if mBusiness='W'
sele sele(1)
use &trns alias transport
endif

sele sele(1)
  use &datdev\pro.&datext alias pro  
  index on name to pro 
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
   if  purc.tottax=0 &&and purc.totsurc=0 &&purc.totcst=0 and
      repl misc3 with subs(misc3,1,53)+'R'+substr(misc3,55)
   else
      repl misc3 with subs(misc3,1,53)+'T'+substr(misc3,55)
   endif
   repl vcn with iif(empty(last1),purc.billno,last1)
   repl date with purc.date
   repl pm with purc.billno
   repl lrda with purc.creadate
   repl codep with alltrim(str(purc.accode))
   repl amountt with (purc.net)
   repl salun with ''
   repl staxun with 'SZTZOZ'
   IF mBusiness='W'
   repl freight with -purc.lessamt
   ELSE
    REPL FREIGHT WITH -PURC.DRADJAMT   &&&&SANTOSH
   endif
   repl round with purc.rndamt&&purc.rnd
   REPL other with purc.otherless
   repl othun with 'otherl'
   repl ltype with pcalc
   repl voucher with last4
   if purc.trantype=1
      repl cash with purc.net
   else
      repl final with purc.net
   endif
   if final=0 and cash#0
      repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
      repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
   endif
*   repl addis with purc.percdisc
   repl duedays with 0
   repl account with 'N'
   repl sale with 'zYNYNPAYUN1N'
   repl godwon with 'A'
   repl ltype with pcalc
   repl discafter with 'N'
   repl remark4 with last1
   repl remark1 with str(purc.net,12,2)
    IF mBusiness='W'
   if purc.trptcode#0 and mBusiness='W'
      sele transport
      loca for trptcode=purc.trptcode
      sele mdis
      repl transport with transport.trptname
   ENDIF
   ENDIF
    sele support 
    appen blank
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
      repl tax with 'T'&&iif(putr.dstperc#0,'T','E')
      repl qty with putr.qty*IIF(PUTR.PACK=0,1,PUTR.PACK)
      IF  mBusiness='W'
      repl free with putr.free
      endif
      repl exp with putr.expdate
      repl batch with putr.batchcode
      repl misc4 with substr(misc4,1,14)+'M'+substr(misc4,16)
      repl flg with 'P'
      REPL FREE WITH PUTR.SCHQTY*IIF(PUTR.PACK=0,1,PUTR.PACK)
      repl rate with putr.purrate
      REPL PACK WITH PUTR.PACK
      IF mBusiness='W'
        repl disc1 with putr.dlessperc
        repl svdis with putr.schdisc 
      ELSE
*        repl disc1 with putr.itemdisc   
        repl disc1 with purc.percdisc
        REPL MDIS.ADDIS WITH 0   
        repl svdis with putr.scmdisc 
*IF PUTR.ITEMDISC#0        
        repl svdis1 with putr.Idamt
*ENDIF        
      ENDIF
      repl mrp with putr.mrp
      repl half with 'A'
      repl godwon with mdis.godwon
      repl tax with "T"
      repl ssta with putr.taxperc1
      repl cgst with putr.taxperc2
    IF putr.taxamt3#0 and putr.qty#0   
      repl cessinrs with val(str(putr.taxamt3/putr.qty,9,2))
    endif   
   sele putr
   skip
   enddo
sele purc
skip
enddo
clos tabl all
*IF MbUSINESS='R'

@rowno,10 say 'Importing Stock Adj(Self Receive)'   font 'Arial',12
rowno=rowno+1
sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datatransferpath\gstaxtran alias gst
index on str(internal,9) + str(prodcode,9) to gst
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
    appen blank
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
         repl rate with adjtrn.salerate
         repl mrp with adjtrn.mrp
         repl godwon with 'A'
    endscan
endscan
clos tabl all


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
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datdev\order.&datext alias ord
index on parnam to ord
sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
*!*	sele sele(1) 
*!*	  use &datdev\pro.&datext alias pro 
*!*	  index on name to pro 

sele crn
set filter to date>=old_5 and date<=old_9
go top
scan
    **@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    ptycod=accode
    sele acct
    seek crn.accode
    sele mdis
    appen blank
    repl voucher with last4
    repl challan with crn.vchno
    repl chdate with crn.date
    repl type with  "R"
    repl ltype with scalc
    repl codep with alltrim(str(crn.accode))
    repl cash with iif(crn.balamt=0,crn.net,0) &&-crn.balamt    
    repl final with crn.balamt
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
    repl mr with 'S'+alltri(str(crn.smancode))
    repl ltype with scalc ,godwon with 'A',addis with crn.lessperc
    repl remark4 with crn.vchno
    repl remark1 with str(crn.net,12,2)
	*repl freight with -(crn.schdisc)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
	 sele support 
    appen blank
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
         repl vcn with mdis.challan
         repl date with mdis.chdate
         repl codep with alltrim(str(crn.accode))
         repl code with pro.code
         repl tax with "T"
         repl batch with cled.batchcode
         repl qty with cled.qty
         IF mBusiness='W'
         
         repl free with cled.schqty
        

*!*	         repl disc1   with iif(subs(pro.misc5,33,1)='N' and updateitemdisc='Y' ,0,cled.percdedu)
*!*	         repl disc2   with iif(subs(pro.misc5,33,1)='N' and updateitemdisc='Y',0,crn.lessperc)
         repl disc1   with iif(subs(pro.misc5,33,1)='N',0,cled.percdedu)
         repl disc2   with iif(subs(pro.misc5,33,1)='N',0,crn.lessperc)
          endif

         repl exp     with cled.expdate
         repl rate    with cled.returate
         repl mrp     with cled.mrp
         IF mBusiness='W' 
         repl disc2   with iif(subs(pro.misc5,33,1)='N',0,cled.schdisc)
         endif
            repl ssta with cled.taxperc1
            repl cgst with cled.taxperc2
         if cled.reason = 1
            repl flg with 'R'
            repl godwon with 'A'
         else
            repl flg with 'W'
            repl godwon with 'Y'
         endif              
    endscan
endscan
clos tabl all

@rowno,10 say 'Importing Debit Note (Purchase Return) '   font 'Arial',12
rowno=rowno+1
if mBusiness='W'
sele sele(1)
	use &datatransferpath\godown alias god
	index on substr(alltrim(str(godocode)),1,1) to god
endif
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis

sele sele(1)
use &datatransferpath\stock alias stock
index on stockid to stock
sele sele(1)
use &datatransferpath\gstaxtran alias gst
index on str(internal,9) + str(prodcode,9) to gst
sele sele(1)
  use &datdev\pro.&datext alias pro  
  index on name to pro 

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
*!*	sele sele(1) 
*!*	   use &datdev\support.&datext  alias support    

sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

*!*	sele sele(1)
*!*	  use &datdev\pro.&datext alias pro 
*!*	  index on name to pro
sele drn
set filter to date>=old_5 and date<=old_9
go top
scan
 *   @rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
if mBusiness='W'    
    =seek(substr(alltrim(str(drn.internal)),1,1),'god')
endif    
    sele mdis
    appen blank
    repl voucher with last4
    repl VCN with drn.vchno
    repl date with drn.date
    repl type with  "B"
    repl ltype with scalc
    repl codep with alltrim(str(drn.accode))        
    repl final with drn.net
	repl account with 'N'
	repl godwon with 'A'
	repl discafter with 'N'
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
    repl ltype with PCALC,;
         addis with -drn.addperc

    repl remark4 with drn.vchno
    repl remark1 with str(drn.net,12,2)
    REPL SALE WITH 'zYNYNPAYUN1N'
    sele support 
    appen blank
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
        repl vcn with mdis.VCN
        repl date with mdis.date
        repl codep with alltrim(str(drn.accode))
        repl code with pro.code
        repl tax with "T"
        repl flg with "B"
        repl batch with stock.batchcode
        repl exp with stock.expdate        
        repl qty with dled.qty
        repl free with dled.schqty
        IF mBusiness='W'
        repl disc1 with dled.percdedu
        ELSE
          REPL DISC1 WITH  drn.lessperc

        endif
        repl rate with DLED.AMOUNT/DLED.QTY &&dled.returate
        repl mrp with stock.mrp
        repl flg with 'B'
        repl godwon with mdis.godwon
        if mdis.date >= ctod('01/07/2017')
	        IF !FOUND('GST')
	            =seek(str(dled->prodcode,9),'gst')
	         ENDI
         repl ssta with DLED.taxperc2
         repl cgst with DLED.taxperc2
      ELSE       
*         repl ssta with dled.vatperc
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
clos tabl all
@rowno,10 say 'Importing (Purchase Challan)'   font 'Arial',12
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis

sele sele(1)
use &datatransferpath\stock alias stock
index on stockid to stock
sele sele(1)
use &datatransferpath\gstaxtran alias gst
index on str(internal,9) + str(prodcode,9) to gst
sele sele(1)
  use &datdev\pro.&datext alias pro  
  index on name to pro 

sele sele(1)
	use &datatransferpath\dc alias dc  
sele sele(1)
	use &datatransferpath\dctr alias dcled 
	index on internal to dcled  
sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

sele dc
scan for between(date,old_5,old_9)
       last4=last4+5
    sele mdis
    appen blank
    repl voucher with last4
    repl challan with dc.vchno
    repl chdate with dc.date
    repl pm with dc.dcno
    repl type with  "P"
    repl ltype with pcalc
    repl codep with alltrim(str(dc.accode))        
    repl final with dc.net
	repl account with 'N'
	repl godwon with 'A'
	repl discafter with 'N'
    if final=0 and cash#0
       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
    else
       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
    endif
    repl remark4 with dc.vchno
    repl remark1 with str(dc.net,12,2)
    REPL SALE WITH 'zYNYNPAYUN1N'
    sele support 
    appen blank
    repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
    sele dcled
    seek dc.internal
    scan while internal=dc.internal
        =seek(stockid,'stock')
        =seek(str(prodcode,9)+str(internal,12),'gst') 
        =seek(str(prodcode,10),'pro')
        sele dis
        appen blank
        repl voucher with mdis.voucher
        repl vcn with mdis.VCN
        repl date with mdis.date
        repl codep with mdis.codep
        repl code with pro.code
        repl tax with "T"
        repl flg with "P"
        repl batch with DCLED.batchcode
        repl exp with DCLED.expdate        
        repl qty with dcled.qty*IIF(DCLED.PACK=0,1,DCLED.PACK)
        repl free with dcled.schqty*IIF(DCLED.PACK=0,1,DCLED.PACK)
        repl rate with DcLED.AMOUNT/DcLED.QTY &&dled.returate
        repl mrp with stock.mrp
        repl flg with 'P'
        repl godwon with mdis.godwon
        if mdis.date >= ctod('01/07/2017')
	        IF !FOUND('GST')
	            =seek(str(dled->prodcode,9),'gst')
	         ENDI
         repl ssta with DcLED.itemtax/2
         repl cgst with DcLED.itemtax/2
      ELSE       
*         repl ssta with dled.vatperc
      endif               
    endscan
    
endscan
clos tabl all

*!*		@rowno,10 say 'Importing Debit Note (Purchase Return) '   font 'Arial',12
*!*		rowno=rowno+1

*!*	if mBusiness='W'
*!*		sele sele(1)
*!*		use &datatransferpath\drcomp alias drn
*!*		sele sele(1)
*!*		use &datatransferpath\drcomptr alias dled
*!*		index on internal to dled
*!*	else
*!*		sele sele(1)
*!*		use &datatransferpath\drnote alias drn
*!*		sele sele(1)
*!*		use &datatransferpath\drnotr alias dled
*!*		index on internal to dled

*!*	endif	
	sele sele(1)
	use &datatransferpath\account alias acct
	index on accode to acct
	sele sele(1)
	use &datdev\order.&datext alias ord
	index on parnam to ord
sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
      
	*!*	sele sele(1)
	*!*	 use &datdev\pro.&datext alias pro 
	*!*	 index on name to pro 
*!*		sele drn
*!*		
*!*		set filter to date >= old_5 and date <= old_9
*!*		go top
*!*		
*!*		scan
*!*		    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
*!*		    last4=last4+5
*!*		    ptycod=accode
*!*		    
*!*		    sele mdis
*!*		    appen blank
*!*		    repl voucher with last4
*!*		    repl challan with drn.vchno
*!*		    repl chdate with drn.date
*!*		    repl type with  "B"
*!*		    repl ltype with scalc
*!*		    repl codep with alltrim(str(drn.accode))        
*!*		    repl final with drn.net
*!*			repl account with 'N'
*!*			repl sale with 'Z'
*!*			repl godwon with 'A'
*!*			repl discafter with 'N'
*!*		    
*!*		    if final=0 and cash#0
*!*		       repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
*!*		    else
*!*		       repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
*!*		    endif
*!*		    repl ltype with PCALC,;
*!*		         godwon with 'A',;
*!*		         addis with drn.addperc
*!*		        * bddis with drn.percdisc
*!*		         
*!*		    repl remark4 with drn.vchno
*!*		    repl remark1 with str(drn.net,12,2)
*!*		sele support 
*!*	    appen blank
*!*	    repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis.cash
*!*		    
*!*		    
*!*		    sele dled
*!*		    seek drn.internal
*!*		    scan while internal=drn.internal
*!*		        =seek(str(internal,9)+str(prodcode,9),'gst')
*!*		        =seek(str(prodcode,10),'pro')   
*!*		        sele dis
*!*		        appen blank
*!*		        repl voucher with mdis.voucher
*!*		        repl vcn with mdis.challan
*!*		        repl date with mdis.chdate
*!*		        repl codep with alltrim(str(drn.accode))
*!*		        repl code with pro.code
*!*		        repl tax with "T"
*!*		        repl flg with "B"
*!*		       IF mBusiness='W'
*!*		        repl batch with dled.batchcode
*!*		         repl exp with dled.expdate   
*!*		          repl rate with dled.rate 
*!*		          repl mrp with dled.mrp    
*!*		        ELSE
*!*		        repl batch with STR(dled.stockid)
*!*		         repl rate with dled.returate
*!*		        
*!*		       ENDIF
*!*		       
*!*		        repl qty with dled.qty
*!*		        repl free with dled.schqty
*!*		        repl disc1 with 0
*!*	*	        repl exp with dled.expdate
*!*		          
*!*		           repl ssta with dled.taxperc1
*!*		           repl cgst with dled.taxperc2
*!*		        
*!*		        if dled.reason = 1
*!*		           repl flg with 'B'
*!*		           repl godwon with 'A'
*!*		        else
*!*		           repl flg with 'Q'
*!*		           repl godwon with 'Y'
*!*		        endif              
*!*		    endscan
*!*		endscan

clos tabl all

@rowno,10 say 'Importing Sales '   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\sale alias sal
set filter to date>=old_5 and date<=old_9
sele sele(1)
use &datatransferpath\stock alias stock
index on stockid to stock
sele sele(1)
use &datatransferpath\gstaxtran alias gst
index on str(internal,9) + str(prodcode,9) to gst
sele sele(1)
  use &datdev\pro.&datext alias pro  
  index on name to pro 

sele sele(1)
use &datatransferpath\satr alias sld
index on internal to sld
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis

sele sele(1)
use &datatransferpath\doctor alias doc
INDEX on doctcode TO doc
sele sele(1)
use &acct alias acct
index on accode to acct

SELECT SELECT(1)
  USE &datatransferpath\patient ALIAS pat 
  INDEX on patiname+add1 TO pat  
  sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

last4=last4+5
sele sal
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    ptycod=accode
    sele acct
    seek sal.accode
    =seek(sal->doctcode,'doc')
    sele mdis
    appen blank
    repl voucher with last4
    repl vcn with ALLT(SUBSTR(sal.vchno,Removecharfrombillno+1,12))
    repl date with sal.date
    repl type with "S"
    IF mBusiness='R'
    IF sal.accode=0 
      mpcode=0      &&&&&By Santosh Srivastava . Patient code is not given in sale file .Search in master and replace

      SELECT PAT 
      SEEK SAL.patient+sal.address 
      mpcode=IIF(FOUND(),pat.paticode,mpcode)
      SELECT mdis
      repl docu with subs(ALLTRIM(STR(mpcode))+space(10),1,10)+SUBSTR(sal.patient,1,30)
      repl docu1 with substr(alltrim(STR(sal.doctcode))+space(10),1,10)+doc.doctname
      repl codep with 'STAC03'
    ELSE
      repl codep with alltrim(str(sal.accode))
      repl sale with 'zYNYNGAYUN1N'
      
     
      endif
    ELSE
    repl codep with alltrim(str(sal.accode))
    ENDIF
    IF  mBusiness='W'
    repl final with sal.net-sal.cashamt
     repl cash with sal.cashamt
    ELSE
     IF sal.trantype=1
     repl cash with sal.net
    ELSE
    repl final with sal.net
    endif
    ENDIF
   
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
    repl addis with sal.percdisc
     IF  mBusiness='W'
    repl other with -sal.octroi,;    
         othun with 'OCTROI',;
         packing with -sal.cradjamt+sal.dradjamt,;
         pacun with 'CRN'
     ELSE
     REPLACE other with sal.others
     
    endif
    repl freight with sal.totvat
    repl freun with 'STcA%-'
    repl ltype with scalc
    repl mr with 'S'+alltri(str(sal.smancode))
    repl remark4 with sal.vchno
    repl remark1 with str(sal.net,12,2)
	repl account with 'N'
	*repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
*	REPL bddis with sal.percdisc
	sele support 
    appen blank
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
        repl vcn with mdis.vcn
        repl date with mdis.date
        repl codep with mdis.codep
        repl tax with "T"
        repl code with pro.code
        repl batch with stock.batchcode
        repl exp with stock.expdate
        repl mrp with stock.mrp
        repl qty with sld.qty
        repl ADDIS with mdis.Addis
        IF  mBusiness='W'
        repl free with sld.schqty
        endif
        repl rate with SLD.SALERATE &&&&(SLD.AMOUNT/sld.qty)   &&&&sld.salerate
        REPL PACK WITH IIF(sld.stockid=0,pro.pack,stock.PACK)
        repl flg with "G"
*!*	        repl disc1 with iif(subs(pro.misc5,33,1)='Y' and updateitemedisc='N',0,sld.itemdisc)
*!*	        repl disc2 with iif(subs(pro.misc5,33,1)='Y' and updateitemedisc='N',0,iif(sld.schdisc#0,0,sal.percdisc))
*!*	        repl svdis with iif(subs(pro.misc5,33,1)='Y' and updateitemedisc='N',sld.schdisc,0) 
        repl disc1 with iif(subs(pro.misc5,33,1)='N',0,sld.itemdisc)
	   * repl svdis with iif(subs(pro.misc5,33,1)='N',sld.schdisc,0) 
           repl ssta with sld.taxperc1
           repl cgst with sld.taxperc2
      IF sld.taxamt3#0 and sld.qty#0   
      repl cessinrs with val(str(sld.taxamt3/sld.qty,9,2))
    endif   

    endscan
endscan
clos tabl all


if mBusiness='W'
@rowno,10 say 'Importing Sales Through Challan'   font 'Arial',12
rowno=rowno+1
sele sele(1) 
 use &datdev\support.&datext  alias support
 inde on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
   append blank
   repl type with 'F',;
      aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

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
         packing with -sal.cradjamt+sal.dradjamt,;
         pacun with 'CRN'
         
    repl remark4 with sal.vchno
    repl remark1 with str(sal.net,12,2)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
	 sele support 
    appen blank
    repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
    
    
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
        repl pack with pro.pack
        repl flg with "G"
        repl disc1 with iif(subs(pro.misc5,33,1)='N',0,sld.itemdisc)
        *repl disc2 with iif(subs(pro.misc5,33,1)='N',0,iif(sld.schdisc#0,0,sal.percdisc))
        repl svdis with iif(subs(pro.misc5,33,1)='N',0,sld.schdisc)
        repl sssc with sld.percoct
        repl godwon with 'A'
           repl ssta with sld.taxperc1
           repl cgst with sld.taxperc2
    endscan
endscan
clos tabl all
endif

if mBusiness='W'
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
	sele support 
    appen blank
    repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
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
        repl ssta with sld.taxperc1
        repl cgst with sld.taxperc2
    endscan
endscan
close data

endif

close table all

@rowno,10 say 'Importing Account From Sales'   font 'Arial',12
rowno=rowno+1
af     =datdev + '\gledger.'+datext
pend   =datdev + '\pend.'+datext
mdis   =datdev + '\mdis.'+datext
pending=datdev + '\pendings.'+datext
sele g
use &pending alias pending
sele f
use &pend alias pend
zap
sele b
use &af alias gledger
zap
sele d
use &mdis alias mdis
go top
do while !eof()
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
      sele f
      appe blank
      repl ord with mdis.codep
      repl ddate with mdis.date
      repl duedays with mdis.duedays
      repl vcn with mdis.vcn
      if d.type='P'
         repl final with -mdis.final
      else
         repl final with mdis.final
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

sele sele(1)
use &datatransferpath\jrnl alias jrnl
set filter to date>=old_5 and date<=old_9
sele sele(1)
use &datatransferpath\jrnltr alias jled
index on internal to jled

sele jrnl
go top
scan
    *@rowno-1,50 say str(recno(),10)  font 'Arial',12
    last4=last4+5
    sele jled
    seek jrnl.internal
    scan while internal = jrnl.internal
IF mBusiness#'R'    
    IF jled.cradjamt#0
       LOOP
    endif
ENDIF    
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
endscan


if mBusiness='W'
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
use &pending alias pending
index on ord + substr(name,1,12) + dtos(ddate) to rou2
sele f
use &pend alias pend

sele sele(1)
use &datatransferpath\purc alias pur
index on internal to pur
sele sele(1)
use &datatransferpath\sale alias sal
index on internal to sal
sele sele(1)
use &datatransferpath\opbill alias opb
index on internal to opb
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
         IF mBusiness='W'
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
         ENDIF
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
sele sele(1)
use &datatransferpath\receipt alias rcpt
set filter to date>=old_5 and date<=old_9
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
    repl credit with rcpt.amount
    repl code with alltrim(str(rcpt.craccode))

         ** Outstanding Adjustment
         IF mBusiness='W'
         if mrcptl.amount>0 .and. old_3 = 'Y'
            sele btr
            seek mrcptl.internal
            do while mrcptl.internal = btr.internal .and. !eof()
               if btr.billtype=0
                  =seek(internal,'opb')
               else
                  =seek(internal,'sal')   
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
IF  mBusiness='W'
if rcpt.discamt#0
  
    sele gledger    
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl remark1 with subs(rcpt.vchno,1,15)+rcpt.narration
    repl book with "R"
    repl cd with "C"
    repl CREDIT with rcpt.discamt
    repl code with alltrim(str(rcpt.Craccode))
  
         ** Outstanding Adjustment
         if mrcptl.DISCAMT>0 .and. old_3 = 'Y'
            sele btr
            seek mrcptl.internal
            do while mrcptl.internal = btr.internal .and. !eof()
               if btr.billtype=0
                  =seek(internal,'opb')
               else
                  =seek(internal,'sal')   
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
            ENDDO
            endif
        
  
    appen blank
    repl voucher with last4
    repl date with rcpt.date
    repl remark1 with subs(rcpt.vchno,1,15)+rcpt.narration
    repl book with "R"
    repl cd with "D"
    repl debit with rcpt.discamt
    repl code with 'DS9999'

   ENDIF
   endif
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
        if mBusiness='W'
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
         ENDIF
         endif
    
    appe blan
    repl voucher with last4
    repl date with pymt.date
    repl remark1 with subs(pymt.vchno,1,15)+pymt.narration
    repl book with 'P'
    repl cd with 'C'
    repl credit with pymt.amount
    repl code with alltrim(str(pymt.craccode))    
endscan


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

