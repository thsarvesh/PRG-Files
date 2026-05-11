*!*	BOF : One Retail.PRG .....Dated    : 17-03-2026  Author : SARVESH
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
if type('FINALCP')='U'
	firstdate=ctod('01/04/2025')                         && Un-Comment this for run from VFP
	lastdate =ctod('31/03/2026')                         && Un-Comment this for run from VFP
	datdev='d:\transfer\'                                 && Un-Comment this for run from VFP
	datext='dbf'
endif
sure= space(4)
datatransferpath=substr('D:\MIGRATION_DATA\MAR\ONE_RETAIL\TOR_MAST\'+space(95),1,95) &&rpos_path
datatransferpath1=substr('D:\MIGRATION_DATA\MAR\ONE_RETAIL\TOR_TRAN\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
datatransferext1='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='24'
removenull = 'NO'
@13,10 say 'One Retail Data Path    :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'One Retail Extension    :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_9    font 'courier',18
@18,10 say 'GST/VAT                 :'  font 'courier',18 get old_12  pict '@m Gst,Vat'  font 'courier',18
@19,10 say 'State GST Code          :'  font 'courier',18 get mstatecode    font 'courier',18
@20,10 say 'Removenull              :'  font 'courier',18 get removenull pict '@M No ,Yes'    font 'courier',18
@21,10 say 'Type SURE               :'  font 'courier',18 get sure pict '@x!'  font 'courier',18
read
datatransferpath  = alltrim(datatransferpath)
datatransferpath1  = alltrim(datatransferpath1)
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
@ 02,25 say 'Please Wait..Importing One Retail Data To Marg.....' font 'courier',14 colo 'W+/b'
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
sele sele(1)
use &datatransferpath\tor_product alias fitm
sele sele(1)
use &datatransferpath\tor_groupdetail alias fgrp
sele sele(1)
select * from fgrp where typeid=25 into curs pkmst readwr
sele pkmst
index on grpid to pkmst
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
	=seek(fitm.grpid_pack,'pkmst')
	sele mitm
	appen blank
	repl code with fitm.pid
	repl name with alltri(str(fitm.ncode))
	repl product with fitm.pname
	repl packing with pkmst.grpname
	repl billname with mitm.product+mitm.packing
	repl pack with 0
	repl rackno with alltri(fitm.loca)+alltri(str(fitm.locn))
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.gcode with padr(fitm.misc_pmfgr,6)
	repl mitm.gcode3 with ''
	repl mitm.maximum with 0
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.mrp with fitm.mrp
	repl mitm.ratea with fitm.tnpr
	repl mitm.lprate with fitm.npr
	repl mitm.prate with fitm.npr
	repl saltax with fitm.igst_per/2
	repl cgst   with fitm.igst_per/2
	repl igst   with fitm.igst_per
	mhsn=fitm.hsn
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
endscan
close table all
@rowno,10 say '**** Importing Company****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\tor_misc.dbf alia fpcm
set filt to typeid=3001
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ  '
	repl mpcm.scode  with padr(fpcm.miscid,6)
	repl mpcm.sname  with fpcm.miscname
	repl mpcm.parnam with fpcm.miscname
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Area****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\tor_groupdetail.dbf alia fpcm
set filt to typeid=3
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA'
	repl mpcm.scode  with padr(fpcm.grpid,6)
	repl mpcm.sname  with fpcm.grpname
	repl mpcm.parnam with fpcm.grpname
	repl mpcm.tcode with 'No'
endscan
close table all

@rowno,10 say '**** Importing Batch Inward ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath1\tor_inward alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan for iscancel=.f.
	mexp=ctod(substr(expdate,9,2)+'/'+substr(expdate,6,2)+'/'+substr(expdate,1,4))
	mmfd=ctod(substr(mfgdate,9,2)+'/'+substr(mfgdate,6,2)+'/'+substr(mfgdate,1,4))
	sele mitm
	seek str(fsbal.pid,9)
	sele msbal
	seek str(fsbal.pid,9)+substr(fsbal.batchno+space(12),1,12)
	if !found()
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
			msbal.batchno with fsbal.batchno
		repl msbal.mycode with fsbal.barcode
	    repl msbal.exp with mexp,;
	    	msbal.mfd with mmfd,;
			msbal.mrp with fsbal.mrp,;
			msbal.prate with fsbal.npr,;
			msbal.ratea with fsbal.tnpr,;
			msbal.lprate with fsbal.npr/iif(mitm.pack#0,mitm.pack,1),;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with '',;
			msbal.purdis with fsbal.cd_per
			
		repl supdat with ctod(substr(fsbal.vdate,9,2)+'/'+substr(fsbal.vdate,6,2)+'/'+substr(fsbal.vdate,1,4))
		repl supinvo with alltri(str(fsbal.vno))
			
	else
		repl msbal.opening with msbal.opening + fsbal.qty,;
			msbal.balance with msbal.balance + fsbal.qty,;
			msbal.o_a with msbal.o_a + fsbal.qty,;
			msbal.b_a with msbal.b_a + fsbal.qty
			repl msbal.mycode with fsbal.barcode
		repl supdat with ctod(substr(fsbal.vdate,9,2)+'/'+substr(fsbal.vdate,6,2)+'/'+substr(fsbal.vdate,1,4))
		repl supinvo with alltri(str(fsbal.vno))

	endif
endscan
close table all
@rowno,10 say '**** Importing Batch Outward ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath1\tor_outward alias fsbal
sele sele(1)
use &datdev\pro.&datext alias mitm
index on str(code,9) to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on str(code,9)+batchno to msbal
sele fsbal
go top
scan for iscancel=.f.
	mexp=ctod(substr(expdate,9,2)+'/'+substr(expdate,6,2)+'/'+substr(expdate,1,4))
	mmfd=ctod(substr(mfgdate,9,2)+'/'+substr(mfgdate,6,2)+'/'+substr(mfgdate,1,4))
	sele mitm
	seek str(fsbal.pid,9)
	sele msbal
	seek str(fsbal.pid,9)+substr(fsbal.batchno+space(12),1,12)
	if !found()
		append blank
		repl msbal.code with mitm.code,;
			msbal.name with mitm.name,;
			msbal.billname with mitm.billname,;
			msbal.product with mitm.product,;
			msbal.pack with mitm.pack,;
			msbal.unit2 with mitm.unit2,;
			msbal.unit with mitm.unit,;
			msbal.decimal with 'Y',;
			msbal.opening with -fsbal.qty,;
			msbal.balance with -fsbal.qty,;
			msbal.o_a with -fsbal.qty,;
			msbal.b_a with -fsbal.qty,;
			msbal.batchno with fsbal.batchno
		repl msbal.mycode with fsbal.barcode
	    repl msbal.exp with mexp,;
	    	msbal.mfd with mmfd,;
			msbal.mrp with fsbal.mrp,;
			msbal.prate with fsbal.npr,;
			msbal.ratea with fsbal.tnpr,;
			msbal.lprate with fsbal.npr/iif(mitm.pack#0,mitm.pack,1),;
			msbal.misc1 with mitm.gcode,;
			msbal.supcode with ''
			
	else
		repl msbal.opening with msbal.opening - fsbal.qty,;
			msbal.balance with msbal.balance - fsbal.qty,;
			msbal.o_a with msbal.o_a - fsbal.qty,;
			msbal.b_a with msbal.b_a + fsbal.qty
	endif
endscan
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\tor_mast alias fact
sele sele(1)
use &datatransferpath\tor_mast_add alias led
index on str(mastid,9)+str(typeid,9) to led
sele sele(1)
use &datatransferpath\tor_groupdetail alias fgrp
sele sele(1)
use &datatransferpath\tor_mast_comm alias mobmst
index on str(mastid,9)+str(typeid,9) to mobmst
sele sele(1)
use &datatransferpath\tor_mast_reg alias regdt
index on str(mastid,9)+str(typeid,9)+str(fxdid_regtype,9) to regdt
sele sele(1)
select * from fgrp where typeid=4 into curs ctmst readwr
sele ctmst
index on grpid to ctmst
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	=seek(str(fact.mastid,9)+str(fact.typeid,9),'led')
	=seek(str(fact.mastid,9)+str(fact.typeid,9),'mobmst')
	=seek(led.grpid_city,'ctmst')
	sele mact
	appen blank
	repl mact.scode with 'D31'
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.mastid))
	repl mact.fax2 with alltri(str(fact.ncode))
	repl mact.parnam  with fact.mastname
	repl mact.mailnam with fact.mastname
	repl mact.paradd with led.add_1
	repl mact.paradd1 with led.add_2
	repl mact.paradd2 with led.lmark
	repl mact.city with ctmst.grpname
	repl mact.dsm with led.zipcode
	repl mact.area with padr(led.grpid_area,6)
	repl phone1 with mobmst.mobile
	repl phone2 with mobmst.tel
	repl phone4 with mobmst.wapp
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	if seek(str(fact.mastid,9)+str(2002,9)+str(1051,9),'regdt')
		repl mact.gstno with regdt.regno
	endi
	if seek(str(fact.mastid,9)+str(2002,9)+str(1052,9),'regdt')
		repl mact.itno with regdt.regno
	endi
	if seek(str(fact.mastid,9)+str(2002,9)+str(1054,9),'regdt')
		repl mact.dlno with alltri(regdt.regno)
	endi
	if seek(str(fact.mastid,9)+str(2002,9)+str(1055,9),'regdt')
		repl mact.dlno with alltri(dlno)+' '+alltri(regdt.regno)
	endi
	*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having
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
&& Email ID
    Sele support
    Append Blank
    Repl aliase With 'ORDER   ',;
        type With 'F',;
        lcode With mact.ordno,;
        sno With 12,;
        remark With mobmst->email,;
        heading With Substr(Heading,1,21)+Iif(Empty(mact->gstno),'UG','NG')
    
endscan
close tables all
@rowno,10 say '**** Importing Customer  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\tor_misc alias fact
sele sele(1)
use &datatransferpath\tor_mast_add alias led
index on str(mastid,9)+str(typeid,9) to led
sele sele(1)
use &datatransferpath\tor_groupdetail alias fgrp
sele sele(1)
use &datatransferpath\tor_mast_comm alias mobmst
index on str(mastid,9)+str(typeid,9) to mobmst
sele sele(1)
use &datatransferpath\tor_mast_reg alias regdt
index on str(mastid,9)+str(typeid,9)+str(fxdid_regtype,9) to regdt
sele sele(1)
select * from fgrp where typeid=4 into curs ctmst readwr
sele ctmst
index on grpid to ctmst
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	=seek(str(fact.miscid,9)+str(fact.typeid,9),'led')
	=seek(str(fact.miscid,9)+str(fact.typeid,9),'mobmst')
	=seek(led.grpid_city,'ctmst')
	sele mact
	appen blank
	repl mact.scode with 'C6'
	repl mact.rate with 'Y'
	repl mact.ordno with 'S'+alltri(str(fact.miscid))
	repl mact.fax2 with alltri(str(fact.miscid))
	repl mact.parnam  with fact.miscname
	repl mact.mailnam with fact.miscname
	repl mact.paradd with led.add_1
	repl mact.paradd1 with led.add_2
	repl mact.paradd2 with led.lmark
	repl mact.city with ctmst.grpname
	repl mact.dsm with led.zipcode
	repl mact.area with padr(led.grpid_area,6)
	repl phone1 with mobmst.mobile
	repl phone2 with mobmst.tel
	repl phone4 with mobmst.wapp
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
	if seek(str(fact.miscid,9)+str(2002,9)+str(1051,9),'regdt')
		repl mact.gstno with regdt.regno
	endi
	if seek(str(fact.miscid,9)+str(2002,9)+str(1052,9),'regdt')
		repl mact.itno with regdt.regno
	endi
	if seek(str(fact.miscid,9)+str(2002,9)+str(1054,9),'regdt')
		repl mact.dlno with alltri(regdt.regno)
	endi
	if seek(str(fact.miscid,9)+str(2002,9)+str(1055,9),'regdt')
		repl mact.dlno with alltri(dlno)+' '+alltri(regdt.regno)
	endi
	*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having
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
&& Email ID
    Sele support
    Append Blank
    Repl aliase With 'ORDER   ',;
        type With 'F',;
        lcode With mact.ordno,;
        sno With 12,;
        remark With mobmst->email,;
        heading With Substr(Heading,1,21)+Iif(Empty(mact->gstno),'UG','NG')
    
endscan
close tables all

@rowno,10 say '**** Importing A/C Outstandings Retail Customer  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath1\tor_os alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan for miscid_misc#0 and iscancel=.f.
	mvcn=alltr(fout.tvno)
	mdate=ctod(substr(fout.vdate,9,2)+'/'+substr(fout.vdate,6,2)+'/'+substr(fout.vdate,1,4))
	sele mord
	seek substr('S'+alltri(str(fout.miscid_misc))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with mdate
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout.vamt),abs(fout.vamt))
	repl itemope with iif(acgroup='D31',-abs(fout.setoffamt),abs(fout.setoffamt)) 
	repl balance with iif(acgroup='D31',-abs(fout.vamt-fout.setoffamt),abs(fout.vamt-fout.setoffamt))
*!*		if inlist(fout.typeid,6002,6001)
*!*			repl final with fout.vamt
*!*			repl itemope with fout.vamt
*!*			repl balane with (fout.vamt-fout.vamt) 
*!*		endif
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing A/C Outstandings (Supplier)  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath1\tor_os alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan for inlist(typeid,5000,6001,6002,5002,5003) and miscid_misc=0 and iscancel=.f.
	mvcn=alltr(fout.tvno)
	mdate=ctod(substr(fout.vdate,9,2)+'/'+substr(fout.vdate,6,2)+'/'+substr(fout.vdate,1,4))
	sele mord
	seek substr(alltri(str(fout.mastid_mast))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with mdate
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
*!*		repl final with iif(acgroup='D31',-abs(fout.vamt),abs(fout.vamt))
*!*		repl itemope with iif(acgroup='D31',-abs(fout.setoffamt),abs(fout.setoffamt)) 
*!*		repl balance with iif(acgroup='D31',-abs(fout.vamt-fout.setoffamt),abs(fout.vamt-fout.setoffamt))
	if inlist(fout.typeid,5000,6001,6002)
		repl final with fout.vamt
		repl itemope with fout.setoffamt
		repl balance with (fout.vamt-fout.setoffamt) 
	endif
	if inlist(fout.typeid,5002,5003)
		repl final with -fout.vamt
		repl itemope with -fout.setoffamt
		repl balance with -(fout.vamt-fout.setoffamt) 
	endif
	repl name with vcn
	vou=vou+5
	svou=svou+5
endsc
sele mslip
repl voucher  with vou+5
repl svoucher with svou+5
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
=messagebox('Master Transfer has been done,Please check the data','MargErp')

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
*!*	EOF : One Retail.PRG .....Dated    : 17-03-2026  Author : SARVESH
