if type('FINALCP')='U'
	if type('FINALCP')#'U'
		datatransferpath=datdev
		datatransferext=datext
		@ 04,1  get datatransferpath
		@ 05,1  get datatransferext
		read
		=starttransfer()
	endif
endif
rest screen from simple
	do while .t.
		rest screen from simple
		colofhed="Masters Import Utility "
		mychoice=1
		=colofil(1,2,14,30,10)
		mgpt_1 ="2         4         \<A) Item Master          "
		mgpt_2 ="3         4         \<B) Batch Master         "
		mgpt_3 ="4         4         \<C) Party Master         "
		mgpt_4 ="5         4         \<D) Patient Master       "
		mgpt_5 ="6         4         \<E) Doctor Master        "
		mgpt_6 ="7         4         \<F) Supermarket Customer "
		mgpt_7 ="8         4         \<G) Company Master       "
		mgpt_8 ="9         4         \<H) Salt Master          "
		mgpt_9 ="10        4         \<I) Category Master      "
		mgpt_10="11        4         \<J) Area Master          "
		mgpt_11="12        4         \<K) Rout Master          "
		mgpt_12="13        4         \<L) Exit                 "

		mychoice=mgptmen(12,mychoice)
		if mychoice=0 or mychoice=12 or lastkey()=27
			exit
		endif
	do case
		case mychoice=1
			do item_trf
		case mychoice=2
			do batch_trf
		case mychoice=3
			do ledger_trf
		case mychoice=4
			do patient_import
		case mychoice=5
			do doctor_import
		case mychoice=6
			do retail_customer
		case mychoice=7
			do company_import
		case mychoice=8
			do salt_import
		case mychoice=9
			do category_import
		case mychoice=10
			do area_master_import
		case mychoice=11
			do rout_import
	endcase
enddo





proc item_trf
	tradetype='PHARMA/FMCG,AUTOMOBILE '
	mimp='No '
	store space(2) to wpcode,wpname,wbillname,wpacking,wrack,wconv,wcase,wunit1,wunit2,wbcode,wcomp,;
		wsalt,wcat,whsn,wsgst,wcgst,wigst,wcess,wmrp,wratea,wrateb,wratec,wprate,wcost,wdisc1,wdisc2,;
		wmfg,wdeal,wfree,wmin,wmax,wstock,wprintname
	store 1 to mchoice
	store 0 to mexcel
	mtrade='PHARMA/FMCG '
	old_datadelete='No '
	pcode='  '
	mfile=''
	colofhed="ITEM IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'ITEM MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1    say 'Excel File   :'+mfile
	@  4,1    say 'TRADE        : ' get mtrade     pict '@^ PHARMA/FMCG,AUTOMOBILE  '  size 1,15   font 'cambria',12&&& validate vtrade()
	@  5,1    say 'PRODUCT CODE : ' get wpcode     pict '@!'
	@  5,25   say 'PRODUCT NAME : ' get wpname     pict '@!'
	@  5,50   say 'BILL NAME    : ' get wbillname  pict '@!'
	@  6,1    say 'PACKING      : ' get wpacking   pict '@!'
	@  6,25   say 'RACK NO.     : ' get wrack      pict '@!'
	@  6,50   say 'CONVERSION   : ' get wconv      pict '@!'
	@  7,1    say 'CASE CONV.   : ' get wcase      pict '@!'
	@  7,25   say 'UNIT-1       : ' get wunit1     pict '@!'
	@  7,50   say 'UNIT-2       : ' get wunit2     pict '@!'
	@  8,1    say 'BARCODE      : ' get wbcode     pict '@!'
	@  8,25   say 'COMPANY      : ' get wcomp      pict '@!'
	@  8,50   say 'SALT         : ' get wsalt      pict '@!'
	@  9,1    say 'CATEGORY     : ' get wcat       pict '@!'
	@  9,25   say 'HSN CODE     : ' get whsn       pict '@!'
	@  9,50   say 'SGST         : ' get wsgst      pict '@!'
	@  10,1   say 'CGST         : ' get wcgst      pict '@!'
	@  10,25  say 'IGST         : ' get wigst      pict '@!'
	@  10,50  say 'CESS         : ' get wcess      pict '@!'
	@  11,1   say 'MRP          : ' get wmrp       pict '@!'
	@  11,25  say 'RATE A       : ' get wratea     pict '@!'
	@  11,50  say 'RATE B       : ' get wrateb     pict '@!'
	@  12,1   say 'RATE C       : ' get wratec     pict '@!'
	@  12,25  say 'PURC. RATE   : ' get wprate     pict '@!'
	@  12,50  say 'COST         : ' get wcost      pict '@!'
	@  13,1   say 'DISC-1       : ' get wdisc1     pict '@!'
	@  13,25  say 'DISC-2       : ' get wdisc2     pict '@!'
	@  13,50  say 'MFG.NAME     : ' get wmfg       pict '@!'
	@  14,1   say 'DEAL         : ' get wdeal      pict '@!'
	@  14,25  say 'FREE         : ' get wfree      pict '@!'
	@  14,50  say 'MIN. QTY     : ' get wmin       pict '@!'
	@  15,1   say 'MAX. QTY     : ' get wmax       pict '@!'
	@  15,25  say 'STOCK        : ' get wstock     pict '@!'
	@  15,50  say 'PRINT NAME   : ' get wprintname pict '@!'
	@  17,1   say 'DELETE OLD DATA :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  19,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\pro.&datext alia pro excl
	sele pro
	if old_datadelete ='Y'
		DELE ALL
	endif
*!*		sele sele(1)
*!*		use &datdev\saletype.&datext alia saletype excl
	sele saletype
	if old_datadelete ='Y'
		dele all for inlist(sgcode,'ZZZZZZ','SALT  ','CATEGO','COMMCD')
	endif
	index on sgcode+sname+str(igst,5,2) to saletype
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele pro
			append blank
			repl code with recno()
			if !empty(wpcode)
				repl name with mconvert(ls.range(allt(wpcode)+allt(padr(rowno,6))).value)
			else
				repl name with padl(recno(),7,'0')
			endif
			if mtrade#'AUTOMOBILE'
				if  !empty(wpname)
					repl product with mconvert(ls.range(allt(wpname)+allt(padr(rowno,6))).value)
				endif
			else
				if  !empty(wpcode)
					repl product with mconvert(ls.range(allt(wpcode)+allt(padr(rowno,6))).value)
				endif
			endif
			if !empty(wpacking)
				repl packing with mconvert(ls.range(allt(wpacking)+allt(padr(rowno,6))).value)
			endif
			if mtrade#'AUTOMOBILE'
				if !empty(wbillname)
					repl billname with mconvert(ls.range(allt(wbillname)+allt(padr(rowno,6))).value)
					repl billname with product+packing
				endif
			else
				if !empty(wbillname)
					repl billname with mconvert(ls.range(allt(wbillname)+allt(padr(rowno,6))).value)
				endif
			endif
			if !empty(wrack)
				if empty(wbcode)
					repl rackno with mconvert(ls.range(allt(wrack)+allt(padr(rowno,6))).value)
				else
					repl rackno2 with mconvert(ls.range(allt(wrack)+allt(padr(rowno,6))).value)
				endif
			endif
			if !empty(wbcode )
				repl rackno with mconvert(ls.range(allt(wbcode)+allt(padr(rowno,6))).value)
			endif
			if !empty(wconv)
				repl pack with val(mconvert(ls.range(allt(wconv)+allt(padr(rowno,6))).value))
			endif
			if !empty(wcase)
				repl onqtyfree with val(mconvert(ls.range(allt(wcase)+allt(padr(rowno,6))).value))
			endif
			if !empty(wunit1)
				repl unit with mconvert(ls.range(allt(wunit1)+allt(padr(rowno,6))).value)
			endif
			if !empty(wunit2)
				repl unit2 with mconvert(ls.range(allt(wunit2)+allt(padr(rowno,6))).value)
			endif
			if !empty(wsgst)
				repl saltax with val(mconvert(ls.range(allt(wsgst)+allt(padr(rowno,6))).value))
			endif
			if !empty(wcgst )
				repl cgst with val(mconvert(ls.range(allt(wcgst )+allt(padr(rowno,6))).value))
			endif
			if !empty(wigst)
				repl igst with val(mconvert(ls.range(allt(wigst)+allt(padr(rowno,6))).value))
			endif
			if !empty(wcess )
				repl salsc with val(mconvert(ls.range(allt(wcess)+allt(padr(rowno,6))).value))
			endif
			if !empty(wmrp )
				repl mrp with val(mconvert(ls.range(allt(wmrp)+allt(padr(rowno,6))).value))
			endif
			if !empty(wmrp )
				repl mrp with val(mconvert(ls.range(allt(wmrp)+allt(padr(rowno,6))).value))
			endif
			if !empty(wratea )
				repl ratea with val(mconvert(ls.range(allt(wratea)+allt(padr(rowno,6))).value))
			endif
			if !empty(wrateb )
				repl rateb with val(mconvert(ls.range(allt(wrateb)+allt(padr(rowno,6))).value))
			endif
			if !empty(wratec )
				repl ratec with val(mconvert(ls.range(allt(wratec)+allt(padr(rowno,6))).value))
			endif
			if !empty(wprate)
				repl prate with val(mconvert(ls.range(allt(wprate)+allt(padr(rowno,6))).value))
			endif
			if !empty(wcost )
				repl lprate with val(mconvert(ls.range(allt(wcost)+allt(padr(rowno,6))).value))
			endif
			if !empty(wdisc1)
				repl fixdis with val(mconvert(ls.range(allt(wdisc1)+allt(padr(rowno,6))).value))
			endif
			if !empty(wdisc2)
				repl fixdis1 with val(mconvert(ls.range(allt(wdisc2)+allt(padr(rowno,6))).value))
			endif
			if !empty(wmfg)
				repl formulano with mconvert(ls.range(allt(wmfg)+allt(padr(rowno,6))).value)
			endif
			if !empty(wdeal)
				repl deal with val(mconvert(ls.range(allt(wdeal)+allt(padr(rowno,6))).value))
			endif
			if !empty(wfree)
				repl free with val(mconvert(ls.range(allt(wfree)+allt(padr(rowno,6))).value))
			endif
			if !empty(wmin)
				repl minimum with val(mconvert(ls.range(allt(wmin)+allt(padr(rowno,6))).value))
			endif
			if !empty(wmax)
				repl maximum with val(mconvert(ls.range(allt(wmax)+allt(padr(rowno,6))).value))
			endif
			if !empty(wstock)
				repl opening with val(mconvert(ls.range(allt(wstock)+allt(padr(rowno,6))).value))
				repl o_a with opening
				repl balance with opening
				repl b_a with opening
			endif
			if !empty(wprintname)
				repl BookName with mconvert(ls.range(allt(wprintname)+allt(padr(rowno,6))).value)
			endif
			if !empty(wsgst )
				repl gcode6 with mconvert(ls.range(allt(wsgst)+allt(padr(rowno,6))).value)
			endif
			repl taxl with 'T'
			repl taxc with 'T'
			repl decimal with 'Y'
			repl halfsche with 'A'
			repl qtrsche with 'Y'
			repl status with 'Y'
			if (saltax=0 or cgst=0) and igst#0
				repl saltax with igst/2
				repl cgst with saltax
			else
				if igst=0 and (saltax#0 or cgst#0)
					repl igst with saltax+cgst
				endif
			endif
			*** HSN/COMPANY/CATEGORY/SALT
			if !empty(whsn)   &&  HSN
				mhsn=mconvert(ls.range(allt(whsn)+allt(padr(rowno,6))).value)
				sele saletype
				seek 'COMMCD' + substr(mhsn+space(40),1,40)+str(pro.igst,5,2)
				if !found()
					append blank
					repl sgcode with 'COMMCD'
					repl scode  with 'H'+alltrim(str(recno()))
					repl sname  with mhsn
					repl parnam with mhsn
					repl tax with pro.saltax
					repl cgst with pro.cgst
					repl igst with pro.igst
				endif
				repl pro.gcode6 with saletype.scode
			endif
			if !empty(wsalt )   && SALT
				msalt= mconvert(ls.range(allt(wsalt)+allt(padr(rowno,6))).value)
				sele saletype
				seek 'SALT  ' + substr(msalt+space(40),1,40)
				if !found()
					append blank
					repl sgcode with 'SALT  '
					repl scode  with 'S'+alltrim(str(recno()))
					repl sname  with subs(msalt,1,40)
					repl tname with subs(msalt,41,40)
					repl parnam with msalt
				endif
				repl pro.gcode3 with saletype.scode
			endif

			if !empty(wcat)   &&&&    CATEGORY
				mcategory=mconvert(ls.range(allt(wcat)+allt(padr(rowno,6))).value)
				sele saletype
				seek 'CATEGO' + substr(mcategory+space(40),1,40)
				if !found()
					append blank
					repl sgcode with 'CATEGO'
					repl scode  with 'C'+alltrim(str(recno()))
					repl sname  with subs(mcategory,1,40)
					repl parnam with mcategory
				endif
				repl pro.gcode5 with saletype.scode
			endif
			if !empty(wcomp)   &&&&  COMPANY
				mcompany=mconvert(ls.range(allt(wcomp)+allt(padr(rowno,6))).value)
				sele saletype
				seek 'ZZZZZZ' + substr(mcompany+space(40),1,40)
				if !found()
					append blank
					repl sgcode with 'ZZZZZZ'
					repl scode  with 'Z'+alltrim(str(recno()))
					repl sname  with mcompany
					repl parnam with mcompany
				endif
				repl pro.gcode with saletype.scode
			endif

			rowno=rowno+1
			=plswproc("Please Wait......."+alltri(pro.product))
		endfor
	endfor
	sele saletype
	repl all sname with parnam+str(igst,5,2)+'%' for sgcode='COMMCD'
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('ITEM MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc



funct vtrade
	if mtrade='AUTOMOBILE'
		@  5,5 say 'Part Number  : ' get wpcode pict '@!'
	else
		@  5,5 say 'Product Code : ' get wpcode pict '@!'
	endif
endfunc






proc ledger_trf
	old_datadelete='No '
	store space(2) to mstate,mledgername,mstation,mmailto,maddress1,maddress2,maddress3,mcity,mpin,memail,mcontactperson,mphone1,;
		mphone2,mmobile,mfax,mgsthead,mgstno,mcstno,mcsthead,mstno,msthead,mdlno,mfoodlic,mpanno,mstate,mmr,marea,;
		mrout,mdisc1,mdisc2,mduedays,mcrlimit,macgroup,mopening
	store 1 to mchoice
	store 0 to mexcel
	pcode='  '
	colofhed="LEDGER IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'LEDGER MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1    say 'Excel File      :'+mfile
	@  5,1    say 'LEDGER CODE     : ' get mfax pict '@!'
	@  5,25   say 'LEDGER NAME     : ' get mledgername pict '@!'
	@  5,50   say 'STATION         : ' get mstation pict '@!'
	@  6,1    say 'MAIL TO         : ' get mmailto pict '@!'
	@  6,25   say 'ADDRESS-1       : ' get maddress1 pict '@!'
	@  6,50   say 'ADDRESS-2       : ' get maddress2 pict '@!'
	@  7,1    say 'ADDRESS-3       : ' get maddress3 pict '@!'
	@  7,25   say 'CITY            : ' get mcity pict '@!'
	@  7,50   say 'PIN             : ' get mpin pict '@!'
	@  8,1    say 'EMAIL ID        : ' get memail pict '@!'
	@  8,25   say 'CONTACT PERSON  : ' get mcontactperson pict '@!'
	@  8,50   say 'PHONE OFFICE    : ' get mphone1 pict '@!'
	@  9,1    say 'PHONE RES.      : ' get mphone2 pict '@!'
	@  9,25   say 'MOBILE NO       : ' get mmobile pict '@!'
	@  9,50   say 'GST HEADING     : ' get mgsthead pict '@!'
	@  10,1   say 'GST No.         : ' get mgstno pict '@!'
	@  10,25  say 'STATE NAME      : ' get mstate pict '@!'
	@  10,50  say 'CST HEADING     : ' get mcsthead pict '@!'
	@  11,1   say 'CST NO.         : ' get mcstno pict '@!'
	@  11,25  say 'ST HEADING      : ' get msthead pict '@!'
	@  11,50  say 'ST NO.          : ' get mstno pict '@!'
	@  12,1   say 'PAN NO.         : ' get mpanno pict '@!'
	@  12,25  say 'DL NO.          : ' get mdlno pict '@!'
	@  12,50  say 'FOOD LIC. NO.   : ' get mfoodlic pict '@!'
	@  13,1   say 'MR/SALES MAN    : ' get mmr pict '@!'
	@  13,25  say 'AREA NAME       : ' get marea pict '@!'
	@  13,50  say 'ROUT NAME       : ' get mrout pict '@!'
	@  14,1   say 'DISC-1          : ' get mdisc1 pict '@!'
	@  14,25  say 'DISC-2          : ' get mdisc2 pict '@!'
	@  14,50  say 'BALANCE         : ' get mopening pict '@!'
	@  15,1   say 'DUE DAYS        : ' get mduedays pict '@!'
	@  15,25  say 'CREDIT LIMIT    : ' get mcrlimit pict '@!'
	@  15,50  say 'ACC GROUP NAME  : ' get macgroup pict '@!'
	@  16,1   say 'DELETE OLD DATA :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  19,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\order.&datext alia order excl
	sele order
	if old_datadelete='Y'
		delete all
	endif
	sele sele(1)
	create curs salesman(mrcode c(6),mrname c(40))
	index on mrname to salesman
*!*		sele sele(1)
*!*		use &datdev\saletype.&datext alia saletype excl
	sele saletype
	if old_datadelete='Y'
		dele all for inlist(sgcode,'AREA  ','ROUT  ','STATION')
	endif
	index on sgcode+sname to saletype
*!*		sele sele(1)
*!*		use &datdev\support.&datext alia support
	sele support
	if old_datadelete='Y'
		dele all for inlist(aliase,'ORDER   ','FODDETAI','LBTDETAI')
	endif
	index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to suppport
	mcode=1
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele order
			append blank
			repl ordno with padr(recno(),6)
			repl price with 'A'
			repl rate with 'Y'
			repl status with 'Y'
			repl adhed with 'Discount'
			repl ref with 'MR.'


			if !empty(mfax)
				repl fax2 with mconvert(ls.range(allt(mfax)+allt(padr(rowno,6))).value)
			else
				repl fax2 with padl(recno(),6,'0')
			endif
			if  !empty(mledgername )
				repl parnam with mconvert(ls.range(allt(mledgername)+allt(padr(rowno,6))).value)
			endif
			if !empty(mmailto)
				repl mailnam with mconvert(ls.range(allt(mmailto)+allt(padr(rowno,6))).value)
			endif
			if !empty(mstation)
				repl city with mconvert(ls.range(allt(mstation)+allt(padr(rowno,6))).value)
			endif
			if !empty(maddress1)
				repl paradd with mconvert(ls.range(allt(maddress1)+allt(padr(rowno,6))).value)
			endif
			if !empty(maddress2)
				repl paradd1 with mconvert(ls.range(allt(maddress2)+allt(padr(rowno,6))).value)
			endif
			if !empty(maddress3)
				repl paradd2 with mconvert(ls.range(allt(maddress3)+allt(padr(rowno,6))).value)
			endif
			if !empty(mpin)
				repl dsm with mconvert(ls.range(allt(mpin)+allt(padr(rowno,6))).value)
			endif
			if !empty(mcontactperson)
				repl confir with mconvert(ls.range(allt(mcontactperson)+allt(padr(rowno,6))).value)
			endif
			if !empty(mphone1)
				repl phone1 with mconvert(ls.range(allt(mphone1)+allt(padr(rowno,6))).value)
			endif
			if !empty(mphone2)
				repl phone2 with mconvert(ls.range(allt(mphone2)+allt(padr(rowno,6))).value)
			endif
			if !empty(mmobile)
				repl phone4 with mconvert(ls.range(allt(mmobile)+allt(padr(rowno,6))).value)
			endif
			if !empty(mgsthead)
				repl gsthed with mconvert(ls.range(allt(mgsthead)+allt(padr(rowno,6))).value)
			else
				repl gsthed with 'GSTIN'
			endif
			if !empty(mgstno)
				repl gstno with mconvert(ls.range(allt(mgstno)+allt(padr(rowno,6))).value)
			endif
			if !empty(mcsthead)
				repl csthed with mconvert(ls.range(allt(mcsthead)+allt(padr(rowno,6))).value)
			endif
			if !empty(mcstno)
				repl cstno with mconvert(ls.range(allt(mcstno)+allt(padr(rowno,6))).value)
			endif
			if !empty(msthead)
				repl sthed with mconvert(ls.range(allt(msthead)+allt(padr(rowno,6))).value)
			endif
			if !empty(mstno)
				repl stno with mconvert(ls.range(allt(mstno)+allt(padr(rowno,6))).value)
			endif
			if !empty(mdlno)
				repl dlno with mconvert(ls.range(allt(mdlno)+allt(padr(rowno,6))).value)
			endif

			if !empty(mpanno)
				repl itno  with mconvert(ls.range(allt(mpanno)+allt(padr(rowno,6))).value)
			endif
			if !empty(mdisc1)
				repl disc1 with val(mconvert(ls.range(allt(mdisc1)+allt(padr(rowno,6))).value))
			endif
			Ldis2=0
			if !empty(mdisc2)
				Ldis2=val(mconvert(ls.range(allt(mdisc2)+allt(padr(rowno,6))).value))
			endif
			if !empty(mduedays)
				repl duedays with val(mconvert(ls.range(allt(mduedays)+allt(padr(rowno,6))).value))
			endif
			if !empty(mcrlimit)
				repl limit with  val(mconvert(ls.range(allt(mcrlimit)+allt(padr(rowno,6))).value))
			endif
			if !empty(mopening)
				repl opning with  val(mconvert(ls.range(allt(mopening)+allt(padr(rowno,6))).value))
				repl balance with opning
			endif
			if !empty(macgroup)
				mgroup= upper(mconvert(ls.range(allt(macgroup)+allt(padr(rowno,6))).value))
				mgrp=''
				do case
					case 'BRANCH'$mgroup or 'DIVISION'$mgroup
						mgrp='A '
					case 'CAPITAL'$mgroup and ('A/C'$mgroup or 'ACCOUNT'$mgroup)
						mgrp='B '
					case 'RESERVE'$mgroup and 'SURPLUS'$mgroup
						mgrp='B '
					case 'CURRENT ASSET'$mgroup
						mgrp='C '
					case 'FIXED'$mgroup and 'ASSET'$mgroup
						mgrp='E '
					case 'INVESTMENT'$mgroup
						mgrp='F   '
					case 'CURRENT LIABILIT'$mgroup
						mgrp='D '
					case ('DUTY'$mgroup or 'DUTIES'$mgroup) and 'TAXES'$mgroup
						mgrp='D '
					case 'SALES TAX'$mgroup and 'CENTRAL'$mgroup
						mgrp='D11'
					case 'SALES TAX'$mgroup and 'LOCAL'$mgroup
						mgrp='D12 '
					case 'PROVISIONS'$mgroup
						mgrp='D  '
					case 'LOAN' $mgroup and 'LIABILITY' $mgroup
						mgrp='G   '
					case 'MISC. EXPENSES' $mgroup and 'ASSET'$mgroup
						mgrp='H   '
					case 'PROFIT & LOSS A/C'$mgroup
						mgrp='I   '
					case 'REVENUE'$mgroup
						mgrp='J   '
					case 'SUNDRY CREDITOR'$mgroup
						mgrp='D31 '
					case 'SUPPLIER'$mgroup
						mgrp='D31 '
					case 'SUNDRY DEBTOR'$mgroup &&&or fdet.mastertype=7
						mgrp='C6 '
					case 'DEPOSITS'$mgroup
						mgrp='C3 '
					case 'INVESTMENT'$mgroup
						mgrp='F '
					case "BANK"$mgroup &&and 'ACCOU'$mGroup and !('ODD'$mGroup) and !('OCC'$mGroup)
						mgrp='C1   '
					case "CASH"$mgroup and ('IN'$mgroup or 'A/C'$mgroup or 'AC'$mgroup) and 'HAND'$mgroup
						mgrp='C2   '
						parentgrup='C '
					case "STOCK" $ mgroup and ('CURRENT'$mgroup or 'IN-HAND'$mgroup or 'IN HAND'$mgroup)
						wacctgroup='C5 '
						mgrp='C   '
						parentgrup='C '
					case "BANK OD A/C" $mgroup or "BANK OCC A/C" $mgroup
						mgrp="G1 "
					case "LOAN" $mgroup and "ADVANCE" $mgroup
						mgrp="C4  "
					case "SECURED LOAN" $mgroup
						mgrp="G2  "
					case "UNSECURED LOAN" $mgroup
						mgrp="G3  "
					case "DIRECT" $mgroup and !("INDIRECT"$mgroup)
						if "INCOME"$mgroup
							mgrp="J3 "
						endif
						if "EXPENSE" $mgroup
							wacctgroup='J11 '
							mgrp="J1  "
							parentgrup='J1 '
						endif
					case "INDIRECT" $mgroup
						if "INCOME" $mgroup
							mgrp="J4 "
						endif
						if "EXPENSE" $mgroup
							mgrp="J12  "
						endif
					case 'SALE'$mgroup
						if "CENTRAL"$mgroup or "CST"$mgroup
							mgrp='J61  '
						else
							mgrp='J62  '
						endif
					case 'PURCHASE'$mgroup
						if "CENTRAL"$mgroup or "CST"$mgroup
							mgrp="J51  "
						else
							mgrp="J52  "
						endif
				endcase
			else
				mgrp='J12'
			endif
			repl scode with mgrp
			if !empty(mmr)
				sele salesman
				seek left(mconvert(ls.range(allt(mmr)+allt(padr(rowno,6))).value)+space(40),40)
				if !found()
					append blank
					wmrcode='M#'+allt(str(mcode))
					repl salesman.mrcode with wmrcode
					repl salesman.mrname  with mconvert(ls.range(allt(mmr)+allt(padr(rowno,6))).value)
					mcode=mcode+1
				else
					mrcode=salesman.mrcode
				endif
				sele order
				repl order.mr with  wmrcode
			endif
			&& Saletype
			&&  Area
			if !empty(marea)
				mareaname= mconvert(ls.range(allt(marea)+allt(padr(rowno,6))).value)
				?mareaname
				sele saletype
				seek 'AREA  '+left(mareaname+space(40),40)
				if !found()
					append blank
					repl sgcode with 'AREA  '
					repl scode  with 'A'+padr(recno(),6)
					repl sname  with mareaname
					repl parnam with mareaname
				endif
				sele order
				repl area with saletype.scode
			endif
			&& Rout
			if !empty(mrout)
				mroutname= mconvert(ls.range(allt(mrout)+allt(padr(rowno,6))).value)
				sele saletype
				seek 'ROUT  '+left(mroutname+space(40),40)
				if !found()
					append blank
					repl sgcode with 'ROUT  '
					repl scode  with 'R'+padr(recno(),6)
					repl sname  with mroutname
					repl parnam with mroutname
				endif
				sele order
				repl rout with saletype.scode
			endif
			&&  Station
			if !empty(mstation)
				mstationname= mconvert(ls.range(allt(mstation)+allt(padr(rowno,6))).value)
				sele saletype
				seek 'STATIO'+left(mstationname+space(40),40)
				if !found()
					append blank
					repl sgcode with 'STATIO'
					repl scode  with 'S'+padr(recno(),6)
					repl sname  with mstationname
					repl parnam with mstationname
				endif
			endif


			&& SUPPORT  FOOD LIC.
			if !empty(mfoodlic)
				select support
				seek 'F'+'FODDETAI'+order.ordno
				if !found()
					appe blan
					repl aliase with 'FODDETAI'
					repl type with 'F'
					repl lcode with order.ordno
					repl remark with LEFT('Food Licence'+mconvert(ls.range(allt(mfoodlic)+allt(padr(rowno,6))).value)+space(57),57)+str(Ldis2,4,1)+str(0,4,1)+str(0,4,1)
				else
					repl remark with Left('Food Licence'+mconvert(ls.range(allt(mfoodlic)+allt(padr(rowno,6))).value)+space(57),57)+str(Ldis2,4,1)+str(0,4,1)+str(0,4,1)
				endif

				&& for central  for local  (L            LN)
				select support
				seek 'F'+'LBTDETAI'+order.ordno
				if !found()
					appe blan
					repl aliase with 'LBTDETAI'
					repl type with 'F'
					repl lcode with order.ordno
					repl heading with iif(finalcp71_code#left(order.gstno,2) and !empty(order.gstno),'L            ON ','L            LN')
				endif
			endif
			&&&  E-MAIL ADDRESS UPDATE
			if !empty(memail)
				sele support
				wemail=mconvert(ls.range(allt(memail)+allt(padr(rowno,6))).value)
				if len(alltrim(wemail))>0 and  at('@',wemail)>0
					sele support
					seek 'F'+'ORDER   '+order.ordno+str(0,9)+str(0,9)+str(12,3)
					if !found()
						append blank
						repl type with 'F',aliase with 'ORDER',lcode with order.ordno,;
							sno with 12,remark with wemail
						repl heading with iif (empty(order.gstno),'                00000UG  ','                00000NG  ')
					else
						repl remark with wemail
					endif
					sele support
					seek 'F'+'ORDERsms'+order.Ordno+str(0,9)+str(0,9)+str(2,3)
					if !found()
						append blank
						repl type with 'F',aliase with 'ORDERsms',lcode with order.ordno,;
							sno with 2,remark with wemail
					else
						repl remark with wemail
					endif
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(order.parnam))
		endfor
	endfor
	sele salesman
	if reccount()>0
		scan
			sele order
			append blan
			repl scode with 'D32'
			repl ordno with salesman.mrcode
			repl parnam with salesman.mrname
			repl mailnam with salesman.mrname
		endscan
	endif
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('LEDGER MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc















proc batch_trf
	old_datadelete='No '
	store space(2) to mitemcode,mproduct,mpacking,mpack,munit1,munit2,mexpdate,mbatchno,mbalanceqty,mmrp,mratea,mrateb,;
		mratec,mcost,mprate,mbarcode
	store 1 to mchoice
	store 0 to mexcel
	mindex='Product'
	pcode='  '
	colofhed="BATCH MASTER IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'BATCH MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1  say 'Excel File      :'+mfile
	@  5,1  say 'ITEM CODE       : ' get mitemcode pict '@!'
	@  5,25 say 'ITEM NAME       : ' get mproduct pict '@!'
	@  5,50 say 'PACKING         : ' get mpacking pict '@!'
	@  6,1  say 'CONVERSION      : ' get mpack pict '@!'
	@  6,25 say 'UNIT-1          : ' get munit1 pict '@!'
	@  6,50 say 'UNIT-2          : ' get munit2 pict '@!'
	@  7,1  say 'EXPIRY DATE     : ' get mexpdate pict '@!'
	@  7,25 say 'BATCH NO        : ' get mbatchno pict '@!'
	@  7,50 say 'STOCK QUANTITY  : ' get mbalanceqty pict '@!'
	@  8,1  say 'M.R.P.          : ' get mmrp pict '@!'
	@  8,25 say 'Rate A          : ' get mratea pict '@!'
	@  8,50 say 'Rate B          : ' get mrateb pict '@!'
	@  9,1  say 'Rate C          : ' get mratec pict '@!'
	@  9,25 say 'COST            : ' get mcost pict '@!'
	@  9,50 say 'PURCHASE RATE   : ' get mprate pict '@!'
	@  10,1 say 'BARCODE         : ' get mbarcode pict '@!'
	@  12,1 say 'DELETE OLD RECORD' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  13,1 say 'MASTER MAP       ' get mindex pict '@^ Code  ,Product' size 1.5,8,2 font 'cambria',13
	@  19,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	*******************************************************************************
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\probat.&datext alia probat excl
	sele probat
	if old_datadelete='Y'
		dele all
	endif
*!*		sele sele(1)
*!*		use &datdev\pro.&datext alia pro excl
	sele pro
	if mindex ='C'
		index on name to pro
	else
		index on product+packing to pro
	endif
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			wpname=''
			if !empty(mproduct)
				wpname=left(mconvert(ls.range(allt(mproduct)+allt(padr(rowno,6))).value)+space(30),30)
				if !empty(mpacking)
					wpname=wpname+left(mconvert(ls.range(allt(mpacking)+allt(padr(rowno,6))).value)+space(15),15)
				endif
			endif
			sele pro
			seek wpname
			if !found()
				loop
			endif
			sele probat
			append blank
			repl code with pro.code
			repl date with date()
			repl name with pro.name
			repl product with pro.product
			repl billname with pro.billname
			repl pack with pro.pack
			repl packing with pro.packing
			repl unit with pro.unit
			repl unit2 with pro.unit2
*!*				if  !empty(mitemcode)
*!*					repl name with mconvert(ls.range(allt(mitemcode)+allt(padr(rowno,6))).value)
*!*				endif
*!*				if !empty(mproduct)
*!*					repl product with mconvert(ls.range(allt(mproduct)+allt(padr(rowno,6))).value)
*!*				endif
*!*				if !empty(mpacking)
*!*					repl packing with mconvert(ls.range(allt(mpacking)+allt(padr(rowno,6))).value)
*!*				endif
*!*				if !empty(mpack)
*!*					repl pack  with val(mconvert(ls.range(allt(mpack)+allt(padr(rowno,6))).value))
*!*				endif
*!*				if !empty(mproduct)
*!*					repl billname with product+packing
*!*				endif
*!*				if !empty(munit1)
*!*					repl unit with mconvert(ls.range(allt(munit1)+allt(padr(rowno,6))).value)
*!*				endif
*!*				if !empty(munit2)
*!*					repl unit2 with mconvert(ls.range(allt(munit2)+allt(padr(rowno,6))).value)
*!*				endif
			if !empty(mexpdate)
				wexp=allt(left(mconvert(ls.range(allt(mexpdate)+allt(padr(rowno,6))).value),10))
				if len(wexp)=10
					repl exp with ctod(wexp)
				endif
				if len(wexp)=7
					wexp='28/'+wexp
					repl exp with ctod(wexp)
				endif
				if len(wexp)=6
					wexp='28/0'+wexp
					repl exp with ctod(wexp)
				endif
				if len(wexp)=5
					wexp='28/'+left(wexp,2)+'/20'+right(wexp,2)
					repl exp with ctod(wexp)
				endif
				if len(wexp)=4
					wexp='28/0'+left(wexp,1)+'/20'+right(wexp,2)
					repl exp with ctod(wexp)
				endif
				
			endif
			if !empty(mbatchno)
				repl batchno with mconvert(ls.range(allt(mbatchno)+allt(padr(rowno,6))).value)
			endif
			if !empty(mbalanceqty)
				repl balance with val(mconvert(ls.range(allt(mbalanceqty)+allt(padr(rowno,6))).value))
				repl b_a with balance
				repl opening with balance
				repl o_a with balance
			endif
			if !empty(mmrp)
				repl mrp with val(mconvert(ls.range(allt(mmrp)+allt(padr(rowno,6))).value))
			endif
			if !empty(mratea)
				repl ratea with val(mconvert(ls.range(allt(mratea)+allt(padr(rowno,6))).value))
			endif
			if !empty(mrateb)
				repl rateb with val(mconvert(ls.range(allt(mrateb)+allt(padr(rowno,6))).value))
			endif
			if !empty(mratec)
				repl ratec with val(mconvert(ls.range(allt(mratec)+allt(padr(rowno,6))).value))
			endif
			if !empty(mcost)
				repl lprate with val(mconvert(ls.range(allt(mcost)+allt(padr(rowno,6))).value))
			endif
			if !empty(mprate)
				repl prate with val(mconvert(ls.range(allt(mprate)+allt(padr(rowno,6))).value))
			endif
			if !empty(mbarcode)
				repl mycode with mconvert(ls.range(allt(mbarcode)+allt(padr(rowno,6))).value)
			endif

			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(probat.product))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('BATCH MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc




proc patient_import
	old_datadelete='No '
	store space(2) to mpatient,madd1,madd2,mcity,mgender,mage,mmobile
	store 1 to mchoice
	store 0 to mexcel
	pcode='  '
	colofhed="PAIENT MASTER IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'PATIENT MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1   say 'Excel File      :'+mfile

	@  5,1   say 'Patient Name    : ' get mpatient pict '@!'
	@  5,25  say 'Address 1       : ' get madd1 pict '@!'
	@  5,50  say 'Address 2       : ' get madd2 pict '@!'
	@  6,1   say 'City            : ' get mcity pict '@!'
	@  6,25  say 'Gender (M/F)    : ' get mgender pict '@!'
	@  6,50  say 'Age             : ' get mage pict '@!'
	@  7,1   say 'Mobile Number   : ' get mmobile pict '@!'
	@  8,1   say 'DELETE OLD DATA :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  10,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\maorder.&datext alia maorder excl
	sele maorder
	if old_datadelete='Y'
		delete all for scode='PET#$~'
	endif
*!*		sele sele(1)
*!*		use &datdev\support.&datext alia support excl
	sele support
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele maorder
			if  !empty(mpatient)
				append blank
				repl maorder.scode with 'PET#$~'
				repl parnam with left(mconvert(ls.range(allt(mpatient)+allt(padr(rowno,6))).value)+space(30),30)+'STACO3STACO3'

				if !empty(madd1) &&AND Empty(mCity)
					repl city  with mconvert(ls.range(allt(madd1)+allt(padr(rowno,6))).value)
				endif
				if !empty(mcity) and empty(madd1)
					repl city with mconvert(ls.range(allt(mcity)+allt(padr(rowno,6))).value)
				endif

				if !empty(mmobile)
					repl balance with val(mconvert(ls.range(allt(mmobile)+allt(padr(rowno,6))).value))
					repl form with mconvert(ls.range(allt(mmobile)+allt(padr(rowno,6))).value)
				endif
				if !empty(mage)
					repl rslipno  with val(mconvert(ls.range(allt(mage)+allt(padr(rowno,6))).value))
				endif
				if !empty(mgender)
					repl paycr  with upper(left(mconvert(ls.range(allt(mgender)+allt(padr(rowno,6))).value),1))
				endif
				if !empty(mmobile)
					wmobile=left(mconvert(ls.range(allt(mmobile)+allt(padr(rowno,6))).value)+space(10),10)
					*wPin=left(mconvert(ls.Range(Allt(mPin)+Allt(Padr(rowno,6))).Value)+space(10),10)
					sele support
					if !empty(madd1) and !empty(mcity)
						append blank
						repl type with 'P'
						repl aliase with left(wmobile,8)
						repl lcode with right(wmobile,2) &&'27'
						repl pcode with 123456790
						repl remark with space(6)+left(mconvert(ls.range(allt(mcity)+allt(padr(rowno,6))).value),20)
					endif
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(maorder.parnam))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('PATIENT MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc



proc retail_customer
	old_datadelete='No '
	store space(2) to mcustcode,mcustomer,madd1,madd2,madd3,mmobile
	store 1 to mchoice
	store 0 to mexcel
	pcode='  '
	colofhed="RETAIL CUSTOMER IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'RETAIL CUSTOEMER MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1  say 'Excel File      :'+mfile
	@  5,1  say 'CUSTOMER CODE   : ' get mcustcode pict '@!'
	@  5,25 say 'CUSTOMER NAME   : ' get mcustomer pict '@!'
	@  5,50  say 'ADDRESS-1       : ' get madd1 pict '@!'
	@  6,1 say 'ADDRESS-2       : ' get madd2 pict '@!'
	@  6,25  say 'ADDRESS-3       : ' get madd3 pict '@!'
	@  6,50 say 'MOBILE NO       : ' get mmobile pict '@!'
	@  7,1   say 'DELETE OLD DATA :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  10,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\sborder.&datext alia sborder excl
	sele sborder
	if old_datadelete='Y'
		delete all for scode='!@#POS'
	endif
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele sborder
			if  !empty(mcustomer)
				append blank
				repl scode with '!@#POS'
				repl parnam with mconvert(ls.range(allt(mcustomer)+allt(padr(rowno,6))).value)

				if !empty(mcustcode)
					repl subcode  with mconvert(ls.range(allt(mcustcode)+allt(padr(rowno,6))).value)
				endif
				if !empty(madd1)
					repl paradd with mconvert(ls.range(allt(madd1)+allt(padr(rowno,6))).value)
				endif
				if !empty(madd2)
					repl paradd1 with mconvert(ls.range(allt(madd2)+allt(padr(rowno,6))).value)
				endif
				if !empty(madd3)
					repl paradd2 with mconvert(ls.range(allt(madd3)+allt(padr(rowno,6))).value)
				endif
				if !empty(mmobile)
					repl couponno with mconvert(ls.range(allt(mmobile)+allt(padr(rowno,6))).value)
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(sborder.parnam))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('RETAIL CUSTOMER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc


proc doctor_import
	old_datadelete='No '
	store space(2) to mdoctor,madd1,mregno,mmobile
	store 1 to mchoice
	store 0 to mexcel
	pcode='  '
	colofhed="DOCTOR IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'DOCTOR MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1    say 'Excel File      :'+mfile

	@  5,1   say 'DOCTOR NAME     : ' get mdoctor pict '@!'
	@  5,25  say 'ADDRESS         : ' get madd1 pict '@!'
	@  5,50  say 'REGISTRATION    : ' get mregno pict '@!'
	@  6,1   say 'MOBILE NO       : ' get mmobile pict '@!'
	@  7,1   say 'DELETE OLD DATA :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  10,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\maorder.&datext alia maorder excl
	sele maorder
	if old_datadelete='Y'
		delete all for scode='PRE#$~'
	endif
*!*		sele sele(1)
*!*		use &datdev\support.&datext alia support excl
	sele support
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele maorder
			if  !empty(mdoctor)
				append blank
				repl maorder.scode with 'PRE#$~'
				madd=''
				if !empty(mdoctor)
					wadd=mconvert(ls.range(allt(madd1)+allt(padr(rowno,6))).value)
				endif
				repl parnam with left(mconvert(ls.range(allt(mdoctor)+allt(padr(rowno,6))).value)+space(30),30)+wadd
				if !empty(mmobile)
					repl form with mconvert(ls.range(allt(mmobile)+allt(padr(rowno,6))).value)
				endif

				if !empty(mregno)
					repl city  with left(mconvert(ls.range(allt(mregno)+allt(padr(rowno,6))).value)+space(15),15)+form
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(maorder.parnam))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('DOCTOR MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc



proc area_master_import
	old_datadelete='No '
	store 1 to mchoice
	store 0 to mexcel
	store space(2) to mareaname
	pcode='  '
	colofhed="AREA MASTER IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'AREA MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1   say 'Excel File      :'+mfile
	@  5,1   say 'AREA NAME       : ' get mareaname pict '@!'
	@  6,1   say 'DELETE OLD DATA :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  9,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\saletype.&datext alia saletype excl
	sele saletype
	if old_datadelete='Y'
		delete all for sgcode='AREA  '
	endif
	index on sgcode+upper(sname) to saletype
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			if  !empty(mareaname)
				xarea=mconvert(ls.range(allt(mareaname)+allt(padr(rowno,6))).value)
				sele saletype
				seek "AREA  "+substr(upper(xarea)+space(40),1,40)
				if !found()
					append blank
					repl sgcode with 'AREA  '
					repl scode  with 'A'+padr(recno(),6)
					repl sname  with upper(xarea)
					repl parnam with sname
					repl tcode with 'No'
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(saletype.sname))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('AREA MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc

proc rout_import
	old_datadelete='No '
	store space(2) to mroutename
	store 1 to mchoice
	store 0 to mexcel
	pcode='  '
	colofhed="ROUTE IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'ROUTE MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1   say 'Excel File      :'+mfile
	@  5,1   say 'ROUTE NAME      : ' get mroutename pict '@!'
	@  6,1   say 'DELETE OLD DATA :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  9,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\saletype.&datext alia saletype excl
	sele saletype
	index on sgcode+upper(sname) to saletype
	if old_datadelete='Y'
		delete all for sgcode='ROUT  '
	endif
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele saletype
			if  !empty(mroutename)
				seek 'ROUT  '+upper(left(mconvert(ls.range(allt(mroutename)+allt(padr(rowno,6))).value)+space(40),40))
				if !found()
					append blank
					repl sgcode with 'ROUT  '
					repl scode  with 'R'+padr(recno(),6)
					repl sname  with upper(mconvert(ls.range(allt(mroutename)+allt(padr(rowno,6))).value))
					repl parnam with sname
					repl tcode with 'No'
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(saletype.sname))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('ROUTE MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc

proc company_import
	old_datadelete='No '
	store space(2) to mcompanyname
	store 1 to mchoice
	store 0 to mexcel
	pcode='  '
	colofhed="COMPANY IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'COMPANY MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1   say 'Excel File          :'+mfile
	@  5,1   say 'COMPANY/GROUP NAME  : ' get mcompanyname pict '@!'
	@  6,1   say 'DELETE OLD DATA     :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  9,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\saletype.&datext alia saletype excl
	sele saletype
	index on sgcode+upper(sname) to saletype
	if old_datadelete='Y'
		delete all for sgcode='ZZZZZZ'
	endif
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele saletype
			if  !empty(mcompanyname)
				seek 'ZZZZZZ'+upper(left(mconvert(ls.range(allt(mcompanyname)+allt(padr(rowno,6))).value)+space(40),40))
				if !found()
					append blank
					repl sgcode with 'ZZZZZZ'
					repl scode  with 'Z'+padr(recno(),6)
					repl sname  with upper(mconvert(ls.range(allt(mcompanyname)+allt(padr(rowno,6))).value))
					repl parnam with sname
					repl tcode with 'No'
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(saletype.sname))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('COMPANY MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc


proc salt_import
	old_datadelete='No '
	store space(2) to msaltname
	store 1 to mchoice
	store 0 to mexcel
	pcode='  '
	colofhed="SALT IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'SALT MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1   say 'Excel File       :'+mfile
	@  5,1   say 'SALT/COMPOSITION : ' get msaltname pict '@!'
	@  6,1   say 'DELETE OLD DATA  :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  9,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\saletype.&datext alia saletype excl
	sele saletype
	index on sgcode+upper(sname) to saletype
	if old_datadelete='Y'
		delete all for sgcode='SALT  '
	endif
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele saletype
			if  !empty(msaltname )
				seek 'SALT  '+upper(left(mconvert(ls.range(allt(msaltname)+allt(padr(rowno,6))).value)+space(40),40))
				if !found()
					append blank
					repl sgcode with 'SALT  '
					repl scode  with 'S'+padr(recno(),6)
					repl sname  with left(upper(mconvert(ls.range(allt(msaltname)+allt(padr(rowno,6))).value)),40)
					repl tname  with subs(upper(mconvert(ls.range(allt(msaltname)+allt(padr(rowno,6))).value)),41,40)
					repl parnam with sname
					repl tcode with 'No'
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(saletype.sname))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('SALT MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc




proc category_import
	old_datadelete='No '
	store space(2) to mcategoryname
	store 1 to mchoice
	store 0 to mexcel
	pcode='  '
	colofhed="CATEGORY IMPORT FROM EXCEL"
	=colofil(0,0,25,80,10)
	@  01,30  say 'CATEGORY MASTER IMPORT FROM EXCEL' font 'arial bold',18 color rgb(181,27,27)
	@  3,1 get mexcel pict "@*TH \<SELECT EXCEL FILE"  font 'cambria',14
	read colo &colourack
	if mexcel=1
		mfile=getfile([XLS,XLSX],"Open Excel File")
		mfile=allt(mfile)
		if empty(mfile)
			=messagebox('Please Select the Excel File','MargErp9')
			return
		endif
	else
		=messagebox('Please Select the Excel File','MargErp9')
		return
	endif
	@  3,1   say 'Excel File      :'+mfile
	@  5,1   say 'CATEGORY NAME   : ' get mcategoryname pict '@!'
	@  6,1   say 'DELETE OLD DATA :' get old_datadelete pict '@^ No ,Yes' size 1.5,8,2 font 'cambria',13
	@  9,22 get mychoice pict "@*TH \<IMPORT;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
	read colo &colourack
	if lastkey()=27 or mychoice=2
		return
	endif
	*close table all
	o = createobject("Excel.Application")
	lw = o.workbooks.open(mfile)
*!*		sele sele(1)
*!*		use &datdev\saletype.&datext alia saletype excl
	sele saletype
	index on sgcode+upper(sname) to saletype
	if old_datadelete='Y'
		delete all for sgcode='CATEGO'
	endif
	for s=1 to 1 &&lw.Worksheets.Count
		ls = lw.sheets(s)
		rowno=2
		for r=1 to o.activesheet.usedrange.rows.count
			sele saletype
			if  !empty(mcategoryname)
				seek 'CATEGO'+upper(left(mconvert(ls.range(allt(mcategoryname)+allt(padr(rowno,6))).value)+space(40),40))
				if !found()
					append blank
					repl sgcode with 'CATEGO'
					repl scode  with 'C'+padr(recno(),6)
					repl sname  with upper(mconvert(ls.range(allt(mcategoryname)+allt(padr(rowno,6))).value))
					repl parnam with sname
					repl tcode with 'No'
				endif
			endif
			rowno=rowno+1
			=plswproc("Please Wait......."+ alltri(saletype.sname))
		endfor
	endfor
	*close table all
	o.application.usercontrol=.t.
	*o.application.interactive=.t.
	o.workbooks.close()
	o.quit()
	=messagebox('CATEGORY MASTER TRANSFER HAS BEEN DONE,PLEASE RUN THE ERROR CHECKING & FILE MAINTENANCE','MargErp9')
endproc

********************************************************************************************************************




funct mconvert
	param mvalue
	mvalue=iif(transform(mvalue)#'.NULL.',transform(mvalue),'')
	return allt(mvalue)
endfunc

