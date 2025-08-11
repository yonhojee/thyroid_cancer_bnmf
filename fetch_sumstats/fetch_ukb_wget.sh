#!/bin/bash

cd /bNMF/fetch_sumstats/filtered_files

# Define URLs, output directory, and pattern file
URL_BASE="https://pan-ukb-us-east-1.s3.amazonaws.com/sumstats_flat_files/"
DIR3="/UKB/"
PATTERN_FILE="/bNMF/fetch_sumstats/all_harmonized_markers.tmp"
OUTPUT_DIR="/bNMF/fetch_sumstats/filtered_files/"

# Define the list of file names
declare -a FILES=(
    "biomarkers-30600-both_sexes-irnt.tsv.bgz"
    "biomarkers-30610-both_sexes-irnt.tsv.bgz"
    "biomarkers-30620-both_sexes-irnt.tsv.bgz"
    "biomarkers-30630-both_sexes-irnt.tsv.bgz"
    "biomarkers-30640-both_sexes-irnt.tsv.bgz"
    "biomarkers-30650-both_sexes-irnt.tsv.bgz"
    "biomarkers-30660-both_sexes-irnt.tsv.bgz"
    "biomarkers-30670-both_sexes-irnt.tsv.bgz"
    "biomarkers-30680-both_sexes-irnt.tsv.bgz"
    "biomarkers-30690-both_sexes-irnt.tsv.bgz"
    "biomarkers-30700-both_sexes-irnt.tsv.bgz"
    "biomarkers-30710-both_sexes-irnt.tsv.bgz"
    "biomarkers-30720-both_sexes-irnt.tsv.bgz"
    "biomarkers-30730-both_sexes-irnt.tsv.bgz"
    "biomarkers-30740-both_sexes-irnt.tsv.bgz"
    "biomarkers-30750-both_sexes-irnt.tsv.bgz"
    "biomarkers-30760-both_sexes-irnt.tsv.bgz"
    "biomarkers-30780-both_sexes-irnt.tsv.bgz"
    "biomarkers-30790-both_sexes-irnt.tsv.bgz"
    "biomarkers-30810-both_sexes-irnt.tsv.bgz"
    "biomarkers-30820-both_sexes-irnt.tsv.bgz"
    "biomarkers-30840-both_sexes-irnt.tsv.bgz"
    "biomarkers-30860-both_sexes-irnt.tsv.bgz"
    "biomarkers-30870-both_sexes-irnt.tsv.bgz"
    "biomarkers-30880-both_sexes-irnt.tsv.bgz"
    "biomarkers-30890-both_sexes-irnt.tsv.bgz"
    "continuous-30000-both_sexes-irnt.tsv.bgz"
    "continuous-30010-both_sexes-irnt.tsv.bgz"
    "continuous-30020-both_sexes-irnt.tsv.bgz"
    "continuous-30030-both_sexes-irnt.tsv.bgz"
    "continuous-30040-both_sexes-irnt.tsv.bgz"
    "continuous-30050-both_sexes-irnt.tsv.bgz"
    "continuous-30060-both_sexes-irnt.tsv.bgz"
    "continuous-30070-both_sexes-irnt.tsv.bgz"
    "continuous-30080-both_sexes-irnt.tsv.bgz"
    "continuous-30090-both_sexes-irnt.tsv.bgz"
    "continuous-30100-both_sexes-irnt.tsv.bgz"
    "continuous-30110-both_sexes-irnt.tsv.bgz"
    "continuous-30120-both_sexes-irnt.tsv.bgz"
    "continuous-30130-both_sexes-irnt.tsv.bgz"
    "continuous-30140-both_sexes-irnt.tsv.bgz"
    "continuous-30150-both_sexes-irnt.tsv.bgz"
    "continuous-30160-both_sexes.tsv.bgz"
    "continuous-30170-both_sexes.tsv.bgz"
    "continuous-30180-both_sexes-irnt.tsv.bgz"
    "continuous-30190-both_sexes-irnt.tsv.bgz"
    "continuous-30200-both_sexes-irnt.tsv.bgz"
    "continuous-30210-both_sexes-irnt.tsv.bgz"
    "continuous-30220-both_sexes-irnt.tsv.bgz"
    "continuous-30230-both_sexes.tsv.bgz"
    "continuous-30240-both_sexes-irnt.tsv.bgz"
    "continuous-30250-both_sexes-irnt.tsv.bgz"
    "continuous-30260-both_sexes-irnt.tsv.bgz"
    "continuous-30270-both_sexes-irnt.tsv.bgz"
    "continuous-30280-both_sexes-irnt.tsv.bgz"
    "continuous-30290-both_sexes-irnt.tsv.bgz"
    "continuous-30300-both_sexes-irnt.tsv.bgz"
    "continuous-30500-both_sexes-irnt.tsv.bgz"
    "continuous-30510-both_sexes-irnt.tsv.bgz"
    "continuous-30520-both_sexes-irnt.tsv.bgz"
    "continuous-30530-both_sexes-irnt.tsv.bgz"
    "continuous-3148-both_sexes-irnt.tsv.bgz"
    "continuous-23105-both_sexes-irnt.tsv.bgz"
    "continuous-23099-both_sexes-irnt.tsv.bgz"
    "continuous-23127-both_sexes-irnt.tsv.bgz"
    "continuous-4079-both_sexes-irnt.tsv.bgz"
    "continuous-4080-both_sexes-irnt.tsv.bgz"
    "continuous-48-both_sexes-irnt.tsv.bgz"
    "continuous-49-both_sexes-irnt.tsv.bgz"
    "continuous-FEV1FVC-both_sexes-irnt.tsv.bgz"
    "continuous-whr-both_sexes-irnt.tsv.bgz"
    "continuous-eGFR-both_sexes-irnt.tsv.bgz"
    "continuous-20127-both_sexes-irnt.tsv.bgz"
    "continuous-PP-both_sexes-auto_irnt.tsv.bgz"
    "continuous-12340-both_sexes-irnt.tsv.bgz"
    
    "continuous-MAP-both_sexes-auto_irnt.tsv.bgz"
    "continuous-12336-both_sexes-irnt.tsv.bgz"
    "continuous-12338-both_sexes-irnt.tsv.bgz"
    "continuous-21021-both_sexes-irnt.tsv.bgz"
    "continuous-4194-both_sexes-irnt.tsv.bgz"
    
    "biomarkers-30770-both_sexes-irnt.tsv.bgz"
    "biomarkers-30800-both_sexes-irnt.tsv.bgz"
    "biomarkers-30830-both_sexes-irnt.tsv.bgz"
    "biomarkers-30850-both_sexes-irnt.tsv.bgz"
    "phecode-255.21-both_sexes.tsv.bgz"
    "prescriptions-hydrocortisone-both_sexes.tsv.bgz"
)

# Get the specific file for the current task
FILE_NAME=${FILES[$((SLURM_ARRAY_TASK_ID - 1))]}
FILE_PATH="${DIR3}${FILE_NAME}"

# Step 1: Download the file
if [ ! -f "$FILE_PATH" ]; then
    echo "Downloading $FILE_NAME..."
    wget -q "${URL_BASE}${FILE_NAME}" -O "$FILE_PATH"
else
    echo "$FILE_NAME already downloaded."
fi

# Extract base name for the file
BASE_NAME=$(basename $FILE_PATH .tsv.bgz)
OUTPUT_FILE="${OUTPUT_DIR}${BASE_NAME}_filtered.tsv"

# Step 2: Extract columns of interest and add SNP column
zcat $FILE_PATH | awk '
BEGIN { FS = "\t"; OFS = "\t" }
NR == 1 {
    # Identify column indices for required columns
    for (i = 1; i <= NF; i++) {
        if ($i == "chr") chr_col = i
        if ($i == "pos") pos_col = i
        if ($i == "ref") ref_col = i
        if ($i == "alt") alt_col = i

        # Check for available beta, se, and p-value columns
        if ($i == "beta_meta_hq" || $i == "beta_meta" || $i == "beta_EUR") beta_col = i
        if ($i == "se_meta_hq" || $i == "se_meta" || $i == "se_EUR") se_col = i
    }

    # Ensure that fallback columns are captured
    if (!beta_col) beta_col = "NA"
    if (!se_col) se_col = "NA"

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
}' > extracted_ukb_${SLURM_ARRAY_TASK_ID}.tsv

# Step 2: Filter rows based on "harmonized_marker"
awk 'NR == FNR { patterns[$1]; next } NR == 1 || $1 in patterns' $PATTERN_FILE extracted_ukb_${SLURM_ARRAY_TASK_ID}.tsv > $OUTPUT_FILE

# Remove intermediate file
rm extracted_ukb_${SLURM_ARRAY_TASK_ID}.tsv
mv fetch_ukb_wget_${SLURM_ARRAY_TASK_ID}.err fetch_ukb_wget_${BASE_NAME}.err
mv fetch_ukb_wget_${SLURM_ARRAY_TASK_ID}.out fetch_ukb_wget_${BASE_NAME}.out

# Step 4: Remove the downloaded file
if [ -f "$FILE_PATH" ]; then
    echo "Removing downloaded file: $FILE_PATH"
    rm "$FILE_PATH"
fi

# Log the saved file
echo "Filtered file saved as: $OUTPUT_FILE"
