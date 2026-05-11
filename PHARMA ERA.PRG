*!*	BOF : speedplus.....Modify By Umesh
*!* for bill difference ## in support -> repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
*!* for item difference ## in support -> repl type with "#",aliase with "DAT/F-IT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for item batch difference ## in support -> repl type with "#",aliase with "DAT/F-BT",pcode with mitm.code,heading with iif(old_11="B",fsbal.batchno,str(fsbal.mrp,9,2)),value with fsbal.stock
*!* for ledger difference ## in support -> repl type with "#",aliase with "DAT/F-LD",Lcode with mact.ordno,value with TOT
clear
clos tabl all
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
brow font 'COURIER',18    nomodify
IF TYPE ('FINALCP')='U'
firstdate=ctod('01/04/2025')
lastdate= ctod('31/03/2026')
datdev='d:\Transfer'
datext= 'DBF'
endif
datatransfermdb='No '
datatransferpath=substr('D:\2025\Dec\Pharmaera\Data\data\'+space(100),1,100)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
old_7 = 'G'
softtype='Retail'
scalc='9'
pcalc='2'
mstatecode='27'
removenull='YES'
sure='SURE'
mrgmdbfile=space(100)
mrgmdbpwd=space(30)
@06,10 say 'Convert DBF From MDB  :' font 'Courier',12 get datatransfermdb  pict '@^m No ,Yes'  Font 'courier',12  valid mdbsqlconvert(1)
@07,10 Say 'Miracle Data Path    :' Font 'Courier',12  Get datatransferpath  Font 'courier',12
@08,10 Say 'Miracle Extension    :' Font 'Courier',12  Get datatransferext  Font 'courier',12
read
@09,10 Say 'With Outstanding Y/N :' Font 'Courier',12  Get old_3 Pict '@m Yes,No '  Font 'Courier',12
@10,10 Say 'No-Full Yes-Master   :' Font 'Courier',12  Get old_4 Pict '@m No,Yes'  Font 'Courier',12
@11,10 Say 'F.Y.BEGIN Date       :' Font 'Courier',12  Get old_5  Font 'Courier',12
@12,10 Say 'F.Y.End   Date       :' Font 'Courier',12  Get old_6   Font 'Courier',12
@13,10 Say 'G-GST  V-Vat         :' Font 'Courier',12  Get old_7  Font 'Courier',12
@14,10 Say 'Software Type        :' Font 'Courier',12  Get softtype Pict '@m Wholesale,Retail   '   Font 'Courier',12
@15,10 Say 'Sales Calculation    :' Font 'Courier',12  Get scalc   Font 'Courier',12
@16,10 Say 'Purch.Calculation    :' Font 'Courier',12  Get pcalc   Font 'Courier',12
@17,10 Say 'State Code           :' Font 'Courier',12  Get mstatecode Font 'Courier',12
@18,10 Say 'Remove Null          :' Font 'Courier',12  Get Removenull Pict '@m No ,Yes'   Font 'Courier',12
@19,10 Say 'Type SURE            :' Font 'courier',12  Get sure Pict '@x!' Font 'courier',12
read
clear
datatransferpath=alltrim(datatransferpath)
if !right(datatransferpath,1)='\'
	datatransferpath=alltrim(datatransferpath)+'\'
endif
datatransferext='.'+alltrim(datatransferext)
datdev= alltrim (datdev)
datext= alltrim (datext)
if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
CLEAR
IF TYPE('FINALCP')#'U'
 =starttransfer()
ENDIF
if removenull='Y'
	@ 08,15 say 'Removing Null Values........     Please Wait..........' font 'Courier',12
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endi
clea
rowno=5
@ 02,22 say 'Please Wait Importing Miracle Data To Marg.....' font 'Arial',14 colo 'W+/G'
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
dele all for type='#' and aliase='DAT/F'
pack
close data
set colo to
@rowno,10 say '**** Importing Company  ****' font  'courier',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemcompany&datatransferext  alias comp
sele sele(1)
use &datdev\saletype.&datext alias stype
dele all for sgcode = 'ZZZZZZ'
pack
sele comp
scan
	sele stype
	appen blank
	repl sgcode with 'ZZZZZZ',scode with alltrim(str(comp.itemcompan,6))
	repl parnam with comp.itemcompa2,sname with comp.itemcompa2
endscan
close data

@rowno,10 say '**** Importing Category  ****' font 'courier',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\itemgroup&datatransferext alias grp
sele sele(1)
use &datdev\saletype.&datext alias stype
dele all for sgcode='CATEGO'
pack
sele grp
scan
	sele stype
	appen blank
	repl sgcode with 'CATEGO',scode with alltrim(str(grp.itemgroupi,6))
	repl parnam with grp.itemgroupn,sname with grp.itemgroupn
endscan
close data

@rowno,10 say '**** Importing Product with HSN  ****' font 'courier',12
rowno=rowno+1
sele sele(1)
use &datdev\saletype.&datext alias stype
dele all for sgcode = 'COMMCD'
pack
inde on sgcode+parnam+str(igst,6,2) to stype
sele sele(1)
use &datatransferpath\items&datatransferext alias fpro
do memo2chr
sele sele(1)
use &datatransferpath\pack alias pack
index on itemid to pack
sele sele(1)
use &datatransferpath\unit&datatransferext alias unit
index on unitid to unit
sele sele(1)
use &datatransferpath\vatslab&datatransferext alias ftax
index on vatslabid to ftax
sele sele(1)
use &datdev\pro.&datext alias pro
dele all
pack
sele fpro
scan
	=seek(itemid,'pack')
	=seek(unitid,'unit')
	sele pro
	appen blank
	repl code with fpro.itemid
	repl name with alltrim(str(fpro.itemid))
	repl product with fpro.itemname
	replace unit with unit.unitname
	repl billname with alltrim(fpro.itemname)+' '&&+fpro.packing
	repl gcode with alltrim(str(fpro.itemcompan,6))
	repl gcode5 with alltrim(str(fpro.itemgroupi,6))
	repl pack with iif(fpro.conversion=1,0,fpro.conversion)
	repl pack with iif(softtype='R',fpro.qtypercase,0)
	repl saltax  with fpro.vatpercent
	repl taxl with iif(fpro.vatpercent#0,'T','P')
	repl decimal with 'Y'
	if old_7='G'
		if empty(fpro->hsncode)
			loop
		endi
		=seek(fpro->vatslabid,'ftax')
		if found('ftax')
			sele stype
			if !seek('COMMCD'+padr(fpro->hsncode,15)+str(ftax->igstpercen,6,2),'stype')
				appen blank
				repl sgcode with 'COMMCD',;
					scode with right(sys(2015),6),;
					parnam with padr(fpro->hsncode,15),;
					sname with padr(fpro->hsncode,15),;
					tax with ftax->sgstpercen,;
					cgst with ftax->cgstpercen,;
					igst with ftax->igstpercen
			endi
			sele pro
			repl gcode6 with stype->scode
			repl saltax with stype->tax
			repl cgst with stype->cgst
			repl igst with stype->igst
		endif
	endi
	sele pro
endscan
close data

@rowno,10 say '**** Importing Stock  ****' font 'courier',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\batch&datatransferext alias fstock

sele sele(1)
use &datatransferpath\inventory&datatransferext  alias tran
index on str(itemid,6)+str(batchid,6) to tran
sele sele(1)
use &datdev\pro.&datext alias pro
index on str(code,9) to pro
sele sele(1)
use &datdev\support.&datext alias support
index on pcode to support
sele sele(1)
use &datdev\probat.&datext alias probat
dele all
pack
index on code to probat

sele fstock
scan
	=seek(str(itemid,9),'PRO')
	sele probat
	appen blank
	repl code with pro.code
	repl name with pro.name
	repl product with pro.product
	repl packing with pro.packing
	repl pack with iif(pro.pack=0,1,pro.pack)
	repl billname with pro.billname
	repl batchno with fstock.batchno
	repl lprate with fstock.basicprice
	repl ratea with fstock.saleprice
	repl mrp with fstock.mrp
	repl prate with fstock.purchasepr
	repl exp with ctod('01/'+chrtr(fstock.expirydate,'-','/'))
	repl opening with iif(old_4='N',fstock.opstock*pack,0)
	repl balance with iif(old_4='N',fstock.opstock*pack,0)
	repl o_a with iif(old_4='N',fstock.opstock*pack,0)
	repl b_a with iif(old_4='N',fstock.opstock*pack,0)
	sele tran
	seek str(fstock.itemid,6)+str(fstock.batchid,6)
	sum iif(transactio='Purchase       '  or transactio='Sale Return' or transactio='Purchase Challan   ' ,qty+free,0),iif(transactio='Sale      '  or transactio='Purchase Return   ' or transactio='Purchase Challan   ' or transactio='Sale Challan       ' ,(qty+free),0) to tot1,tot2 while itemid=fstock.itemid and batchid=fstock.batchid
	stockcl=probat.opening+tot1-tot2
            if old_4='Y'
            sele probat
            repl opening with stockcl
            repl o_a with stockcl
            repl balance with stockcl
            repl b_a with stockcl
            endi
	sele pro
	repl ratea with probat.ratea,mrp with probat.mrp,prate with probat.prate,lprate with probat.lprate
&& UPDATING SUPPORT FOR BATCH STOCK DIFF
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-BT",pcode with pro.code,heading with fstock.batchno,value with stockcl
endscan
sele pro
scan
	sele support
	seek pro.code
	sum value to tot while support.pcode=pro.code
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-IT",pcode with pro.code,value with tot
endscan
close data

@rowno,10 say '**** Importing Ledgers   ****' font 'courier',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\account&datatransferext alias fact
do memo2chr
sele sele(1)
use &datatransferpath\ledger&datatransferext alias tran
do memo2chr
sele tran
index on accountid to tran
sele sele(1)
use &datdev\support.&datext alias support
index on aliase + str(sno,3) + lcode to msup
dele all for aliase = 'ORDER   '
dele all for aliase = "DAT/F-LD"
pack
sele sele(1)
use &datdev\order.&datext alias mact
dele all
pack
sele fact
scan
	mopbal=iif(fact.dc='C',-opbal,opbal)
	sele mact
	appen blank
	do case
	case fact.accountsgr=1
		repl scode with 'B'
	case fact.accountsgr=2
		repl scode with 'C'
	case fact.accountsgr=3
		repl scode with 'D'
	case fact.accountsgr=4
		repl scode with 'E'
	case fact.accountsgr=5
		repl scode with 'F'
	case fact.accountsgr=6
		repl scode with 'G'
	case fact.accountsgr=8
		repl scode with 'I'
	case fact.accountsgr=9
		repl scode with 'J'
	case fact.accountsgr=11
		repl scode with 'C2'
	case fact.accountsgr=12
		repl scode with 'C1'
	case fact.accountsgr=13
		repl scode with 'C3'
	case fact.accountsgr=14
		repl scode with 'C4'
	case fact.accountsgr=15
		repl scode with 'C5'
	case fact.accountsgr=16 or fact.accountsgr=23 or fact.accountsgr=99
		repl scode with 'C6'
	case fact.accountsgr=17 or fact.accountsgr=24 or fact.accountsgr=100
		repl scode with 'D31'
	case fact.accountsgr=18
		repl scode with 'D1'
	case fact.accountsgr=19
		repl scode with 'J12'
	case fact.accountsgr=20
		repl scode with 'G2'
	case fact.accountsgr=21
		repl scode with 'G3'
	case fact.accountsgr=24
		repl scode with 'J11'
	case fact.accountsgr=25
		repl scode with 'J12'
	case fact.accountsgr=26
		repl scode with 'J3'
	case fact.accountsgr=28
		repl scode with 'G1'
	case fact.accountsgr=29
		repl scode with 'B1'
	case fact.accountsgr=24
		repl scode with 'J11'
	endcase
	repl ordno with alltrim(str(fact.accountid))
	repl mailnam with upper(fact.accountnam)
	repl parnam with upper(fact.accountnam)
	repl paradd with fact.address
	repl paradd1 with fact.address2
	repl city with fact.city
	repl phone1 with fact.phone
	repl cstno with fact.tinno,csthed with 'TIN NO:'
	repl dlno with alltrim(fact.dlno1)+' '+alltrim(fact.dlno2)
	repl itno with fact.itpan
	repl gstno with fact.ot21
	repl limit with fact.creditlimi,duedays with fact.creditdays
	sele tran
	seek fact.accountid
	sum iif(dc='D',amount,0),iif(dc='C',amount,0) to dr,cr while accountid =fact.accountid
	sele mact
	if old_4='Y'
	repl opning with dr-cr&& mopbal+
	else
	repl opning with  mopbal
            endi
** UPDATING SUPPORT LEDGER DIFF
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with mact.balance
** State
	sele support
	seek 'ORDER   ' + '  7' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(fact.ot21,1,2)='  ',mstatecode,subs(fact.ot21,1,2))+'                                           '
endscan
close data

if old_4='N'
do full_tf
endi
proc full_tf
@rowno,10 say '**** Importing Inventory Transaction  ****' font 'courier',12
rowno=rowno+1
mdis=datdev+ '\mdis.'+datext
af =datdev + '\gledger.'+datext
bf =datdev + '\slipno.'+datext
dis=datdev + '\dis.'+datext
pro=datdev + '\pro.'+datext
ord=datdev + '\order.'+datext
sp=datdev +'\support.'+datext
sal=datatransferpath +'voucher'+datatransferext
sld=datatransferpath +'Inventory'+datatransferext
sele select(1)                         
use &datdev\support.&datext alias support
index on type+aliase to support
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
last4 = voucher+10
slast5= svoucher+10

last4=last4+20
sele e
use &pro alias pro
inde on code to pro

sele select(1)
use &ord alias ord
index on ordno to ord
sele c
use &sal alias sal
set filter to entrydate>=old_5 and entrydate<=old_6
do memo2chr
set filter to  (transactio='Purchase                                          ' or transactio='Sale                                              ' or transactio='Sale Return                                       ' or transactio='Purchase Return                                   ' or transactio='Purchase Challan   ' or transactio='Sale Challan                    ') and (entrydate>=old_5 and entrydate<=old_6 )
sele h
use &sld alias sld
index on voucherid to sld

sele d
use &mdis alias mdis
zap
sele g
use &dis alias dis
zap

sele c
go top
do while .not. eof()
	select ord
	seek str(c.partyid,6)

	last1=c.voucherid
	sele d
	appe blank

	if c.transactio='Purchase                                          '
		repl type with 'P'
		repl vcn with 'P'+alltrim(str(c.vchno))
		repl date with c.entrydate
		repl pm with c.purchasebi && updated party code dated 31-12-2019
	else
		if c.transactio='Sale                                              '
			repl type with 'S'
			if c.subtype='Retail       '
				repl vcn with 'S'+alltrim(str(c.vchno))
				repl date with c.entrydate
			else
				repl vcn with 'T'+alltrim(str(c.vchno))
				repl date with c.entrydate
			endif
		else
			if  c.transactio='Purchase Return                                   '
				repl type with 'B'
				repl vcn with 'PR'+alltrim(str(c.vchno))
				repl date with c.entrydate
			else
				if c.transactio='Sale Return                                       '
					repl type with 'R'
					repl vcn with 'SR'+alltrim(str(c.vchno))
					repl date with c.entrydate
				else
					if c.transactio='Purchase Challan   '
						repl type with 'P'
						repl challan with 'PC'+alltrim(str(c.vchno))
						repl chdate with c.entrydate
					else
						if c.transactio='Sale Challan                              '
							repl type with 'S'
							repl challan with 'SC'+alltrim(str(c.vchno))
							repl chdate with c.entrydate


						endif
					endif
				endif
			endif
		endif
	endif
	repl codep with padr(c.partyid,6)
	repl voucher with last4&&c.voucherid
	last4=last4+5
	repl amountp with iif(empty(c.billsundry),round(c.subtotal,2),round(c.totalamoun,2))
	repl salun with ''
	repl staxun with 'SZTZOZ'
	if c.paymentter='Cash     '
		repl cash with iif(empty(c.billsundry),round(c.subtotal,2),round(c.totalamoun,2))
	else
		repl final with iif(empty(c.billsundry),round(c.subtotal,2),round(c.totalamoun,2))
	endif
	if final=0 .and. cash#0
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	else
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	endif
	repl duedays with 0
	repl lrda with c.date
	repl account with 'N'
	
	repl sale with IIF(inlist(d.type,'P','B'),'z','Z')
	repl godwon with 'A'
	repl ltype with iif(d.type$'PB',pcalc,scalc)
	repl discafter with 'N'
	repl remark4 with alltrim(str(c.vchno))
	repl remark1 with iif(empty(c.billsundry),str(c.subtotal,2),str(c.totalamoun,12,2))
	repl other with c.billsundry
	repl othun with 'STcA%-'
	isigst=0
	if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
		isigst=1

	endif
&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
	sele support
	appen blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele h
	seek last1
	do while .not. eof() .and. h.voucherid= last1 .and.  h.vchno=c.vchno
		sele pro
		seek h.itemid
		sele g
		appe blank
		repl codep with d.codep
		repl vcn with iif(empty(d.vcn),d.challan,d.vcn)
		repl date with iif(empty(d.date),d.chdate,d.date)
		repl voucher with d.voucher
		repl code with h.itemid
		repl tax with 'T'
		repl pack with pro.pack
		repl qty with h.qty*iif(pack#0,pack,1)
		repl free with h.free*iif(pack#0,pack,1)
		repl batch with h.batchno
		repl exp with ctod('01'+'/'+substr(h.expirydate,1,2)+'/'+substr(h.expirydate,4,4))
		if (h.transactio='Sale' or h.transactio='Sale Challan' ).and. d.type = 'S'  &&& UPDATED BY NIVEDAN SHARMA DATED 05/11/2019
			repl flg with 'G'
		else
			if  h.transactio='Sale Return'
				repl flg with 'R'
			else
				repl flg with d.type
			endif
		endif
		if h.primaryun2#'Box' 
			repl rate with h.selectedpr
			repl qty with h.qty*iif(pack#0,pack,1)
		else
			repl rate with h.selectedpr&&*iif(pack=0,1,pack)
			repl qty with h.qty
		endif
		repl disc1 with h.discountra
		repl disc2 with h.on2
		if isigst=1
			repl ssta with h.igstpercen
		else

			repl ssta with h.sgstpercen
			repl cgst with h.sgstpercen
		endif

		repl mrp with h.mrp
		repl half with 'A'
		repl godwon with d.godwon

		sele h
		skip
	enddo
	sele c
	skip
enddo
close data
@rowno,10 say '**** Importing Account from Sales ****' font 'Arial',12
rowno=rowno+1
af   =datdev+'\gledger.'+datext
pend =datdev+'\pend.'+datext
mdis =datdev+'\mdis.'+datext
pending=datdev+'\pendings.'+datext
sele g
use &pending alias pending
zap
sele f
use &pend alias pend
zap
sele b
use &af alias gledger
zap
sele d
use &mdis alias mdis
go top
do while .not. eof()
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
				repl final with mdis.final
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

@rowno,10 say '**** Importing Ledgers Transaction(Receipt/Payment)   ****' font 'courier',12
rowno=rowno+1
af      = datdev + '\gledger.'+datext
bf      = datdev + '\slipno.'+datext
cf      = datatransferpath+'voucher'+datatransferext
pend    = datdev + '\pend.'+datext
pending = datdev + '\pendings.'+datext
sele g
use &pending alias pending
index on ord + substr(name,1,12) to rou2
last4  = last4 + 10
slast5 = slast5 + 10
sele f
use &pend alias pend
sele b
use &af alias gledger
sele a
use &cf alias led
set filter to transactio='Quick Receipt                          ' or transactio='Quick Payment                             ' or transactio='Chq Issd                                          ' or transactio='Chq Recd                                          ' and date>=old_5
go top
do while !eof()
last4=last4+10
*** Debit Credit Vice versa ***
	sele b
	append blank
	repl vcsno with alltrim(str(a.vchno))
	repl voucher with last4
	if a.transactio='Quick Payment                             ' or a.transactio='Chq Issd                                          '
		repl cd with 'D'
		repl debit with a.totalamoun
		repl code with padr(a.partyid,6)
		repl code1 with padr(a.accountid,6)
		repl book with 'P'
	else
		if a.transactio='Chq Recd                                          ' or a.transactio='Quick Receipt                          '
			repl cd with 'C'
			repl credit with a.totalamoun
			repl code with  padr(a.partyid,6)
			repl code1 with padr(a.accountid,6)
			repl book with 'R'
		endif
	endif
	repl date with a.entrydate
	repl remark1 with a.longnarrat
*** Debit Credit Vice versa
	sele b
	append blank
	repl vcsno with alltrim(str(a.vchno))
	repl voucher with last4
	if a.transactio='Quick Payment                             ' or a.transactio='Chq Issd                                          '
		repl cd with 'C'
		repl credit with a.totalamoun
		repl code1 with padr(a.partyid,6)
		repl code with padr(a.accountid,6)
		repl book with 'P'
	else
		if a.transactio='Chq Recd                                          ' or a.transactio='Quick Receipt                          '
			repl cd with 'D'
			repl debit with a.totalamoun
			repl code1 with padr(a.partyid,6)
			repl code with padr(a.accountid,6)
			repl book with 'R'
		endif
	endif
	repl date with a.entrydate
	repl remark1 with a.longnarrat
	sele a
	skip
enddo
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
endproc
func mdbsqlconvert(mdbsqlpara1)
do case
case mdbsqlpara1=1
	if datatransfermdb='Y'
		mrgmdbfile=alltrim(getfile('mdb'))
		datatransferpath=subs(fullpath(mrgmdbfile)+'\Miracle_data\'+space(80),1,80)

		datatransferpath=alltrim(datatransferpath)
		=mdbsqlconvert(2)
	endif
case mdbsqlpara1=2 and datatransfermdb='Y'
	clear
	mrgmdbfile=alltrim(mrgmdbfile)
	mrgmdbpwd=alltrim(mrgmdbpwd)
	datatransferpath=subs(justpath(mrgmdbfile)+'\Miracle_data\'+space(80),1,80)
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
	datatransferpath=subs(fullpath(curdir())+'Miracle_data\'+space(80),1,80)
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
	clear
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
&& Removing Null form TAble

proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y","M")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T","M")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor
&&&&& Memo to Charachter
proc memo2chr
tbl=alia()
set memo to 8000
sele &tbl
marr=afield(tarr)
for i=1 to marr
	if tarr[i,2]='M'
		fldname=tarr[i,1]
		alter table &tbl alter column &fldname c(254)
	endi
	@rowno,10	say'Wait while Fetching records :' +str(i,10) font 'courier',12
next
rowno=rowno+1
endproc
