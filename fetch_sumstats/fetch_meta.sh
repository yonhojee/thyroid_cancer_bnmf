#!/bin/bash

cd /bNMF/fetch_sumstats/filtered_files

# Define directory and pattern file
DIR3="./KCPS2/"
PATTERN_FILE="/bNMF/fetch_sumstats/all_harmonized_markers.tmp"
OUTPUT_DIR="/bNMF/fetch_sumstats/filtered_files/"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Declare an array variable
#declare -a arr=("KCPS2_GBMI_FinnGen_MVP_ThC_FUMA" "TSH_ref" "FT4_ref" "T3_ref")
declare -a arr=("TSH_ref" "FT4_ref" "T3_ref" "FT3" "KCPS2_GBMI_FinnGen_MVP_ukb_out_GHI_LAT_PMBB_ThC")

i=${SLURM_ARRAY_TASK_ID}-1
trait="${arr[i]}"
FILE="${DIR3}meta_${trait}.txt.gz"
OUTPUT_FILE="${OUTPUT_DIR}${trait}_filtered.tsv"

# Step 1: Extract SNP, BETA, SE, EFFECT_ALLELE, and OTHER_ALLELE columns
zcat $FILE | awk '
BEGIN { FS = "\t"; OFS = "\t" }
NR == 1 {
    # Identify column indices for required columns
    for (i = 1; i <= NF; i++) {
        if ($i == "SNP") SNP_col = i
        if ($i == "BETA") beta_col = i
        if ($i == "SE") se_col = i
        if ($i == "EFFECT_ALLELE") effect_allele_col = i
        if ($i == "OTHER_ALLELE") other_allele_col = i
    }

    # Print header for selected columns
    print "SNP", "BETA", "SE", "EFFECT_ALLELE", "OTHER_ALLELE"
    next
}
{
    # Print required columns
    print $SNP_col, $beta_col, $se_col, $effect_allele_col, $other_allele_col
}' > extracted_meta_${SLURM_ARRAY_TASK_ID}.tsv

# Step 2: Filter rows based on "SNP"
awk 'NR == FNR { patterns[$1]; next } NR == 1 || $1 in patterns' $PATTERN_FILE extracted_meta_${SLURM_ARRAY_TASK_ID}.tsv > $OUTPUT_FILE

# Remove intermediate file
rm extracted_meta_${SLURM_ARRAY_TASK_ID}.tsv
mv fetch_meta_${SLURM_ARRAY_TASK_ID}.err fetch_meta_${trait}.err
mv fetch_meta_${SLURM_ARRAY_TASK_ID}.out fetch_meta_${trait}.out

# Log the saved file
echo "Filtered file saved as: $OUTPUT_FILE"
