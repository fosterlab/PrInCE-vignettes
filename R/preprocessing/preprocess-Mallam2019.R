setwd("~/git/PrInCE-vignettes")
options(stringsAsFactors = FALSE)
library(tidyverse)
library(magrittr)

# list proteinGroups files
files = list.files("data/Mallam2019/raw", full.names = TRUE, recursive = TRUE,
                   pattern = 'proteinGroups')

# read them
pgs = map(files, ~ read.delim(.) %>%
            filter(Potential.contaminant != '+',
                   Reverse != '+',
                   Only.identified.by.site != '+'))

# extract LFQ matrices, mapped to genes for RBP enrichment analysis
mats = map(pgs, ~ {
  # extract LFQ matrix
  mat = .x %>%
    dplyr::select(Majority.protein.IDs, starts_with('LFQ.')) %>%
    column_to_rownames('Majority.protein.IDs') %>%
    as.matrix()
  # extract gene map
  gene_map = .x %>%
    dplyr::select(Majority.protein.IDs, Gene.names) %>%
    set_colnames(c("protein_group", "gene")) %>%
    mutate(gene = strsplit(gene, ';')) %>%
    unnest(gene) %>%
    drop_na()
  # pick the best chromatogram per gene name
  genes = unique(gene_map$gene)
  gene_mat = matrix(NA, nrow = length(genes), ncol = ncol(mat),
                    dimnames = list(genes, colnames(mat)))
  n_fractions = rowSums(!is.na(mat) & is.finite(mat) & mat != 0)
  for (gene in genes) {
    protein_groups = gene_map$protein_group[gene_map$gene == gene]
    # pick the best protein for this replicate
    n_fractions0 = n_fractions[protein_groups]
    best = names(which(n_fractions0 == max(n_fractions0))) %>%
      dplyr::first()
    gene_mat[gene, ] = mat[best, ]
  }
  return(gene_mat)
})
accessions = basename(dirname(dirname(files)))
conditions = basename(dirname(files))
names(mats) = paste0(accessions, '|', conditions)

# save
saveRDS(mats, "data/Mallam2019/chromatograms.rds")
