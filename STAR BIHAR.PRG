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

sure = space(4)
datatransferpath=substr('D:\MIGRATION_DATA\MAR\STAR\STAR_DATA\vDosPlus\GSTAR19\DATA\'+space(100),1,100)
datatransferpath1=substr('D:\MIGRATION_DATA\MAR\STAR\STAR_DATA\vDosPlus\GSTAR19\DATA\2025\'+space(100),1,100)
datatransferext='dbf'
old_3 = 'YES'
old_4 = 'YES'
old_5 = CTOD('01/04/2023')
old_6 = '2'
old_7 = 'Y'
old_8 = '#'
mstatecode='10'
@ 10,10 SAY 'STAR Data Path (Master) :' get datatransferpath
@ 11,10 SAY 'STAR Data Path (Trn)    :' get datatransferpath1
@ 12,10 SAY 'STAR Data Ext           :' get datatransferext
@ 13,10 SAY 'WITH O/S                :' get old_3 PICT '@m YES,NO '
@ 14,10 SAY 'F/Y Start Date          :' get old_5
@ 16,10 SAY 'Type Sure               :' get sure Pict '@x!'
read

datatransferpath = alltrim(datatransferpath)
datatransferpath1 = alltrim(datatransferpath1)

if lastkey()=27 .and. Sure#'SURE'
	return
endif
clear
if type('FINALCP')#'U'
	=starttransfer()
ENDIF
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
wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer ITEM"
fd=datatransferpath+'rate.dbf'
ft=datatransferpath1+'tax.dbf'
td=datdev +'\pro.'+datext
tc=datdev +'\saletype.'+datext

sele select(1)
use &tc alias mpcm
dele all for sgcode = 'COMMCD'
dele all for sgcode = 'ZZZZZZ'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm


sele c
use &ft alias ftax
index on tcode to ftax
sele a
use &fd alias fitm
sele b
use &td alias mitm 
zap
index on name to mitm
sele fitm
go top
do while .not. eof()
   last=recno()
   sele mitm
   seek substr(fitm.itcode+space(10),1,10)
   if .not. found()
      append blank
      repl mitm.code with last
      repl mitm.name with fitm.itcode
      repl mitm.product with fitm.itname
      repl mitm.packing with fitm.unit
      repl mitm.billname with alltrim(fitm.itname) +'  '+ alltrim(fitm.unit)
      repl mitm.unit with fitm.units
      repl mitm.taxl with 'T'
      repl mitm.taxc with 'T'
      repl mitm.decimal with 'Y'
      repl mitm.salfix with 'N'
      repl mitm.minimum with fitm.min
      repl mitm.maximum with fitm.max
      repl mitm.halfsche with 'A'
      repl mitm.qtrsche with 'Y'
      
      sele ftax
      seek fitm.ptcode
      repl mitm.salsc with 0
      repl mitm.saltax with ftax.gst/2
      repl mitm.cgst with ftax.gst/2      
      repl mitm.igst with ftax.gst            
      repl mitm.pursc with 0
      repl mitm.purtax with ftax.gst/2
      repl mitm.status with 'Y'
	  mhsn=''&&fitm.hsn	      
      &&HSN
      sele mpcm
      seek 'COMMCD' + substr(mhsn+space(15),1,15) + str(mitm.igst,5,2)
      if !found()
         append blank
         repl mpcm.sgcode with 'COMMCD',;
              mpcm.scode  with 'C'+alltrim(str(last)),;
              mpcm.sname  with substr(mhsn+space(15),1,15)+ substr(mhsn,1,15) +' '+ alltrim(str(mitm.igst,5,2)),;
              mpcm.parnam with substr(mhsn,1,15),;
              mpcm.tax with mitm.saltax,;
              mpcm.cgst with mitm.cgst,;
              mpcm.igst with mitm.igst,;
              mpcm.tcode with 'No'
      endif
      repl mitm.gcode6 with mpcm.scode
      
      
      sele mpcm
      seek 'ZZZZZZ' + substr(fitm.comp+space(15),1,15)
      if !found()
         append blank
         repl mpcm.sgcode with 'ZZZZZZ',;
              mpcm.scode  with fitm.itcode,;
              mpcm.sname  with fitm.comp,;
              mpcm.parnam with fitm.comp,;
              mpcm.tcode with 'No',;
              mpcm.tax with 1
      endif   
      repl mitm.gcode with mpcm.scode
   endif
sele fitm
skip
enddo
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer BATCH"
fd=datatransferpath + 'batch.dbf'
td=datdev  + '\probat.'+datext
mi=datdev  + '\pro.'+datext
sele a
use &fd alias fsbal 
sele b
use &mi alias mitm 
index on name to mitm
sele c
use &td alias msbal 
zap
index on name to msbal

r=0
sele fsbal
go top
do while .not. eof()
   sele mitm
   seek substr(fsbal.itcode+space(10),1,10)
   sele msbal
   seek substr(fsbal.itcode+space(10),1,10) + substr(fsbal.batch+space(12),1,12)
   if .not. found()
      append blank
      repl msbal.code with mitm.code,;
           msbal.name with mitm.name,;
           msbal.billName with mitm.billname,;
           msbal.product with mitm.product,;
           msbal.pack with mitm.pack,;
           msbal.unit2 with mitm.unit2,;
           msbal.unit with mitm.unit,;
           msbal.decimal with 'Y',;
           msbal.opening with (fsbal.qty),;
           msbal.balance with (fsbal.qty),;
           msbal.o_a with (fsbal.qty),;
           msbal.b_a with (fsbal.qty),;
           msbal.exp with fsbal.exp,;
           msbal.lprate with fsbal.np_rate,;
           msbal.prate with fsbal.dp,;
           msbal.ratea with fsbal.tr,;
           msbal.mrp with fsbal.mrp,;
           msbal.misc1 with mitm.gcode,;
           msbal.batchno with fsbal.batch,;
           msbal.purdeal with fsbal.bq,;
           msbal.purfree with fsbal.bb,;
           msbal.purdis with fsbal.disc
    else
      repl msbal.opening with msbal.opening + (fsbal.qty),;
           msbal.balance with msbal.balance + (fsbal.qty),;
           msbal.o_a with msbal.o_a + (fsbal.qty),;
           msbal.b_a with msbal.b_a + (fsbal.qty),;
           msbal.lprate with fsbal.np_rate,;
           msbal.prate with fsbal.dp,;
           msbal.ratea with fsbal.tr,;
           msbal.mrp with fsbal.mrp,;
           msbal.purdeal with fsbal.bq,;
           msbal.purfree with fsbal.bb,;
           msbal.purdis with fsbal.disc
    endi
sele fsbal
skip
enddo
sele msbal
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Customer Master"
fd=datatransferpath1 + 'sto.dbf'
td=datdev  + '\order.'+datext
ts=datdev  + '\support.'+datext

sele d
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
go top
do while .not. eof()
   sele mact
   append blank
   repl mact.rate with 'Y'
   REPL scode with 'C6' 
   repl mact.ordno with alltr(str(recno())),;
        mact.parnam  with upper(fact.sname),;
        mact.paradd with fact.add,;
        mact.paradd1 with alltrim(fact.add2)+' '+alltrim(fact.add3),;
        mact.paradd2 with fact.city,;
        mact.sthed with  'TIN No.',;
        mact.csthed with 'CST No.',;
        mact.cstno with fact.tinc,;
        mact.stno with fact.tin,;
        mact.gstno with fact.tin,;
        mact.fax2 with fact->ssname,;
        mact.dlno with alltrim(fact.dlno),;
        mact.mailnam with parnam,;
        mact.ref with 'Mr.',;
        mact.phone1 with fact.ph1,;
        mact.phone2 with fact.ph2,;        
        mact.confir with fact.mp,;
        mact.area with fact.root,;
        mact.price with 'A',;
        mact.city with fact.city,;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        mact.itno with fact.pan,;
        mact.opning with iif(fact.bal1='D',fact.bal,-fact.bal)
sele fact
skip
enddo
close data

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Supplier Master"
fd=datatransferpath1 + 'pfrom.dbf'
td=datdev  + '\order.'+datext
ts=datdev  + '\support.'+datext

sele d
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup
sele a
use &fd alias fact  
sele b
use &td alias mact 
sele fact
go top
do while .not. eof()
   sele mact
   append blank
   repl mact.rate with 'Y'
   REPL scode with 'D31' 
   repl mact.ordno with alltr(str(recno()))
   repl mact.fax2 with fact->psname
   repl mact.desi with fact->sname,;
        mact.parnam  with upper(fact.pname),;
        mact.paradd with fact.add,;
        mact.paradd1 with alltrim(fact.add2)+' '+alltrim(fact.add3),;
        mact.paradd2 with fact.city,;
        mact.sthed with  'TIN No.',;
        mact.csthed with 'CST No.',;
        mact.dsm with fact.zip,;
        mact.stno with fact.tinc,;
        mact.gstno with fact.tinb,;
        mact.fax1 with fact->fax,;
        mact.dlno with alltrim(fact.dlno),;
        mact.mailnam with parnam,;
        mact.ref with 'Mr.',;
        mact.phone1 with fact.ph1,;
        mact.phone2 with fact.ph2,;        
        mact.confir with fact.mp,;
        mact.price with 'A',;
        mact.city with fact.city,;
        mact.status with 'Y',;
        mact.adhed with 'Discount',;
        mact.itno with fact.pan,;
        mact.opning with iif(fact.bal1='D',fact.bal,-fact.bal)
	&&&STATE
	sele msup
	appen blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	&&Local/Central Update
	select msup
	appe blan
	repl aliase with 'LBTDETAI'
	repl type with 'F'
	repl lcode with mact.ordno
	repl heading with iif(mstatecode=left(mact.gstno,2) and empty(mact.gstno),'L            LN','L            ON ')

sele fact
skip
enddo
close data