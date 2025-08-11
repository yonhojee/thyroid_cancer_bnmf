Genetic drivers of etiologic heterogeneity in thyroid cancer

#===========================================================
1. Meta-analysis
#===========================================================
MA_KCPS2_GBMI_FinnGen_MVP_leave_UKB_GHI_LAT_PMBB.sh
MA_KCPS2_GBMI_FinnGen_MVP_leave_UKB_GHI_LAT_PMBB.txt

#===========================================================
1. Fetch sumstats directly using bash script → save cluster SNPs filtered tsv for each trait
#===========================================================
fetch_*.sh
# Bash scripts to fetch summary statistics

#===========================================================
2. Construct Z-score matrix
#===========================================================
Construct_Z_matrix.Rmd

#===========================================================
3. Run bNMF
#===========================================================
bNMF_thyroid_cancer.Rmd

#===========================================================
4. Enrichment
#===========================================================
Excess_overlap.Rmd
