create curs MyCurs  (setup c(50),value c(4)) 
sele MyCurs
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
brow Titl "Control Room Setting" FONT 'COURIER',18    NOMODIFY   
if messagebox('Control Room Setting is Enabled ?','MargErp9',36)#6
	retu
endif


*!*	BOF : Soham Prg .....Nivedan Sharma
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
close table all
set talk off
set date to brit
set cent on
set dele on
set safe off
if type('FINALCP')='U'
firstdate=ctod('01/04/2024')
lastdate =ctod('31/03/2025')
datdev='d:\transfer\'
datext='DBF'
endi
datatransferpath=substr('D:\Sep\Soham\dbf\'+space(50),1,50)
datatransferext='DBF'
datatransfersql='No '
old_2='01'
old_3 = 'No '
old_4 = 'No '
old_5 = firstdate
old_6 = lastdate
old_7='2425'
mstatecode='24'
softtype='Wholesale'
scalc='2'
pcalc='2'
removenull='No '
Sure = 'SURE'
mrgsqlfile=subs('ESDATA'+space(60),1,60)
mrgsqluserid=subs('sa'+space(60),1,60)
mrgsqlpwd=subs('Marg@123'+space(60),1,60)
@07,10 say 'Convert DBF From SQL  :' font 'Courier',18 get datatransfersql  pict '@m No ,Yes'  font 'cOURIER',18
@08,10 say 'Old Data From         :' font 'Courier',18 get datatransferpath     font 'Courier',18
@09,10 say 'Old Data Extension    :' font 'courier',18  get datatransferext font 'courier',18
read
if datatransfersql='Y'
	=mdbsqlconvert(3)
endif

@ 12,10 say 'Soham Data Path       :' font 'Courier',18  get datatransferpath  font 'courier',18
@ 13,10 say 'Soham Data ext        :' font 'Courier',18  get datatransferext   font 'courier',18
@ 14,10 say 'With Outstanding Y/N  :' font 'Courier',18  get old_3 pict '@m Yes,No '  font 'Courier',18
@ 15,10 say 'No-Full Yes-Master    :' font 'Courier',18  get old_4 pict '@m Yes,No '  font 'Courier',18
@ 16,10 say 'F.Y.BEGIN Date        :' font 'Courier',18  get old_5  font 'Courier',18
@ 17,10 say 'F.Y.End   Date        :' font 'Courier',18  get old_6   font 'Courier',18
@ 18,10 say 'State Code            :' font 'Courier',18  get mstatecode   font 'Courier',18
@ 19,10 say 'Sales Calculation     :' font 'Courier',18  get scalc   font 'Courier',18
@ 20,10 say 'Purch.Calculation     :' font 'Courier',18  get pcalc   font 'Courier',18
@ 21,10 say 'Wholesale             :' font 'Courier',18  get softtype pict '@m Wholesale'   font 'Courier',18
@ 22,10 say 'Firm code             :' font 'Courier',18  get old_2 pict '@x'    font 'Courier',18
@ 23,10 say 'Year Id               :' font 'Courier',18  get old_7 pict '@x'    font 'Courier',18
@ 24,10 say 'Removing Null(Y/N)    :' font 'Courier',18  get removenull pict '@m Yes,No '   font 'Courier',18
@ 25,10 say 'Type SURE             :' font 'courier',18  get Sure pict '@x!' font 'courier',18

read
clear
close table all
datatransferpath=alltrim(datatransferpath)
if !right(datatransferpath,1)='\'
	datatransferpath=alltrim(datatransferpath)+'\'
endif
datatransferext=alltrim(datatransferext)
datdev= alltrim ( datdev  )
datext= alltrim ( datext )
if lastkey() = 27 or  upper( Sure ) # 'SURE'
	return
endif
clear
if type('FINALCP')#'U'
	=starttransfer()
endif
if removenull='Y'
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	@ 02,22 say 'Please wait removing null values'
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif
rowno=5

@ 02,22 say 'Please Wait Importing Soham Software  Data To Marg.....' font 'Arial',14 colo 'W+/G'

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
use &datdev\subdis.&datext
zap
use &datdev\support.&datext
zap
close table all
set colo to


@rowno,10 say '**** Importing Product ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'imast.'+datatransferext
ft=datatransferpath+'hsnmaster.'+datatransferext
td=datdev+'\pro.'+datext

sele d
use &ft alias ftax
inde on hsncode to ftax


sele a
use &fd alias fitm


sele b
use &td alias mitm
zap
index on name to mitm

sele sele(1)
use datdev+'\saletype.'+datext alias mpcm
dele all for sgcode='COMMCD' or sgcode='SALT  ' or sgcode='ZZZZZZ' or sgcode='CATEGO'
pack
inde on sgcode+parnam+str(igst,5,2) tag mpcm
inde on sgcode+sname tag mpcm1


sele fitm
go top
do while .not. eof()
	last=recno()
	=seek(fitm.hsn,'ftax')
	sele mitm
	seek substr(fitm.icode+space(10),1,10)
	if .not. found()
		append blank
		repl mitm.code with last
		repl mitm.name with fitm.icode
		repl mitm.product with fitm.iname
		repl mitm.packing with fitm.pack
		repl mitm.billname with alltrim(fitm.iname) +'  '+ alltrim(fitm.pack)
		repl mitm.unit with fitm.unit
		repl mitm.gcode with substr(fitm.make,1,6)
		repl mitm.taxl with 'T'
		repl mitm.taxc with 'T'
		repl mitm.decimal with 'Y'
		repl mitm.salfix with 'N'
		repl mitm.minimum with fitm.mlevel
		repl mitm.halfsche with 'A'
		repl mitm.qtrsche with 'Y'
		repl mitm.saltax with ftax.sgst
		repl mitm.purtax with ftax.sgst
		repl mitm.cgst with ftax.cgst
		repl mitm.igst with ftax.igst
		repl mitm.status with 'Y'
		repl mitm.rackno with fitm.rackno
	endi

&& For HSN
	sele mpcm
	seek 'COMMCD' + substr(fitm.hsn+space(15),1,15) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'H'+alltrim(str(last)),;
			mpcm.sname  with substr(fitm.hsn+space(15),1,15)+substr(fitm.hsn,1,15) +' '+ alltrim(str(mitm.igst,5,2))+'%',;
			mpcm.parnam with substr(fitm.hsn,1,15),;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
&& For Salt Master
	set order to mpcm1
	seek 'SALT  ' + substr(upper(fitm.generic)+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'SALT  ',;
			mpcm.scode  with 'S'+alltrim(str(last)),;
			mpcm.sname  with substr(upper(fitm.generic)+space(40),1,40),;
			mpcm.parnam with substr(upper(fitm.generic),1,15),;
			mpcm.tcode with 'No',;
			mpcm.tax with 1

	endif
	repl mitm.gcode3 with mpcm.scode
&& For Company Master
	set order to mpcm1
	seek 'ZZZZZZ' + substr(fitm.make+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'ZZZZZZ',;
			mpcm.scode  with 'C'+alltrim(str(last)),;
			mpcm.sname  with substr(fitm.make+space(40),1,40),;
			mpcm.parnam with substr(fitm.make,1,15),;
			mpcm.tcode with 'No',;
			mpcm.tax with 1
	endif
	repl mitm.gcode with mpcm.scode
&& For Category Master
	set order to mpcm1
	seek 'CATEGO' + substr(upper(fitm.Itgroup)+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'CATEGO',;
			mpcm.scode  with 'G'+alltrim(str(last)),;
			mpcm.sname  with substr(upper(fitm.Itgroup)+space(40),1,40),;
			mpcm.parnam with substr(upper(fitm.Itgroup),1,15),;
			mpcm.tcode with 'No',;
			mpcm.tax with 1
	endif
	repl mitm.gcode5 with mpcm.scode
	sele fitm
	skip
enddo
close table all
@rowno,10 say '**** Importing Transport Master ' font 'Arial',11
rowno=rowno+1

fd=datatransferpath +'TransportDetails.'+datatransferext
td=datdev + '\saletype.'+datext

sele a
use &fd alias fpcm

sele b
use &td alias mpcm
set filt to sgcode = 'MSTTPT'
dele all
pack
index on scode to mpcm

sele fpcm
go top
do while ! eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'MSTTPT',;
		mpcm.scode  with fpcm.tid,;
		mpcm.sname  with fpcm.transname,;
		mpcm.parnam with fpcm.transname,;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
	sele fpcm
	skip
enddo
close tables all


@rowno,10 say '**** Importing Batch Master ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'batch.'+datatransferext
fs=datatransferpath+'fasledger.'+datatransferext
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext

SELE SELE (1)
use &datatransferpath\stock.&datatransferext alias fpdet
set filt to io='I'
index on icode+batch to fpdet
sele sele (1)
use &fd alias fsbal
set filter to Yearid=old_7 and cmpid=old_2
sele sele (1)
use &mi alias mitm
index on name to mitm
sele sele (1)
use &td alias msbal
zap
index on name+batchno to msbal

r=0
sele fsbal
go top
do while .not. eof()


	sele mitm
	seek substr(fsbal.icode+space(10),1,10)

	sele msbal
	seek substr(fsbal.icode+space(10),1,10)+substr(fsbal.batch+space(12),1,12)
	if .not. found()
		append blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with mitm.pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with 0,;
			msbal.balance with 0,;
			msbal.o_a with 0,;
			msbal.b_a with 0,;
			msbal.batchno with fsbal.batch,;
			msbal.exp with fsbal.expdt,;
			msbal.prate with fsbal.prate,;
			msbal.ratea with fsbal.ptr,;
			msbal.mrp with fsbal.mrp,;
			msbal.misc1 with mitm.gcode
*REPL MSBAL.SUPINVO WITH FSBAL.LINVNO
REPL MSBAL.SUPDAT WITH FSBAL.LINVDT
sele fpdet
seek fsbal.icode+fsbal.batch
scan while icode+batch=fsbal.icode+fsbal.batch
	if found()
		REPLACE MSBAL.SUPCODE WITH Fpdet.PCODE
	endif
endsc
	endi
	sele fsbal
	skip
endd
sele msbal
*repl all date with old_5-1 for balance = 0
close table all

if old_4='N'
	@rowno,10 say '**** Importing Batch(Opening) ****' font 'Arial',12
	rowno=rowno+1
	fd=datatransferpath+'stock.'+datatransferext
	fs=datatransferpath+'fasledger.'+datatransferext
	td=datdev+'\probat.'+datext
	mi=datdev+'\pro.'+datext

	sele sele (1)
	use &fd alias fsbal
	set filter to Yearid=old_7 and cmpid=old_2 and dbc='OPSK'
	sele sele (1)
	use &mi alias mitm
	index on name to mitm
	sele sele (1)
	use &td alias msbal
	index on name+batchno to msbal
	r=0
	sele fsbal
	go top
	do while .not. eof()

		sele mitm
		seek substr(fsbal.icode+space(10),1,10)

		sele msbal
		seek substr(fsbal.icode+space(10),1,10)+substr(fsbal.batch+space(12),1,12)
		if .not. foun()
			append blank
			repl msbal.code with mitm.code,;
				msbal.name with mitm.name,;
				msbal.billname with mitm.billname,;
				msbal.product with mitm.product,;
				msbal.pack with mitm.pack,;
				msbal.unit2 with mitm.unit2,;
				msbal.unit with mitm.unit,;
				msbal.decimal with 'Y',;
				msbal.opening with fsbal.qty,;
				msbal.balance with fsbal.qty,;
				msbal.o_a with fsbal.qty,;
				msbal.b_a with fsbal.qty,;
				msbal.batchno with fsbal.batch,;
				msbal.exp with fsbal.expdt,;
				msbal.prate with fsbal.prate,;
				msbal.ratea with fsbal.ptr,;
				msbal.rateb with fsbal.srate,;
				msbal.mrp with fsbal.mrp,;
				msbal.misc1 with mitm.gcode,;
				msbal.supcode with fsbal.pcode,;
				msbal.supinvo with fsbal.dno
*msbal.supdat With fsbal.linvdt


		else
			repl msbal.opening with msbal.opening+fsbal.qty,;
				msbal.balance with msbal.balance+fsbal.qty,;
				msbal.o_a with msbal.o_a+fsbal.qty,;
				msbal.b_a with msbal.b_a+fsbal.qty,;
				msbal.batchno with fsbal.batch,;
				msbal.exp with iif(!isnull(fsbal.expdt),fsbal.expdt,ctod('00/00/0000')),;
				msbal.prate with fsbal.prate,;
				msbal.ratea with fsbal.ptr,;
				msbal.rateb with fsbal.srate,;
				msbal.mrp with fsbal.mrp,;
				msbal.misc1 with mitm.gcode,;
				msbal.supcode with fsbal.pcode,;
				msbal.supinvo with fsbal.dno
* msbal.supdat With fsbal.linvdt

		endi
		sele fsbal
		skip
	enddo

	sele msbal
	repl all date with old_5-1 for balance = 0
	close table all
else

	@rowno,10 say '**** Importing Batch(Closing) ****' font 'Arial',12
	rowno=rowno+1
	fd=datatransferpath+'batch.'+datatransferext
	td=datdev+'\probat.'+datext
	mi=datdev+'\pro.'+datext

	sele sele (1)
	use &fd alias fsbal
	set filter to Yearid=old_7 and cmpid=old_2
	sele sele (1)
	use &mi alias mitm
	index on name to mitm
	sele sele (1)
	use &td alias msbal
	index on name+batchno to msbal
	r=0
	sele fsbal
	go top
	do while .not. eof()

		sele mitm
		seek substr(fsbal.icode+space(10),1,10)

		sele msbal
		seek substr(fsbal.icode+space(10),1,10)+substr(fsbal.batch+space(12),1,12)
		if .not. foun()
			append blank
			repl msbal.code with mitm.code,;
				msbal.name with mitm.name,;
				msbal.billname with mitm.billname,;
				msbal.product with mitm.product,;
				msbal.pack with mitm.pack,;
				msbal.unit2 with mitm.unit2,;
				msbal.unit with mitm.unit,;
				msbal.decimal with 'Y',;
				msbal.opening with fsbal.bal,;
				msbal.balance with fsbal.bal,;
				msbal.o_a with fsbal.bal,;
				msbal.b_a with fsbal.bal,;
				msbal.batchno with fsbal.batch,;
				msbal.exp with fsbal.expdt,;
				msbal.prate with fsbal.prate,;
				msbal.ratea with fsbal.ptr,;
				msbal.rateb with fsbal.srate,;
				msbal.mrp with fsbal.mrp,;
				msbal.misc1 with mitm.gcode
*!*				msbal.supcode WITH fsupp.refactid,;
*!*	            msbal.supdat WITH fsbal.linvdt,;
*!*	            msbal.supinvo WITH fsbal.linvno

		else
			repl msbal.opening with msbal.opening+fsbal.bal,;
				msbal.balance with msbal.balance+fsbal.bal,;
				msbal.o_a with msbal.o_a+fsbal.bal,;
				msbal.b_a with msbal.b_a+fsbal.bal,;
				msbal.batchno with fsbal.batch,;
				msbal.exp with fsbal.expdt,;
				msbal.prate with fsbal.prate,;
				msbal.ratea with fsbal.ptr,;
				msbal.rateb with fsbal.srate,;
				msbal.mrp with fsbal.mrp,;
				msbal.misc1 with mitm.gcode
*!*			    msbal.supcode WITH fsupp.refactid,;
*!*	            msbal.supdat WITH fsbal.linvdt,;
*!*	            msbal.supinvo WITH fsbal.linvno


		endi
		sele fsbal
		skip
	enddo

	sele msbal
	repl all date with old_5-1 for balance = 0
	close table all
endif

@rowno,10 say '**** Importing Account ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'pmast.'+datatransferext
fs=datatransferpath+'docum.'+datatransferext
fb=datatransferpath+'fasledger.'+datatransferext
td=datdev + '\order.'+datext

select select(1)
use datdev + '\support.'+datext  alias tsupp
index on aliase + str(sno,3) + lcode to tsupp
delete all for(aliase ='ORDER' or  aliase="DAT/F-LD") .and. sno=7
pack
sele sele(1)
use datdev+'\saletype.'+datext alias mpcm
dele all for sgcode='AREA  '
pack
inde on sgcode+sname to mpcm
*!*	sele sele(1)
*!*	use &fs alia fstate
*!*	set filter to Yearid=old_7
*!*	inde on pcode to fstate

select c
use &fb alias bal
*set filter to Yearid<old_7 and cmpid=old_2 &&and  dbc='OPBL'
set filter to yearid=old_7 and cmpid=old_2 and refactid='OPBL'
index on pcode to bal

sele a
use &fd alias fact

sele b
use &td alias mact
zap

sele fact
go top
do while .not. eof()
*!*		sele fstate
*!*		seek fact.pcode
	last=recno()
&&& Closing
	sele bal
	seek fact.pcode
	sum debit,credit to TOdeb,TOcre while fact.pcode=bal.pcode and !eof()
&&& Opening
	sele bal
	seek fact.pcode
	sum debit,credit to OPdeb,OPcre while fact.pcode=bal.pcode  and !eof()
	sele mact
	append blank
	repl mact.rate with 'Y'

	do case
	case fact.ACTYPE='P'
		repl	mact.scode with 'D31'
	case fact.ACTYPE='B'
		repl	mact.scode with 'C1'
	case fact.ACTYPE='S'
		repl	mact.scode with 'C6'
	otherwise
		repl mact.scode with 'J12'
	endcase
	repl mact.ordno with fact.pcode,;
		mact.parnam  with fact.pname,;
		mact.paradd with fact.add1,;
		mact.paradd1 with alltrim(fact.add2)+' '+alltrim(fact.add3),;
		mact.paradd2 with fact.city,;
		mact.dsm with fact.zip,;
		mact.sthed with  'TIN No.',;
		mact.csthed with 'CST No.',;
		mact.gsthed with 'GST No.',;
		mact.itno with fact.panno,;
		mact.gstno with fact.gstin,;
		mact.cstno with fact.sttinno,;
		mact.stno with fact.csttinno,;
		mact.dlno with alltrim(fact.dlno1) +' * '+ alltrim(fact.dlno2),;
		mact.mailnam with fact.pname,;
		mact.trans with subst(fact.trans+spac(25),1,25)+fact.delivery,;
		mact.ref with 'Mr.',;
		mact.phone1 with fact.phoneo,;
		mact.phone4 with fact.mobile,;
		mact.confir with fact.person,;
		mact.price with 'A',;
		mact.city with  fact.city,;
		mact.status with 'Y',;
		mact.adhed with 'Discount',;
		mact.margcode with fact.tcscalc

*!*			if old_4='N'
*!*			REPLACE mact.opning With Iif(mact.scode='D31',-(OPcre-OPdeb),OPdeb-OPcre),;
*!*			mact.balance With Iif(mact.scode='D31',-(TOcre-TOdeb),TOdeb-TOcre)
*!*			ELSE
*!*			REPLACE mact.opning With Iif(mact.scode='D31',-(TOcre-TOdeb),TOdeb-TOcre),;
*!*			mact.balance With Iif(mact.scode='D31',-(TOcre-TOdeb),TOdeb-TOcre)
*!*			endif


&&& Closing
	sele bal
	seek fact.pcode
	sum debit,credit to TOdeb,TOcre while fact.pcode=bal.pcode
&&& Opening
	sele bal
	seek fact.pcode
	sum debit,credit to OPdeb,OPcre while fact.pcode=bal.pcode

	if old_4='N'
		replace mact.opning with iif(mact.scode='D31',-(OPcre-OPdeb),OPdeb-OPcre),;
			mact.balance with iif(mact.scode='D31',-(TOcre-TOdeb),TOdeb-TOcre)
	else
		replace mact.opning with iif(mact.scode='D31',-(TOcre-TOdeb),TOdeb-TOcre),;
			mact.balance with iif(mact.scode='D31',-(TOcre-TOdeb),TOdeb-TOcre)
	endif


&& For Area Master mact.cgstun With fstate.consstatec
	select mpcm
	seek 'AREA  ' + substr(fact.area+space(40),1,40)
	if !found()
		append blank
		repl mpcm.sgcode with 'AREA  ',;
			mpcm.scode  with 'A'+alltrim(str(last)),;
			mpcm.sname  with substr(fact.area+space(40),1,40),;
			mpcm.parnam with substr(fact.area,1,15),;
			mpcm.tcode with 'No',;
			mpcm.tax with 1
	endif
	repl mact.area with mpcm.scode
&& Updating State
	sele tsupp
	seek 'ORDER   ' + '  7' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(fact.gstin,1,2)#'  ',subs(fact.gstin,1,2),mstatecode)+'                                           '
&& Email ID
	sele tsupp
	append blank
	repl aliase with 'ORDER   ',;
		type with 'F',;
		lcode with mact.ordno,;
		sno with 12,;
		remark with fact->email,;
		heading with substr(heading,1,21)+iif(empty(mact->gstno),'UG','NG')
&&ledger Difference
	sele tsupp
	appe blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact->ordno,value with mact.balance
*** Ask Tcs Charge In Ledger ***  &&&updated by umesh on 12th,mar,2021
	if fact->tcscalc='Y'
		sele tsupp
		append blank
		repl aliase with 'PARTYOTP'
		repl type with 'F'
		repl lcode with mact.ordno
		repl remark with 'M 50.00 40.00Y1             30            BAB                                   '
	endi
	sele fact
	skip
enddo
select mact
append blank
repl ordno with 'OTHER'
repl parnam with 'OTHER HEAD'
select mact
append blank
repl ordno with 'ROUNDA'
repl parnam with 'ROUNDING'
select mact
append blank
repl ordno with 'FREIGH'
repl parnam with 'FREIGHT'
close table all

@rowno,10 say '**** Importing Outstanding ****' font 'Arial',12
rowno=rowno+1
af=datdev+'\pendings.'+datext
or=datdev+'\order.'+datext
bf=datdev+'\slipno.'+datext
cf=datatransferpath+'fasledger.'+datatransferext
sele a
use &af alias mpend
zap
select d
use &or alias ord
index on ordno to ord
sele b
use &bf alias mslip
sele c
use &cf alias fout
*set filter to Yearid=old_7  and cmpid=old_2 and  refdocdt<old_5&&Between(refdocdt,old_5,old_6)
set filter to yearid=old_7 and cmpid=old_2 and refactid='OPBL'

if old_3='Y'

	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10

	sele fout

	go top
	do while !eof()
		select ord
		seek  fout.pcode
		sele mpend
		append blank
		repl     mpend.ord with fout.pcode
		repl     mpend.ddate with fout.refdocdt
		repl     mpend.vcn with fout.refdocno
		repl     mpend.invtype with 'O'
		repl     mpend.voucher  with vou
		repl     mpend.svoucher with svou
		repl     mpend.duedate with fout.duedate
* Repl     mpend.duedays with fout.duedate
		if ord.scode='D31'
			repl     mpend.itemope with 0
			repl     mpend.final with  -fout.credit-fout.debit
			repl     mpend.balance with  -fout.credit-fout.debit
		else
			repl     mpend.itemope with 0
			repl     mpend.final with fout.debit-fout.credit
			repl     mpend.balance with fout.debit-fout.credit
		endif


		repl name with vcn
		vou =vou+5
		svou=svou+5
		sele fout
		skip
	enddo

	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5

endif
close table all
if old_4='N'
	do import_transactions
endi

procedur import_transactions
@rowno,10 say '**** Importing Ledger Transaction ****' font 'Arial',12
rowno=rowno+1
mdis=datdev+ '\mdis.'+datext
af =datdev + '\gledger.'+datext
bf =datdev + '\slipno.'+datext
dis=datdev + '\dis.'+datext
pro=datdev + '\pro.'+datext
ord=datdev + '\order.'+datext


**Sales
sal=datatransferpath +'fasledger.'+datatransferext
sld=datatransferpath +'Stock.'+datatransferext
doc=datatransferpath +'docum.'+datatransferext

sele select(1)
use &datdev\support.&datext alias support  &&inde &datdev\&datext.supp
index on type+aliase to  support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele (1)
use &pro alias pro
inde on name to pro
*!*	sele sele (1)
*!*	use &doc alias doc
*!*	inde on clydsd to doc
sele sele(1)
use &ord alia ord
inde on ordno to ord
sele sele(1)
use &bf
go top
last4  = voucher + 10
slast5 = svoucher + 10


@rowno,10 say '**** Importing Sales ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &sld alias sld
index on clydsd to sld

sele sele(1)
use &sal alias sal

sele sele(1)
use &dis alias dis
zap
sele sele(1)
use &mdis alias mdis
zap
sele sal
set filter to Yearid=old_7 and ledentno='1  '  and  dbc $'SALE' and cmpid=old_2 and  between(refdocdt,old_5,old_6)

go top
do while .not. eof()

	=seek(subs(sal->pcode+spac(6),1,6),'ord')
*!*		=seek(sal->clydsd,'doc')
	last1=sal->refdocno

	sele mdis
	appe blank
	repl type with 'S'
	repl vcn with last1
	repl date with sal->refdocdt
	repl codep with sal->pcode
	repl voucher with last4
	last4=last4+5
	repl amountp with sal->debit
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl duedays with 0

	if sal.dbc ='CASH '
		repl cash with sal->debit
	else
		repl final with sal->debit
	endif

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl lrda with sal->refdocdt
	repl Account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl ltype with scalc
	repl discafter with 'N'
	repl remark4 with last1
	repl remark1 with str(round(sal->debit,0),15,2)
*!*		repl other with doc->otheramt1
*!*		repl othun with 'OTHER'

	sele mdis
	isigst=0
	if subst(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endi

	if !empty(ord.cgstun) and subs(ord.cgstun,1,2)!=subst(ord.gstno,1,2) and ord.cgstun!=mstatecode
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endi

	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele sld
	seek sal->clydsd
	do while .not. eof() .and. sal->clydsd =sld->clydsd


		last=substr(sld.icode+space(10),1,10)

		sele pro
		seek last

		sele dis
		appe blank
		repl codep with mdis->codep
		if empty(mdis->vcn)
			repl vcn with mdis->challan
			repl date with mdis->chdate
		else
			repl vcn with mdis->vcn
			repl date with mdis->date
		endi
		repl voucher with mdis->voucher
		repl code with pro->code
		repl tax with 'T'
		repl qty with sld->qty
		repl free with sld->fqty
		repl pack with pro->pack
		repl exp with sld->expdt
		repl  batch with sld->batch
		repl misc4 with substr(misc4,1,14)+'M'+substr(misc4,16,100)
		repl flg with iif(mdis->type='S','G',mdis->type)
		repl rate with sld->srate
		repl mrp with sld->mrp
*		Repl disc1 With sld->tradedisc
*		repl svdis with sld->lotdisc

		if sld.cgst_p=0

			repl ssta with sld->igst_p

		else
			repl ssta with sld->sgst_p
			repl cgst with sld->cgst_p
		endif
		repl tax with 'T'
		repl half with 'A'
		repl godwon with mdis->godwon
		sele sld
		skip
	enddo
	sele sal
	skip
endd
close table all
@rowno,10 say '**** Importing Sales Return ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &ord alia ord
inde on ordno to ord
sele select(1)
use &datdev\support.&datext alias support
sele sele (1)
use &pro alias pro
inde on name to pro
sele sele(1)
use &sld alias sld
index on clydsd to sld

sele sele(1)
use &sal alias sal

sele sele(1)
use &dis alias dis

sele sele(1)
use &mdis alias mdis

sele sal
set filter to Yearid=old_7  and  dbc $'SLRT ' and cmpid=old_2 and  between(refdocdt,old_5,old_6) and ledentno='3  '

go top
do while .not. eof()

	=seek(subs(sal->pcode+spac(6),1,6),'ord')
	last1=sal->refdocno

	sele mdis
	appe blank
	repl type with 'R'
	repl vcn with last1
	repl date with sal->refdocdt
	repl codep with sal->pcode
	repl voucher with last4
	last4=last4+5
	repl amountp with sal->credit
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl duedays with 0

	if sal.dbc ='CASH '
		repl cash with sal->credit
	else
		repl final with sal->credit
	endif

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl lrda with sal->refdocdt
	repl Account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl ltype with scalc
	repl discafter with 'N'
	repl remark4 with last1
	repl remark1 with str(round(sal->credit,0),15,2)


	sele mdis
	isigst=0
	if subst(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endi
	if !empty(ord.cgstun) and subs(ord.cgstun,1,2)#subst(ord.gstno,1,2) and ord.cgstun!=mstatecode
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endi
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele sld
	seek sal->clydsd
	do while .not. eof() .and. sal->clydsd =sld->clydsd

		last=substr(sld.icode+space(10),1,10)

		sele pro
		seek last

		sele dis
		appe blank
		repl codep with mdis->codep
		if empty(mdis->vcn)
			repl vcn with mdis->challan
			repl date with mdis->chdate
		else
			repl vcn with mdis->vcn
			repl date with mdis->date
		endi
		repl voucher with mdis->voucher
		repl code with pro->code
		repl tax with 'T'
		repl qty with sld->qty
		repl free with sld->fqty
		repl pack with pro->pack
		repl exp with sld->expdt
		repl  batch with sld->batch
		repl misc4 with substr(misc4,1,14)+'M'+substr(misc4,16,100)
		repl flg with iif(mdis->type='S','G',mdis->type)
		repl rate with sld->cnrate
		repl mrp with sld->mrp
*		Repl disc1 With sld->tradedisc
*		repl svdis with sld->lotdisc

		if isigst=1

			repl ssta with sld->igst_p

		else
			repl ssta with sld->sgst_p
			repl cgst with sld->cgst_p
		endif
		repl tax with 'T'
		repl half with 'A'
		repl godwon with mdis->godwon
		sele sld
		skip
	enddo
	sele sal
	skip
endd
close table all
@rowno,10 say '**** Importing Purchase ****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &ord alia ord
inde on ordno to ord

sele select(1)
use &datdev\support.&datext alias support
sele select(1)
use &datdev\subdis.&datext alias subdis


sele sele (1)
use &pro alias pro
inde on name to pro
sele sele (1)
*!*	use &doc alias doc
*!*	inde on clydsd to doc
sele sele(1)
use &sld alias sld
index on clydsd to sld

sele sele(1)
use &sal alias sal
*!*	select * from sal  into cursor tmptcs where xrefdbc='TCS' and Yearid=old_7 and cmpid=old_2 and between(refdocdt,old_5,old_6) readwr
*!*	index on clydsd to tmptcs &&ledentno='14  '

sele sele(1)
use &dis alias dis

sele sele(1)
use &mdis alias mdis

sele sal
set filter to Yearid=old_7 and (ledentno='3  ' ) and  dbc $'PURC' and cmpid=old_2 and  between(refdocdt,old_5,old_6)

go top
do while .not. eof()

	=seek(subs(sal->pcode+spac(6),1,6),'ord')
	*=seek(sal->clydsd,'tmptcs')
*!*		=seek(sal->clydsd,'doc')
	last1=sal->refdocno

	sele mdis
	appe blank


	repl type with 'P'
	repl vcn with sal.billno
	repl pm with last1
	repl date with sal->refdocdt
	repl codep with sal->pcode
	repl voucher with last4
	last4=last4+5
	repl amountp with sal->credit
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl duedays with 0

	if sal.dbc ='CASH '
		repl cash with sal->credit
	else
		repl final with sal->credit
	endif

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl lrda with sal->refdocdt
	repl Account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl ltype with scalc
	repl discafter with 'N'
	repl remark4 with last1
	repl remark1 with str(round(sal->credit,0),15,2)
*	repl other with doc->rnd_a
	repl othun with 'ROUNDA'
*	repl freight with doc->otheramt1
	repl freun with 'FREIGH'

****Tcs Addition****
*!*		if doc->tcsp#0 and doc->tcsamount#0
*!*			sele subdis
*!*			appen blan
*!*			repl codep with mdis->codep
*!*			repl vcn with mdis->vcn
*!*			repl date with mdis->date
*!*			repl voucher with mdis->voucher
*!*			repl type with '9'
*!*			repl dsm with 'RETTCS'
*!*			repl rtqt with str(doc->tcsamount,12)+' '+str(doc->tcsp,5,3)&&'0.075'
*!*		endif

	sele mdis
	isigst=0
	if subst(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endi
	if !empty(ord.cgstun) and subs(ord.cgstun,1,2)#subst(ord.gstno,1,2) and ord.cgstun!=mstatecode
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endi
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele sld
	seek sal->clydsd
	do while .not. eof() .and. sal->clydsd =sld->clydsd

**Exp Date
		last=substr(sld.icode+space(10),1,10)

		sele pro
		seek last

		sele dis
		appe blank
		repl codep with mdis->codep
		if empty(mdis->vcn)
			repl vcn with mdis->challan
			repl date with mdis->chdate
		else
			repl vcn with mdis->vcn
			repl date with mdis->date
		endi
		repl voucher with mdis->voucher
		repl code with pro->code
		repl tax with 'T'
		repl qty with sld->qty
		repl free with sld->fqty
		repl pack with pro->pack
		repl exp with sld->expdt
		repl  batch with sld->batch
		repl misc4 with substr(misc4,1,14)+'M'+substr(misc4,16,100)
		repl flg with iif(mdis->type='S','G',mdis->type)
		repl rate with sld->prate
		repl mrp with sld->mrp
*		Repl disc1 With sld->tradedisc
*		repl svdis with sld->lotdisc

		if isigst=1

			repl ssta with sld->igst_p

		else
			repl ssta with sld->sgst_p
			repl cgst with sld->cgst_p
		endif
		repl tax with 'T'
		repl half with 'A'
		repl godwon with mdis->godwon
		sele sld
		skip
	enddo
	sele sal
	skip
endd
close table all
@rowno,10 say '**** Importing Purchase Return****' font 'Arial',12
rowno=rowno+1

sele sele(1)
use &ord alia ord
inde on ordno to ord

sele select(1)
use &datdev\support.&datext alias support

sele sele (1)
use &pro alias pro
inde on name to pro
sele sele(1)
use &sld alias sld
index on clydsd to sld

sele sele(1)
use &sal alias sal

sele sele(1)
use &dis alias dis

sele sele(1)
use &mdis alias mdis

sele sal
set filter to Yearid=old_7 and (ledentno='1  ' ) and  dbc $'PRRT' and cmpid=old_2 and  between(refdocdt,old_5,old_6)

go top
do while .not. eof()

	=seek(subs(sal->pcode+spac(6),1,6),'ord')
	last1=sal->refdocno

	sele mdis
	appe blank

	repl type with 'B'
	repl pm with last1
	repl vcn with iif(empty(sal.billno),last1,sal.billno)
	repl date with sal->refdocdt
	repl codep with sal->pcode
	repl voucher with last4
	last4=last4+5
	repl amountp with sal->debit
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl duedays with 0

	if sal.dbc ='CASH '
		repl cash with sal->debit
	else
		repl final with sal->debit
	endif

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl lrda with sal->refdocdt
	repl Account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl ltype with scalc
	repl discafter with 'N'
	repl remark4 with last1
	repl remark1 with str(round(sal->debit,0),15,2)


	sele mdis
	isigst=0
	if subst(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endi
	if !empty(ord.cgstun) and subs(ord.cgstun,1,2)#subst(ord.gstno,1,2) and ord.cgstun!=mstatecode
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1
	endi
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele sld
	seek sal->clydsd
	do while .not. eof() .and. sal->clydsd =sld->clydsd

**Exp Date
		last=substr(sld.icode+space(10),1,10)

		sele pro
		seek last

		sele dis
		appe blank
		repl codep with mdis->codep
		if empty(mdis->vcn)
			repl vcn with mdis->challan
			repl date with mdis->chdate
		else
			repl vcn with mdis->vcn
			repl date with mdis->date
		endi
		repl voucher with mdis->voucher
		repl code with pro->code
		repl tax with 'T'
		repl qty with sld->qty
		repl free with sld->fqty
		repl pack with pro->pack
		repl exp with sld->expdt
		repl  batch with sld->batch
		repl misc4 with substr(misc4,1,14)+'M'+substr(misc4,16,100)
		repl flg with iif(mdis->type='S','G',mdis->type)
		repl rate with sld->prate
		repl mrp with sld->mrp
*		Repl disc1 With sld->tradedisc
*		repl svdis with sld->lotdisc

		if isigst=1

			repl ssta with sld->igst_p

		else
			repl ssta with sld->sgst_p
			repl cgst with sld->cgst_p
		endif
		repl tax with 'T'
		repl half with 'A'
		repl godwon with mdis->godwon
		sele sld
		skip
	enddo
	sele sal
	skip
endd
close table all
@rowno,10 say '**** Importing Account From Sales  ' font 'Arial',11
rowno=rowno+1
af      = datdev + '\gledger.'+datext
pend    = datdev + '\pend.'+datext
mdis    = datdev + '\mdis.'+datext
pending = datdev + '\pendings.'+datext
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
do while ! eof()
	if vcn=space(12)
		skip
		loop
	endif
	last1 = mdis.codep
	if mdis.final#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		if d.type = 'P'
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
**** for outstanding
		if old_3='Y'
			sele f
			appe blank
			repl ord with mdis.codep
			repl ddate with mdis.date
			repl duedays with mdis.duedays
			repl vcn with mdis.vcn
			if d.type = 'P'
				repl final with -mdis.final
			else
				if d.type = 'S'
					repl final with mdis.final
				endif
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
		if d.type = 'P'
			repl cd with 'C'
			repl credit with mdis.cash
			repl book with 'A'
		else
			if d.type = 'S'
				repl cd with 'D'
				repl debit with mdis.cash
				repl book with 'S'
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
	sele d
	skip
enddo
close table	all

@rowno,10 say '**** Importing Cash Transactions ' font 'Arial',11
rowno=rowno+1
af      = datdev + '\gledger.'+datext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath+'fasledger.'+datatransferext
sele g
use &pending alias pending
index on ord + substr(name,1,12) to rou2
last4  = last4 + 10
slast5 = slast5 + 10

sele c
use &ord alias ord
index on fax2 to ord

sele f
use &pend alias pend
sele b
use &af alias gledger
sele a
use &cf alias led
index on clydsd to led
*!*	Set Filter To Yearid=old_7 And ledentno='1  ' And  inlist(Dbc,'BNKP','BNKR','CASR','CASP')  And cmpid=old_2 ;
*!*	And  Between(refdocdt,old_5,old_6) and pcode='A.A01'
set filter to Yearid=old_7 and inlist(dbc,'BNKP','BNKR','CASR','CASP','CRNT','DBNT')  and cmpid=old_2 ;
	and  between(refdocdt,old_5,old_6) &&&&and pcode='A.A01'
**6 - Contra
**9 - Cash Receipt
**22- Cash Payment
go top
last1 = '##########'
mvch='9999999999999999'
do while !eof()
	if clydsd#mvch
		mvch=clydsd
		last4 = last4+4
	endif
	do while clydsd=mvch and !eof()
		sele b
		append blank
		repl voucher with last4
		if a.credit # 0
			repl cd with 'C'
			repl credit with a.credit
		else
			if a.debit # 0
				repl cd with 'D'
				repl debit with a.debit
			endif
		endif
		repl date with a.refdocdt
		repl code with a.pcode
		repl remark1 with iif(isnull(a.narration),'',a.narration)
		if a.dbc $ 'BNKP'
			repl book with 'P'
		else
			if a.dbc $ 'BNKR'
				repl book with 'R'
			else
				if a.dbc $ 'CASR'
					repl book with 'R'
				else
					if a.dbc $ 'CRNT'
						repl book with 'E'
					else
						if a.dbc $ 'DBNT'
							repl book with 'D'
						endi
					endif
				endif
			endif
		endi
		sele a
		skip
	enddo

*!*	**Contra Entry
*!*		Sele b
*!*		Append Blank
*!*		Repl voucher With last4
*!*		If a.credit # 0
*!*			Repl Cd With 'D'
*!*			Repl debit With a.credit
*!*		Else
*!*			If a.debit # 0
*!*				Repl Cd With 'C'
*!*				Repl credit With a.debit
*!*			Endif
*!*		Endif
*!*		Repl Date With a.refdocdt
*!*		Repl Code With a.pcode
*!*		Repl remark1 With iif(isnull(a.narration),'',a.narration)
*!*		If a.Dbc $ 'BNKP'
*!*			Repl book With 'P'
*!*		Else
*!*			If a.Dbc $ 'BNKR'
*!*				Repl book With 'R'
*!*			Else
*!*				If a.Dbc $ 'CASR'
*!*					Repl book With 'R'
*!*				Endif
*!*			Endif
*!*		Endif
*!*		Sele a
*!*		Skip
enddo
close data all
bf=datdev + '\slipno.'+datext
use &bf
go top
repl voucher with last4+20
repl svoucher with slast5+20
bf=datdev+ '\mdis.'+datext
use &bf
repl misc4 with ' '
bf=datdev+ '\pendingS.'+datext
use &bf
repl all vcn with '*'+vcn for invtype='O' .and. ddate<=old_5
close data
&&&&&&&&&&&&&&&&&FUNCTION FOR MDB TO DBF&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7
close table all
func mdbsqlconvert(mdbsqlpara1)
do case
case mdbsqlpara1=1
	if datatransfermdb='Y'
		mrgmdbfile=alltrim(getfile('mdb'))
		datatransferpath=subs(fullpath(mrgmdbfile)+'\visual_data\'+space(80),1,80)

		datatransferpath=alltrim(datatransferpath)
		=mdbsqlconvert(2)
	endif
case mdbsqlpara1=2 and datatransfermdb='Y'
	clear
	mrgmdbfile=alltrim(mrgmdbfile)
	mrgmdbpwd=alltrim(mrgmdbpwd)
	datatransferpath=subs(justpath(mrgmdbfile)+'\visual_data\'+space(80),1,80)
	mrgexit=0
	if empty(mrgmdbfile)
		=messagebox("Please Enter Access File Name !!",100,'Check MDB File Path')
		mrgexit=1
	endif
	if !file(mrgmdbfile)
		=messagebox("Access File not found. Please Check !!",100,'Check MDB File Path')
		mrgexit=1
	endif
	if empty(datatransferpath)
		=messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	endif
	if mrgexit=1
		=messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		return
	endif
	lnconnhandle=0
	merrno=0
	try
		if empty(mrgmdbpwd)
			lnconnhandle=sqlstringconnect('DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		else
			lnconnhandle=sqlstringconnect('PWD='+trim(mrgmdbpwd)+';DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ='+mrgmdbfile)
		endif
	catch to oexp
		merrno=1
	endtry
	if merrno=1
		=messagebox('Invalid MS-Access data file or invalid password.',48,'Will Quit Now')
		retu
	endif
	if !directo(alltrim(datatransferpath))
		md &datatransferpath
	endif
	datatransferpath=addbs(datatransferpath)
	if lnconnhandle>0
		clear
		@07,10 say 'Converting Access File to DBF. Please Wait......' font 'courier',16
		dvfp_tflds=0
		sele sele(1)
		lnresult=sqltables(lnconnhandle,'TABLE')
		tblfnd=0
		if lnresult > 0
			sele sqlresult
			scan
				try
					msqltabl=uppe(allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					sele sele(1)
					lngetdata=sqlexec(lnconnhandle,lcsqlcommand,'NEWDATA')
					if lngetdata>0
						lcdbffilenm=allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=chrtran(lcdbffilenm," "+chr(9),"")
						sele newdata
						copy to &lcdbffilenm
						wait wind lcdbffilenm nowait
						use
					endif
				catch to oerr
					merrno=1
					=messagebox(oerr.message,64)
					susp
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "Access File Successfully Converted to DBF."

	else
		=messagebox('Unable to read from Connection',48,'Marg Payroll')
		retu
	endif
	rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	if merrno=1
		=messagebox('Error encountered while importing data.',48)
		retu
	endif
	clear
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16

	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
case mdbsqlpara1=3
	clear
	mrgsqlfile=alltrim(mrgsqlfile)
	mrgsqluserid=alltrim(mrgsqlpwd)
	mrgsqlpwd=alltrim(mrgsqlpwd)
	datatransferpath=alltrim(datatransferpath)
	mrgexit=0
	if empty(mrgsqlfile)
		=messagebox("Please Enter SQL Database Name !!",100,'Check File Name')
		mrgexit=1
	endif
	if empty(datatransferpath)
		=messagebox("Please Enter Save Path !!",100,'Check Source Data Path')
		mrgexit=1
	endif
	if mrgexit=1
		=messagebox('No files Selected :: Give Correct file name & path : Quit Now ',100)
		return
	endif
	lnconnhandle=0
	merrno=0
	try
		lnconnhandle=sqlstringconnect("DRIVER=Sql Server;SERVER=SANTOSH-LP\SQLEXPRESS;UID="+mrgsqluserid+";PWD="+mrgsqlpwd+";APP=Microsoft Visual FoxPro;WSID=MARG01;DATABASE="+mrgsqlfile)
	catch to oexp
		merrno=1
	endtry
	if merrno=1
		=messagebox('Invalid data file or invalid password.',48,'Will Quit Now')
		retu
	endif
	if !directo(datatransferpath)
		md &datatransferpath
	endif
	datatransferpath=addbs(datatransferpath)
	if lnconnhandle>0
		clear
		@07,10 say 'Converting SQL Database to DBF. Please Wait......' font 'courier',16
		dvfp_tflds=0
		sele sele(1)
		lnresult=sqltables(lnconnhandle,'TABLE')
		tblfnd=0
		if lnresult > 0
			sele sqlresult
			scan
				try
					msqltabl=uppe(allt(table_name))
					lcsqlcommand="SELECT * FROM ["+msqltabl+"]"
					sele sele(1)
					lngetdata=sqlexec(lnconnhandle,lcsqlcommand,'NEWDATA')
					if lngetdata>0
						lcdbffilenm=allt(datatransferpath)+msqltabl+'.dbf'
						lcdbffilenm=chrtran(lcdbffilenm," "+chr(9),"")
						sele newdata
						copy to &lcdbffilenm
						use
					endif
				catch to oerr
					merrno=1
					=messagebox(oerr.message,64)
					susp
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "SQL DataBase  Successfully Converted to DBF."
	else
		=messagebox('Unable to read from Connection',48,'Marg ')
		retu
	endif
	rele lnconnhandle,lnresult,lcsqlcommand,lngetdata,lcnewname
	if merrno=1
		=messagebox('Error encountered while importing data.',48)
		retu
	endif
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
	datatransferpath=subs(alltrim(datatransferpath)+space(80),1,80)
endcase

proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor
