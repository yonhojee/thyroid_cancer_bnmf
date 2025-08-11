#!/bin/bash

cd /bNMF/fetch_sumstats/filtered_files

# Define directory and pattern file
DIR3="/FinnGen/"
DIR4="/MVP/"
PATTERN_FILE="/bNMF/fetch_sumstats/all_harmonized_markers_hg38.tmp"
OUTPUT_DIR="/bNMF/fetch_sumstats/filtered_files/"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Declare an array with file paths
declare -a FILES=(
    "/FinnGen/AUTOIMMUNE_HYPERTHYROIDISM_meta_out.tsv.gz"
    "/FinnGen/AUTOIMMUNE_meta_out.tsv.gz"
    "/FinnGen/AUTOIMMUNE_NONTHYROID_meta_out.tsv.gz"
    "/FinnGen/BMI_meta_out.tsv.gz"
    "/FinnGen/C3_BASAL_CELL_CARCINOMA_EXALLC_meta_out.tsv.gz"
    "/FinnGen/C3_BREAST_ERNEG_EXALLC_meta_out.tsv.gz"
    "/FinnGen/C3_BREAST_ERPLUS_EXALLC_meta_out.tsv.gz"
    "/FinnGen/C3_CANCER_EXALLC_meta_out.tsv.gz"
    "/FinnGen/C3_GBM_EXALLC_meta_out.tsv.gz"
    "/FinnGen/C3_HEAD_AND_NECK_EXALLC_meta_out.tsv.gz"
    "/FinnGen/C3_MELANOMA_SKIN_EXALLC_meta_out.tsv.gz"
    "/FinnGen/C3_OVARY_EXALLC_meta_out.tsv.gz"
    "/FinnGen/C3_PROSTATE_EXALLC_meta_out.tsv.gz"
    "/FinnGen/CD2_BENIGN_LEIOMYOMA_UTERI_meta_out.tsv.gz"
    "/FinnGen/CD2_MULTIPLE_MYELOMA_PLASMA_CELL_EXALLC_meta_out.tsv.gz"
    "/FinnGen/CHIRBIL_PRIM_meta_out.tsv.gz"
    "/FinnGen/E4_GRAVES_STRICT_meta_out.tsv.gz"
    "/FinnGen/E4_NONTOXIC_THYROID_meta_out.tsv.gz"
    "/FinnGen/E4_PCOS_BROAD_meta_out.tsv.gz"
    "/FinnGen/E4_THYROIDITAUTOIM_meta_out.tsv.gz"
    "/FinnGen/F5_DEPRESSIO_meta_out.tsv.gz"
    "/FinnGen/HEIGHT_meta_out.tsv.gz"
    "/FinnGen/I9_STR_meta_out.tsv.gz"
    "/FinnGen/ILD_ENDPOINTS_meta_out.tsv.gz"
    "/FinnGen/K11_COELIAC_meta_out.tsv.gz"
    "/FinnGen/WEIGHT_meta_out.tsv.gz"
)

FILE=${FILES[$((SLURM_ARRAY_TASK_ID - 1))]}

# Extract base name for the file (before _meta_out.tsv.gz)
BASE_NAME=$(basename $FILE | sed 's/_meta_out\.tsv\.gz$//')
OUTPUT_FILE="${OUTPUT_DIR}${BASE_NAME}_filtered.tsv"

# Step 1: Extract required columns and create harmonized_marker
zcat $FILE | awk '
BEGIN { FS = "\t"; OFS = "\t" }
NR == 1 {
    # Identify column indices for required columns
    for (i = 1; i <= NF; i++) {
        if ($i == "#CHR") chr_col = i
        if ($i == "POS") pos_col = i
        if ($i == "all_inv_var_meta_beta") beta_col = i
        if ($i == "all_inv_var_meta_sebeta") se_col = i
        if ($i == "ALT") alt_col = i
        if ($i == "REF") ref_col = i
    }

    # Print header for selected columns
    print "harmonized_marker", "all_inv_var_meta_beta", "all_inv_var_meta_sebeta", "ALT", "REF"
    next
}
{
    # Construct harmonized_marker using REF and ALT alleles
    min_allele = ($ref_col < $alt_col) ? $ref_col : $alt_col;
    max_allele = ($ref_col > $alt_col) ? $ref_col : $alt_col;
    harmonized_marker = $chr_col ":" $pos_col ":" min_allele ":" max_allele;

    # Print required columns
    print harmonized_marker, $beta_col, $se_col, $alt_col, $ref_col
}' > extracted_finngen_ukb_${SLURM_ARRAY_TASK_ID}.tsv

# Step 2: Filter rows based on "harmonized_marker"
awk 'NR == FNR { patterns[$1]; next } NR == 1 || $1 in patterns' $PATTERN_FILE extracted_finngen_ukb_${SLURM_ARRAY_TASK_ID}.tsv > $OUTPUT_FILE

# Remove intermediate file
rm extracted_finngen_ukb_${SLURM_ARRAY_TASK_ID}.tsv
mv fetch_finngen_ukb_${SLURM_ARRAY_TASK_ID}.err fetch_finngen_ukb_${BASE_NAME}.err
mv fetch_finngen_ukb_${SLURM_ARRAY_TASK_ID}.out fetch_finngen_ukb_${BASE_NAME}.out

# Log the saved file
echo "Filtered file saved as: $OUTPUT_FILE"
