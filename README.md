# Analysis pipeline
This repository provides a framework for thyroid cancer GWAS clustering using Bayesian non-negative matrix factorization (bNMF). Please refer to our manuscript for details "Genetic drivers of etiologic heterogeneity in thyroid cancer" Jee YH, Pozdeyev N, Gignoux CR, et al. medRxiv 2025.05.15.25327708; doi: https://doi.org/10.1101/2025.05.15.25327708

## 1. Meta-analysis
`MA_KCPS2_GBMI_FinnGen_MVP_leave_UKB_GHI_LAT_PMBB.sh` and `MA_KCPS2_GBMI_FinnGen_MVP_leave_UKB_GHI_LAT_PMBB.txt` provide the generalized script for running METAL. We conducted a fixed-effect meta-analysis of thyroid cancer using inverse-variance weighting, combining GWAS summary statistics from two meta-analyses (the GBMI meta-analysis and a separate meta-analysis of FinnGen R12 and MVP) and four individual biobanks (the the Korean Cancer Prevention Study-II Biobank, Latvian National Biobank, Penn Medicine BioBank, and Genomic Health Initiative).

## 2. Fetch sumstats
`/fetch_sumstats/fetch_*.sh` in provides the scripts for fetching summary statistics of specified list of SNPs from corresponding phenotype data. In our project, we extracted 66 thyroid cancer lead variants from 151 phenotypes summary statistics across multiple biobanks.

## 3. Construct Z-score matrix
`Construct_Z_matrix.Rmd` loads fetched summary statistics across phenotypes and construct Z score matrix (N variants x M phenotypes).

## 4. Run bNMF
`bNMF_thyroid_cancer.Rmd` provides a pipeline for bNMF to cluster GWAS variants. This is a modified pipeline available in https://github.com/gwas-partitioning/bnmf-clustering/blob/master/scripts/bNMF_example_pipeline.R from Smith, K., Deutsch, A.J., McGrail, C. et al. Multi-ancestry polygenic mechanisms of type 2 diabetes. Nat Med 30, 1065–1074 (2024). https://doi.org/10.1038/s41591-024-02865-3. 

## 5. Enrichment analysis
`Excess_overlap.Rmd` computes excess overlap to assess whether cluster-specific variants exhibit significant overlap with cell-type-specific regulatory elements (Kim et al. Am J Hum Genet. 2019. doi: 10.1016/j.ajhg.2019.03.020). We applied this metric to five binary cell-type annotation datasets used in LD Score regression with Specifically Expressed Genes (LDSC-SEG) (Finucane et al. Nat Genet. 2018. https://doi.org/10.1038/s41588-018-0081-4): GTEx, Franke, ImmGen, Roadmap, and EN-TEx (`/run_excess_overlap/Excess_overlap_perm_*_array.R`). The statistical significance of annotations in each cluster was assessed using a permutation test. For each cluster, we permuted annot1 values (thyroid cancer index variant indicators) and recalculated the excess overlap using shuffled labels. After 10,000 permutations, we compared the observed excess overlap to the permuted background using a one-tailed test to determine the significance of each annotation. We corrected for multiple tests and considered statistically significant enrichment at q-value thresholds of 0.1 and 0.001, using Bonferroni correction (for 53 tissues in GTEx, 152 tissues in Franke, 292 immune cell types in ImmGen, 396 in Roadmap, 93 in EN-TEx).

