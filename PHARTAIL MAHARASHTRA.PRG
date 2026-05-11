Clea
Close Data
Set Talk Off
Set Date To brit
Set Cent On
Set Dele On
Set Cpdialog Off
Set Safe Off
Close Table All
Clea
if type('FINALCP')='U'
	firstdate = ctod('01/04/2025')                                                &&&Uncomment It For Running Outside Marg
	lastdate  = ctod('31/03/2026')                                                &&&Uncomment It For Running Outside Marg
	datdev=subst('d:\transfer\'+Space(60),1,60)                            &&&Uncomment It For Running Outside Marg
	datext = 'dbf'
endi
sure = spac(4)
datatransferpath=Substr('D:\2025\March\PHARTAIL_KA\data\'+Space(50),1,50)
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'NO '
old_5 = firstdate
old_11 = lastdate
fm    = 'NO '
old_6 = '2'
tfVol = 'No '
old_A = '109'
old_9 = 'G'
scalc='9'
pcalc='2'
mstatecode='27'
removenull='NO '
clea
TfAcc='Yes'
@ 10,10 say 'Phartail Data From          :' font 'courier',10 get datatransferpath font  'courier',11.5 
@ 11,10 Say 'Phartail Data Ext.          :'Font 'courier',10 Get datatransferext Font 'courier',11.5
@ 12,10 say 'Only Master                 :' font 'courier',10 get  Old_4 font 'courier',11.5 pict '@M NO,YES '
@ 13,10 say 'F.Y.BEGIN FROM              :' font 'courier',10 get  Old_5 font 'courier',11.5
@ 14,10 say 'F.Y.END TO                  :' font 'courier',10 get  Old_11 font 'courier',11.5
@ 15,10 say 'Sale Calc.Type              :' font 'courier',10 get  scalc font 'courier',11.5
@ 16,10 say 'Purc.Calc.Type              :' font 'courier',10 get  pcalc   font 'courier',11.5
@ 17,10 Say 'State                       :'font 'courier',10 Get mstatecode Font 'courier',11.5
@ 18,10 SAY 'GST/VAT                     :'font 'courier',10 get  Old_9 font 'courier',11.5 pict '@M G ,V '
@ 19,10 Say 'Removenull Value            :'font 'courier',10 Get removenull Pict '@^ YES,NO   ' Font 'courier',11.5
@ 21,10 say 'Type SURE                   :'font 'courier',10 get Sure pict '@x! ' font 'courier',11.5
read
datatransferpath =Alltrim(datatransferpath)
datdev =Alltrim(datdev)
datext=Alltrim(datext)
datatransferext=Alltrim(datatransferext)
CLEAR
@ 04,15 Say '*** Phartail Data Migration Program ***' Font 'courier',18
If Lastkey()=27 .And. sure#'SURE'
	Return
Endif
CLEAR
if type('FINALCP')#'U'
	=starttransfer()  &&COMMENT IT FOR RUNNING OUTSIDE MARG
endif
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
@ 02,22 say 'Please Wait Importing PharTail  Data To Marg.....' font 'courier',14 colo 'W+/b'
set colo to
Sele Sele(1)
use &datdev\mdis.&datext
zap
use &datdev\dis.&datext
zap
use &datdev\gLedger.&datext
zap
use &datdev\pend.&datext
zap
use &datdev\pendings.&datext
zap
use &datdev\SaleType.&datext
dele all for sgcode='AREA'
dele all for sgcode='ROUT'
dele all for sgcode='STATIO'
dele all for sgcode='ZZZ'
dele all for sgcode='CATEGO'
dele all for sgcode='SALT'
pack
use  &datdev\Probat.&datext
zap
use &datdev\Pro.&datext
zap
use &datdev\order.&datext
dele all
use &datdev\Rate.&datext
zap
use &datdev\SaleType.&datext
dele all for sgcode='ZZZZZZ'
dele all for sgcode='AREA'
dele all for sgcode='ROUt'
close DATA
Set Colo To


ROWNO=1
@Rowno,10 say '**** Importing Company  ****' font 'courier',12
Rowno=Rowno+1

sele sele(1)
use &datatransferpath\CompanyMaster alias fComp
sele sele(1)
use &datdev\SaleType.&datext alias sType excl
dele all for sgcode='ZZZZZZ'
pack
sele fComp
scan
	m.sgcode='ZZZZZZ'
	m.scode=MfgCode
	m.sName=CompanyNam
	m.parnam=alltrim(CompanyNam)
	sele sType
	appen blank
	gath memvar
endscan
close data

@Rowno,10 say '**** Importing Salt/Composition ****' font 'courier',12
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\PreparationMaster alias fSalt
sele sele(1)
use &datdev\SaleType.&datext alias sType excl
dele all for sgcode='SALT'
pack
sele fSalt
scan
	m.sgcode='SALT'
	m.scode=alltrim(str(Preparatio))
	m.sName=Preparati2
	m.parnam=Preparati2
	sele sType
	appen blank
	gath memvar
endscan
CLOSE DATA

@Rowno,10 say '**** Importing Category ****' font 'courier',12
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\ItemTypeMaster alias fCategory
sele sele(1)
use &datdev\SaleType.&datext alias sType
dele all for sgcode='CATEGO'
pack
sele fCategory
scan
	m.sgcode='CATEGO'
	m.scode=alltrim(str(ItemTypeCo))
	m.sName=ItemTypeNa
	m.parnam=ItemTypeNa
	sele sType
	appen blank
	gath memvar
endscan
CLOSE DATA


@Rowno,10 say '**** Importing Patients ****' font 'courier',12
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\PatientMaster alias fPatient
sele sele(1)
use &datdev\MaOrder.&datext alias mAct
dele all for scode='PET#$~'
pack
sele fPatient
scan
	m.scode='PET#$~'
	m.Ordno=space(06)
	m.parnam=PatientNam
	m.Mailnam=PatientNam
	m.Form=str(PatientCod,10)
	sele mAct
	appen blank
	gath memvar
endscan
CLOSE DATA


@Rowno,10 say '**** Importing Doctor ****' font 'courier',12
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\DoctorMaster  alias fDoctor
sele sele(1)
use &datdev\MaOrder.&datext alias mAct
dele all for scode='PRE#$~'
pack
sele fDoctor
scan
	m.scode='PRE#$~'
	m.Ordno=space(06)
	m.parnam=alltrim(DoctorName)+' '+iif(isnull(Specializa),'',alltrim(Specializa) )
	m.City=iif(isnull(Address1),'',alltrim(Address1))+' '+iif(isnull(PhoneResi),'',alltrim(PhoneResi))+' '+iif(isnull(PhoneClini),'',alltrim(PhoneClini))
	m.Form=str(DoctorCode,10)
	sele mAct
	appen blank
	gath memvar
endscan
CLOSE DATA


@Rowno,10 say '**** Importing Items/Product Master ****' font 'courier',12
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\ItemMaster alias fItem
sele sele(1)
use &datatransferpath\StorageMaster alias fRack
index on StorageCod to fStore
sele sele(1)
use &datdev\Pro.&datext alias Pro excl
dele all
sele fItem

scan
	m.Code=int(ItemCode)
	m.Name=alltrim(str(ItemCode))
	m.Product=ItemDesc
	m.Packing=Packing
	m.BillName=alltrim(ItemDesc)+' '+alltrim(Packing)
	m.gcode=MfgCode
	m.gcode3=alltrim(str(Preparatio))
	m.gcode5=alltrim(str(ItemTypeCo))
	if seek(StorageCod,'fRack')
		m.RackNo=fRack.StorageNam
	else
		m.RackNo=''
	endif
	m.pack=ConvUnit
	sele Pro
	appen blank
	gath memvar
endscan
CLOSE DATA


@Rowno,10 say '**** Importing Items/Product Stock/Batch ****' font 'courier',12
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\BatchMaster alias fBatch
sele sele(1)
use &datdev\Pro.&datext alias Pro
index on str(code,9) to Pro
sele sele(1)
use &datdev\Probat.&datext alias Probat excl
dele all
pack
sele fbatch
scan
	if seek(str(int(ItemCode),9),'Pro')
		m.Name=Pro.name
		m.Product=Pro.product
		m.pack=Pro.pack
		m.BillName=Pro.BillName
		m.Code=int(ItemCode)
		m.BatchNo=BatchNo
		m.mycode=barcode
		m.Exp=iif(isnull(Expiry ),ctod('  /  /    '),Expiry)
		m.Opening=iif(Old_4='N',Opening,CurrentSto)
		m.Balance=iif(Old_4='N',Opening,CurrentSto)
		m.o_a=iif(Old_4='N',Opening,CurrentSto)
		m.b_a=iif(Old_4='N',Opening,CurrentSto)
		m.Mrp=Mrp
		m.RateA=SaleRate&&*Convunit
		m.prate=VrPur*Convunit
		m.LpRate=Landing/Convunit 
		m.supcode=alltrim(str(purchaseac))
		m.date=lastpurcha
		m.supinvo=purcinv
		m.mycode=barcode
if OLD_9='V'
        m.SalTax=taxperc
		M.PURTAX=taxperc
		m.cgst=0.00
		m.igst=0.00
ELSE
		m.SalTax=taxperc/2
		m.cgst=taxperc/2
		m.igst=taxperc
ENDIF
		sele Probat
		appen blank
		gath memvar
		sele Pro
		repl SalTax with m.SalTax,CGST with m.CGST,IGST with m.IGST,Taxl with iif(m.SalTax>0,'T','P'),Mrp with m.Mrp,RateA with m.RateA,LpRate with m.LpRate,prate with m.prate
	ENDIF
	
endscan
CLOSE DATA

sele sele(1)
  use &datdev\pro.&datext alias mitm
  inde on name to mitm
sele sele(1)
  use &datdev\saletype.&datext alias mslt
  inde on sgcode+parnam+str(igst,5,2) to mslt
sele sele(1)
  use &datatransferpath\itemmaster alias fitm
go top
scan
sele mitm
seek subs(alltrim(str(fitm.itemCode))+spac(10),1,10)
if foun()
*****Hsn Transfer*****
    sele mslt
    seek 'COMMCD' + substr(fitm->hsn_code+space(15),1,15) + str(mitm->igst,5,2)
   if !found()
      append blank
      repl sgcode with 'COMMCD'
      repl scode  with 'H'+alltrim(str(recno()))
      repl sname  with substr(fitm->hsn_code+space(15),1,15)+substr(fitm->hsn_code,1,15) +' '+ alltrim(str(mitm->igst,5,2))+'%'
      repl parnam with substr(fitm->hsn_code,1,15)
      repl tax with mitm->saltax
      repl cgst with mitm->cgst
      repl igst with mitm->igst
      repl tcode with 'No'
   endi 
   repl mitm->gcode6 with mslt->scode 
 endi
endsc


@Rowno,10 say '**** Importing Account Ledgers  ****' font 'courier',12
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\LedgerMaster alias fAct
sele sele(1)
use &datatransferpath\Tacb alias fBal
index on AccountCod to fBal
sele sele(1)
use &datdev\order.&datext alias mAct excl
dele all
pack

sele fAct
scan
	mscode=''
	m.scode=''
	m.Ordno=alltrim(str(AccountCod))
	m.City=iif(isnull(City),'',City)
	m.Mailnam=AccountNam
	m.parnam=alltrim(m.Mailnam)+' '+alltrim(m.City)
	m.ParAdd=iif(isnull(Address1),'',Address1)
	m.ParAdd1=iif(isnull(Address2),'',Address2)
	m.CstHed='TIN No'
	m.Cstno=iif(isnull(Stno),'',Stno)
	m.gstno=iif(isnull(gstin_no),'',gstin_no)
	m.Phone1=iif(isnull(Phone),'',Phone)
	m.DlNo=alltrim(iif(isnull(DrugLic1),'',DrugLic1))+' '+alltrim(iif(isnull(DrugLic2),'',DrugLic2))
	if GroupCode=30001
		m.scode='C6'
	else
		if GroupCode=30003
			m.scode='D31'
		else
			if GroupCode=30010
				m.scode='J11'
			else
				m.scode=''
			endif
		endif
	endif
	if seek(AccountCod,'fBal')
		if Old_4='N'
			m.Opning=-fBal.OpeningBal
			m.Balance=-fBal.OpeningBal
		else
			m.Opning=-fBal.CurrentBal
			m.Balance=-fBal.CurrentBal
		endif
	else
		m.Opning=0
		m.Balance=0
	endif
	sele mAct
	appen blank
	gath memvar
*!*	If Seek(fAct.AccountCod,'fBal')
*!*	   If old_4='Y'
*!*	      repl opning with  -fBal.CurrentBal,balance with -fBal.CurrentBal
*!*	   Else
*!*		  Repl opning with -fBal.OpeningBal,balance with -fBal.OpeningBal
*!*	   Endif
*!*	Endif
endscan
CLOSE DATA


@Rowno,10 say '**** Importing Series ****' font 'courier',12
Rowno=Rowno+1

sele sele(1)
use &datatransferpath\Seriesmaster alias Series

sele sele(1)
use &datdev\SaleType.&datext alias sType
sele sType
index on sgcode+scode to sType
dele all for sgcode='SERIES'
pack
sele Series
set filt to seriescode#82 and Seriescode#83 and Seriescode#84
go top
scan
	m.sgcode='SERIES'
	m.scode=Prefix
	m.parnam=Prefix
	m.sName=seriesname
	sele sType
	appen blank
	gath memvar
endscan
CLOSE DATA



if Old_4='N'
	do Tr_Accounts
endif


proc Tr_Accounts
@Rowno,10 say '**** Importing Inventory Transactions  ****' font 'courier',12
Rowno=Rowno+1
sele sele(1)
use &datdev\slipno.&datext alias mSlip
go bott
m.Voucher=Voucher+5
m.sVoucher=sVoucher+10
sele sele(1)
use &datdev\mdis.&datext alias mdis
dele all
pack
sele sele(1)
use &datdev\dis.&datext alias dis
dele all
sele sele(1)
use &datdev\Pro.&datext alias Pro
index on code to Pro
sele sele(1)
use &datdev\MaOrder.&datext alias mAord
index on scode+form to mAord
sele sele(1)
use &datatransferpath\Invoice alias fSal
SET FILTER TO INVDATE>=OLD_5 AND invdate<=old_11 
sele sele (1)
use &datatransferpath\batchmaster.dbf alias fsbal
index on str(itemcode,9)+substr(batchno,1,12) to fsbal
sele sele(1)
use &datatransferpath\ItemTrsc  alias fDis
index on str(trsctype,5)+invcode to fDis
sele select(1)
use &datdev\support.&datext alias support
index on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to supp
seek 'F' + 'BATCHPRT'
if !found()
    append blank
    repl type with 'F',;
        aliase with 'BATCHPRT'
endif
repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)

sele sele(1)
	use &datatransferpath\trac alias fLed

sele sele(1)
	use &datdev\gLedger.&datext alias gle
	sele gle
	dele all
	pack

sele fSal
go top
Scan for seek(str(trsctype,5),'fDis')
	store 0 to m.final,m.Addis,m.bddis,m.cddis,m.sddis,m.Packing,m.freight,m.oth
	store '' to m.vcn,m.codep,m.salun
	m.vcn=invcode
	m.Date=InvDate
	m.final=Amount
	m.account='N'
	if grossamoun<>0
		m.Addis=(disc*100)/grossamoun
	else
		m.Addis=0
	endif

    do case
	case  trsctype=42 or trsctype=36    &&'CR-' $fSal->prefix or 'CS'$ fSal->prefix or 'CSC'$ fSal->prefix or 'RS'$ fSal->prefix or 'RT'$fSal->prefix or 'TLO'$ prefix
		m.Type='S'
		m.ltype='9'
	case trsctype=31   &&'SLR'$fsal->PRefix
		m.Type='R'
		m.ltype='9'
	case trsctype=46 or trsctype=81 or trsctype=33  &&'GP'$Prefix or 'GPB'$prefix or 'PB'$prefix or 'PIN'$prefix or 'PUR'$prefix or 'FLO'$pRefix
		m.Type='P'
		m.ltype='2'
	case trsctype=43
		m.Type='B'
		m.ltype='2'
	case trsctype=44 or trsctype=45
		m.Type='Q'
		m.ltype='2'
	case trsctype=32
		m.Type=''
		m.ltype='2'
*!*
*!*	     case 'PRR'$Prefix
*!*	        &&Sales Return Exp/brk=W
*!*	     Other
*!*	         m.Type=' '
	endcase
	m.codep=alltrim(str(AccountCod))
	if 'TLO'$fSal->Prefix
		m.salun='ST#12'
	else
		if 'FLO'$Prefix
			m.salun='PT#12'
		else
			m.salun=''
		endif
	endif
	if returnamou#0
		m.Packing=-returnamou
	else
		m.Packing=0
	endif
	if seek('PET#$~'+str(PatientCod,10),'maord')
		m.Docu=str(PatientCod,10)+narration2          &&+subs(mAord->parnam,1,45)
	else
		m.Docu=space(10)+narration2
	endif

	if seek('PRE#$~'+str(DoctorCode,10),'maord')
		m.Docu1=str(DoctorCode,10)+subs(mAord->parnam,1,45)
	else
		m.Docu1=space(10) 
	endif
	m.other=-(lessamount+crnote)
	m.packing=addamount
	sele mdis
	appen blank
	gath memvar
	repl sale with iif(type='P','z','Z')
    sele support
    appe blank
    repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash

	sele fDis
	seek str(fSal->trsctype,5)+fSal->invcode
	scan while trsctype=fSal->trsctype and invcode=fSal->invcode
		=seek(str(fdis.itemcode,9)+substr(fdis.batchno,1,12),'fsbal')
		m.Code=int(ItemCode)
		m.flg=iif(m.Type='S','G',m.Type)
		m.tax='T'
		m.batch=BatchNo
		m.Qty=Qty
		m.Free=FreeQty
		m.Rate=Rate*ConvUnit
		m.pack=ConvUnit
		m.mrp=fsbal.mrp
		m.exp=fsbal.expiry
if old_9='V'
        m.ssta=PurTax
		m.disc1=DiscPer

else
		m.ssta=igst_per/2
		m.cgst=igst_per/2
		m.disc1=DiscPer
endi
		sele dis
		appen blank
		gath memvar
	endscan
	m.Voucher=m.Voucher+5
	m.sVoucher=m.sVoucher+10
endscan
@Rowno,10 say '**** Importing Account Transactions  ****' font 'courier',12
Rowno=Rowno+1

sele fLed
set filt to trsctype=82 or trsctype=83 or trsctype=84
go top
m.Voucher=m.Voucher+5
m.sVoucher=m.sVoucher+10
Scan
	if fLed->trsctype=82
		sele gle
		appen blank
		repl Voucher with m.Voucher,cd with 'C',date with fLed->InvDate,code with alltrim(str(fLed->AccountCod)),Credit  with fLed->Amount,book with 'R',code1 with alltrim(str(fLed->OppAcc)),;
			remark1 with alltrim(fLed->invcode)+' '+alltrim(fLed->Narration1),Remark2 with alltrim(fLed->narration2)

		appen blank
		repl Voucher with m.Voucher,cd with 'D',date with  fLed->InvDate,code with alltrim(str(fLed->OppAcc)),Debit  with fLed->Amount,book with 'R',code1 with alltrim(str(fLed->AccountCod)),;
			remark1 with alltrim(fLed->invcode)+' '+alltrim(fLed->Narration1),Remark2 with alltrim(fLed->narration2)
	else
		if fLed->trsctype=83
			sele gle
			appen blank
			repl Voucher with m.Voucher,cd with 'D',date with  fLed->InvDate,code with alltrim(str(fLed->AccountCod)),Debit  with abs(fLed->Amount),book with 'P',code1 with alltrim(str(fLed->OppAcc)),;
				remark1 with alltrim(fLed->invcode)+' '+alltrim(fLed->Narration1),Remark2 with alltrim(fLed->narration2)

			appen blank
			repl Voucher with m.Voucher,cd with 'C',date with  fLed->InvDate,code with alltrim(str(fLed->OppAcc)),Credit  with abs(fLed->Amount),book with 'R',code1 with alltrim(str(fLed->AccountCod)),;
				remark1 with alltrim(fLed->invcode)+' '+alltrim(fLed->Narration1),Remark2 with alltrim(fLed->narration2)
		else
			if fLed->trsctype=84
*!*					sele gle
*!*					appen blank
*!*					repl Voucher with m.Voucher,cd with iif(fLed->Amount>0,'D','C'),date with  fLed->InvDate,code with alltrim(str(fLed->AccountCod)),Debit  with iif(fLed->Amount>0,fLed->Amount,0),;
*!*						Credit with iif(fLed->Amount>0,0,abs(fLed->Amount))  book with 'J',code1 with alltrim(str(fLed->OppAcc)),;
*!*						remark1 with alltrim(fLed->invcode)+' '+alltrim(fLed->Narration1),Remark2 with alltrim(fLed->narration2)

*!*					appen blank
*!*					repl Voucher with m.Voucher,cd with iif(fLed->Amount>0,'C','D'),date with  fLed->InvDate,code with alltrim(str(fLed->OppAcc)),;
*!*						Credit  with iif(fLed->Amount>0,abs(fLed->Amount),0),;
*!*						Debit with iif(fLed->Amount>0,0,abs(fLed->Amount)),book with 'R',code1 with alltrim(str(fLed->AccountCod)),;
*!*						remark1 with alltrim(fLed->invcode)+' '+alltrim(fLed->Narration1),Remark2 with alltrim(fLed->narration2)
			endif

		endif
	endif
	m.Voucher=m.Voucher+5
	m.sVoucher=m.sVoucher+10
endscan


sele mSlip
go bott
repl Voucher with m.Voucher,sVoucher with m.sVoucher

CLOSE DATA


proce removenull
CLOSE DATA

use &datatransferpath\SeriesMaster
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

use &datatransferpath\Trac
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

use &datatransferpath\Invoice
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


use &datatransferpath\ItemTrsc
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

use &datatransferpath\DoctorMaster
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

use &datatransferpath\ItemMaster
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

use &datatransferpath\BatchMaster
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

Proc  rem_null
a = Afields(arr)
For i = 1 To a
	mfldname = arr(i, 1)
	Do Case
	Case Inlist(arr(i,2), "C","V","M")
		Replace All &mfldname With '' For Isnull(&mfldname)
	Case Inlist(arr(i,2), "B","N","I","F","Y","M")
		Replace All &mfldname With 0 For Isnull(&mfldname)
	Case Inlist(arr(i,2), "D","T","M")
		Replace All &mfldname With Ctod('') For Isnull(&mfldname)
	Endcase
Endfor
