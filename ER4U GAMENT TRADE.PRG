**Bof    << ER4U Prg >>
**State  << U.P.>>
**Author << Umesh Nath Goswami >>
**Created on <<09/12/2024>>
clea
set cpdialog off
close data
set talk Off
set date to brit
set cent on
set dele on
set safe off
if type('FINALCP')='U'
	firstdate=Ctod('01/04/2024')
	lastdate =Ctod('31/03/2025')
	datdev='d:\transfer\'
	datext='dbf'
endi
datatransferpath =subst('D:\2025\Feb\erp\Dbf\'+Space(50),1,50)
datatransferext='DBF'
old_3 = 'YES'
old_4 = 'No'
old_5 = firstdate
old_6 = lastdate
mstatecode='09'
sure='SURE'
location=1
removenull='No '
clea
close table all
if type('FINALCP')<>'U'
rest screen from SIMPLE
colofhed="ER4U TRANSFER"
=colofil(03,08,13,60,10)
endi
clea
@04,10 Say 'ER4U Data Path      :' Font 'courier',18 Get datatransferpath   Font 'courier',18
@05,10 Say 'ER4U Data Ext.      :' Font 'courier',18 Get datatransferext   Font 'courier',18
@06,10 Say 'With O/S            :' Font 'courier',18 Get old_3 Pict '@^ YES,NO '  Font 'courier',12
@07,10 Say 'Only Balance        :' Font 'courier',18 Get old_4 Pict '@^ YES,NO '  Font 'courier',12
@08,10 Say 'F.Y.Begin From      :' Font 'courier',18 Get old_5  Font 'courier',18
@09,10 Say 'F.Y.Upto            :' Font 'courier',18 Get old_6  Font 'courier',18
@10,10 Say 'Your State Code     :' Font 'courier',18 Get mstatecode Font 'courier',18
@11,10 Say 'Location Id         :' Font 'courier',18 Get location font 'courier',18
@12,10 Say 'Remove Null Values  :' Font 'courier',18 Get removenull Pict '@^ YES,NO '  Font 'courier',12
@13,10 Say 'Type SURE           :' Font 'courier',18 Get SURE Pict '@x!' Font 'courier',18
Read
datatransferpath = Alltrim(datatransferpath)
datatransferext=Alltrim(datatransferext)
datdev=Alltrim(datdev)
datext=Alltrim(datext)
if type('FINALCP')#'U'
	=starttransfer()
ENDIF
rowno=1
If Lastkey()=27 .And. SURE#'SURE'
	Return
Endif
Clear
If removenull='Y'
	@ 08,15 Say 'Removing Null Values........     Please Wait..........' Font 'Tahoma',18
	totfiles=Adir(fhandle,datatransferpath+'*.dbf')
	For cfile = 1 To totfiles
		Use datatransferpath+fhandle(cfile,1)
		If Reccount()>0
			Do rem_null
		Endif
	Next
Endi
clea

@02,22 Say 'Please Wait Importing Er4u Data Into Marg....' Font 'Arial',14 Colo 'W+/G'
sele sele(1)
use &datdev\Pro.&datext
zap
use &datdev\order.&datext
zap
use &datdev\SaleType.&datext
zap
use &datdev\Gledger.&datext
zap
use &datdev\Pendings.&datext
zap
use &datdev\Pend.&datext
zap
use &datdev\Probat.&datext
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
use &datdev\Support.&datext
zap
clos table all
rowno=6

@rowno,10 Say '**** Importing Item Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\Master_subcategory alia fitm
sele sele(1)
use &datatransferpath\barcode alia fbr
inde on scatid to fbr 
sele sele(1)
use &datatransferpath\t_tax_master alia ftax
inde on tax_id to ftax
sele sele(1)
use &datdev\pro.&datext alias mitm
inde on name to mitm
sele sele(1)
use &datdev\saletype.&datext ALIAS mpcm
index on sgcode + sname + str(igst,5,2) to mpcm
sele fitm
pack
go top
scan
   sele mitm
   append blank
   repl code with fitm->scatid
   repl name with alltr(str(code))
   repl product with fitm->subcat
   repl packing with ''
   repl billname with product+packing
   =seek(fitm->scatid,'fbr')
   repl gcode with fbr->cbrand
   repl rackno with fbr->barcode
   repl unit with 'PCS'	  
   repl taxl with 'T'
   repl taxc with 'T'
   repl decimal with 'Y'
   repl salfix with 'N'
   repl halfsche with 'A'
   repl qtrsche with 'Y'
   repl status with 'Y'
   =seek(fbr->tax_id,'ftax')
   mtax=val(strtran(ftax->tax_name,'GST(',''))
   repl saltax with mtax/2
   repl cgst with mtax/2
   repl igst with mtax
   repl prate with 0
   repl ratea with 0
   repl mrp with 0
**Hsn Transfer**
   sele mpcm
   seek 'COMMCD' + substr(fitm->hsncode+space(40),1,40) + str(mitm->igst,5,2)
   if !found()
      append blank
      repl sgcode with 'COMMCD'
      repl scode  with alltr(str(recno()))
      repl sname  with fitm->hsncode
      repl parnam with substr(fitm->hsncode,1,15)
      repl tax with mitm->saltax
      repl cgst with mitm->cgst
      repl igst with mitm->igst
   endi
   repl mitm->gcode6 with mpcm->scode
   endsca
clos table all

@rowno,10 Say '**** Importing Company Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\Master_brand alia fpcm
sele sele(1)
use &datdev\saletype.&datext alia mpcm
index on scode to mpcm
sele fpcm
scan
	sele mpcm
	append blank
	repl sgcode with 'ZZZZZZ'
	repl scode with alltrim(str(fpcm->bid))
	repl sname with upper(fpcm->brand)
	repl parnam with upper(fpcm->brand)	
endsc
close tabl all

@rowno,10 Say '**** Importing COLOR Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\Master_color alia fpcm
sele sele(1)
use &datdev\saletype.&datext alia mpcm
dele all for sgcode='BAT-CL'
index on scode to mpcm
sele fpcm
scan
	sele mpcm
	append blank
	repl sgcode with 'BAT-CL'
	repl scode with alltrim(str(fpcm->cid))
	repl sname with upper(fpcm->color)
	repl parnam with upper(fpcm->color)	
endsc
close tabl all

@rowno,10 Say '**** Importing SIZE Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\barcode alia fpcm
index on substr(csize,1,10) to fpcm uniq
sele sele(1)
use &datdev\saletype.&datext alia mpcm
dele all for sgcode='BAT-SZ'
index on scode to mpcm
sele fpcm
sn=1
scan
	sele mpcm
	append blank
	repl sgcode with 'BAT-SZ'
	repl scode with alltri(str(sn))
	repl sname with upper(fpcm->csize)
	repl parnam with upper(fpcm->csize)	
	sn=sn+1
endsc
close tabl all

@rowno,10 Say '**** Importing Batch Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datatransferpath\barcode alia fsbal


sele sele(1)
use &datdev\pro.&datext alia mitm
index on str(code,9) to mitm

sele sele(1)
use &datdev\saletype.&datext alia stype
index on sgcode+sname to stype

sele sele (1)
sele * from stype where sgcode='BAT-CL' into curs mcolor readwr
index on scode to mcolor 
sele sele(1)
use &datdev\malter.&datext  alias altr 
DELE ALL
PACK 
INDEX ON CODE+BATCH TO ALTR

sele sele(1)
use &datdev\probat.&datext alia msbal
index on str(code,9)+SUBSTR(batchno,1,10) to msbal
r=0
sele fsbal
go top
scan &&&FOR BARCODE='KIDSJEANS91'
		lcolor=substr(alltri(fsbal.colr),1,3)
		msize='   '
		if seek('BAT-SZ'+substr(fsbal.csize+space(40),1,40),'stype')
			msize=substr(alltri(stype.scode),1,3)
*!*				IF BARCODE='KIDSJEANS91'
*!*					wait wind stype.sname+stype.scode+lcolor
*!*				ENDIF
		endif
	lstring=' '+substr(msize+space(3),1,3)+substr(lcolor+space(3),1,3)
  sele mitm
  seek str(fsbal.scatid,9)
  sele msbal
  seek str(fsbal.scatid,9)+substr(lstring+space(10),1,10)
  if .not. found()
      appe blan
      repl date with date()
      repl code with mitm->code
      repl name with mitm->name
      repl billname with mitm->billname
      repl product with mitm->product
      repl packing with mitm->packing
      repl pack with mitm->pack
      repl unit2 with mitm->unit2
      repl unit with mitm->unit
      repl decimal with 'Y'
      repl opening with val(fsbal->cqty)
      repl balance with opening
      repl o_a with opening
      repl b_a with opening
      repl batchno with substr(lstring+SPACE(10),1,10)+'#'
      repl mycode with fsbal->barcode
	  repl prate with val(fsbal->purprice)
	  repl ratea with val(fsbal->saleprice)
   	  repl mrp with val(fsbal->nmrp)
      repl misc1 with mitm->gcode
      repl supdat with ctod('')
      repl supinvo with ''
      repl supcode with ''
   else
      repl opening with opening+val(fsbal->cqty)
      repl balance with opening
      repl o_a with opening
      repl b_a with opening
      repl exp with ctod(fsbal->expiry)
	  repl prate with val(fsbal->purprice)
	  repl ratea with val(fsbal->saleprice)
   	  repl mrp with val(fsbal->nmrp)
      repl misc1 with mitm->gcode
    endi	
	sele altr 
	seek str(msbal.code,9)+msbal.batchno+subs(fsbal.barcode+space(20),1,20)
	IF !FOUND()   
    	appen blank
     	repl type with 'BTBRCD'
    	repl code with STR(MSBAL.code,9)
    	repl batch with msbal.batchno
     	repl name with subs(fsbal.barcode+space(20),1,20)
	endif
endsc

sele msbal
close table all

@rowno,10 Say '**** Importing Supplier Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alia mact
sele sele(1)
use &datatransferpath\supplier alia fact
sele sele(1)
use &datatransferpath\all_cities alia fct
inde on id to fct
sele sele(1)
use &datatransferpath\account_tranas alia fbal
inde on subs(party_id,1,10) to fbal for party_type='Supplier' and locid=location and sess_id=2
sele sele(1)
use &datdev\support.&datext alias support
index on aliase + str(sno,3) + lcode to support
sele fact
go top
scan
last=recno()
   sele mact
   append blank
   repl rate with 'Y'
   repl ordno with padr(fact->supid,6)
   repl fax2 with fact->supcode
   repl parnam  with fact->sname
   repl paradd with subs(fact->sadd,1,40)
   repl paradd1 with subs(fact->sadd,41,40)
   repl paradd2 with subs(fact->sadd,81)
   =seek(fact->city,'fct')
   repl city with fct->name
   repl dsm with fact->pincode
   repl sthed with  'TIN No.'
   repl csthed with 'CST  No.'
   repl Gsthed with 'GST  No.'
   repl cstno with ''
   repl stno with fact->tinno
   repl gstno with fact->gstn
   repl dlno with ''
   repl itno with fact->pano
   repl phone1 with subs(chrtran(fact->mobno,',',''),1,10)
   repl phone2 with fact->ladlineno
   repl phone4 with subs(fact->mobno,at(',',fact->mobno)+1,12)
   repl confir with ' '
   repl mailnam with parnam
   repl ref with 'Mr.'
   repl price with 'A'
   repl status with 'Y'
   repl adhed with 'Discount'
   repl duedays with 0
   mgrp=icase(fact->acc_type='Sundry Creditors ','D31',fact->acc_type='Sundry Deb','C6','J12')
   repl scode with mgrp
sele fbal
seek subs(alltr(str(fact->supid))+spac(10),1,10)
sum iif(val(tcredit_am)>0,val(tcredit_am),0),iif(val(tdebit_amo)>0,val(tdebit_amo),0)to cr,dr whil subs(party_id,1,10)=subs(alltr(str(fact->supid))+spac(10),1,10)
sele mact
repl opning with (dr-cr)
  *** for state code ***
	Sele Support
	Seek 'ORDER   ' + '  7' +  mact->ordno
	Append Blank
	Repl aliase with 'ORDER   '
	Repl Type with 'F'
	Repl lcode with mact->ordno
	Repl sno with 7
	Repl pcode with 15
	Repl remark with Subs(remark,1,32)+'DEF'+Iif(Subs(mact->Gstno,1,2)='  ',mstatecode,Subs(mact->Gstno,1,2))+'                                           '
******For Email*****	
	Sele support
	Append Blank
	Repl aliase With 'ORDER   '
	repl type With 'F'
	repl lcode With mact.ordno
	repl sno With 12
	repl remark With fact->email
	repl heading With Substr(Heading,1,21)+Iif(Empty(mact->gstno),'UG','NG')
endsc
close table all

@rowno,10 Say '**** Importing Customer Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alia mact
sele sele(1)
use &datatransferpath\master_customer alia fact
sele sele(1)
use &datatransferpath\all_cities alia fct
inde on id to fct
sele sele(1)
use &datatransferpath\account_tranas alia fbal
inde on subs(party_id,1,10) to fbal for party_type='Customer' and locid=location and sess_id=2
sele sele(1)
use &datdev\support.&datext alias support
index on aliase + str(sno,3) + lcode to support
sele fact
go top
scan
last=recno()
   sele mact
   append blank
   repl rate with 'Y'
   repl ordno with 'P'+padr(fact->custid,5)
   repl fax2 with padr(fact->custid,5)
   repl parnam  with fact->cname
   repl paradd with subs(fact->cadd,1,40)
   repl paradd1 with subs(fact->cadd,41,40)
   repl paradd2 with subs(fact->cadd,81)
   =seek(fact->city,'fct')
   repl city with fct->name
   repl dsm with fact->pincode
   repl sthed with  'TIN No.'
   repl csthed with 'CST  No.'
   repl Gsthed with 'GST  No.'
   repl cstno with ''
   repl stno with ''
   repl gstno with fact->gstin
   repl dlno with ''
   repl itno with ''
   repl phone1 with subs(chrtran(fact->mobno,',',''),1,10)
   repl phone2 with ''
   repl phone4 with subs(fact->mobno,at(',',fact->mobno)+1,12)
   repl confir with ' '
   repl mailnam with parnam
   repl ref with 'Mr.'
   repl price with 'A'
   repl status with 'Y'
   repl adhed with 'Discount'
   repl duedays with 0
   repl scode with 'C6'
sele fbal
seek subs(alltr(str(fact->custid))+spac(10),1,10)
sum iif(val(tcredit_am)>0,val(tcredit_am),0),iif(val(tdebit_amo)>0,val(tdebit_amo),0)to cr,dr whil subs(party_id,1,10)=subs(alltr(str(fact->custid))+spac(10),1,10)
sele mact
repl opning with abs(cr-dr)
  *** for state code ***
	Sele Support
	Seek 'ORDER   ' + '  7' +  mact->ordno
	Append Blank
	Repl aliase with 'ORDER   '
	Repl Type with 'F'
	Repl lcode with mact->ordno
	Repl sno with 7
	Repl pcode with 15
	Repl remark with Subs(remark,1,32)+'DEF'+Iif(Subs(mact->Gstno,1,2)='  ',mstatecode,Subs(mact->Gstno,1,2))+'                                           '
******For Email*****	
	Sele support
	Append Blank
	Repl aliase With 'ORDER   '
	repl type With 'F'
	repl lcode With mact.ordno
	repl sno With 12
	repl remark With fact->email
	repl heading With Substr(Heading,1,21)+Iif(Empty(mact->gstno),'UG','NG')
endsc
close table all
*******************
@rowno,10 Say '**** Importing Other Account Master  ****' Font 'Arial',12
rowno=rowno+1
sele sele(1)
use &datdev\order.&datext alia mact
sele sele(1)
use &datatransferpath\cashbook_subhead alia fact
sele sele(1)
use &datatransferpath\master_head alia fgrp
inde on hid to fgrp
sele sele(1)
use &datatransferpath\all_cities alia fct
inde on id to fct
sele sele(1)
use &datatransferpath\account_tranas alia fbal
inde on subs(party_id,1,10) to fbal for party_type='Ledger' and locid=location and sess_id=2
sele sele(1)
use &datdev\support.&datext alias support
index on aliase + str(sno,3) + lcode to support
sele fact
set filt to shstatus='Active'
go top
scan 
last=recno()
   sele mact
   append blank
   repl rate with 'Y'
   repl ordno with 'L'+padr(fact->shid,5)
   repl fax2 with padr(fact->shid,5)
   repl parnam  with fact->subhead
   repl paradd with ''
   repl paradd1 with ''
   repl paradd2 with ''
   repl mailnam with parnam
   repl ref with 'Mr.'
   repl price with 'A'
   repl status with 'Y'
   repl adhed with 'Discount'
   repl duedays with 0
   sele fgrp
   seek fact->hid
   mgroup=uppe(head)
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
						otherw
						mgrp='J12'
				endcase
      
			repl mact.scode with mgrp  
sele fbal
seek subs(alltr(str(fact->shid))+spac(10),1,10)
sum iif(val(tcredit_am)>0,val(tcredit_am),0),iif(val(tdebit_amo)>0,val(tdebit_amo),0)to cr,dr whil subs(party_id,1,10)=subs(alltr(str(fact->shid))+spac(10),1,10)
sele mact
repl opning with abs(cr-dr)
  *** for state code ***
	Sele Support
	Seek 'ORDER   ' + '  7' +  mact->ordno
	Append Blank
	Repl aliase with 'ORDER   '
	Repl Type with 'F'
	Repl lcode with mact->ordno
	Repl sno with 7
	Repl pcode with 15
	Repl remark with Subs(remark,1,32)+'DEF'+Iif(Subs(mact->Gstno,1,2)='  ',mstatecode,Subs(mact->Gstno,1,2))+'                                           '
endsc
close table all


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
**Eof**
**Author--Umesh Nath Goswami