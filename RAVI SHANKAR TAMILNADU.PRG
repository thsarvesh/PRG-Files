*!*	BOF : Ravi Shankar.PRG .....Dated    : 22/12/2025   Author : SARVESH
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
*!*	create curs mycurs  (setup c(50),value c(4))
*!*	sele mycurs
*!*	appe blank
*!*	repl  setup with 'Item Wise Double Discount ',value with 'Y'
*!*	appen blank
*!*	repl  setup with 'Volume discount 1st ',value with 'L'
*!*	brow font 'COURIER',18    nomodify
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='d:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Dec\Ravishankar\SUNSURGICALS-22122025\DATA\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only    '
old_5 = firstdate
old_6 = lastdate
old_7 = '2'
old_8 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='33'
removenull = 'NO'
@13,10 say 'Ravi Shankar Data Path  :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'Ravi Shankar Extension  :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_6    font 'courier',18
@18,10 say 'GST/VAT                 :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code          :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Removenull              :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@21,10 say 'Type SURE               :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
read
datatransferpath  = alltrim(datatransferpath)
datdev  = alltrim(datdev)
datext = alltrim(datext)
if lastkey()=27 &&.or. sure#'SURE'
	return
endif
if type('FINALCP')#'U'
	=starttransfer()
endif
clear
rowno=5
@ 02,25 say 'Please Wait..Importing Ravi Shankar Data To Marg.....' font 'courier',14 colo 'W+/b'
rowno=rowno+1
set colo to
if removenull='Y'
	@07,10 say 'Removing Null Values..Please Wait......' font 'courier',16
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
rowno=5
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\medmast.&datatransferext alias fitm
sele sele (1)
use &datatransferpath\ratemast.&datatransferext alias frate
index on mdcode to frate
sele sele (1)
use &datatransferpath\gstfile.&datatransferext alias ftax
index on gstxcode to ftax
sele sele (1)
use &datdev\pro.&datext alias mitm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode +sname+str(igst,5,2) to mpcm
sele fitm
pack
go top
do while !eof()
	=seek(fitm.gtaxcode,'ftax')
    Sele mitm
	append blank
    Replace mitm.Code With fitm.mdcode
	Replace mitm.Name With alltri(str(fitm.mdcode))
	Replace mitm.Product With fitm.mddesc
	repl mitm.packing with fitm.packing
	Replace mitm.BillName With mitm.product+mitm.packing
	Replace mitm.Gcode With padr(fitm.supno,6)
	Replace mitm.formulano With fitm.SUPCODE
	repl mitm.maximum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl saltax with ftax.igst/2
	repl cgst   with ftax.igst/2
	repl igst   with ftax.igst
	sele frate
	seek fitm.mdcode
	scan while mdcode=fitm.mdcode
		if found()
			sele mitm
			repl ratea with frate.srate
			repl mrp with frate.mrp
		endif
	endsca
	mhsn=fitm.hsncode
	&&&HSN and Tax Mast
	sele mpcm
	seek 'COMMCD' + substr(mhsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'HH'+alltrim(str(recno())),;
			mpcm.sname  with mhsn,;
			mpcm.parnam with mhsn,;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
	Sele fitm
	Skip
enddo
close table all
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\supmast.dbf alia fpcm
sele fpcm
go top
do while .not. eof()
	sele mpcm
	if .not. found()
		append blank
		replace mpcm.sgcode With 'ZZZZZZ'
		replace mpcm.scode  with padr(fpcm.supno,9)
		replace mpcm.sname  with fpcm.supname
		replace mpcm.parnam with fpcm.supname
	endif
	sele fpcm
	skip
enddo
close table all
@rowno,10 say '**** Importing Area****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\area.dbf alia fpcm
sele fpcm
go top
do while .not. eof()
   sele mpcm
   append blank
        repl mpcm.sgcode with 'AREA  '
        Replace MPcm.SCode  With padr(fpcm.areano,6)
		Replace MPcm.SName  With FPcm.areaname
		Replace MPcm.ParNam With FPcm.areaname
        replace mpcm.tcode with 'No'
        replace mpcm.tax with 1
sele fpcm
skip
enddo
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\medmast.&datatransferext alias fsbal

sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
r=0
sele fsbal
go top
do while .not. eof()
select fsbal
    for x=1 to 8
    y=alltrim(str(x))
    if !empty(fsbal.bno&y)
	   sele mitm
	   seek str(fsbal.mdcode,9)
	   sele msbal
	      append blank
	         replace msbal.code with mitm.code
		     replace msbal.name with mitm.name
		     replace msbal.billname with mitm.billname
		     replace msbal.product with mitm.product
		     replace msbal.packing with mitm.packing
		     replace msbal.opening with fsbal.qy&y
		     replace msbal.balance with fsbal.qy&y
		     replace msbal.o_a with fsbal.qy&y
		     replace msbal.b_a with fsbal.qy&y
		     replace msbal.batchno with fsbal.bno&y
		     replace msbal.exp with fsbal.exp&y
		     replace msbal.prate with fsbal.prate&y
		     replace msbal.lprate with fsbal.prate&y
		     replace msbal.ratea with fsbal.srate&y
		     replace msbal.mrp with fsbal.mrp&y
     endif	
      next x
	  sele fsbal
	  skip
enddo 
sele msbal
repl all date with old_5-1 for balance = 0
close table all
@rowno,10 say '**** Importing Supplier****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\distmast alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
go top
do while .not. eof()
last=recno()
   sele mact
   append blank
    replace mact.scode with 'D31'
    replace mact.rate with 'Y'
    replace mact.ordno with 'D'+padr(fact.dcode,5)
	replace mact.parnam with fact.dname
	replace mact.mailnam with fact.dname
	replace mact.paradd with fact.dadd1
	replace mact.paradd1 with fact.dadd2
	replace mact.paradd2 with alltrim(fact.dadd3)
	replace mact.phone1 with fact.contact
	repl mact.phone2 with fact.dphone1
	repl mact.phone3 with fact.dphone2
	repl mact.phone4 with fact.contact
	replace mact.dlno with alltri(fact.ddl20)+' '+alltri(fact.ddl21)
	repl mact.stno with fact.dlstno
	replace mact.gstno with fact.gstin
	replace mact.itno with fact.pan_no
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
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
@rowno,10 say '**** Importing Customer ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\cusmast alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
go top
do while .not. eof()
last=recno()
   sele mact
   append blank
    replace  mact.scode with 'C6'
    replace  mact.rate with 'Y'
    Replace mact.ordno With 'R'+padr(fact.ccode,5)
	Replace mact.ParNam With fact.cname
	replace mact.mailnam with fact.cname
	replace mact.paradd with fact.cadd1
	replace mact.paradd1 with fact.cadd2
	replace mact.paradd2 with alltrim(fact.cadd3)
	replace mact.phone1 with fact.cphone
	Replace mact.dlno With alltri(fact.cdl20)+"-"+alltri(fact.cdl21)
	Replace mact.fax2 With alltri(str(fact.ccode))
	Replace mact.mr With 'M'+padr(fact.smcode,5)
	Replace mact.area With padr(fact.carea,6)
	Replace mact.gstno With fact.gstin
	repl mact.stno with fact.ctngst
	Replace mact.itno With fact.pan_no
	Replace mact.csthed With 'TIN No.'
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
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
@rowno,10 say '**** Importing MR ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\sfile alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
go top
do while .not. eof()
   sele mact
   append blank
   REPLACE mact.rate with 'Y'
   replace mact.ordno with 'M'+padr(fact.scode,5)
   replace mact.parnam with fact.sname
   replace mact.mailnam with fact.sname
   REPLACE MACT.scode with 'D32'
sele fact
skip
enddo
close table all
@rowno,10 say '**** Importing Supplier Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\distdue alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
do while !eof()
	select mord
	seek 'D'+padr(fout.dcode,5)
	sele mpend
	Append Blank
	Repl mpend.acgroup with  'D31'&&&With Iif(fout.invamt<0,'C6 ','D31 ')
	Repl mpend.ord With mord.ordno
	Repl mpend.ddate With fout.date
	Repl mpend.vcn With fout.docno
	Repl mpend.invtype With 'O'
	Repl mpend.voucher  With vou
	Repl mpend.svoucher With svou
	Repl mpend.Final With -fout.docamt
	Repl mpend.itemope With -fout.rd_amt
	Repl mpend.Balance With -(fout.docamt-fout.rd_amt)
	Repl Name With vcn
	vou=vou+5
	svou=svou+5
	Sele fout
	Skip
enddo
Sele mslip
Repl voucher  With vou+5
Repl svoucher With svou+5
close table all
@rowno,10 say '**** Importing Customer Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\ctran alias fout
sele sele(1)
select * from fout where inlist(ctrcd,51,52) into curs frec readwr
index on str(cccode,9)+str(crefno,9) to frec
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
set filter to ctype='BILL  '
go top
do while !eof()	
	store 0 to lcol
	sele frec
	seek str(fout.cccode,9)+str(fout.crefno,9)
	scan while str(cccode,9)+str(crefno,9)=str(fout.cccode,9)+str(fout.crefno,9)
		lcol=lcol+camount
	endsca
	select mord
	seek 'R'+padr(fout.cccode,5)
	sele mpend
	Append Blank
	Repl mpend.acgroup with  'C6'&&&With Iif(fout.invamt<0,'C6 ','D31 ')
	Repl mpend.ord With mord.ordno
	Repl mpend.ddate With fout.cdate
	Repl mpend.vcn With alltri(str(fout.crefno))
	Repl mpend.invtype With 'O'
	Repl mpend.voucher  With vou
	Repl mpend.svoucher With svou
	Repl mpend.Final With fout.camount
	Repl mpend.itemope With lcol
	Repl mpend.Balance With (fout.camount-lcol)
	Repl Name With vcn
	vou=vou+5
	svou=svou+5
	Sele fout
	Skip
enddo
Sele mslip
Repl voucher  With vou+5
Repl svoucher With svou+5
close table all
@rowno,10 say '**** Importing Ledger Balance  ****' font 'Arial',10
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
retu
@ 21,22 Say  'Transfering CUSTOMER Credit note Pending OPENING'
*wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+'** Transfer CUSTOMER credit note pending OPENING'
cf=datatransferpath + 'sreturn'+datatransferext
af=datdev + '\pendings.'+datext
bf=datdev + '\slipno.'+datext
df=datdev + '\order.'+datext

Select d
Use &df Alias mord
Index On ordno To mord
Sele a
Use &af Alias mpend
Sele b
Use &bf Alias mslip
Sele c
Use &cf Alias fout
Index On ccode To fout
set filt to adjust#flock()

If old_3='Y'

	Sele mslip
	Go Top
	vou =voucher  + 10
	svou=svoucher + 10

	Sele fout
	Go Top
	Do While !Eof()

		Select mord
		Seek fout.ccode
		Sele mpend
		Append Blank
		Repl mpend.acgroup With Iif(fout.net_amt>0,'C6 ','D31 ')
		Repl mpend.ord With fout.ccode
		Repl mpend.ddate With fout.sretdt
		Repl mpend.vcn With 'CN-'+alltrim(str(fout.sretno))
		Repl mpend.invtype With 'O'
		Repl mpend.voucher  With vou
		Repl mpend.svoucher With svou
		Repl mpend.Final With -fout.net_amt
		Repl mpend.Balance With -fout.net_amt
		Repl Name With vcn
		vou=vou+5
		svou=svou+5
		Sele fout
		Skip
	Enddo

	Sele mslip
	Repl voucher  With vou+5
	Repl svoucher With svou+5

Endif
Close data


Select SELECT(1)
Use datdev+'\pendings.'+datext ALIAS pendings  
Index On ord To T

Select b
Use datdev+'\order.'+datext ALIAS order 
Index On ordNO To ttt
Select a

Select b

Select ord,Sum(BALANCE) As balance From pendings Into Cursor tmp readwrite Group By ord
Select tmp
Scan
	Select Order
	Seek tmp.ord
	Replace balance With tmp->balANCE
	ENDSCAN
	Select ord,Sum(BALANCE) As BALANCE From pendings Into Cursor tmp readwrite Group By ord 
Select tmp
Scan
	Select Order
	Seek tmp.ord
	Replace  order.opning With tmp->BALANCE 
Endscan
@ 28,25 Say '<<< Please Check all Tax Details with Tax code in Product Master    !!! >>>' font 'Tahoma',14
@ 30,25 Say '<<< Migration Process completed. Congratulations to Win more orders !!! >>>' font 'Tahoma',14

CLOSE DATA

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
retu
*!*	EOF : RaviShankar.PRG .....Dated    : 22/12/2025   Author : SARVESH
