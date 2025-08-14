# ATAC-Seq-analysis-with-DiffBind-DESeq2
Pipeline to analyse chromatin compaction with ATAC-Seq samples in R.

**Note:** The aim of this repository is not to report new findings, it is rather meant to showcase my ability to process data from ATAC-Seq samples using R, bioconductor and several different packages.
## Summary
Assessment of chromatin state changes from ATAC-Seq samples generated from U2OS wild-type (WT), CRAMP1-KO (KO) and CRAMP1-KO reconstituted with a GFP-tagged version of CRAMP1.
**Note:** The pipeline showed in this project starts from .bam generated from sequences processed with the nf-core/atacseq bioinformatics pipeline (v.2.1.2). Sequences were trimmed using Trim Galore! (v. 0.6.7), mapped (GRCh37) using bwa (v.0.7.17 -r1188) and duplicated sequences were marked using Picard MarkDuplicates (v.3.0.0). Reads were filtered to remove those mapping to mitochondrial DNA and blacklisted regions.
## Background
Though CRISPR/Cas9 screening, we identified the previously uncharacterized protein CRAMP1 as a novel factor controlling the sensistivity to Topoisomerase II (TOP2) inhibitors. Further investigation led to the discovery that CRAMP1 acts as a regulator of linker histone H1 expression in human cells. Since it has been reported that H1 downregulation leads to a reduction in chromatin compaction, we set on to analyze if CRAMP1 depletion would have a similar effect.
## Aim of the study
To determine if CRAMP1 depletion, as previously reported for H1 downregulation, promotes general chromatin decompaction through ATAC-Seq analysis. For details on sample preparation, please refer to [this publication](https://www.cell.com/molecular-cell/fulltext/S1097-2765(25)00309-0?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS1097276525003090%3Fshowall%3Dtrue).
## Tools
- **Macs2:** Used for peak calling.
- **Bedtools:** Merging of replicates and identification of consensus peaks.
- **R/Bioconductor:** Handling of data, package managing.
- **DiffBind/DESeq2:** Analysis of peaks.
- **ggplot2:** Visualization of data.
## Workflow
1) For each replicate, peaks were called using **macs2**.
2) Next, **bedtools** was used to get the consensus peaks for all replicates and conditions.
3) A **DiffBind** object was created including only peaks present in at least two replicates and contrast was applied.
4) Data preparation for **DESeq2** analysis.
5) DESeq2 differential analysis.
6) Assessment of replicates with **PCA**.
7) Evaluation of overall chromatin compaction across the different samples.
8) Log2 fold change **(LFC)** calculation and representation of the differences between samples.
## Results
- PCA plots showed a good correlation between replicates, except for the GFP samples, where sample dispersion was higher [Figure 1](*/graphs/CRAMP1_PCA.pdf).
- Total chromatin accesibility was slighlty lower in CRAMP1-KO cells as compared to the other two conditions, as expected [Figure 2](*/graphs/CRAMP1_overall_chromatin_accesibility.pdf).
- When comparing the LFC of the samples individually, WT cells showed an increased opening of 9.1% peaks and a 6.9% closing as compared to KO cells. This difference was much less pronounced when comparing KO and GFP, with 10 and 9,6% percent increased decompaction and compaction, respectively [Figure 3](*/graphs/CRAMP1_LFC.pdf)..
- When comparing the top 100 opening and closing peaks, we could see that they clustered extremely well between WT and KO samples, showing a clear effect caused by CRAMP1 absence. However, this was not the case for GFP, where variation between replicates, probably due to technical difficulties, making it impossible to evaluate [Figure 4](*/graphs/CRAMP1_heatmap.pdf).
