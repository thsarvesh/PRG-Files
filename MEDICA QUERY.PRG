
-------------------------------------------------------------------------------------------------------
select itemdetailid,batchno,
iif(schqtyadjincurr<>0 and schamt<>0,sum(qty),sum(qty+schqty)) as mqty,
iif(damaged=1,iif(schqtyadjincurr<>0 and schamt<>0,sum(qty),sum(qty+schqty)),0) as dqty
into myin from tbl_inward where UsrDate<'2022-04-01'  group by ItemDetailId,batchno,schqtyadjincurr,schamt,Damaged   

select itemdetailid,batchno,
iif(schqtyadjincurr<>0 and schamt<>0,sum(qty),sum(qty+schqty)) as mqty,
iif(damaged=1,iif(schqtyadjincurr<>0 and schamt<>0,sum(qty),sum(qty+schqty)),0) as dqty
into myout from tbl_outward where UsrDate<'2022-04-01'  group by ItemDetailId,batchno,schqtyadjincurr,schamt,Damaged   

select * into tbl_out from tbl_Outward where usrdate>'2022-03-31'
drop table tbl_outward
exec sp_rename 'tbl_out','tbl_outward'
