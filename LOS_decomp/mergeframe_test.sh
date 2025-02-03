#!/bin/bash

frames1="144A_05476_141414_151D_05440_131313"
frames2="144A_05476_141414_151D_05639_131313"


for keystr in EW UD; do
    diff1=$frames1'_'$keystr'.mskd.geo.adjusted.tif'
    diff2=$frames2'_'$keystr'.mskd.geo.tif'
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

    gmt grdmath $diff2 $difference ADD = $frames2'_'$keystr.mskd.geo.adjusted.tif
    rm $M1
    rm $M2
done


