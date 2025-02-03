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
f8a=144A_05476_141414
f8b=151D_05639_131313
fpair8=$f8a'_'$f8b


keystr="coh_avg"

for i in {1..8}; do
    eval current_pair=\$fpairs$i
    eval framekey1=\$f$i'a'
    eval framekey2=\$f$i'b'
    frame1=tosend2/$framekey1.$keystr.geo.tif
    framekey1poly=poly_txt/$framekey1-poly.txt
    gmt grdcut $frame1 -G$framekey1.geo.cropped.tif=gd:GTiff -F$framekey1poly+c
    frame1=$framekey1.geo.cropped.tif
    gmt grdmath $frame1 0 NAN = $frame1

    frame2=tosend2/$framekey2.$keystr.geo.tif
    framekey2poly=poly_txt/$framekey2-poly.txt
    gmt grdcut $frame2 -G$framekey2.geo.cropped.tif=gd:GTiff -F$framekey2poly+c
    frame2=$framekey2.geo.cropped.tif
    gmt grdmath $frame2 0 NAN = $frame2

    R=`gmt grdselect $frame1 $frame2 -Ai`

    gmt grdcut $frame1 -G$framekey1.$keystr.geo.ovlp.tif=gd:GTiff $R
    gmt grdcut $frame2 -G$framekey2.$keystr.geo.ovlp.tif=gd:GTiff $R

    M1=$framekey1.$keystr.geo.ovlp.tif
    M2=$framekey2.$keystr.geo.ovlp.tif
    gdalwarp2match.py $M2 $M1 $framekey2.$keystr.geo.ovlp.ok.tif
    mv $framekey2.$keystr.geo.ovlp.ok.tif $framekey2.$keystr.geo.ovlp.tif

    gmt grdmath $M2 $M1 ADD 2 DIV = $framekey1'_'$framekey2.$keystr.geo.tif
    gmt grdmath $framekey1'_'$framekey2.$keystr.geo.tif 0 NAN = $framekey1'_'$framekey2.$keystr'_new'.geo.tif

    rm $M1
    rm $M2
    rm $framekey1.geo.cropped.tif
    rm $framekey2.geo.cropped.tif

done
