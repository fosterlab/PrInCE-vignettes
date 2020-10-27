setwd("~/git/PrInCE-vignettes")
options(stringsAsFactors = FALSE)
library(tidyverse)
library(magrittr)

# read data
dat = read.csv("data/RBPDB/raw/RBPDB_v1.3.1_proteins_human_2012-11-21.csv") %>%
  dplyr::select(7, 5) %>%
  setNames(c("Species", "Gene")) %>%
  filter(!is.na(Gene), Gene != "")

# save
saveRDS(dat, 'data/RBPDB/RBPDB.rds')
