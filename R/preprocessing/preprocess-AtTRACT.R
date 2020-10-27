setwd("~/git/PrInCE-vignettes")
options(stringsAsFactors = FALSE)
library(tidyverse)
library(magrittr)

# read data
dat = read.delim("data/AtTRACT/raw/ATtRACT_db.txt") %>%
  # human RBPs only
  filter(Organism == "Homo_sapiens") %>%
  distinct(Gene_name, .keep_all = T) %>%
  transmute(
    Species = Organism,
    Gene = Gene_name
  )

# save
saveRDS(dat, 'data/AtTRACT/AtTRACT.rds')
