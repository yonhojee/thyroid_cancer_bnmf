#!/bin/bash

cd /bNMF/fetch_sumstats/filtered_files

# Define directory and pattern file
DIR3="/BBJ/"
PATTERN_FILE="/bNMF/fetch_sumstats/all_harmonized_markers.tmp"
OUTPUT_DIR="/bNMF/fetch_sumstats/filtered_files/"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Declare an array variable
declare -a arr=("Mosaic_loss_of_chromosome_Y")

i=${SLURM_ARRAY_TASK_ID}-1
trait="${arr[i]}"
FILE="${DIR3}${trait}"
OUTPUT_FILE="${OUTPUT_DIR}${trait}_filtered.tsv"

# Step 1: Extract required columns and create harmonized_marker
zcat $FILE | awk '
BEGIN { FS = "\t"; OFS = "\t" }
NR == 1 {
    # Identify column indices for required columns
    for (i = 1; i <= NF; i++) {
        if ($i == "chrom") chr_col = i
        if ($i == "pos") pos_col = i
        if ($i == "beta") beta_col = i
        if ($i == "sebeta") se_col = i
        if ($i == "alt") alt_col = i
        if ($i == "ref") ref_col = i
    }

    # Print header for selected columns
    print "harmonized_marker", "beta", "sebeta", "alt", "ref"
    next
}
{
    # Construct harmonized_marker using ref and alt alleles
    min_allele = ($ref_col < $alt_col) ? $ref_col : $alt_col;
    max_allele = ($ref_col > $alt_col) ? $ref_col : $alt_col;
    harmonized_marker = $chr_col ":" $pos_col ":" min_allele ":" max_allele;

    # Print required columns
    print harmonized_marker, $beta_col, $se_col, $alt_col, $ref_col
}' > extracted_bbj_${SLURM_ARRAY_TASK_ID}.tsv

# Step 2: Filter rows based on "harmonized_marker"
awk 'NR == FNR { patterns[$1]; next } NR == 1 || $1 in patterns' $PATTERN_FILE extracted_bbj_${SLURM_ARRAY_TASK_ID}.tsv > $OUTPUT_FILE

# Remove intermediate file
rm extracted_bbj_${SLURM_ARRAY_TASK_ID}.tsv
mv fetch_bbj_${SLURM_ARRAY_TASK_ID}.err fetch_bbj_${trait}.err
mv fetch_bbj_${SLURM_ARRAY_TASK_ID}.out fetch_bbj_${trait}.out

# Log the saved file
echo "Filtered file saved as: $OUTPUT_FILE"
