*!*	BOF :PROFIT MAKER.PRG .....Nivedan Sharma
*****Last Change By Nivedan Sharma        Dated    : 28-Apr-2020
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
appe blank
repl  setup with 'Bill discount ',value with 'Y'
appen blank
repl  setup with 'Ask Discount in Amount',value with 'B'
brow font 'COURIER',18    nomodify
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&OUTSITDE PATHE PRG&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
if type('FINALCP')='U'
	firstdate=ctod('01/04/2024')
	lastdate= ctod('31/03/2025')
	datdev='D:\TRANSFER'
	datext= 'dbf'
endif

datatransferpath=subs('D:\Data_Migration\Nov\Profimaker\data\'+space(100),1,100)
datatransferext='DBF'
datatransfersql='No '
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
old_7 = 'G'
softtype='Wholesale'
scalc='2'
pcalc='2'
old_12 = '      '
old_13 = '      '
old_14 = '#'
mstatecode='37'
sure='SURE'
datatype1='SQL'
datatransfersql='No '
datatransfermdb='No '
mrgmdbfile=space(100)
mrgmdbpwd=space(30)
removenull='No '
mversion='V01'
@04,10 say 'Database SQL/MDB' font 'Courier',14 get datatype1  pict '@^m SQL,MDB'  font 'cOURIER',11
read
if datatype1='SQL'
	mrgsqlfile=subs('Profit_data'+space(60),1,60)
	mrgsqluserid=subs('sa'+space(60),1,60)
	mrgsqlpwd=subs('Marg@12'+space(60),1,60)
	@ 08,10 say 'Convert DBF From SQL  :' font 'Courier',14 get datatransfersql pict '@^m No ,Yes'  font 'cOURIER',11
	@ 09,10 say 'SQL Database Name     :' font 'Courier',14 get mrgsqlfile    font 'cOURIER',14
	@ 10,10 say 'Convert DBF From SQL  :' font 'Courier',14 get mrgsqluserid   font 'cOURIER',14
	@ 11,10 say 'Convert DBF From SQL  :' font 'Courier',14 get mrgsqlpwd    font 'cOURIER',14
	@ 12,10 say 'Profit Maker Data Path:' font 'Courier',14 get datatransferpath     font 'Courier',14
	read
else
	@05,10 say 'Convert DBF From MDB  :' font 'Courier',14 get datatransfermdb  pict '@^m No ,Yes'  font 'cOURIER',11
	@06,10 say 'Profit Maker Data Path:' font 'Courier',14 get datatransferpath     font 'Courier',14
	read
endif
if datatransfersql='Y'
	=mdbsqlconvert(3)
else
	if datatype1='M' and datatransfermdb='Y'
		=mdbsqlconvert(1)
	endif
endif
clear gets
clear
clear
upd_clo='No '
@ 05,10 say 'PROFIT MAKER Data Path         :' font 'Courier',14  get datatransferpath  font 'courier',11
@ 06,10 say 'PROFIT MAKER Extension         :' font 'Courier',14  get datatransferext  font 'courier',11
@ 07,10 say 'With Outstanding Y/N           :' font 'Courier',14  get old_3 pict '@^m YES,NO '  font 'Courier',11
@ 08,10 say 'No-Full Yes-Master             :' font 'Courier',14  get old_4 pict '@^m No,Yes'  font 'Courier',11
@ 09,10 say 'F.Y.BEGIN Date                 :' font 'Courier',14  get old_5  font 'Courier',11
@ 10,10 say 'F.Y.End   Date                 :' font 'Courier',14  get old_6   font 'Courier',11
@ 11,10 say 'G-GST  V-Vat                   :' font 'Courier',14  get old_7  font 'Courier',11
@ 12,10 say 'State Code                     :' font 'Courier',14  get mstatecode font 'Courier',11
@ 13,10 say 'Sales Calculation              :' font 'Courier',14  get scalc   font 'Courier',11
@ 14,10 say 'Purch.Calculation              :' font 'Courier',14  get pcalc   font 'Courier',11
@ 16,10 say 'Sale Adj Ledger(aless1+aless2) :' font 'Courier',14  get old_12   font 'Courier',11
@ 17,10 say 'Purchase Adj Ledger            :' font 'Courier',14  get old_13  font 'Courier',11
@ 18,10 say 'Removenull                     :' font 'Courier',14  get removenull pict '@^ No ,Yes'   font 'Courier',11
@ 19,10 say 'Version                        :' font 'Courier',14  get mversion pict '@^ V01,V02'   font 'Courier',11
@ 20,10 say 'Update Closing Only            :' font 'Courier',14  get upd_clo pict '@^ No ,Yes'   font 'Courier',11
@ 21,10 say 'Type SURE                      :' font 'courier',14  get sure pict '@x!' font 'courier',11
read
if type('FINALCP')#'U'
=STARTTRANSFER()
endif
close data
if removenull='Y'
	clear
	@05,10 say 'Removing Null Values..Please Wait......' font 'courier',14
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif


datatransferpath=alltrim(datatransferpath)
if !right(datatransferpath,1)='\'
	datatransferpath=alltrim(datatransferpath)+'\'
endif
datatransferext='.'+alltrim(datatransferext)
datdev= alltrim (datdev)
datdev= alltrim (datdev)
if !dire(datatransferpath)
	md &datatransferpath
endif


if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
if upd_clo='Y'
	do update_closing
	return
endif

rowno=5

*@ 02,22 say 'Please Wait Importing Profit Maker Data To Marg.....' font 'Arial',14 colo 'W+/G'
*!*	REST SCREEN FROM SIMPLE
*!*	colofhed="PROFIT MAKER TO MARG MIGRATION TOOL"
*!*	=colofil(02,08,21,80,10)
*set colo to
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
dele all for type='#' and aliase='DAT/F'
pack
close data
set colo to
*do removenull
if old_4='Y'
	do margo
else
	do marga
endif

proc margo
@rowno,10 say '**** Importing Product ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'product'+datatransferext
td=datdev+'\pro.'+datext
ty=datdev+'\rate.'+datext
ts=datdev+'\saletype.'+datext

sele d
use &ts alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm

sele c
use &ty alias frat
index on code to frat
dele all for  type = '~'
pack
go top

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
	append blank
	repl mitm.code with fitm.rndid
	repl mitm.name with fitm.code
	repl mitm.product with upper(fitm.name)
	repl mitm.packing with upper(fitm.packing)
	repl mitm.billname with upper(alltrim(fitm.name)) +'  '+ upper(alltrim(fitm.packing))
	repl mitm.unit with 'Pcs'
	repl mitm.rackno with fitm.rackno
	repl mitm.pack with fitm.boxqty
	repl mitm.gcode with str(fitm.comid,6)
	if softtype='R'
		repl mitm.gcode3 with alltrim(fitm.drugid)
	endif
	repl mitm.gcode5 with str(fitm.catid,6)

	repl mitm.taxl with 'T'
	repl mitm.taxc with 'T'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with fitm.saleminqty
	repl mitm.maximum with fitm.salemaxqty
	repl mitm.halfsche with 'H'
	repl mitm.qtrsche with 'Y'
	repl mitm.saltax with fitm.salegst/2
	repl mitm.cgst with fitm.salegst/2
	repl mitm.igst with fitm.salegst
	repl mitm.purtax with fitm.salegst
	repl mitm.status with iif(fitm.deleted = .t.,'N','Y')
	repl mitm.prate with fitm.purprice
	repl mitm.lprate with fitm.costprice
	repl mitm.ratea with fitm.billprice
	repl mitm.rateb with fitm.splprice
	repl mitm.ratec with fitm.stkprice
	repl mitm.mrp with fitm.mrp
	repl mitm.deal with fitm.saleschqty
	repl mitm.free with fitm.saleschqty
	repl mitm.purdeal with fitm.purschqty
	repl mitm.purfree with fitm.purschfree
	repl mitm.purdis with fitm.purdis
	repl mitm.rackno2 with str(fitm.rndid,10)
	repl mitm.formulano with substr(formulano,1,25)+str(fitm.saledis,5,2)

	if old_7='G'
		sele mpcm
		seek 'COMMCD' + substr(alltrim(fitm.hsncode)+space(15),1,15) + str(mitm.igst,5,2)
		if !found()
			append blank
			repl mpcm.sgcode with 'COMMCD',;
				mpcm.scode  with 'C'+alltrim(str(last)),;
				mpcm.sname  with substr(alltrim(fitm.hsncode)+space(15),1,15)+ substr(alltrim(fitm.hsncode),1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
				mpcm.parnam with substr(alltrim(fitm.hsncode),1,15),;
				mpcm.tax with mitm.saltax,;
				mpcm.cgst with mitm.cgst,;
				mpcm.igst with mitm.igst,;
				mpcm.tcode with 'No'
		endif
		repl mitm.gcode6 with mpcm.scode
	else
		skip
	endif
	sele fitm
	skip
enddo
close data

@rowno,10 say '**** Importing Company  ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'company'+datatransferext
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to sgcode='ZZZZZZ'
dele all
pack
index on scode to mpcm

sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ',;
		mpcm.scode  with str(fpcm.rndid,6),;
		mpcm.sname  with upper(fpcm.name),;
		mpcm.parnam with upper(fpcm.name),;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
	sele fpcm
	skip
enddo
close data

if softtype='R'
	@rowno,10 say '**** Importing Salt/Composition ****' font 'Arial',12
	rowno=rowno+1
	fd=datatransferpath+'Drugform'+datatransferext
	td=datdev+'\saletype.'+datext
	sele a
	use &fd alias fpcm
	sele b
	use &td alias mpcm
	set filt to sgcode='SALT'
	dele all
	pack
	index on scode to mpcm

	sele fpcm

	go top
	do while .not. eof()
		sele mpcm
		append blank
		repl mpcm.sgcode with 'SALT',;
			mpcm.scode  with alltrim(str(fpcm.rndid,6)),;
			mpcm.sname  with upper(fpcm.content),;
			mpcm.parnam with upper(fpcm.content),;
			mpcm.tcode with 'No',;
			mpcm.tax with 1
		sele fpcm
		skip
	enddo

	close data
endif

@rowno,10 say '**** Importing Product Category ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'prodcat'+datatransferext
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to sgcode='CATEGO'
dele all
pack
index on scode to mpcm

sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO',;
		mpcm.scode  with alltrim(str(fpcm.rndid,6)),;
		mpcm.sname  with upper(fpcm.name),;
		mpcm.parnam with upper(fpcm.name),;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
	sele fpcm
	skip
enddo
close data

@rowno,10 say '**** Importing Area  ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'area'+datatransferext
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to sgcode='AREA  '
dele all
pack
index on scode to mpcm

sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA  ',;
		mpcm.scode  with str(fpcm.rndid,6),;
		mpcm.sname  with upper(fpcm.name),;
		mpcm.parnam with upper(fpcm.name),;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
	sele fpcm
	skip
enddo
close data
@rowno,10 say '**** Importing Batch  ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'batch'+datatransferext
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
sp=datdev+'\support.'+datext

sele sele(1)
use &sp alias support
dele all for type='#' and aliase='DAT/F-BT'
pack


sele a
use &fd alias fsbal
sele b
use &mi alias mitm
index on rackno2 to mitm
sele c
use &td alias msbal
zap
index on mycode + batchno to msbal

r=0
sele fsbal
go top
do while .not. eof()
  MOPENING=0 
  mbalance=0 
  mopening=iif(old_4='N',QTY,yendqty)
  mbalance=qty 
	dd  = '26'
	if len(alltrim(str(fsbal.expmonth,2)))=1
		mm = '0'+alltrim(str(fsbal.expmonth,2))
	else
		mm = alltrim(str(fsbal.expmonth,2))
	endif
	yy = alltrim(str(fsbal.expyear,4))
	edt = ctod(dd+'/'+mm+'/'+yy)

	sele mitm
	seek substr(str(fsbal.prodid,10)+space(10),1,10)

	sele msbal
	seek substr(str(fsbal.prodid,10)+space(20),1,20) + substr(fsbal.batchno+space(12),1,12)
	if .not. found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.pack with mitm.pack
		repl msbal.unit2 with mitm.unit2
		repl msbal.unit with mitm.unit
		repl msbal.decimal with 'Y'
		repl msbal.opening with mopening 
		repl msbal.balance with mbalance
		repl msbal.o_a with mopening
		repl msbal.b_a with mbalance
		repl msbal.tqty with (fsbal.qty)
		repl msbal.batchno with fsbal.batchno
		repl msbal.exp with edt
		repl msbal.prate with fsbal.purcprice
		repl msbal.lprate with fsbal.costprice
		repl msbal.ratea with fsbal.billprice
		repl msbal.rateb with fsbal.splprice
		repl msbal.ratec with fsbal.stkprice
		repl msbal.mrp with fsbal.mrp
		repl msbal.deal with fsbal.saleschqty
		repl msbal.free with fsbal.saleschfre
		repl msbal.purdeal with fsbal.purcschqty
		repl msbal.purfree with fsbal.purcschfre
		repl msbal.misc1 with mitm.gcode
		repl msbal.mycode with str(fsbal.prodid,10)
		repl msbal.supcode with str(fsbal.supid,6)
		repl msbal.supinvo with fsbal.purinvno
		repl msbal.supdat with fsbal.purdate
		repl msbal.purdis with fsbal.purdis
*     repl msbal.purexi with fsbal.purex
*      repl msbal.salexi with fsbal.salex


	else
		repl msbal.opening with msbal.opening + fsbal.qty,;
			msbal.balance with msbal.balance + fsbal.qty,;
			msbal.o_a with msbal.o_a + fsbal.qty,;
			msbal.b_a with msbal.b_a + fsbal.qty,;
			msbal.tqty with msbal.tqty + (fsbal.qty),;
			msbal.exp with edt,;
			msbal.lprate with fsbal.actcostpri,;
			msbal.prate with fsbal.purcprice,;
			msbal.rateh with fsbal.costprice,;
			msbal.ratea with fsbal.retprice,;
			msbal.rateb with fsbal.billprice,;
			msbal.ratec with fsbal.splprice,;
			msbal.rated with fsbal.stkprice,;
			msbal.mrp with fsbal.mrp,;
			msbal.deal with fsbal.saleschqty,;
			msbal.free with fsbal.saleschfre,;
			msbal.purdeal with fsbal.purcschqty,;
			msbal.purfree with fsbal.purfree,;
			msbal.misc1 with mitm.gcode,;
			msbal.mycode with str(fsbal.prodid,10),;
			msbal.supcode with str(fsbal.supid,6),;
			msbal.supinvo with fsbal.purinvno,;
			msbal.supdat with fsbal.purdate,;
			msbal.purdis with fsbal.purdis
*           msbal.purexi with fsbal.purex,;
*           msbal.salexi with fsbal.salex



	endif
	sele fsbal
	skip
enddo
sele msbal
repl all date with old_5-1 for balance = 0
close data

@rowno,10 say '**** Importing Account master ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'accounts'+datatransferext
fx=datatransferpath+'banks'+datatransferext
td=datdev+'\order.'+datext
ts=datdev+'\support.'+datext

sele e
use &fx alias fbnk
index on str(rndid,6) to fbnk

sele d
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup
dele all for aliase = 'ORDER   '
dele all for (sno=7 or sno=11 or sno=1)
dele all for (type='#' and aliase='DAT/F-LD')
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
	repl mact.price with 'A'
	repl mact.rate with 'N'
	if fact.subgroupid = 2
		repl mact.scode with 'D31'
		repl mact.rate with old_3
	else
		if fact.subgroupid = 1 .and. fact.identify = 'CASH'
			repl mact.scode with 'C1'
		else
			if fact.subgroupid = 1 .and. fact.identify = 'BANK'
				repl mact.scode with 'C2'
			else
				if fact.subgroupid = 3
					repl mact.scode with 'C6'
					repl mact.rate with old_3
				else
					if fact.subgroupid = 0 .or. fact.identify $ 'REP '
						repl mact.scode with 'D32'
					else
						repl mact.scode with 'J12'
					endif
				endif
			endif
		endif
	endif

*        mact.cstno with fact.Cstno,;

	repl mact.ordno with str(fact.rndid,6),;
		mact.parnam  with upper(fact.name),;
		mact.paradd with upper(alltrim(fact.add1))+'  '+ upper(alltrim(fact.add2)),;
		mact.paradd1 with upper(alltrim(fact.add3))+'  '+ upper(alltrim(fact.add4)),;
		mact.paradd2 with upper(alltrim(fact.city)),;
		mact.dsm with  fact.pin,;
		mact.sthed with  'TIN No.',;
		mact.csthed with 'CST No.',;
		mact.gstno with fact.gstin,;
		mact.itno with fact.panno,;
		mact.dlno with alltrim(fact.dlno1) +' * '+ alltrim(fact.dlno2),;
		mact.mailnam with upper(fact.name),;
		mact.ref with 'Mr.',;
		mact.phone1 with fact.phone,;
		mact.phone2 with iif(isnull(fact.cell),'',fact.cell) ,;
		mact.fax1 with fact.fax,;
		mact.confir with fact.conperson,;
		mact.price with 'A',;
		mact.city with fact.city,;
		mact.status with 'Y',;
		mact.adhed with 'Discount',;
		mact.area with str(fact.areaid,6),;
		mact.mr with str(fact.repid,6),;
		mact.opning with iif(mact.scode='D31',-fact.curbal,fact.curbal),;
		mact.limit with fact.maxamt

	if fact.billingon = 0
		repl mact.price with 'A'
	else
		if fact.billingon = 1
			repl mact.price with 'H'
		else
			if fact.billingon = 2
				repl mact.price with 'X'
			else
				if fact.billingon = 3
					repl mact.price with 'P'
				else
					if fact.billingon = 4
						repl mact.price with 'M'
					else
						if fact.billingon = 5
							repl mact.price with 'C'
						endif
					endif
				endif
			endif
		endif
	endif
	sele fbnk
	seek str(fact.bankid,6)
	repl mact.docu with substr(fbnk.name,1,25),;
		mact.docu with substr(mact.docu,1,25)

	sele msup
	seek 'ORDER   ' + ' 11' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 11

	if (fact.discfact #  0 )
		repl remark with substr(msup.remark,1,27)+str(100-fact.discfact,5,2)+substr(msup.remark,33,100)
	endif
	if (fact.discfact = 0 .or. fact.discfact = 100)
		repl remark with substr(msup.remark,1,27)+" 0.00"+substr(msup.remark,33,100)
	endif

	sele msup
	seek 'ORDER   ' + '  1' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 1
	repl remark with substr(msup.remark,1,70)+iif(fact.billtype=1,'R','C')+substr(msup.remark,71,100)
	repl remark with substr(msup.remark,1,51)+str(fact.maxdays,3)+substr(msup.remark,55,100)
	repl value with fact.maxbills

&& Updating State
	sele msup
	seek 'ORDER   ' + '  7' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(fact.gstin,1,2)='  ',mstatecode,subs(fact.gstin,1,2))+'                                           '

&& UPDATED SUPPORT FOR LEDGER  DIFFERENCE
	sele msup
	appe blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with  iif(mact.scode='D31',-fact.curbal,fact.curbal)

	sele fact
	skip
enddo
sele mact
appe blank 
repl scode with "J12" 
repl ordno with 'CN9999' 
repl mailnam with 'ADD/LESS in Purchase'
repl parnam with 'ADD/LESS in Purchase'
close data
@rowno,10 say '**** Importing Oustandings ****' font 'Arial',12
rowno=rowno+1
af=datdev+'\pend.'+datext
sele a
use &af alias mpend
zap
af=datdev+'\gledger.'+datext
sele a
use &af alias mpend
zap
af=datdev+'\dis.'+datext
sele a
use &af alias mpend
zap
af=datdev+'\mdis.'+datext
sele a
use &af alias mpend
zap

af=datdev+'\pendings.'+datext
bf=datdev+'\slipno.'+datext
cf=datatransferpath+'tranmain'+datatransferext
df=datatransferpath+'accounts'+datatransferext
ef=datdev+'\order.'+datext

sele e
use &ef alias mact
index on ordno to mact

sele d
use &df alias fact
set filt to subgroupid = 2 .or. subgroupid = 3
index on str(rndid,6) to fact


sele a
use &af alias mpend
zap
sele b
use &bf alias mslip
sele c
use &cf alias fout
set filt to  trantype $ 'S P ' .and. terms = 1
index on str(accid,6) to fout

go top

if old_3='Y'

	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10

	sele fact
	go top
	do while .not. eof()
		bl = 0
		sele fout
		seek str(fact.rndid,6)
		do while str(fout.accid,6) = str(fact.rndid,6) .and. .not. eof()
			sele mpend
			append blank
			repl mpend.acgroup with iif(fact.showtype = 1,'D31','C6'),;
				mpend.ord with str(fout.accid,6),;
				mpend.ddate with fout.feeddate,;
				mpend.vcn with fout.feedno,;
				mpend.invtype with 'O',;
				mpend.voucher  with vou,;
				mpend.svoucher with svou,;
				mpend.duedate with fout.feeddate,;
				mpend.duedays with duedate-ddate,;
				mpend.itemiss with fout.netamt-fout.paidamt
			if fout.trantype = 'S ' .and. (fout.netamt-fout.paidamt)#0
				repl mpend.itemope with 0,;
					mpend.final with fout.netamt-fout.paidamt,;
					mpend.balance with fout.netamt-fout.paidamt
			else
				if fout.trantype = 'P ' .and. (fout.netamt-fout.paidamt)#0
					repl mpend.itemope with 0,;
						mpend.final with -(fout.netamt-fout.paidamt),;
						mpend.balance with -(fout.netamt-fout.paidamt)
				endif
			endif
			repl mpend.name with mpend.vcn
			bl = bl + mpend.balance
			vou =vou+5
			svou=svou+5
			sele fout
			skip
		enddo

		sele mact
		seek str(fact.rndid,6)
		if found()
			repl mact.opning with bl
		endif

		sele fact
		?recno()
		skip
		
	enddo

	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5

endif
close data


proc marga
@rowno,10 say '**** Importing Product ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'product'+datatransferext
if mversion='V02'
	fh=datatransferpath+'hsnsac'+datatransferext
endif
td=datdev+'\pro.'+datext
ty=datdev+'\rate.'+datext
ts=datdev+'\saletype.'+datext

sele d
use &ts alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm

if mversion='V02'
	select e
	use &fh alias fhsn
	index on rndid to fhsn
endif
sele c
use &ty alias frat
index on code to frat
dele all for  type = '~'
pack
go top

sele a
use &fd alias fitm
sele b
use &td alias mitm
zap
index on name to mitm

sele fitm
go top
scan
	sele mitm
	append blank


	repl mitm.code with fitm.rndid
	repl mitm.name with iif(isnull(fitm.code),'',fitm.code)
	repl mitm.product with iif(isnull(fitm.name),'',upper(fitm.name))
	repl mitm.packing with upper(fitm.packing)
if isnull(fitm.name)
else	
	repl mitm.billname with upper(alltrim(fitm.name)) +'  '+ upper(alltrim(fitm.packing))
endif	
	repl mitm.unit with 'Pcs'
	repl mitm.rackno with fitm.rackno
	repl mitm.pack with fitm.boxqty
	repl mitm.gcode with str(fitm.comid,6)
	if softtype='R'
		repl mitm.gcode3 with alltrim(fitm.drugid)
	endif
	repl mitm.gcode5 with iif(isnull(fitm.catid),'',str(fitm.catid,6))

	repl mitm.taxl with 'T'
	repl mitm.taxc with 'T'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.minimum with fitm.saleminqty
	repl mitm.maximum with fitm.salemaxqty
	repl mitm.halfsche with 'H'
	repl mitm.qtrsche with 'Y'
	repl mitm.saltax with fitm.salegst/2
	repl mitm.cgst with fitm.salegst/2
	repl mitm.igst with fitm.salegst
	repl mitm.purtax with fitm.salegst
	repl mitm.status with iif(fitm.deleted = .t.,'N','Y')
	repl mitm.prate with fitm.purprice
	repl mitm.lprate with fitm.costprice
*  repl mitm.rateg with fitm.actcostpri
*	repl mitm.ratea with fitm.retprice
*	repl mitm.ratea with fitm.billprice
try
	repl mitm.rateb with fitm.splprice
	repl mitm.ratec with fitm.stkprice
	repl mitm.ratea with fitm.retprice
	repl mitm.mrp with fitm.mrp
catch
mError=1 
endtry	
*!*		repl mitm.deal with fitm.saleschqty
*!*		repl mitm.free with fitm.saleschqty
*!*		repl mitm.purdeal with fitm.purschqty
*!*		repl mitm.purfree with fitm.purschfree
	repl mitm.purdis with fitm.purdis
	repl mitm.margcode with str(fitm.rndid,10)
	
*	repl mitm.formulano with substr(formulano,1,25)+str(fitm.saledis,5,2)
	if mversion='V01'
		if old_7='G'
			sele mpcm
			seek 'COMMCD' + substr(alltrim(fitm.hsncode)+space(15),1,15) + str(mitm.igst,5,2)
			if !found()
				append blank
				repl mpcm.sgcode with 'COMMCD',;
					mpcm.scode  with 'C'+alltrim(str(recno())),;
					mpcm.sname  with substr(alltrim(fitm.hsncode)+space(15),1,15)+ substr(alltrim(fitm.hsncode),1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
					mpcm.parnam with substr(alltrim(fitm.hsncode),1,15),;
					mpcm.tax with mitm.saltax,;
					mpcm.cgst with mitm.cgst,;
					mpcm.igst with mitm.igst,;
					mpcm.tcode with 'No'
			endif
			repl mitm.gcode6 with mpcm.scode
		endif
	else
		if old_7='G'
			select fhsn
			seek fitm.hsnid
			sele mpcm
			seek 'COMMCD' + substr(fhsn.code+space(15),1,15) + str(mitm.igst,5,2)
			if !found()
				append blank
				repl mpcm.sgcode with 'COMMCD',;
					mpcm.scode  with 'H'+alltrim(str(recno())),;
					mpcm.sname  with substr(fhsn.code+space(15),1,15)+ substr(fhsn.code,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
					mpcm.parnam with substr(fhsn.code,1,15),;
					mpcm.tax with mitm.saltax,;
					mpcm.cgst with mitm.cgst,;
					mpcm.igst with mitm.igst,;
					mpcm.tcode with 'No'

			endif
			repl mitm.gcode6 with mpcm.scode
		endif
	endif
endscan
close data
@rowno,10 say '**** Importing Company  ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'company'+datatransferext
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to sgcode='ZZZZZZ'
dele all
pack
index on scode to mpcm
sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ',;
		mpcm.scode  with str(fpcm.rndid,6),;
		mpcm.sname  with upper(fpcm.name),;
		mpcm.parnam with upper(fpcm.name),;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
	sele fpcm
	skip
enddo
close data


if softtype='R'
	@rowno,10 say '**** Importing Salt/Composition ****' font 'Arial',12
	rowno=rowno+1
	fd=datatransferpath+'Drugform'+datatransferext
	td=datdev+'\saletype.'+datext
	sele a
	use &fd alias fpcm
	sele b
	use &td alias mpcm
	set filt to sgcode='SALT'
	dele all
	pack
	index on scode to mpcm

	sele fpcm

	go top
	do while .not. eof()
		sele mpcm
		append blank
		repl mpcm.sgcode with 'SALT',;
			mpcm.scode  with alltrim(str(fpcm.rndid,6)),;
			mpcm.sname  with upper(fpcm.content),;
			mpcm.parnam with upper(fpcm.content),;
			mpcm.tcode with 'No',;
			mpcm.tax with 1
		sele fpcm
		skip
	enddo

	close data
endif

@rowno,10 say '**** Importing Product Category ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'prodcat'+datatransferext
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to sgcode='CATEGO'
dele all
pack
index on scode to mpcm

sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO',;
		mpcm.scode  with alltrim(str(fpcm.rndid,6)),;
		mpcm.sname  with upper(fpcm.name),;
		mpcm.parnam with upper(fpcm.name),;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
	sele fpcm
	skip
enddo
close data

@rowno,10 say '**** Importing Area  ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'area'+datatransferext
td=datdev+'\saletype.'+datext
sele a
use &fd alias fpcm
sele b
use &td alias mpcm
set filt to sgcode='AREA  '
dele all
pack
index on scode to mpcm

sele fpcm
go top
do while .not. eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA  ',;
		mpcm.scode  with str(fpcm.rndid,6),;
		mpcm.sname  with upper(fpcm.name),;
		mpcm.parnam with upper(fpcm.name),;
		mpcm.tcode with 'No',;
		mpcm.tax with 1
	sele fpcm
	skip
enddo
close data
@rowno,10 say '**** Importing Batch  ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'batch'+datatransferext
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
sp=datdev+'\support.'+datext

sele sele(1)
use &sp alias support
dele all for type='#' and aliase='DAT/F-BT'
pack


sele a
use &fd alias fsbal

sele b
use &mi alias mitm
index on subs(margcode,1,15) to mitm
sele c
use &td alias msbal
zap
index on mycode + batchno to msbal

r=0
sele fsbal
go top
do while .not. eof()
*!*	   MOPENING=IIF(OLD_4='N',YENDQTY,QTY)
   mcode=subs(allt(str(prodid,15))+space(15),1,15)   
   mopening=purqty
   MBALANCE=QTY
	dd  = '26'
	if len(alltrim(str(fsbal.expmonth,2)))=1
		mm = '0'+alltrim(str(fsbal.expmonth,2))
	else
		mm = alltrim(str(fsbal.expmonth,2))
	endif
	yy = alltrim(str(fsbal.expyear,4))
	edt = ctod(dd+'/'+mm+'/'+yy)

	sele mitm
	seek mcode

	sele msbal
	seek substr(mcode+space(20),1,20) + substr(fsbal.batchno+space(12),1,12)
	if .not. found()
		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.packing with mitm.packing
		repl msbal.pack with mitm.pack
		repl msbal.unit2 with mitm.unit2
		repl msbal.unit with mitm.unit
		repl msbal.decimal with 'Y'
*		MQTY=IIF(ISNULL(FSBAL.VQTY),0,FSBAL.VQTY)
		mqty=0
*!*			if old_4='N'
*!*				if fsbal.purfeedno='OPB'
*!*					mqty=iif(isnull(fsbal.qty),0,fsbal.qty)
*!*				endif
*!*			else
*!*				mqty=iif(isnull(fsbal.vqty),0,fsbal.vqty)
*!*			endif
		mqty1=0 &&IIF(ISNULL(FSBAL.YENDQTY),0,FSBAL.YENDQTY)
		repl msbal.opening with MOPENING
		repl msbal.balance with MBALANCE
		repl msbal.o_a with MOPENING
		repl msbal.b_a with MBALANCE
		repl msbal.tqty with (fsbal.qty)
		repl msbal.batchno with fsbal.batchno
		repl msbal.exp with edt
		repl msbal.prate with fsbal.purcprice
		repl msbal.lprate with fsbal.costprice
*		repl msbal.rateA with fsbal.billprice
		repl msbal.rateb with fsbal.splprice
*!*			repl msbal.ratec with fsbal.stkprice
		repl msbal.ratea with fsbal.splprice

		repl msbal.mrp with fsbal.mrp
*!*			repl msbal.deal with fsbal.saleschqty
*!*			repl msbal.free with fsbal.saleschfre
*!*			repl msbal.purdeal with fsbal.purcschqty
*!*			repl msbal.purfree with fsbal.purfree
		repl msbal.misc1 with mitm.gcode
		repl msbal.mycode with str(fsbal.prodid,10)
		repl msbal.supcode with str(fsbal.supid,6)
		repl msbal.supinvo with fsbal.purinvno
		repl msbal.supdat with iif(isnull(fsbal.purdate),ctod(''),fsbal.purdate)
		repl msbal.purdis with fsbal.purdis

	else
		mqty=0
		if old_4='N'
			if fsbal.purfeedno='OPB'
				mqty=iif(isnull(fsbal.qty),0,fsbal.qty)
			endif
		else
			mqty=iif(isnull(fsbal.vqty),0,fsbal.vqty)
		endif
		mqty1=0 &&IIF(ISNULL(FSBAL.YENDQTY),0,FSBAL.YENDQTY)
		repl msbal.opening with msbal.opening + mqty,;
			msbal.balance with msbal.balance + mqty,;
			msbal.o_a with msbal.o_a + mqty,;
			msbal.b_a with msbal.b_a + mqty,;
			msbal.tqty with msbal.tqty + (fsbal.qty)

*!*			repl msbal.opening with msbal.opening + fsbal.vqty+fsbal.yendqty,;
*!*				msbal.balance with msbal.balance + fsbal.vqty+fsbal.yendqty,;
*!*				msbal.o_a with msbal.o_a + fsbal.vqty+fsbal.yendqty,;
*!*				msbal.b_a with msbal.b_a + fsbal.vqty+fsbal.yendqty,;
*!*				msbal.tqty with msbal.tqty + (fsbal.qty),;
*!*				msbal.exp with edt,;
*!*				msbal.lprate with fsbal.actcostpri,;
*!*				msbal.prate with fsbal.purcprice,;
*!*				msbal.rateh with fsbal.costprice,;
*!*				msbal.ratea with fsbal.retprice,;
*!*				msbal.rateb with fsbal.billprice,;
*!*				msbal.ratec with fsbal.splprice,;
*!*				msbal.rated with fsbal.stkprice,;
*!*				msbal.mrp with fsbal.mrp,;
*!*				msbal.deal with fsbal.saleschqty,;
*!*				msbal.free with fsbal.saleschfre,;
*!*				msbal.purdeal with fsbal.purcschqty,;
*!*				msbal.purfree with fsbal.purfree,;
*!*				msbal.misc1 with mitm.gcode,;
*!*				msbal.mycode with str(fsbal.prodid,10),;
*!*				msbal.supcode with str(fsbal.supid,6),;
*!*				msbal.supinvo with fsbal.purinvno,;
*!*				msbal.supdat with fsbal.purdate,;
*!*				msbal.purdis with fsbal.purdis

	endif



	sele fsbal
	skip
enddo
sele msbal
scan

	sele support
	append blank
	repl type with "#",aliase with "DAT/F-BT",lcode with "PROFTF",pcode with msbal.code,;
		heading with msbal.batchno ,value with msbal.tqty


endscan

sele msbal
repl all date with old_5-1 for balance = 0

close data

@rowno,10 say '**** Importing Account master ****' font 'Arial',12
rowno=rowno+1
fd=datatransferpath+'accounts'+datatransferext
fx=datatransferpath+'banks'+datatransferext
td=datdev+'\order.'+datext
ts=datdev+'\support.'+datext

sele e
use &fx alias fbnk
index on str(rndid,6) to fbnk

sele d
use &ts alias msup
index on aliase + str(sno,3) + lcode to msup
dele all for aliase = 'ORDER   '
dele all for aliase = 'LBTDETAI'
dele all for (type='#' and aliase='DAT/F-LD')
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
	repl mact.price with 'A'
	repl mact.rate with 'N'
	if fact.subgroupid = 2
		repl mact.scode with 'D31'
		repl mact.rate with old_3
	else
		if fact.subgroupid = 1 .and. fact.identify = 'CASH'
			repl mact.scode with 'C1'
		else
			if fact.subgroupid = 1 .and. fact.identify = 'BANK'
				repl mact.scode with 'C2'
			else
				if fact.subgroupid = 3
					repl mact.scode with 'C6'
					repl mact.rate with old_3
				else
					if fact.subgroupid = 0 .or. fact.identify $ 'REP '
						repl mact.scode with 'D32'
					else
						repl mact.scode with 'J12'
					endif
				endif
			endif
		endif
	endif
	repl mact.ordno with str(fact.rndid,6),;
		mact.parnam  with upper(fact.name),;
		mact.paradd with upper(alltrim(fact.add1))+'  '+ upper(alltrim(fact.add2)),;
		mact.paradd1 with upper(alltrim(fact.add3))+'  '+ upper(alltrim(fact.add4)),;
		mact.paradd2 with upper(alltrim(fact.city)),;
		mact.dsm with  fact.pin,;
		mact.sthed with  'TIN No.',;
		mact.csthed with 'CST No.',;
		mact.gstno with iif(isnull(fact.gstin),'',fact.gstin),;
		mact.itno with iif(isnull(fact.panno),'',fact.panno)
	mdlno=iif(isnull(fact.dlno1),"",fact.dlno1)+' '+iif(isnull(fact.dlno2),'',fact.dlno2)
	replace mact.dlno with mdlno,;
		mact.mailnam with upper(fact.name),;
		mact.ref with 'Mr.',;
		mact.phone1 with fact.phone,;
		mact.phone2 with iif(isnull(fact.cell),'',fact.cell),;
		mact.fax1 with fact.fax,;
		mact.confir with iif(isnull(fact.conperson),'',fact.conperson),;
		mact.price with 'A',;
		mact.city with fact.city,;
		mact.status with 'Y',;
		mact.adhed with 'Discount',;
		mact.area with iif(isnull(fact.areaid),'',str(fact.areaid,6)),;
		mact.mr with iif(isnull(fact.repid),'',str(fact.repid,6)),;
		mact.opning with fact.opbal,;
		mact.limit with fact.maxamt,;
		mact.balance with fact.curbal


	if fact.billingon = 0
		repl mact.price with 'A'
	else
		if fact.billingon = 1
			repl mact.price with 'H'
		else
			if fact.billingon = 2
				repl mact.price with 'X'
			else
				if fact.billingon = 3
					repl mact.price with 'P'
				else
					if fact.billingon = 4
						repl mact.price with 'M'
					else
						if fact.billingon = 5
							repl mact.price with 'C'
						endif
					endif
				endif
			endif
		endif
	endif
	sele fbnk
	seek str(fact.bankid,6)
	repl mact.docu with substr(fbnk.name,1,25),;
		mact.docu with substr(mact.docu,1,25)

	sele msup
	seek 'ORDER   ' + ' 11' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 11

	if (fact.discfact #  0 )
		repl remark with substr(msup.remark,1,27)+str(100-fact.discfact,5,2)+substr(msup.remark,33,100)
	endif
	if (fact.discfact = 0 .or. fact.discfact = 100)
		repl remark with substr(msup.remark,1,27)+" 0.00"+substr(msup.remark,33,100)
	endif

	sele msup
	seek 'ORDER   ' + '  1' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 1
	repl remark with substr(msup.remark,1,70)+iif(fact.billtype=1,'R','C')+substr(msup.remark,71,100)
	repl remark with substr(msup.remark,1,51)+str(fact.maxdays,3)+substr(msup.remark,55,100)
	repl value with fact.maxbills

&& Updating State
	sele msup
	seek 'ORDER   ' + '  7' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
&& LOCAL && CENTRAL  MARK IN LEDGER.
	select msup
	appe blan
	repl aliase with 'LBTDETAI'
	repl type with 'F'
	repl lcode with mact.ordno
	repl heading with iif(subs(mact.gstno,1,2)=mstatecode or subs(mact.gstno,1,2)='  ','   ','L            ON          ')
	appen blan
	repl type with 'F',aliase with 'ORDER',lcode with mact.ordno,sno with 12
	repl  heading with iif(len(alltrim(mact.gstno))=0,'                00000UG  ','                00000NG  ')

	sele msup
	appe blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with  mact.balance && updated by Nivedan sharma


	sele fact
	skip
enddo
sele mact
appen blank
repl scode with 'J12'
repl ordno with 'PR9999'
repl parnam with "PURCHASE ADJUSTMENTS"
repl mailnam with "PURCHASE ADJUSTMENTS"
close data
close table all


@rowno,10 say '**** Importing Outsandings ****' font 'Arial',12
rowno=rowno+1
af=datdev+'\pend.'+datext
sele a
use &af alias mpend
zap
af=datdev+'\gledger.'+datext
sele a
use &af alias mpend
zap
af=datdev+'\dis.'+datext
sele a
use &af alias mpend
zap
af=datdev+'\mdis.'+datext
sele a
use &af alias mpend
zap
sele sele(1)
use &datatransferpath\accitems alias led
index on accid to led
sele sele(1)
use &datdev\support.&datext alias support

sele sele(1)
use &datatransferpath\accinv alias oinv
index on feedno+DTOC(FEEDDATE)  to oinv

af=datdev+'\pendings.'+datext
bf=datdev+'\slipno.'+datext
cf=datatransferpath+'tranmain'+datatransferext
df=datatransferpath+'accounts'+datatransferext
ef=datdev+'\order.'+datext

sele e
use &ef alias mact
index on ordno to mact

sele d
use &df alias fact
set filt to subgroupid = 2 .or. subgroupid = 3
index on str(rndid,6) to fact


sele a
use &af alias mpend
zap
sele b
use &bf alias mslip
sele c
use &cf alias fout
set filt to feeddate < old_5 .and. trantype $ 'S P ' .and. terms = 1 &&&AND ACCID=8268   &&'HERE-1 SANTOSH'
index on str(accid,6) to fout
go top
if old_3='Y'
	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10

	sele fact
	go top
	do while .not. eof()
		bl = 0
		sele fout
		seek str(fact.rndid,6)
		do while str(fout.accid,6) = str(fact.rndid,6) .and. .not. eof()
			sele mpend
			appe blan
			repl mpend.acgroup with iif(fact.showtype = 1,'D31','C6'),;
				mpend.ord with str(fout.accid,6),;
				mpend.ddate with fout.feeddate,;
				mpend.vcn with fout.feedno,;
				mpend.invtype with 'O',;
				mpend.voucher  with vou,;
				mpend.svoucher with svou,;
				mpend.duedate with fout.feeddate,;
				mpend.duedays with duedate-ddate
			sele oinv
			seek subs(fout.feedno+space(20),1,20)+DTOC(FOUT.FEEDDATE)
			sum rcvdamt to tot FOR RCVDDATE<OLD_5 while feedno+DTOC(FEEDDATE)=subs(fout.feedno+space(20),1,20)+DTOC(FOUT.FEEDDATE)
			sele mpend
			if alltrim(fout.trantype)='S' &&&&.And. (fout.netamt-fout.paidamt)#0
				repl mpend.itemope with tot,;
					mpend.final with fout.netamt,;
					mpend.balance with FOUT.netamt-tot
			else
				if alltrim(fout.trantype) = 'P' &&.And. (fout.netamt-fout.paidamt)#0
				   IF TOT=0
				      tot=fout.paidamt
				   endif   
					repl mpend.itemope with -tot,;
						 mpend.final with -(fout.netamt),;
						 mpend.balance with -(fout.netamt-tot)
				endif
			endif
			repl mpend.name with mpend.vcn
			if fact.rndid=8268
			endif
			bl = bl + mpend.balance
			vou =vou+5
			svou=svou+5
			sele fout
			skip
		enddo

		sele fact
		skip
	enddo
	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5
endif
close data


@rowno,10 say '**** Ledger Transaction ****' font 'Arial',12
rowno=rowno+1
mdis=datdev+'\mdis.'+datext
af =datdev +'\gledger.'+datext
bf =datdev +'\slipno.'+datext
dis=datdev +'\dis.'+datext
pro=datdev +'\pro.'+datext
prb=datatransferpath+'batch'+datatransferext
cf =datatransferpath+'xxled09'+datatransferext
sal=datatransferpath+'tranmain'+datatransferext
pur=datatransferpath+'tranmain'+datatransferext
sld=datatransferpath+'tranitem'+datatransferext
sele sele(1)
use &sp alias support
dele all for type='#'  and aliase="DAT/F-PM"
pack
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

sele i
use &bf
go top
last4  = voucher + 10
slast5 = svoucher + 10


last4 = last4 + 20
sele f
use &prb alias prb
index on rndid to prb

sele e
use &pro alias pro
index on str(code,9) to pro

sele c
use &sal alias sal
set filter to invdate>=old_5 and invdate<=old_6
sele h
use &sld alias sld
index on tranid to sld

sele d
use &mdis alias mdis
zap
sele g
use &dis alias dis
zap
sele c

**Old
**S- Sales
**N- Stock Less
**G- Self Expiry / Breakage
**H- Sales on special Rate
**O- Delevery Challan (Sales)

**New
*S- Sales
*H- Challan
*N- Transfer Out
*I- Performa Invoice
*X- Special Rate
@rowno,10 say '**** Importing Sales Return ****' font 'Arial',12
rowno=rowno+1
last4=last4+20
**SR- Sales Return
sele c
use &pur alias pur
set filt to trantype = 'SR' .and. feeddate >= old_5 .and. feeddate <= old_6
go top
do while .not. eof()
	last1 = c.rndid

	sele d
	appe blank
*  repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl type with 'R'
	repl godwon with 'A'
	repl vcn with c.feedno
	repl date with c.feeddate
	repl pm with c.feedno
	repl lrda with c.feeddate
	repl codep with str(c.accid,6)
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.netamt)
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl othun with old_12
	repl other with c.adjust
	repl packing with c.debitamt-c.creditamt
	repl pacun with str(c.accid,6)
	if c.terms = 0
		repl cash with c.netamt
		repl round with c.rounding
	else
		repl final with c.netamt
		repl round with c.rounding
	endif

	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
*	repl addis with c.disper
*	repl mr with str(c.repid,6)
	repl duedays with 0
	repl account with 'N'
	repl sale with 'Z'
	repl ltype with scalc   &&'5'
	repl discafter with 'N'
	repl remark4 with c.feedno
	repl remark1 with str(c.netamt,12,2)
&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	repl d.misc3 with subs(d.misc3,1,54)+str(c.sumdis,10,2)+subs(d.misc3,65)
	repl d.misc3 with subs(d.misc3,1,78)+"#"+subs(d.misc3,80)

	mdisctype=0
	if round(c.sumdis,2)=round(c.subtotal*c.disper*0.01,2) or round(c.sumdis,0)=round(c.subtotal*c.disper*0.01,0)
		mdisctype=1
	endif

	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-PM",pcode with mdis->voucher,value with mdis->final+mdis->cash
sele mdis	
ISIGST=0
IF SUBS(C.GSTIN,1,2)#MSTATECODE AND len(allt(c.gstin))#0 
         repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
         isigst=1
endif     
	sele h
	seek last1
	do while .not. eof() .and. h.tranid = last1
		if comment='N'
			skip
			loop
		endif
		dd  = '26'
		if len(alltrim(str(f.expmonth,2)))=1
			mm = '0'+alltrim(str(f.expmonth,2))
		else
			mm = alltrim(str(f.expmonth,2))
		endif
		yy = alltrim(str(f.expyear,4))
		edt = ctod(dd+'/'+mm+'/'+yy)

		last = h.prodid

		sele f
		seek h.batchid


		sele e
		seek str(last,9)

		sele g
		appe blank
		repl codep with d.codep
		repl vcn with d.vcn
		repl date with d.date
		repl voucher with d.voucher
		repl code with e.code
		repl tax with 'T'&&iif(h.stper=0,'E','T')
		repl qty with abs(h.qty)
		repl free with abs(h.free)
		repl exp with edt
		repl batch with f.batchno
		repl flg with iif(h.mark='Y','R','W')
		repl godwon with iif(h.mark='Y','A','Y')
		repl rate with h.rate
*		repl disc1 with h.disper
		repl disc1 with iif(mdisctype=1,c.disper,h.disper) &&iif(c.disper#0,c.disper,h.disper)
*!*	IF H.disper=0 and h.provalue#h.taxvalue 
*!*	     repl svdis with h.provalue-h.taxvalue 
*!*	     repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,45)
*!*	     
*!*	endif     
		repl pack with iif(softtype='R',e.pack,0)
		if old_7='G'
		   if isigst=1
		     repl ssta with h.gstper 
		   else  
			repl ssta with h.gstper/2
			repl cgst with h.gstper/2
		   endif	
		else
			repl ssta with h.stper
			repl sssc with h.cstper
		endif
		repl ssex with 0
		repl mrp with f.mrp
		repl half with 'A'
		repl addis with mdis.addis
		sele h
		skip
	enddo
	sele c
	skip
enddo

@rowno,10 say '**** Importing Sales ****' font 'Arial',12
rowno=rowno+1

sele c

*set filt to trantype $ 'S H N I X G A ' .and. feeddate >= old_5
set filt to trantype $ 'S H N I X G A R ' .and. feeddate >= old_5
*BROW FOR FEEDNO='SC'
go top
do while .not. eof()
	last1=c.rndid
	sele d
	appe blank
*  repl misc3 with substr(misc3,1,53)+iif(substr(c.billno_sm,1,1)='T','T','R')+substr(misc3,55,100)
	if c.trantype $ 'S H X R '
		repl type with 'S'
		if c.trantype $ 'S R '
			repl vcn with c.feedno
			repl date with c.feeddate
		else
			if c.trantype $ 'H '
				repl challan with c.feedno
				repl chdate with c.feeddate
			endif
		endif
*     if c.trantype = 'N '
*        repl misc3 with substr(misc3,1,64)+'Y'+substr(misc3,66,200)
*      endif
	else
		if c.trantype $ 'N I A '
			repl type with iif(c.trantype='I','v','L')
			repl challan with c.feedno
			repl chdate with c.feeddate
		endif
	endif
	repl codep with iif(c.trantype='G ','STACsl',str(c.accid,6))
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.netamt)
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl othun with old_12
	repl other with c.adjust
*	Repl packing With c.debitamt-c.creditamt
	repl pacun with str(c.accid,6)
	if c.terms = 0
		repl cash with (c.netamt+c.creditamt)
		repl round with c.rounding
	else
		repl final with (c.netamt+c.creditamt)
		repl round with c.rounding
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
*!*		if c.disfact#0 and c.disfact<1
*!*			repl addis with round(c.disper*c.disfact,2)
*!*		else
*!*			repl addis with c.disper
*!*		endif
*   repl mr with str(c.repid,6)
	repl duedays with 0
	repl lrno with iif(isnull(c.lrno),'',c.lrno)
	repl account with 'N'
	repl sale with 'Z'
	repl godwon with 'A'
	repl ltype with iif(c.billingon=4,'9',scalc)  &&'5'
	repl discafter with 'N'
	repl remark4 with c.feedno
	repl remark1 with str(c.netamt+c.creditamt,12,2)
if isnull(c.tcname)
else	
	repl docu with space(10)+c.tcname
endif	
	if c.creditamt#0
		repl crno with -c.creditamt
		repl crnorem with subs(c.comment,at('.s :',c.comment)+5)
		repl pm with subs(c.comment,at('.s :',c.comment)+5)
	endif
	repl d.misc3 with subs(d.misc3,1,78)+"#"+subs(d.misc3,80)
	repl d.misc3 with subs(d.misc3,1,54)+str(c.sumdis,10,2)+subs(d.misc3,65)
	repl sale with 'ZYNY G YUN1N1INN'
	mdisctype=0
	if round(c.sumdis,2)=round(c.subtotal*c.disper*0.01,2) or round(c.sumdis,0)=round(c.subtotal*c.disper*0.01,0)
		mdisctype=1
	endif
sele mdis	
ISIGST=0
IF SUBS(C.GSTIN,1,2)#MSTATECODE AND len(allt(c.gstin))#0 
    repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
         isigst=1
endif     

&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-PM",pcode with mdis->voucher,value with mdis->final+mdis->cash

	sele h
	seek c.rndid
	do while h.tranid = c.rndid .and. .not. eof()

		last = h.prodid

		sele f
		seek h.batchid

		dd  = '26'
		if len(alltrim(str(f.expmonth,2)))=1
			mm = '0'+alltrim(str(f.expmonth,2))
		else
			mm = alltrim(str(f.expmonth,2))
		endif
		yy = alltrim(str(f.expyear,4))
		edt = ctod(dd+'/'+mm+'/'+yy)

		sele e
		seek str(last,9)

		sele g
		appe blank
		repl codep with d.codep

		if c.trantype $ 'S H X R '
			repl flg with iif((h.qty+h.free)>0,'G','R')
			if c.trantype $ 'S R '
				repl vcn with d.vcn
				repl date with d.date
			else
				if c.trantype $ 'H '
					repl vcn with d.challan
					repl date with d.chdate
				endif
			endif
		else
			if c.trantype $ 'N I A '
				repl flg with iif(d.type='v','X','L')
				repl vcn with d.challan
				repl date with d.chdate
			endif
		endif

		repl voucher with d.voucher
		repl code with e.code
		repl tax with iif(h.gstper=0,'E','T')
		repl qty with abs(h.qty)
		repl free with abs(h.free)
		repl exp with edt
		repl batch with f.batchno
		repl rate with h.rate
		repl disc1 with h.disper
		repl pack with iif(softtype='R',e.pack,0)
*!*	IF H.disper=0 and h.provalue#h.taxvalue 
*!*	     repl svdis with h.provalue-h.taxvalue 
*!*	     repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,45)
*!*	     
*!*	endif     

		if old_7='G'
		   if isigst=1
		     repl ssta with h.gstper
		   else  
			  repl ssta with h.gstper/2
			  repl cgst with h.gstper/2
		   endif	  
		else
			repl ssta with h.stper
			repl sssc with h.cstper
		endif
		repl disc1 with iif(mdisctype=1,c.disper,h.disper) &&iif(c.disper#0,c.disper,h.disper)

*        REPL ADDIS WITH MDIS.ADDIS

		repl ssex with 0
		repl mrp with f.mrp
		repl half with 'A'
		repl godwon with d.godwon
		sele h
		skip
	enddo
	sele c
	skip
enddo

@rowno,10 say '**** Importing Purchase ****' font 'Arial',12
rowno=rowno+1
last4=last4+20
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord
sele sele(1)
use &datdev\subdis.&datext alias subdis

sele c
use &pur alias pur
**P-Purchase
**A-Stock Adjustment
**V-Stock In "I"
**C-Challan Purchase

**New
**P- Purchase
**W- Purchase Challan
**V- Transfer Out


set filt to trantype $ 'P W V ' .and. feeddate >= old_5 .and. feeddate <= old_6
go top
do while .not. eof()

	last1 = c.rndid

	sele d
	appe blank
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl godwon with 'A'
	if c.trantype $ 'P W '
		repl type with 'P'
		if c.trantype $ 'P '
			repl vcn with c.feedno
			repl date with c.INVDATE &&&feeddate
			repl lrda with c.FEEDdate
			repl pm with c.invno
		else
			if c.trantype $ 'W '
				repl challan with c.feedno
				repl chdate with c.feeddate
				repl lrda with c.invdate
				repl pm with c.invno
			endif
		endif
	else
		if c.trantype $ 'V '
			repl type with 'D'
			repl challan with c.feedno
			repl chdate with c.feeddate
			repl lrda with c.invdate
			repl pm with c.invno
		endif
	endif
	repl codep with str(c.accid,6)
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.netamt)
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl othun with old_13
	repl other with c.adjust
	repl packing with -c.debitamt &&&-c.creditamt
	repl pacun with "PU9999"
    repl freun with 'CN9999' 
    repl freight with pur.creditamt 
	if c.terms = 0
		repl cash with c.netamt
		repl round with c.rounding
	else
		repl final with c.netamt
		repl round with c.rounding
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
*!*		repl addis with c.disper
	repl duedays with 0
	repl account with 'N'
	repl sale with 'Z'
	repl ltype with pcalc &&  '5'
	repl discafter with 'N'
	repl remark4 with c.feedno
	repl remark1 with str(c.netamt,12,2)
&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	repl d.misc3 with subs(d.misc3,1,78)+"#"+subs(d.misc3,80)
	repl d.misc3 with subs(d.misc3,1,54)+str(c.sumdis,10,2)+subs(d.misc3,65)
ISIGST=0
IF SUBS(C.GSTIN,1,2)#MSTATECODE AND len(allt(c.gstin))#0 
         repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
         isigst=1
endif     

	xfieldno=check_field('TCSAMT','MDIS','C')
	if xfieldno>0
		if c.tcsamt#0
			sele subdis
			=seek(mdis.codep,'ord')
			sele subdis
			appen blan
			repl codep with mdis.codep
			repl vcn with mdis.vcn
			repl date with mdis.date
			repl voucher with mdis.voucher
			repl type with '9'
			repl dsm with 'RETTCS'
			repl rtqt with str(c.tcsamt,10,2)+' '+iif(len(alltrim(ord.itno))#0,'0.075','0.100')
		endif
	endif

	mdisctype=0
	if round(c.sumdis,2)=round(c.subtotal*c.disper*0.01,2) or round(c.sumdis,0)=round(c.subtotal*c.disper*0.01,0)

		mdisctype=1
	endif

	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-PM",pcode with mdis->voucher,value with mdis->final+mdis->cash

	sele h
	seek c.rndid
	do while h.tranid = c.rndid .and. .not. eof()
		last = prodid

		sele f
		seek h.batchid

		dd  = '26'
		if len(alltrim(str(f.expmonth,2)))=1
			mm = '0'+alltrim(str(f.expmonth,2))
		else
			mm = alltrim(str(f.expmonth,2))
		endif
		yy = alltrim(str(f.expyear,4))
		edt = ctod(dd+'/'+mm+'/'+yy)


		sele e
		seek str(last,9)

		sele g
		appe blank
		repl codep with d.codep
		if c.trantype $ 'P W '
			repl vcn with d.vcn
			repl date with d.date
			repl flg with 'P'
			if (h.qty+h.free) < 0
				repl flg with 'B'
			endif
		else
			if c.trantype $ 'V '
				repl vcn with d.challan
				repl date with d.chdate
				repl flg with 'D'
				if (h.qty+h.free) < 0
					repl flg with 'B'
				endif
			endif
		endif
		repl voucher with d.voucher
		repl code with e.code
		repl tax with iif(h.gstper=0,'E','T')
		repl qty with abs(h.qty)
		repl free with abs(h.free)
		repl exp with edt
		repl batch with f.batchno
		repl rate with h.rate
		repl disc1 with iif(mdisctype=1,c.disper,h.disper) &&iif(c.disper#0,c.disper,h.disper)

		repl pack with iif(softtype='R',e.pack,0)

		if old_7='G'
		  if isigst=1
		    repl ssta with h.gstper
		  else
			repl ssta with h.gstper/2
			repl cgst with h.gstper/2
	      endif		
		else
			repl ssta with h.stper
			repl sssc with h.cstper
			repl ssex with f.purex+f.purad
		endif


		repl mrp with f.mrp
		repl half with 'A'
		repl godwon with d.godwon
*!*			repl addis with mdis.addis
*       if f.purex+f.purad#0
*          repl d.ltype with '3'
*       endif
		sele h
		skip
	enddo
	sele c
	skip
enddo
@rowno,10 say '**** Importing Purchase Return ****' font 'Arial',12
rowno=rowno+1
last4=last4+20
*TP- Purchase Return
sele c
use &pur alias pur
set filt to trantype = 'TP' .and. feeddate >= old_5  .and. feeddate <= old_6
go top
do while .not. eof()
	last1 = c.rndid

	sele d
	appe blank
*  repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl type with 'B'
	repl godwon with 'A'
	repl vcn with c.feedno
	repl date with c.feeddate
	repl codep with str(c.accid,6)
	repl voucher with last4
	last4=last4+5
	repl amountp with (c.netamt)
	repl salun with ''
	repl staxun with 'SZTZOZ'
	repl othun with old_13
	repl other with c.adjust
	repl packing with c.debitamt-c.creditamt
	repl pacun with str(c.accid,6)
	if c.terms = 0
		repl cash with c.netamt
		repl round with c.rounding
	else
		repl final with c.netamt
		repl round with c.rounding
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl addis with c.disper
	repl duedays with 0
	repl account with 'N'
	repl sale with 'Z'
	repl ltype with pcalc   &&'5'
	repl discafter with 'N'
	repl remark4 with c.feedno
	repl remark1 with str(c.netamt,12,2)

	repl d.misc3 with subs(d.misc3,1,78)+"#"+subs(d.misc3,80)
	repl d.misc3 with subs(d.misc3,1,54)+str(c.sumdis,10,2)+subs(d.misc3,65)

	mdisctype=0
	if round(c.sumdis,2)=round(c.subtotal*c.disper*0.01,2) or round(c.sumdis,0)=round(c.subtotal*c.disper*0.01,0)

		mdisctype=1
	endif

&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-PM",pcode with mdis->voucher,value with mdis->final+mdis->cash

	sele h
	seek c.rndid
	do while h.tranid = c.rndid .and. .not. eof()

		last = h.prodid

		sele f
		seek h.batchid

		dd  = '26'
		if len(alltrim(str(f.expmonth,2)))=1
			mm = '0'+alltrim(str(f.expmonth,2))
		else
			mm = alltrim(str(f.expmonth,2))
		endif
		yy = alltrim(str(f.expyear,4))
		edt = ctod(dd+'/'+mm+'/'+yy)

		sele e
		seek str(last,9)

		sele g
		appe blank
		repl codep with d.codep
		repl vcn with d.vcn
		repl date with d.date
		repl voucher with d.voucher
		repl code with e.code
		repl tax with 'T'&&iif(h.stper=0,'E','T')
		repl qty with abs(h.qty)
		repl free with abs(h.free)
		repl exp with edt
		repl batch with f.batchno
		repl flg with iif(h.mark=' ','B','Q')
		repl godwon with iif(h.mark=' ','A','Y')
		repl rate with h.rate
*		repl disc1 with h.disper
		repl disc1 with iif(mdisctype=1,c.disper,h.disper) &&iif(c.disper#0,c.disper,h.disper)

		repl pack with iif(softtype='R',e.pack,0)

		if old_7='G'
			repl ssta with h.gstper/2
			repl cgst with h.gstper/2
		else
			repl ssta with h.stper
			repl sssc with h.cstper
			repl ssex with f.purex+f.purad
		endif

		repl mrp with f.mrp
		repl half with 'A'
*!*	       if f.purex+f.purad#0
*!*	          repl d.ltype with '3'
*!*	       endif
		sele h
		skip
	enddo
	sele c
	skip
enddo
close data




@rowno,10 say '**** Importing Account from Sales ****' font 'Arial',12
rowno=rowno+1
af      = datdev+'\gledger.'+datext
pend    = datdev+'\pend.'+datext
mdis    = datdev+'\mdis.'+datext
pending = datdev+'\pendings.'+datext
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
set filt to type='R'
sele d
go top
do while .not. eof()
*!*	   if ALLTRIM(codep)#'5772'
*!*	       skip
*!*	       loop
*!*	   endif    &&&&Here-  Santosh
	if vcn=space(12)
		skip
		loop
	endif
	last1 = mdis.codep
	if mdis.final#0
		sele b
		appe blank
		repl voucher with mdis.voucher
		repl cd with 'C'
		repl credit with mdis.final
		repl book with 'E'
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
			repl final with -mdis.final
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
		repl cd with 'C'
		repl credit with mdis.cash
		repl date with mdis.date
		repl code with 'STACO3'
		last1='STACO3'
		repl remark1 with mdis.vcn
		repl book with 'E'
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
		repl cd with 'D'
		repl debit with (mdis.final+mdis.cash)
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

*********sales
sele d
set filt to type#'R'
go top
do while .not. eof()
*!*	   if ALLTRIM(codep)#'5772'
*!*	       skip
*!*	       loop
*!*	   endif    &&&&Here-  Santosh
*!*	   BROW
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
			if d.type $ 'S'
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
				repl final with round(mdis.final+mdis.crno,0)
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
			if d.type='S' and d.crno#0
				sele f
				appe blank
				repl ord with mdis.codep
				repl ddate with mdis.date
				repl duedays with mdis.duedays
				repl vcn with mdis.vcn
				repl final with abs(mdis.crno)
				repl type with 'A'
				repl voucher with mdis.voucher
				sele g
				seek mdis.codep+subs(mdis.crnorem+space(20),1,20)
				if found()
					sele f
					repl adjvoucher with g.voucher
					repl svoucher with g.svoucher
				endif
			endif
		endif
	endif
	if mdis.cash#0
		sele b
		append blank
		repl voucher with mdis.voucher
		if d.type = 'P'
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
		append blank
		repl voucher with mdis.voucher
		if d.type#'P'
			repl cd with 'C'
			repl credit with (mdis.final + mdis.cash)
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

close data
close table all

@rowno,10 say '**** Importing Account Transaction ****' font 'Arial',12
rowno=rowno+1
af      = datdev +'\gledger.'+datext
bf      = datdev +'\slipno.'+datext
cf      = datatransferpath+'acchead'+datatransferext
ef      = datatransferpath+'accitems'+datatransferext
df      = datatransferpath+'accinv'+datatransferext
pend    = datdev+'\pend.'+datext
pending = datdev+'\pendings.'+datext
sele g
use &pending alias pending
index on ord + substr(name,1,12) to rou2
last4  = last4 + 10
slast5 = slast5 + 10

sele d
use &df alias oinv
index on str(aheadid,9) + feedno to oinv

sele a
use &cf alias led
set filter to feeddate>=old_5 .and. feeddate<=old_6
copy to led1

sele f
use &pend alias pend
sele b
use &af alias gledger

sele e
use &ef alias ldd
index on str(aheadid,9) + str(accid,6) to ldd

*Modular
*CQ -
*CT- Credit Note (Mannual)
*DT- Debit Note (Mannual)
*CV- Payment Voucher to Supplier
*JV- Journal Voucher
*OR- Receipt Voucher
*P - Puchase (Mannual)
*RC- Receipt from customer
*RR- Receipt from customer
*S - Sales (Mannual)
*CE- Contra Voucher
*OP- Payment Voucher
*OA- Outstanding Adjustment (Customer)
*SA- Outstanding Adjustment (Supplier)

*MegaSoft
*CR-Cheque Return
*CV-Contra Voucher
*P -Purchase
*RS-Receipt
*RV-Receipt Voucher
*S - Sales

**New
*RS- Receipt
*RV- Receipt
*PA- Payment
*PV- Payment
*CV- Contra
*DN- Debit Note
*CN- Credit Note
*SU- Sales
*PU- Purchase
*OJ- Journal


sele c
use led1 alias led1
index on feedno + str(accid,6) to led1

sele a
index on str(rndid,9) to led
set filt to trantype $ 'RSRVPAPVCVDNCNSUPUOJORJVCR' .and.  feeddate >= old_5 .and.  feeddate <= old_6   &&&&& AND RNDID=82419
*BROW FOR ACCID=2650

go top
last3= '%%%%%%%%%'
do while .not. eof()
	if last3 # str(a.rndid,9)
		last4 = last4+4
	endif
	last3 = str(a.rndid,9)

	sele e
	seek str(a.rndid,9)
	xacc = '$$$$$$'
	do while str(e.aheadid,9) = str(a.rndid,9) .and. .not. eof()
		if a.trantype='RS'
			if accid=11 or amount=a.disamt
				skip
				loop
			endif
		endif

		if xacc # str(e.accid,6)
			sele b
			append blank
			repl voucher with last4
			if e.dctype = 'C'
				repl cd with 'C'
				repl credit with abs(e.amount)
			else
				if e.dctype = 'D'
					repl cd with 'D'
					repl debit with abs(e.amount)
				endif
			endif
			repl date with a.feeddate
			repl code with str(e.accid,6)
  if isnull(a.chqno)
  else			
			repl remark1 with a.comment + ' '+alltrim(a.chqno)
			repl addfield1 with a.chqno
			repl addfield2 with a.chqno
  endif			
			repl vcsno with a.feedno

*RS- Receipt
*RV- Receipt
*PA- Payment
*PV- Payment
*CV- Contra
*DN- Debit Note
*CN- Credit Note
*SU- Sales
*PU- Purchase
*OJ- Journal
			if a.trantype = 'JV'
				repl book with 'J'
			else
**Contra
				if a.trantype = 'CV'
					repl book with 'C'
				else
**Payment
					if (a.trantype = 'PA' .or. a.trantype = 'PV')
						repl book with 'P'
					else
**Receipt
						if (a.trantype = 'OR' .or. a.trantype = 'RS' .or. a.trantype = 'RV')
							repl book with 'R'
						else
**Credit Note
							if a.trantype = 'CN'
								repl book with 'E'
							else
**Debit Note
								if a.trantype = 'DN'
									repl book with 'D'
								else
**Purchase
									if a.trantype = 'P '
										repl book with 'A'
									else
**Sales
										if a.trantype = 'S '
											repl book with 'S'
									    else
									       if a.trantype='CR'
									          repl book with 'P'
									       endif   		
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif
			if old_3='Y'
				if (b.book='R'  and b.credit#0) or (b.book='P' and b.debit#0)  &&&&Receipts AND
					if (a.trantype = 'OR' .or. a.trantype = 'S' .or. a.trantype = 'RC' .or. a.trantype = 'RS' .or. a.trantype = 'RR' .or. a.trantype = 'CV' .or. a.trantype = 'OP')    &&(a.trantype = 'RSPAOR')
						sele d
						seek str(e.aheadid,9)
						do while str(d.aheadid,9) = str(e.aheadid,9) .and. .not. eof()
							sele c
							seek d.feedno + str(a.accid,6)
*!*							?d.feedno + str(a.accid,6)
*!*							?found()
*!*							wait wind 'HERE-1'
							sele f
							appe blank
							repl ord with b.code
							repl ddate with b.date
							repl vcn with d.feedno
							if d.rcvdamt#0 .and. (a.subtotal = e.amount)
								if e.dctype = 'C'
									repl final with -d.rcvdamt
								else
									if e.dctype = 'D'
										repl final with d.rcvdamt
									endif
								endif
							endif
							if d.disamt#0 .and. (a.disamt = e.amount)
								if e.dctype = 'C'
									repl final with -d.disamt
								else
									if e.dctype = 'D'
										repl final with d.disamt
									endif
								endif
							endif
							repl voucher with b.voucher
							sele g
							seek f.ord+substr(f.vcn,1,12)
							if found()
								sele f
								repl type with 'A'
								repl adjvoucher with g.voucher
								repl svoucher with g.svoucher
							endif
							sele d
							skip
						enddo
					endif
				endif

			else
			endif
		endif
		sele e
		skip
	enddo

	sele a
	skip
enddo
select b

********************my DISCOUNT
sele c
use led1 alias led1
index on feedno + str(accid,6) to led1
*set filt to trantype $ 'RSRVPAPVCVDNCNSUPUOJOR' .and.  feeddate >= old_5 .and.  feeddate <= old_6 AND AHEADID=82419
sele a
index on str(rndid,9) to led
set filt to trantype $ 'RS' .and.  feeddate >= old_5 .and.  feeddate <= old_6 and disamt#0   &&&&&AND RNDID=82419
go top
last3= '%%%%%%%%%'
do while .not. eof()
	if last3 # str(a.rndid,9)
		last4 = last4+4
	endif
	last3 = str(a.rndid,9)
	sele e
	seek str(a.rndid,9)
	xacc = '$$$$$$'
	do while str(e.aheadid,9) = str(a.rndid,9) .and. .not. eof()

		if a.trantype='RS'
			if  amount#a.disamt
				skip
				loop
			endif
		endif

		if xacc # str(e.accid,6)
			sele b
			append blank
			repl voucher with last4
			if e.dctype = 'C'
				repl cd with 'C'
				repl credit with abs(e.amount)
			else
				if e.dctype = 'D'
					repl cd with 'D'
					repl debit with abs(e.amount)
				endif
			endif
			repl date with a.feeddate
			repl code with str(e.accid,6)
			repl remark1 with a.comment + ' '+alltrim(a.chqno)
			repl addfield1 with a.chqno
			repl addfield2 with a.chqno
			repl vcsno with a.feedno

*RS- Receipt
*RV- Receipt
*PA- Payment
*PV- Payment
*CV- Contra
*DN- Debit Note
*CN- Credit Note
*SU- Sales
*PU- Purchase
*OJ- Journal
			if a.trantype = 'JV'
				repl book with 'J'
			else
**Contra
				if a.trantype = 'CV'
					repl book with 'C'
				else
**Payment
					if (a.trantype = 'PA' .or. a.trantype = 'PV')
						repl book with 'P'
					else
**Receipt
						if (a.trantype = 'OR' .or. a.trantype = 'RS' .or. a.trantype = 'RV')
							repl book with 'R'
						else
**Credit Note
							if a.trantype = 'CN'
								repl book with 'E'
							else
**Debit Note
								if a.trantype = 'DN'
									repl book with 'D'
								else
**Purchase
									if a.trantype = 'P '
										repl book with 'A'
									else
**Sales
										if a.trantype = 'S '
											repl book with 'S'
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif
			if old_3='Y'
				if (b.book='R'  and b.credit#0) or (b.book='P' and b.debit#0)  &&&&Receipts AND
					if (a.trantype = 'OR' .or. a.trantype = 'S' .or. a.trantype = 'RC' .or. a.trantype = 'RS' .or. a.trantype = 'RR' .or. a.trantype = 'CV' .or. a.trantype = 'OP')    &&(a.trantype = 'RSPAOR')
						sele d
						seek str(e.aheadid,9)
						do while str(d.aheadid,9) = str(e.aheadid,9) .and. .not. eof()
							sele c
							seek d.feedno + str(a.accid,6)
*!*							?d.feedno + str(a.accid,6)
*!*							?found()
*!*							wait wind 'HERE-1'
							sele f
							appe blank
							repl ord with b.code
							repl ddate with b.date
							repl vcn with d.feedno
							if d.rcvdamt#0 .and. (a.subtotal = e.amount)
								if e.dctype = 'C'
									repl final with -d.rcvdamt
								else
									if e.dctype = 'D'
										repl final with d.rcvdamt
									endif
								endif
							endif
							if d.disamt#0 .and. (a.disamt = e.amount)
								if e.dctype = 'C'
									repl final with -d.disamt
								else
									if e.dctype = 'D'
										repl final with d.disamt
									endif
								endif
							endif
							repl voucher with b.voucher
							sele g
							seek f.ord+substr(f.vcn,1,12)
							if found()
								sele f
								repl type with 'A'
								repl adjvoucher with g.voucher
								repl svoucher with g.svoucher
							endif
							sele d
							skip
						enddo
					endif
				endif

			else
			endif
		endif
		sele e
		skip
	enddo

	sele a
	skip
enddo

********************MY DISCOUNT
close data

bf=datdev+'\slipno.'+datext
use &bf
go top
repl voucher with last4+20
repl svoucher with slast5+20
bf=datdev+'\mdis.'+datext
use &bf
repl misc4 with ' '
bf=datdev+'\pendings.'+datext
use &bf
repl all vcn with '*'+vcn for invtype='O' .and. ddate<=old_5
close data

** Transfer CALCULATION FIELD OF MARG TRANSACTION FILE
dis=datdev+'\dis.'+datext
use &dis
go top
do while .not. eof()
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
&&&&&&&&&&&&&&&&&FUNCTION FOR MDB AND SQL TO DBF&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7

func mdbsqlconvert(mdbsqlpara1)
do case
case mdbsqlpara1=1
	if datatransfermdb='Y'
		mrgmdbfile=alltrim(getfile('mdb'))
		datatransferpath=alltrim(datatransferpath)
		=mdbsqlconvert(2)
	endif
case mdbsqlpara1=2 and datatransfermdb='Y'
	mrgmdbfile=alltrim(mrgmdbfile)
	mrgmdbpwd='' &&alltrim(mrgmdbpwd)
	datatransferpath=subs(alltrim(datatransferpath)+space(80),1,80)
	datatransferpath=alltrim(datatransferpath)
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
*!*						susp
				endtry
				if merrno=1
*exit
				endif
			endscan
		endif
		=sqldisconnect(lnconnhandle)
		@ 16,20 say "Access File Successfully Converted to DBF."
	else
		=messagebox('Unable to read from Connection',48,'Marg ')
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
		lnconnhandle=sqlstringconnect("DRIVER=Sql Server;SERVER=M-DM-LP10\SQLEXPRESS;UID="+mrgsqluserid+";PWD="+mrgsqlpwd+";APP=Microsoft Visual FoxPro;WSID=MARG01;DATABASE="+mrgsqlfile)
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
	clear
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
*datatransferpath=subs(alltrim(datatransferpath)+space(80),1,80)
endcase


proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V",'X')
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y","X","U")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor


Proc update_closing
sele sele(1)
use &datatransferpath\batch alias fsbal
sele sele(1)
use &datdev\probat.&datext alias msbal
repl all opening with opening-balance for balance#0
repl all o_a with o_a-b_a for b_a#0
index on str(code)+batchno to  msbal

sele fsbal
scan for seek(str(prodid)+subs(batchno+space(12),1,12),'msbal')
	repl msbal.opening with msbal.opening+qty,msbal.o_a with msbal.o_a+qty
endscan

close data

proc check_field
para myfield,calias,falias
sele (falias)
afields(tblfields)
xfieldno=ascan(tblfields, upper(myfield))
sele (calias)
return xfieldno
