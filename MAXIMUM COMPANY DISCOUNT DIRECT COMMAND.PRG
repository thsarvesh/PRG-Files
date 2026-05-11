sele sele (1)
sele support
set order to supp
sele sele (1)
select * from saletype where sgcode='ZZZZZZ' into curs tcomp
sele tcomp
go top
scan
	sele support
	seek 'F'+'MXDISC% '+tcomp.scode
	if !found()
		appen blank
		repl type with 'F'
		repl aliase with 'MXDISC% '
		repl lcode with tcomp.scode
	endif
	repl remark with '  5.50  0.00  0.00  0.00  7.00  0.00  0.00  0.00    0.00    0.00N               '
endsca
=messagebox('Company Maximum Discount Updated','MargErp')
