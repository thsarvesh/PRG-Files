*!*	BOF : Medi RX.PRG .....Dated    : 24/04/2025   Author : SARVESH
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
datatransferpath=substr('D:\MIGRATION_DATA\MAR\MEDISOFT_ABHISHEK_GANJI\METADB25\'+space(95),1,95) &&rpos_path
datatransferext='DBF'
old_3 = 'Yes'
old_4 = 'Master Only      '
old_5 = firstdate
old_9 = lastdate
old_6 = '2'
outsonly='No '
old_12 = 'GST'
mstatecode='32'
removenull = 'NO'
@13,10 say 'METALINK Data Path      :'  font 'Courier',18 get datatransferpath  font 'courier',18
@14,10 say 'METALINK Extension      :'  font 'Courier',18 get datatransferext  font 'courier',18
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
@ 02,25 say 'Please Wait..Importing METALINK Data To Marg.....' font 'courier',14 colo 'W+/b'
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

rowno=5
@rowno,10 say '**** Importing Product/HSN ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alias mpcm
dele all for sgcode = 'COMMCD'
pack
index on sgcode + parnam + str(igst,5,2) to mpcm
sele sele (1)
use &datatransferpath\product.&datatransferext alias fitm
sele sele (1)
use &datatransferpath\gst.&datatransferext alias fgst
INDEX on gstkey TO fgst
sele sele (1)
use &datdev\pro.&datext alias mitm
zap
Index On Name to MItm
Sele FItm
GO TOP
Do While .NOT. Eof()
   last=RecNo()
   SELECT fgst
   SEEK fitm.gstid
   Sele MItm
      Append Blank
      Replace Mitm->Code with last
      Replace MItm->Name with ALLTRIM(STR(FItm->productkey))
      Replace Mitm->Product with FItm->name
      Replace Mitm->BillName with Fitm->name
      Replace Mitm->Unit with Fitm->Alias
      Replace Mitm->Gcode with ALLTRIM(STR(Fitm->mktdby))
      REPLACE Mitm->packing with Fitm->boxpack
      REPL MITM.BILLNAME WITH MITM.PRODUCT+MITM.PACKING
*      REPLACE Mitm->pack with val(Fitm->boxpack)
      REPLACE Mitm->Gcode5 with ALLTRIM(STR(Fitm->Category)) 
      REPLACE Mitm->rackno2 with Fitm->rackno 
      REPLACE Mitm->Saltax WITH fgst.sgstper
      replace Mitm->Purtax WITH fgst.sgstper
      replace Mitm->cgst WITH fgst.cgstper
      replace Mitm->igst WITH fgst.cgstper*2
      replace Mitm->Taxl WITH "T"
      REPLACE Mitm->Taxc WITH "T"
      replace mitm.ratee WITH FITM.SALE
      replace mitm.ratea WITH FITM.ptr
      replace mitm.ratef WITH FITM.pts
      REPLACE MITM.MRP WITH FITM.MRP
      REPLACE MITM.PRATE WITH FITM.cost
      REPLACE MITM.LPRATE WITH FITM.COST
      &&&& HSN-CODE
        sele mpcm
        seek 'COMMCD' + substr(fitm.hsn+space(15),1,15) + str(mitm.igst,5,2)
        if !found()
           append blank
           repl mpcm.sgcode with 'COMMCD',;
                mpcm.scode  with 'C'+alltrim(str(last)),;
                mpcm.sname  with substr(fitm.hsn+space(15),1,15)+ substr(fitm.hsn,1,15) +' '+ alltrim(str(mitm.igst,5,2)) ,;
                mpcm.parnam with substr(fitm.hsn,1,15),;
                mpcm.tax with mitm.saltax,;
                mpcm.cgst with mitm.cgst,;
                mpcm.igst with mitm.igst,;
                mpcm.tcode with 'No'
        endif
        repl mitm.gcode6 with mpcm.scode
	sele fitm
	skip
	enddo
close tables all
@rowno,10 say '**** Importing Company Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alias mpcm
Index On SCode to MPcm
sele sele (1)
use &datatransferpath\company.&datatransferext alias fpcm
Sele FPcm
GO TOP
Do While .NOT. Eof()
   Sele MPcm
   If .NOT. Found()
      Append Blank
      Replace Mpcm->SGCode with 'ZZZZZZ'
      Replace Mpcm->SCode  with ALLTRIM(STR(FPcm->companykey))
      Replace Mpcm->SName  with FPcm->name
      Replace Mpcm->ParNam with FPcm->name
   Endif
	Sele FPcm
	SKIP
Enddo
close tables all

@rowno,10 say '**** Importing Category Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alias mpcm
Index On SCode to MPcm
sele sele (1)
use &datatransferpath\productcategory.&datatransferext alias fpcm
Sele FPcm
GO TOP
Do While .NOT. Eof()
   Sele MPcm
   If .NOT. Found()
      Append Blank
      Replace Mpcm->SGCode with 'CATEGO'
      Replace Mpcm->SCode  with FPcm->code
      Replace Mpcm->SName  with FPcm->name
      Replace Mpcm->ParNam with FPcm->name
   Endif
	Sele FPcm
	SKIP
Enddo
close tables all
@rowno,10 say '**** Importing Batch Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datatransferpath\batches.&datatransferext alias fsbal
SET FILTER TO !EMPTY(quantity)
sele sele (1)
use &datdev\pro.&datext alias mitm
Index On name to mitm
sele sele (1)
use &datdev\probat.&datext alias msbal
Index On name+batchno to msbal
zap
r=0
Sele FSbal
GO TOP 
Do While .NOT. Eof()
    
   Sele MItm
   Seek ALLTRIM(STR(FSbal->productid))
   Sele MSbal
   Seek ALLTRIM(STR(FSbal->productid))+ SUBSTR(FSBAL.Batchnumbe+SPACE(12),1,12)
   IF .not. FOUND() 
   Append Blank
      replace MSbal->Code with Mitm->Code
      replace MSbal->Name with Mitm->Name
      replace MSbal->BillName with Mitm->BillName
      replace MSbal->Product with Mitm->Product
      REPLACE MSBAL->packing with Mitm->packing
      REPLACE Mitm->pack with Mitm->pack
      replace MSbal->Opening with FSbal->QUANTITY
      replace MSbal->Balance with FSbal->QUANTITY
      replace MSbal->o_a with FSbal->QUANTITY
      replace MSbal->b_a with FSbal->QUANTITY
      replace MSbal->BatchNo with FSbal->Batchnumbe
      replace MSbal->Exp with CTOD(ALLTRIM(("01")+'/'+IIF(LEN(ALLTRIM(STR(FSBAL.EXPIRYMONT)))<2,'0'+ALLTRIM(STR(FSBAL.EXPIRYMONT)),ALLTRIM(STR(FSBAL.EXPIRYMONT)))+'/'+ALLTRIM(STR(FSBAL.EXPIRYYEAR))))
      replace MSbal->pRate with FSbal->boxprice
      replace MSbal->lprate with FSbal->costprice
      replace MSbal->ratea with FSbal->retailerpr
      replace MSbal->ratee with FSbal->saleprice
      replace MSbal->Mrp with FSbal->mrp
      
     ELSE 
     
      replace MSbal->Opening with OPENING + FSbal->QUANTITY
      replace MSbal->Balance with BALANCE + FSbal->QUANTITY
      replace MSbal->o_a with O_A + FSbal->QUANTITY
      replace MSbal->b_a with B_A + FSbal->QUANTITY
   
    endif    
	sele fsbal
	skip
enddo
sele msbal
close tables all
@rowno,10 say '**** Importing Area Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\saletype.&datext alias mpcm
Index On SCode to MPcm

sele sele (1)
use &datatransferpath\area.&datatransferext alias fpcm

Sele FPcm
GO TOP
Do While .NOT. Eof()
   Sele MPcm
   If .NOT. Found()
      Append Blank
      Replace Mpcm->SGCode with 'AREA  '
      Replace Mpcm->SCode  with ALLTRIM(STR(FPcm->Areakey))
      Replace Mpcm->SName  with FPcm->name
      Replace Mpcm->ParNam with FPcm->name
   Endif
	Sele FPcm
	SKIP
Enddo
close tables all


@rowno,10 say '**** Importing MR ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\order.&datext alias mact
sele sele (1)
use &datatransferpath\Representative.&datatransferext alias fact
sele fact
go top
do while .not. eof()
   sele mact
   append blank
   repl mact.rate with 'Y'
   replace mact.ordno with 'S' + ALLTRIM(STR(fact.repkey))
   replace mact.parnam with fact.name
   REPLACE MACT.MAILNAM WITH Fact.name
   REPLACE MACT.PARADD WITH (FACT.doorno)+","+(FACT.street)
   REPLACE MACT.PARADD1 WITH FACT.city+","+FACT.PIN
   REPLACE MACT.PHONE1 WITH FACT.phone
   REPLACE MACT.PHONE2 WITH FACT.fax
   REPLACE MACT.PHONE3 WITH FACT.cell
   REPLACE mact.scode with "D32"
sele fact
skip
enddo
close tables all
@rowno,10 say '**** Importing Doctor Master ****' font 'Arial',10
rowno=rowno+1
sele sele (1)
use &datdev\maorder.&datext alias mdoc
set filt to scode='PRE#$~'
dele all
pack
index on scode to mdoc 
zap
sele sele (1)
use &datatransferpath\doctor.&datatransferext alias fdoc
sele fdoc
go top
do while .not. eof()
   sele mdoc
   append blank
   repl mdoc.scode with 'PRE#$~'
   repl mdoc.ordno with ALLTRIM(STR(fdoc.Doctorkey))
   repl mdoc.parnam with fdoc.name
   sele fdoc
skip
enddo
close tables all
@rowno,10 say '**** Importing Ledger Master ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\ACCLEDGER alias fact
sele sele(1)
use &datatransferpath\CUSTOMER alias FCUSTOM
INDEX ON code to fcustom
sele sele(1)
use &datatransferpath\PURCHASEHEAD alias fpur
INDEX ON CUSTOMERPR to fpur
sele sele(1)
use &datatransferpath\SALEHEAD alias fsal
INDEX ON CUSTOMERID to fsal
sele sele(1)
use &datdev\order.&datext alias mact 
Sele sele(1)
Use &datdev\support.&datext Alias tsupp
Index On aliase + Str(sno,3) + lcode To tsupp
sele fact
go top
scan
	=seek(fact->code,'fcustom')
	sele mact
   	append blank   	
   	if fact.accgroupid=9
   	replace mact.scode with 'C6'
   	ELSE
   	IF fact.accgroupid=13
   	replace mact.scode with 'D31'
   	ENDIF
   	ENDIF
   	repl mact.rate with 'Y'   	
   	repl mact.ordno with IIF(EMPTY(FACT.CSPROFILEI),FACT.CODE,ALLTRIM(STR(FACT.CSPROFILEI)))
   	repl mact.parnam  with fact.NAME
   	REPL MACT.AREA WITH alltrim(str(FCUSTOM.AREA))
   	REPL MACT.CITY WITH FCUSTOM.CITY
   	repl mact.paradd with FCUSTOM.DOORNO
   	repl mact.paradd1 with FCUSTOM.STREET
   	repl mact.dsm with FCUSTOM.pin
   	repl mact.sthed with  'TIN No.'
  	repl mact.gsthed with  'GST No.'
  	repl mact.csthed with 'CST  No.'
   	repl mact.mailNam with FCUSTOM.NAME
   	repl mact.ref with 'Mr.'  	
   	repl mact.price with 'A'
   	repl mact.status with 'Y' 
   	repl mact.dlno with alltrim(FCUSTOM.DLNO1)+','+alltrim(FCUSTOM.DLNO2)
   	repl mact.phone1 with FCUSTOM.PHONE
   	REPL MACT.FAX1 WITH FCUSTOM.FAX
   	REPL MACT.STNO WITH FCUSTOM.TINNO
   	REPL MACT.GSTNO WITH FCUSTOM.GSTIN
   	sele fpur
	seek fact.csprofilei
	SUM NETDUE TO TOT1 WHILE  CUSTOMERPR=FACT.CSPROFILEI
    sele fsal
	seek fact.csprofilei
    SUM NETDUE TO TOT2 WHILE CUSTOMERID=FACT.CSPROFILEI
    sele mact
   	if fact.accgroupid=13
   	replace mact.opning with -(TOT1)
   	replace mact.balance with -(TOT1)
   	else
   	if fact.accgroupid=9
   	replace mact.opning with TOT2
   	replace mact.balance with TOT2
   	ENDIF
   	ENDIF  	
   	&& Updating State
	Sele tsupp
	Seek 'ORDER   ' + '  7' +  mact.ordno
	Append Blank
	Repl aliase With 'ORDER   '
	Repl Type With 'F'
	Repl lcode With mact.ordno
	Repl sno With 7
	Repl pcode With 15
	Repl remark With Subs(remark,1,32)+"DEF"+Iif(Subs(MACT.GSTNO,1,2)='  ',MSTATECODE,Subs(MACT.GSTNO,1,2))+'                                           '  
    SELE FACT   	
endscan
close tables all
@rowno,10 say '**** Importing Supplier OS ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\purchasehead alias fout
sele mslip 
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan
   sele mpend
   append blank
   repl acgroup with 'D31'
   repl ord with padr(fout->CUSTOMERPR,6)
   repl ddate with fout->BILLDATE
   repl vcn with fout->BILLNO
   repl invtype with 'O'
   repl voucher  with vou
   repl svoucher with svou
   repl final with -(fout->PAYRUPEES)
   repl balance with -(fout->NETDUE)
   repl itemope with -(fout->PAIDAMOUNT)
   repl name with vcn
   vou=vou+5
   svou=svou+5
endsc
sele mslip 
repl voucher  with vou+5
repl svoucher with svou+5
close table all
@rowno,10 say '**** Importing Customer OS****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\salehead alias fcust
sele mslip 
go top
vou =voucher  + 10
svou=svoucher + 10
sele fcust
go top
scan for cashcredit=1 and payrupees#paidamount
   sele mpend
   append blank
   repl acgroup with 'C6'
   repl ord with padr(fcust->CUSTOMERID,6)
   repl ddate with fcust->BILLDATE
   repl vcn with fcust->BILLNO
   repl invtype with 'O'
   repl voucher  with vou
   repl svoucher with svou
   repl final with (fcust->PAYRUPEES)
   repl balance with (fcust->NETDUE)
   repl itemope with (fcust->PAIDAMOUNT)
   repl name with vcn
   vou=vou+5
   svou=svou+5
endsc
sele mslip 
repl voucher  with vou+5
repl svoucher with svou+5
close table all

@rowno,10 say '**** Importing Ledger Balance ****' font 'Arial',10
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
*!*	EOF : METALINK.PRG .....Dated    : 24/04/2025   Author : SARVESH




