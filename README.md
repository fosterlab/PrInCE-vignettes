## PrInCE vignettes

This repository contains additional vignettes demonstrating secondary features of the PrInCE R package. Because the Bioconductor project requires that all executable code finish running within a strict limit of 5 minutes, these are provided separately from the main package, in order to provide full worked examples and enable interested users to reproduce the results found in our manuscript, "PrInCE: an R/Bioconductor package for 
protein-protein interaction network inference from co-fractionation mass spectrometry data."

The vignettes included in this repository are as follows:

- `vignettes/detect_complexes.html`: demonstrates the use of the PrInCE function `detect_complexes` to identify significantly co-eluting complexes in mitochondrial and cytosolic CF-MS data [1]
- `vignettes/calculate_autocorrelation.html`: demonstrates the use of the PrInCE function `calculate_autocorrelation` to identify proteins with 'rewired' protein-protein interactions after RNAse treatment [2]

#### References

[1] Scott, N.E. _et al._ _Mol. Syst. Biol._ **13**, 906 (2017). 
[2] Mallam, A. _et al._ _Cell Rep._ **29**, 1351-1368 (2019).
