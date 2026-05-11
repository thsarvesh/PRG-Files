****Raymedy Wholesale Program (Maharashtra)*****
****Updated By-Umesh Nath Goswami****
clos tables all
set date  brit
set cent on
set dele on
set safe off
set cpdi off
set color to
set status off
set talk off
sele sele(1)
creat cursor mycursor (setup c(50),value c(5))
sele mycursor
appen blank
repl setup with 'Ask Discount in Amount',value with 'N'
brow font 'courier',16 nomodif
sure= space(4)
*For Execution in VFP Direct
****************************************
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')
	lastdate =ctod('31/03/2026')
	datdev='d:\transfer\'
	datext='DBF'
endif
*!* *****************************************
datatransferpath=substr('D:\2025\apr\Gofrugal\Dbf\'+space(95),1,95)
datatransferext='dbf'
old_3 = 'YES'
outsonly='NO '
old_4 = 'Master Only   '
old_5 = firstdate
old_9 = lastdate
old_12 = 'G'
mstatecode='24'
removenull = 'NO'
store '2' to scalc,pcalc
clear
close data
@07,10 say 'Raymedi Data Path  :' font 'courier',18 get datatransferpath   font 'courier',18
@08,10 say 'Raymedi Data Ext.  :' font 'courier',18 get datatransferext   font 'courier',18
@09,10 say 'With O/S           :' font 'courier',18 get old_3 pict '@^ YES,NO '  font 'courier',12
@10,10 say 'Outstanding Only   :' font 'courier',18 get outsonly pict '@^ NO ,YES'  font 'courier',12
@11,10 say 'Transfer Type      :' font 'courier',18 get old_4 pict '@^ Master Only      ,With A/C Vouchers,Full Transfer    '   when outsonly='N' font 'courier',12
@12,10 say 'F.Y.Begin From     :' font 'courier',18 get old_5  font 'courier',18
@13,10 say 'F.Y.Upto           :' font 'courier',18 get old_9  font 'courier',18
@14,10 say 'Gst/Vat            :' font 'courier',18 get old_12 pict '@^ GST,VAT'font 'courier',18
@15,10 say 'Your State Code    :' font 'courier',18 get mstatecode font 'courier',18
@16,10 say 'Sale Calculation   :' font 'courier',18 get scalc font 'courier',18
@17,10 say 'Purch Calculation  :' font 'courier',18 get pcalc font 'courier',18
@18,10 say 'Removenull         :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@19,10 say 'Type SURE          :' font 'courier',18 get sure pict '@x!' font 'courier',18
read
datatransferpath = alltrim(datatransferpath)
datdev = alltrim(datdev)
datext= alltrim(datext)
if lastkey()=27 .and. sure#'SURE'
	return
endif
clear
old_4=iif(old_4='M','Y',iif(old_4='W','W','N'))
if type('FINALCP')#'U'
	=starttransfer()
endif
clear
@02,22 say 'Please Wait Importing Raymedi Data Into Marg....' font 'Arial',14 colo 'W+/G'
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
use &datdev\saletype.&datext
zap
use &datdev\support.&datext
zap
clos table all
rowno=6
@rowno,10 say '**** Removing Null Values ****' font 'Arial',10
rowno=rowno+1
if removenull='Y'
	do removenull
endif
do remedy_tf
close table all
proc remedy_tf
	@rowno,10 say '**** Importing Sales/Medical Representatives****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datatransferpath\rep alias fact
	sele sele (1)
	use &datdev\order.&datext alias mact
	zap
	sele fact
	go top
	do while .not. eof()
		sele mact
		append blank
		repl scode with 'D32'
		repl mact.ordno with fact.rcode
		repl mact.parnam  with upper(alltrim(fact.name))
		repl mact.paradd with upper(alltrim(fact.street))
		repl mact.paradd1 with upper(alltrim(fact.ads))
		repl mact.paradd2 with upper(alltrim(fact.place))
		repl mact.phone1 with fact.phone
		sele fact
		skip
	enddo
	close table all

	@rowno,10 say '**** Importing Ledger Masters****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datatransferpath\acmas alias fact
	sele sele(1)
	use &datatransferpath\ledger alias led
	index on lcode  to led
	sele sele(1)
	use &datdev\order.&datext alias mact
	sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	delete all for sgcode='AREA  '
	index on sgcode+sname to mpcm
	sele sele(1)
	use &datdev\support.&datext alias support
	sele fact
	go top
	scan
		sele mact
		append blank
		do case
			case fact.mgcode= 701 .or. fact.mgcode = 203
				repl mact.scode with 'D31'
				repl mact.rate with old_3
			case fact.mgcode = 801
				repl mact.scode with 'C6'
				repl mact.rate with old_3
			case fact.mgcode = 403
				repl mact.scode with 'J12'
			otherwise
				repl mact.scode with 'J12'
		endcase
		replace mact.rate with 'N'
		repl mact.ordno with alltrim(str(recno()))
		repl fax2 with fact.code
		repl mact.parnam  with upper(alltrim(fact.name))
		repl mact.paradd with upper(alltrim(fact.street))
		repl mact.paradd1 with upper(alltrim(fact.ads))
		repl mact.paradd2 with upper(alltrim(fact.place))
		repl mact.sthed with  'CST No.'
		repl mact.csthed with 'TIN  No.'
		repl mact.gsthed with 'GST  No.'
		repl mact.cstno with fact.girno
		repl mact.stno with fact.cst
		repl mact.gstno with fact.girno
		repl mact.dlno with alltrim(fact.dlno1) +' , '+ alltrim(fact.dlno2)
		repl mact.phone1 with fact.phone
		repl mact.phone4 with fact.cell
		repl mact.mailnam with upper(alltrim(fact.name))
		repl mact.ref with 'Mr.'
		repl mact.area with fact.area
		repl mact.price with 'A'
		repl mact.city with fact.place
		repl mact.status with 'Y'
		repl mact.adhed with 'Discount'
		repl mact.rate with 'Y'
		repl mact.mr with fact.rep
		repl mact.area with fact.area
		repl mact.limit with fact.crlimit
		repl mact.duedays   with val(alltrim(fact.crdays))
		repl mact.dsm with fact.pin
		repl mact.fax1 with fact.pager
		repl mact.disc1 with fact.cashdisc
		repl mact.disc2 with fact.creditdisc
		if alltrim(fact.girno)='.'
			repl cstno with ''
		endif
		sele led
		seek fact.code
		sum dr-cr to curbal while lcode=fact.code
		sele fact
		mobal=iif(crdr='D',obal,-obal)
		mopn=mobal
		if old_4='Y'
			mopn=mobal+curbal
		endif
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
	endscan
	close table all
	@rowno,10 say '**** Importing Product****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\promas alias fitm
	sele sele(1)
	use &datatransferpath\tax alias ftax
	index on tcode to ftax
	sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode+sname+str(igst,5,2) to mpcm
	sele sele(1)
	use &datdev\pro.&datext alias  mitm
	dele all
	sele fitm
	go top
	scan
		=seek(fitm.tax,'ftax')
		sele mitm
		append blank
		repl mitm.code with recno()
		repl mitm.name with fitm.pcode
		repl mitm.product with fitm.name
		repl mitm.packing with fitm.pack
		repl mitm.billname with alltrim(fitm.name) +'  '+ alltrim(fitm.pack)
		repl mitm.unit with 'Pcs'
		repl mitm.taxl with 'T'
		repl mitm.taxc with 'T'
		repl mitm.decimal with 'Y'
		repl mitm.salfix with 'N'
		repl mitm.minimum with fitm.mqty
		repl mitm.halfsche with 'A'
		repl mitm.qtrsche with 'Y'
		repl mitm.saltax with ftax.st/2
		repl mitm.cgst with ftax.st/2
		repl mitm.purtax with ftax.st/2
		repl mitm.igst with ftax.st
		repl mitm.status with 'Y'
		repl mitm.gcode with fitm.scode
		repl mitm.gcode3 with left(alltrim(fitm.drugs),6)
		repl formulano with fitm.mfr+space(11)+subs(formulano,16,100)
		if upper(scalc)='N'
			mincl='S'
			if ('MRP'$ftax.name or 'M.R.P.'$ftax.name)
				mmrp=iif('INC'$ftax.name,'I','E')
			else
				mmrp=iif('INC'$ftax.name,'W','S')
			endif
			sele mitm
			repl misc5 with subs(misc5,1,1)+mmrp+subs(misc5,3,100)
		endif
		&&&&&hsn code
		mhsncode=alltri(fitm.item_alias_list)
		select mpcm
		seek 'COMMCD' + substr(mhsncode+space(15),1,15) + str(mitm.igst,5,2)
		if !found()
			append blank
			repl mpcm.sgcode with 'COMMCD'
			repl mpcm.scode  with 'H'+alltrim(str(recno()))
			repl mpcm.sname  with mhsncode
			repl mpcm.parnam with mhsncode
			repl mpcm.tax with mitm.saltax
			repl mpcm.cgst with mitm.cgst
			repl mpcm.igst with mitm.igst
			repl mpcm.tcode with 'No'
		endif
		repl mitm.gcode6 with mpcm.scode
		&&&Update Salt
		sele mpcm
		seek 'SALT  '+substr(upper(fitm.drugs)+space(40),1,40)
		if !found()
			appen blank
			repl sgcode with 'SALT  '
			repl sname with upper(fitm.drugs)
			repl parnam with upper(fitm.drugs)
			repl tname with upper(substr(fitm.drugs,41,40))
			repl scode with 'S'+alltri(str(recno()))
		endif
		sele mitm
		repl gcode3 with mpcm.scode
	endscan
	close table all
	@rowno,10 say '**** Importing Company ****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datdev\saletype.&datext alia mpcm
	index on sgcode+sname to mpcm
	sele sele (1)
	use &datatransferpath\mfrmast.dbf alia fpcm
	sele fpcm
	go top
	scan
		sele mpcm
		append blank
		repl mpcm.sgcode with 'ZZZZZZ'
		repl mpcm.scode  with fpcm.code
		repl mpcm.sname  with fpcm.name
		repl mpcm.parnam with fpcm.name
		repl mpcm.tcode with 'No'
	endscan
	close table all
	@rowno,10 say '**** Importing Area ****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datdev\saletype.&datext alia mpcm
	index on sgcode+sname to mpcm
	sele sele (1)
	use &datatransferpath\area.dbf alia fpcm
	sele fpcm
	go top
	scan
		sele mpcm
		append blank
		repl mpcm.sgcode with 'AREA  '
		repl mpcm.scode  with fpcm.acode
		repl mpcm.sname  with fpcm.name
		repl mpcm.parnam with fpcm.name
		repl mpcm.tcode with 'No'
	endscan
	close table all
	@rowno,10 say '**** Importing Batch/Stock****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\product  alias fsbal
	sele sele(1)
	use &datdev\pro.&datext alias mitm
	index on name to mitm
	sele sele(1)
	use &datdev\probat.&datext alias msbal
	zap
	index on name+batchno to msbal
	sele select(1)
	use &datdev\order.&datext alias mact
	index on fax2 to mact
	sele fsbal
	go top
	scan
		sele mitm
		seek(substr(fsbal.pcode+space(10),1,10))
		sele msbal
		seek(substr(fsbal.pcode+space(10),1,10)+substr(fsbal.batch+space(12),1,12))
		if !found()
			sele msbal
			append blank
			repl msbal.date with date()
			repl msbal.code with mitm.code
			repl msbal.name with mitm.name
			repl msbal.billname with mitm.billname
			repl msbal.product  with mitm.product
			repl msbal.pack with mitm.pack
			repl msbal.unit2 with mitm.unit2
			repl msbal.unit with mitm.unit
			repl msbal.decimal with 'Y'
			repl msbal.opening with (fsbal.qty+fsbal.fqty)
			repl msbal.balance with (fsbal.qty+fsbal.fqty)
			repl msbal.o_a with (fsbal.qty+fsbal.fqty)
			repl msbal.b_a with fsbal.qty+fsbal.fqty
			repl msbal.batchno with (fsbal.batch)
			repl msbal.prate with fsbal.prate
			repl msbal.ratea with fsbal.rate
			repl msbal.mrp with fsbal.mrp
			repl msbal.misc1 with mitm.gcode
			repl exp with ctod('01/'+substr(fsbal.ed,1,2)+'/20'+substr(fsbal.ed,4,2))
			repl msbal.packing with mitm.packing
		else
			sele msbal
			repl exp with ctod('01/'+substr(fsbal.ed,1,2)+'/20'+substr(fsbal.ed,4,2))
			repl opening with  opening+fsbal.qty+fsbal.fqty
			repl balance with  balance+fsbal.qty+fsbal.fqty
			repl o_a with o_a+fsbal.qty+fsbal.fqty
			repl b_a with b_a+fsbal.qty+fsbal.fqty
		endif
	endscan
	close table all
	if old_3 = 'Y'
		@rowno,10 say '**** Importing Outstanding****' font 'Arial',10
		rowno=rowno+1
		sele sele(1)
		use &datdev\pendings.&datext alias mpend
		sele sele(1)
		use &datdev\order.&datext alias mact
		inde on fax2 to mact
		sele sele(1)
		use &datdev\slipno.&datext alias mslip
		sele sele(1)
		use &datatransferpath\outstand alias fout
		sele sele(1)
		use &datatransferpath\acmas alias fact
		index on code to fact
		sele mslip
		go top
		vou =voucher  + 10
		svou=svoucher + 10
		sele fout
		set filter to balamt > 0
		go top
		scan
			=seek(subs(ccode+space(12),1,12),'mact')
			sele mpend
			append blank
			repl ord with mact.ordno
			repl mpend.acgroup with 'C6'
			repl mpend.ddate with fout.idate
			repl mpend.vcn with fout.invno
			repl mpend.invtype with 'O'
			repl mpend.voucher  with vou
			repl mpend.svoucher with svou
			repl mpend.duedate with fout.idate
			repl mpend.duedays with duedate-ddate
			if substr(fout.ccode,1,3) = '801'
				repl mpend.acgroup with 'C6'
				repl mpend.itemope with (fout.rcpt)
				repl mpend.final with fout.amt
				repl mpend.balance with (fout.balamt)
			else
				repl mpend.acgroup with 'D31'
				repl mpend.itemope with - (fout.rcpt)
				repl mpend.final with - fout.amt
				repl mpend.balance with - (fout.balamt)
			endif
			vou =vou+5
			svou=svou+5
		endscan
		****for excess
		sele fout
		set filter to excess  > 0
		go top
		scan
			=seek(subs(ccode+space(12),1,12),'mact')
			sele mpend
			append blank
			repl ord with mact.ordno
			repl mpend.acgroup with 'C6'
			repl mpend.ddate with fout.idate
			repl mpend.vcn with 'EXCESS'
			repl mpend.invtype with 'O'
			repl mpend.voucher  with vou
			repl mpend.svoucher with svou
			repl mpend.duedate with fout.idate
			repl mpend.duedays with duedate-ddate
			if substr(fout.ccode,1,3) = '801'
				repl mpend.acgroup with 'C6'
				repl mpend.itemope with  -(fout.amt-fout.excess)
				repl mpend.final with -(fout.amt)
				repl mpend.balance with -(fout.excess)
			else
				repl mpend.acgroup with 'D31'
				repl mpend.itemope with  fout.amt-fout.excess
				repl mpend.final with fout.amt
				repl mpend.balance with (fout.excess)
			endif
			vou =vou+5
			svou=svou+5
			sele fout
		endsca
		sele mslip
		repl voucher  with vou+5
		repl svoucher with svou+5
	endif
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





	if old_4='W'
		do tr_acvouchers
	endif
	if old_4='N'
		*   do tr_Vouchers
	endif

proc tr_vouchers
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	mvou=voucher+10
	msvou=svoucher+5
	sele sele(1)
	use &datdev\gledger.&datext alias gle
	dele all
	pack
	sele sele(1)
	use &datdev\mdis.&datext alias mdis
	dele all
	pack
	index on vcn to mdis
	sele sele(1)
	use &datdev\dis.&datext alias dis
	dele all
	pack
	sele sele(1)
	use &datdev\pro.&datext alias pro
	index on name to mitm
	sele sele(1)
	use &datdev\order.&datext alias mact
	index on fax2 to mact
	sele sele(1)
	use	&datatransferpath\pur alias pur
	set filter to pdate>=old_5 .and. pdate<=old_9
	index on pno  to pur
	sele sele(1)
	use &datatransferpath\sales alias sal
	index on serial_cod+str(invno,20) to sal
	sele sele(1)
	use &datatransferpath\tax alias ftax
	index on tcode to ftax
	sele sele(1)
	use &datatransferpath\ledger alias led
	index on vno+dtoc(vdate)+mty+lcode to led

	@rowno,10 say '**** Importing Purchases****' font 'Arial',10
	rowno=rowno+1
	sele pur
	go top
	mpno ='9999999999'
	do while !eof()
		=seek(subs(pur.scode+space(12),1,12),'mAct')
		if pno#mpno
			mpno=pno
			addbill='Y'
			mfinal=0
			mvou=mvou+10
			msvou=msvou+5
		endif
		sele led
		seek(substr(pur.pno+space(8),1,8)+dtoc(pur.pdate)+pur.ptype+pur.scode)
		mybillno=substr(led.nar,11,at(' -',led.nar)-11)
		if addbill='Y'
			sele mdis
			appen blank
			repl  voucher with mvou,codep with mact.ordno,type with 'P',vcn with pur.pno,date with pur.pdate,ltype with pcalc,pm with mybillno
			addbill='N'
		endif
		=seek(subs(pur.pcode+space(10),1,10),'pro')
		=seek(pur.tax,'ftax')
		sele dis
		appen blank
		repl voucher with mvou
		repl code with pro.code
		repl codep with mact.ordno
		repl vcn with pur.pno,date with pur.pdate
		repl batch with  pur.batch
		repl exp with ctod('01/'+subs(pur.ed,1,3)+'20'+subs(pur.ed,4,2))
		repl qty with pur.qty,free  with pur.fqty,tax with 'T'
		repl mrp with pur.mrp,rate with pur.prate
		repl disc1 with pur.pdis,disc2 with pur.cdis
		repl ssta with ftax.st/2
		repl cgst with ftax.st/2
		&&ftax.sc
		mfinal=(pur.qty*pur.prate)+pur.cstamt+pur.stamt+pur.scamt-pur.pdisamt-pur.cdisamt-pur.sdisamt
		sele mdis
		repl final with final+mfinal
		sele pur
		skip
	enddo

	@rowno,10 say '**** Importing Sales****' font 'Arial',10
	rowno=rowno+1

	sele sal
	set filt to itype$'S' .and. idate>=old_5 .and. idate<=old_9
	go top
	mpno =9999999999
	scan
		=seek(subs(sal.ccode+space(12),1,12),'mAct')
		mpno=invno
		minvno=alltrim(serial_cod)+'-'+repl('0',6-len(alltrim(str(invno))))+alltrim(str(invno))
		*minvno=ALLTRIM(serial_cod)++repl('0',6-len(alltrim(str(invno))))+alltrim(Str(invno))
		sele mdis
		seek subs(minvno+space(12),1,12)
		if !found()
			mvou=mvou+10
			msvou=msvou+5
			appen blank
			sele mdis
			appen blank
			repl  voucher with mvou,codep with mact.ordno,type with 'S',vcn with minvno,date with sal.idate,ltype with scalc
		endif
		sele sal
		=seek(subs(sal.pcode+space(10),1,10),'pro')
		=seek(sal.tax,'ftax')
		sele dis
		appen blank
		repl voucher with mvou
		repl flg with 'G'
		repl code with pro.code
		repl codep with mact.ordno
		repl vcn with minvno,date with sal.idate
		repl batch with  sal.batch
		repl exp with ctod('01/'+subs(sal.ed,1,3)+'20'+subs(sal.ed,4,2))
		repl qty with sal.qty,free  with sal.fqty,tax with 'T'
		repl mrp with sal.mrp,rate with sal.rate
		repl disc1 with sal.pdis,disc2 with sal.cdis
		repl ssta with ftax.st/2
		repl cgst with ftax.st/2
		mfinal=(sal.qty*sal.rate)+sal.cstamt+sal.stamt+sal.scamt-sal.pdisamt-sal.cdisamt-sal.sdisamt
		sele mdis
		repl final with final+mfinal
	endscan

	@rowno,10 say '**** Importing Sales(pending challan )****' font 'Arial',10
	rowno=rowno+1
	sele sele(1)
	use &datatransferpath\tsales alia tsal
	set filt to itype$'D' and empty(dc_ref) .and. idate>=old_5 .and. idate<=old_9
	go top
	mpno =9999999999
	curchal=0
	do while !eof()
		=seek(subs(tsal.ccode+space(12),1,12),'mact')
		if invno#mpno
			mpno=invno
			addbill='Y'
			mfinal=0
			mvou=mvou+10
			msvou=msvou+5
			curchal=curchal+1
			*  minvno=alltrim(itype)+repl('0',6-len(alltrim(str(curchal))))+alltrim(Str(Curchal))
			minvno=alltrim(itype)+repl('0',6-len(alltrim(str(invno))))+alltrim(str(invno))
		endif
		if addbill='Y'
			sele mdis
			appen blank
			repl  voucher with mvou,codep with mact.ordno,type with 'S',challan with minvno,chdate with tsal.idate,ltype with scalc
			addbill='N'
		endif
		=seek(subs(tsal.pcode+space(10),1,10),'pro')
		=seek(tsal.tax,'ftax')
		sele dis
		appen blank
		repl voucher with mvou
		repl flg with 'G'
		repl code with pro.code
		repl codep with mact.ordno
		repl vcn with minvno,date with tsal.idate
		repl batch with  tsal.batch
		repl exp with ctod('01/'+subs(tsal.ed,1,3)+'20'+subs(tsal.ed,4,2))
		repl qty with tsal.qty,free  with tsal.fqty,tax with 'T'
		repl mrp with tsal.mrp,rate with tsal.rate
		repl disc1 with tsal.pdis,disc2 with tsal.cdis
		if old_12='G'
			if tsal.tax='304' .or. tsal.tax='305' .or. tsal.tax='306' .or. tsal.tax='307'
				repl ssta with ftax.st
				repl cgst with ftax.st
			endi
		else
			repl ssta  with ftax.st
		endi
		mfinal=(tsal.qty*tsal.rate)+tsal.cstamt+tsal.stamt+tsal.scamt-tsal.pdisamt-tsal.cdisamt-tsal.sdisamt
		sele mdis
		repl final with final+mfinal
		sele tsal
		skip
	enddo

	@rowno,10 say '**** Importing Purchase Return(Fresh)****' font 'Arial',10  && SALES RETURN FRESH . OLD
	rowno=rowno+1
	sele sal
	set filt to itype='R' .and. idate>=old_5 .and. idate<=old_9
	go top
	mpno =9999999999
	do while !eof()
		=seek(subs(sal.ccode+space(12),1,12),'mAct')
		if invno#mpno
			mpno=invno
			addbill='Y'
			mfinal=0
			mvou=mvou+10
			msvou=msvou+5
			minvno='CN-'+repl('0',6-len(alltrim(str(invno))))+alltrim(str(invno)) && OLD=CN
		endif
		if addbill='Y'
			sele mdis
			appen blank
			repl  voucher with mvou,codep with mact.ordno,type with 'R',vcn with minvno,date with sal.idate,ltype with scalc &&OLD = R
			addbill='N'
		endif
		=seek(subs(sal.pcode+space(10),1,10),'pro')
		=seek(sal.tax,'ftax')
		sele dis
		appen blank
		repl voucher with mvou
		repl flg with 'R'     && OLD=R
		repl code with pro.code
		repl codep with mact.ordno
		repl vcn with minvno,date with sal.idate
		repl batch with  sal.batch
		repl exp with ctod('01/'+subs(sal.ed,1,3)+'20'+subs(sal.ed,4,2))
		repl qty with sal.qty,free  with sal.fqty,tax with 'T'
		repl mrp with sal.mrp,rate with sal.rate
		repl disc1 with sal.pdis,disc2 with sal.cdis
		repl ssta with ftax.st/2
		repl cgst with ftax.st/2
		mfinal=(sal.qty*sal.rate)+sal.cstamt+sal.stamt+sal.scamt-sal.pdisamt-sal.cdisamt-sal.sdisamt
		sele mdis
		repl final with final+mfinal
		sele sal
		skip
	enddo
	@rowno,10 say '**** Importing Sales Return        ****' font 'Arial',10
	rowno=rowno+1
	sele sal
	set filt to itype='Q' .and. idate>=old_5 .and. idate<=old_9
	go top
	mpno =9999999999
	do while !eof()
		=seek(subs(sal.ccode+space(12),1,12),'mAct')
		if invno#mpno
			mpno=invno
			addbill='Y'
			mfinal=0
			mvou=mvou+10
			msvou=msvou+5
			minvno='DN-'+repl('0',6-len(alltrim(str(invno))))+alltrim(str(invno))

		endif
		if addbill='Y'
			sele mdis
			appen blank
			repl  voucher with mvou,codep with mact.ordno,type with 'B',vcn with minvno,date with sal.idate,ltype with scalc
			addbill='N'
		endif
		=seek(subs(sal.pcode+space(10),1,10),'pro')
		=seek(sal.tax,'ftax')
		sele dis
		appen blank
		repl voucher with mvou
		repl flg with 'B'
		repl code with pro.code
		repl codep with mact.ordno
		repl vcn with minvno,date with sal.idate
		repl batch with  sal.batch
		repl exp with ctod('01/'+subs(sal.ed,1,3)+'20'+subs(sal.ed,4,2))
		repl qty with sal.qty,free  with sal.fqty,tax with 'T'
		repl mrp with sal.mrp,rate with sal.rate
		repl disc1 with sal.pdis,disc2 with sal.cdis
		repl ssta with ftax.st/2
		repl cgst with ftax.st/2
		mfinal=(sal.qty*sal.rate)+sal.cstamt+sal.stamt+sal.scamt-sal.pdisamt-sal.cdisamt-sal.sdisamt
		sele mdis
		repl final with final+mfinal
		sele sal
		skip
	enddo
	sele mdis
	repl all remark4 with str(final,14,2)
	@rowno,10 say '**** Importing A/C Transactions****' font 'Arial',10
	rowno=rowno+1
	sele led
	set filt to mty$'CTUVWX' .and. vdate>=old_5 .and. vdate<=old_9
	go top
	mvno ='XXXXXXXXXXXX'
	mtype='9'
	mdate=ctod('  /  /    ')
	go top
	do while !eof()
		if vno+dtoc(vdate)+mty#mvno+dtoc(mdate)+mtype
			mvou=mvou+10
			mtype=mty
			mvno=vno
			mdate=vdate
		endif
		if 'X'$mty
			mbook='J'
		else
			if 'VWICTUL'$mty
				mbook=iif('VWI'$mty,'P',iif(dr>0 and 'C'$mty,'P','R'))
			else
				if mty$'SR'
					mbook=iif(mty='S','S','E')
				else
					if mty$'PQE'
						mbook=iif(mty='P','A','D')
					else
						mbook='S'
					endif
				endif
			endif
		endif
		=seek(subs(lcode+space(12),1,12),'mact')
		sele gle
		appen blank
		repl voucher with mvou,cd with iif(led.cr>0,'C','D'),code with mact.ordno
		repl credit with iif(led.cr>0,led.cr,0),debit with iif(led.dr>0,led.dr,0)
		repl date with mdate,remark1 with alltrim(led.nar),vcsno with led.vno
		repl advance with iif(led.mty='C','Y','')
		repl book with mbook
		sele led
		skip
	enddo
	sele mslip
	repl voucher with mvou



proc tr_acvouchers
	sele sele(1)
	use &datdev\slipno.&datext alias mslip
	go top
	mvou=voucher+10
	msvou=svoucher+5
	sele sele(1)
	use &datdev\gledger.&datext alias gle
	dele all
	pack
	sele sele(1)
	use &datdev\order.&datext alias mact
	index on fax2 to mact
	sele sele(1)
	use &datatransferpath\ledger alias led
	set filter to vdate>=old_5 .and. vdate<=old_9
	index on vno+dtoc(vdate)+mty to led
	@rowno,10 say '**** Importing A/C Transactions****' font 'Arial',10
	rowno=rowno+1
	sele led
	*!*	Set filt to mty$'CTUVWX'
	go top
	mvno ='XXXXXXXXXXXX'
	mtype='9'
	mdate=ctod('  /  /    ')
	go top
	do while !eof()
		if vno+dtoc(vdate)+mty#mvno+dtoc(mdate)+mtype
			mvou=mvou+10
			mtype=mty
			mvno=vno
			mdate=vdate
		endif
		if 'X'$mty
			mbook='J'
		else
			if 'VWICTUL'$mty
				mbook=iif('VWI'$mty,'P',iif(dr>0 and 'C'$mty,'P','R'))
			else
				if mty$'SR'
					mbook=iif(mty='S','S','E')
				else
					if mty$'PQE'
						mbook=iif(mty='P','A','D')
					endif
				endif
			endif
		endif
		=seek(subs(lcode+space(12),1,12),'mact')
		sele gle
		appen blank
		repl voucher with mvou,cd with iif(led.cr>0,'C','D'),code with mact.ordno
		repl credit with iif(led.cr>0,led.cr,0),debit with iif(led.dr>0,led.dr,0)
		repl date with mdate,remark1 with iif(isnull(alltrim(led.nar)),'',alltrim(led.nar)),vcsno with led.vno
		repl advance with iif(led.mty='C','Y','')
		repl book with mbook
		sele led
		skip
	enddo
	sele mslip
	repl voucher with mvou
	close table all

proc upd_outs
	retu
	close table all
	@rowno,10 say '**** Importing Updating Bill Wise Outstanding****' font 'Arial',10
	rowno=rowno+1
	af=datdev + '\pendings.'+datext
	bf=datdev + '\slipno.'+datext
	cf=datatransferpath + 'outstand.dbf'
	df=datdev + '\order.'+datext
	sele sele(1)
	use &datatransferpath\acmas alias fact
	index on code  to acmas
	sele sele(1)
	use &af alias mpend
	sele sele(1)
	use &bf alias mslip
	sele sele(1)
	use &cf alias fout
	sele sele(1)
	use &df alias mact
	index on fax2  to mact
	sele mslip
	go top
	vou =voucher  + 10
	svou=svoucher + 10
	sele mpend
	repl all itemope with final,balance with 0
	sele fout
	set filter to balamt > 0 .and. idate>=old_5 .and. idate<=old_9
	go top
	do while .not. eof()
		=seek(subs(ccode+space(12),1,12),'mact')
		sele mpend
		append blank
		repl ord with mact.ordno
		repl mpend.acgroup with 'C6',;
			mpend.ddate with fout.idate,;
			mpend.vcn with fout.invno,;
			mpend.invtype with 'O',;
			mpend.voucher  with vou,;
			mpend.svoucher with svou,;
			mpend.duedate with fout.idate,;
			mpend.duedays with duedate-ddate
		if substr(fout.ccode,1,3) = '801'
			repl mpend.acgroup with 'C6'
			repl mpend.itemope with (fout.rcpt),;
				mpend.final with fout.amt,;
				mpend.balance with (fout.balamt)
		else
			repl mpend.acgroup with 'D31'
			repl mpend.itemope with - (fout.rcpt),;
				mpend.final with - fout.amt,;
				mpend.balance with - (fout.balamt)
		endif
		vou =vou+5
		svou=svou+5
		sele fout
		skip
	enddo
	****for excess
	sele fout
	set filter to excess  > 0
	go top
	do while .not. eof()
		=seek(subs(ccode+space(12),1,12),'mact')
		sele mpend
		append blank
		repl ord with mact.ordno
		repl mpend.acgroup with 'C6',;
			mpend.ddate with fout.idate,;
			mpend.vcn with 'EXCESS',;
			mpend.invtype with 'O',;
			mpend.voucher  with vou,;
			mpend.svoucher with svou,;
			mpend.duedate with fout.idate,;
			mpend.duedays with duedate-ddate
		if substr(fout.ccode,1,3) = '801'
			repl mpend.acgroup with 'C6'
			repl mpend.itemope with  -(fout.amt-fout.excess) ,;
				mpend.final with -(fout.amt),;
				mpend.balance with -(fout.excess)
		else
			repl mpend.acgroup with 'D31'

			repl mpend.itemope with  fout.amt-fout.excess ,;
				mpend.final with fout.amt,;
				mpend.balance with (fout.excess)
		endif
		vou =vou+5
		svou=svou+5
		sele fout
		skip
	enddo
	********

	sele mslip
	repl voucher  with vou+5
	repl svoucher with svou+5

	close table all

proc  removenull
	use &datatransferpath\tax
	do rem_null
	use &datatransferpath\promas
	do rem_null
	use &datatransferpath\mfrmast
	do rem_null
	use &datatransferpath\area
	do rem_null
	use &datatransferpath\product
	do rem_null
	use &datatransferpath\acmas
	do rem_null
	use &datatransferpath\outstand
	do rem_null
	use &datatransferpath\ledger
	do rem_null

proc  rem_null
	a = afields(arr)
	for i = 1 to a
		mfldname = arr(i, 1)
		do case
			case inlist(arr(i,2), "C","V")
				replace all &mfldname with '' for isnull(&mfldname)
			case inlist(arr(i,2), "B","N","I","F","Y")
				replace all &mfldname with 0 for isnull(&mfldname)
			case inlist(arr(i,2), "D","T")
				replace all &mfldname with ctod('') for isnull(&mfldname)
		endcase
	endfor
