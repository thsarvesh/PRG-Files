*!*	BOF || Software Name : Interact || Pharma Wholesale || Auro : Sarvesh || Date : 25-03-2026||
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
	datatransferpath=substr('D:\MIGRATION_DATA\MAR\INTERACT_DATA\DBF_FILES\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='29'
removenull = 'NO'
@13,10 say 'INTERACT Data Path      :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'INTERACT Extension      :'  font 'Courier',18 get datatransferext  font 'courier',18
@15,10 say 'WITH O/S                :'  font 'courier',18 get old_3 pict '@m YES,NO ' when outsonly='N'   font 'courier',18
@16,10 say 'F.Y.BEGIN FROM          :'  font 'courier',18 get old_5     font 'courier',18
@17,10 say 'F.Y.UP TO               :'  font 'courier',18 get old_9    font 'courier',18
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
@ 02,25 say 'Please Wait..Importing Interact Pharma Wholesale Data To Marg.....' font 'courier',14 colo 'W+/b'
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
use &datdev\RATE.&datext
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
use &datatransferpath\item_mst alias fitm
sele sele(1)
use &datatransferpath\pack_mst alias packmst
index on c_code to packmast
sele sele(1)
use &datatransferpath\gst_hsn_mst alias hsnmst
index on c_code to hsnmst
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname+str(igst,5,2) to mpcm
sele sele(1)
use &datdev\pro.&datext alias  mitm
dele all
sele fitm
scan
	=seek(fitm.c_pack_cod,'packmst')
	=seek(fitm.c_hsn_sac_,'hsnmst')
	sele mitm
	appen blank
	repl code with recno()		
	repl name with fitm.c_code
	repl product with fitm.c_name
	repl packing with packmst.c_name
	repl billname with mitm.product+mitm.packing
	repl pack with fitm.n_strip_bo
	repl rackno with fitm.c_code
	repl unit with 'PCS'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.gcode with fitm.c_div_code
	repl mitm.gcode3 with fitm.c_type_cod
	repl mitm.gcode5 with fitm.c_pack_typ
	repl mitm.maximum with fitm.n_max_qty
	repl minimum with fitm.n_min_qty
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.salsc with 0
	repl mitm.deal with fitm.n_sch_qty_
	repl mitm.free with fitm.n_free_qty
	repl mitm.mrp with fitm.n_mrp
	repl mitm.ratea with fitm.n_srt&&*iif(mitm.pack#0,mitm.pack,1)
	repl mitm.lprate with fitm.n_prt/iif(mitm.pack#0,mitm.pack,1)
	repl mitm.prate with fitm.n_prt
	repl saltax with hsnmst.n_cgst
	repl cgst   with hsnmst.n_sgst
	repl igst   with hsnmst.n_igst
	mhsn=hsnmst.c_hsn_code
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
@rowno,10 say '**** Importing Company ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\div_group_mst.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ'
	repl mpcm.scode  with fpcm.c_code
	repl mpcm.sname  with fpcm.c_name
	repl mpcm.parnam with fpcm.c_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Group****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
index on sgcode+sname to mpcm
sele sele (1)
use &datatransferpath\item_type_mst.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'SALT'
	repl mpcm.scode  with fpcm.c_code
	repl mpcm.sname  with fpcm.c_name
	repl mpcm.parnam with fpcm.c_name
	repl mpcm.tcode with 'No'
endscan
close table all
@rowno,10 say '**** Importing Category ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\item_pack_type_mst.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'CATEGO'
	repl mpcm.scode  with fpcm.c_code
	repl mpcm.sname  with fpcm.c_name
	repl mpcm.parnam with fpcm.c_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Area ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\area_mst.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA'
	repl mpcm.scode  with fpcm.c_code
	repl mpcm.sname  with fpcm.c_name
	repl mpcm.parnam with fpcm.c_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Sub Area ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\subarea_mst.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA'
	repl mpcm.scode  with fpcm.c_code
	repl mpcm.sname  with fpcm.c_name
	repl mpcm.parnam with fpcm.c_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Route ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alia mpcm
sele sele (1)
use &datatransferpath\city_mst.dbf alia fpcm
sele fpcm
go top
scan
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ROUT'
	repl mpcm.scode  with fpcm.c_code
	repl mpcm.sname  with fpcm.c_name
	repl mpcm.parnam with fpcm.c_name
	repl mpcm.tcode with 'No'
endsc
close table all
@rowno,10 say '**** Importing Special Scheme Master Customer Wise ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\rate.&datext alia mpcm
sele sele (1)
use &datdev\pro.&datext alia mitm
index on name to mitm
sele sele (1)
use &datatransferpath\sp_sch_mst.dbf alia fpcm
sele fpcm
go top
scan
	=seek(substr(fpcm.c_item_cod+space(10),1,10),'mitm')
	sele mpcm
	append blank
	repl pcode with fpcm.c_cust_cod,;
		 code with mitm.code,;
		 date with firstdate,;
		 deal with fpcm.n_sch_qty_,;
		 free with fpcm.n_free_qty,;
		 type with 'D'
endsc
close table all
@rowno,10 say '**** Importing Special Rate Master Customer Wise ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\rate.&datext alia mpcm
sele sele (1)
use &datdev\pro.&datext alia mitm
index on name to mitm
sele sele (1)
use &datatransferpath\sp_rate_mst.dbf alia fpcm
sele fpcm
go top
scan
	=seek(substr(fpcm.c_item_cod+space(10),1,10),'mitm')
	sele mpcm
	append blank
	repl pcode with fpcm.c_cust_cod,;
		 code with mitm.code,;
		 date with firstdate,;
		 rate with fpcm.n_srt,;
		 type with ' '
endsc
close table all


@rowno,10 say '**** Importing Batch ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\stock alias fsbal
sele sele (1)
use &datatransferpath\sp_rate_cat_mst.dbf alia fpcm
index on c_item_cod to fpcm
sele sele (1)
use &datatransferpath\sp_sch_cat_mst.dbf alia fsch
index on c_item_cod to fsch
sele sele(1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\probat.&datext alias msbal
index on name+batchno to msbal
sele fsbal
go top
scan
	=seek(fsbal.c_item_cod,'fpcm')
	=seek(fsbal.c_item_cod,'fsch')
	mbal=n_bal_qty
	sele mitm
	seek substr(fsbal.c_item_cod+space(10),1,10)
	sele msbal
	seek substr(fsbal.c_item_cod+space(10),1,10)+substr(fsbal.c_batch_no+space(12),1,12)
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
			msbal.opening with mbal,;
			msbal.balance with mbal,;
			msbal.o_a with mbal,;
			msbal.b_a with mbal,;
			msbal.batchno with fsbal.c_batch_no
	    repl msbal.exp with fsbal.d_exp_dt,;
	    	 msbal.mfd with fsbal.d_mfg_dt,;	
			 msbal.mrp with fsbal.n_mrp,;
			 msbal.prate with fsbal.n_prt,;
			 msbal.ratea with fsbal.n_srt,;
			 msbal.lprate with fsbal.n_prt/iif(mitm.pack#0,mitm.pack,1),;
			 msbal.misc1 with mitm.gcode,;
			 msbal.supcode with '',;
			 msbal.rateb with fpcm.n_srt,;
			 msbal.deal with fsch.n_sch_qty_,;
			 msbal.free with fsch.n_free_qty
	else
		repl msbal.opening with msbal.opening +mbal,;
			msbal.balance with msbal.balance +mbal,;
			msbal.o_a with msbal.o_a +mbal,;
			msbal.b_a with msbal.b_a +mbal
	endif
Endscan
close table all
@rowno,10 say '**** Importing Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\act_mst alias fact
sele sele(1)
use &datatransferpath\city_mst alias citymst
index on c_code to citymst
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	=seek(fact.c_city_cod,'citymst')
	sele mact
	appen blank
		do case
			case fact.c_grp_no='1002002000'
				mscode='C6'
			case inlist(fact.c_grp_no,'1002003002')
				mscode='C2'
			case inlist(fact.c_grp_no,'1002003001')
				mscode='C1'
				mscode='C2'
			case inlist(fact.c_grp_no,'2005001001','2005001002')
				mscode='D31'
		otherwise 
				mscode='J12'
		endcase
	repl mact.scode with mscode
	repl mact.rate with 'Y'
	repl mact.ordno with fact.c_code
	repl mact.fax2 with fact.c_code
	repl mact.parnam  with fact.c_name
	repl mact.mailnam with fact.c_name
	repl mact.paradd with fact.c_add_1
	repl mact.paradd1 with fact.c_add_2
	repl mact.paradd2 with alltri(fact.c_add_3)+' '+alltri(fact.c_add_4)
	repl mact.city with citymst.c_name
	repl mact.dsm with fact.c_pin
	repl mact.phone2 with fact.c_phone
	repl mact.phone3 with fact.c_fax
	repl duedays with fact.n_days
	repl mact.stno with fact.c_st_no,;
		 mact.cstno with fact.c_cst_no,;
		 mact.area with fact.c_area_cod,;
		 mact.mr with fact.c_rep_code,;
		 mact.dlno with alltri(fact.c_dl_no1)+' '+alltri(fact.c_dl_no2),;
		 mact.phone4 with fact.c_mobile,;
		 mact.phone1 with fact.c_mobile,;
		 mact.rout with fact.c_city_cod,;
		 mact.itno with fact.c_pan_no,;
		 mact.phone3 with fact.c_mobile2,;
		 mact.gstno with fact.c_gstin_no,;
		 mact.limit with fact.n_limit
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
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
    sele support
    append blank
    repl aliase with 'ORDER   ',;
         type with 'F',;
         lcode with mact.ordno,;
         sno with 12,;
         remark with fact.c_email_id,;
         heading with substr(heading,1,21)+iif(empty(mact.gstno),'UG','NG')	
endscan
close tables all
=messagebox('Master Transfer has been done,Please check the data','MargErp')
retu
@rowno,10 say '**** Importing A/C Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on ordno to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\sales1 alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
set filter to balance#0
go top
scan
	mvcn=alltr(str(fout.salno))
	sele mord
	seek substr(alltri(str(fout.pa_code))+space(6),1,6)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.date
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->net),abs(fout->net))
	repl balance with iif(acgroup='D31',-abs(fout.balance),abs(fout.balance))
	repl itemope with iif(acgroup='D31',-abs(fout->net-fout.balance),abs(fout->net-fout.balance))
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
*!*	EOF || Software Name : Interact || Pharma Wholesale || Auro : Sarvesh || Date : 25-03-2026||
