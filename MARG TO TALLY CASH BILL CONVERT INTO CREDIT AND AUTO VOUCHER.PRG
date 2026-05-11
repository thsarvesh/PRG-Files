close table all
sele sele (1)
use &datdev\mdis.&datext alias mdis
index on voucher to mdis
sele sele (1)
select * from mdis where substr(misc3,35,1)='C' and type='P' into curs tmdis readwr
sele sele(1)
use &datdev\gledger.&datext alias gle
sele sele(1)
use &datdev\slipno.&datext alias mslip
go top
last4  = voucher + 10
slast5 = svoucher + 10
last4 = last4 + 20

sele tmdis
go top
scan
	sele gle
	appen blank
	repl voucher with last4
	repl vcsno with tmdis.vcn
	repl code with 'STACO3'
	repl date with tmdis.date
	repl code1 with tmdis.codep
	repl cd with 'C'
	repl Credit with tmdis.cash+tmdis.final
	repl book with 'P'
	
	sele gle
	appen blank
	repl voucher with last4
	repl vcsno with tmdis.vcn
	repl code with tmdis.codep
	repl date with tmdis.date
	repl code1 with 'STACO3'
	repl cd with 'D'
	repl debit with tmdis.cash+tmdis.final
	repl book with 'P'
	last4=last4+10
	sele mdis
	seek tmdis.voucher
	if found()
		repl misc3 with  substr(misc3,1,34)+'R'+substr(misc3,36,100)
		repl cash with 0
	endif
endscan
sele mslip
repl voucher with last4+10
repl svoucher with slast5+10
clos table all
