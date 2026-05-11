*!*	BOF :Shiva.PRG Pharma Retail Tamilnadu .....Author Santosh Srivastava
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
*!* your commands
set talk off
set date to brit
set cent on
set dele on
set safe off
set cpdi off
set color to
Sele Sele(1)
Create Curs mycurs  (Setup c(50),Value c(4))
Sele mycurs
Sele mycurs
Appe Blank
Repl  Setup With 'Item Wise Double Discount ',Value With 'Y'
Appen Blank
Repl  Setup With 'Volume discount 1st ',Value With 'L'
Appen Blank
Repl  Setup With 'Ask discount in Amoun ',Value With 'N'
Brow Font 'COURIER',18    Nomodify
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&77
if type('FINALCP')='U'
	firstdate=ctod('01/04/2024')
	lastdate=ctod('31/03/2025')
	datdev='d:\TRANSFER\'
	datext='DBF'
endif
SURE='SURE'
datatransferpath =substr('D:\2025\Feb\Siva\Data\'+space(90),1,90)
datatransferext='DAT'
datatransfermdb='No '
old_3 = 'YES'
old_4 = 'No '
old_5 = FIRSTDATE
old_6 = LASTDATE 
old_7 = 'G' 
softtype='Retail   ' 
scalc='9' 
pcalc='2'
mstatecode='33'
mrgmdbfile=space(100)
mrgmdbpwd=space(30)
opasclosing='No '
Clear
Close data
mVersion='V01'
Removenull='No '
*!*	@06,10 say 'Convert DBF From MDB  :' font 'Courier',18 get datatransfermdb  pict '@m No ,Yes'  font 'cOURIER',18  
@07,10 SAY 'Shiva Data Path      :' font 'Courier',18  get datatransferpath  font 'courier',18 &&&&valid mdbsqlconvert(1)
@08,10 SAY 'Shiva Extension      :' font 'Courier',18  get datatransferext  font 'courier',18
@09,10 SAY 'With Outstanding Y/N :' font 'Courier',18  get old_3 PICT '@m YES,NO '  font 'Courier',18 
@10,10 SAY 'F-Full M-Master      :' font 'Courier',18  get old_4 PICT '@m No ,Yes'  font 'Courier',18 
@11,10 SAY 'F.Y.BEGIN Date       :' font 'Courier',18  get old_5  font 'Courier',18 
@12,10 SAY 'F.Y.End   Date       :' font 'Courier',18  get old_6   font 'Courier',18 
@13,10 SAY 'G-GST  V-Vat         :' font 'Courier',18  get old_7  font 'Courier',18 
@14,10 SAY 'State Code           :' font 'Courier',18  get mstatecode   font 'Courier',18 
@15,10 SAY 'Sales Calculation    :' font 'Courier',18  get scalc   font 'Courier',18 
@16,10 SAY 'Purch.Calculation    :' font 'Courier',18  get pcalc   font 'Courier',18 
*@17,10 SAY 'Wholesale/Retail     :' font 'Courier',18  get Softtype PICT '@m Wholesale,Retail   '   font 'Courier',18 
@17,10 SAY 'Update Closing       :' font 'Courier',18  get opasClosing  PICT '@^ No ,Yes'   font 'Courier',11 
@18,10 SAY 'Type SURE            :' font 'courier',18  get sure Pict '@x!' font 'courier',18
Read
Clear
Close data
datatransferpath=alltrim(datatransferpath)
datatransferext=alltrim(datatransferext)
datdev= alltrim ( datdev  )
datext= alltrim ( datext )
if !dire(datatransferpath)
	md &datatransferpath
endif
if lastkey() = 27 or  upper( sure ) # 'SURE'
	return
endif
clear
*!*	=starttransfer()
rowno=5
@ 02,22 say 'Please Wait Importing Shiva Data To Marg.....' font 'Arial',14 colo 'W+/G'
set colo to
sele sele(1)
use &datdev\GLMONTH.&datext
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
dele ALL FOR TYPE='#' AND aliase='DAT/F'
dele all for aliase='ORDER'
pack
Close Data

*!*	@RowNo,10 say '**** Importing Product Company ****' font 'Arial',12
*!*	Rowno=rowno+1
*!*	sele sele(1)
*!*	use &datatransferpath\compmast.&datatransferext alias fcomp 
*!*	sele sele(1)
*!*	use &datdev\saletype.&datext alias stype 
*!*	sele fcomp
*!*	scan
*!*	  sele stype
*!*	  appen blank 
*!*	  repl sgcode with 'ZZZZZZ'
*!*	  repl scode with 'C'+fcomp.comno 
*!*	  repl sname with fcomp.comname 
*!*	  repl parnam with fcomp.comname
*!*	  
*!*	endscan
*!*	close table all 


@RowNo,10 say '**** Importing Product Category ****' font 'Arial',12
Rowno=rowno+1
sele sele(1)
use &datatransferpath\diag.&datatransferext alias fcat 
sele sele(1)
use &datdev\saletype.&datext alias stype 
sele fcat
scan
sele stype
appen blank 
repl sgcode with 'CATEGO' 
repl scode with 'D'+fcat.dcode 
repl parnam with fcat.dname 
repl sname with fcat.dname
endscan 
close table all 

@RowNo,10 say '**** Importing Doctor Master ****' font 'Arial',12
Rowno=rowno+1
sele sele(1)
use &datatransferpath\docmast.&datatransferext alias fdoc 
sele sele(1)
use &datdev\order.&datext alias maord 
sele fdoc 
scan
 sele maord 
 appen blank 
 repl scode with 'PRE#$~'
 repl parnam with fdoc.docname 
 repl paradd with allt(fdoc.docadd1)+' '+allt(fdoc.docadd2)
 repl form with fdoc.docno
endscan
close table all 

@RowNo,10 say '**** Importing Product Salt ****' font 'Arial',12
Rowno=rowno+1
sele sele(1)
use &datatransferpath\group.&datatransferext alias fsalt 
sele sele(1)
use &datdev\saletype.&datext alias stype 
sele fsalt
scan
 sele stype
 appen blank 
 repl sgcode with 'SALT' 
 repl scode with 'S'+fsalt.gpcode 
 repl sname with fsalt.gpname 
 repl parnam with fsalt.gpname
endscan
close table all 

@RowNo,10 say '**** Importing Product  ****' font 'Arial',12
Rowno=rowno+1
sele sele(1)
use &datatransferpath\medimast.&datatransferext alias fitm 
sele sele(1)
use &datdev\pro.&datext alias mitm 
sele sele(1)
use &datdev\saletype.&datext alias stype 
index on sgcode+sname+str(igst,6,2) to stype
sele sele(1)
use &datatransferpath\tfile.&datatransferext alias ftax 
index on tcode to ftax
sele fitm
xRec=1
scan
  =seeK(tcode,'ftax')
  sele mitm
  appen blank 
  repl code with recno() 
  repl name with fitm.mdcode 
  repl product with fitm.mdname 
  repl packing with allt(fitm.packg)
  repl billname with product+packing 
*!*	  repl pack with fitm.packg
  repl gcode3 with 'S'+fitm.gpcode 
  repl rackno with fitm.rack
*!*	  repl gcode with 'C'+fitm.comno 
*!*	  repl minimum with fitm.minqty 
  repl gcode5 with 'D'+fitm.dcode 
  repl igst with ftax.igst 
  repl saltax with ftax.igst/2 
  repl cgst with ftax.igst/2
  sele stype 
  seek 'COMMCD'+subs(fitm.hsn+space(40),1,40)+str(mitm.igst,6,2) 
  if !found()
    appen blank 
    repl sgcode with 'COMMCD' 
    repl scode with 'H'+alltrim(Str(recno()))
    repl parnam with fitm.hsn 
    repl sname with fitm.hsn 
    repl igst with mitm.igst 
    repl tax with mitm.igst/2 
    repl cgst with mitm.igst/2 
 endif
 repl gcode with stype.scode     
endscan
Close Table All 


@RowNo,10 say '**** Importing Supplier ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\supmast.&datatransferext alias fact
sele sele(1)
use &datdev\order.&datext alias mact 
sele sele(1)
use &datdev\support.&datext alias support 
sele fact
scan
  sele mact 
  appen blank 
  repl scode with 'D31' 
  repl ordno with fact.supno
  repl parnam with fact.supname
  repl mailnam with fact.supname
*!*	  repl paradd with fact.supadd1
*!*	  repl paradd1 with fact.supadd2 
*!*	  repl paradd2 with fact.supadd3
  repl gsthed with 'GST No:' 
*!*	  repl gstno with fact.tngst
*!*	  repl phone1 with fact.sphone 
  
endscan
close table all

@RowNo,10 say '**** Importing Batch/Stock-1  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat1+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat1 
    repl exp with fsbal.exp1 
    repl mrp with fsbal.mrp1 
    repl prate with fsbal.prate1
    repl ratea with fsbal.srate1
    repl lprate with fsbal.prate1
    repl opening with fsbal.qty1
    repl o_a with fsbal.qty1
    repl balance with fsbal.qty1
    repl b_a with fsbal.qty1
 else
    repl opening with opening+fsbal.qty1
    repl o_a with o_a+fsbal.qty1
    repl balance with balance+fsbal.qty1
    repl b_a with b_a+fsbal.qty1
 endif 
endscan
Close Table all 

@RowNo,10 say '**** Importing Batch/Stock-2  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat2+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat2 
    repl exp with fsbal.exp2
    repl mrp with fsbal.mrp2 
    repl prate with fsbal.prate2
    repl ratea with fsbal.srate2
    repl lprate with fsbal.prate2
    repl opening with fsbal.qty2
    repl o_a with fsbal.qty2
    repl balance with fsbal.qty2
    repl b_a with fsbal.qty2
 else
    repl opening with opening+fsbal.qty2
    repl o_a with o_a+fsbal.qty2
    repl balance with balance+fsbal.qty2
    repl b_a with b_a+fsbal.qty2
 endif 
endscan
Close Table all 
@RowNo,10 say '**** Importing Batch/Stock-3  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat3+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat3 
    repl exp with fsbal.exp3
    repl mrp with fsbal.mrp3 
    repl prate with fsbal.prate3
    repl ratea with fsbal.srate3
    repl lprate with fsbal.prate3
    repl opening with fsbal.qty3
    repl o_a with fsbal.qty3
    repl balance with fsbal.qty3
    repl b_a with fsbal.qty3
 else
    repl opening with opening+fsbal.qty3
    repl o_a with o_a+fsbal.qty3
    repl balance with balance+fsbal.qty3
    repl b_a with b_a+fsbal.qty3
 endif 
endscan
Close Table all 

@RowNo,10 say '**** Importing Batch/Stock-4  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat4+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat4 
    repl exp with fsbal.exp4
    repl mrp with fsbal.mrp4 
    repl prate with fsbal.prate4
    repl ratea with fsbal.srate4
    repl lprate with fsbal.prate4
    repl opening with fsbal.qty4
    repl o_a with fsbal.qty4
    repl balance with fsbal.qty4
    repl b_a with fsbal.qty4
 else
    repl opening with opening+fsbal.qty4
    repl o_a with o_a+fsbal.qty4
    repl balance with balance+fsbal.qty4
    repl b_a with b_a+fsbal.qty4
 endif 
endscan
Close Table all 
@RowNo,10 say '**** Importing Batch/Stock-5  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat5+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat5 
    repl exp with fsbal.exp5
    repl mrp with fsbal.mrp5 
    repl prate with fsbal.prate5
    repl ratea with fsbal.srate5
    repl lprate with fsbal.prate5
    repl opening with fsbal.qty5
    repl o_a with fsbal.qty5
    repl balance with fsbal.qty5
    repl b_a with fsbal.qty5
 else
    repl opening with opening+fsbal.qty5
    repl o_a with o_a+fsbal.qty5
    repl balance with balance+fsbal.qty5
    repl b_a with b_a+fsbal.qty5
 endif 
endscan
Close Table all 

@RowNo,10 say '**** Importing Batch/Stock-6  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat6+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat6 
    repl exp with fsbal.exp6
    repl mrp with fsbal.mrp6 
    repl prate with fsbal.prate6
    repl ratea with fsbal.srate6
    repl lprate with fsbal.prate6
    repl opening with fsbal.qty6
    repl o_a with fsbal.qty6
    repl balance with fsbal.qty6
    repl b_a with fsbal.qty6
 else
    repl opening with opening+fsbal.qty6
    repl o_a with o_a+fsbal.qty6
    repl balance with balance+fsbal.qty6
    repl b_a with b_a+fsbal.qty6
 endif 
endscan
Close Table all 
@RowNo,10 say '**** Importing Batch/Stock-7  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat7+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat7 
    repl exp with fsbal.exp7
    repl mrp with fsbal.mrp7 
    repl prate with fsbal.prate7
    repl ratea with fsbal.srate7
    repl lprate with fsbal.prate7
    repl opening with fsbal.qty7
    repl o_a with fsbal.qty7
    repl balance with fsbal.qty7
    repl b_a with fsbal.qty7
 else
    repl opening with opening+fsbal.qty7
    repl o_a with o_a+fsbal.qty7
    repl balance with balance+fsbal.qty7
    repl b_a with b_a+fsbal.qty7
 endif 
endscan
Close Table all 
@RowNo,10 say '**** Importing Batch/Stock-8  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat8+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat8 
    repl exp with fsbal.exp8
    repl mrp with fsbal.mrp8 
    repl prate with fsbal.prate8
    repl ratea with fsbal.srate8
    repl lprate with fsbal.prate8
    repl opening with fsbal.qty8
    repl o_a with fsbal.qty8
    repl balance with fsbal.qty8
    repl b_a with fsbal.qty8
 else
    repl opening with opening+fsbal.qty8
    repl o_a with o_a+fsbal.qty8
    repl balance with balance+fsbal.qty8
    repl b_a with b_a+fsbal.qty8
 endif 
endscan
Close Table all 
@RowNo,10 say '**** Importing Batch/Stock-9  ****' font 'Arial',12
Rowno=Rowno+1
sele sele(1)
 use &datdev\support.&datext alias support  
sele sele(1)
 use &datdev\probat.&datext alias msbal 
 index on name+batchno to msbal 
sele sele(1)
use &datdev\pro.&datext alias mitm 
index on name to mitm
sele sele(1)
use &datatransferpath\MEDImast.&datatransferext alias fsbal 
sele fsbal
scan
  sele mitm 
  seek subs(fsbal.mdcode+space(10),1,10)
  sele msbal 
  seek mitm.name+subs(fsbal.bat9+space(12),1,12)
  if !found()
    appe blank 
    repl code with mitm.code 
    repl name with mitm.name 
    repl product with mitm.product 
    repl billname with mitm.billname 
    repl packing with mitm.packing 
    repl pack with mitm.pack 
    repl batchno with fsbal.bat9 
    repl exp with fsbal.exp9
    repl mrp with fsbal.mrp9 
    repl prate with fsbal.prate9
    repl ratea with fsbal.srate9
    repl lprate with fsbal.prate9
    repl opening with fsbal.qty9
    repl o_a with fsbal.qty9
    repl balance with fsbal.qty9
    repl b_a with fsbal.qty9
 else
    repl opening with opening+fsbal.qty9
    repl o_a with o_a+fsbal.qty9
    repl balance with balance+fsbal.qty9
    repl b_a with b_a+fsbal.qty9
 endif 
endscan
Close Table all 

@rowno,10 say '**** Importing Customer Ledger  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datatransferpath\custmast.&datatransferext alias fact
sele sele(1)
use &datdev\order.&datext alias mact
sele sele(1)
use &datdev\saletype.&datext alias mpcm
index on sgcode+sname to mpcm
sele sele(1)
use &datdev\support.&datext alias support
sele fact
scan
	sele mact
	appen blank
	repl mact.scode with 'C6'
	repl mact.rate with 'Y'
	repl mact.ordno with 'D'+fact.ccode
	repl mact.fax2 with fact.ccode
	repl mact.parnam  with fact.cname
	repl mact.mailnam with fact.cname
	repl mact.paradd with fact.cadd1
	repl mact.paradd1 with fact.cadd2
	repl mact.paradd2 with alltri(fact.cadd3)+' '+fact.cadd4
	repl mact.city with fact.cadd4
	repl mact.itno with fact.pan
	repl mact.dlno with alltri(fact.cdl20)+' '+alltri(fact.cdl21)
	repl gstno with fact.gstin
	repl phone1 with chrtran(fact.cphone,' ','')
	repl phone4 with chrtran(fact.cphone,' ','')
	repl mact.sthed with  'TIN No.'
	repl mact.gsthed with  'GST No.'
	repl mact.csthed with 'CST  No.'
	repl mact.ref with 'Mr.'
	repl mact.price with 'A'
	repl mact.status with 'Y'
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

@rowno,10 say '**** Importing A/C Outstandings  ****' font 'Arial',10
rowno=rowno+1
sele sele(1)
use &datdev\pendings.&datext alias mpend
sele sele(1)
use &datdev\order.&datext alias mord
inde on substr(fax2,1,4) to mord
sele sele(1)
use &datdev\slipno.&datext alias mslip
sele sele(1)
use &datatransferpath\custran.&datatransferext alias fout
sele mslip
go top
vou =voucher  + 10
svou=svoucher + 10
sele fout
go top
scan 
	mvcn=alltr(str(fout.invno))
	sele mord
	seek substr(alltri(fout.ccode)+space(4),1,4)
	sele mpend
	appen blan
	repl acgroup with mord->scode
	repl ord with mord.ordno
	repl ddate with fout.invdt
	repl vcn with mvcn
	repl invtype with 'O'
	repl voucher  with vou
	repl svoucher with svou
	repl final with iif(acgroup='D31',-abs(fout->invamt),abs(fout->invamt))
	repl itemope with iif(acgroup='D31',-abs(fout->rdamt),abs(fout->rdamt))
	repl balance with iif(acgroup='D31',-(abs(final)-abs(itemope)),(abs(final)-abs(itemope)))
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


retu
IF old_4='N' 
  Do import_transactions
Endif

proc import_transactions   
@rowno,10 say '**** Importing Inventory Transaction ****' font 'Arial',12 && updated sale bill patient code by nivedan sharma dateted 12-12-2019
rowno=rowno+1
sele sele(1)
 use &datdev\slipno.&datext alias mslip 
 mVoucher=voucher+5 
 msVoucher=svoucher+4
sele sele(1)
 use &datdev\support.&datext alias support 
 dele all for type='#'  and aliase="DAT/F-SL"
 INDEX on type+aliase+lcode+str(pcode,9)+str(voucher,9)+str(sno,3) to support
 seek 'F' + 'BATCHPRT'
 if !found()
   append blank
   repl type with 'F',aliase with 'BATCHPRT'
 endif
 repl remark with substr(remark,1,57)+dtoc(date())+substr(remark,68)
sele sele(1)
 use &datdev\mdis.&datext alias mdis 
sele sele(1)
 use &datdev\dis.&datext alias dis 
sele sele(1)
 use &datdev\pro.&datext alias mitm 
 index on name to mitm
sele sele(1)
 use &datdev\maorder.&datext alias maord  
 index on form to maord   
 
@Rowno,10 say '**** Importing Sales  ****' font 'Arial',12 && updated sale bill patient code by nivedan sharma dateted 12-12-2019
Rowno=Rowno+1
sele sele(1)
use &datatransferpath\invoice.&datatransferext alias sal 
sele sele(1)
use &datatransferpath\invdet.&datatransferext alias sld  
index on invno to sld  
sele sele(1)
use &datatransferpath\tfile.&datatransferext alias ftax
index on tcode to ftax
sele sal
scan
mvoucher=mvoucher+5 
sele mdis
appen blank 
repl voucher with mvoucher 
repl type with 'S' 
repl vcn with  padl(sal.invno,6,'0')
repl date with sal.invdt 
repl docu with space(10)+sal.cname 
repl docu2 with subs(sal.docno+space(10),1,10)+sal.docnam
repl bddis with sal.dper 
if sal.term='C'
  repl codep with 'STACO3'
  repl final with 0 
  repl cash with sal.invamt
else
  repl codep with sal.ccode
  repl final with sal.invamt
  repl cash with 0 
endif    
  repl round with sal.r_off 
   if final=0 .and. cash#0
   	  repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
	     repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)	
   ENDIF
   repl duedays with 0
   repl account with 'N'
   repl godwon with 'A'
   repl discafter with 'N'
   repl sale with 'Z'
   repl ltype with scalc
   repl misc3 with substr(mdis.misc3,1,54)+str(sal.disamt,10,2)+substr(MDIS.misc3,65,100)
   repl mdis.misc3 with substr(mdis.misc3,1,78)+'#'+substr(mdis.misc3,80)                       
   sele support
   appen blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
   
sele sld
seek sal.invno 
scan while invno=sal.invno 
   =seek(subs(mdcode+space(10),1,10),'mitm')
   =seek(tcode,'ftax')
   
   sele dis
   appen blank 
   repl voucher with mdis.voucher 
   repl vcn with iif(day(mdis.date)=0,mdis.challan,mdis.vcn) 
   repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date) 
   repl codep with mdis.codep 
   repl tax with 'T' 
   repl code with mitm.code 
   repl batch with sld.batch 
   repl exp with sld.exp 
   repl qty with sld.qty 
   repl rate with sld.mrp 
*   repl pack with sld.packg
   repl ssta with ftax.igst/2 
   repl cgst with ftax.igst/2
   repl flg with iif(mdis.type='S','G',mdis.type)
   repl mrp with sld.mrp
   repl bddis  with sal.dper      
endscan  
endscan
@Rowno,10 say '**** Importing Purchase Return  ****' font 'Arial',12 && updated sale bill patient code by nivedan sharma dateted 12-12-2019
Rowno=Rowno+1
sele sele(1)
 use &datatransferpath\preturn.&datatransferext alias pret
sele sele(1)
 use &datatransferpath\pretdet.&datatransferext alias prld  
 index on pretno to prld
sele pret 
scan 
 mvoucher=mvoucher+5
  sele mdis
  appen blank 
  repl voucher with mvoucher  
  repl type with 'B' 
  repl vcn with padl(pret.pretno,6,'0')
  repl date with pret.pretdt 
  repl codep with pret.supno 
  repl bddis with pret.dper  
  repl round with pret.r_off 
  if pret.term='C'
    repl final with 0 
    repl cash with pret.invamt 
  else
    repl cash with 0 
    repl final with pret.invamt
  endif    
    
   if final=0 .and. cash#0
   	  repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
	     repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)	
   ENDIF
   repl duedays with 0
   repl account with 'N'
   repl godwon with 'A'
   repl discafter with 'N'
   repl sale with 'z'
   repl ltype with pcalc
   repl misc3 with substr(mdis.misc3,1,54)+str(pret.disamt,10,2)+substr(mdis.misc3,65,100)
   repl mdis.misc3 with substr(mdis.misc3,1,78)+'#'+substr(mdis.misc3,80)                       &&    
   sele support
   appen blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
sele prld
seek pret.pretno 
scan while pretno=pret.pretno 
   =seek(subs(mdcode+space(10),1,10),'mitm')
   =seek(tcode,'ftax')
   sele dis
   appen blank 
   repl voucher with mdis.voucher 
   repl vcn with iif(day(mdis.date)=0,mdis.challan,mdis.vcn) 
   repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date) 
   repl codep with mdis.codep 
   repl tax with 'T' 
   repl code with mitm.code 
   repl batch with prld.batch 
   repl exp with prld.exp 
   repl rate with prld.prate
   repl mrp with prld.mrp 
   repl qty with prld.qty   &&&*IIF(PRLD.PACKG#0,PRLD.PACKG,1) 
   repl free with prld.fqty &&&*IIF(PRLD.PACKG#0,PRLD.PACKG,1)
*   repl pack with prld.packg
   repl ssta with ftax.igst/2 
   repl cgst with ftax.igst/2
   repl flg with iif(mdis.type='S','G',mdis.type)
   repl bddis  with pret.dper      
   repl mdis.pm with prld.pinvno
   repl mdis.lrda with prld.pinvdt
endscan  
  
endscan 

@Rowno,10 say '**** Importing Purchase   ****' font 'Arial',12 && updated sale bill patient code by nivedan sharma dateted 12-12-2019
Rowno=Rowno+1
sele sele(1)
 use &datatransferpath\supout.&datatransferext alias pur
sele sele(1)
 use &datatransferpath\purchase.&datatransferext alias pld  
 index on pinvno to pld
sele pur 
currec=0
scan for between(tradt,old_5,old_6)
 mvoucher=mvoucher+5
  sele mdis
  appen blank 
  repl voucher with mvoucher  
  repl type with 'P' 
  repl vcn with padl(pur.srlno,6,'0')
  repl date with pur.tradt 
  repl pm with pur.invno 
  repl lrda with pur.invdt
  repl codep with pur.supno 
  repl bddis with pur.dper  
*  repl round with pur.r_off 
if pur.term='R'  
  repl final with pur.invamt 
  repl cash with 0 
else
  repl final with pur.invamt-pur.paidamt
  repl cash with pur.paidamt
endif  
   if final=0 .and. cash#0
   	  repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
	     repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)	
   ENDIF
   repl duedays with 0
   repl account with 'N'
   repl godwon with 'A'
   repl discafter with 'N'
   repl sale with 'z'
   repl ltype with pcalc
   repl misc3 with substr(mdis.misc3,1,54)+str(0,10,2)+substr(mdis.misc3,65,100)
   repl mdis.misc3 with substr(mdis.misc3,1,78)+'#'+substr(mdis.misc3,80)                       &&    
   sele support
   appen blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
sele pld
seek pur.invno 
scan while pinvno=pur.invno 
   =seek(subs(mdcode+space(10),1,10),'mitm')
   =seek(tcode,'ftax')
   sele dis
   appen blank 
   repl voucher with mdis.voucher 
   repl vcn with iif(day(mdis.date)=0,mdis.challan,mdis.vcn) 
   repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date) 
   repl codep with mdis.codep 
   repl tax with 'T' 
   repl code with mitm.code 
   repl batch with pld.batch 
   repl exp with pld.exp 
   repl rate with pld.prate
   repl mrp with pld.mrp 
   repl qty with pld.qty 
   repl free with pld.fqty
*   repl pack with pld.packg
   repl ssta with ftax.igst/2 
   repl cgst with ftax.igst/2
   repl flg with iif(mdis.type='S','G',mdis.type)
   repl bddis  with pur.dper      
   repl disc2 with pld.pdisc
endscan  
  
endscan 

@Rowno,10 say '**** Importing Sales Return ****' font 'Arial',12 && updated sale bill patient code by nivedan sharma dateted 12-12-2019
Rowno=Rowno+1
sele sele(1)
 use &datatransferpath\sreturn.&datatransferext alias sret 
sele sele(1)
 use &datatransferpath\sretdet.&datatransferext alias srld 
 index on sretno to srld  
sele sret
scan
mvoucher=mvoucher+5 
sele mdis
appen blank 
repl voucher with mvoucher 
repl type with 'R' 
repl vcn with  padl(sret.sretno,6,'0')
repl date with sret.sretdt 
repl docu with space(10)+sret.cname 
repl docu2 with subs(sret.docno+space(10),1,10)+sret.docnam
repl bddis with sret.dper 
if sal.term='C'
  repl codep with 'STACO3'
  repl final with 0 
  repl cash with sret.invamt
else
  repl codep with sret.ccode
  repl final with sret.invamt
  repl cash with 0 
endif    
  repl round with sret.r_off 
   if final=0 .and. cash#0
   	  repl misc3 with substr(misc3,1,34)+'C'+substr(misc3,36,100)
   else
	     repl misc3 with substr(misc3,1,34)+'R'+substr(misc3,36,100)	
   ENDIF
   repl duedays with 0
   repl account with 'N'
   repl godwon with 'A'
   repl discafter with 'N'
   repl sale with 'Z'
   repl ltype with scalc
   repl misc3 with substr(mdis.misc3,1,54)+str(sret.disamt,10,2)+substr(mdis.misc3,65,100)
   repl mdis.misc3 with substr(mdis.misc3,1,78)+'#'+substr(mdis.misc3,80)                       &&    
   sele support
   appen blank
   repl type with "#",aliase with "DAT/F-SL",pcode with mdis->voucher,value with mdis->final+mdis->cash
   
sele srld
seek sret.sretno 
scan while sretno=sret.sretno 
   =seek(subs(mdcode+space(10),1,10),'mitm')
   =seek(tcode,'ftax')
   sele dis
   appen blank 
   repl voucher with mdis.voucher 
   repl vcn with iif(day(mdis.date)=0,mdis.challan,mdis.vcn) 
   repl date with iif(day(mdis.date)=0,mdis.chdate,mdis.date) 
   repl codep with mdis.codep 
   repl tax with 'T' 
   repl code with mitm.code 
   repl batch with srld.batch 
   repl exp with srld.exp 
   repl qty with srld.qty 
   repl rate with srld.mrp 
*   repl pack with srld.packg
   repl ssta with ftax.igst/2 
   repl cgst with ftax.igst/2
   repl flg with iif(mdis.type='S','G',mdis.type)
   repl mrp with srld.mrp
   repl bddis  with sret.dper      
endscan  
endscan

sele mslip 
repl voucher with mvoucher 
repl svoucher with msvoucher
close table all 
@rowno,10 say '**** Importing Account from Sales ****' font 'Arial',12
rowno=rowno+1
sele sele(1)
 use &datdev\slipno.&datext alias mslip
 last4=voucher+10 
 slast5=svoucher+5
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
	   **** For Outstanding
	   if old_3 = 'Y'
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
		LAST1='STACO3'
		repl remark1 with mdis.vcn
		repl book WITH 'S'
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
sele mslip 
repl voucher with last4 
repl svoucher with slast5
close data





  
 


























