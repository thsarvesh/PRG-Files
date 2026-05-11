*!*	BOF : TF_KLUSTER.PRG (PHARMA RETAIL).....UPDATED By Santosh Srivastava
*!* STATE : KERALA(32)    kluster - retail
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
close databases all
set talk off
set date to brit
set cent on
set dele on
set safe off

if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')  		&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')  		&& Un-Comment this for run from VFP
	datdev='D:\transfer\'   && Un-Comment this for run from VFP
	datext='dbf'						&& Un-Comment this for run from VFP
endif




datatransferpath=substr('D:\2025\Oct\KLUSTER\Dbf\'+space(100),1,100)
datatransferpath1=substr('D:\2025\Oct\KLUSTER\Dbf\'+space(100),1,100)

datatransferext='.DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='32'
sure='SURE'
trade = 'PHARMA'
removenull='No '

clear
close data
@ 02,22 say 'Importing KLUSTER Retail To Marg.....' font 'Arial',14 colo 'W+/G'
@ 04,08 to 21,120 doub
@ 10,10 say 'OLD DATA path1 :' font 'Courier',18 get datatransferpath font 'Courier',18
*@ 11,10 SAY 'OLD DATA PATH2 :' Font 'Courier',18 get DATATRANSFERPATH1 Font 'Courier',18
@ 12,10 say 'DATA EXTENSION :' font 'Courier',18 get datatransferext font 'Courier',18
@ 13,10 say 'WITH O/S       :' font 'Courier',18 get old_3 pict '@m YES,NO ' font 'Courier',18
@ 14,10 say 'ONLY BALANCE   :' font 'Courier',18 get old_4 pict '@m YES,NO ' font 'Courier',18
@ 15,10 say 'F.Y.BEGIN FROM :' font 'Courier',18 get old_5 font 'Courier',18
@ 16,10 say 'F.Y.BEGIN FROM :' font 'Courier',18 get old_6 font 'Courier',18
@ 17,10 say 'State Code     :' font 'Courier',18 get mstatecode font 'Courier',18
@ 18,10 say 'TRADE          :' font 'Courier',18 get trade font 'Courier',18
@ 19,10 say 'Type SURE      :' font 'Courier',18 get sure pict '@x!' font 'Courier',18
read
clear
close data

datatransferpath=alltrim(datatransferpath)
datatransferpath1=alltrim(datatransferpath1)

if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
if type('FINALCP')#'U'
	=starttransfer()
endif
rowno=5

@ 02,22 say 'Please Wait PIPING KLUSTER(Wholesale) DATA To Marg.....' font 'Arial',14 colo 'W+/G'

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
use &datdev\support.&datext
dele all for type='#' and aliase='DAT/F'
pack
close data
set colo to

@rowno,22 say 'Importing Company.....' font 'Courier',14
rowno=rowno+1

sele sele(1)
use &datatransferpath\commas alias fcomp
sele sele(1)
use &datdev\saletype.&datext alias mcomp
index on sgcode + sname + str(igst,5,2) to  mcomp
sele fcomp
go top
scan
	sele mcomp
	append blank
	repl mcomp.sgcode with 'ZZZZZZ',;
		mcomp.scode  with 'Z'+str(recno(),5);
		mcomp.sname  with upper(fcomp.cm_nm),;
		mcomp.parnam with upper(fcomp.cm_nm),;
		mcomp.tname with fcomp.cm_cod,; 
		mcomp.igst with 0,;
		mcomp.tcode with 'No'
endscan
close table all

@rowno,22 say 'Importing Category .....' font 'Courier',14
rowno=rowno+1
pc=datatransferpath+'\PCAT.dbf'
if file(pc)
	sele sele(1)
	use &datatransferpath\pcat alias fcat
	sele sele(1)
	use &datdev\saletype.&datext alias mcat
	index on sgcode + parnam + str(igst,5,2) to  mcat

	sele fcat
	go top
	scan
		sele mcat
		append blank
		repl mcat.sgcode with 'CATEGO',;
			mcat.scode  with 'C'+str(recno(),5),;
			mcat.sname  with upper(fcat.gr_nm),;
			mcat.parnam with upper(fcat.gr_nm),;
			mcat.tcode with 'No',igst with 0
	endscan
	close table all
endif



@rowno,22 say 'Importing Product .....' font 'Courier',14
rowno=rowno+1

sele sele(1)
*	use &datatransferpath\Itemmas alias fitm
use &datatransferpath\promas alias fitm
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\saletype.&datext alias mpcm
copy to mcomp
index on sgcode + sname + str(igst,5,2) to  mpcm
sele sele(1)
use  mcomp alias mcomp 
index on subs(tname,1,10) to mcomp
sele fitm
go top
scan
*	=seek(pm_cc,'fpcm')
	sele mitm
	append blank
	last=recno()
	repl mitm.code with last
	repl mitm.name with str(last,10)
	repl mitm.product with upper(fitm.pm_nm)
	repl mitm.pack with fitm.pm_un
	repl mitm.billname with upper(alltrim(fitm.pm_nm))    && +'  '+ alltrim(fitm.pm_pac)
	repl mitm.unit with fitm.pm_p1		&& 'Pcs'
*	repl mitm.gcode with fitm.pm_cc
	repl mitm.gcode5 with fitm.pm_cat
	repl mitm.taxl with iif(fitm.pm_ptax>0,'T','E')
	repl mitm.taxc with 'T'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.pursc with 0
	repl mitm.status with 'Y'
	repl mitm.saltax with fitm.pm_ptax/2
	repl mitm.cgst with fitm.pm_ptax/2
	repl mitm.igst with fitm.pm_ptax
	repl mitm.purtax with fitm.pm_ptax/2
	repl mitm.prate with fitm.pm_prt
	repl mitm.ratea with fitm.pm_srt
	repl mitm.mrp with fitm.pm_srt
	repl formulano with fitm.pm_cod
	REPL RACKNO WITH FITM.PM_RCK 
	
&&?'foR hsn'
	sele mpcm
	seek 'COMMCD' + substr(fitm.pm_hsn+space(40),1,40) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'H'+alltrim(str(last)),;
			mpcm.sname  with substr(fitm.pm_hsn+space(15),1,15)+ substr(fitm.pm_hsn,1,15)+' '+ alltrim(str(mitm.igst,5,2)),;
			mpcm.parnam with substr(fitm.pm_hsn,1,15),;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endi
	repl mitm.gcode6 with mpcm.scode
	sele mcomp
	seek subs(fitm.pm_cc+space(10),1,10)
	if found()
		repl mitm.gcode with mcomp.scode
	endif
endscan
close table all

@rowno,22 say 'Importing Patients'   font 'Arial',12
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
	repl ordno with alltrim(str(pat.p_id))
	repl parnam with upper(pat.p_nm)
	repl form with alltrim(str(pat.p_id))
endscan
close data

@rowno,22 say 'Importing Doctor'   font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\docmas alias doc
sele sele(1)
use &datdev\maorder.&datext alias mord
sele doc
scan
	sele mord
	appen blank
	repl scode with 'PRE#$~'
	repl ordno with doc.do_code
	repl parnam with upper(doc.do_name)+upper(doc.do_ad1)
	repl form with doc.do_code
endscan


@rowno,22 say 'Importing Area .....' font 'Courier',14
rowno=rowno+1
far=datatransferpath+'\armas.dbf'
if file(far)
	sele sele(1)
	use &datatransferpath\armas alias farr
	sele sele(1)
	use &datdev\saletype.&datext alias marr
	index on sgcode + parnam + str(igst,5,2) to  marr

	sele farr
	go top
	scan
		sele marr
		append blank
		repl marr.sgcode with 'AREA  ',;
			marr.scode  with alltrim(farr.ar_cod) ,;
			marr.sname  with upper(farr.ar_nm),;
			marr.parnam with upper(farr.ar_nm),;
			marr.tcode with 'No',;
			marr.tax with 1
	endscan
	close table all
endif

@rowno,22 say 'Importing Ledger(SUNDRY DEBTORS) .....' font 'Courier',14
rowno=rowno+1

sele sele(1)
use &datatransferpath\cusmas alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias msup
index on aliase + str(sno,3) + lcode to msup

sele fact
go top
scan
	last=recno()
	sele mact
	append blank
	repl      mact.scode with 'C6'
	repl      mact.rate with 'Y'
	repl      mact.ordno with fact.cu_code
	repl      mact.parnam  with upper(fact.cu_name)
	repl      mact.paradd with upper(fact.cu_add1)
	repl      mact.paradd1 with upper(fact.cu_add2)
	repl      mact.paradd2 with upper(alltrim(fact.cu_add3))     &&+ALLTRIM(fact.Cu_add4)
	repl      mact.dsm with fact.cu_pin
	repl      mact.gsthed with 'GST  No.'
*   repl      mact.gstno with fact.Cu_cst
*   repl      mact.dlno with alltrim(fact.Cu_dl1)+','+ALLTRIM(fact.Cu_dl2)
	repl      mact.phone1 with substr(fact.cu_mob,1,10)
	repl      mact.phone2 with fact.cu_phone
	repl      mact.mailnam with upper(fact.cu_name)
	repl      mact.ref with 'Mr.'
*   repl      mact.MR with fact.cu_rc
*  repl      mact.area with ALLTRIM(fact.cu_ter)
	repl      mact.price with 'A'
	repl      mact.status with 'Y'
	repl      mact.adhed with 'Discount'

   	&& Updating State
*!*		Sele msup
*!*		Seek 'ORDER   ' + '  7' +  mact.ordno
*!*		Append Blank
*!*		Repl aliase With 'ORDER   '
*!*		Repl Type With 'F'
*!*		Repl lcode With mact.ordno
*!*		Repl sno With 7
*!*		Repl pcode With 15
*!*		Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(fact.Cu_cst,1,2)='  ',MSTATECODE,Subs(fact.Cu_cst,1,2))+'                                           '
*!*	     sele msup
*!*	     appen blan
*!*	     repl type with '#',aliase with 'DAT/F-LD',Lcode with mact.ordno,value with 0
*!*
endscan
close tables all

@rowno,22 say 'Importing Ledger(SUNDRY CREDITORS) .....' font 'Courier',14
rowno=rowno+1

sele sele(1)
use &datatransferpath\supmas alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias msup
index on aliase + str(sno,3) + lcode to msup

sele fact
go top
scan
	last=recno()
	sele mact
	append blank
	repl      mact.scode with 'D31'
	repl      mact.rate with 'Y'
	repl      mact.ordno with 'P'+alltrim(str(last))
	repl      mact.parnam  with upper(fact.su_nm)
	repl      mact.paradd with upper(fact.su_ad1)
	repl      mact.paradd1 with upper(fact.su_ad2)
**   repl      mact.paradd2 with ALLTRIM(fact.Su_ad3)+ALLTRIM(fact.Su_pl)
	repl      mact.city with upper(fact.su_pl)
	repl      mact.dsm with fact.su_pin
	repl      mact.gsthed with 'GST  No.'
	repl      mact.gstno with upper(fact.su_tin)
	repl      mact.fax2 with fact.su_cod
	repl      mact.phone1 with fact.su_ph
*   repl      mact.phone2 with substr(fact.Su_mob,11,10)
	repl      mact.mailnam with upper(fact.su_nm)
	repl      mact.ref with 'Mr.'
	repl      mact.price with 'A'
	repl      mact.status with 'Y'
	repl      mact.adhed with 'Discount'

&& Updating State
	sele msup
	seek 'ORDER   ' + '  7' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(fact.su_tin,1,2)='  ',mstatecode,subs(fact.su_tin,1,2))+'                                           '
	sele msup
	appen blan
	repl type with '#',aliase with 'DAT/F-LD',lcode with mact.ordno,value with 0
endscan
close tables all


@rowno,22 say 'Importing MR .....' font 'Courier',14
rowno=rowno+1

sele sele(1)
use &datatransferpath\repmas alias fmr
sele sele(1)
use &datdev\order.&datext alias mmr

sele fmr
go top
scan
	sele mmr
	append blank
	repl mmr.scode with 'D32',;
		mmr.ordno with fmr.rm_cod,;
		mmr.parnam with fmr.rm_nm,;
		mmr.fax2 with fmr.rm_cod,;
		mmr.mailnam with fmr.rm_nm
endscan
close table all

@rowno,22 say 'Importing Batch .....' font 'Courier',14
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alias mact
index on parnam to mact

sele sele(1)
use &datatransferpath\supmas alias fact
index on su_cod to fact

sele sele(1)
use &datatransferpath\stomas alias fsbal

sele sele(1)
use &datdev\probat.&datext alias msbal
index on name  + batchno to msbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on formulano  to mitm
sele sele(1)
use &datdev\support.&datext alias msup

sele fsbal
go top
xrec=1
scan
	select fact
	seek   fsbal.st_sup
	select mact
	seek substr(fact.su_nm,1,45)
	sele mitm
	seek subs(fsbal.st_cod+space(35),1,35)
	IF !FOUND()
	  appen blank 
	  repl code with recno() 
	  repl name with str(recno()) 
	  repl product with '# '+fsbal.st_cod
	  repl billname with '# '+fsbal.st_cod 
	  REPL PACK WITH IIF(FSBAL.ST_UN=0,1,FSBAL.ST_UN)
	  REPL FORMULANO WITH FSBAL.st_cod
	endif  
	sele msbal
	seek mitm.name+ substr(fsbal.st_bn+space(12),1,12)
   IF !FOUND()	

		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.pack with fsbal.st_un
		repl msbal.unit2 with mitm.unit2
		repl msbal.unit with mitm.unit
		repl msbal.decimal with 'Y'
		repl msbal.batchno with fsbal.st_bn
		repl msbal.exp with  ctod(alltrim('01')+'/'+alltrim(substr(fsbal.st_exp,1,2)+'/'+alltrim(substr(fsbal.st_exp,3,4))))
		repl msbal.mrp with fsbal.st_srt				&&MRP
		repl msbal.misc1 with mitm.gcode
		repl msbal.supdat with fsbal.st_dt
		repl msbal.date with fsbal.st_dt
		repl msbal.supcode with mact.ordno
		repl msbal.supinvo with fsbal.st_rn
	    repl msbal.opening with fsbal.st_qty
	    repl msbal.balance with fsbal.st_qty
	    repl msbal.o_a with fsbal.st_qty
	    repl msbal.b_a with fsbal.st_qty
	    repl msbal.lprate with fsbal.st_hsrt/iif(msbal.pack#0,msbal.pack,1)
	    repl msbal.prate with fsbal.st_prt
	    repl msbal.ratea with fsbal.st_srt
	    repl msbal.mrp with fsbal.st_srt
ELSE

		append blank
		repl msbal.code with mitm.code
		repl msbal.name with mitm.name
		repl msbal.billname with mitm.billname
		repl msbal.product with mitm.product
		repl msbal.pack with fsbal.st_un
		repl msbal.unit2 with mitm.unit2
		repl msbal.unit with mitm.unit
		repl msbal.decimal with 'Y'
	
		repl msbal.batchno with subs(fsbal.st_bn+space(12),1,10)+str(xrec,2)
		repl msbal.exp with  ctod(alltrim('01')+'/'+alltrim(substr(fsbal.st_exp,1,2)+'/'+alltrim(substr(fsbal.st_exp,3,4))))
		repl msbal.mrp with fsbal.st_srt				&&MRP
		repl msbal.misc1 with mitm.gcode
		repl msbal.supdat with fsbal.st_dt
		repl msbal.date with fsbal.st_dt

		repl msbal.supcode with mact.ordno
		repl msbal.supinvo with fsbal.st_rn
	    repl msbal.opening with fsbal.st_qty
	    repl msbal.balance with fsbal.st_qty
	    repl msbal.o_a with fsbal.st_qty
	    repl msbal.b_a with fsbal.st_qty
	    repl msbal.lprate with fsbal.st_hsrt/iif(msbal.pack#0,msbal.pack,1)
	    repl msbal.prate with fsbal.st_prt
	    repl msbal.ratea with fsbal.st_srt
	    repl msbal.mrp with fsbal.st_srt
	    repl msbal.opening with fsbal.st_qty
	    repl msbal.balance with fsbal.st_qty
	    repl msbal.o_a with fsbal.st_qty
	    repl msbal.b_a with fsbal.st_qty
	    repl msbal.lprate with fsbal.st_hsrt/iif(msbal.pack#0,msbal.pack,1)
	    repl msbal.prate with fsbal.st_prt
	    repl msbal.ratea with fsbal.st_srt
	    repl msbal.mrp with fsbal.st_srt
	    xrec=xrec+1
ENDIF
endscan
close table all


return
*** CLOSING BALANCES PATH AND DB NOT AVAILABLE

@rowno,22 say 'Importing Outstanding(SUNDRY DEBTORS) .....' font 'Courier',14
rowno=rowno+1

sele sele(1)
use &datatransferpath1\ledger alias fled
set filt to le_tc = '1'
sele sele(1)
use &datatransferpath1\col alias fcol
index on co_bno + co_cod to fcol
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\slipno.&datext alias mslip

if old_3='Y'

	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10

	sele fled
	go top
	scan

		adjamt=0
		sele fcol
		seek fled.le_rn + fled.le_cod
		do while fcol.co_bno = fled.le_rn .and. fcol.co_cod = fled.le_cod  .and. .not. eof()
			adjamt = adjamt + fcol.co_amt
			skip
		enddo
		if fled.le_amt-adjamt>0
			sele mpend
			append blank
			repl mpend.acgroup with 'C6'
			repl mpend.ord with alltrim(fled.le_cod)
			repl mpend.ddate with fled.le_dt
			repl mpend.vcn with fled.le_rn
			repl mpend.invtype with 'O'
			repl mpend.voucher  with vou
			repl mpend.svoucher with svou
			repl mpend.duedate with fled.le_dt
			repl mpend.duedays with duedate-ddate
			repl mpend.itemope with adjamt
			repl mpend.final with fled.le_amt
			repl mpend.balance with fled.le_amt-adjamt
			vou =vou+5
			svou=svou+5
		endif

		sele mslip
		repl voucher  with vou+5
		repl svoucher with svou+5

	endscan
endif
close table all

@rowno,22 say 'Importing Outstanding(SUNDRY CREDITOR) .....' font 'Courier',14
rowno=rowno+1

sele sele(1)
use &datatransferpath1\ledger alias fled
set filt to le_tc = '2'
sele sele(1)
use &datatransferpath1\col alias fcol
index on co_bno + co_cod to fcol
sele sele(1)
use &datdev\order.&datext alias ord
inde on fax2 to ord
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\slipno.&datext alias mslip

if old_3='Y'

	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10

	sele fled
	go top
	scan
		select ord
		seek substr(fled.le_cod,1,6)
		adjamt=0
		sele fcol
		seek fled.le_rn + fled.le_cod
		do while fcol.co_bno = fled.le_rn .and. fcol.co_cod = fled.le_cod .and. .not. eof()
			adjamt = adjamt + fcol.co_amt
			skip
		enddo
		if fled.le_amt-adjamt>0
			sele mpend
			append blank
			repl mpend.acgroup with 'D31'
			repl mpend.ord with ord.ordno
			repl mpend.ddate with fled.le_dt
			repl mpend.vcn with fled.le_rn
			repl mpend.invtype with 'O'
			repl mpend.voucher  with vou
			repl mpend.svoucher with svou
			repl mpend.duedate with fled.le_dt
			repl mpend.duedays with duedate-ddate
			repl mpend.itemope with -(adjamt)
			repl mpend.final with -(fled.le_amt)
			repl mpend.balance with -(fled.le_amt-adjamt)
			vou =vou+5
			svou=svou+5
		endif

		sele mslip
		repl voucher  with vou+5
		repl svoucher with svou+5
	endscan
endif
close table all

&&--------------------------------------------

@rowno,22 say 'Transfer LEDGER BALANCES FROM PENDINGS .....' font 'Courier',14
rowno=rowno+1

sele sele(1)
use &datdev\order.&datext alias order1
index on ordno to order1
sele sele(1)
use &datdev\pendings.&datext alias pend
index on ord to pend

select ord,sum(balance) as balance from pend into cursor tmp readwrite group by ord
select tmp
scan
	select order1
	seek tmp.ord
	replace balance with tmp->balance
endscan
select ord,sum(balance) as balance from pend into cursor tmp readwrite group by ord
select tmp
scan
	select order1
	seek tmp.ord
	replace  order1.opning with tmp->balance
endscan
close table all

*!*	EOF : TF_KLUSTER.PRG (PHARMA RETAIL).....UPDATED By Santosh Srivastava
