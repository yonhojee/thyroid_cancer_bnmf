- Analysis pipeline
This repository provides a generalized framework for ###. Please refer to our manuscript for details "Genetic drivers of etiologic heterogeneity in thyroid cancer" Jee YH, Pozdeyev N, Gignoux CR, et al. medRxiv 2025.05.15.25327708; doi: https://doi.org/10.1101/2025.05.15.25327708

1. Meta-analysis
MA_KCPS2_GBMI_FinnGen_MVP_leave_UKB_GHI_LAT_PMBB.sh
MA_KCPS2_GBMI_FinnGen_MVP_leave_UKB_GHI_LAT_PMBB.txt

2. Fetch sumstats directly using bash script → save cluster SNPs filtered tsv for each trait
fetch_*.sh
Bash scripts to fetch summary statistics

3. Construct Z-score matrix
Construct_Z_matrix.Rmd

4. Run bNMF
bNMF_thyroid_cancer.Rmd

5. Enrichment
Excess_overlap.Rmd
