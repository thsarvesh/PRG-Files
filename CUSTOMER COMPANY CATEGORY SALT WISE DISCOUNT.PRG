colofhed="COMPANY CATEGORY WISE PRODUCT DISCOUNT"
=colofil(11,19,18,60,10)
partyby='Yes'
companyby='Yes'
categoryby='Yes'
saltby='Yes'
store 2 to mychoice
@12,22 SAY "SELECTED PARTY       : " GET partyby pict'@m No ,Yes'
@13,22 say "SELECTED COMPANY     : " get companyby pict'@m No ,Yes'
@14,22 say "SELECTED CATEGORY    : " get categoryby pict'@m No ,Yes'
@15,22 say "SELECTED SUB CATEGORY: " get saltby pict'@m No ,Yes'
@16.5,28 get mychoice pict "@*TH \<Ok;\<Cancel"  size 1.5,8,2 font margprmfmt, margprmfsz
read colo &colourack
if lastkey()=27 or mychoice=2
 retu .f.
endif
sele sele(1)
select * from order c into curs party_curs where 1=2 readwrit
sele party_curs
index on parnam to &viewgpdir\party_curs
sele c
set order to ords
sele c
seek "C6"
scan while scode="C6"
scat memvar
	sele party_curs
	insert into party_curs from memvar
endscan
sele party_curs
repl all true with "N"
if partyby='Yes'
	co=""
	last=0
	sand="6"
	shelp_heading="Select Party"
	save scre to shelp
	do shelpsal
	mcode=ordno
	if last=27
		sele sele(1)
		sele party_curs
		use
		return
		else
		dele all for true#"Y"
	endif
endif
sele party_curs
index on ordno to &viewgpdir\party_curs
&&company
sele sele(1)
select * from saletype into curs comp_curs  where 1=2 readwri      &&&&&Create Blank Cursor
sele comp_curs
index on parnam to &viewgpdir\comp_curs   &&&&Index on name
sele saletype
set order to salst
seek "ZZZZZZ"
scan while sgcode="ZZZZZZ"     &&&&&Sale will be used for Category/Commodity/HSN/Area/ROut/State/Country/Sales/Purchase/Salt etc
	scat memvar
	insert into comp_curs from memvar   &&&& Adding Records from saletype
endscan
select comp_curs
repl all code with "Y"        &&&Default select all company
if companyby="Y"
	repl all code with "N"
	co=""
	last=0
	sand="2"
	save scre to shelp
	shelp_heading="Select Company"
	do shelpsal
	if last=27
		sele sele(1)
		sele comp_curs
		repl all code with "Y"
		return
	else
	dele all for code#"Y"
	endif
endif
sele comp_curs
index on scode to &viewgpdir\comp_curs
&&category
sele sele(1)
select * from saletype into curs cat_curs  where 1=2 readwri      &&&&&Create Blank Cursor
sele cat_curs
index on parnam to &viewgpdir\cat_curs   &&&&Index on name
sele saletype
set order to salst
seek "CATEGO"
scan while sgcode="CATEGO"     &&&&&Sale will be used for Category/Commodity/HSN/Area/ROut/State/Country/Sales/Purchase/Salt etc
scat memvar
insert into cat_curs from memvar   &&&& Adding Records from saletype
endscan
select cat_curs
repl all code with "Y"        &&&Default select all company
if categoryby="Y"
	repl all code with "N"
	co=""
	last=0
	sand="2"
	save scre to shelp
	shelp_heading="Select Category"
	do shelpsal
	if last=27
		sele sele(1)
		sele cat_curs
		repl all code with "Y"
		return
		else
		dele all for code#"Y"
	endif
endif
sele cat_curs
index on scode to &viewgpdir\cat_curs
&&salt
sele sele(1)
select * from saletype into curs salt_curs  where 1=2 readwri      &&&&&Create Blank Cursor
if saltby="Y"
	sele salt_curs
	index on parnam to &viewgpdir\salt_curs  &&&&Index on name
	sele saletype
	set order to salst
	seek "SALT  "
	scan while sgcode="SALT  "     &&&&&Sale will be used for Category/Commodity/HSN/Area/ROut/State/Country/Sales/Purchase/Salt etc
		scat memvar
		insert into salt_curs from memvar   &&&& Adding Records from saletype
	endscan
	select salt_curs
	repl all code with "Y"        &&&Default select all company
	repl all code with "N"
	co=""
	last=0
	sand="2"
	save scre to shelp
	shelp_heading="Select Sub Category"
	do shelpsal
	if last=27
		sele sele(1)
		sele salt_curs
		repl all code with "Y"
		return
		else
		dele all for code#"Y"
	endif
	sele salt_curs
	index on scode to &viewgpdir\salt_curs
endif
sele sele (1)
create curs data_curs(ordno c(6),parnam c(30),gcode c(6),compname c(20),gcode5 c(6),category c(20),;
                      gcode3 c(6),salt c(30),discount n(5,2),DIS2 N(5,2),ms n(5))
sele rate
set order to RATGEI
rest screen from simple
=plswproc("Please Wait.......Processing")
if saltby='Y'
	sele party_curs
	go top
	scan
		sele comp_curs
		scan
			sele cat_curs
			scan
				sele salt_curs
				scan
					sele data_curs
					appen blank
					repl ordno with party_curs.ordno
					repl parnam with party_curs.parnam
					repl gcode with comp_curs.scode
					repl compname with comp_curs.sname
					repl gcode5 with cat_curs.scode
					repl category with cat_curs.sname
					repl gcode3 with salt_curs.scode
					repl salt with salt_curs.sname
					sele rate
					seek 'D'+comp_curs.scode+party_curs.ordno+substr(upper(cat_curs.scode)+upper(salt_curs.scode)+space(45),1,45)
					if found()
						repl data_curs.discount with disc1
						repl data_curs.dis2 with disc2
					endif
				endscan
			endscan
		endscan
	endscan
else
	sele party_curs
	go top
	scan
		sele comp_curs
		scan
			sele cat_curs
			scan
				sele data_curs
				appen blank
				repl ordno with party_curs.ordno
				repl parnam with party_curs.parnam
				repl gcode with comp_curs.scode
				repl compname with comp_curs.sname
				repl gcode5 with cat_curs.scode
				repl category with cat_curs.sname
				repl gcode3 with salt_curs.scode
				repl salt with salt_curs.sname
				sele rate
				seek 'D'+comp_curs.scode+party_curs.ordno+substr(upper(cat_curs.scode)+upper(salt_curs.scode)+space(45),1,45)
				if found()
					repl data_curs.discount with disc1
					repl data_curs.dis2 with disc2
				endif
			endscan
		endscan
	endscan
endif
sele data_curs
index on gcode+gcode5+gcode3 to data_curs
Repl ms With Recno() All
select * from data_curs into curs datacurs_main READW
Sele datacurs_main
Index On ms To msdm
go top
sele data_curs
index on compname+category+salt+parnam to data_curs
go top
tcols=10
frmmyform = createobject('MyForm')
frmmyform.caption = "Party Company Group Category Wise Report Esc-Exit"
frmmyform.addobject('cmdCommand1','cmdMyCmdBtn')
frmmyform.addobject('cmdCommand2','cmdMyCmdBtn2')
frmmyform.addobject('cmdCommand3','cmdMyCmdBtn3')
frmmyform.addobject('cmdtxtbox1','cmdMytxtbox')
frmmyform.addobject('cmdtxtbox2','cmdMytxtbox')
frmmyform.addobject('cmdtxtbox3','cmdMytxtbox')
frmmyform.addobject('cmdtxtbox4','cmdMytxtbox')

frmmyform.addobject('label1','mylabel')
frmmyform.addobject('label2','mylabel')
frmmyform.addobject('label3','mylabel')
frmmyform.addobject('label4','mylabel')

frmmyform.label1.caption='COMPANY'
frmmyform.label2.caption='CATEGORY'
frmmyform.label3.caption='SUB-COMPANY'
frmmyform.label4.caption='PARTY'

frmmyform.label1.Left=40
frmmyform.cmdtxtbox1.left=110
frmmyform.label2.Left=270
frmmyform.cmdtxtbox2.left=340
frmmyform.label3.Left=540
frmmyform.cmdtxtbox3.left=640
frmmyform.label4.Left=820
frmmyform.cmdtxtbox4.left=870

frmmyform.icon="MARG.ICO"
frmmyform.grdgrid1.left=12
frmmyform.grdgrid1.top=50
frmmyform.grdgrid1.visible = .t.

frmmyform.cmdcommand1.fontbold =.t.
frmmyform.cmdcommand1.visible =.t.
frmmyform.cmdcommand1.backcolor=rgb(255,0,0)
frmmyform.cmdcommand2.fontbold =.t.
frmmyform.cmdcommand2.visible =.t.
frmmyform.cmdcommand2.backcolor=rgb(0,166,0)
frmmyform.cmdcommand3.fontbold =.t.
frmmyform.cmdcommand3.visible =.t.
frmmyform.cmdcommand3.backcolor=rgb(130,168,254)


*frmmyform.grdgrid1.recordSource="data_curs"

frmmyform.grdgrid1.columncount=tcols
frmmyform.grdgrid1.column1.controlsource="data_curs->ordno"
frmmyform.grdgrid1.column1.header1.caption = 'Ledger Code'
frmmyform.grdgrid1.column1.header1.fontsize = 9
frmmyform.grdgrid1.column1.header1.fontbold = .t.
frmmyform.grdgrid1.column1.header1.fontname = 'Arial'
frmmyform.grdgrid1.column1.visible = .f.
frmmyform.grdgrid1.column1.width =75

frmmyform.grdgrid1.column2.controlsource="data_curs->parnam"
frmmyform.grdgrid1.column2.header1.caption = 'Ledger Name'
frmmyform.grdgrid1.column2.header1.fontsize = 9
frmmyform.grdgrid1.column2.header1.fontbold = .t.
frmmyform.grdgrid1.column2.header1.fontname = 'Arial'
frmmyform.grdgrid1.column2.width =250

frmmyform.grdgrid1.column3.controlsource="data_curs->gcode"
frmmyform.grdgrid1.column3.header1.caption = 'Company Code'
frmmyform.grdgrid1.column3.header1.fontsize = 9
frmmyform.grdgrid1.column3.header1.fontbold = .t.
frmmyform.grdgrid1.column3.header1.fontname = 'Arial'
frmmyform.grdgrid1.column3.visible = .f.
frmmyform.grdgrid1.column3.width =75

frmmyform.grdgrid1.column4.controlsource="data_curs->compname"
frmmyform.grdgrid1.column4.header1.caption = 'Company Name'
frmmyform.grdgrid1.column4.header1.fontsize = 9
frmmyform.grdgrid1.column4.header1.fontbold = .t.
frmmyform.grdgrid1.column4.header1.fontname = 'Arial'
frmmyform.grdgrid1.column4.width =150


frmmyform.grdgrid1.column5.controlsource="data_curs->gcode5"
frmmyform.grdgrid1.column5.header1.caption = 'Category Code'
frmmyform.grdgrid1.column5.header1.fontsize = 9
frmmyform.grdgrid1.column5.visible = .f.
frmmyform.grdgrid1.column5.header1.fontbold = .t.
frmmyform.grdgrid1.column5.header1.fontname = 'Arial'
frmmyform.grdgrid1.column5.width =75

frmmyform.grdgrid1.column6.controlsource="data_curs->category"
frmmyform.grdgrid1.column6.header1.caption = 'Category Name'
frmmyform.grdgrid1.column6.header1.fontsize = 9
frmmyform.grdgrid1.column6.header1.fontbold = .t.
frmmyform.grdgrid1.column6.header1.fontname = 'Arial'
frmmyform.grdgrid1.column6.width =150

frmmyform.grdgrid1.column7.controlsource="data_curs->gcode3"
frmmyform.grdgrid1.column7.header1.caption = 'Salt Code'
frmmyform.grdgrid1.column7.header1.fontsize = 9
frmmyform.grdgrid1.column7.header1.fontbold = .t.
frmmyform.grdgrid1.column7.visible = .f.
frmmyform.grdgrid1.column7.header1.fontname = 'Arial'
frmmyform.grdgrid1.column7.width =75

frmmyform.grdgrid1.column8.controlsource="data_curs->salt"
frmmyform.grdgrid1.column8.header1.caption = 'Sub Category'
frmmyform.grdgrid1.column8.header1.fontsize = 9
frmmyform.grdgrid1.column8.header1.fontbold = .t.
frmmyform.grdgrid1.column8.header1.fontname = 'Arial'
frmmyform.grdgrid1.column8.width =150

frmmyform.grdgrid1.column9.controlsource="data_curs->discount"
frmmyform.grdgrid1.column9.header1.caption = 'Disc-1 %'
frmmyform.grdgrid1.column9.header1.fontsize = 9
frmmyform.grdgrid1.column9.header1.fontbold = .t.
frmmyform.grdgrid1.column9.header1.fontname = 'Arial'
frmmyform.grdgrid1.column9.width =75

frmmyform.grdgrid1.column10.controlsource="data_curs->Dis2"
frmmyform.grdgrid1.column10.header1.caption = 'Disc-2 %'
frmmyform.grdgrid1.column10.header1.fontsize = 9
frmmyform.grdgrid1.column10.header1.fontbold = .t.
frmmyform.grdgrid1.column10.header1.fontname = 'Arial'
frmmyform.grdgrid1.column10.width =75
frmmyform.show  && Display the form

define class mylabel as label  && Create Command button
 && Caption on the Command button
 cancel = .t.  && Default Cancel Command button (Esc)
 left = 20  && Command button column
 autosize=.t.
 fontsize=9
 fontbold =.t.
 visible =.t.
 top = 15  && Command button row
 height = 25  && Command button height

 procedure click
*CLEAR EVENTS  && Stop event processing, close form
&&&&CLOSE ALL  && Close table and database
 thisform.release()
 return
enddefine

define class cmdmycmdbtn as commandbutton  && Create Command button
 caption = '\<Quit'  && Caption on the Command button
 cancel = .t.  && Default Cancel Command button (Esc)
 left = sysm(1)-150  && Command button column
 top = 10  && Command button row
 height = 25  && Command button height

 procedure click
*CLEAR EVENTS  && Stop event processing, close form
&&&&CLOSE ALL  && Close table and database
 thisform.release()
 return
enddefine

define class cmdmycmdbtn3 as commandbutton  && sAVE Command button
 caption = '\<Save'  && Caption on the Command button
 cancel = .t.  && Default Cancel Command button (Esc)
 left = sysm(1)-340  && Command button column
 top = 10  && Command button row
 height = 25  && Command button height

procedure click
sele data_curs
if saltby='Y'
	index on gcode+gcode5+gcode3 to data_curs
else
	index on gcode+gcode5 to data_curs
endif
sele sele (1)
select * from pro into curs tpro readwr
if saltby='Y'
	index on gcode+gcode5+gcode3 to tpro
else
	index on gcode+gcode5 to tpro
endif
sele sele (1)
create curs data_curs1(ordno c(6),code n(9),discount n(10,2),dis2 n(10,2))
=plswproc("Please Wait.......Processing")
select select(1)
sele * from datacurs_main into curs data_curs where discount+dis2#0 readwr
sele data_curs
go top
scan for (discount+dis2)#0
sele rate
if saltby='Y'
	seek 'D'+data_curs.gcode+data_curs.ordno+substr(upper(data_curs.gcode5)+upper(data_curs.gcode3)+space(45),1,45)
else
	seek 'D'+data_curs.gcode+data_curs.ordno+substr(upper(data_curs.gcode5)+space(45),1,45)
endif
	if !found()
	appen blank
		repl type with 'D'
		repl gcode with data_curs.gcode
		repl pcode with data_curs.ordno
		if saltby='Y'
		    repl billname with upper(data_curs.gcode5)+upper(data_curs.gcode3)
		 else
		    repl billname with upper(data_curs.gcode5)
		endif
	endif
	repl disc1 with data_curs.discount
	repl disc2 with data_curs.dis2
	sele tpro
	if saltby='Y'
		if seek(data_curs.gcode+data_curs.gcode5+data_curs.gcode3)
			scan while gcode+gcode5+gcode3=data_curs.gcode+data_curs.gcode5+data_curs.gcode3
				sele data_curs1
				appen blank
				repl ordno with data_curs.ordno
				repl code with tpro.code
				repl discount with data_curs.discount
				repl dis2 with data_curs.dis2
			endscan
		endif
	else
		if seek(data_curs.gcode+data_curs.gcode5)
			scan while gcode+gcode5=data_curs.gcode+data_curs.gcode5
			sele data_curs1
			appen blank
			repl ordno with data_curs.ordno
			repl code with tpro.code
			repl discount with data_curs.discount
			repl dis2 with data_curs.dis2
			endscan
		endif
	endif
endscan
sele data_curs1
if reccount()>0
	if messagebox('Want to Save','MargErp9',36)=6
		sele rate
		set order to rate
		sele data_curs1
		go top
		scan for seek(code,'pro','proc')
			=plswproc(substr("Updating  "+alltri(UPPER(pro.billname))+space(45),1,45))
			sele rate
			seek ' '+data_curs1.ordno+str(data_curs1.code,9)
			if !found()
				appen blank
				repl pcode with data_curs1.ordno
				repl code with data_curs1.code
			endif
			repl disc1 with data_curs1.discount
			repl disc2 with data_curs1.dis2
		endscan
		=messagebox('Party Company category wise discount Updated','Marger9')
	endif
	else
	=messagebox('Product not Found','Marger9')
endif
thisform.release()
return
enddefine


define class cmdmycmdbtn2 as commandbutton  && Create Command button
 caption = '\<Excel'  && Caption on the Command button
 cancel = .t.  && Default Cancel Command button (Esc)
 left = sysm(1)-240  && Command button column
 top = 10  && Command button row
 height = 25  && Command button height
* width=100
 procedure click
 =plswproc("Please Wait.......Processing")
 sele sele (1)
 select parnam,compname,category,salt,discount,dis2 from data_curs into curs report_curs readwr
 sele report_curs
 index on parnam to report_curs
  mexcl=viewreport+"\Discount_Report.xls"
  tColumcount=6
  tLineNo=1
  tColumNo=1
  =plswproc("Please Wait.......Processing")
  select select(1)
  sele report_curs
  copy to &mexcl type xls
  o=createobject('EXCEL.APPLICATION')
  o.workbooks.open(mexcl)
 ***COMPANY NAME
  o.range(o.cells(tLineNo,tColumNo),o.cells(tLineNo,tColumcount)).select
  o.selection.rows.insert
  o.range(o.cells(tLineNo,tColumNo),o.cells(tLineNo,tColumcount)).select
  o.selection.merge
  o.selection.value='Demo Company'
  o.selection.font.name="Cambria"
  o.selection.horizontalalignment=3
  o.selection.font.size=10
  o.selection.font.bold=.t.
  o.columns.autofit
  tLineNo=tLineNo+1
 ***COMPANY ADDRESS
  o.range(o.cells(tLineNo,tColumNo),o.cells(tLineNo,tColumcount)).select
  o.selection.rows.insert
  o.range(o.cells(tLineNo,tColumNo),o.cells(tLineNo,tColumcount)).select
  o.selection.merge
  o.selection.value=compaddall
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  o.columns.autofit
  tLineNo=tLineNo+1
 ***COMPANY PHOEN GST
  o.range(o.cells(tLineNo,tColumNo),o.cells(tLineNo,tColumcount)).select
  o.selection.rows.insert
  o.range(o.cells(tLineNo,tColumNo),o.cells(3,tColumcount)).select
  o.selection.merge
  o.selection.value=alltri(comppho)+' '+alltri(compgst)
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  o.columns.autofit
  tLineNo=tLineNo+1
  o.range(o.cells(tLineNo,tColumNo),o.cells(tLineNo,tColumcount)).select
  o.selection.rows.insert
  o.range(o.cells(tLineNo,tColumNo),o.cells(tLineNo,tColumcount)).select
  o.selection.merge
  o.selection.value='Product Company/Category/Sub Category'
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  o.columns.autofit
  tLineNo=tLineNo+1
  o.cells(tLineNo,tColumNo).select
  o.selection.value='Party Name'
  o.selection.interior.colorindex=6
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  tColumNo=tColumNo+1
  o.cells(tLineNo,tColumNo).select
  o.selection.value='Company Name'
  o.selection.interior.colorindex=6
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  tColumNo=tColumNo+1

  o.cells(tLineNo,tColumNo).select
  o.selection.value='Category'
  o.selection.interior.colorindex=6
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  tColumNo=tColumNo+1

  o.cells(tLineNo,tColumNo).select
  o.selection.value='Sub Category'
  o.selection.interior.colorindex=6
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  tColumNo=tColumNo+1

  o.cells(tLineNo,tColumNo).select
  o.selection.value='Disc-1 %'
  o.selection.interior.colorindex=6
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  tColumNo=tColumNo+1
  o.cells(tLineNo,tColumNo).select
  o.selection.value='Disc-2 %'
  o.selection.interior.colorindex=6
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  tColumNo=tColumNo+1
  rcount=o.activesheet.usedrange.rows.count
  o.range(o.cells(1,1),o.cells(rcount,tColumcount)).select
  o.selection.borders.weight=2
  o.range(o.cells(2,1),o.cells(2,tColumcount)).select
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  o.columns.autofit
  o.selection.borders.weight=2
  rowno=rcount+1
  o.range(o.cells(rowno,1),o.cells(rowno,tColumcount)).select
  o.selection.merge
  o.selection.borders.weight=2
  o.selection.value='End of Report'
  o.selection.interior.colorindex=6
  o.selection.font.name="Cambria"
  o.selection.font.size=10
  o.selection.font.bold=.t.
  o.columns.autofit
  o.displayalerts=.f.
  o.activeworkbook.saveas(mexcl)
  o.visible=.t.
  =messagebox('EXCEL Saved as '+mexcl)
 thisform.release()
 return
enddefine


define class mygrid as grid
 deletemark=.f.
 recordmark=.f.
 scrollbars=3
 left=5
 lockcolumnsleft=3
 themes=.f.

 proc init
*scrnwidth=sysm(1)
*if Thisform.width<scrnwidth
*   Thisform.width=scrnwidth
*   This.width=scrnwidth-10
*   This.Left=5
*endif
*scrheight=sysm(2)-80
*if thisform.height<scrheight
*   thisform.height=scrheight
*   *This.height=scrheight-100
*endif
*!*        This.Column5.dynamicbackcolor="iif(customer->hsn=customer->ehsn,rgb(255,255,255),rgb(255,255,66))"
 for i=1 to this.columncount
  clmnno="COLUMN"+ltri(str(i,2))
  this.&clmnno..header1.backcolor=rgb(200,243,255)
 next
 endproc
enddefine

define class myform as form
 closable = .t.  && Disable the window pop-up menu
 showwindow=1
 windowtype=1
 proc init
 this.addobject('grdGrid1','MyGrid')  && Add Grid control
 scrnwidth=sysm(1)-10
 if thisform.width<scrnwidth
  thisform.width=scrnwidth
  thisform.grdgrid1.width=scrnwidth-20
 endif
 scrheight=sysm(2)-150
 if thisform.height<scrheight
  thisform.height=scrheight
  thisform.grdgrid1.height=scrheight-100
 endif
BindEvent(Thisform.grdGrid1.Column10.Text1,"lostfocus",Thisform,"UpdateData")
BindEvent(Thisform.grdGrid1.Column9.Text1,"lostfocus",Thisform,"UpdateData")
endproc
Proc UpdateData
  m.disc2=data_curs->dis2
  m.discount=data_curs->discount
  Sele datacurs_main
  Seek data_curs->ms
  Repl datacurs_main->discount With m.discount, datacurs_main->DIS2 With m.disc2
Endpro
 proc changedata
 thisform.grdgrid1.refresh
 endproc
enddefine


define class cmdmytxtbox as textbox  && Create Command button
 cancel = .t.  && Default Cancel Command button (Esc)
 width = 150
 top = 10  && Command button row
 fontbold =.t.
 visible =.t.
 backcolor=rgb(255,255,255)
 height = 25  && Command button height

 procedure interactivechange

mcomp=allt(upper(frmmyform.cmdtxtbox1.value))
mccat=allt(upper(frmmyform.cmdtxtbox2.value))
msalt=allt(upper(frmmyform.cmdtxtbox3.value))
mpart=allt(upper(frmmyform.cmdtxtbox4.value))

mcondn=''
if saltby='Y'
	mcondn=mcondn+Iif(!Empty(mcomp),"mcomp=Upper(Trim(compname))"+" and ","")
	mcondn=mcondn+Iif(!Empty(mccat),"mccat=Upper(Trim(category))"+IIF(!EMPTY(mcondn)," and ",""),"")
	mcondn=mcondn+Iif(!Empty(msalt),"msalt=Upper(Trim(salt))"+IIF(!EMPTY(mcondn)," and ",""),"")
	mcondn=mcondn+Iif(!Empty(mpart),"mpart=Upper(Trim(parnam))","")
	mcondn=RTRIM(mcondn,"and ")
else
	mcondn=mcondn+Iif(!Empty(mcomp),"mcomp=Upper(Trim(compname))"+" and ","")
	mcondn=mcondn+Iif(!Empty(mccat),"mccat=Upper(Trim(category))"+IIF(!EMPTY(mcondn)," and ",""),"")
	mcondn=mcondn+Iif(!Empty(mpart),"mpart=Upper(Trim(parnam))","")
	mcondn=RTRIM(mcondn,"and ")
endif
If len(mcondn)>3
  Sele Sele(1)
  Sele * From datacurs_main Where &mcondn Into Curs data_curs1
Endif

 sele data_curs
 zap
 appe from dbf('data_curs1')
 go top
 frmmyform.grdgrid1.columncount=tcols
 frmmyform.grdgrid1.column1.controlsource="data_curs->ordno"
 frmmyform.grdgrid1.column1.header1.caption = 'Ledger Code'
 frmmyform.grdgrid1.column1.header1.fontsize = 9
 frmmyform.grdgrid1.column1.header1.fontbold = .t.
 frmmyform.grdgrid1.column1.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column1.visible = .f.
 frmmyform.grdgrid1.column1.width =75

 frmmyform.grdgrid1.column2.controlsource="data_curs->parnam"
 frmmyform.grdgrid1.column2.header1.caption = 'Ledger Name'
 frmmyform.grdgrid1.column2.header1.fontsize = 9
 frmmyform.grdgrid1.column2.header1.fontbold = .t.
 frmmyform.grdgrid1.column2.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column2.width =250

 frmmyform.grdgrid1.column3.controlsource="data_curs->gcode"
 frmmyform.grdgrid1.column3.header1.caption = 'Company Code'
 frmmyform.grdgrid1.column3.header1.fontsize = 9
 frmmyform.grdgrid1.column3.header1.fontbold = .t.
 frmmyform.grdgrid1.column3.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column3.visible = .f.
 frmmyform.grdgrid1.column3.width =75

 frmmyform.grdgrid1.column4.controlsource="data_curs->compname"
 frmmyform.grdgrid1.column4.header1.caption = 'Company Name'
 frmmyform.grdgrid1.column4.header1.fontsize = 9
 frmmyform.grdgrid1.column4.header1.fontbold = .t.
 frmmyform.grdgrid1.column4.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column4.width =150


 frmmyform.grdgrid1.column5.controlsource="data_curs->gcode5"
 frmmyform.grdgrid1.column5.header1.caption = 'Category Code'
 frmmyform.grdgrid1.column5.header1.fontsize = 9
 frmmyform.grdgrid1.column5.visible = .f.
 frmmyform.grdgrid1.column5.header1.fontbold = .t.
 frmmyform.grdgrid1.column5.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column5.width =75

 frmmyform.grdgrid1.column6.controlsource="data_curs->category"
 frmmyform.grdgrid1.column6.header1.caption = 'Category Name'
 frmmyform.grdgrid1.column6.header1.fontsize = 9
 frmmyform.grdgrid1.column6.header1.fontbold = .t.
 frmmyform.grdgrid1.column6.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column6.width =150

 frmmyform.grdgrid1.column7.controlsource="data_curs->gcode3"
 frmmyform.grdgrid1.column7.header1.caption = 'Salt Code'
 frmmyform.grdgrid1.column7.header1.fontsize = 9
 frmmyform.grdgrid1.column7.header1.fontbold = .t.
 frmmyform.grdgrid1.column7.visible = .f.
 frmmyform.grdgrid1.column7.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column7.width =75

 frmmyform.grdgrid1.column8.controlsource="data_curs->salt"
 frmmyform.grdgrid1.column8.header1.caption = 'Sub Category'
 frmmyform.grdgrid1.column8.header1.fontsize = 9
 frmmyform.grdgrid1.column8.header1.fontbold = .t.
 frmmyform.grdgrid1.column8.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column8.width =150

 frmmyform.grdgrid1.column9.controlsource="data_curs->discount"
 frmmyform.grdgrid1.column9.header1.caption = 'Disc-1 %'
 frmmyform.grdgrid1.column9.header1.fontsize = 9
 frmmyform.grdgrid1.column9.header1.fontbold = .t.
 frmmyform.grdgrid1.column9.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column9.width =75

 frmmyform.grdgrid1.column10.controlsource="data_curs->Dis2"
 frmmyform.grdgrid1.column10.header1.caption = 'Disc-2 %'
 frmmyform.grdgrid1.column10.header1.fontsize = 9
 frmmyform.grdgrid1.column10.header1.fontbold = .t.
 frmmyform.grdgrid1.column10.header1.fontname = 'Arial'
 frmmyform.grdgrid1.column10.width =75
 frmmyform.show  && Display the form
 thisform.grdgrid1.refresh
 endproc
enddefine


