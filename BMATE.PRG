*!*	bof : bmate.prg-super market(barcode wise)(master converstion) .....nivedan sharma
**area- goa(30)
*****last change by nivedan sharma        dated    : 25-feb-2019
*!* datatransferpath="e:\datafrom\"+space(45)
*!* datatransferext="dbf"
*!* for bill difference ## in support -> repl type with "#",aliase with "dat/f-sl",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!* for item difference ## in support -> repl type with "#",aliase with "dat/f-it",pcode with mitm.code,heading with iif(old_11="b",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for item batch difference ## in support -> repl type with "#",aliase with "dat/f-bt",pcode with mitm.code,heading with iif(old_11="b",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for ledger difference ## in support -> repl type with "#",aliase with "dat/f-ld",lcode with mact.ordno,value with tot
*!* ******************
*!* your commands
*!* ******************
*!* if lastkey()=27
*!*  return
*!* endif
*!* =starttransfer()
*!* ******************
*!*	*!* your commands
clear
close data
set talk off
set date to brit
set cent on
set dele on
set safe off


&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&outsitde pathe prg&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*!*	sure = space(4)
*!*	datatransferpath=substr('d:\nivedan\bmate\data\'+space(100),1,100)
*!*	datdev=substr('d:\nivedan\bmate\transfer\'+space(80),1,80)
*!*	datatransferext='dbf'
*!*	datext = 'a01'
*!*	old_3 = 'y'
*!*	old_4 = 'yes'
*!*	firstdate=ctod('01/04/2018')
*!*	lastdate= ctod('31/03/2019')
*!*	old_7='g'
*!*	old_1='bl'
*!*	mstatecode='19'
*!*	datatransfersql='no '
*!*	sure='sure'
&&&&&&&&&&&&&&&&&&&&&&&&&&&outsite marg prg &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && un-comment this for run from vfp
	lastdate =ctod('31/03/2026')                         && un-comment this for run from vfp
	datdev='d:\transfer'   && un-comment this for run from vfp
	datext='dbf'
endif
sure = 'sure'
datatransfermdb='No'
datatransferpath=substr('D:\2025\apr\Bmate\data\'+space(100),1,100)
datatransferext='dbf'
old_3 = 'yes'
old_4 = 'Yes'
old_5 = firstdate
old_6 = lastdate
old_7 = 'G'
old_1='bl'
softtype='FMCG   '
mstatecode='29'
removenull = 'No'
sure='sure'
@ 09,10 say 'bmate data path      :' font 'courier',18  get datatransferpath  font 'courier',18
@ 10,10 say 'bmate extension      :' font 'courier',18  get datatransferext  font 'courier',18
@ 11,10 say 'with outstanding y/n :' font 'courier',18  get old_3 pict '@m Yes,No '  font 'courier',18
@ 12,10 say 'no-full yes-master   :' font 'courier',18  get old_4 pict '@m No,Yes'  font 'courier',18
@ 13,10 say 'f.y.begin date       :' font 'courier',18  get old_5  font 'courier',18
@ 14,10 say 'f.y.end   date       :' font 'courier',18  get old_6   font 'courier',18
@ 15,10 say 'g-gst  v-vat         :' font 'courier',18  get old_7  font 'courier',18
@ 16,10 say 'state code           :' font 'courier',18  get mstatecode font 'courier',18
@ 17,10 say 'Trade                :' font 'courier',18  get softtype pict '@m Pharma,FMCG   '   font 'courier',18
@ 18,10 say 'removenull           :'  font 'courier',18 get removenull pict '@m No ,Yes'    font 'courier',18
@ 19,10 say 'type sure            :' font 'courier',18  get sure pict '@x!' font 'courier',18
read
clear
close data
datatransferpath=alltrim(datatransferpath)
if !right(datatransferpath,1)='\'
	datatransferpath=alltrim(datatransferpath)+'\'
endif
datatransferext='.'+alltrim(datatransferext)
datdev= alltrim (datdev)
datext= alltrim (datext)
if !dire(datatransferpath)
	md &datatransferpath
endif
if removenull='Y'
	@07,10 say 'removing null values..please wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif
if lastkey() = 27 or  upper( SURE ) # 'SURE'
	return
endif
clear
if type('FINALCP')#'U'
	=starttransfer()
endif
rowno=5
@ 02,22 say 'please wait importing bmate software data to marg.....' font 'arial',14 colo 'w+/g'
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
use &datdev\support.&datext
dele all for type='#' and aliase='dat/f'
pack
close data
set colo to
if old_4='Y'
	do margo
endi
proc margo
@rowno,10 say '**** importing product ****' font 'arial',12
rowno=rowno+1
fd=datatransferpath+'itemmaster'+datatransferext  
td=datdev+'\pro.'+datext
sele sele(1)
use datdev+'\saletype.'+datext alias mpcm
delete all for sgcode='COMMCD'
pack
index on sgcode+parnam+str(igst,5,2)to mpcm 
sele a
use &fd alias fitm
sele b
use &td alias mitm
zap
index on name to mitm

sele fitm
go top
scan
	last=recno()
	sele mitm
	append blank
	repl mitm.code with fitm.itemid
	repl mitm.name with fitm.searchkey
	repl mitm.product with alltrim(fitm.name)
	repl mitm.billname with alltrim(fitm.name)&& +'  '+ alltrim(fitm.iunit)
	repl mitm.unit with 'PCS'
	repl mitm.pack with fitm.subunitqty
	repl mitm.gcode5 with alltrim(str(fitm.brandid))
	repl mitm.gcode with alltrim(str(fitm.groupid))
	repl mitm.minimum with fitm.minlevel
	repl mitm.maximum with fitm.maxlevel
	repl mitm.taxl with 'T'
	repl mitm.taxc with 'T'
	repl mitm.decimal with 'T'
	repl mitm.salfix with 'N'
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.saltax with fitm.taxrate4
	repl mitm.cgst with fitm.taxrate4
	repl mitm.igst with fitm.taxrate3
	repl mitm.purtax with fitm.taxrate4
	repl mitm.status with 'Y'
	repl mitm.prate with fitm.inratebt
	repl mitm.ratea with fitm.outratebt
	repl mrp with fitm.rateat
	repl mitm.rateb with fitm.outrateat
	repl mitm.rackno with fitm.barcode
   &&&???? for hsn
    sele mpcm
    seek 'COMMCD' + substr(fitm.hsncode+space(15),1,15) + str(mitm.igst,5,2)
   if !found()
      append blank
      repl mpcm.sgcode with 'COMMCD',;
           mpcm.scode  with 'h'+alltrim(str(last)),;
           mpcm.sname  with substr(fitm.hsncode+space(15),1,15)+substr(fitm.hsncode,1,15) +' '+ alltrim(str(mitm.igst,5,2)),;
           mpcm.parnam with substr(fitm.hsncode,1,15),;
           mpcm.tax with mitm.saltax,;
           mpcm.cgst with mitm.cgst,;
           mpcm.igst with mitm.igst,;
           mpcm.tcode with 'no'
   endif
   repl mitm.gcode6 with mpcm.scode 
endsca
close table all
@rowno,10 say '**** importing company ****' font 'arial',12
rowno=rowno+1
fd=datatransferpath+'itembrandmaster'+datatransferext  
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
dele all for inlist(sgcode,'ZZZZZZ','CATEGO','SALT  ')
pack
index on scode to mpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO',;
		mpcm.scode  with alltrim(str(fpcm.brandid)),;
		mpcm.sname  with fpcm.name,;
		mpcm.parnam with fpcm.name,;
		mpcm.tcode with 'no',;
		mpcm.tax with 0
endsca
close table all
@rowno,10 say '**** importing group ****' font 'arial',12
rowno=rowno+1
fd=datatransferpath+'itemgroupmaster'+datatransferext  
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
index on scode to mpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ',;
		mpcm.scode  with alltrim(str(fpcm.groupid)),;
		mpcm.sname  with fpcm.name,;
		mpcm.parnam with fpcm.name,;
		mpcm.tcode with 'no',;
		mpcm.tax with 0
endscan
close table all
if softtype='P'
@rowno,10 say '**** importing batch stock ****' font 'arial',12
rowno=rowno+1
fd=datatransferpath+'itembatchmaster'+datatransferext  
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
sele a
use &fd alias fsbal
sele b
use &mi alias mitm
index on name to mitm
sele c
use &td alias msbal
zap
index on product+mycode to msbal
r=0
sele fsbal
go top
scan
	sele mitm
	seek substr(str(fsbal.itemid)+space(10),1,10)
	sele msbal
	seek substr(str(fsbal.itemid)+space(10),1,10)+substr(fsbal.barcode+space(12),1,12)	
	if .not.found()
		append blank
		repl  msbal.code with mitm.code
		repl  msbal.name with mitm.name
		repl  msbal.billname with mitm.billname
		repl  msbal.product with mitm.product
		repl  msbal.packing with mitm.packing
		repl  msbal.decimal with 'y'
		repl  msbal.mycode with fsbal.barcode
		*repl  msbal.prate with fsbal.bcostp
		repl  msbal.prate with fsbal.ratebt
		repl  msbal.ratea with fsbal.rateat
		repl  msbal.rateb with fsbal.inratebt
		repl  msbal.ratec with fsbal.inrateat
		repl  msbal.rated with fsbal.outratebt
		repl  msbal.mrp with fsbal.mrp
		repl  msbal.exp with fsbal.expdate
		*repl  msbal.lprate with fsbal.bnetp
        repl  msbal.opening with fsbal.currentsto
		repl  msbal.balance with fsbal.currentsto
		repl  msbal.o_a with fsbal.currentsto
		repl  msbal.b_a with fsbal.currentsto
	else
		repl  msbal.opening with msbal.opning+fsbal.currentsto
		repl  msbal.balance with msbal.balance +fsbal.currentsto
		repl  msbal.o_a with msbal.o_a +fsbal.currentsto
		repl  msbal.b_a with msbal.b_a +fsbal.currentsto
	    repl  msbal.prate with fsbal.ratebt
		repl  msbal.ratea with fsbal.rateat
		repl  msbal.rateb with fsbal.inratebt
		repl  msbal.ratec with fsbal.inrateat
		repl  msbal.rated with fsbal.outratebt
		repl  msbal.mrp with fsbal.mrp
	endif
endsca
close table all
endif
if softtype='F'
@rowno,10 say '**** Importing MRP Wise Stock ****' font 'arial',12
rowno=rowno+1
sele sele (1)
use &datatransferpath\itemmaster&datatransferext alias fsbal
sele sele (1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele (1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan
	if itemid=       21
	brow
	endif
	sele mitm
	seek str(fsbal.itemid,9)
	sele msbal
	seek str(fsbal.itemid,9)+str(fsbal.rateat,9,2)
	if .not.found()
		append blank
		repl  msbal.code with mitm.code
		repl  msbal.name with mitm.name
		repl  msbal.billname with mitm.billname
		repl  msbal.product with mitm.product
		repl  msbal.packing with mitm.packing
		repl  msbal.decimal with 'Y'
		repl msbal.pack with mitm.pack
		repl  msbal.mycode with fsbal.barcode
		repl  msbal.prate with fsbal.inratebt
		repl  msbal.lprate with fsbal.inratebt
		repl  msbal.ratea with fsbal.outratebt
		repl  msbal.rateb with fsbal.outrateat
		repl  msbal.mrp with fsbal.rateat
		repl  msbal.exp with ctod('')
		repl batchno with str(fsbal.rateat,9,2)
        repl  msbal.opening with fsbal.stock
		repl  msbal.balance with fsbal.stock
		repl  msbal.o_a with fsbal.stock
		repl  msbal.b_a with fsbal.stock
	else
		repl  msbal.opening with msbal.opning+fsbal.stock
		repl  msbal.balance with msbal.balance +fsbal.stock
		repl  msbal.o_a with msbal.o_a +fsbal.stock
		repl  msbal.b_a with msbal.b_a +fsbal.stock
		repl  msbal.prate with fsbal.inratebt
		repl  msbal.lprate with fsbal.inratebt
		repl  msbal.ratea with fsbal.outratebt
		repl  msbal.rateb with fsbal.outrateat
		repl  msbal.mrp with fsbal.rateat
	endif
endsca
close table all
endif

@rowno,10 say '**** importing customer master ****' font 'arial',12
rowno=rowno+1
fd=datatransferpath+'accountmaster'+datatransferext  
fdet=datatransferpath+'addressbook'+datatransferext  
td=datdev+'\order.'+datext
select select(1)
use datdev+'\support.'+datext  alias support
index on aliase + str(sno,3) + lcode to support
delete all for aliase ='order' .and. sno=7
pack
sele a
use &fd alias fact
sele c
use &fdet alias fadd
index on addressid to fadd
sele b
use &td alias mact
zap
sele fact
go top
do while .not. eof()
     select fadd
     seek fact.addressid    
    sele mact
	append blank
	if fact.accountgro=18
	 replace mact.scode with 'C6'
	else
	if fact.accountgro=17
	 replace mact.scode with 'D31'
	endif
	endif
	repl mact.rate with 'y'
	repl mact.ordno with alltrim(str(fact.accountid)),;
		 mact.parnam  with alltrim(fact.name),;
		 mact.paradd with alltrim(fadd.address),;
	     mact.dsm with alltrim(fadd.pin),;
		 mact.sthed with  'tin no.',;
		 mact.csthed with 'cst  no.',;
	     mact.phone1 with fadd.contactdet,;
		 mact.phone2 with fadd.phone1,;
		 mact.phone3 with fadd.phone2,;
		 mact.ref with 'mr.',;
		 mact.area with  str(fadd.areaid),;
		 mact.price with 'a',;
		 mact.city with  alltrim(fadd.city),;
		 mact.status with 'y',;
		 mact.adhed with 'discount',;
		 mact.opning with fact.currentbal
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
		sele fact
	skip
enddo
close table all
proc rem_null
totfields = afields(arr)
for imarg = 1 to totfields
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor


