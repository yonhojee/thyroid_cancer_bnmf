#!/bin/bash

cd /bNMF/fetch_sumstats/filtered_files

# Define directory and pattern file
DIR3="/GWASCatalog/"
PATTERN_FILE="/bNMF/fetch_sumstats/all_rsid.tmp"
OUTPUT_DIR="/bNMF/fetch_sumstats/filtered_files/"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Declare an array variable
declare -a arr=("GCST90165257")

i=${SLURM_ARRAY_TASK_ID}-1
trait="${arr[i]}"
FILE="${DIR3}${trait}.h.tsv.gz"
OUTPUT_FILE="${OUTPUT_DIR}${trait}_filtered.tsv"

# Step 1: Extract rsids, BETA, SE, EFFECT_ALLELE, and OTHER_ALLELE columns
zcat $FILE | awk '
BEGIN { FS = "\t"; OFS = "\t" }
NR == 1 {
    # Identify column indices for required columns
    for (i = 1; i <= NF; i++) {
        if ($i == "rsid") rsids_col = i
        if ($i == "odds_ratio") beta_col = i
        if ($i == "ci_upper") ci_upper_col = i
        if ($i == "ci_lower") ci_lower_col = i
        if ($i == "effect_allele") effect_allele_col = i
        if ($i == "other_allele") other_allele_col = i
    }

    # Check if required columns are found
    if (!(rsids_col && beta_col && effect_allele_col && other_allele_col)) {
        print "Error: Missing required columns" > "/dev/stderr"
        exit 1
    }

    # Print header for selected columns including calculated sebeta
    print "rsids", "beta", "sebeta", "effect_allele", "other_allele"
    next
}
{
    # Calculate sebeta using ci_upper and ci_lower, if available
    if (ci_upper_col && ci_lower_col && $ci_upper_col != "NA" && $ci_lower_col != "NA") {
        sebeta = ($ci_upper_col - $ci_lower_col) / (2 * 1.96)
    } else {
        sebeta = "NA"
    }

    # Print required columns along with calculated sebeta
    print $rsids_col, $beta_col, sebeta, $effect_allele_col, $other_allele_col
}' > extracted_gwascat_${SLURM_ARRAY_TASK_ID}.tsv

# Step 2: Filter rows based on "rsids"
awk 'NR == FNR { patterns[$1]; next } NR == 1 || $1 in patterns' $PATTERN_FILE extracted_gwascat_${SLURM_ARRAY_TASK_ID}.tsv > $OUTPUT_FILE

# Remove intermediate file
#rm extracted_gwascat_${SLURM_ARRAY_TASK_ID}.tsv
mv fetch_gwascat_${SLURM_ARRAY_TASK_ID}.err fetch_gwascat_${trait}.err
mv fetch_gwascat_${SLURM_ARRAY_TASK_ID}.out fetch_gwascat_${trait}.out

# Log the saved file
echo "Filtered file saved as: $OUTPUT_FILE"
