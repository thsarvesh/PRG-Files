***Samarth Retail**
clear
close table all
set talk off
set date to brit
set cent on
set dele on
set safe off
sele sele(1)
if type('FINALCP')='U'
	firstdate=ctod('01/04/2024')
	lastdate= ctod('31/03/2025')
	datdev='E:\umeshmarg\whol\'
	datext= 'dbf'
endi
datatransferpath=substr('D:\Umesh_2425\June\samarth\NEw\'+space(100),1,100)
datatransferext='DBF'
datatransfersql='No '
datatransfermdb='No '
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
scalc='9'
pcalc='2'
mstatecode='27'
sure='SURE'
removenull='No '
if type('FINALCP')#'U'
rest screen from simple
colofhed="SAMARTH SOFTWARE RETAIL MIGRATION TO MARG ERP"
=colofil(3,0,16.5,80,10)
endi
@ 04,1 say 'SAMARTH Data Path    :' get datatransferpath
@ 05,1 say 'SAMARTH Extension    :' get datatransferext
@ 06,1 say 'With Outstanding Y/N :' get old_3 pict '@^m Yes,No ' FONT'cambria',13
@ 07,1 say 'No-Full Yes-Master   :' get old_4 pict '@^m No,Yes' FONT'cambria',13
@ 08,1 say 'F.Y.BEGIN Date       :' get old_5
@ 09,1 say 'F.Y.End   Date       :' get old_6
@ 10,1 say 'State Code           :' get mstatecode
@ 11,1 say 'Sales Cal            :' get scalc
@ 12,1 say 'Purch Cal            :' get pcalc
@ 13,1 say 'Removenull           :' get removenull pict '@^ No ,Yes' FONT'cambria',13
@ 14,1 say 'Type SURE            :' get sure pict '@x!'
@ 15.5,2 get mychoice pict "@*TH \<Transfer;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
read
if lastkey()=27 or mychoice=2
   return
endif

clear
close table all
datatransferpath=alltrim(datatransferpath)
if !right(datatransferpath,1)='\'
	datatransferpath=alltrim(datatransferpath)+'\'
endif
datatransferext=alltrim(datatransferext)
datdev= alltrim(datdev)
datdev= alltrim(datdev)
if !dire(datatransferpath)
	md &datatransferpath
endif
if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
IF TYPE('FINALCP')#'U'
	=starttransfer()
ENDIF
if removenull='Y'
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next
endif
rowno=5

@ 02,22 say 'Please Wait Importing SAMARTH Data To Marg.....' font 'Arial',14 colo 'W+/G'

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
use &datdev\subdis.&datext
zap
use &datdev\glmonth.&datext
zap
use &datdev\ggmonth.&datext
zap
use &datdev\support.&datext
zap
close table all
set colo to

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer ITEM"
fd=datatransferpath+'ADMTIT.'+datatransferext
td=datdev+'\pro.'+datext
ts=datdev+'\saletype.'+datext
sp=datdev+'\support.'+datext

sele sele(1)
use &sp alias msup
dele all for aliase = "DAT/F-IT"
pack

sele d
use &ts alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm

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
	seek substr(alltr(str(fitm.itcd))+space(10),1,10)
	if .not. foun()
		append blank
		repl code with last
		repl name with alltr(str(fitm.itcd))
		repl product with upper(fitm.itnm)
		repl packing with fitm.packing
		repl billname with alltrim(upper(fitm.itnm))+'  '+alltrim(fitm.packing)
		repl unit with 'Pcs'
		repl taxl with 'T'
		repl taxc with 'T'
		repl decimal with 'Y'
		repl salfix with 'N'
		repl gcode with padr(fitm.cocd,6)
		repl minimum with fitm.minlvl
		repl halfsche with 'A'
		repl qtrsche with 'Y'
		repl saltax with fitm.sgstper
		repl cgst with fitm.cgstper
		repl igst with fitm.igstper
		repl status with 'Y'
		repl ratea with fitm.rate
		repl rateb with fitm.brate
		repl prate with fitm.prate
		repl mrp with fitm.mrp
		repl lprate with fitm.brate
		repl rackno2 with alltr(str(fitm.loc))
		repl rackno with padr(fitm.itcdb,20)
	endif
	***For Hsncode***
	sele mpcm
	seek 'COMMCD' + substr(fitm.hsncode+space(15),1,15) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl sgcode with 'COMMCD'
		repl scode  with 'C'+alltrim(str(last))
		repl sname  with substr(fitm.hsncode+space(15),1,15)+ substr(fitm.hsncode,1,15) +' '+ alltrim(str(mitm.igst,5,2))
		repl parnam with substr(fitm.hsncode,1,15)
		repl tax with mitm.saltax
		repl cgst with mitm.cgst
		repl igst with mitm.igst
	endif
	repl mitm.gcode6 with mpcm.scode
	sele fitm
	skip
enddo
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Company"
fd=datatransferpath+'ADMTCO.'+datatransferext
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
	repl sgcode with 'ZZZZZZ'
	repl scode  with padr(fpcm.cocd,6)
	repl sname  with upper(fpcm.conm)
	repl parnam with upper(fpcm.conm)
	sele fpcm
	skip
enddo
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Batch"
fd=datatransferpath+'admtib.'+datatransferext
td=datdev+'\probat.'+datext
mi=datdev+'\pro.'+datext
sp=datdev+'\support.'+datext

sele a
use &fd alias fsbal
sele b
use &mi alias mitm
index on name to mitm
sele c
use &td alias msbal
zap
index on name + batchno to msbal

r=0
sele fsbal
go top
do while .not. eof()
	sele mitm
	seek substr(alltr(str(fsbal.itcd))+space(10),1,10)
	sele msbal
	seek substr(alltr(str(fsbal.itcd))+space(10),1,10) + substr(fsbal.bchno+space(12),1,12)
	if .not. found()
		append blank
		repl code with mitm.code
		repl name with mitm.name
		repl billname with mitm.billname
		repl product with mitm.product
		repl packing with mitm.packing
		repl pack with mitm.pack
		repl unit2 with mitm.unit2
		repl unit with mitm.unit
		repl decimal with 'Y'
		repl batchno with fsbal.bchno
		repl exp with ctod('01/'+subs(fsbal.expdt,1,2)+'/20'+subs(fsbal.expdt,4,2))
		repl prate with fsbal.prate
		repl lprate with fsbal.npr
		repl ratea with fsbal.rate
		repl ratec with fsbal.brate
		repl mrp with fsbal.mrp
		repl misc1 with mitm.gcode
		repl mycode with padl(alltr(str(fsbal.itcd)),6,'0')+padl(alltr(str(fsbal.bchsr)),4,'0')
		if old_4='N'
			repl opening with fsbal.op_sqty+fsbal.op_fqty
			repl balance with opening
			repl o_a with opening
			repl b_a with opening
			repl tqty with fsbal.cl_sqty+fsbal.cl_fqty
		else
			repl opening with fsbal.cl_sqty+fsbal.cl_fqty
			repl balance with fsbal.cl_sqty+fsbal.cl_fqty
			repl o_a with fsbal.cl_sqty+fsbal.cl_fqty
			repl b_a with fsbal.cl_sqty+fsbal.cl_fqty
			repl tqty with fsbal.cl_sqty+fsbal.cl_fqty
		endif
	else
		repl batchno with fsbal.bchno
		repl exp with ctod('01/'+subs(fsbal.expdt,1,2)+'/20'+subs(fsbal.expdt,4,2))
		repl prate with fsbal.prate
		repl lprate with fsbal.npr
		repl ratea with fsbal.rate
		repl ratec with fsbal.brate
		repl mrp with fsbal.mrp
		repl misc1 with mitm.gcode
		if old_4='N'
			repl opening with msbal.opening+fsbal.op_sqty+fsbal.op_fqty
			repl balance with msbal.balance+fsbal.op_sqty+fsbal.op_fqty
			repl o_a with msbal.o_a+fsbal.op_sqty+fsbal.op_fqty
			repl b_a with msbal.b_a+fsbal.op_sqty+fsbal.op_fqty
			repl tqty with msbal.tqty+fsbal.cl_sqty+fsbal.cl_fqty
		else
			repl opening with msbal.opening+fsbal.bal04
			repl balance with msbal.balance+fsbal.bal04
			repl o_a with msbal.o_a+fsbal.bal04
			repl b_a with msbal.b_a+fsbal.bal04
			repl tqty with msbal.tqty+(fsbal.bal04)
		endif
	endif
	sele fsbal
	skip
enddo
sele msbal
repl all date with old_5-1 for balance = 0
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Customer/Patient Master"
fd=datatransferpath+'Admtpa.'+datatransferext
td=datdev +'\order.'+datext
sele a
use &fd alias fact
sele b
use &td alias mact
sele sele(1)
use &datdev\support.&datext alia fsup
sele fact
go top
do while !eof()
	sele mact
	append blank
	repl scode with 'C6'
	repl rate with 'Y'
	repl ordno with str(fact.pacd,5)
	repl parnam  with upper(fact.panm)
    repl paradd with fact.add1
	repl paradd1 with fact.add2
	repl paradd2 with fact.add3
	repl confir with ''
	repl itno with ''
	repl fax2 with ''
	repl sthed with  'TIN No.'
	repl csthed with 'CST  No.'
	repl gsthed with 'GST  No.'
	repl gstno with fact.gstno
	repl dsm with  alltr(str(fact.pincode))
	repl phone4 with fact.mobno
	repl phone1 with fact.telno
	repl mailnam with parnam
	repl ref with 'Mr.'
	repl price with 'A'
	repl city with fact.add2
	repl status with 'Y'
	repl adhed with 'Discount'
	repl disc1 with fact.cd
	**** Updating State
	sele fsup
	appe blan
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+subs(fact->stcode,1,2)+'                                           '
	sele fact
	skip
enddo
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Account Master"
fd=datatransferpath+'Acmtac.'+datatransferext
fs=datatransferpath+'Admtsp.'+datatransferext
td=datdev +'\order.'+datext
select select(1)
use datdev + '\support.'+datext  alias tsupp
index on aliase + str(sno,3) + lcode to tsupp
dele all for aliase ='ORDER   '
dele all for aliase ='ORDERsms'
dele all for aliase ='LBTDETAI'
dele all for (type='#' and aliase='DAT/F-LD')
pack
sele a
use &fd alias fact
sele b
use &td alias mact
sele d
use &fs alia fsup
inde on supp to fsup
sele fact
go top
do while !eof()
	sele mact
	append blank
	do case
	case fact->gcode1=1 and fact->gcode2=1
	repl      mact->scode with 'B'
	repl      mact.rate with old_3
	case fact->gcode1=1 and fact->gcode2=2
	repl      mact->scode with 'G2'
	case fact->gcode1=1 and fact->gcode2=3
	repl      mact->scode with 'G3'
	case (fact->gcode1=1 and fact->gcode2=4) or fact.actype='S'
	repl      mact->scode with 'D31'
	case fact->gcode1=2 and fact->gcode2=4
	repl      mact->scode with 'C6'
	case fact->gcode1=2 and fact->gcode2=5
	repl      mact->scode with 'C2'
	case fact->gcode1=2 and fact->gcode2=6
	repl      mact->scode with 'C1'
	otherw
	repl  mact->scode with 'J12'
	endca
	repl rate with 'Y'
	repl ordno with str(fact.acnt,5)
	repl parnam  with upper(fact.acnam)
    if seek(fact->acnt,'fsup')
    repl paradd with substr(upper(fsup.add1),1,45)
	repl paradd1 with substr(upper(fsup.add2),1,45)
	repl paradd2 with substr(upper(fsup.add3),1,45)
	repl confir with upper(fsup.person)
	repl itno with upper(fsup.panno)
	repl fax2 with alltr(str(fsup.supp))
	repl sthed with  'TIN No.'
	repl csthed with 'CST  No.'
	repl gsthed with 'GST  No.'
	repl gstno with alltrim(fsup.gstno)
	repl dlno with  fsup.dlno1+' '+fsup.dlno2
	repl phone4 with substr(fsup.telno,1,10)
	repl phone1 with substr(fsup.mobno,1,10)
	repl mailnam with parnam
	repl ref with 'Mr.'
	repl price with 'A'
	repl city with fsup.add2
	repl status with 'Y'
	repl adhed with 'Discount'
    endi
    repl mact.opning with iif(fact->opdcf='D',fact->opnet,-fact->opnet)
	**** Updating State
	sele tsupp
	seek 'ORDER   ' + '  7' +  mact.ordno
	append blank
	repl aliase with 'ORDER   '
	repl type with 'F'
	repl lcode with mact.ordno
	repl sno with 7
	repl pcode with 15
	repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
	*** Local && CENTRAL & EMAIL ID MARK IN LEDGER.
	select tsupp
	appe blan
	repl aliase with 'LBTDETAI'
	repl type with 'F'
	repl lcode with mact.ordno
	repl heading with iif(subs(mact.gstno,1,2)=mstatecode or subs(mact.gstno,1,2)='  ','   ','L            ON          ')
	sele fact
	skip
enddo
close table all
sele sele(1)
use &datdev\order.&datext alia mord
appen blan
repl scode with 'C1'
repl ordno with 'CRDCRD'
repl parnam with 'CREDIT/CARD'
repl mailnam with parnam
appen blan
repl scode with 'C1'
repl ordno with 'DIGITA'
repl parnam with 'DIGITAL'
repl mailnam with parnam
clos tabl all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Customer's Outstanding "
sele sele(1)
use &datatransferpath\adtmbl alia fout
set filt to billdt<firstdate and !betwe(pmdt,firstdate-730,firstdate-1) and mode='2' and chqrcd=0
sele sele(1)
use &datdev\pendings.&datext alia mout
inde on ord to mout
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
   sele mout
   append blank
   repl acgroup with 'C6'
   repl ord with str(fout.pacd,5)
   repl ddate with fout->billdt
   repl vcn with fout->billno
   repl invtype with 'O'
   repl voucher  with vou
   repl svoucher with svou
   repl final with fout->rndamt
   repl itemope with 0
   repl balance with final-itemope
   repl name with vcn
   vou=vou+5
   svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Customer's Cheque Outstanding "  &&&Updated By Umesh on 14-06-2024
sele sele(1)
use &datatransferpath\adtmbl alia fout
set filt to billdt<firstdate and !betwe(pmdt,firstdate-730,firstdate-1) and mode='2' and chqrcd#0
sele sele(1)
use &datatransferpath\adtsbs alia fadj
inde on billno+str(amt) to fadj

sele sele(1)
use &datatransferpath\adtmbs alia fdt
inde on srno to fdt for tdt>=firstdate

sele sele(1)
use &datdev\pendings.&datext alia mout
inde on ord to mout
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
if seek(fout.billno+str(fout.rndamt),'fadj') and seek(fadj->srno,'fdt')
   sele mout
   append blank
   repl acgroup with 'C6'
   repl ord with str(fout.pacd,5)
   repl ddate with fout->billdt
   repl vcn with fout->billno
   repl invtype with 'O'
   repl voucher  with vou
   repl svoucher with svou
   repl final with fout->rndamt
   repl itemope with 0
   repl balance with final-itemope
   repl name with vcn
   vou=vou+5
   svou=svou+5
   endi
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Supplier's Outstanding "
sele sele(1)
use &datatransferpath\adtmpu alia fout
inde on supp to fout for chqdt>=old_5 and billdt<old_5
sele sele(1)
use &datdev\pendings.&datext alia mout
inde on ord to mout
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
   sele mout
   append blank
   repl acgroup with 'D31'
   repl ord with str(fout.supp,5)
   repl ddate with fout->billdt
   repl vcn with padl(alltr(str(fout.psrno)),6,'0')
   repl invtype with 'O'
   repl voucher  with vou
   repl svoucher with svou
   repl final with -fout->netamt
   repl itemope with 0
   repl balance with final-itemope
   repl name with vcn
   vou=vou+5
   svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
**
wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Doctor"
fd=datatransferpath + 'admtdm.'+datatransferext
td=datdev+'\maorder.'+datext
sele a
use &fd alias fdoc
sele sele(1)
use &datdev\support.&datext alias sup
inde on type+aliase+lcode to sup
sele b
use &td alias mdoc
index on scode to mdoc
sele fdoc
go top
do while ! eof()
alia1='PRE#'+substr(alltr(str(dmcd)),1,4)
lcod=substr(alltr(str(dmcd)),5,6)
   sele mdoc
   append blank
   repl scode with 'PRE#$~'
   repl parnam with substr(fdoc.dmnm,1,25)+SUBSTR(ALLTRIM(fdoc.add1)+SPACE(14),1,14)
   repl city with substr(alltr(fdoc.regno)+space(15),1,15)+substr(alltr(fdoc.telno)+space(15),1,15)
   repl form with substr(alltrim(str(fdoc.dmcd))+SPACE(10),1,10)
        sele sup
        append blank
        repl aliase with alia1
        repl type with 'M'
        repl lcode with lcod
        repl heading with subst(alltr(fdoc.add1),16,40)
        repl remark with alltr(fdoc.add2)+alltr(fdoc.add3)
   sele fdoc
skip
enddo
close tabl all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer PATIENT"
fd=datatransferpath + 'admtpa.'+datatransferext
td=datdev+'\maorder.'+datext
sele a
use &fd alias fpet
sele b
use &td alias mpet
index on scode to mpet
sele fpet
go top
do while .not. eof()
   sele mpet
   append blank
   repl scode with 'PET#$~'
   repl ordno with alltr(str(fpet.pacd))
   repl parnam with substr(alltr(fpet.panm)+spac(30),1,30)+subs(str(fpet.pacd,5)+spac(6),1,6)+subs(str(fpet.pacd,5)+spac(6),1,6)
   repl paycr with 'M'
   repl city with alltrim(fpet.add1)+' '+alltr(fpet.add2)+' '+alltr(fpet.add3)
   repl form with alltr(str(fpet.pacd))
   repl balance with val(fpet.mobno)
   repl islipno with fpet.cd
   sele fpet
skip
enddo
close tabl all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Ledger Opening Billwise"
sele sele(1)
use &datdev\order.&datext alia mord
inde on ordno to mord
sele sele(1)
use &datdev\pendings.&datext alia mpend
inde on ord to mpend
sele mord
go top
scan
sele mpend
seek mord->ordno
sum balance to mqty whil ord=mord->ordno
sele mord
repl opning with mqty
ends
clos tabl all
**
wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer MR(SalesMan )"
fd=datatransferpath+'admtsr.'+datatransferext
td=datdev+'\order.'+datext
sl=datdev +'\saletype.'+datext

sele a
use &fd alias fact
sele b
use &td alias mact
sele fact
go top
do while !eof()
	sele mact
	append blank
	repl mact.rate with 'N'
	repl mact.scode with 'D32'
	repl mact.ordno with 'M'+str(fact.smancode,4)
	repl mact.parnam  with upper(fact.smanname)
	repl mact.paradd with substr(upper(fact.add1),1,45)
	repl mact.paradd1 with substr(upper(fact.add2),1,45)
	repl mact.paradd2 with substr(upper(fact.add3),1,45)
	repl mact.fax2 with str(fact.smancode)
	repl mact.sthed with  'TIN No.'
	repl mact.csthed with 'CST  No.'
	repl mact.gsthed with 'GST  No.'
	repl mact.phone4 with substr(fact.telno,1,12)
	repl mact.mailnam with upper(fact.smanname)
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	*!*		Repl mact.area With saletype.scode
	*!*		Repl mact.city With Upper(fact.Actown)

	sele fact
	skip
enddo
close table all
if old_4='N'
	do import_transactions
endif
proc import_transactions
	wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Ledger Transaction"
	mdis=datdev+'\mdis.'+datext
	af =datdev +'\gledger.'+datext
	bf =datdev +'\slipno.'+datext
	dis=datdev +'\dis.'+datext
	pro=datdev +'\pro.'+datext
	ord=datdev +'\order.'+datext

	&& Sales
	sal=datatransferpath+'ADTMBL.'+datatransferext
	sld=datatransferpath+'ADTSBL.'+datatransferext
	&& Sales Return
	salr=datatransferpath+'ADTMCN.'+datatransferext
	sldr=datatransferpath+'ADTSCN.'+datatransferext
	&& Purchase
	pur=datatransferpath+'ADTMPU.'+datatransferext
	pld=datatransferpath+'ADTSPU.'+datatransferext
	&& Purchase Return
	purr=datatransferpath+'ADTMDN.'+datatransferext
	pldr=datatransferpath+'ADTSDN.'+datatransferext

	&& Sale/Purchase Expiry Return
	puex=datatransferpath+'adtmpuex.'+datatransferext
	plex=datatransferpath+'adtspuex.'+datatransferext

	
	sele select(1)
	use &datdev\support.&datext alias support
	index on type+aliase to  support
	seek 'F' + 'BATCHPRT'
	if !found()
		append blank
		repl type with 'F',;
			aliase with 'BATCHPRT'
	endif
	repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
     sele sele(1)
     use &datdev\subdis.&datext alia subdis
	sele i
	use &bf
	go top
	last4  = voucher + 10
	slast5 = svoucher + 100

	wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Sales"
	sele i
	use &bf
	go top
	last4 = last4 + 20

	sele select(1)
	use &ord alias ord
	index on fax2 to ord
	sele c
	use &sal alias sal
	set filter to (billamt) # 0
	sele e
	use &pro alias pro
	index on name to pro
	sele h
	use &sld alias sld
	index on billno to sld

	sele d
	use &mdis alias mdis
	zap

	sele g
	use &dis alias dis
	zap

	sele c
	go top
	do while .not. eof()
		if !between(billdt,old_5,old_6)
			skip
			loop
		endif

		l1=c.billno
		l2=l1
		l3=l1
		select ord
		seek str(c.pacd,5)
		last1=c.billno
		sele d
		appe blank
		repl type with iif(c.rndamt<0,'R','S')
		repl vcn with  l3
		repl date with c.billdt
		repl codep with str(c.pacd,5)
		repl voucher with last4
		last4=last4+5
		repl amountp with c.billamt
		repl salun with ''
		repl staxun with 'SZTZOZ'
		if c.submode=1
		repl cash with abs(c.rndamt)
		else
		repl final with abs(c.rndamt)
		endi
		repl round with 0
		if final=0 .and. cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl lrda with c.billdt
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with scalc
		repl discafter with 'N'
		repl remark4 with  l3
		repl remark1 with str(abs(c.billamt),12,2)
		repl other with 0
		repl othun with ''
		repl docu with iif(empty(c.mobno),subs(alltr(str(c.pacd))+spac(10),1,10),subs(c.mobno+spac(10),1,10))+c.panm
		repl docu1 with subs(alltr(str(c.dmcd))+spac(10),1,10)+c.dmnm
		repl docu2 with c. add1+c.add2
*		repl codep with 'STACO3'
		isigst=0
		if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
			isigst=1
		endif
******multi payment mode umesh goswami ******

	if inlis(c.mode,'7','3') and c.rcdamt+c.chqrcd=0
		repl cash with abs(c.rndamt)
		repl final with 0
    	repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)

		sele subdis
		appen blan
		repl codep with d.codep
		repl vcn with d.vcn
		repl date with d.date
		repl voucher with d.voucher
		repl type with 'V'
		repl dsm with 'REMARK'
		repl rtqt with iif(c.mode='7','DIGITA','CRDCRD')+str(c.rndamt,13,2)
		repl d.misc3 with subs(d.misc3,1,34)+'M'+subs(d.misc3,36,50)
		sele subdis
		appen blan
		repl codep with d.codep
		repl vcn with d.vcn
		repl date with d.date
		repl voucher with d.voucher
		repl type with 'V'
		repl dsm with 'REMARK'
		repl rtqt with iif(c.mode='7','DIGITA','CRDCRD')+str(c.rndamt,13,2)
		repl d.misc3 with subs(d.misc3,1,34)+'M'+subs(d.misc3,36,50)
	endi
		
		&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
		sele support
		appen blank
		repl type with "#",aliase with "DAT/F-SM",pcode with mdis->voucher,value with mdis->final+mdis->cash

		sele h
		seek c.billno
		do while  c.billno=h.billno .not. eof()
				xdt = '01/'+h.expdt
			last = substr(alltr(str(h.itcd))+space(10),1,10)
			select e
			seek last

			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with h.qnty
			repl rate with h.rate
			repl free with h.lqnty
			repl exp with ctod(xdt)
			repl batch with h.bchno
			if h.aflg='R'
			repl flg with 'R'
			else
			repl flg with 'G'
			endi
			repl disc1 With h.cd
				if isigst=1
					repl ssta with h.igstper
				else
					repl ssta with h.sgstper
					repl cgst with h.cgstper
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
	close table all


	wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Purchase"
	last4=last4+20
	sele i
	use &bf
	go top
	last4 = last4 + 20

	sele sele(1)
	use &datdev\support.&datext alias support
	index on type+aliase+lcode+str(pcode,9)+str(voucher,9) to support
*	set order to supp

	sele select(1)
	use &ord alias ord
	index on fax2 to ord

	sele c
	use &pur alias pur
	set filter to (netamt) # 0

	sele e
	use &pro alias pro
	index on name to pro
	sele h
	use &pld alias pld
	index on psrno to pld

	sele d
	use &mdis alias mdis


	sele g
	use &dis alias dis


	sele c
	go top
	do while .not. eof()
		if !between(rcddt,old_5,old_6)
			skip
			loop
		endif

		l1=c.psrno
		l2=l1
		l3=padl(alltr(str(c.psrno)),6,'0')
		select ord
		seek str(c.supp)

		last1=c.psrno
		sele d
		appe blank
		repl type with 'P'
		repl vcn with  l3
		repl pm with  c.billno
		repl date with c.rcddt
		repl codep with str(c.supp,5)
		repl voucher with last4
		last4=last4+5
		repl amountp with c.netamt
		repl salun with ''
		repl staxun with 'SZTZOZ'
		repl final with c.netamt
		repl round with final - c.netamt

		if final=0 .and. cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl lrda with c.rcddt
		repl account with 'N'
		repl sale with 'z'
		repl godwon with 'A'
		repl ltype with pcalc
		repl discafter with 'N'
		repl remark4 with  l3
		repl remark1 with str(c.netamt,12,2)

		isigst=0
		if substr(ord.gstno,1,2) # mstatecode and len(alltrim(ord.gstno))>10
			repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66,100)
			isigst=1

		endif
		&& UPDATED SUPPORT FOR VOUCHER DIFFERENCE
		sele support
		appen blank
		repl type with "#",aliase with "DAT/F-SM",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele h
		seek c.psrno
		do while  c.psrno=h.psrno .not. eof()
				xdt = '01/'+h.expdt
			last = substr(alltr(str(h.itcd))+space(10),1,10)
			select e
			seek last


			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.pm
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with h.qnty
			repl rate with iif(h.prate#0,h.prate,h.brate)
			repl free with h.fqnty
			repl exp with ctod(xdt)
			repl batch with h.bchno
			repl disc1 with h.cd
			repl svdis with h.isdsc
			repl misc4 with subs(misc4,1,43)+'L'+subs(misc4,45)
			repl flg with 'P'
				if isigst=1
					repl ssta with h.igstper
				else
					repl ssta with h.sgstper
					repl cgst with h.cgstper
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
	close table all



wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Stock Out"
	last4=last4+20
	sele i
	use &bf
	go top
	last4 = last4 + 20
	sele sele(1)
	use &datatransferpath\adtspr alias pur
    set filter to tdt>old_5
    inde on srno to pur
	sele e
	use &pro alias pro
	index on name to pro
	sele sele(1)
	select * from pur into curs pld readw
	index on srno to pld
	sele d
	use &mdis alias mdis
	sele g
	use &dis alias dis
	sele pur
	go top
	do while .not. eof()
		if !between(tdt,old_5,old_6)
			skip
			loop
		endif

		l1=pur.srno
		l2=l1
		l3=padl(alltr(str(pur.srno)),6,'0')
		last1=pur.srno
		sele d
		appe blank
		repl type with 'L'
		repl challan with  l3
		repl pm with  alltr(str(pur.srno))
		repl chdate with pur.tdt
		repl codep with 'STACAC'
		repl voucher with last4
		last4=last4+5
		repl amountp with pur.itval
		repl salun with ''
		repl staxun with 'SZTZOZ'
		repl final with pur.itval
		repl round with final - pur.itval

		if final=0 .and. cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with scalc
		repl discafter with 'N'
		repl remark4 with  l3
		repl remark1 with str(final,12,2)
		sele pld
		seek pur.srno
		do while  pur.srno=pld.srno and  .not. eof()
				xdt = '01/'+pld.expdt
			last = substr(alltr(str(pld.itcd))+space(10),1,10)
			select e
			seek last
			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.pm
			repl date with iif(!empty(d.date),d.date,d.chdate)
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with pld.qnty
			repl rate with pld.rate
			repl free with pld.fqnty
			repl exp with ctod(xdt)
			repl batch with pld.bchno
			repl flg with d.type
    		repl ssta with pld.sgstper
			repl cgst with pld.cgstper
			*Repl sssc With h.n_satp
			repl mrp with pld.mrp
			repl half with 'A'
			repl godwon with d.godwon

			sele pld
			skip
		enddo
		sele pur
		skip
	enddo
	close table all
***********************
	wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Account from Sales"
	af   =datdev+'\gledger.'+datext
	pend =datdev+'\pend.'+datext
	mdis =datdev+'\mdis.'+datext
	pending=datdev+'\pendings.'+datext
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
	close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Payment Transaction"
af =datdev+'\gledger.'+datext
bf =datdev+'\slipno.'+datext
cf=datatransferpath+'adtmpm.'+datatransferext
pend=datdev +'\pend.'+datext
pending=datdev+'\pendings.'+datext
adj=datatransferpath+'adtspm.'+datatransferext
sele g
use &pending Alias pending
index on ord + substr(name,1,12) to rou2
last4  = last4 + 10
slast5 = slast5 + 10
Sele F
Use &pend Alias pend
Sele b
Use &af Alias gledger
sele sele(1)
use &adj alia adj
inde on srno to adj
Sele a
Use &cf Alias led
index on dtos(tdt)+str(srno) to led
go top
do While .Not. Eof()
    if !Between(tdt,old_5,old_6)
		skip
		loop
	endi	
    last4=last4+10
    slast5 = slast5 + 10
	l1=a->chqno
    sele b
	appen blank
	repl vcsno With l1
	repl voucher With last4
    repl cd with 'D'
    repl debit with a.amt
    Repl Date With a.tdt
	Repl Code WITH str(a.supp,5)
	Repl Code1 WITH str(a.acnt,5)
	Repl remark1 With a.chqno
    repl book with 'P'
    sele adj
    seek a.srno
    do whil adj.srno=a.srno
	mvcn=padl(alltr(str(adj.psrno)),6,'0')
    sele pending
    seek subs(str(a.supp,5)+space(6),1,6)+subs(mvcn+spac(12),1,12)
        if found()
        sele pend
		 appen blank
		 repl voucher with b->voucher
		 repl ord with b->code
		 repl vcn with mvcn
		 repl adjvoucher with pending.voucher
		 repl svoucher   with pending.svoucher
		 repl final      with adj.amt
		 repl type       with 'A'
		 repl ddate      with a.tdt
endi
sele adj
skip
endd
    sele b
	appen blank
	repl vcsno With l1
	repl voucher With last4
    repl cd with 'C'
    repl credit with a.amt
    Repl Date With a.tdt
	Repl Code1 WITH str(a.supp,5)
	Repl Code WITH str(a.acnt,5)
	Repl remark1 With a.chqno
    repl book with 'P'
	Sele a
	Skip
endd
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Cash Receipt Transaction"
af =datdev+'\gledger.'+datext
bf =datdev+'\slipno.'+datext
cf=datatransferpath+'adtrrc.'+datatransferext
pend=datdev +'\pend.'+datext
pending=datdev+'\pendings.'+datext
sele g
use &pending Alias pending
index on ord + substr(name,1,12) to rou2
last4  = last4 + 10
slast5 = slast5 + 10
Sele F
Use &pend Alias pend
Sele b
Use &af Alias gledger
Sele a
Use &cf Alias led
index on dtos(rcddt)+str(srno) to led
go top
do While .Not. Eof()
    if !Between(rcddt,old_5,old_6)
		skip
		loop
	endi	
    last4=last4+10
    slast5 = slast5 + 10
	l1=alltr(str(a->srno))
    sele b
	appen blank
	repl vcsno With l1
	repl voucher With last4
    repl cd with 'C'
    repl credit with a.amtrcd
    Repl Date With a.rcddt
	Repl Code WITH str(a.pacd,5)
	Repl remark1 With 'Cash Paid Against'+a.billno
    repl book with 'R'
    sele b
	appen blank
	repl vcsno With l1
	repl voucher With last4
    repl cd with 'D'
    repl debit with a.amtrcd
    Repl Date With a.rcddt
	Repl Code WITH 'STACO3'
	Repl remark1 With 'Cash Paid Against'+a.billno
    repl book with 'R'
	Sele a
	Skip
endd
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Cheque Receipt Transaction"
af =datdev+'\gledger.'+datext
bf =datdev+'\slipno.'+datext
cf=datatransferpath+'adtmbs.'+datatransferext
pend=datdev +'\pend.'+datext
pending=datdev+'\pendings.'+datext
adj=datatransferpath+'adtsbs.'+datatransferext
sele g
use &pending Alias pending
index on ord + substr(name,1,12) to rou2
last4  = last4 + 10
slast5 = slast5 + 10
Sele F
Use &pend Alias pend
Sele b
Use &af Alias gledger
sele sele(1)
use &adj alia adj
inde on srno to adj
Sele a
Use &cf Alias led
index on dtos(tdt)+str(srno) to led
go top
do While .Not. Eof()
    if !Between(tdt,old_5,old_6)
		skip
		loop
	endi	
    last4=last4+10
    slast5 = slast5 + 10
	l1=a->chqno
    sele b
	appen blank
	repl vcsno With l1
	repl voucher With last4
    repl cd with 'C'
    repl credit with a.amt
    Repl Date With a.tdt
	Repl Code WITH str(a.pacd,5)
	Repl Code1 WITH str(a.acnt,5)
	Repl remark1 With a.chqno
    repl book with 'R'
    sele adj
    seek a.srno
    do whil adj.srno=a.srno
	mvcn=adj.billno
    sele pending
    seek subs(str(a.pacd,5)+space(6),1,6)+subs(mvcn+spac(12),1,12)
        if found()
        sele pend
		 appen blank
		 repl voucher with b->voucher
		 repl ord with b->code
		 repl vcn with mvcn
		 repl adjvoucher with pending.voucher
		 repl svoucher   with pending.svoucher
		 repl final      with -adj.amt
		 repl type       with 'A'
		 repl ddate      with a.tdt
endi
sele adj
skip
endd
    sele b
	appen blank
	repl vcsno With l1
	repl voucher With last4
    repl cd with 'D'
    repl debit with a.amt
    Repl Date With a.tdt
	Repl Code1 WITH str(a.pacd,5)
	Repl Code WITH str(a.acnt,5)
	Repl remark1 With a.chqno
    repl book with 'R'
	Sele a
	Skip
endd
close table all

wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer Other Accounting Transactions"
af =datdev+'\gledger.'+datext
bf =datdev+'\slipno.'+datext
cf=datatransferpath+'actldg.'+datatransferext
pend=datdev +'\pend.'+datext
pending=datdev+'\pendings.'+datext
sele g
use &pending alias pending
index on ord + substr(name,1,12) to rou2
last4  = last4 + 10
slast5 = slast5 + 10
sele f
use &pend Alias pend
Sele b
Use &af Alias gledger
sele a
use &cf alias led
set filter to inli(docno,'JV','GN')
Index On docno+dtos(docdt) To led
Go Top
last1='9999999999'
last2=ctod('')
do While .Not. Eof()
    If !Between(docdt,old_5,old_6)
		Skip
		Loop
	ENDIF
	If last1 # docno or last2#docdt
	last4 = last4+4
	Endif
	
	last1 = led.docno
	last2 = led.docdt
	l1=left(alltr(a.docno),3)+righ(alltr(a.docno),6)
    Sele b
	Append Blank
	Repl vcsno With l1
	Repl voucher With last4
	 if a.dcflg='D'
	   repl cd with 'D'
       repl debit with a.amount
    else
	   repl cd with 'C'
       repl credit with a.amount
    endif
    Repl Date With a.docdt
	Repl Code WITH STR(a.acnt,5)
	Repl Code1 WITH STR(a.agac,5)
	Repl remark1 With a.refdoc
    do case
    case a.docno='JV' or a.docno='GN'
    repl book with 'J'
    case a.docno='CX' or a.docno='SR'
    repl book with 'E'
    endca
	Sele a
	Skip
endd
close table all

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
