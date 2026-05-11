** Last Update by Rajesh VK dt. 17.02.2024
clear
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
set cpdialog off
sele sele(1)
create curs mycurs  (setup c(50),value c(4))
sele mycurs
appen blank
repl  setup with 'Volume Discount 1',value with 'L'
appen blank
repl  setup with 'Ask Discount in Amount',value with 'N'
appen blank
repl  setup with 'Deal/Lot              ',value with 'l'

brow font 'COURIER',18    nomodify
if type('FINALCP')='U'
	firstdate=ctod('01/04/2024')
	lastdate=ctod('31/03/2025')
	datdev='d:\transfer\'
	datext='DBF'
endif
close data
sure = 'SURE'
datatransferpath=substr('D:\Data_Migration\Nov\Dbf\'+space(45),1,45)
datatransferext='dbf'
old_3 = 'YES'
old_4 = 'No '
old_5 = firstdate
old_6 = '2'
old_7 = 'Y'
old_8 = '#'
scalc='2'
pcalc='2'
rscalc='9'
mstatecode='09'
removeduplicate='No '
isretail='No '

@06,22 say 'SUGAM DATA TRANSFER TO MARG '+space(30) font 'Arial',14 style 'BU' color rgb(0,0,0,20,250,150)
@08,22 say 'OLD DATA PATH       :' font 'courier new',12 get datatransferpath   font 'courier new',12
@09,22 say 'OLD DATA Extension  :' font 'courier new',12 get datatransferext   font 'courier new',12
@10,22 say 'WITH O/S            :' font 'courier new',12  get  old_3 pict '@m YES,NO ' font 'courier new',12
@11,22 say 'Master-Y Full-N     :' font 'courier new',12  get  old_4 pict '@m No ,Yes' font 'courier new',12
@12,22 say 'F/Y Start Date      :' font 'courier new',12  get  old_5
@13,22 say 'Deal Base           :' font 'courier new',12  get  old_7 pict '@m YES,NO '  font 'courier new',12
@14,22 say 'Sign II Sale        :' font 'courier new',12  get  old_8 pict '!'   font 'courier new',12
@15,22 say 'Remove Duplicate    :' font 'courier new',12  get  removeduplicate pict '@m No ,Yes' font 'courier new',12
@16,22 say 'Sale Calculation    :' font 'courier new',12  get  scalc font 'courier new',12
@17,22 say 'Purch Calculation   :' font 'courier new',12  get  pcalc font 'courier new',12
@18,22 say 'STATE CODE          :' font 'courier new',12  get  mstatecode  font 'Courier New',12
@19,22 say 'Retail Required     :' font 'courier new',12  get  isretail pict '@M No ,Yes'  font 'courier new',12
@20,22 say 'Sale Cal(Retail)    :' font 'courier new',12  get  rscalc    font 'courier new',12
@21,22 say 'Type SURE           :' font 'courier new',12  get  sure pict '@x!' font 'courier new',12
read
datatransferpath = alltrim(datatransferpath)
datatransferext  = alltrim(datatransferext)
if lastkey()=27 .or. sure#'SURE'
	return
endif
if removeduplicate='Y'
	=rem_dupl()
endif
if type('FINALCP')#'U'
	=starttransfer()
endif
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
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
clear 
@04,22 say 'SUGAM DATA TRANSFER TO MARG '+space(30) font 'Arial',14 style 'BU' color rgb(0,0,0,20,250,150)
rowno=6
@rowno,10 say '**** Importing Product Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\item_master.&datatransferext alias fitm
sele sele (1)
use &datatransferpath\tax_master.&datatransferext alias ftax
index on str(tax_code,5) to ftax
sele sele (1)
use &datdev\pro.&datext alias mitm
zap
sele sele (1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm
sele fitm
go top
do while ! eof()
	last=recno()
	sele mitm
	append blank
	repl mitm.code with fitm.item_code
	repl mitm.name with allt(str(fitm.item_code))
	repl mitm.product with fitm.item_name
	repl mitm.packing with fitm.unit_pack
	repl mitm.billname with alltrim(fitm.item_name) +' '+ alltrim(fitm.unit_pack)
	repl mitm.unit with 'Pcs'
	repl mitm.pack with fitm.r_unit
	repl mitm.gcode with allt(str(fitm.mfg_comp_c))
	repl mitm.rackno with fitm.rack_no
	repl mitm.taxl with 'T'
	repl mitm.taxc with 'T'
	repl mitm.decimal with 'Y'
	repl mitm.salfix with 'N'
	repl mitm.halfsche with 'A'
	repl mitm.qtrsche with 'Y'
	repl mitm.ratea with fitm.item_pur_r,;
		mitm.ratea with fitm.item_sale_,;
		mitm.ratea with fitm.item_mrp_r
	sele ftax
	seek str(fitm.tax_code,5)
	repl mitm.cgst with ftax.central_ta
	repl mitm.saltax with ftax.local_tax
	repl mitm.igst with ftax.local_tax+ftax.central_ta
	if ftax.central_ta+ftax.local_tax=0
		repl mitm.taxl with 'E'
	endif
	&&For HSN
	sele mpcm
	seek 'COMMCD' + substr(fitm.hsn_code+space(15),1,15) + str(mitm.igst,5,2)
	if !found()
		append blank
		repl mpcm.sgcode with 'COMMCD',;
			mpcm.scode  with 'C'+alltrim(str(last)),;
			mpcm.sname  with substr(fitm.hsn_code+space(15),1,15)+ substr(fitm.hsn_code,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
			mpcm.parnam with substr(fitm.hsn_code,1,15),;
			mpcm.tax with mitm.saltax,;
			mpcm.cgst with mitm.cgst,;
			mpcm.igst with mitm.igst,;
			mpcm.tcode with 'No'
	endif
	repl mitm.gcode6 with mpcm.scode
	sele fitm
	skip
enddo
close data

@rowno,10 say '**** Importing Area Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\area_master.&datatransferext alias fpcm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode = 'AREA  '
pack
sele fpcm
go top
do while ! eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'AREA  '
	repl mpcm.scode  with allt(str(fpcm.area_code))
	repl mpcm.sname  with allt(fpcm.area_name)
	repl mpcm.parnam with allt(fpcm.area_name)
	repl mpcm.tcode with 'No'
	sele fpcm
	skip
enddo
close data

@rowno,10 say '**** Importing Company Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\mfg_comp_master.&datatransferext alias fpcm
sele sele (1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode = 'ZZZZZZ'
pack
sele fpcm
go top
do while ! eof()
	sele mpcm
	append blank
	repl mpcm.sgcode with 'ZZZZZZ',;
		mpcm.scode  with allt(str(fpcm.mfg_comp_c)),;
		mpcm.sname  with fpcm.mfg_comp_n,;
		mpcm.parnam with fpcm.mfg_comp_n,;
		mpcm.tcode with 'No'
	sele fpcm
	skip
enddo
close data

@rowno,10 say '**** Importing Batch Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\stock_stmt.&datatransferext alias fsbal
sele sele (1)
use &datatransferpath\pur_master.&datatransferext alias fpur
index on str(sys_pur_co,8) to fpur
sele sele (1)
use &datatransferpath\pur_detail.&datatransferext alias fstk
index on str(item_code)+batch_no to fstk for inv_type_f='O'
sele sele(1)
use &datatransferpath\stock_detail alias stkrate
index on str(item_code)+batch_no to stkrate
sele sele (1)
use &datdev\probat.&datext alias msbal
zap
index on name+batchno to msbal
sele sele (1)
use &datdev\pro.&datext alias mitm
index on name to mitm
sele sele(1)
use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
dele all for type = '#'
r=0
sele fsbal
go top
do while !eof()
	sele mitm
	seek substr(allt(str(fsbal.item_code))+space(10),1,10)
	dq=0
	df=0
	y=0
	try
		if at('+',fsbal.bonus_rcvd)>0
			y=at('+',fsbal.bonus_rcvd)
			dq = val(substr(fsbal.bonus_rcvd,1,y-1))
			df = val(substr(fsbal.bonus_rcvd,y+1))
		else
			dq=0
			df=0
			y=0
		endif
	catch
		er=1
	endtry
	mopening=0
	sele fstk
	seek str(fsbal.item_code)+fsbal.batch_no
	tot=0
	scan while str(item_code)+batch_no=str(fsbal.item_code)+fsbal.batch_no
		if isretail='Y'
			mqty=(pur_qty+free_qty)*iif(mitm.pack#0,mitm.pack,1)
			tot=tot+mqty &&((PUR_QTY+FREE_QTY)*IIF(MITM.PACK#0,MITM.PACK,1))

		else
			tot=tot+((pur_qty+free_qty))
		endif
	endscan
	sele mitm
	seek substr(allt(str(fsbal.item_code))+space(10),1,10)
	=seek(left(fsbal.batch_no,8),'fstk')
	sele stkrate
	seek str(fsbal.item_code)+left(fsbal.batch_no,12)
	sele msbal
	append blank
	repl msbal.code with mitm.code,;
		msbal.name with mitm.name,;
		msbal.billname with mitm.billname,;
		msbal.product with mitm.product,;
		msbal.pack with mitm.pack,;
		msbal.unit2 with mitm.unit2,;
		msbal.unit with mitm.unit,;
		msbal.decimal with 'Y',;
		msbal.opening with iif(old_4='N',tot,fsbal.stock_qty),;
		msbal.balance with iif(old_4='N',tot,fsbal.stock_qty),;
		msbal.o_a with iif(old_4='N',tot,fsbal.stock_qty),;
		msbal.b_a with iif(old_4='N',tot,fsbal.stock_qty),;
		msbal.batchno with iif(fsbal.est_inv_fl='E',old_8+allt(fsbal.batch_no),allt(fsbal.batch_no));
		msbal.exp with iif(fstk.exp_dt=ctod('01/01/1900'),ctod('  /  /    '),fstk.exp_dt)

	repl msbal.lprate with fsbal.pc,;
		msbal.prate with stkrate.item_pur_r,;
		msbal.ratea with stkrate.item_sale_,;
		msbal.mrp with stkrate.item_mrp_r,;
		msbal.misc1 with mitm.gcode,;
		msbal.purdis with fstk.pur_disc01+fstk.spl_disc,;
		msbal.purdeal with dq,;
		msbal.purfree with df,;
		msbal.supinvo with fpur.pur_inv_no,;
		msbal.supdat with fpur.pur_dt,;
		msbal.date with fpur.pur_dt,;
		msbal.supcode with allt(str(fpur.party_code))
	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-BT",lcode with "MEDIBT",pcode with mitm.code,heading with msbal.batchno,value with (msbal.balance)
	sele fsbal
	skip
enddo
sele msbal
repl all date with old_5-1 for balance = 0

@rowno,10 say '**** Importing Stock Adjustments ****' font 'Arial',10
rowno=rowno+1
sele fsbal
*!*	*    set filt to item_code=519
go top
do while !eof()
	sele mitm
	seek substr(allt(str(fsbal.item_code))+space(10),1,10)
	sele msbal
	seek mitm.name+subs(fsbal.batch_no+space(12),1,12)
	if found()
		try
			repl msbal.opening with opening+fsbal.adj_qty,;
				msbal.balance with balance++fsbal.adj_qty,;
				msbal.o_a with o_a+fsbal.adj_qty,;
				msbal.b_a with b_a+fsbal.adj_qty
		catch
			er=1
		endtry
	endif
	sele fsbal
	skip
enddo
sele msbal
repl all date with old_5-1 for balance = 0
close data


*!*	    if old_4='N'
*!*	        wait wind nowait 'PLEASE WAIT PIPING DATA TO MARG.....'+chr(13)+"Transfer BATCH Opening"
*!*	        fd=datatransferpath + 'pur_detail.'+datatransferext
*!*	        td=datdev + '\probat.'+datext
*!*	        mi=datdev + '\pro.'+datext
*!*	        use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
*!*	        index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support

*!*	        dele all for type = '#'
*!*	        sele a
*!*	        use &fd alias fsbal
*!*	        sele b
*!*	        use &mi alias mitm
*!*	        index on name to mitm
*!*	        sele c
*!*	        use &td alias msbal
*!*	        index on name + batchno to msbal
*!*	        r=0
*!*	        sele fsbal
*!*	        set filter to sys_pur_co = 0
*!*	        go top
*!*	        do while !eof()
*!*	            dq=0
*!*	            df=0
*!*	            y=0
*!*	**Deal Calculation
*!*	            if at('+',fsbal.pdeal_valu)>0
*!*	                y=at('+',fsbal.pdeal_valu)
*!*	                dq = val(substr(fsbal.pdeal_valu,1,y-1))
*!*	                df = val(substr(fsbal.pdeal_valu,y+1))
*!*	            else
*!*	                dq=0
*!*	                df=0
*!*	                y=0
*!*	            endif

*!*	            sele mitm
*!*	            seek substr(allt(str(fsbal.item_code))+space(10),1,10)
*!*	            sele msbal
*!*	            seek substr(allt(str(fsbal.item_code))+space(10),1,10) + substr(fsbal.batch_no+space(12),1,12)
*!*	            if !found()
*!*	                append blank
*!*	                repl msbal.code with mitm.code,;
*!*	                    msbal.name with mitm.name,;
*!*	                    msbal.billname with mitm.billname,;
*!*	                    msbal.product with mitm.product,;
*!*	                    msbal.pack with mitm.pack,;
*!*	                    msbal.unit2 with mitm.unit2,;
*!*	                    msbal.unit with mitm.unit,;
*!*	                    msbal.decimal with 'Y',;
*!*	                    msbal.opening with (fsbal.pur_qty+fsbal.free_qty),;
*!*	                    msbal.balance with (fsbal.pur_qty+fsbal.free_qty),;
*!*	                    msbal.o_a with (fsbal.pur_qty+fsbal.free_qty),;
*!*	                    msbal.b_a with (fsbal.pur_qty+fsbal.free_qty),;
*!*	                    msbal.batchno with iif(fsbal.est_inv_fl='E',old_8+allt(fsbal.batch_no),allt(fsbal.batch_no));
*!*	                    msbal.exp with iif(fsbal.exp_dt=ctod('01/01/1900'),ctod('  /  /    '),fsbal.exp_dt),;
*!*	                    msbal.lprate with fsbal.pc,;
*!*	                    msbal.prate with fsbal.item_pur_r,;
*!*	                    msbal.ratea with fsbal.item_sale_,;
*!*	                    msbal.mrp with fsbal.item_mrp_r,;
*!*	                    msbal.misc1 with mitm.gcode,;
*!*	                    msbal.purdis with fsbal.pur_disc01,;
*!*	                    msbal.purdeal with dq,;
*!*	                    msbal.purfree with df

*!*	            else
*!*	                repl msbal.opening with msbal.opening + (fsbal.pur_qty+fsbal.free_qty),;
*!*	                    msbal.balance with msbal.balance + (fsbal.pur_qty+fsbal.free_qty),;
*!*	                    msbal.o_a with msbal.o_a + (fsbal.pur_qty+fsbal.free_qty),;
*!*	                    msbal.b_a with msbal.b_a + (fsbal.pur_qty+fsbal.free_qty),;
*!*	                    msbal.lprate with fsbal.pc,;
*!*	                    msbal.prate with fsbal.item_pur_r,;
*!*	                    msbal.ratea with fsbal.item_sale_,;
*!*	                    msbal.mrp with fsbal.item_mrp_r,;
*!*	                    msbal.misc1 with mitm.gcode,;
*!*	                    msbal.purdis with fsbal.pur_disC01,;
*!*	                    msbal.purdeal with dq,;
*!*	                    msbal.purfree with df
*!*	            endif
*!*	            if fsbal.batch_no = 'EN292       '
*!*
*!*	            endif
*!*	*!*	            sele support
*!*	*!*	            appe blank
*!*	*!*	            repl type with "#",aliase with "DAT/F-BT",lcode with "MEDIBT",pcode with mitm.code,heading with msbal.batchno,value with (fsbal.stock_qty)

*!*	            sele fsbal
*!*	            skip
*!*	        enddo
*!*	        sele msbal
*!*	        repl all date with old_5-1 for balance = 0
*!*	        close data
*!*	    endif

*!*	    close table all
*!*	close data

@rowno,10 say '**** Importing Patient Master ****' font 'Arial',10
rowno=rowno+1
use &datatransferpath\sale_master  alias mst
index on cash_pname to mst uniq
sele sele(1)
use &datdev\maorder.&datext alias pte
index on parnam to pte
sele mst
scan
	sele pte
	seek subs(mst.cash_pname+space(45),1,45)
	if !found()
		appen blank
		repl scode with 'PET#$~'
		repl parnam with mst.cash_pname
		repl city with mst.cash_paddr
		repl form with mst.cash_pph
	endif
endscan
close table all
@rowno,10 say '**** Importing Doctor Master****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\sale_master  alias mst
index on ref_name to mst uniq
sele sele(1)
use &datdev\maorder.&datext alias pte
index on parnam to pte
sele mst
scan
	sele pte
	seek subs(mst.ref_name+space(45),1,45)
	if !found()
		appen blank
		repl scode with 'PRE#$~'
		repl parnam with mst.cash_pname
	endif
endsc
close table all
@rowno,10 say '**** Importing Account Master****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\party_master.&datatransferext alias fact
sele sele (1)
use &datdev\order.&datext alias mact
zap
sele sele(1)
use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
sele fact
pack
go top
do while !eof()
	sele mact
	append blank
	repl mact.rate with 'N'
	if fact.ac_code = '21        '
		repl mact.scode with 'D31'
		repl mact.rate with old_3
	else
		if fact.ac_code = '22        '
			repl mact.scode with 'C6'
			repl mact.rate with old_3
		else
			repl mact.scode with 'J12'
		endif
	endif
	repl mact.ordno with allt(str(fact.party_code)),;
		mact.parnam  with upper(fact.party_name),;
		mact.paradd with fact.party_addr,;
		mact.paradd1 with fact.party_ad01,;
		mact.paradd2 with alltrim(fact.party_city),;
		mact.area with allt(str(fact.area_code)),;
		mact.phone1 with fact.party_ph1,;
		mact.phone2 with fact.party_ph2,;
		mact.phone4 with fact.party_mob,;
		mact.sthed with  'TIN No.',;
		mact.csthed with 'CST No.',;
		mact.cstno with fact.party_ctax,;
		mact.stno with '',;
		mact.gstno with fact.party_ltax,;
		mact.dlno with alltrim(fact.party_lic1) +' * '+ alltrim(fact.party_lic2),;
		mact.mailnam with upper(fact.party_name),;
		mact.ref with 'Mr.',;
		mact.confir with fact.contact_na,;
		mact.price with 'A',;
		mact.city with fact.party_city,;
		mact.status with 'Y',;
		mact.adhed with 'Discount',;
		mact.itno with fact.aadhar_no,;
		mact.opning with iif(fact.cr_dr='D',fact.open_bal,-fact.open_bal)

***STATE
	    sele support
	    appen blank
		repl aliase with 'ORDER   '
		repl type with 'F'
		repl lcode with mact.ordno
		repl sno with 7
		repl pcode with 15
		repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '

	sele support
	appe blank
	repl type with "#",aliase with "DAT/F-LD",lcode with mact.ordno,value with fact.current_ba
	sele fact
	skip
enddo
close data

if old_4='N'
	do import_transactions
endif


proc import_transactions
	mdis=datdev+ '\mdis.'+datext
	af =datdev + '\gledger.'+datext
	bf =datdev + '\slipno.'+datext
	dis=datdev + '\dis.'+datext
	pro=datdev + '\pro.'+datext

	prb=datatransferpath + 'stock_detail.'+datatransferext
	cf =datatransferpath +  'tran_detail.'+datatransferext
	**Sales
	sal = datatransferpath + 'sale_master.'+datatransferext
	sld = datatransferpath + 'sale_detail.'+datatransferext
	**Purchase
	pur = datatransferpath + 'pur_master.'+datatransferext
	pld = datatransferpath + 'pur_detail.'+datatransferext
	**Sales Retail
	sgr = datatransferpath + 'sale_ret_master.'+datatransferext
	sgl = datatransferpath + 'sale_ret_detail.'+datatransferext
	**Purchase Return
	pgr = datatransferpath + 'pur_ret_master.'+datatransferext
	pgl = datatransferpath + 'pur_ret_detail.'+datatransferext
	sele j
	sele sele(1)
	use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
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

	@rowno,10 say '**** Importing Purchase****' font 'Arial',10
	rowno=rowno+1
	last4 = last4 + 20
	sele sele (1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele sele (1)
	use &datatransferpath\tax_master.dbf alias ftax
	index on tax_code to ftax
	sele f
	use &prb alias prb
	index on str(item_code,9) + batch_no to prb
	sele e
	use &pro alias pro
	index on name to pro

	sele c
	use &pur alias pur
	index on str(sys_pur_co,8) to pur

	sele h
	use &pld alias pld
	index on str(sys_pur_co,8) to pld
	sele d
	use &mdis alias mdis
	sele g
	use &dis alias dis

	sele c
	set filt to est_inv_fl = 'I'
	go top
	do while !eof()
		l1 = alltrim(str(c.sys_pur_co))
		l2 = len(l1)
		l3 = replicate('0',6-l2)+l1
		last1 = c.sys_pur_co
		sele d
		appe blank
		repl type with 'P'
		repl misc3 with substr(misc3,1,53)+iif(c.inv_type_f='T','T','R')+substr(misc3,55,100)
		repl vcn with l3
		repl pm with c.pur_inv_no
		repl date with iif(empty(c.entry_dt),c.pur_dt,c.entry_dt)
		repl lrda with c.pur_dt
		repl codep with allt(str(c.party_code))
		repl voucher with last4
		last4=last4+5
		repl amountp with (c.pur_bill_a)
		repl salun with ''
		repl staxun with 'SZTZOZ'
		repl other with c.tpt_chrg + c.other_chrg
		if (c.cash_credi = 'C')
			repl cash with c.pur_bill_a
		else
			repl final with c.pur_bill_a
		endif
		if final=0 and cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with pcalc
		repl discafter with 'N'
		=seek(substr(allt(str(c.party_code))+space(6),1,6),'ord')
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
			isigst=1
		endi

		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

		sele h
		seek str(c.sys_pur_co,8)
		do while  str(c.sys_pur_co,8) = str(h.sys_pur_co,8) and !eof()
			last=substr(allt(str(h.item_code))+space(10),1,10)
			sele f
			seek str(h.item_code,9) + h.batch_no

			sele e
			seek last

			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with h.pur_qty     &&&&iif(e.pack#0,e.pack*h.pur_qty,h.pur_qty)
			repl free with h.free_qty
			repl pack with e.pack
			repl exp with iif(h.exp_dt=ctod('01/01/1900'),ctod('  /  /    '),h.exp_dt)
			repl batch with iif(f.est_inv_fl='E',old_8+allt(h.batch_no),allt(h.batch_no))
			repl flg with 'P'    &&iif(c.sale_ret_f='Y','R','P')
			repl rate with h.item_pur_r
			repl disc1 with h.pur_disc_i
			if h.pur_disc_i=0 and h.pur_disc_a#0
				repl svdis with h.pur_disc_a
				repl misc4 with subs(misc4,1,44)+'L'+subs(misc4,46)
			endif
			=seek(h.tax_code,'ftax')
			if isigst=0
				repl ssta with ftax.local_tax
				repl cgst with ftax.central_ta
			else
				repl ssta with ftax.igst_tax
			endif
			repl ssex with 0
			repl mrp with h.item_mrp_r
			repl half with 'A'
			repl godwon with d.godwon
			if old_7='Y'
				if at('+',h.pdeal_valu)>0
					dq=val(substr(h.pdeal_valu,1,at('+',h.pdeal_valu)-1))
					df=val(substr(h.pdeal_valu,at('+',h.pdeal_valu)+1))
					repl deal with dq/iif(e.pack#0,e.pack,1)
					repl freedeal with df
					repl rsm with h.pdeal_valu
				endif
			endif
			sele h
			skip
		enddo
		sele c
		skip
	enddo
	close data


	@rowno,10 say '**** Importing Purchase Estimate****' font 'Arial',10
	rowno=rowno+1
	last4 = last4 + 20
	sele sele (1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele sele (1)
	use &datatransferpath\tax_master.dbf alias ftax
	index on tax_code to ftax
	sele sele(1)
	use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
	index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
	sele f
	use &prb alias prb
	index on str(item_code,9) + batch_no to prb
	sele e
	use &pro alias pro
	index on name to pro
	sele c
	use &pur alias pur
	index on str(sys_pur_co,8) to pur

	sele h
	use &pld alias pld
	index on str(sys_pur_co,8) to pld

	sele d
	use &mdis alias mdis
	sele g
	use &dis alias dis

	sele c
	set filt to est_inv_fl = 'E'
	go top
	do while !eof()
		l1 = alltrim(str(c.sys_pur_co))
		l2 = len(l1)
		l3 = replicate('0',6-l2)+l1

		last1 = c.sys_pur_co
		sele d
		appe blank
		repl type with 'D'
		repl misc3 with substr(misc3,1,53)+iif(c.inv_type_f='T','T','R')+substr(misc3,55,100)
		repl challan with l3
		repl pm with c.pur_inv_no
		repl chdate with iif(empty(c.entry_dt),c.pur_dt,c.entry_dt)
		repl lrda with c.pur_dt
		repl codep with allt(str(c.party_code))
		repl voucher with last4
		last4=last4+5
		repl amountp with (c.pur_bill_a)
		repl salun with ''
		repl staxun with 'SZTZOZ'
		repl other with c.tpt_chrg + c.other_chrg
		if (c.cash_credi = 'C')
			repl cash with round(c.pur_bill_a,0)
			repl round with c.pur_bill_a-round(c.pur_bill_a,0)
		else
			repl final with round(c.pur_bill_a,0)
			repl round with c.pur_bill_a-round(c.pur_bill_a,0)
		endif
		if final=0 and cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with pcalc
		repl discafter with 'N'
		=seek(substr(allt(str(c.party_code))+space(6),1,6),'ord')
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
			isigst=1
		endi
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele h
		seek str(c.sys_pur_co,8)
		do while  str(c.sys_pur_co,8) = str(h.sys_pur_co,8) and !eof()
			last=substr(allt(str(h.item_code))+space(10),1,10)
			sele f
			seek str(h.item_code,9) + h.batch_no
			sele e
			seek last
			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.challan
			repl date with d.chdate
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with iif(e.pack#0,e.pack*h.pur_qty,h.pur_qty)
			repl free with h.free_qty
			repl pack with e.pack
			repl exp with iif(h.exp_dt=ctod('01/01/1900'),ctod('  /  /    '),h.exp_dt)
			repl batch with iif(f.est_inv_fl='E',old_8+allt(h.batch_no),allt(h.batch_no))
			repl flg with 'D'    &&iif(c.sale_ret_f='Y','R','P')
			repl rate with h.item_pur_r
			repl disc1 with h.pur_disc_i
			=seek(h.tax_code,'ftax')
			if isigst=0
				repl ssta with ftax.local_tax
				repl cgst with ftax.central_ta
			else
				repl ssta with ftax.igst_tax
			endif
			repl ssex with 0
			repl mrp with h.item_mrp_r
			repl half with 'A'
			repl godwon with d.godwon
			if old_7='Y'
				if at('+',h.pdeal_valu)>0
					dq=val(substr(h.pdeal_valu,1,at('+',h.pdeal_valu)-1))
					df=val(substr(h.pdeal_valu,at('+',h.pdeal_valu)+1))
					repl deal with dq/iif(e.pack#0,e.pack,1)
					repl freedeal with df
					repl rsm with h.pdeal_valu
				endif
			endif
			sele h
			skip
		enddo
		sele c
		skip
	enddo
	close data


	@rowno,10 say '**** Importing Purchase Return****' font 'Arial',10
	rowno=rowno+1
	last4 = last4 + 20
	sele sele (1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele sele (1)
	use &datatransferpath\tax_master.dbf alias ftax
	index on tax_code to ftax
	sele sele(1)
	use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
	index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
	sele f
	use &prb alias prb
	index on str(item_code,9) + batch_no to prb
	sele e
	use &pro alias pro
	index on name to pro
	sele c
	use &pgr alias pgr
	index on str(sys_pur_re,8) to pgr
	sele h
	use &pgl alias pgl
	index on str(sys_pur_re,8) to pgl
	sele d
	use &mdis alias mdis
	sele g
	use &dis alias dis
	sele c
	set filt to est_inv_fl = 'I'

	go top
	do while !eof()
		l1 = alltrim(str(c.sys_pur_re))
		l2 = len(l1)
		l3 = replicate('0',6-l2)+l1

		last1 = c.sys_pur_re
		sele d
		appe blank
		repl type with 'B'
		repl misc3 with substr(misc3,1,53)+iif(c.inv_type_f='T','T','R')+substr(misc3,55,100)
		repl vcn with l3
		repl pm with c.pur_inv_no
		repl date with iif(empty(c.entry_dt),c.pur_dt,c.entry_dt)
		repl lrda with c.pur_dt
		repl codep with allt(str(c.party_code))
		repl voucher with last4
		last4=last4+5
		repl amountp with (c.pur_bill_a)
		repl salun with ''
		repl staxun with 'SZTZOZ'
		repl other with c.other_plus
		if (c.cash_credi = 'C')
			repl cash with round(c.pur_bill_a,0)
			repl round with c.pur_bill_a-round(c.pur_bill_a,0)
		else
			repl final with round(c.pur_bill_a,0)
			repl round with c.pur_bill_a-round(c.pur_bill_a,0)
		endif
		if final=0 and cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with pcalc
		repl discafter with 'N'
		=seek(substr(allt(str(c.party_code))+space(6),1,6),'ord')
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
			isigst=1
		endi
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

		sele h
		seek str(c.sys_pur_re,8)
		do while  str(c.sys_pur_re,8) = str(h.sys_pur_re,8) and !eof()
			last=substr(allt(str(h.item_code))+space(10),1,10)
			sele f
			seek str(h.item_code,9) + h.batch_no

			sele e
			seek last

			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with iif(e.pack#0,e.pack*h.ret_qty,h.ret_qty)
			repl free with h.free_qty
			repl pack with e.pack
			repl exp with iif(h.exp_dt=ctod('01/01/1900'),ctod('  /  /    '),h.exp_dt)
			repl batch with iif(f.est_inv_fl='E',old_8+allt(h.batch_no),allt(h.batch_no))
			repl flg with 'B'    &&iif(c.sale_ret_f='Y','R','P')
			repl rate with h.item_pur_r
			repl disc1 with h.pur_disc01
			=seek(h.tax_code,'ftax')
			if isigst=0
				repl ssta with ftax.local_tax
				repl cgst with ftax.central_ta
			else
				repl ssta with ftax.igst_tax
			endif
			repl ssex with 0
			repl mrp with h.item_mrp_r
			repl half with 'A'
			repl godwon with d.godwon
			sele h
			skip
		enddo
		sele c
		skip
	enddo
	close data
	@rowno,10 say '**** Importing Sale Bills****' font 'Arial',10
	rowno=rowno+1
	sele sele (1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele sele (1)
	use &datatransferpath\tax_master.dbf alias ftax
	index on tax_code to ftax
	sele sele(1)
	use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
	index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
	last4 = last4 + 20
	sele f
	use &prb alias prb
	index on str(item_code,9) + batch_no to prb
	sele e
	use &pro alias pro
	index on name to pro

	sele c
	use &sal alias sal
	index on str(sys_sale_c,8) to sal

	sele h
	use &sld alias sld
	index on str(sys_sale_c,8) + est_inv_fl to sld
	sele d
	use &mdis alias mdis
	*zap
	sele g
	use &dis alias dis
	*zap
	sele sele(1)
	use &datatransferpath\party_master alias prt
	index on party_code to prt
	sele c
	set filt to c.sale_inv_a#0
	go top
	do while !eof()
		=seek(party_code,'prt')
		l1 = alltrim(c.sale_inv_n)
		l2 = len(l1)
		l3 = replicate('0',6-l2) + l1
		sele d
		appe blank
		repl type with 'S'
		repl misc3 with substr(misc3,1,53)+iif(!empty(c.party_gstn),'T','R')+substr(misc3,55,100)
		repl vcn with l3
		repl date with c.sale_dt
		repl codep with allt(str(c.party_code))
		repl voucher with last4
		last4=last4+5
		repl amountp with round(c.sale_inv_a,0)
		repl salun with ''
		repl staxun with 'SZTZOZ'
		*        repl other with c.other_add_-c.other_less
		if (c.cash_credi = 'C')
			repl cash with round(c.sale_inv_a,0)
			repl round with 0
		else
			repl final with round(c.sale_inv_a,0)
			repl round with 0
		endif
		if final=0 and cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl lrda with c.sale_dt
		repl account with 'N'
		*if isretail='Y' and 'CASH'$prt.party_name
		if c.rsale_flg='R'
			repl sale with 'zYNYNG YLN1N'
			repl ltype with rscalc
		else
			repl sale with 'ZYNYNG YLN1N'
			repl ltype with scalc
		endif
		if isretail='Y'
			repl docu with c.cash_pname
			repl docu1 with c.ref_name
		endif
		repl godwon with 'A'
		repl discafter with 'N'
		=seek(substr(allt(str(c.party_code))+space(6),1,6),'ord')
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
			isigst=1
		endi
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele h
		seek str(c.sys_sale_c,8) + 'I'
		do while  str(c.sys_sale_c,8) = str(h.sys_sale_c,8) and h.est_inv_fl = 'I' and !eof()
			last=substr(allt(str(item_code))+space(10),1,10)
			sele f
			seek str(h.item_code,9) + h.batch_no
			sele e
			seek last
			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with h.sale_qty &&iif(e.pack#0,e.pack*h.sale_qty,h.sale_qty)
			repl free with h.free_qty
			repl pack with e.pack
			repl exp with iif(h.exp_dt=ctod('01/01/1900'),ctod('  /  /    '),h.exp_dt)
			repl batch with iif(f.est_inv_fl='E',old_8+allt(h.batch_no),allt(h.batch_no))
			repl flg with 'G'
			if h.flat_rate=0
				repl rate with h.item_sale_
				repl disc1 with h.sale_dis01
				=seek(h.tax_code,'ftax')
				if isigst=0
					repl ssta with ftax.local_tax
					repl cgst with ftax.central_ta
				else
					repl ssta with ftax.igst_tax
				endif
				repl ssex with 0
				repl mrp with h.item_mrp_r
				if old_7='Y'
					if at('+',h.deal_value)>0
						dq=val(substr(h.deal_value,1,at('+',h.deal_value)-1))
						df=val(substr(h.deal_value,at('+',h.deal_value)+1))
						repl deal with dq/iif(e.pack#0,e.pack,1)
						repl freedeal with df
						repl rsm with h.deal_value
					endif
				endif
			else
				repl rate with round(((h.flat_rate*100)/(100+h.local_tax+h.central_ta)),2)
				=seek(h.tax_code,'ftax')
				if isigst=0
					repl ssta with ftax.local_tax
					repl cgst with ftax.central_ta
				else
					repl ssta with ftax.igst_tax
				endif
				repl misc4 with substr(misc4,1,13)+'N'+substr(misc4,15,100)
				repl mrp with h.item_mrp_r
			endif
			repl half with 'A'
			repl godwon with d.godwon
			sele h
			skip
		enddo
		sele c
		skip
	enddo
	close data
	@rowno,10 say '**** Importing Sale Estimate****' font 'Arial',10
	sele sele (1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele sele (1)
	use &datatransferpath\tax_master.dbf alias ftax
	index on tax_code to ftax
	rowno=rowno+1
	last4 = last4 + 20
	sele sele(1)
	use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
	index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
	sele f
	use &prb alias prb
	index on str(item_code,9) + batch_no to prb
	sele e
	use &pro alias pro
	index on name to pro
	sele c
	use &sal alias sal
	index on str(sys_sale_c,8) to sal
	sele h
	use &sld alias sld
	index on str(sys_sale_c,8) + est_inv_fl to sld
	sele d
	use &mdis alias mdis
	sele g
	use &dis alias dis
	sele c
	set filt to c.sale_est_a#0
	go top
	do while !eof()
		l1 = alltrim(c.sale_est_n)
		l2 = len(l1)
		l3 = replicate('0',6-l2) + l1
		sele d
		appe blank
		repl type with 'L'
		repl misc3 with substr(misc3,1,53)+iif(!empty(c.party_gstn),'T','R')+substr(misc3,55,100)
		repl vcn with l3
		repl date with c.sale_dt
		repl codep with allt(str(c.party_code))
		repl voucher with last4
		last4=last4+5
		repl amountp with round(c.sale_est_a,0)
		repl salun with ''
		repl staxun with 'SZTZOZ'
		repl other with c.other_add_-c.other_less
		if (c.cash_credi = 'C')
			repl cash with round(c.sale_est_a,0)
			repl round with 0
		else
			repl final with round(c.sale_est_a,0)
			repl round with 0
		endif
		if final=0 and cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl lrda with c.sale_dt
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with scalc
		repl discafter with 'N'
		if c.rsale_flg='R'
			repl sale with 'zYNYNG YLN1N'
			repl ltype with rscalc
		else
			repl sale with 'ZYNYNG YLN1N'
			repl ltype with scalc
		endif
		=seek(substr(allt(str(c.party_code))+space(6),1,6),'ord')
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
			isigst=1
		endi

		*!*	endif

		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele h
		seek str(c.sys_sale_c,8) + 'E'
		do while  str(c.sys_sale_c,8) = str(h.sys_sale_c,8) and h.est_inv_fl = 'E' and !eof()
			last=substr(allt(str(item_code))+space(10),1,10)
			sele f
			seek str(h.item_code,9) + h.batch_no
			sele e
			seek last
			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with h.sale_qty &&iif(e.pack#0,e.pack*h.sale_qty,h.sale_qty)
			repl free with h.free_qty
			repl pack with e.pack
			repl exp with iif(h.exp_dt=ctod('01/01/1900'),ctod('  /  /    '),h.exp_dt)
			repl batch with iif(f.est_inv_fl='E',old_8+allt(h.batch_no),allt(h.batch_no))
			repl flg with 'L'
			if h.flat_rate=0
				repl rate with h.item_sale_
				repl disc1 with h.sale_dis01 &&&&h.sale_disc_
				=seek(h.tax_code,'ftax')
				if isigst=0
					repl ssta with ftax.local_tax
					repl cgst with ftax.central_ta
				else
					repl ssta with ftax.igst_tax
				endif
				repl ssex with 0
				repl mrp with h.item_mrp_r
				if old_7='Y'
					if at('+',h.deal_value)>0
						dq=val(substr(h.deal_value,1,at('+',h.deal_value)-1))
						df=val(substr(h.deal_value,at('+',h.deal_value)+1))
						repl deal with dq/iif(e.pack#0,e.pack,1)
						repl freedeal with df
						repl rsm with h.deal_value
					endif
				endif
			else
				repl rate with round(((h.flat_rate*100)/(100+h.local_tax+h.central_ta)),2)
				=seek(h.tax_code,'ftax')
				if isigst=0
					repl ssta with ftax.local_tax
					repl cgst with ftax.central_ta
				else
					repl ssta with ftax.igst_tax
				endif
				repl misc4 with substr(misc4,1,13)+'N'+substr(misc4,15,100)
				repl mrp with h.item_mrp_r
			endif
			repl half with 'A'
			repl godwon with d.godwon
			sele h
			skip
		enddo
		sele c
		skip
	enddo
	close data
	@rowno,10 say '**** Importing Sale Return****' font 'Arial',10
	rowno=rowno+1
	last4 = last4 + 20
	sele sele (1)
	use &datdev\order.&datext alias ord
	index on ordno to ord
	sele sele (1)
	use &datatransferpath\tax_master.dbf alias ftax
	index on tax_code to ftax
	sele sele(1)
	use &datdev\support.&datext alias support &&&&inde &datdev\&datext.supp
	index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
	sele f
	use &prb alias prb
	index on str(item_code,9) + batch_no to prb
	sele e
	use &pro alias pro
	index on name to pro
	sele c
	use &sgr alias sgr
	index on str(sys_sale_r,8) to sgr
	sele h
	use &sgl alias sgl
	index on str(sys_sale_r,8) + est_inv_fl to sgl

	sele d
	use &mdis alias mdis
	sele g
	use &dis alias dis

	sele c
	set filt to c.ret_inv_am#0
	go top
	do while !eof()
		l1 = alltrim(c.ret_inv_no)
		l2 = len(l1)
		l3 = replicate('0',6-l2) + l1

		sele d
		appe blank
		repl type with 'R'
		repl misc3 with substr(misc3,1,53)+iif(!empty(c.party_gstn),'T','R')+substr(misc3,55,100)
		repl vcn with l3
		repl date with c.ret_dt
		repl codep with allt(str(c.party_code))
		repl voucher with last4
		last4=last4+5
		repl amountp with round(c.ret_inv_am,0)
		repl salun with ''
		repl staxun with 'SZTZOZ'
		repl other with c.other_add_-c.other_less
		if (c.cash_credi = 'C')
			repl cash with round(c.ret_inv_am,0)
			repl round with 0
		else
			repl final with round(c.ret_inv_am,0)
			repl round with 0
		endif
		if final=0 and cash#0
			repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
		else
			repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)
		endif
		repl duedays with 0
		repl lrda with c.ret_dt
		repl account with 'N'
		repl sale with 'Z'
		repl godwon with 'A'
		repl ltype with scalc
		repl discafter with 'N'
		=seek(substr(allt(str(c.party_code))+space(6),1,6),'ord')
		***Local Central***
		isigst=0
		if substr(ord->gstno,1,2)#mstatecode and len(alltrim(ord->gstno))>10
			repl mdis.misc3 with substr(mdis.misc3,1,64)+'C'+substr(mdis.misc3,66)
			isigst=1
		endi
		sele support
		appe blank
		repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
		sele h
		seek str(c.sys_sale_r,8) + 'I'
		do while  str(c.sys_sale_r,8) = str(h.sys_sale_r,8) and h.est_inv_fl = 'I' and !eof()

			last=substr(allt(str(item_code))+space(10),1,10)
			sele f
			seek str(h.item_code,9) + h.batch_no
			sele e
			seek last
			sele g
			appe blank
			repl codep with d.codep
			repl vcn with d.vcn
			repl date with d.date
			repl voucher with d.voucher
			repl code with e.code
			repl tax with 'T'
			repl qty with iif(e.pack#0,e.pack*h.ret_qty,h.ret_qty)
			repl free with h.free_qty
			repl pack with e.pack
			repl exp with iif(h.exp_dt=ctod('01/01/1900'),ctod('  /  /    '),h.exp_dt)
			repl batch with iif(f.est_inv_fl='E',old_8+allt(h.batch_no),allt(h.batch_no))
			repl flg with 'R'
			repl rate with h.item_sale_
			repl disc1 with h.ret_disc01
			=seek(h.tax_code,'ftax')
			if isigst=0
				repl ssta with ftax.local_tax
				repl cgst with ftax.central_ta
			else
				repl ssta with ftax.igst_tax
			endif
			repl ssex with 0
			repl mrp with h.item_mrp_r
			repl half with 'A'
			repl godwon with d.godwon
			sele h
			skip
		enddo
		sele c
		skip
	enddo
	close data
	@rowno,10 say '**** Importing Account From Sales****' font 'Arial',10
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
	do while !eof()
		if vcn=space(12)
			skip
			loop
		endif
		last1 = mdis.codep
		if mdis.final#0
			sele b
			appe blank
			repl voucher with mdis.voucher
			if d.type $ 'P'
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
			**** For Outstanding
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

	@rowno,10 say '**** Importing Account Trasaction****' font 'Arial',10
	rowno=rowno+1
	af      = datdev + '\gledger.'+datext
	bf      = datdev + '\slipno.'+datext
	cf      = datatransferpath + 'trans_detail.'+datatransferext
	pend    = datdev + '\pend.'+datext
	pending = datdev + '\pendings.'+datext
	sele g
	use &pending alias pending
	index on ord + substr(name,1,12) to rou2
	last4  = last4 + 10
	slast5 = slast5 + 10
	sele sele(1)
	use &datatransferpath\sale_master alia sal
	index on sale_inv_n to sal
	sele f
	use &pend alias pend
	sele b
	use &af alias gledger
	sele a
	use &cf alias led
	inde on str(trans_code,8) to led
	set filt to trans_type $ 'PAYMENT             ' or trans_type $ 'RECIEPT             '
	go top
	last3= '%%%%%%%$'
	do while !eof()

		if trans_type='RECIEPT' and sale_inv_n<>space(20)
			sele sal
			seek subs(a.sale_inv_n,1,16)
			if found() and sal.cash_credi='C'
				sele a
				skip
				loop
			endif
		endif
		sele a
		last3 = str(trans_code,8)
		sele b
		append blank
		repl voucher with last4
		if a.cr_amnt # 0
			repl cd with 'C'
			repl credit with abs(a.cr_amnt)
		else
			repl cd with 'D'
			repl debit with abs(a.dr_amnt)
		endif
		repl date with a.trans_dt
		repl code with allt(a.party_code)
		repl remark1 with a.narration

		if a.trans_type = 'RECIEPT             '
			repl book with 'R'
		else
			if a.trans_type = 'PAYMENT             '
				repl book with 'P'
			endif
		endif

		**Contra
		sele b
		append blank
		repl voucher with last4
		if a.cr_amnt # 0
			repl cd with 'D'
			repl debit with abs(a.cr_amnt)
		else
			repl cd with 'C'
			repl credit with abs(a.dr_amnt)
		endif
		repl date with a.trans_dt
		repl code with allt(a.ac_code)
		repl remark1 with a.narration

		if a.trans_type = 'RECIEPT             '
			repl book with 'R'
		else
			if a.trans_type = 'PAYMENT             '
				repl book with 'P'
			endif
		endif
		last4=last4+4
		sele a
		skip
	enddo
	close data
	bf=datdev + '\slipno.'+datext
	use &bf
	go top
	repl voucher with last4+20
	repl svoucher with slast5+20
	bf=datdev+ '\mdis.'+datext
	use &bf
	repl misc4 with ' '
	bf=datdev+ '\pendings.'+datext
	use &bf
	repl all vcn with '*'+vcn for invtype='O' and ddate<=old_5
	close data
	** Transfer CALCULATION FIELD OF MARG TRANSACTION FILE
	dis=datdev + '\dis.'+datext
	use &dis
	go top
	do while !eof()
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
proc rem_dupl
	sele sele(1)
	crea curs dbffile (filepath varchar(250),filname varchar(25),filsel n(1))
	defpath=alltrim(datatransferpath) &&GETDIR(sys(5)+sys(2003),'Select Path for Backup','Select Path',64)
	if empty(defpath)
		m.dbfpath=alltrim(datatransferpath) &&curdir()
		retu
	endif
	m.dbfpath=defpath
	tlen=adir(dmarr,defpath+'\*.DBF')
	sele dbffile
	zap
	for icount=1 to tlen
		if 'FOXUSER.'$dmarr(icount,1)
			loop
		endif
		if file(dbfpath+'\'+dmarr(icount,1))
			appe blan
			repl filepath with dbfpath,filname with dmarr(icount,1),filsel with 1
		endif
	next
	go top

	tmptabl=sys(2023)+'\'+sys(3)+'.DBF'
	do whil file(tmptabl)
		tmptabl=sys(2023)+'\'+sys(3)+'.DBF'
	enddo
	=strtofil('DD',tmptabl)
	tmpfil=sys(2023)+'\'+sys(3)+'.TMP'
	do whil file(tmpfil)
		tmpfil=sys(2023)+'\'+sys(3)+'.TMP'
	enddo
	=strtofil('DD',tmpfil)
	*----------------------------------------*
	scntabl=sys(2023)+'\'+sys(3)+'.DBF'
	do whil file(scntabl)
		scntabl=sys(2023)+'\'+sys(3)+'.DBF'
	enddo
	=strtofil('DD',scntabl)
	scnfil=sys(2023)+'\'+sys(3)+'.TMP'
	do whil file(scnfil)
		scnfil=sys(2023)+'\'+sys(3)+'.TMP'
	enddo
	=strtofil('DD',scnfil)
	eras "&tmptabl"
	eras "&tmpfil"
	eras "&scntabl"
	eras "&scnfil"
	*----------------------------------------*
	if used('MYTEMP')
		use in mytemp
	endif
	sele sele(1)
	**crea curs MyTemp (field_name c(10),field_type c(1),field_len n(3),field_dec n(3))
	crea curs mytemp (field_name c(10),;
		field_type c(1),;
		field_len n(3),;
		field_dec n(3),;
		field_null l,;
		field_nocp l,;
		field_defa m,;
		field_rule m,;
		field_err m,;
		table_rule m,;
		table_err m,;
		table_name c(128),;
		ins_trig m,;
		upd_trig m,;
		del_trig m,;
		table_cmt m,;
		field_next i,;
		field_step i)

	sele dbffile
	coun to tot for filsel=1
	if tot=0
		=messagebox('No file(s) selected for conversion.',64,'Marg')
		retu
	endif
	*set notif off
	m.errno=0
	**on error m.errno=error()
	totfiles=0
	if file('MYCMD.TXT')
		eras &mycmd.txt
	endif
	scan for filsel=1
		m.errno=0
		filnm=addbs(rtri(dbfpath))+filname
		filsc=justpath(filnm)+juststem(filnm)+"_2nd."+justext(filnm)
		if at(' ',filnm)>0
			filnm='"'+filnm+'"'
		endif
		if at(' ',filsc)>0
			filsc='"'+filsc+'"'
		endif
		try
			sele sele(1)
			use &filnm
		catch to oexp
			m.errno=oexp.errorno
		endtry
		if m.errno=0
			use
			loop
		endif
		fp=fopen(filnm)
		if fp<0
			=messagebox('Error opening File :'+chr(13)+dbffile->filname+chr(13)+'Please check whether utility is already running.',64,'Marg')
			loop
		endif
		wait wind 'Processing '+dbffile->filname+chr(13)+'Please wait.....' at 2,2 nowa
		=fseek(fp,0,0)
		filtyp=fread(fp,1)
		lstdat=fread(fp,3)
		norecs=fread(fp,4)
		frstrec=fread(fp,2)
		reclength=fread(fp,2)
		reserve=fread(fp,16)
		table_flag=fread(fp,1)
		code_page=fread(fp,1)
		hdr_end=fread(fp,2)
		frstrec=asc(left(frstrec,1))+256*asc(subs(frstrec,2,1))
		** noflds=(frstrec-296)/32
		noflds=(frstrec-32)/32
		norecs=asc(left(norecs,1))+256*asc(subs(norecs,2,1))+65536*asc(subs(norecs,3,1))+16777216*asc(subs(norecs,4,1))
		**cmd='CREATE CURS TMP ('
		reco_len=asc(left(reclength,1))+asc(subs(reclength,2,1))*256
		if noflds>250
			acflds=250
			dime fldarray(250,4)
		else
			acflds=noflds
			dime fldarray(noflds,4)
		endif
		for dvfp_i=1 to acflds
			fname=padr(fread(fp,10),10)
			resv=fread(fp,1)
			fltyp=fread(fp,1)
			resv=fread(fp,4)
			flen=asc(fread(fp,1))
			fdeci=asc(fread(fp,1))
			resv2=fread(fp,14)
			fldarray(dvfp_i,1)=fltyp
			fldarray(dvfp_i,2)=flen
			fldarray(dvfp_i,3)=fdeci
			newfldnm=''
			for dvfp_j=1 to 10
				_chr=subs(fname,dvfp_j,1)
				if isalpha(_chr) or isdigit(_chr) or _chr='_'
					newfldnm=newfldnm+_chr
				else
					*exit
				endif
			next
			fldarray(dvfp_i,4)=newfldnm  && allt(chrtran(fname,chr(0),''))
			**=STRTOFILE(fname+' '+fldarray(dvfp_i,4)+CHR(13)+CHR(10),'MYCMD.txt',1)
		next
		duplfnd=.f.
		newnum=1
		for dvfp_i=1 to acflds-1
			for dvfp_j=dvfp_i+1 to acflds
				dvfp_f1=allt(fldarray(dvfp_i,4))
				dvfp_f2=allt(fldarray(dvfp_j,4))
				if dvfp_f1=dvfp_f2
					duplfnd=.t.
					if newnum<100
						nnm=left(dvfp_f2,8)+subs(str(100+newnum,3),2)
					else
						nnm=left(dvfp_f2,7)+subs(str(1000+newnum,4),2)
					endif
					fldarray(dvfp_j,4)=nnm
					newnum=newnum+1
				endif
			next
		next
		if !duplfnd
			=fclos(fp)
			wait clea
			loop
		endif
		dvfp_len=1
		for dvfp_i=1 to acflds
			*if dvfp_i>250
			*   exit
			*endif
			flen=fldarray(dvfp_i,2)
			fdeci=fldarray(dvfp_i,3)
			**cmd=cmd+fldarray(dvfp_i,4)+' '+allt(fldarray(dvfp_i,1))+'('+ltri(str(flen,3))+;
			**    iif(fdeci>0,','+ltri(str(fdeci,3)),'')+'),'
			dvfp_len=dvfp_len+flen
			sele mytemp
			appe blan
			repl field_name with fldarray(dvfp_i,4),field_type with fldarray(dvfp_i,1),;
				field_len with flen,field_dec with fdeci
		next
		if used('TMP')
			sele tmp
			use
		endif
		mt_250=.f.
		sele mytemp
		if recc()<251
			copy to "&tmptabl"
			if file("&tmpfil")
				eras "&tmpfil"
			endif
			sele sele(1)
			use "&tmptabl"
			use
			sele sele(1)
			crea "&tmpfil" from "&tmptabl"
			use
			use "&tmpfil" alias tmp
			eras "&tmptabl"
		else
			mt_250=.t.
			copy to "&tmptabl" for recn()<251
			if file("&tmpfil")
				eras "&tmpfil"
			endif
			sele sele(1)
			use "&tmptabl"
			use
			sele sele(1)
			crea "&tmpfil" from "&tmptabl"
			use
			use "&tmpfil" alias tmp
			eras "&tmptabl"
			sele mytemp
			copy to "&scntabl" for recn()>250
			if file("&scnfil")
				eras "&scnfil"
			endif
			sele sele(1)
			use "&scntabl"
			use
			sele sele(1)
			crea "&scnfil" from "&scntabl"
			use
			use "&scnfil" alias tmp2
			eras "&scntabl"
		endif
		sele mytemp
		zap

		=fseek(fp,frstrec,0)
		for i=1 to norecs
			delmrk=fread(fp,1)
			if mt_250
				sele tmp2
				appe blan
			endif
			sele tmp
			appe blan
			for j=1 to noflds
				if j>250
					=fread(fp,reco_len-dvfp_len)
					*for _k=j to noflds
					*fldval=fread(fp,fldarray(_k,2))
					*if len(fldval)<fldarray(j,2)
					*   i=norecs+1
					*   exit
					*endif
					*if fldarray(j,1)$'INFBY'
					*   fldval=val(fldval)
					*endif
					*if fldarray(j,1)='D'
					*   fldval=ctod('^'+left(fldval,4)+'/'+subs(fldval,5,2)+'/'+subs(fldval,7))
					*endif
					*if fldarray(j,1)='L'
					*   if vartype(fldval)='C'
					*      if fldval$'Yy1'
					*         fldval=.T.
					*      else
					*         fldval=.F.
					*      endif
					*   else
					*      if vartype(fldval)$'INF'
					*         if fldval=1
					*            fldval=.T.
					*         else
					*            fldval=.F.
					*         endif
					*      else
					*         fldval=.F.
					*      endif
					*   endif
					*endif
					*Sele TMP2
					*fnam=field(_k-250)
					*repl &fnam with fldval in TMP2
					*next
					*if delmrk='*'
					*   dele in TMP2
					*endif
					exit
				endif
				fldval=fread(fp,fldarray(j,2))
				if len(fldval)<fldarray(j,2)
					i=norecs+1
					exit
				endif
				if fldarray(j,1)$'INFBY'
					fldval=val(fldval)
				endif
				if fldarray(j,1)='D'
					fldval=ctod('^'+left(fldval,4)+'/'+subs(fldval,5,2)+'/'+subs(fldval,7))
				endif
				if fldarray(j,1)='L'
					if vartype(fldval)='C'
						if fldval$'Yy1'
							fldval=.t.
						else
							fldval=.f.
						endif
					else
						if vartype(fldval)$'INF'
							if fldval=1
								fldval=.t.
							else
								fldval=.f.
							endif
						else
							fldval=.f.
						endif
					endif
				endif
				sele tmp
				fnam=field(j)
				repl &fnam with fldval in tmp
			next
			if delmrk='*'
				dele in tmp
			endif
		next
		=fclos(fp)
		wait clea
		sele tmp
		copy to &filnm
		use
		eras "&tmpfil"
		if mt_250
			sele tmp2
			copy to &filsc
			use
			eras "&scnfil"
		endif
		wait wind 'File converted successfully !'+chr(13)+dbffile->filname at 2,2 time 2
		totfiles=totfiles+1
	endscan
	on error
	if totfiles>0
		=messagebox('Total '+ltri(str(totfiles,5))+' file(s) converted',48,'Marg')
	else
		=messagebox('No files found with duplicate fields.',64,'Marg')
	endif
	sele mytemp
	use
