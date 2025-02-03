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

for i in 2 3 4 5 6 7; do
    eval pair=\$fpair$i
    eval ref=\$fpair$((i-1))
    eval frameasc=\$f$i'a'
    eval framedes=\$f$i'b'

    frames1=$ref
    frames2=$pair

    for keystr in EW UD; do
        diff1=$frames1'_'$keystr'.geo.tif'
        diff2=$frames2'_'$keystr'.geo.tif'
        R=`gmt grdselect $diff1 $diff2 -Ai`

        gmt grdcut $diff1 -G$frames1.$keystr.geo.ovlp.tif=gd:GTiff $R
        gmt grdcut $diff2 -G$frames2.$keystr.geo.ovlp.tif=gd:GTiff $R

        M1=$frames1.$keystr.geo.ovlp.tif
        M2=$frames2.$keystr.geo.ovlp.tif
        gdalwarp2match.py $M2 $M1 $frames2.$keystr.geo.ovlp.ok.tif
        mv $frames2.$keystr.geo.ovlp.ok.tif $frames2.$keystr.geo.ovlp.tif

        gmt grdmath $M1 $M2 SUB MEDIAN = tempmedian.nc
        difference=`gmt grdinfo tempmedian.nc | grep v_min | awk {'print $3'}`
        rm tempmedian.nc

        gmt grdmath $diff2 $difference ADD = $frames2.$keystr.geo.adjusted$i.tif
        rm $M1
        rm $M2
    done
done
