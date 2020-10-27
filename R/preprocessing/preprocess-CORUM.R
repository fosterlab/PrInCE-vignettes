# Preprocess protein complexes from the CORUM database.
setwd("~/git/PrInCE-vignettes")
options(stringsAsFactors = FALSE)
library(tidyverse)
library(magrittr)
library(flavin)

# read the complexes
corum = read.delim("data/CORUM/raw/coreComplexes.txt")

# convert to a list
complexes = corum %>%
  dplyr::select(ComplexName, subunits.UniProt.IDs.) %>%
  mutate(complex_idx = row_number()) %>%
  unite(complex, complex_idx, ComplexName) %>%
  set_colnames(c("complex", "proteins")) %>%
  mutate(protein = strsplit(proteins, ';'), .keep = 'unused') %>%
  unnest(protein) %>%
  as_annotation_list('protein', 'complex') %>%
  setNames(gsub("^.*_", "", names(.)))

# don't do any filtering now: do that in the datasets

# write
saveRDS(complexes, "data/CORUM/complexes.rds")
