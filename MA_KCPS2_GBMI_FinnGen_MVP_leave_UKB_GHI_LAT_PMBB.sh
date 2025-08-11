#!/bin/bash

outdir="/Thyroid/MA"
outdir1="/GWAS_output"

cd /METAL/METAL/build/bin

for trait in ThC
do
	echo $trait
	./metal ${outdir}/MA_KCPS2_GBMI_FinnGen_MVP_leave_UKB_GHI_LAT_PMBB.txt
	mv ${outdir1}/MA_KCPS2_GBMI_FinnGen_MVP_ukb_GHI_LAT_PMBB1.tbl ${outdir1}/MA_KCPS2_GBMI_FinnGen_MVP_ukb_GHI_LAT_PMBB_${trait}.tbl
	mv ${outdir1}/MA_KCPS2_GBMI_FinnGen_MVP_ukb_GHI_LAT_PMBB1.tbl.info ${outdir1}/MA_KCPS2_GBMI_FinnGen_MVP_ukb_GHI_LAT_PMBB_${trait}.tbl.info
	echo "done"
done


