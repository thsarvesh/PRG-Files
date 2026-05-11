*!*	BOF : A2H.PRG .....Dated    : 18/12/2025   Author : SARVESH
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
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
sele sele(1)
close tables all
sele sele (1)
create curs mycurs  (setup c(50),value c(4))
sele mycurs
appe blank
repl  setup with 'Item Discount on Sale ',value with 'Y'
appe blank
repl  setup with 'Item Discount Y-Both/P-Purchase/S-Sale ',value with 'Y'
appe blank
repl  setup with 'Item Wise Double Discount Y-Both/P-Purchase/S-Sale ',value with 'Y'
appe blank
repl  setup with 'Bill Discount Y-Both/P-Purchase/S-Sale ',value with 'Y'
appe blank
repl  setup with 'Ask discount in Amount N-No/P-Purchase/S-Sale/B-Both ',value with 'Y'
brow font 'tahoma',13    nomodify
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='D:\transfer'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\2025\Dec\Vijay\Dbf_ath\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Full Migration'
old_5 = firstdate
old_6 = lastdate
purcal='2'
salcal= '2'
outsonly='No '
mtype='Retail '
old_12 = 'GST'
mstatecode='03'
removenull = 'NO'
@02,25   say 'Please Wait..Importing A2H Data To Marg.....' font 'courier new ',16 colo 'W+/b'
@06,10   say 'A2H Data Path           :'  font 'courier new',10 get datatransferpath  font 'courier new',10
@07,10   say 'A2H Extension           :'  font 'courier new',10 get datatransferext pict '@m DBF' size 1,21 font 'courier new',10
@08 ,10  say 'WITH O/S                :'  font 'courier new',10 get old_3           pict '@m Yes,No ' when outsonly='N'  size 1,21 font 'courier new',10
@09,10   say 'Migration Type          :'  font 'courier new',10 get old_4           pict '@m Master,Full Migration' size 1,21 font 'courier new',10
@10 ,10  say 'F.Y.BEGIN FROM          :'  font 'courier new',10 get old_5           font 'courier new',10
@11,10   say 'F.Y.UP TO               :'  font 'courier new',10 get old_6           font 'courier new',10
@12 ,10  say 'Migration Type          :'  font 'courier new',10 get mtype           pict '@m Retail,Wholesale' size 1,21 font 'courier new',10
@13 ,10  say 'Purchase Calculation    :'  font 'courier new',10 get purcal          font 'courier new',10
@14 ,10  say 'Sale Calculation        :'  font 'courier new',10 get salcal          font 'courier new',10
@15 ,10  say 'GST/VAT                 :'  font 'courier new',10 get old_12          pict '@m Gst,Vat' size 1,21 font 'courier new',10
@16,10   say 'State GST Code          :'  font 'courier new',10 get mstatecode      pict '@m 01,02,03,04,05,06,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,' size 1,21 font 'courier new',10
@17 ,10  say 'Removenull              :'  font 'courier new',10 get removenull      pict '@m No ,Yes' size 1,21 font 'courier new',10
@18,10   say 'Type SURE               :'  font 'courier new',10 get sure            pict '@x!' font 'courier new',10
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
@ 02,25 say 'Please Wait..Importing A2H Data To Marg.....' font 'courier',14 colo 'W+/b'
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
close data
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\vaitem alias fitm
sele sele (1)
use &datatransferpath\vaunit alias funit
index on id to funit uniq
sele sele(1)
use &datatransferpath\vaunitconversion alias fconv
index on id to fconv
sele sele(1)
use &datatransferpath\vatax alias ftax
index on id to ftax unique 
select select(1)
use &datatransferpath\vaitembatch alias fbal
index on ibcode to fbal 

select select(1)
use &datdev\pro.&datext alias mitm
zap
index on name to mitm
select select(1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode = 'COMMCD'
index on sgcode + parnam + str(igst,5,2) to mpcm
sele fitm
pack
go top
do while !eof()
   last=recno()
  	=seek (fitm.itemunitid,'funit') 
   	=seek(fitm.itempurtaxid,'ftax')
   	=seek(fitm.itemcode,'fbal')
   	=seek(fitm.itemconversionid,'fconv')
	sele mitm
   append blank
   repl mitm.code with fitm.id
   repl mitm.name with (fitm.Itemcode)
   repl mitm.product with fitm.Itemname	
   repl mitm.packing with funit.Unitname	
   repl mitm.billname with alltrim(fitm.Itemname)+'  '+(funit.Unitname)
   repl mitm.unit with 'PCS'
   repl mitm.pack with fconv.conv1
   repl mitm.gcode with padr(fitm.itemcmpid,6)
*!*	   repl mitm.gcode2 with padr(fitm.itemmanufid,6)
   repl mitm.gcode5 with padr(fitm.itemigid,6)
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.minimum with fbal.Ibminqty
   repl mitm.maximum with fbal.Ibmaxqty
   repl mitm.saltax with IIF(INLIST(ftax.taxvatrate,5,12,18,28),ftax.taxvatrate/2,ftax.taxvatrate)
   repl mitm.purtax with IIF(INLIST(ftax.Taxvatrate,5,12,18,28),ftax.Taxvatrate/2,ftax.Taxvatrate)
   repl mitm.cgst with IIF(INLIST(ftax.Taxvatrate,5,12,18,28),ftax.Taxvatrate/2,ftax.Taxvatrate)
   repl mitm.igst with IIF(INLIST(ftax.Taxvatrate,5,12,18,28),ftax.Taxvatrate,ftax.Taxvatrate*2)
   repl mitm.prate with fbal.Ibpurrate
   repl mitm.ratea with fbal.Ibsalerate
   repl mitm.tqty with fbal.Ibopqty
   repl mitm.opening with fbal.Ibopqty
   repl mitm.balance with fbal.Ibopqty
   repl mitm.o_a with fbal.Ibopqty
   repl mitm.b_a with fbal.Ibopqty
   repl mitm.mrp with fbal.Ibmrp
 **---Hsn Update---'    
   sele mpcm
   seek 'COMMCD' + substr(fbal.Ibhsncode+space(15),1,15) + str(mitm.igst,5,2)
   if !found()
      append blank
      repl mpcm.sgcode with 'COMMCD',;
           mpcm.scode  with 'H'+alltrim(str(last)),; 
           mpcm.sname  with substr(fbal.Ibhsncode+space(15),1,15)+ substr(fbal.Ibhsncode,1,15)+' '+ alltrim(str(mitm.igst,5,2))+'%',;
           mpcm.parnam with substr(fbal.Ibhsncode,1,15),;
           mpcm.tax with mitm.saltax,;
           mpcm.cgst with mitm.cgst,;
           mpcm.igst with mitm.igst,;
           mpcm.tcode with 'No'
   endi
   repl mitm.gcode6 with mpcm.scode
  sele fitm
skip
enddo
close table all
@rowno,10 say '**** Importing Company Master  ****' font 'Arial',10
rowno=rowno+1
select select(1)
use &datatransferpath\vaitemcompany alias fpcm
index on id to fpcm unique 
select select(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='ZZZZZZ'
pack
index on scode to mpcm 
sele fpcm
go top
do while .not. eof()
   sele mpcm
   append blank
   repl mpcm.sgcode with 'ZZZZZZ',;
        mpcm.scode  with padr(fpcm.id,6),;
        mpcm.sname  with UPPER(fpcm.itmcmpname),;
        mpcm.parnam with UPPER(fpcm.itmcmpname),;
        mpcm.tcode with 'No',;
        mpcm.tax with 1
sele fpcm
skip
enddo
close table all
@rowno,10 say '**** Importing Group Master  ****' font 'Arial',10
rowno=rowno+1
select select(1)
use &datatransferpath\vaitemgroup alias fpcm
index on id to fpcm unique 
select select(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='CATEGO'
pack
index on scode to mpcm 
sele fpcm
go top
do while .not. eof()
   sele mpcm
   append blank
   repl mpcm.sgcode with 'CATEGO',;
        mpcm.scode  with padr(fpcm.id,6),;
        mpcm.sname  with UPPER(fpcm.igname),;
        mpcm.parnam with UPPER(fpcm.igname),;
        mpcm.tcode with 'No',;
        mpcm.tax with 1
sele fpcm
skip
enddo
close table all

*!*	@rowno,10 say '**** Importing Company Master  ****' font 'Arial',10
*!*	rowno=rowno+1
*!*	select select(1)
*!*	use &datatransferpath\vaitemcompany alias fpcm
*!*	index on id to fpcm unique 
*!*	select select(1)
*!*	use &datdev\saletype.&datext alias mpcm
*!*	delete all for sgcode='ZZZZZZ'
*!*	pack
*!*	index on scode to mpcm 
*!*	sele fpcm
*!*	go top
*!*	do while .not. eof()
*!*	   sele mpcm
*!*	   append blank
*!*	   repl mpcm.sgcode with 'ZZZZZZ',;
*!*	        mpcm.scode  with ALLTRIM(str(fpcm.Id)),;
*!*	        mpcm.sname  with UPPER(fpcm.Itmcmpname),;
*!*	        mpcm.parnam with UPPER(fpcm.Itmcmpname),;
*!*	        mpcm.tcode with 'No',;
*!*	        mpcm.tax with 1
*!*	sele fpcm
*!*	skip
*!*	enddo
*!*	close table all
@rowno,10 say '**** Importing Salt Master  ****' font 'Arial',10
rowno=rowno+1
select select(1)
use &datatransferpath\vasalt alias fpcm
index on id to fpcm unique 
select select(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='SALT  '
pack
index on scode to mpcm 
sele fpcm
go top
do while .not. eof()
   sele mpcm
   append blank
   repl mpcm.sgcode with 'SALT  ',;
        mpcm.scode  with alltrim(str(fpcm.Id)),;
        mpcm.sname  with UPPER(fpcm.saltname),;
        mpcm.parnam with UPPER(fpcm.saltname	),;
        mpcm.tcode with 'No',;
        mpcm.tax with 1
sele fpcm
skip
enddo
close table all
@rowno,10 say '**** Importing Area Master  ****' font 'Arial',10
rowno=rowno+1
select select(1)
use &datatransferpath\vacity alias fpcm
index on id to fpcm unique 
select select(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='AREA  '
pack
index on scode to mpcm 
sele fpcm
go top
do while .not. eof()
   sele mpcm
   append blank
   repl mpcm.sgcode with 'AREA  ',;
        mpcm.scode  with padr(fpcm.Id,6),;
        mpcm.sname  with UPPER(fpcm.cityname),;
        mpcm.parnam with UPPER(fpcm.cityname),;
        mpcm.tcode with 'No',;
        mpcm.tax with 1
sele fpcm
skip
enddo
close table all
@rowno,10 say '**** Importing Route Master  ****' font 'Arial',10
rowno=rowno+1
select select(1)
use &datatransferpath\vaarea alias fpcm
index on id to fpcm unique 
select select(1)
use &datdev\saletype.&datext alias mpcm
delete all for sgcode='ROUT  '
pack
index on scode to mpcm 
sele fpcm
go top
do while .not. eof()
   sele mpcm
   append blank
   repl mpcm.sgcode with 'ROUT  ',;
        mpcm.scode  with padr(fpcm.Id,6),;
        mpcm.sname  with UPPER(fpcm.arname),;
        mpcm.parnam with UPPER(fpcm.arname),;
        mpcm.tcode with 'No',;
        mpcm.tax with 1
sele fpcm
skip
enddo
close table all
@rowno,10 say '**** Importing  MR  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\vaagent alias fact
sele sele(1)
use &datdev\order.&datext alias mact
zap
sele sele(1)
use &datdev\support.&datext alias support
sele fact
go top
scan
	sele mact
	appen blank
	repl scode with 'D32'
	repl parnam with fact.agentname
	repl mailnam with fact.agentname
	repl fax2 with fact.agentcode
	repl ordno with 'M'+alltri(str(fact.id))
endscan
close table all
@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\vaitembatch alias fsbal
sele sele(1)
use &datatransferpath\stocktable alias fstk
index on str(itemid,9)+str(ibid,9) to fstk
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan
	sele fstk
	seek str(fsbal.ibprdid,9)+str(fsbal.id,9)
	sum sysqty to stk while str(itemid,9)+str(ibid,9)=str(fsbal.ibprdid,9)+str(fsbal.id,9)
   sele mitm
   seek  str(fsbal.ibprdid,9)
   sele msbal
   seek str(fsbal.ibprdid,9)+substr(fsbal.ibname+space(12),1,12)
   if !found()
      append blank
      repl msbal.code with mitm.code,;
           msbal.name with mitm.name,;
           msbal.billname with mitm.billname,;
           msbal.product with mitm.product,;
           msbal.packing with fsbal.ibpacking,;
           mitm.packing with msbal.packing,;
           msbal.pack with mitm.pack,;
           msbal.unit2 with mitm.unit2,;
           msbal.unit with mitm.unit,;
           msbal.decimal with 'Y',;
           msbal.opening with iif(old_4='F',fsbal.ibopqtycalc,fsbal.ibopqtycalc+stk),;
           msbal.balance with iif(old_4='F',fsbal.ibopqtycalc,fsbal.ibopqtycalc+stk),;
           msbal.o_a with iif(old_4='F',fsbal.ibopqtycalc,fsbal.ibopqtycalc+stk),;
           msbal.b_a with iif(old_4='F',fsbal.ibopqtycalc,fsbal.ibopqtycalc+stk),;
           msbal.batchno with fsbal.ibname
        repl mycode with fsbal.ibcode
     	repl msbal.exp with fsbal.ibexpiry,;
           msbal.mfd with fsbal.ibmanufdate,;
           msbal.mrp with fsbal.ibmrp,;
           msbal.prate with fsbal.ibpurrate,;
           msbal.ratea with fsbal.ibsalerate,;
           msbal.lprate with fsbal.ibpurrate,;           
           msbal.mrp with fsbal.ibmrp,;
           msbal.misc1 with mitm.gcode,;
           msbal.supcode with ''
	   else
      repl msbal.opening with msbal.opening+iif(old_4='F',fsbal.ibopqtycalc,fsbal.ibopqtycalc+stk),;
           msbal.balance with msbal.balance+iif(old_4='F',fsbal.ibopqtycalc,fsbal.ibopqtycalc+stk),;
           msbal.o_a with msbal.o_a+iif(old_4='F',fsbal.ibopqtycalc,fsbal.ibopqtycalc+stk),;
           msbal.b_a with msbal.b_a+iif(old_4='F',fsbal.ibopqtycalc,fsbal.ibopqtycalc+stk)
   endif
endsc
close table all
@rowno,10 say '**** Importing  Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\vaaccountinfo alias fact
select select(1)
use &datatransferpath\vacity alias fcity
index on id to fcity unique 
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\support.&datext alias support
sele fact
go top
do while .not. eof()
last=recno()
=seek (fact.accityid,'fcity')  
	sele mact	
	append blank
   	do case
		case fact.Acgrpid=1
			   repl mact.scode with 'C6'
   		case fact.Acgrpid=2
			   repl mact.scode with 'D31'
   		case fact.Acgrpid=6
			   repl mact.scode with 'C1'
   		case fact.Acgrpid=5
			   repl mact.scode with 'C2'
   		case fact.Acgrpid=19
			   repl mact.scode with 'J12'
		otherwise
			   repl mact.scode with 'J12'
	endcase
	repl mact.rate with 'Y'
	repl mact.ordno with padr(fact.acledgerid,6)
	repl mact.fax2 with alltr(fact.Accode)
	repl mact.parnam  with fact.acnametoprint
	repl mact.paradd with fact.Acadd1
	repl mact.paradd1 with fact.Acadd2
	repl mact.paradd2 with fact.Acadd3
	repl mact.sthed with  'TIN No.'
	repl mact.csthed with 'CST  No.'
	repl mact.Gsthed with 'GST  No.'
	repl mact.cstno with fact.Actinno
	repl mact.gstno with fact.Acgstno
	repl mact.confir with fact.Accontactperson
	repl mact.itno with fact.Acpanno
	repl mact.phone1 with fact.Acoffno
	repl mact.phone4 with fact.acwhatsappno
	repl mact.dsm with fact.Acpincode
	repl mact.dlno with alltri(fact.Acdlno1)+'-'+alltri(fact.Acdlno2)
	repl mact.fax1 with fact.Acfaxno
	repl mact.mailNam with fact.acnametoprint&&&fact.Acname
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.city with fcity.Cityname
	repl mact.status with 'Y'
	repl mact.adhed with 'Discount'
	repl mact.opning WITH fact.Acopbal
	repl mact.area with padr(fact.accityid,6)
	repl mact.rout with padr(fact.acareaid,6)
	if old_4='F'
		repl mact.opning with iif(fact.acopbaltype='Dr',fact.acopbal,-fact.acopbal)
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
sele fact
skip
enddo
close table all
@rowno,10 say '**** Importing Purchase Bill  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\pro.&datext alias pro
index on str(code,9) to pro
sele sele(1)
use &datdev\order.&datext alia ord
inde on ordno to ord
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\probat.&datext alias prb
index on str(code,9)+batchno to prb
sele sele(1)
use &datdev\subdis.&datext alias msub
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20
sele sele(1)
use &datatransferpath\vaitembatch alias fsbal
index on str(ibprdid,9)+str(id,9) to fsbal
sele sele(1)
use &datatransferpath\vavouchertypeseries alia fser
index on id to fser
sele sele(1)
use &datatransferpath\vapurchasemaster alia pur
set filte to between(purbilldate,firstdate,lastdate)
sele sele(1)
use &datatransferpath\vapurchasedetail alia pld
index on purid to pld
sele pur
go top
scan 
	=seek(padr(pursuppacid,6),'ord')
	=seek(pur.vtseriesid,'fser')
	mseries=alltri(fser.entrytype)
	lentryno=mseries+padl(pur.purentryno,6,'0')
	sele mdis
	appen blan
	do case
		case pur.purisreturn=.F.
			repl type with IIF(pur.gstinvtype=2,'P','p')
			repl vcn with lentryno
			repl date with pur.purentrydate
			repl pm with pur.purbillno
			repl lrda with pur.purbilldate
		case pur.purisreturn=.T.
			repl type with 'B'
			repl vcn with lentryno
			repl date with pur.purentrydate
			repl pm with pur.purbillno
			repl lrda with pur.purbilldate
	endcase
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl codep with ord.ordno
	repl voucher with last4
	last4=last4+5
	repl rout with ' '
	repl area with ' '
	repl addis with 0
	repl sale with 'Z'
	repl account with 'N'
	repl godwon with 'A'
	repl discafter with 'M'
	repl othun with 'STAC23'
	repl ltype with purcal
	bdisc=pur.purdisamt+iif(pur.purbftaxfieldsvalue<0,abs(pur.purbftaxfieldsvalue),0)
	repl misc3 with substr(misc3,1,54)+str(bdisc,10,2)+substr(misc3,65,100)
	repl amountt with pur.puritemamt
	isigst=0
	if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
		isigst=1
	endi
	if upper(pur.purmode)='CREDIT'
		repl final with pur.purnetbillamt
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	else
		repl cash with pur.purnetbillamt
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	endif
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	xvol=0
	sele pld
	seek pur.id
	scan for purid=pur.id
		=seek(str(pld.itemid,9),'pro')
		=seek(str(pld.itemid,9)+str(pld.ibid,9),'fsbal')
		sele dis
		appen blan
		repl codep with mdis->codep
		repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
		repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
		repl voucher with mdis->voucher
		repl code with pro.code
		repl batch with fsbal.ibname
		repl exp with fsbal.ibexpiry
		repl mfd with fsbal.ibmanufdate
		repl qty with pld.qty
		repl free with pld.free
		repl rate with pld.rate
		repl mrp with fsbal.ibmrp
		repl tax with pro.taxl
		repl flg with iif(mdis.type='S','G',mdis.type)
		if pld.disformat='%'
			repl disc1 with pld.discount
		endif
		if pld.rlsubdisformat='%'
			repl svdis with pld.rlsubdisc
			repl misc4 with substr(misc4,1,43)+'PP'+substr(misc4,46,100)
		endif
		repl half with 'A'
		repl godwon with mdis->godwon
		mtax=iif(inlist(pld.taxrate,5,12,18,28,3),pld.taxrate,pld.taxrate*2)
		if isigst=1
			repl ssta with mtax
		else
			repl ssta with mtax/2
			repl cgst with mtax/2
		endif
		xvol=xvol+pld.rlsubdisamount
	endsc
	bdisc=bdisc+xvol
	sele mdis
	repl misc3 with substr(misc3,1,54)+str(bdisc,10,2)+substr(misc3,65,100)
endsc
sele sele(1)
sele mslip
go top
repl voucher with last4+10
repl svoucher with slast5+10
clos tabl all

@rowno,10 say '**** Importing Sales Bill  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\support.&datext alias support
index on type+aliase to support
seek 'F' + 'BATCHPRT'
if !found()
	append blank
	repl type with 'F',;
		aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
use &datdev\pro.&datext alias pro
index on str(code,9) to pro
sele sele(1)
use &datdev\order.&datext alia ord
inde on ordno to ord
sele sele(1)
use &datdev\dis.&datext alias dis
sele sele(1)
use &datdev\mdis.&datext alias mdis
sele sele(1)
use &datdev\probat.&datext alias prb
index on str(code,9)+batchno to prb
sele sele(1)
use &datdev\subdis.&datext alias msub
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20
sele sele(1)
use &datatransferpath\vaitembatch alias fsbal
index on str(ibprdid,9)+str(id,9) to fsbal
sele sele(1)
use &datatransferpath\vavouchertypeseries alia fser
index on id to fser
sele sele(1)
use &datatransferpath\vasalemaster alia sal
set filte to between(slbilldate,firstdate,lastdate)
sele sele(1)
use &datatransferpath\vasaledetail alia sld
index on saleid to sld
sele sal
go top
scan
	=seek(padr(slcustacid,6),'ord')
	=seek(sal.vtseriesid,'fser')
	mseries=alltri(fser.entrytype)
	mbill=mseries+padl(sal.slbillno,6,'0')
	sele mdis
	appen blan
	do case
		case sal.slisreturn=.F.
			repl type with 'S'
			repl vcn with mbill
			repl pm with mbill
			repl date with sal.slbilldate
			repl lrda with sal.slbilldate
		case sal.slisreturn=.T.
			repl type with 'R'
			repl vcn with mbill
			repl pm with mbill
			repl date with sal.slbilldate
			repl lrda with sal.slbilldate
	endcase
	repl misc3 with substr(misc3,1,53)+'T'+substr(misc3,55,100)
	repl codep with ord.ordno
	repl voucher with last4
	last4=last4+5
	repl rout with ' '
	repl area with ' '
	repl addis with 0
	repl sale with 'Z'
	if sal.cancelvch=.T.
		repl account with 'C'
		repl remark1 with "Cancel Bill"
	else
		repl account with 'N'
	endif
	
	repl godwon with 'A'
	repl discafter with 'M'
	repl othun with 'STAC23'
	repl ltype with salcal
	if mtype='R'
		repl docu with upper(sal.slcpname)
		repl docu1 with upper(alltri(sal.slcpadd1))+' '+upper(alltri(sal.slcpcity))
		repl phone with sal.slcpmobno 
		repl docu2 with upper(alltri(sal.slcpadd2))
		repl sale with 'z'
	endif
	repl misc3 with substr(misc3,1,54)+str(sal.sldisamt,10,2)+substr(misc3,65,100)
	repl amountt with sal.slitemamt
	isigst=0
	if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
		repl misc3 with substr(misc3,1,64)+'C'+substr(misc3,66)
		isigst=1
	endi
	if upper(sal.slmode)='CREDIT'
		repl final with sal.slnetbillamt
		repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
	else
		repl cash with sal.slnetbillamt
		repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
	endif
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
	sele sld
	seek sal.id
	scan for saleid=sal.id
		=seek(str(sld.itemid,9),'pro')
		=seek(str(sld.itemid,9)+str(sld.ibid,9),'fsbal')
		sele dis
		appen blan
		repl codep with mdis->codep
		repl vcn with iif(empty(mdis->vcn),mdis->challan,mdis->vcn)
		repl date with iif(empty(mdis->date),mdis->chdate,mdis->date)
		repl voucher with mdis->voucher
		repl code with pro.code
		repl batch with fsbal.ibname
		repl exp with fsbal.ibexpiry
		repl mfd with fsbal.ibmanufdate
		repl qty with iif(sal.cancelvch=.t.,0,sld.qty)
		repl rate with iif(sal.cancelvch=.t.,0,sld.rate)
		repl mrp with iif(sal.cancelvch=.t.,0,fsbal.ibmrp)
		repl tax with pro.taxl
		repl flg with iif(mdis.type='S','G',mdis.type)
		if sld.disformat='%'
			repl disc1 with iif(sal.cancelvch=.t.,0,sld.discount)
		endif
		repl half with 'A'
		repl godwon with mdis->godwon
		mtax=iif(inlist(sld.taxrate,5,12,18,28,3),sld.taxrate,sld.taxrate*2)
		if isigst=1
			repl ssta with mtax
		else
			repl ssta with mtax/2
			repl cgst with mtax/2
		endif
	endsc
endsc
sele sele(1)
sele mslip
go top
repl voucher with last4+10
repl svoucher with slast5+10
clos table all
@rowno,10 say '**** Importing Account From Inventories ****' font 'Arial',10
rowno=rowno+1
af     =datdev + '\gledger.'+datext
pend   =datdev + '\pend.'+datext
mdis   =datdev + '\mdis.'+datext
pending=datdev + '\pendings.'+datext
sele g
use &pending alias pending
sele f
use &pend alias pend excl
sele b
use &af alias gledger excl
sele sele(1)
use &datdev\order.&datext alias ord
index on ordno to ord
sele d
use &mdis alias mdis
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
msvoucher=svoucher+5
slast5=msvoucher
sele d
set filt to account#'C'
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
		endi
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
sele mslip
repl svoucher with msvoucher
close tabl all
@rowno,10 say '**** Transfer Voucher Entry ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\gledger.&datext alias gle
sele sele(1)
use &datdev\order.&datext alia ord
inde on ordno to ord
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20
sele sele(1)
use &datatransferpath\vavouchertypeseries alia fser
index on id to fser
sele sele(1)
use &datatransferpath\vavouchermaster.&datatransferext alias fvm
set filt to between(vmentrydate,firstdate,lastdate) and inlist(vmvchtypeid,1,2,3,5,4)
sele sele(1)
use &datatransferpath\vavoucherdetail.&datatransferext alias fvmd
index on vdvmid to fvmd
sele fvm
scan 
	=seek(fvm.vtseriesid,'fser')
	lvou_no=alltri(fser.entrytype)+padl(alltri(fvm.vmentryno),6,'0')
	sele fvmd
	seek fvm.id
	scan while vdvmid=fvm.id
		=seek(substr(alltri(str(fvmd.vdacid))+space(6),1,6),'ord')
		sele gle
		appen blank
		repl voucher with last4
		repl vcsno with lvou_no
		repl code with ord.ordno
		repl date with fvm.vmentrydate
		repl remark1 with chrtran(fvmd.vdnarration,chr(0),'')
		if fvmd.vddramt#0
			repl cd with 'D'
			repl debit with fvmd.vddramt
		else
			repl cd with 'C'
			repl credit with fvmd.vdcramt
		endif		
		do case
			case fvm.vmvchtypeid=1
				repl book with 'J'
			case fvm.vmvchtypeid=2
				repl book with 'C'
			case fvm.vmvchtypeid=4
				repl book with 'P'
			case inlist(fvm.vmvchtypeid,5,3)
				repl book with 'R'
		endcase
		=seek(substr(alltri(str(fvmd.oppacid))+space(6),1,6),'ord')
		repl code1 with ord.ordno
	endscan			
	last4=last4+10
endscan
sele mslip
repl voucher with last4+10
repl svoucher with slast5+10
clos table all




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

*!*	EOF : A2H.PRG .....Dated    : 18/12/2025   Author : SARVESH
