# Preprocess SEC and BN-PAGE PCP-SILAC chromatograms from cytosolic and membrane
# networks before and after Fas-mediate dapoptosis (Scott et al., MSB 2017).
setwd("~/git/PrInCE-vignettes")
options(stringsAsFactors = F)
library(tidyverse)
library(magrittr)
library(openxlsx)

# read profiles
sec = read.xlsx("data/Scott2017/raw/Table EV11.xlsx", sheet = 1, startRow = 2)
bn = read.xlsx("data/Scott2017/raw/Table EV11.xlsx", sheet = 2, startRow = 2)

# make container
chroms = list()

# split the SEC dataset up by replicates
for (replicate in unique(sec$`PCP-SILAC.Replicate`)) {
  ## process SEC
  repl = sec %>%
    filter(`PCP-SILAC.Replicate` == replicate) 
  groups = repl$Majority.protein.IDs %>% gsub(";.*$", "", .)
  heavy = repl %>%
    dplyr::select(starts_with("Ratio.H/L")) %>%
    mutate_all(as.numeric) %>%
    as.matrix() %>%
    set_rownames(groups) %>%
    set_colnames(paste0("SEC_", seq_len(ncol(.))))
  medium = repl %>%
    dplyr::select(starts_with("Ratio.M/L")) %>%
    mutate_all(as.numeric) %>%
    as.matrix() %>%
    set_rownames(groups) %>%
    set_colnames(paste0("SEC_", seq_len(ncol(.))))
  # save
  chroms[[paste('SEC unstimulated', replicate)]] = medium
  chroms[[paste('SEC stimulated', replicate)]] = heavy

  ## process BN-PAGE
  repl = bn %>%
    filter(Replicate == replicate) 
  groups = repl$Majority.protein.IDs %>% gsub(";.*$", "", .) 
  heavy = repl %>%
    dplyr::select(starts_with("Ratio.H/L")) %>%
    mutate_all(as.numeric) %>%
    as.matrix() %>%
    set_rownames(groups) %>%
    set_colnames(paste0("BN_", seq_len(ncol(.))))
  medium = repl %>%
    dplyr::select(starts_with("Ratio.M/L")) %>%
    mutate_all(as.numeric) %>%
    as.matrix() %>%
    set_rownames(groups) %>%
    set_colnames(paste0("BN_", seq_len(ncol(.))))
  # save
  chroms[[paste('BN-PAGE unstimulated', replicate)]] = medium
  chroms[[paste('BN-PAGE stimulated', replicate)]] = heavy
}

# save
saveRDS(chroms, "data/Scott2017/chromatograms.rds")
