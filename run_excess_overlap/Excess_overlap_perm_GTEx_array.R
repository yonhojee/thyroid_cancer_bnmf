library(data.table);library(dplyr);library(tidyr);library(stats) # For one-tailed test
library(readxl)

#===========================================
# Define changing parameters
args = commandArgs(trailingOnly = TRUE)
ld_index_start = (as.numeric(args[1]) - 1) * 500 + 1
ld_index_stop = ld_index_start + 499 #ld_index_stop = ld_index_start

print(paste0("from=",ld_index_start));print(paste0("to=",ld_index_stop))
print("start")
#===========================================
k=5; cutoff=1.057017 #2025-05-13 #k=4; cutoff=1.058735 #2025-05-12; #k=5; cutoff=0.955435 #2025-05-08
df <- read_excel(paste0("/bNMF/test_results/sorted_cluster_weights_K",k,"_rev.xlsx")) 
df_var <- df %>%
  filter(!is.na(VAR_ID)) %>%
  dplyr::select(1:(k+3)) %>%
  dplyr::rename_at(vars(4:(k+3)), ~paste0("W", 1:k))
res_genes <- df_var

dir="/ldsc/"

cts_name="Multi_tissue_gene_expr"
print(cts_name)
cts <- fread(paste0(dir,cts_name,".ldcts"),header = F, sep = "\t", data.table = F) %>%
  separate(V2,c("file_name","control"),",")
dir_annot <- paste0("/ldsc/Merged/",cts_name,"_1000Gv3_ldscores/")

annot_name = "GTEx"
cell_annotations <- cts[1:which(cts$V1=="Whole_Blood"),] #_GTEx
print(annot_name)
#===========================================

res_genes_bin <- data.frame(rsID=res_genes$rsID,
                            ifelse(res_genes[,paste0("W", 1:k)]>cutoff,1,0))
Merge_All_Samples <- fread(paste0(dir_annot,"All_",annot_name,".gz"),data.table = F) 
cluster_annotations <- Merge_All_Samples %>%
  left_join(.,res_genes_bin,by=c("SNP"="rsID")) %>%
  mutate_at(vars(paste0("W", 1:k)), ~replace_na(., 0))
dim(cluster_annotations) #[1] 9997231      60
#===========================================
# Function to calculate EO (custom based on your method)
calculate_EO <- function(cluster_annotations, cell_annotations, annot_name) {
  cts <- cell_annotations
  
  df_excess_overlap <- data.frame()
  
  Merge_All_Samples <- cluster_annotations
  
  for(gs in c(1:nrow(cts))) { #
    excess_overlap <- c()
    #print(paste0("gs=",gs))
    for(cs in 1:k){
      # print(paste0("cs=",cs));print(paste0("gs+1=",gs+1));print(paste0("cs+nrow(cts)+1=",cs+nrow(cts)+1))
      # print(head(Merge_All_Samples))
      annot_autochr_cs <- Merge_All_Samples %>% 
        select(SNP,(gs+1),(cs+nrow(cts)+1)) %>%
        rename_with(.cols = c(2,3), ~c("annot2","annot1")) %>%
        mutate(annot12 = annot1*annot2)
      
      excess_overlap_cs <- mean(annot_autochr_cs$annot12)/(mean(annot_autochr_cs$annot1)*mean(annot_autochr_cs$annot2))
      excess_overlap <- c(excess_overlap,excess_overlap_cs)
    }
    
    df_excess_overlap <- rbind(df_excess_overlap, excess_overlap)
  }
  df_excess_overlap <- as.data.frame(df_excess_overlap)
  rownames(df_excess_overlap) <- cts$V1
  colnames(df_excess_overlap) <- paste0("Cluster",1:k)
  
  return(df_excess_overlap)
}

# Function to generate shuffled annotations for any given k
generate_shuffled_annotations <- function(res_genes, k) {
  # Create a list to store the shuffled columns
  shuffled_data <- list()
  
  # Add the rsID column first
  shuffled_data$rsID <- res_genes$rsID
  
  # Dynamically create k shuffled W columns
  for (i in 1:k) {
    column_name <- paste0("W", i)  # Generate column name (W1, W2, ..., Wk)
    shuffled_data[[column_name]] <- res_genes[[column_name]][order(rnorm(length(res_genes[[column_name]]), mean=0, sd=1))]
  }
  
  # Combine all columns into a data frame
  shuffled_annotations_bin <- as.data.frame(shuffled_data)
  
  return(shuffled_annotations_bin)
}
#===========================================
set.seed(123)

#num_permutations <- 10000

# Initialize an empty list to store permuted EO values
permuted_EO <- vector("list", length(k))

# Initialize lists to store results
p_values_list <- list()

# Perform permutations
permuted_EO_matrix <- list()
start.time <- Sys.time()
for (perm in ld_index_start:ld_index_stop) {
  if(perm %% 100==0) {
    cat(paste0("permutation: ", perm, "\n"))
  }
  shuffled_annotations_bin <- generate_shuffled_annotations(res_genes, k)  
  shuffled_annotations <- Merge_All_Samples %>%
    left_join(.,shuffled_annotations_bin,by=c("SNP"="rsID")) %>%
    mutate_at(vars(paste0("W", 1:k)), ~replace_na(., 0))
  
  # Recalculate EO based on shuffled labels
  permuted_EO_matrix[[perm]] <- calculate_EO(shuffled_annotations, cell_annotations, annot_name)
}
saveRDS(permuted_EO_matrix,
        paste0("/bNMF/permutation_66loci_k5/",annot_name,"_permuted_EO_matrix_",ld_index_stop/500,".rds"))

end.time <- Sys.time()
time.taken <- end.time - start.time

print("end")
print(time.taken)
