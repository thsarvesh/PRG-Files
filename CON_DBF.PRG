clea
close all
dmlen=adir(dmarr,"*.DBF")
if dmlen>0
   for i=1 to dmlen
       filnm=dmarr(i,1)
       sele sele(1)
       use &filnm
       brow
       use
   next
endif