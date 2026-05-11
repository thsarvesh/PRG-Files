
*!*	CLOSE ALL
****634AD311
*!*	BOF : TFACME_Retail.PRG .....Author Santosh Srivastava
*****Last Change By Santosh K Srivastava       Dated    : 04/01/2018
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
appen blank
repl  setup with 'Volume discount 1st ',value with 'L'
appen blank
repl  setup with 'Volume discount 2nd ',value with 'L'
brow font 'COURIER',18    nomodify

set talk off
set date to brit
set cent on
set dele on
set safe off
set cpdi off
set color to
IF TYPE('FINALCP')='U'
	firstdate=ctod('01/04/2024')
	lastdate= ctod('31/03/2025')
	datdev='d:\transfer'
	datext='dbf'
endif
clear
close table all
sure = 'SURE' &&space(4)
datatransferpath=substr('D:\Data_Migration\Nov\acmemh\'+space(100),1,60)
datatransferext = 'DBF'
old_3 = 'Yes'
old_4 = 'No '
old_5 = firstdate
old_6 = lastdate
old_7 = 'GST  '
mstatecode='27'
softtype='WholeSale'
scalc='2'
srcalc='8'
pcalc='2'
mtrade='Pharma '
removenull='NO '
mrgmdbfile=space(100)
mrgmdbpwd=space(30)
ltype1="1"
clear
sure = space(4)
old_5 = firstdate
old_6 = lastdate
fm    = 'NO '
pcalc = '2'
scalc = '2'
pcalco="N"
scalco="N"
pcalco1="N"
scalco1="N"
bchklst='N'
multiunit="Y"
sure='SURE'
fmt='1'
autoos='Yes'
mstatecode='27'
drcrdisc='Yes'
itemcrn='No '
companycode=1
onlyout='No '
@03,10 say 'Only Outstanding,Full:' font 'Courier',18 get onlyout pict '@M No ,Yes'     font 'Courier',18
read
if onlyout='Y'
	do tf_acmeout
	return
endif
@04,10 say 'Old Data From        :' font 'Courier',18 get datatransferpath    font 'Courier',18
@05,10 say 'Old Data Extension   :' font 'Courier',18 get datatransferext     font 'Courier',18
@06,10 say 'With Out Standing    :' font 'Courier',18 get old_3               font 'Courier',18 pict  '@m Yes,No '
@07,10 say 'Only Balance         :' font 'Courier',18 get old_4               font 'Courier',18 pict  '@m No ,Yes'
@08,10 say 'Financial Year From  :' font 'Courier',18 get old_5               font 'Courier',18
@09,10 say 'Financial Year UpTo  :' font 'Courier',18 get old_6               font 'Courier',18
@10,10 say 'Sales Calculation    :' font 'Courier',18 get scalc               font 'Courier',18
@11,10 say 'Purchase Calculation :' font 'Courier',18 get pcalc               font 'Courier',18
@12,10 say 'State GST Code       :' font 'Courier',18 get mstatecode          font 'Courier',18
@13,10 say 'Wholesale/Retail     :' font 'Courier',18 get softtype            font 'Courier',18 pict  '@m Wholesale,Retail   '
@15,10 say 'Company code         :' font 'Courier',18 get companycode         font 'Courier',18 pict  '999'
@16,10 say 'Type Sure            :' font 'Courier',18 get sure                font 'Courier',18  pict  '@X!'
read
datatransferpath=alltrim(datatransferpath)
datatransferext=alltrim(datatransferext)
datdev= alltrim ( datdev  )
datext= alltrim ( datext )
if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
if type('FINALCP')#'U'
	=starttransfer()
endif

rowno=5
@02,22 say 'Please Wait Importing ACME Data To Marg.....' font 'Arial',14 colo 'W+/G'
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
zap
pack

close table all


select select(1)
mytable=datatransferpath+'datetable.dbf'
if !file(mytable)
	create table &mytable( sno int,value int)
	appen blank
	repl sno with 1,value with 0
endif
@rowno,10 say '**** Importing Series  ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\secondarymasters alias series
sele sele(1)
use &datdev\saletype.&datext alias stype

sele series
scan for mastertype=18
	sele stype
	appen blank
	repl sgcode with 'SERIES'
	repl scode with alltrim(str(series.mastercode))
	repl sname with upper(series.descriptio)
	repl parnam  with upper(series.descriptio)
endscan

close table all

@rowno,10 say '**** Importing Product Category  ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\secondarymasters alias cat
sele sele(1)
use &datdev\saletype.&datext alias stype

sele cat
scan for mastertype=14
	sele stype
	appen blank
	repl sgcode with 'CATEGO'
	repl scode with alltrim(str(cat.mastercode))
	repl sname with upper(cat.descriptio)
	repl parnam  with upper(cat.descriptio)
endscan

close table all
@rowno,10 say '**** Importing Company  ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\secondarymasters alias area
sele sele(1)
use &datdev\saletype.&datext alias stype


sele area
scan for mastertype=11
	sele stype
	appen blank
	repl sgcode with 'ZZZZZZ'
	repl scode with alltrim(str(area.mastercode))
	repl sname with upper(area.descriptio)
	repl parnam  with upper(area.descriptio)
endscan

close table all

@rowno,10 say '**** Importing Salesman/M.R.  ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\secondarymasters alias mr
sele sele(1)
use &datdev\order.&datext alias ord

sele mr
scan for mastertype=124
	sele ord
	appen blank
	repl scode with 'D32'
	repl ordno with 'MR'+alltrim(str(mr.mastercode))
	repl parnam with upper(mr.descriptio)
	repl mailnam with upper(mr.descriptio)
endscan
close table all


@rowno,10 say '**** Importing Product  ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &datatransferpath\schememst alias scm
index on itemcode to scm for startdate#0 and enddate#0
sele sele(1)
use &datatransferpath\primemasters alias fitm
sele sele(1)
use &datdev\support.&datext alia support
sele sele(1)
use &datatransferpath\primemasterdetails alias idet
copy to &datatransferpath\taxmaster for mastertype=144
index on str(compcode)+str(mastercode) to idet for mastertype=5
sele sele(1) &&&updated By Umesh 29/01/2024
sele * from idet into curs mycat readw where fieldno=40 and compcode=companycode and !empty(fieldlooku) 
inde on mastercode to mycat

sele sele (1)
select *from idet where fieldno=580 into curs frk
sele frk
index on mastercode to frk
sele sele (1)
select *from idet where fieldno=40 and mastertype=5 into curs fh
index on mastercode to fh

sele sele(1)
use &datatransferpath\itemunitlevel alias unit
set filt to levelno=2
index on itemcode to unit

sele sele(1)
use &datdev\rate.&datext alias rate
dele all
pack
sele sele(1)
use &datatransferpath\taxmaster alias ftax
index on mastercode to ftax

sele sele(1)
use &datdev\pro.&datext alias pro
sele sele(1)
use &datdev\saletype.&datext alias stype
index on sgcode+sname+str(igst,6,2) to stype
sele sele(1)
use &datatransferpath\productingredienttable alias salt
index on itemcode to salt

sele fitm
scan for mastertype=5 and compcode=companycode
     =seek(mastercode,'unit')
	sele pro
	appen blank
	repl code with fitm.mastercode
	repl name with alltrim(str(fitm.mastercode))
	repl product with upper(fitm.descriptio)
	sele idet
	seek str(fitm.compcode)+str(fitm.mastercode)
	mtax=0
	loca for fieldno=1050  while str(compcode)+str(mastercode)=str(fitm.compcode)+str(fitm.mastercode)
	if found()
		sele ftax
		seek val(alltrim(idet.fieldvalue))
		scan while mastercode=val(alltrim(idet.fieldvalue))
			if fieldno=30
				repl pro.saltax with val(ftax.fieldvalue)
			else
				if fieldno=40
					repl pro.cgst with val(ftax.fieldvalue)
				else
					if fieldno=50
						repl pro.igst with val(ftax.fieldvalue)
						mtax=val(ftax.fieldvalue)
					endif
				endif
			endif
		endscan
	endif
	IF SOFTTYPE='R'
	   repl pro.pack with unit.conversion
	endif   
	sele idet
	seek str(fitm.compcode)+str(fitm.mastercode)
	
	mpack=0
	scan for mastertype=5 while str(compcode)+str(mastercode)=str(fitm.compcode)+str(fitm.mastercode)
		do case
		case fieldno=50
			repl pro.packing with alltrim(idet.fieldlooku)
			repl pro.billname with pro.product+pro.packing
			=seek(fitm.mastercode,'frk')
			repl pro.rackno with frk.fieldlooku
			=seek(fitm.mastercode,'fh')
			repl pro.gcode4 with iif(fh.fieldlooku='**Schedule H1','  NN       #     NNMN    ','  NN       N     NNMN    ')
		case fieldno=180
			repl pro.gcode with alltrim(idet.fieldvalue)
		case fieldno=1050
			sele stype
			seek 'COMMCD'+subs(idet.fieldlooku+space(40),1,15)+str(mtax,6,2)
			if !found()
				appen blank
				repl sgcode with 'COMMCD',scode with alltrim(str(recno()))
				repl parnam with allt(idet.fieldlooku)+' - '+str(mtax,6,2)+'%',sname with allt(idet.fieldlooku)+' - '+str(mtax,6,2)+'%'
				repl igst with mtax,tax with mtax/2,cgst with mtax/2
			endif
			sele pro
			repl gcode6 with stype.scode
		
		endcase
		if seek(fitm->mastercode,'mycat')
		sele stype
		seek 'CATEGO'+subs(mycat.fieldlooku+spac(40),1,40)
		if !foun()
		appen blan
		repl sgcode with 'CATEGO'
		repl scode with alltr(str(recno()))
		repl sname with mycat.fieldlooku
		repl parnam with sname
		endi
		sele pro
		repl gcode5 with stype.scode
        endi
	endscan
	sele scm
	seek fitm.mastercode
	scan for startdate#0 while itemcode=fitm.mastercode
		sele rate
		appen blank
		repl code with pro.code
		repl edisc2 with day(acmeconvertdate(scm.startdate-36161))
		repl edisc1 with month(acmeconvertdate(scm.startdate-36161))
		repl rcode  with year(acmeconvertdate(scm.startdate-36161))
		repl date with acmeconvertdate(scm.enddate-36161)
		repl deal with val(subs(scm.schemedesc,1,at('+',scm.schemedesc)-1))
		repl free with val(subs(scm.schemedesc,at('+',scm.schemedesc)+1))
	    endsc
	    msalt='' &&&ingredient In Support By Umesh 21/01/2024 
		sele salt
		seek fitm->mastercode		
		scan whil itemcode=fitm->mastercode
		msalt=msalt+subs(alltr(ingredient)+' '+alltr(qtydescrip)+space(40),1,40)        
       endsc
       if !empty(msalt)
       SELE STYPE
       seek 'SALT  '+subs(msalt+space(40),1,40)
       if !found()
          appen blank 
          repl sgcode with 'SALT'
          repl scode with 'SS'+allt(str(recno()))
          repl sname with msalt
          REPL PARNAM WITH MSALT
       endif
       repl pro.gcode3 with stype.scode   
       sele support
       appen blan
       repl type with 'F',aliase with 'PRO',pcode with pro->code,sno with 1,remark with subs(msalt,1,40)+iif(!empty(subs(msalt,41)),subs(msalt,41,40),'') 
       endi
       msalt1=subs(msalt,81)
       if !empty(msalt1)
       appen blan
       repl type with 'F',aliase with 'PRO',pcode with pro->code,sno with 2,remark with subs(msalt1,1,40)+iif(!empty(subs(msalt1,41)),subs(msalt1,41,40),'')   
       endi
       msalt2=subs(msalt1,81)
       if !empty(msalt2)
       appen blan
       repl type with 'F',aliase with 'PRO',pcode with pro->code,sno with 2,remark with subs(msalt2,1,40)+iif(!empty(subs(msalt2,41)),subs(msalt2,41,40),'')   
     endi
     endsca
sele rate
close table all

@rowno,10 say '**** Importing Product Stock/Batch ****' font 'Arial',12
rowno=rowno+1
batch=datatransferpath+'batchtable.'+datatransferext
sele sele(1)
use &datatransferpath\schememst alias sch
index on batchcode to sch
sele sele(1)
use  &batch alias batch
try
alter table &batch add date d(10) 
catch
merror=1
endtry
repl all date with acmeconvertdate(batch.stockindat-36161)
index on itemcode to batch
sele sele(1)
use &datatransferpath\inventorytable  alias batch1
try
  alter table batch1 add date d(10)
  repl all date with acmeconvertdate(batch.stockindat-36161)
catch
merror=1
endtry
try
  repl all date with acmeconvertdate(stockindat-36161)

catch
merror=1
endtry
try
  alter table batch1 add date1 d(10)
catch
merror=1
endtry
try
  repl all date1 with acmeconvertdate(docdate-36161)

catch
merror=1
endtry

index on str(itemcode)+subs(batchno,1,20) to batch1 for documentty=23 and compcode=companycode &&&inlist(documentma,9,20,80)


sele sele(1)
use &datdev\pro.&datext alias pro
index on code to pro
sele sele(1)
use &datdev\probat.&datext alias probat
index on str(code)+batchno to probat

sele sele(1)
use &datdev\support.&datext alias support

sele batch
go top
do while !eof()
	=seek(itemcode,'pro')
	sele probat
	seek str(batch.itemcode)+subs(alltrim(batch.batchdescr)+space(12),1,12)
	if !found()
		appen blank
		repl code with pro.code
		repl name with pro.name
		repl product with pro.product
		repl billname with pro.billname
		repl pack with pro.pack
		repl batchno with batch.batchdescr
		repl packing with pro.packing
		if batch.expirydate#0
		mexp=acmeconvertdate(batch.expirydate-36161)
		repl exp with mexp
		endi
		repl ratea with batch.salesrate
		repl mrp with batch.mrp
		repl pro.ratea with batch.salesrate
		repl pro.mrp with batch.mrp
		repl prate with batch.averagerat
		repl pro.prate with batch.averagerat

	endif

	repl ratea with batch.salesrate
	repl mrp with batch.mrp
	repl pro.ratea with batch.salesrate
	repl pro.mrp with batch.mrp
	repl prate with batch.averagerat
	repl pro.prate with batch.averagerat
	sele batch1
	seek str(batch.itemcode)+subs(probat.batchno+space(20),1,20)
	sum qty1+qty2 to tot while str(itemcode)+batchno=str(batch.itemcode)+subs(probat.batchno+space(20),1,20)
	sele probat
	if old_4='Y' &&and acmeconvertdate(batch.stockindat-36161)<=old_6
		replace opening with opening+(batch.balqty1+batch.balqty2)
		repl balance with balance+(batch.balqty1+batch.balqty2)
		repl o_a with    o_a+(batch.balqty1+batch.balqty2)
		repl b_a with b_a+(batch.balqty1+batch.balqty2)
	else
		repl opening with tot
		repl o_a with tot
		repl balance with balance+(batch.balqty1+batch.balqty2)
		repl b_a     with b_a+(batch.balqty1+batch.balqty2)
	endif
	if seek(batch.creatingin,'sch')
		sele probat
		repl deal with val(subs(sch.schemedesc,1,at('+',sch.schemedesc)-1))
		repl free with val(subs(sch.schemedesc,at('+',sch.schemedesc)+1))
	endif
	sele batch
	skip
enddo

*!*	if old_4#'Y'
*!*		sele batch1
*!*		set filt to documentma=80 &&&AND INLIST(ITEMCODE,12762,12)
*!*		go top
*!*		do while !eof()
*!*			sele batch1
*!*			=seek(itemcode,'pro')
*!*			sele probat
*!*			seek str(batch1.itemcode)+subs(alltrim(batch1.batchno)+space(12),1,12)
*!*			if !found()
*!*				appen blank
*!*				repl code with pro.code
*!*				repl name with pro.name
*!*				repl product with pro.product
*!*				repl billname with pro.billname
*!*				repl pack with pro.pack
*!*				repl batchno with batch1.batchno
*!*				repl packing with  pro.packing
*!*				mexp=acmeconvertdate(batch1.expirydate-36161)
*!*				repl exp with mexp
*!*				repl ratea with batch1.salesrate
*!*				repl mrp with batch1.mrp
*!*				repl pro.ratea with batch1.salesrate
*!*				repl pro.mrp with batch1.mrp

*!*	*			DISP MEXP,RATEA,MRP NOWAI
*!*	*			repl balance with balance+mbalance
*!*	*			repl B_a with    b_a+mbalance
*!*			endif
*!*			replace opening with opening+(batch1.qty1+batch1.qty2)
*!*	*!*			repl balance with balance+mbalance
*!*			repl o_a with    o_a+(batch1.qty1+batch1.qty2)
*!*	*!*			repl B_a with    b_a+mbalance
*!*			mexp=acmeconvertdate(batch1.expirydate-36161)

*!*			repl exp with mexp
*!*			repl ratea with batch1.salesrate
*!*			repl mrp with batch1.mrp

*!*			repl date with old_5-1
*!*			sele batch1
*!*			skip
*!*		enddo
*!*	endif
sele probat
scan
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-BT",pcode with probat.code,heading with probat.batchno,value with probat.balance
endscan
sele pro
scan
	sele probat
	seek str(pro.code)
	sum balance to tot while code=pro.code
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-IT",pcode with pro.code,value with tot
endscan
*!*	SELE SELE(1)
*!*	  use &datatransferpath\historyinventorytable alias his
*!*	sele his
*!*	scan
*!*	 if seek(str(itemcode)+subs(batchno,1,12),'probat')
*!*	    repl probat.mrp with his.mrp
*!*	*    repl probat.ratea with his.ratea
*!*	endif
*!*	endscan

close table all

if softtype='R'
	@rowno,10 say '**** Importing Patients ****' font 'Arial',12
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\primemasters alias fact
	set filt to compcode=companycode
	sele sele(1)
	use &datatransferpath\primemasterdetails alias fdet
	pack
	index on str(mastertype)+str(mastercode) to fdet for compcode=companycode

	sele sele(1)
	use &datdev\maorder.&datext alias mord

sele fact
scan for inlist(mastertype,7) &&&&and mastercode=2404 &&&,7) &&&&AND MASTERCODE=11721
	mmastercode=mastercode
	regunregcomposite=''
	SELE mord  
	appen blank 
	repl scode with  'PET#$~'
	repl form with allt(str(fact.mastercode)) 
	repl parnam with fact.descriptio 
	sele fdet
	seek str(fact.mastertype)+str(fact.mastercode)
	do while str(mastertype)+str(mastercode)=str(fact.mastertype)+str(fact.mastercode)
	    if fieldno=40
	       repl mord.city with fdet.fieldvalue 
	    endif
        skip 
    enddo     	       
endscan
    
	close table all


	@rowno,10 say '**** Importing Doctors ****' font 'Arial',12
	rowno=rowno+1

	sele sele(1)
	use &datatransferpath\primemasters alias fact
	set filt to compcode=companycode
	sele sele(1)
	use &datatransferpath\primemasterdetails alias fdet
	pack
	index on str(mastertype)+str(mastercode) to fdet for compcode=companycode

	sele sele(1)
	use &datdev\maorder.&datext alias mord


sele fact
	scan for mastertype=24 or mastertype=117 or 'DR '$upper(descriptio) or 'DR.'$upper(descriptio)
	mmastercode=mastercode
	regunregcomposite=''
	SELE mord  
	appen blank 
	repl scode with 'PRE#$~'
	repl form with allt(str(fact.mastercode)) 
	repl parnam with fact.descriptio 
	sele fdet
	seek str(fact.mastertype)+str(fact.mastercode)
	do while str(mastertype)+str(mastercode)=str(fact.mastertype)+str(fact.mastercode)
	    if fieldno=40
	       repl mord.city with fdet.fieldvalue 
	    endif
        skip 
    enddo     	       
endscan
close table all
endi

@rowno,10 say '**** Importing Account Masters ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\primemasters alias fact
set filt to compcode=companycode
COPY TO FACT1
sele sele(1)
use fact1 alias fact1
index on upper(subs(descriptio,1,50)) to fact1 for mastertype=7

sele sele(1)
use &datatransferpath\primemasterdetails alias fdet
pack
index on str(mastertype)+str(mastercode) to fdet for compcode=companycode
copy to det_dlno
sele sele(1) &&&updated By Umesh 23/01/2024
sele * from fdet into curs myarea readw where fieldno=490 and compcode=companycode and !empty(fieldlooku) 
inde on mastercode to myarea

sele sele(1)
sele * from fdet into curs myrt readw where fieldno=120 and compcode=companycode and !empty(fieldlooku)
inde on mastercode to myrt

sele sele(1)
use det_dlno alias det_dlno
index on str(mastertype)+str(fieldno)+str(val(fieldvalue)) to det_dlno  for mastertype=7 and fieldno=30 and compcode=companycode
sele sele(1)
use &datatransferpath\accountstable alias bal
index on accountcod to bal for compcode=companycode
sele sele(1)
use &datatransferpath\secondarymasters alias det1
index on str(mastertype)+str(mastercode) to det1  for compcode=companycode
sele sele(1)
use &datdev\order.&datext alias mact
index on fax2 to mact
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase+lcode to support
sele sele(1) &&By umesh 230124
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm

sele fact
scan for inlist(mastertype,6) &&&&and mastercode=2262 &&&,7) &&&&AND MASTERCODE=11721
    mroutemastercode=0
    sele fact1
    seek subs(fact.descriptio,1,50)
    if found()
      mroutemastercode=mastercode
    endif
    sele fact  
	mmastercode=mastercode
	regunregcomposite=''
	sele mact
	appen blank
	repl ordno with alltrim(str(fact.mastercode))
	repl parnam with fact.descriptio
	mdlno=''
	mgstno=''
	mybalcode=0
	memail=''
	mdlcode=0
	sele fdet
	seek str(fact.mastertype)+str(fact.mastercode)
	do while str(mastertype)+str(mastercode)=str(fact.mastertype)+str(fact.mastercode)
		do case
		case fieldno=10
			repl mact.mailnam with fdet.fieldvalue
		case fieldno=30
			repl mact.fax2 with alltrim(fdet.fieldvalue)
			sele det_dlno
			seek str(7)+str(30)+str(val(mact.fax2))
			if found()
				mdlcode=mastercode
			endif
			sele fdet

		case fieldno=690
			regunregcomposite=upper(fieldvalue)
		case fieldno=680
			repl mact.gsthed with 'GST No.:'
			repl mact.gstno with fdet.fieldvalue
			mgstno=fdet.fieldvalue
		case fieldno=50
			repl mact.paradd with fdet.fieldvalue
		case fieldno=70
			=seek(str(16)+str(val(alltrim(fieldvalue))),'det1')
			repl mact.paradd1 with fdet.fieldlooku
		case fieldno=80
			repl mact.paradd2 with alltrim(fdet.fieldvalue)
		case fieldno=100
			repl mact.itno with fdet.fieldvalue
		case fieldno=170
			repl mact.phone1 with fdet.fieldvalue
		case fieldno=360
			repl mact.phone4 with fdet.fieldvalue
		case fieldno=450
			memail=allt(fdet.fieldvalue)
		case fieldno=40   &&&& account group
			mygroup=fdet.fieldvalue
			wacctgroup=''
			wgroupcode=''
			parentgrup=''
			wcurrentaccount=alltrim(upper(fdet.fieldlooku))
			do case
			case 'BRANCH'$wcurrentaccount or 'DIVISION'$wcurrentaccount
				wgroupcode='A '
			case 'CAPITAL'$wcurrentaccount and ('A/C'$wcurrentaccount or 'ACCOUNT'$wcurrentaccount)
				wgroupcode='B '
			case 'RESERVE'$wcurrentaccount and 'SURPLUS'$wcurrentaccount
				wgroupcode='B '
			case 'CURRENT ASSET'$wcurrentaccount
				wgroupcode='C '
			case 'FIXED'$wcurrentaccount and 'ASSET'$wcurrentaccount
				wgroupcode='E '
			case 'INVESTMENT'$wcurrentaccount
				wgroupcode='F   '
			case 'CURRENT LIABILIT'$wcurrentaccount
				wgroupcode='D '
			case ('DUTY'$wcurrentaccount or 'DUTIES'$wcurrentaccount) and 'TAXES'$wcurrentaccount
				wgroupcode='D '
			case 'SALES TAX'$wcurrentaccount and 'CENTRAL'$wcurrentaccount
				wgroupcode='D11'
			case 'SALES TAX'$wcurrentaccount and 'LOCAL'$wcurrentaccount
				wgroupcode='D12 '
			case 'PROVISIONS'$wcurrentaccount
				wgroupcode='D  '
			case 'LOAN' $wcurrentaccount and 'LIABILITY' $wcurrentaccount
				wgroupcode='G   '
			case 'MISC. EXPENSES' $wcurrentaccount and 'ASSET'$wcurrentaccount
				wgroupcode='H   '
			case 'PROFIT & LOSS A/C'$wcurrentaccount
				wgroupcode='I   '
			case 'REVENUE'$wcurrentaccount
				wgroupcode='J   '
			case 'SUNDRY CREDITOR'$wcurrentaccount
				wgroupcode='D31 '
			case 'SUPPLIER'$wcurrentaccount
				wgroupcode='D31 '
			case 'SUNDRY DEBTOR'$wcurrentaccount or fdet.mastertype=7 or mygroup='17'
				wgroupcode='C6 '
			case 'DEPOSITS'$wcurrentaccount
				wgroupcode='C3 '
			case 'INVESTMENT'$wcurrentaccount
				wgroupcode='F '
			case "BANK"$wcurrentaccount and 'ACCOU'$wcurrentaccount and !('ODD'$wcurrentaccount) and !('OCC'$wcurrentaccount)
				wgroupcode='C1   '
			case "CASH"$wcurrentaccount and 'IN'$wcurrentaccount and 'HAND'$wcurrentaccount
				wgroupcode='C2   '
				wgroupcode='C2   '
				parentgrup='C '
			case "STOCK" $ wcurrentaccount and ('CURRENT'$wcurrentaccount or 'IN-HAND'$wcurrentaccount or 'IN HAND'$wcurrentaccount)
				wacctgroup='C5 '
				wgroupcode='C   '
				parentgrup='C '
			case "BANK OD A/C" $wcurrentaccount or "BANK OCC A/C" $wcurrentaccount
				wgroupcode="G1 "
			case "LOAN" $wcurrentaccount and "ADVANCE" $wcurrentaccount
				wgroupcode="C4  "
			case "SECURED LOAN" $wcurrentaccount
				wgroupcode="G2  "
			case "UNSECURED LOAN" $wcurrentaccount
				wgroupcode="G3  "
			case "DIRECT" $wcurrentaccount and !("INDIRECT"$wcurrentaccount)
				if "INCOME"$wcurrentaccount
					wgroupcode="J3 "
				endif
				if "EXPENSE" $wcurrentaccount
					wacctgroup='J11 '
					wgroupcode="J1  "
					parentgrup='J1 '
				endif
			case "INDIRECT" $wcurrentaccount
				if "INCOME" $wcurrentaccount
					wgroupcode="J4 "
				endif
				if "EXPENSE" $wcurrentaccount
					wgroupcode="J12  "
				endif
			case 'SALE'$wcurrentaccount
				if "CENTRAL"$wcurrentaccount or "CST"$wcurrentaccount
					wgroupcode='J61  '
				else
					wgroupcode='J62  '
				endif
			case 'PURCHASE'$wcurrentaccount
				if "CENTRAL"$wcurrentaccount or "CST"$wcurrentaccount
					wgroupcode="J51  "
				else
					wgroupcode="J52  "
				endif
			otherwise
			endcase
			repl mact.scode with wgroupcode
			sele fdet
		endcase
		sele fdet
		skip
	enddo
	mdlno1=''
	mdlno2=''
	sele fdet
	seek str(7)+str(mdlcode)
	loca for fieldno=180   while str(mastertype)+str(mastercode)=str(7)+str(mdlcode)
	if found()
		mdlno1=allt(fieldvalue)
	endif
	sele fdet
	seek str(7)+str(mdlcode)
	loca for fieldno=190   while str(mastertype)+str(mastercode)=str(7)+str(mdlcode)
	if found()
		mdlno2=allt(fieldvalue)
	endif
	repl mact.dlno with mdlno1+' '+mdlno2
	sele support
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	mopening=0
	mclosing=0

&&&&&&Opening & Closing
	mmastercode  =fact.mastercode  &&creditdays  and discount
*!*	   sele fdet
*!*	   seek STR(7)+str(FACT.MASTERCODE)
*!*	   loca for fieldno=160 while str(MASTERTYPE)+str(mastercode)=str(7)+str(fact.mastercode)
*!*	   if found()
*!*	*     mmastercode=VAL(FIELDVALUE)  &&&mastercode
*!*	   endif
*!*	   MEMAILID=''
	mrout=''
*!*	   mgstno=''
*!*	   SELE FDET
*!*	   seek str(6)+str(mmastercode)
*!*	   scan while str(mastertype)+str(mastercode)=str(7)+str(mmastercode)
*!*	      if fieldno=110
*!*	        sele mact
*!*	        repl duedays with val(alltrim(fdet.fieldvalue))
*!*	      else
*!*	        if fieldno=140
*!*	           sele mact
*!*	           repl disc1 with   val(alltrim(fdet.fieldvalue))
*!*	        ELSE
*!*	          if fieldno=140
*!*	          		memailid=alltrim(fieldvalue)
*!*	          else
*!*	            if fieldno=120
*!*	               mrout=alltrim(fieldvalue)
*!*	            else
*!*	               if fieldno=520
*!*	                  mgstno=alltrim(fieldvalue)
*!*	               endif
*!*	            endif
*!*	          endif
*!*	        endif
*!*	      endif
*!*	   endscan
***Area Transfer***
if seek(fdet->mastercode,'myarea')
	sele mpcm
	seek 'AREA  '+subs(myarea->fieldlooku+spac(40),1,40)
	if !foun()
	appen blan
	repl sgcode with 'AREA'
	repl scode with alltr(str(recno()))
	repl sname with myarea->fieldlooku
	repl parnam with sname
	endi
	repl mact->area with mpcm->scode
endi
*** Route Transfer ***
*if seek(fdet->mastercode,'myrt')
sele myrt
seek mroutemastercode
*!*	?found(),mroutemastercode
*!*	wait
sele mpcm
seek 'ROUT  '+subs(myrt->fieldlooku+spac(40),1,40)
if !foun()
appen blan
repl sgcode with 'ROUT'
repl scode with 'R'+alltr(str(recno()))
repl sname with myrt->fieldlooku
repl parnam with myrt->fieldlooku
endi
repl mact->rout with mpcm->scode
*endi
	sele support
	append blank
	repl aliase with 'ORDER   ',type with 'F',lcode with mact.ordno,sno with 12
	repl heading with substr(heading,1,21)+iif(regunregcomposite='COMPOSIT','CG',iif(empty(mact.gstno),'UG','NG'))
	repl remark with memail
	mopening=0
	mclosing=0
	sele bal
	seek mmastercode  &&&fact.mastercode
	scan for cancelflag#2 while accountcod=mmastercode &&&&fact.mastercode  &&&&and acmeconvertdate(docdate)<=old_6
		xdate=acmeconvertdate(docdate-36161)
		if documentty=22
			mopening=mopening+amount
		endif
		mclosing=mclosing+amount
	endscan
	sele mact
	repl rate with old_3
	repl opning with iif(old_4='Y',mclosing,mopening)
	repl balance  with mclosing
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with mact.balance
endsc
close table all

if old_3='Y'
	@rowno,10 say '**** Importing Outstanding ****' font 'Arial',12
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\referencemaintable alias fout
	set filt to compcode=companycode
	sele sele(1)
	use &datatransferpath\documentmaintable alias sal
	index on owncode to sal  for compcode=companycode
	sele sele(1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele sele(1)
	use &datdev\pendings.&datext alias pend
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	mvoucher=voucher+5
	msvoucher=svoucher+4

	sele fout
	if old_4='N'
		set filt to acmeconvertdate(docdate-36161)<old_5 &&and accountcod=324
	endif


	sele fout
	go top
	scan
		=seek(subs(alltrim(str(accountcod))+space(06),1,6),'ord')
		mvoucher=mvoucher+5
		msvoucher=msvoucher+4
		mvcn=''
		sele sal
		seek fout.documentow
		if softtype#'R'
			mvcn=subs(fout.docno,1,20)
		else
			mvcn=sal.sourcedocu
		endif
		sele pend
		appen blank
		repl voucher with mvoucher
		repl svoucher with msvoucher
		repl vcn with mvcn
		repl ord  with alltrim(str(fout.accountcod))
		repl ddate with acmeconvertdate(fout.docdate-36161)
		if old_4='N' &&&acmeconvertdate(docdate-36161)<OLD_5
			repl final with iif(fout.crdr='D',fout.amount,-fout.amount)
			repl balance with final
		else
			repl final with iif(fout.crdr='D',fout.amount,-fout.amount)
			repl balance with iif(fout.crdr='D',fout.balanceamo,-fout.balanceamo)
			repl itemope with final-balance
		endif
		repl duedate with acmeconvertdate(fout.duedate-36161)
		repl invtype with 'O'
		repl acgroup with ord.scode
	endscan
	sele mslip
	repl voucher with mvoucher
	repl svoucher with msvoucher

endif

if old_4='N'
	do import_transactions
endif
do acme_history
close table all


proc import_transactions

@rowno,10 say '**** Importing Inventory Transactions ****' font 'Arial',12
rowno=rowno+1

close table all
sele sele(1)
select mastertype,mastercode,descriptio,compcode from &datatransferpath\primemasters into curs master1 where mastertype=6  and compcode=companycode
index on subs(descriptio,50) to master1
sele sele(1)
select mastertype,mastercode,descriptio from &datatransferpath\primemasters into curs master2 where mastertype=7  and compcode=companycode
index on mastercode to master2


sele sele(1)
use &datatransferpath\primemasterdetails alias mast
set filt to compcode=companycode
index on mastercode to mast

sele sele(1)
use &datatransferpath\documentmaintable alias sal
set filt to compcode=companycode
index on str(documentma)+str(docno) to sal
sele sele(1)
use &datatransferpath\inventorytable alia sld
set filt to compcode=companycode
index on documentow to sld
sele sele(1)
use &datatransferpath\accountstable alias act
set filt to compcode=companycode
index on documentow to act for compcode=companycode
sele sele(1)
use  &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datdev\pro.&datext alias pro
index on code to pro
sele sele(1)
use &datdev\probat.&datext alias probat
index on str(code)+batchno  to probat
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
mvoucher=voucher+10
msvoucher=svoucher+10
sele sele(1)
use &datdev\subdis.&datext alias subdis
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord

SELE SELE(1)
USE &datdev\maorder.&datext alias maord
index on scode+form to maord  

*!*	1=SALES
*!*	3-SALES RETURN (A/C)
*!*	75-SALES RETURN CHALLAN
*!*	30-ACCOUNT C/N
*!*	31-ACCOUNT D/N
*!*	7-PURCHASE
*!*	4=PURCHASE RETURN   (A/C)
*!*	71=MPB IMPORT PURCHAASE
*!*	77-PRETURN CHALLAN
*!*	78-PURCHASE RETURN

sele sal
*!*	SET FILT TO series='I' and docno=675
*!*	brow
scan for inlist(documentty,2,4,16,28,39,51,53) or inlist(documentma,1,20,3,6,75,7,4,71,77,78,130,50,40,66,22,130,40,3586,3587)
	if cancelflag=2
		loop
	endif
	if documentma=78   &&& purchase return challan
		loop
	endif
	if documentma=77 and sourcechal="SKIPTHIS"
		loop
	endif
*!*	  ?acmeconvertdate(challandat-36161),SERIES,DOCNO
	if  (challandat=0 and (acmeconvertdate(docdate-36161)<old_5 or acmeconvertdate(docdate-36161)>old_6)) or ;
			(challandat>0 and (acmeconvertdate(challandat-36161)<old_5 or acmeconvertdate(challandat-36161)>old_6))
		loop
	endif
	mvcn=alltrim(sal.series)+'-'+alltrim(str(sal.docno))&&repl('0',7-len(alltrim(str(sal.docno))))+alltrim(str(sal.docno))
	mmastercode=sal.personcode
	if inlist(sal.documentma,1,3,75,66,3586,40,3587)  or sal.documentty=4 or sal.documentty=28
		sele mast
		seek sal.personcode
		loca for mastertype=7 and fieldno=160 while mastercode=sal.personcode
		if found()
			mmastercode=val(alltrim(fieldvalue))
		endif
	endif
	mvoucher=mvoucher+5
	sele mdis
	appen blank
	repl voucher with mvoucher
*!*	   repl codep with ''
	sele act
	seek sal.owncode
	loca for accountcod=1 while documentow=sal.owncode

	iscash=iif(found(),1,0)
	sele mdis

	repl mdis.codep with alltrim(str(mmastercode))
	repl account with 'N'
	repl godwon with 'A'
	repl discafter with 'N'

	mvoutype=sal.documentma
	sele mdis
	do case
	case inlist(mvoutype,1,66,40,3587,3586)  or  sal.documentty=4 &&&=1 or mvoutype=66
		repl type with 'S'
		repl ltype with scalc
		repl vcn with alltrim(sal.series)+'-'+alltrim(str(sal.docno))
		repl date with acmeconvertdate(sal.docdate-36161)
		=seek('PET#$~'+subs(allt(str(sal.personcode))+space(10),1,10),'maord')
		repl docu with maord.form+maord.parnam
		repl docu1 with allt(str(sal.referencec))
	case mvoutype=3  or mvoutype=75 or  mvoutype=40  or sal.documentty=28
		if mvoutype=3 or mvoutype=40  or sal.documentty=28
			if sal.challandat#0
				repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
				repl chdate with acmeconvertdate(sal.docdate-36161)
				repl type with 'R'
			else
				repl vcn with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
				repl date with acmeconvertdate(sal.docdate-36161)
				repl type with 'R'
			endif
			repl ltype with scalc
		endif
		if sal.documentty=28
*		    repl type with 'W'
		endif
		repl ltype with  scalc
	case sal.documentty=39 or sal.documentty=2 &&&mvoutype=7 or mvoutype=4 OR MVOUTYPE=71 OR MVOUTYPE=20 or mvoutype=22 or inlist(sal.documentty,2,39)
		if sal.challanno#0
			repl challan with mvcn    &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
			repl chdate with acmeconvertdate(sal.challandat-36161)

		else
			repl vcn with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
			repl date with acmeconvertdate(sal.challandat-36161)

		endif
		repl pm with sal.sourcedocu
		repl lrda with acmeconvertdate(sal.docdate-36161)
		repl ltype with pcalc
		repl type with iif(sal.documentty=39,'B','P')
		repl godwon with 'A' &&&IIF(TYPE='Q','Y','A')
	case mvoutype=77 or mvoutype=78
		repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
		repl chdate with acmeconvertdate(sal.docdate-36161)
		repl ltype with  scalc
		repl type with 'B'
	case mvoutype=6
		repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
		repl chdate with acmeconvertdate(sal.docdate-36161)
		repl ltype with  scalc
		repl type with 'L'
		repl codep with 'STACex'
	case mvoutype=50
		repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
		repl chdate with acmeconvertdate(sal.docdate-36161)
		repl ltype with  scalc
		repl type with 'B'
	case SAL.DOCUMENTTY=51
		repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
		repl chdate with acmeconvertdate(sal.docdate-36161)
		repl type with 'L'
		repl ltype with  scalc
        repl codep with 'STACAC'
	endcase
	repl sale with iif(mdis.type='P' and softtype='R','zYNYNPAYUN1N','Z')
	
	if mdis.type$'RW' and sal.refdocownc#0 &&&sal.salesrefer='Y'
		repl cash with 0 &&&sal.netamount
		repl final with 0

	else
		if iscash=1
			repl cash with sal.netamount
			repl final with 0
		else
			repl final with sal.netamount
			repl cash with 0
		endif
		if between(sal.roundoff,-0.99,0.99)
			repl round with sal.roundoff
		else
		endi
        if sal.memotype='2 '  &&&umesh 29012024
	    repl final with sal.netamount
		repl cash with 0
		else
		repl final with 0
		repl cash with sal.netamount
		endi
			
       	if final=0 .and. cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif

		isigst=0
		if sal.igstamt#0
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
			isigst=1
		endif

		sele support
		appen blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	endif
	sele mdis
	if mdis.type='R'
		repl other with other+sal.addlessamo
	endif
	=seek(mdis.codep,'ord')
IF SAL.TCS#0	
	sele subdis
	appen blan
	repl codep with mdis.codep
	repl vcn with mdis.vcn
	repl date with mdis.date
	repl voucher with mdis.voucher
	repl type with '9'
	repl dsm with 'RETTCS'
	repl rtqt with str(sal.tcs,10,2)+' '+iif(len(alltrim(ord.itno))#0,'0.075','0.100')
ENDIF
	mybilldiscount=0
	mother=0
	sele sld
	seek sal.owncode
	scan while documentow=sal.owncode
		=seek(itemcode,'pro')
		sele dis
		appen blank
		repl voucher with mdis.voucher
		repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date)
		repl vcn with iif(day(mdis.date)=0,mdis.challan,mdis.vcn)
		repl codep with mdis.codep
		repl code with sld.itemcode
		repl qty with sld.qty1
		repl free with sld.qty2
		repl pack with pro.pack
		repl rate with iif(sal.documentma=6,sld.salesrate,sld.rate)
		if sld.expirydate#0
		repl exp  with acmeconvertdate(sld.expirydate-36161)
		endi
		repl disc1 with sld.bottomdisc
		if mdis.type='P'
			repl rate with round(sld.amount/sld.qty1,2)
		endif
		if mdis.type$'R'
*   repl svdis with -sld.addlessamo
		else
			repl svdis with -sld.addoncharg
		    repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,45)
			
		endif
		IF SLD.bottomdisc=0 and sld.discount#0 
		   repl svdis1 with sld.discount 
		   REPL misc4 with subs(misc4,1,44)+'L'+subs(misc4,46)
		endif   
		repl batch with alltrim(sld.batchno)
		repl mrp with sld.mrp
		if sal.documentma=3 and sal.reversetax='Y'
		else
			if sld.cgstamt+sld.sgstamt+sld.igstamt#0
				if sld.igstper>0
					repl ssta with sld.igstper
				else
					repl ssta with sld.sgstper
					repl cgst with sld.cgstper
				endif
			endif
		endif
		repl svdis1 with svdis1+abs(sld.othercharg)
*!*	    repl svdis1 with -sld.othercharg+SLD.DISCOUNT
*!*	    repl misc4 with subs(misc4,1,44)+'L'+subs(misc4,46)
		repl flg with iif(mdis.type='S','G',mdis.type)
		repl godwon with 'A'
		repl tax with 'T'
		if sld.affectssto='N'
			if mdis.type$'RDP'
				repl flg with 'W'
				repl godwon with 'Y'
			else
				if mdis.type$'SBL'
					repl flg with 'Q'
					repl godwon with 'Y'
				endif
			endif
		endif
		if sal.documentma=6
			repl flg with iif(sld.howitaffec='S','L','D')
		endif
		if mdis.type#'R'
			if sal.addlessamo<0
				mybilldiscount=mybilldiscount+(abs(sld.addlessamo)-abs(sld.addoncharg))
			else
				mother=mother+abs(sld.addlessamo)
			endif
		endif
		if mdis.type='P' and sal.addlessamo<0
			repl svdis with abs(sld.addlessamo)
			repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,44)
		endif
		if mdis.type#'R'
			mybilldiscount=mybilldiscount   &&&&-sld.othercharg
		endif

		if sld.amount=0
			repl free with sld.qty1+sld.qty2
			repl qty with 0
		endif
		if sal.documentty=4
			repl supplied with 'R'
		endif
		if sal.documentma=7 and seek(str(sld.itemcode)+subs(sld.batchno+space(12),1,12),'PROBAT')
			repl probat.deal with sld.qty1,probat.free with sld.qty2
			repl probat.supcode with mdis.codep
			repl probat.supinvo with mdis.pm
			repl probat.supdat with mdis.lrda
		endif
		if dis.flg$'P' and seek(str(dis.code)+dis.batch,'probat')
			repl probat.supinvo with mdis.pm
			repl probat.supdat with mdis.lrda
			repl probat.supcode with mdis.codep
		endif
		sele dis
		if mdis.type$'WR' and sal.refdocownc#0 &&&sal.salesrefer='Y'
			repl free  with free+qty
			repl qty with 0
		endif
		if sld.amount=sld.taxableamo and mdis.type='P' and sld.amount#0
			repl mdis.ltype with '8'
		endif
        If sal.documentty=51
           repl qty with abs(qty)
           repl free with abs(free)
           repl flg with iif(sld.howitaffec='S','L','D')
        endif   
	endscan
	sele mdis
	if mdis.type='P' and sal.addlessamo>0 &&&&AND MOTHER=0
		repl other with  sal.addlessamo &&&&OTHER-mybilldiscount
	endif
	if mdis.type$'S'
		repl other with -mybilldiscount+mother
	endif
endscan
sele mslip
repl voucher with mvoucher,svoucher with msvoucher
slast5=msvoucher+10
close table all

@rowno,10 say '**** Importing Account ( From Sales ) ****' font 'Arial',12
rowno=rowno+1
af     =datdev + '\gledger.'+datext
pend   =datdev + '\pend.'+datext
mdis   =datdev + '\mdis.'+datext
pending=datdev + '\pendings.'+datext
sele g
use &pending alias pending
sele f
use &pend alias pend excl
zap
sele b
use &af alias gledger excl
zap
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord
sele d
use &mdis alias mdis
go top
do while .not. eof()
	=seek(mdis.codep,'ord')
	sele d
	if vcn=space(12)
		skip
		loop
	endif
	last1=mdis.codep
	if mdis.final#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		if d.type='P'
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
		repl gcode with ord.scode
**** for outstanding
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
			repl acgroup with ord.scode
		endif
	endif
	if mdis.cash#0
		sele b
		appe blank
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
	sele gledger
	sele d
	skip
enddo
sele gledger
close table all


@rowno,10 say '**** Importing Account Transactions Receipts/Payments****' font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\referenceadjustmenttable alias ref
index on acctraownc to ref
sele sele(1)
use &datatransferpath\referencemaintable alias outs
index on owncode to outs
sele sele(1)
use &datatransferpath\documentmaintable alias sal
index on owncode to sal  for compcode=companycode

sele sele(1)
use &datatransferpath\accountstable alias led
index on documentow to led   for compcode=companycode        &&&&and accounting#0

sele sele(1)
use &datatransferpath\primemasterdetails alias mst
index on mastercode to mst for mastertype=6

sele sele(1)
use &datatransferpath\primemasters alias mstmain
index on mastercode to mstmain for mastertype=6  and compcode=companycode

sele sele(1)
use &datdev\gledger.&datext alias gle
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
mvoucher=voucher+10

sele sele(1)
use &datdev\order.&datext alias ord
index on parnam tag pnam of ord
index on fax2 tag pcode  of ord

sele sele(1)
use &datdev\pendings.&datext alias pendings
index on ord+vcn to pendings
sele sele(1)
use &datdev\pend.&datext alias pend

sele led

set filter to INLIST(SUBS(VOUCHERNO,1,2),'CR','CP','BR','BP','JV','CE')
*!*	BROW FOR ACCOUNTCOD=2945


mdocno=9999999999999999999
go top
do while !eof()
	if cancelflag=2
		skip
		loop
	endif
	if  acmeconvertdate(led.docdate-36161)<old_5 or acmeconvertdate(led.docdate-36161)>old_6
		skip
		loop
	endif
	if documentow#mdocno
		mdocno=documentow
		mvoucher=mvoucher+5
	endif
	do while documentow=mdocno and !eof()
		sele gle
		appen blank
		repl voucher with mvoucher
		repl date with acmeconvertdate(led.docdate-36161)
		repl code with alltrim(str(led.accountcod))
		if led.amount>0
			repl debit with led.amount
			repl cd with  'D'
		else
			repl credit with abs(led.amount)
			repl cd with  'C'
		endif
		DO CASE
		   case inlist(subs(led.voucherno,1,2),'CR','BR')
		     repl book with 'R'
		   case inlist(subs(led.voucherno,1,2),'CP','BP','CE')
		     repl book with 'P'
           case subs(led.voucherno,1,2)='JV'
             repl book with 'J'
       endcase      
*!*			if inlist(led.documentma,23,26,29,170,180) or inlist(LED.documentty,18)
*!*				repl book with 'R'
*!*			else
*!*				if inlist(led.documentma,24,25,190,200)
*!*					repl book with 'P'
*!*				else
*!*					if led.documentma=27 or led.documentma=210
*!*						repl book with  'J'
*!*					else
*!*						if led.documentma=30 or led.documentma=130
*!*							repl book with 'E'
*!*						else
*!*							if led.documentma=31
*!*								repl  book with 'D'
*!*							endif
*!*						endif
*!*					endif
*!*				endif
*!*			endif
		repl vcsno with led.voucherno
		repl  remark1 with led.narration
		if old_3='Y'
			if  inlist(led.documentma,23,26,29,13) and led.amount<0
				sele ref
				seek led.owncode
				scan while acctraownc=led.owncode
					sele outs
					seek ref.referencem
					if found()
						if acmeconvertdate(docdate-36161)<old_5
							mvcn=subs(docno+space(20),1,20)
						else
							sele sal
							seek outs.documentow
							mvcn=allt(series)+'-'+allt(str(docno))  &&subs(docno+space(20),1,20)
							mvcn=subs(mvcn+space(20),1,20)
						endif
						sele pendings
						seek subs(alltrim(str(led.accountcod))+space(06),1,6)+subs(mvcn+space(20),1,20)
*!*	                 ?mvcn,FOUND()
*!*	                 WAIT
						if found()

							sele pend
							appe blank
							repl voucher with mvoucher
							repl ord with alltrim(str(led.accountcod))
							repl ddate with acmeconvertdate(led.docdate-36161)
							repl vcn with mvcn
							if ref.crdr='D'
								repl final with -ref.amount
							else
								repl final with ref.amount
							endif
							repl type with 'A'
							repl adjvoucher with pendings.voucher
							repl svoucher with pendings.svoucher
						endif
					endif
				endscan
*!*	   SELECT ACCOUNTSTABLE
*!*	   SEEK OWNCODE IN REFERENCEADJUSTMENT(ACCTRAOWC)
*!*	   SELE REFERENCEMAINTABLE
*!*	   SEEK REFERENCEADJUSTMENTTABLE.REFERENCEM(REFERENCEMAINTABLE.OWNCODE)
*!*	   REFERENCEMAINTABLE=DOCUMENTOW=DOCUMENTMAINTABLE.OWNCODE
			endif
		endif
		sele led
		skip
	enddo
enddo
sele mslip
repl voucher with mvoucher
close table all

function acmeconvertdate(acmedatenumber)
return {^1899/12/30} + acmedatenumber
*!*
*!*	* Convert Excel serial number to a datetime
function acmedatenumber2datetime(acmedatenumber)
return dtot({^1899/12/30} + int(acmedatenumber)) + ;
	round(24*60*60 * (acmedatenumber % 1),0)

* Convert Excel serial number to a time string
function acmedatenumber2time(acmedatenumber)
return substr(ttoc({^2000/01/10 00:00:00} + round(24*60*60 * (acmedatenumber % 1),0),3), 12)


proc tf_acmeout
*!*	BOF : TFACME.PRG .....Author Santosh Srivastava
*****Last Change By Santosh K Srivastava       Dated    : 04/01/2018
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
set talk off
set date to brit
set cent on
set dele on
set safe off
set cpdi off
set color to
clear
close table all
@04,10 say 'Old Data From        :' font 'Courier',18 get datatransferpath     font 'Courier',18
@05,10 say 'Old Data Extension   :' font 'Courier',18 get datatransferext     font 'Courier',18
@06,10 say 'Type Sure            :' font 'Courier',18 get sure      pict  '@X!' font 'Courier',18
read
datatransferpath=alltrim(datatransferpath)
datatransferext=alltrim(datatransferext)
datdev= alltrim ( datdev  )
datext= alltrim ( datext )
if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
=starttransfer()

rowno=5
@02,22 say 'Please Wait Importing ACME Data To Marg.....' font 'Arial',14 colo 'W+/G'
set colo to

@rowno,10 say '**** Importing Outstanding ****' font 'Arial',12
rowno=rowno+1

af=datdev + '\pendings.'+datext
bf=datdev + '\slipno.'+datext
cf=datatransferpath + 'btemp.'+datatransferext

sele a
use &datdev\pendings.&datext  alias mpend  excl
index on ord to mpend

sele sele(1)
select * from mpend into curs difference where 1=2 readwri
index on acgroup+remark to difference
sele b
use &datdev\slipno.&datext  alias mslip

sele sele(1)
use &datatransferpath\documentmaintable alias sal
index on owncode to sal


sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord
sele c
use &datatransferpath\referencemaintable   alias fout

if old_3='Y'
	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10
	sele fout
	set filt to balanceamo#0
	go top
	do while .not. eof()
		=seek(documentow,'sal')
		mvcn=alltrim(sal.series)+'-'+repl('0',7-len(alltrim(str(sal.docno))))+alltrim(str(sal.docno))
		dt  = acmeconvertdate(docdate-36161)
		dt1 = acmeconvertdate(duedate-36161)
		sele mpend
		appe blank
		replace mpend.ord       with   alltrim(str(fout.accountcod))
		replace mpend.ddate     with   dt
		replace mpend.invtype   with   "O"
		replace mpend.vcn       with   mvcn
		replace mpend.voucher   with   vou
		if fout.crdr='D'
			replace mpend.final     with   sal.netamount &&fout.pbat,-fout.pbat)
			replace mpend.balance   with   fout.balanceamo
		else
			replace mpend.final     with   -sal.netamount &&fout.pbat,-fout.pbat)
			replace mpend.balance   with   -fout.balanceamo
		endif
		replace mpend.duedate   with   dt1
		replace mpend.acgroup   with   ord.scode
		replace mpend.svoucher  with   svou
		replace mpend.name      with   vcn
		vou=vou+5
		svou=svou+5
		sele fout
		skip
	enddo
	sele mpend
	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5
endif



proc acme_history
close data

@rowno,10 say '**** Importing Inventory History ****' font 'Arial',12
rowno=rowno+1

close table all
sele sele(1)
select mastertype,mastercode,descriptio from &datatransferpath\primemasters into curs master1 where mastertype=6
index on subs(descriptio,50) to master1
sele sele(1)
select mastertype,mastercode,descriptio from &datatransferpath\primemasters into curs master2 where mastertype=7
index on mastercode to master2


sele sele(1)
use &datatransferpath\primemasterdetails alias mast
index on mastercode to mast

sele sele(1)
use &datatransferpath\historydocumentmaintable alias sal
index on str(documentma)+str(docno) to sal
sele sele(1)
use &datatransferpath\historyinventorytable alia sld
index on documentow to sld
sele sele(1)
use &datatransferpath\accountstable alias act
index on documentow to act
sele sele(1)
use  &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\pro.&datext alias pro
index on code to pro
sele sele(1)
use &datdev\probat.&datext alias probat
index on str(code)+batchno  to probat
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
mvoucher=voucher+10
msvoucher=svoucher+10
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord
sele sele(1)
if used('DIS')
	sele dis
	use
endif
dis=datdev+'\HISTDIS.'+subs(datext,1,1)+'00'
if !file(dis)
	xdis=datdev+'\DIS.'+datext
	sele sele(1)
	use &xdis
	copy to &dis
	use
endif
use &dis alias dis
zap
*!*	1=SALES
*!*	3-SALES RETURN (A/C)
*!*	75-SALES RETURN CHALLAN
*!*	30-ACCOUNT C/N
*!*	31-ACCOUNT D/N
*!*	7-PURCHASE
*!*	4=PURCHASE RETURN   (A/C)
*!*	71=MPB IMPORT PURCHAASE
*!*	77-PRETURN CHALLAN
*!*	78-PURCHASE RETURN
sele mdis
appen blank
xrecnodel=recno()
sele sal
scan for inlist(documentma,1,20,3,6,75,7,4,71,77,78)   &&30,4,7)
*!*	   IF OWNCODE#442
*!*	     LOOP
*!*	   ENDIF
	if cancelflag=2
		loop
	endif
	if documentma=78   &&& purchase return challan
		loop
	endif
	if documentma=77 and sourcechal="SKIPTHIS"
		loop
	endif
*!*	  if  (CHALLANDAT=0 AND (acmeconvertdate(docdate-36161)=>old_5 or acmeconvertdate(docdate-36161)>old_6)) OR ;
*!*	     (CHALLANDAT>0 AND (acmeconvertdate(CHALLANDAT-36161)=>old_5 or acmeconvertdate(CHALLANDAT-36161)>old_6))
*!*		    loop
*!*	  endif
	mvcn=alltrim(sal.series)+'-'+alltrim(str(sal.docno))&&repl('0',7-len(alltrim(str(sal.docno))))+alltrim(str(sal.docno))
	mmastercode=sal.personcode
	if inlist(sal.documentma,1,3,75)
		sele mast
		seek sal.personcode
		loca for mastertype=7 and fieldno=160 while mastercode=sal.personcode
		if found()
			mmastercode=val(alltrim(fieldvalue))
		endif
	endif
	mvoucher=mvoucher+5
	sele mdis
	repl voucher with mvoucher
*!*	   repl codep with ''
	sele act
	seek sal.owncode
	loca for accountcod=1 while documentow=sal.owncode

	iscash=iif(found(),1,0)
	sele mdis
	repl mdis.codep with alltrim(str(mmastercode))
	if iscash=1
*!*	   if sal.memotype='1'  or SAL.DUEDATE=0
		repl cash with sal.netamount
		repl final with 0
	else
		repl final with sal.netamount
		repl cash with 0
	endif
	if between(sal.roundoff,-0.99,0.99)
		repl round with sal.roundoff
	else
*!*	   		repl other with sal.roundoff
*!*	   		REPL OTHUN WITH 'XXXXXX'
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	isigst=0
	if sal.igstamt#0
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endif
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl discafter with 'N'
*!*	 sele support
*!*	 appen blank
*!*	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	mvoutype=sal.documentma
	sele mdis
	do case
	case mvoutype=1
		repl type with 'S'
		repl ltype with scalc
		repl vcn with alltrim(sal.series)+'-'+alltrim(str(sal.docno))
		repl date with acmeconvertdate(sal.docdate-36161)
	case mvoutype=3  or mvoutype=75 &&&or mvoutype=30
		if mvoutype=3
			if seek(sal.owncode,'act') and sal.reasoncode#0
				repl vcn with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
				repl date with acmeconvertdate(sal.docdate-36161)
				repl type with 'R'
			else
				if sal.challanno#0
					repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
					repl chdate with acmeconvertdate(sal.docdate-36161)
					repl type with 'R'
				else
					repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
					repl chdate with acmeconvertdate(sal.docdate-36161)
					repl type with 'D'
				endif
			endif
		else
			repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
			repl chdate with acmeconvertdate(sal.docdate-36161)
			repl type with 'R'
		endif
		repl ltype with  scalc
	case mvoutype=7 or mvoutype=4 or mvoutype=71 or mvoutype=20
		repl vcn with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
		repl date with acmeconvertdate(sal.challandat-36161)
		repl pm with sal.sourcedocu
		repl lrda with acmeconvertdate(sal.docdate-36161)
		repl ltype with pcalc
		repl type with iif(mvoutype=4,'B','P')
	case mvoutype=77 or mvoutype=78
		repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
		repl chdate with acmeconvertdate(sal.docdate-36161)
		repl ltype with  scalc
		repl type with 'B'
	case mvoutype=6
		repl challan with mvcn &&alltrim(sal.series)+'-'+alltrim(Str(sal.docno))
		repl chdate with acmeconvertdate(sal.docdate-36161)
		repl ltype with  scalc
		repl type with 'L'
		repl codep with 'STACex'
	endcase
	if mdis.type='R'
		repl other with other+sal.addlessamo
	endif
	mybilldiscount=0
	sele sld
	seek sal.owncode
	scan while documentow=sal.owncode
		=seek(itemcode,'pro')
		sele dis
		appen blank
		repl voucher with mdis.voucher
		repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date)
		repl vcn with iif(day(mdis.date)=0,mdis.challan,mdis.vcn)
		repl codep with mdis.codep
		repl code with sld.itemcode
		repl qty with sld.qty1
		repl free with sld.qty2
		repl rate with iif(sal.documentma=6,sld.salesrate,sld.rate)
		if sld.expirydate#0
		repl exp  with acmeconvertdate(sld.expirydate-36161)
		endi

		if mdis.type='R'
*    repl svdis with -sld.addlessamo
		else
			repl svdis with -sld.addoncharg
		endif
		repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,45)
		repl batch with alltrim(sld.batchno)
		repl mrp with sld.mrp

		if sal.documentma=3 and sal.reversetax='Y'
		else
			if sld.igstper>0
				repl ssta with sld.igstper
			else
				repl ssta with sld.sgstper
				repl cgst with sld.cgstper
			endif
		endif
		repl svdis1 with -sld.othercharg+sld.discount
		repl misc4 with subs(misc4,1,44)+'L'+subs(misc4,46)
		repl flg with iif(mdis.type='S','G',mdis.type)
		repl godwon with 'A'
		repl tax with 'T'
		if sld.affectssto='N'
			if mdis.type$'RDP'
				repl flg with 'W'
				repl godwon with 'Y'
			else
				if mdis.type$'SBL'
					repl flg with 'Q'
					repl godwon with 'Y'
				endif
			endif
		endif
		if sal.documentma=6
			repl flg with iif(sld.howitaffec='S','L','D')
		endif
		if mdis.type#'R'
			if sal.addlessamo#0
				mybilldiscount=mybilldiscount+(abs(sld.addlessamo)-abs(sld.addoncharg))
			endif
		endif
		if mdis.type#'R'
*    mybilldiscount=mybilldiscount-sld.othercharg
		endif

		if sld.amount=0
			repl free with sld.qty1+sld.qty2
			repl qty with 0
		endif
		if sal.documentty=4
			repl supplied with 'R'
		endif
		if sal.documentma=7 and seek(str(sld.itemcode)+subs(sld.batchno+space(12),1,12),'PROBAT')
			repl probat.deal with sld.qty1,probat.free with sld.qty2
			repl probat.supcode with mdis.codep
			repl probat.supinvo with mdis.pm
			repl probat.supdat with mdis.lrda
		endif
		if dis.flg$'P' and seek(str(dis.code)+dis.batch,'probat')
			repl probat.supinvo with mdis.pm
			repl probat.supdat with mdis.lrda
			repl probat.supcode with mdis.codep
		endif

	endscan

	sele mdis
	if mdis.type#'R'
		repl other with other-mybilldiscount
	endif
endscan
sele dis

sele mdis
dele for recno()=xrecnodel
sele mslip
repl voucher with mvoucher,svoucher with msvoucher
slast5=msvoucher+10
close table all
close data

*!*	EOF : TFACME.PRG .....Author Santosh Srivastava
