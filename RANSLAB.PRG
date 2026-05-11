*!*	BOF : Ranslab.PRG (Garment).....CREATED By Sarvesh Thakur     Dated    : 04/12/2021
clear
set cpdialog off
close data
set talk off
set date to brit
set cent on
set dele on
set safe off
if type('FINALCP')='U'
	firstdate=ctod('01/04/2021')  		&& Un-Comment this for run from VFP
	lastdate =ctod('31/03/2022')  		&& Un-Comment this for run from VFP
	datdev='D:\transfer'   && Un-Comment this for run from VFP
	datext='dbf'						&& Un-Comment this for run from VFP
endif
datatransferext='DBF'
datatransferpath =substr('D:\DM\Mar\Ranslab\DBF\'+space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='20'
sure='SURE'
removenull='No '

Clear
Close Data
@ 02,22 Say 'Piping Ranslab To Marg.....' Font 'Arial',14 Colo 'W+/G'
@ 04,08 to 21,115 doub
@ 06,10 Say 'Ranslab Data Path    :' Font 'Courier',18  Get datatransferpath  Font 'courier',18
@ 07,10 Say 'Ranslab Extension    :' Font 'Courier',18  Get datatransferext  Font 'courier',18
@ 09,10 Say 'F.Y.BEGIN Date       :' Font 'Courier',18  Get old_5  Font 'Courier',18
@ 10,10 Say 'F.Y.End   Date       :' Font 'Courier',18  Get old_6   Font 'Courier',18
@ 11,10 Say 'State Code           :' Font 'Courier',18  Get mstatecode Font 'Courier',18
@ 12,10 Say 'Removenull           :' Font 'Courier',18  Get removenull Pict '@m No,Yes ' Font 'Courier',18
@ 13,10 Say 'Type SURE            :' Font 'courier',18  Get sure Pict '@x!' Font 'courier',18

Read
Clear
Close Data
datatransferpath=alltrim(datatransferpath)
datatransferpath=Alltrim(datatransferpath)
datatransferext='.'+Alltrim(datatransferext)
datdev= Alltrim (datdev)
datext= Alltrim (datext)
If Lastkey() = 27 Or  Upper( sure ) # 'SURE'
	Return
Endif
Clear
if type('FINALCP')#'U'
	=starttransfer()        &&&&Comment it for run in VFP
endif
if removenull='Y'
	totfiles=adir(fhandle,datatransferpath+'*.dbf')
	@ 02,22 Say 'Please wait removing null values'
	for cfile = 1 to totfiles
		use datatransferpath+fhandle(cfile,1)
		if reccount()>0
			do rem_null
		endif
	next                           
Endif
clear
rowno=5
@ 02,22 Say 'Please Wait Importing Ranslab  To Marg.....' Font 'Arial',14 Colo 'W+/G'
Set Colo To
Sele Sele(1)
Use &datdev\glmonth.&datext
Zap
Use &datdev\ggmonth.&datext
Zap
Use &datdev\pro.&datext
Zap
Use &datdev\Order.&datext
Zap
Use &datdev\saletype.&datext
Zap
Use &datdev\gledger.&datext
Zap
Use &datdev\pendings.&datext
Zap
Use &datdev\pend.&datext
Zap
Use &datdev\probat.&datext
Zap
Use &datdev\maorder.&datext
Zap
Use &datdev\sborder.&datext
Zap
Use &datdev\mdis.&datext
Zap
Use &datdev\dis.&datext
Zap
Use &datdev\glmonth.&datext
Zap
Use &datdev\ggmonth.&datext
Zap
Use &datdev\Support.&datext
Dele All For Type='#' And aliase='DAT/F'
Pack
Close Data
Set Colo To
close table all
@Rowno,22 say 'Importing Product_Master .....' font 'Courier',14 
rowno=rowno+1

sele sele(1) 
	use &datatransferpath\productmaster alias fitm
sele sele(1) 
	use &datatransferpath\hsnsacmaster alias fhsn
	index on hsnsacid to fhsn
sele sele(1) 
	use &datatransferpath\taxmaster alias ftax
	index on taxid to ftax
sele sele(1)
	use &datdev\pro.&datext alias mitm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	index on sgcode + sname + str(igst,5,2) to mpcm 
sele fitm
go top
scan
   @rowno-1,80 say str(recno(),10)   font 'Arial',12
   last=recno()
   =seek(fitm.hsnsacid,'fhsn')
   =seek(fitm.taxidpurchase,'ftax')
   sele mitm
   append blank
   repl mitm.code with last
   repl mitm.name with alltri(fitm.productid)
   repl mitm.product with upper(fitm.productname)
   repl mitm.packing with ' '
   repl mitm.bookname with fitm.printname
   repl mitm.unit with "PCS"
   repl mitm.pack with 0
   repl rackno with fitm.upcean
   repl mitm.billname with mitm.product+' '+mitm.packing
   repl gcode with padr(fitm.brandid,6)
   repl gcode5 with padr(fitm.departmentid,6)
   repl gcode3 with padr(fitm.subgroupid,6)
   repl mitm.taxl with 'T'
   repl mitm.taxc with 'T'
   repl mitm.decimal with 'Y'
   repl mitm.salfix with 'N'
   repl mitm.halfsche with 'A'
   repl mitm.qtrsche with 'Y'
   repl mitm.status with 'Y'
   repl mitm.purtax with ftax.taxvalue/2
   repl mitm.saltax with ftax.taxvalue/2
   repl mitm.cgst with ftax.taxvalue/2
   repl mitm.igst with ftax.taxvalue
   &&HSN
   sele mpcm
   seek 'COMMCD' + substr(fhsn.hsnsaccode+space(40),1,40) + str(mitm.igst,5,2)
   if !found()
      append blank
      repl mpcm.sgcode with 'COMMCD',;
           mpcm.scode  with 'HH'+alltrim(str(last)),;
           mpcm.sname  with fhsn.hsnsaccode,;
           mpcm.parnam with fhsn.hsnsaccode,;
           mpcm.tax with mitm.saltax,;
           mpcm.cgst with mitm.cgst,;
           mpcm.igst with mitm.igst,;
           mpcm.tcode with 'No'
   endif
   repl mitm.gcode6 with mpcm.scode
endscan
close table all

@Rowno,22 say 'Importing Product Department Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
	use &datatransferpath\Departmentmaster alias fpcm

sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	dele all for sgcode='CATEGO'
sele fpcm
go top
scan
	@rowno-1,80 say str(recno(),10)   font 'Arial',12
	sele mpcm
	appen blank
	repl sgcode with "CATEGO"
	repl scode with padr(fpcm.departmentid,6)
	repl sname with upper(fpcm.departmentname)
	repl parnam with upper(fpcm.departmentname)
endsc
close table all

@Rowno,22 say 'Importing Product Company.....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
	use &datatransferpath\brandmaster alias fpcm

sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	dele all for sgcode='ZZZZZZ'
sele fpcm
go top
scan
	@rowno-1,80 say str(recno(),10)   font 'Arial',12
	sele mpcm
	appen blank
	repl sgcode with "ZZZZZZ"
	repl scode with padr(fpcm.brandid,6)
	repl sname with upper(fpcm.brandname)
	repl parnam with upper(fpcm.brandname)
endsc
close table all

@Rowno,22 say 'Importing Product SubGroup .....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
	use &datatransferpath\subgroupmaster alias fpcm

sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	dele all for sgcode='SALT  '
sele fpcm
go top
scan
	@rowno-1,80 say str(recno(),10)   font 'Arial',12
	sele mpcm
	appen blank
	repl sgcode with "SALT  "
	repl scode with padr(fpcm.subgroupid,6)
	repl sname with upper(fpcm.subgroupname)
	repl parnam with upper(fpcm.subgroupname)
endsc
close table all


@Rowno,22 say 'Importing Stock.....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\Stock alias fsbal
sele sele(1)
	use &datatransferpath\productmaster alias fitm
	index on productid to fitm
sele sele(1)
	use &datdev\probat.&datext alias msbal
	index on name+batchno to msbal
sele sele(1)
	use &datdev\pro.&datext alias mitm
	index on substr(name,1,10) to mitm
sele sele (1)
	use &datdev\malter.&datext  alias altr 
	dele all
	pack
    index on code+batch+subs(name,1,20) to altr
sele sele(1)
	use &datdev\support.&datext
  	dele all for type='#' and aliase='DAT/F-BT'
 	pack
r=0
sele fsbal
go top
scan
   @rowno-1,80 say str(recno(),10)   font 'Arial',12
   =seek(fsbal.productid,'fitm')
   sele mitm
   seek substr(fsbal.productid+space(10),1,10)
   sele msbal
   seek substr(fsbal.productid+space(10),1,10)+str(fsbal.mrp,9,2)
      if !found()   
      append blank
      repl msbal.code with mitm.code
      repl msbal.name with mitm.name
      repl msbal.billname with mitm.billname
      repl msbal.product with mitm.product
      repl msbal.packing with mitm.packing
      repl msbal.decimal with 'Y'
      repl msbal.batchno with str(fsbal.mrp,9,2)
      repl msbal.prate with fsbal.purchasecost
      repl msbal.ratea with fsbal.srate
      repl msbal.mrp with fsbal.mrp
      repl msbal.misc1 with mitm.gcode
      repl msbal.opening with fsbal.quantity
      repl msbal.balance with fsbal.quantity
      repl msbal.o_a with fsbal.quantity
      repl msbal.b_a with fsbal.quantity
    else
      repl msbal.opening with msbal.opening + fsbal.quantity,;
           msbal.balance with msbal.balance + fsbal.quantity,;
           msbal.o_a with msbal.o_a + fsbal.quantity,;
           msbal.b_a with msbal.b_a + fsbal.quantity
    endif
sele altr 
seek str(msbal.code,9)+msbal.batchno+subs(fitm.upcean+spac(20),1,20)
	IF !FOUND()   
	    appen blank
	    repl type with 'BTBRCD'
	    repl code with STR(MSBAL.code,9)
	    repl batch with msbal.batchno
	    repl name with fitm.upcean
    ENDIF   
*****
sele altr 
seek str(msbal.code,9)+msbal.batchno+subs(fitm.upcean1+spac(20),1,20)
	IF !FOUND()   
	    appen blank
	    repl type with 'BTBRCD'
	    repl code with STR(MSBAL.code,9)
	    repl batch with msbal.batchno
	    repl name with fitm.upcean1
    ENDIF   

sele altr 
seek str(msbal.code,9)+msbal.batchno+subs(fitm.upcean2+spac(20),1,20)
	IF !FOUND()   
	    appen blank
	    repl type with 'BTBRCD'
	    repl code with STR(MSBAL.code,9)
	    repl batch with msbal.batchno
	    repl name with fitm.upcean2
    ENDIF   

sele altr 
seek str(msbal.code,9)+msbal.batchno+subs(fitm.upcean3+spac(20),1,20)
	IF !FOUND()   
	    appen blank
	    repl type with 'BTBRCD'
	    repl code with STR(MSBAL.code,9)
	    repl batch with msbal.batchno
	    repl name with fitm.upcean3
    ENDIF   
sele altr 
seek str(msbal.code,9)+msbal.batchno+subs(fitm.upcean4+spac(20),1,20)
	IF !FOUND()   
	    appen blank
	    repl type with 'BTBRCD'
	    repl code with STR(MSBAL.code,9)
	    repl batch with msbal.batchno
	    repl name with fitm.upcean4
    ENDIF   
sele altr 
seek str(msbal.code,9)+msbal.batchno+subs(fitm.userdefinedcode+spac(20),1,20)
	IF !FOUND()   
	    appen blank
	    repl type with 'BTBRCD'
	    repl code with STR(MSBAL.code,9)
	    repl batch with msbal.batchno
	    repl name with fitm.userdefinedcode
    ENDIF   
endscan
close table all
@Rowno,22 say 'Importing Ledger Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
use &datatransferpath\accountmaster alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	@rowno-1,80 say str(recno(),10)   font 'Arial',12
	sele mact
	appen blank
	mgroup='J12'
		do case
			case fact.groupid=23
				mgroup='D31'
			case fact.groupid=8
				mgroup='C6'
			case fact.groupid=2
				mgroup='C1'
			case fact.groupid=3
				mgroup='C2'
			case fact.groupid=21
				mgroup='D1'
			case fact.groupid=22
				mgroup='D2'
			case fact.groupid=10
				mgroup='E'
			case fact.groupid=30
				mgroup='J11'
			case fact.groupid=31
				mgroup='J12'
			case fact.groupid=32
				mgroup='I'
			otherwise
				mgroup='J12'
		endcase
	repl mact.scode with mgroup
	repl mact.rate with 'Y'
	repl mact.ordno with alltri(str(fact.accountid))
	repl mact.fax2 with alltri(str(fact.accountid))
	repl mact.parnam  with fact.accountname
	repl mact.mailnam with fact.accountname
	repl mact.paradd with fact.address1
	repl mact.paradd1 with fact.address2
	repl mact.paradd2 with fact.address3
	repl mact.cstno with fact.cstno
	repl mact.stno with fact.vatno
	repl itno with fact.panno
	repl gstno with fact.gstinno
	repl area with padr(fact.cityid,6)
	repl phone1 with fact.phone
	repl phone4 with fact.contactpersonmobile
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
*!*	update mact set opning=sum(bal.cr)-sum(bal.dr) from bal group by acid having  
***STATE
	    sele support
	    appen blank
		repl aliase with 'ORDER   '
		repl type with 'F'
		repl lcode with mact.ordno
		repl sno with 7
		repl pcode with 15
		repl remark with subs(remark,1,32)+"DEF"+iif(subs(mact.gstno,1,2)='  ',mstatecode,subs(mact.gstno,1,2))+'                                           '
endscan
close tables all

@Rowno,22 say 'Importing City Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1) 
	use &datatransferpath\citymaster alias fpcm
sele sele(1)
	use &datdev\saletype.&datext alias mpcm
	dele all for sgcode='AREA  '
sele fpcm
go top
scan
	@rowno-1,80 say str(recno(),10)   font 'Arial',12
	sele mpcm
	appen blank
	repl sgcode with "AREA  "
	repl scode with padr(fpcm.cityid,6)
	repl sname with upper(fpcm.cityname)
	repl parnam with upper(fpcm.cityname)
endsc
close table all

@Rowno,22 say 'Importing Customer_Master .....' font 'Courier',14 
rowno=rowno+1
sele sele(1)
	use &datatransferpath\customermaster alias fact
sele sele(1)
	use &datdev\sborder.&datext alias mact 
sele fact
go top
scan
   @rowno-1,80 say str(recno(),10)   font 'Arial',12
	sele mact
	appen blank
	repl scode with '!@#POS'
	repl parnam with upper(fact.firstname)
	repl confir with upper(fact.firstname)
	repl conlas with upper(fact.lastname)
	repl couponno with fact.mobile
	repl subcode with (fact.cardid)
	repl phone1 with fact.phone
endscan
close tables all


proc rem_null
a = afields(arr)
for imarg = 1 to a
	mfldname = arr(imarg, 1)
	do case
	case inlist(arr(imarg,2), "C","V","M")
		replace all &mfldname with '' for isnull(&mfldname)
	case inlist(arr(imarg,2), "B","N","I","F","Y")
		replace all &mfldname with 0 for isnull(&mfldname)
	case inlist(arr(imarg,2), "D","T","M")
		replace all &mfldname with ctod('') for isnull(&mfldname)
	endcase
endfor

*!*	EOF : Ranslab.PRG (Garment).....CREATED By Sarvesh Thakur     Dated    : 04/12/2021
