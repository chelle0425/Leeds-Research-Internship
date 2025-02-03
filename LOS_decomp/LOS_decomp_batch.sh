#!/bin/bash
f1a=173A_05350_131313
f1b=005D_05398_131313
fpair1=$f1a'_'$f1b
f2a=042A_05535_131313
f2b=049D_05534_131313
fpair2=$f2a'_'$f2b
f3a=115A_05608_131313
f3b=122D_05571_131313
fpair3=$f3a'_'$f3b
f4a=115A_05409_131313
f4b=122D_05372_131313
fpair4=$f4a'_'$f4b
f5a=042A_05336_131313
f5b=049D_05335_131313
fpair5=$f5a'_'$f5b
f6a=071A_05440_131313
f6b=078D_05435_131313
fpair6=$f6a'_'$f6b
f7a=144A_05476_141414
f7b=151D_05440_131313
fpair7=$f7a'_'$f7b

# for pair in $fpair1 $fpair2 $fpair3 $fpair4 $fpair5 $fpair6 $fpair7; do
for i in 1 2 3 4 5 6 7; do
    eval pair=\$fpair$i
    eval frameasc=\$f$i'a'
    eval framedes=\$f$i'b'
    echo -e "tosend/${frameasc}.vel_filt.mskd.geo.tif tosend/${frameasc}.geo.E.tif tosend/${frameasc}.geo.N.tif\n\
tosend/${framedes}.vel_filt.geo.tif tosend/${framedes}.geo.E.tif tosend/${framedes}.geo.N.tif" > "decomp_${pair}.txt"
    LiCSBAS_decomposeLOS.py -f 'decomp'_$pair.txt
    mv EW.geo.tif $pair'_EW'.mskd.geo.tif
    mv UD.geo.tif $pair'_UD'.mskd.geo.tif

done

