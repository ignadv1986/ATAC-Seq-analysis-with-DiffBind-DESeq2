# ATAC-Seq-analysis-with-DiffBind-DESeq2
Pipeline to analyse chromatin compaction with ATAC-Seq samples in R.

**Note:** The aim of this repository is not to report new findings, it is rather meant to showcase my ability to process data from ATAC-Seq samples using R, bioconductor, and related tools.
## Summary
This project analyzes chromatin state changes in ATAC-Seq data from U2OS cells under three conditions:
- Wild-type (WT)
- CRAMP1 knockout (CRAMP1-KO)
- CRAMP1-KO reconstituted with GFP-tagged CRAMP1 (GFP)
The workflow begins with .bam files generated using the nf-core/atacseq pipeline (v2.1.2). Raw sequences were trimmed with Trim Galore! (v0.6.7), aligned to GRCh37 using bwa (v0.7.17), and duplicates marked using Picard MarkDuplicates (v3.0.0). Reads mapping to mitochondrial DNA and ENCODE blacklisted regions were removed.
## Background
Though CRISPR/Cas9 screening, we identified the previously uncharacterized protein CRAMP1 as a novel factor controlling the sensistivity to Topoisomerase II (TOP2) inhibitors. Further investigation led to the discovery that CRAMP1 acts as a regulator of linker histone H1 expression in human cells. As previous work has shown that H1 downregulation leads to chromatin decompaction, we aimed to investigate whether CRAMP1 depletion produces a similar chromatin state.
## Aim of the study
To assess whether loss of CRAMP1 leads to genome-wide chromatin decompaction, using ATAC-Seq data analyzed with R and Bioconductor packages. For experimental details and sample preparation, please refer to [this publication](https://www.cell.com/molecular-cell/fulltext/S1097-2765(25)00309-0?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS1097276525003090%3Fshowall%3Dtrue).
## Tools
- **Macs2:** Peak calling.
- **Bedtools:** Consensus peak generation and overlap analysis.
- **R/Bioconductor:** Data handling and statistical analysis
- **DiffBind/DESeq2:** Peak quantification and differential accessibility.
- **ggplot2:** Data visualization.
## Workflow
1) **Peak calling** was performed on each replicate using macs2.
2) **Consensus peaks** were generated using bedtools, keeping only peaks present in at least two replicates.
3) A **DiffBind object** was constructed with contrast definitions for each comparison.
4) **Peak count data** was normalized and modeled using DESeq2.
5) Sample-level quality control was performed via **PCA**.
6) **Chromatin accessibility** was assessed by comparing total peak signal across conditions.
7) Log2 Fold Change **(LFC)** was calculated to evaluate differential accessibility.
8) Heatmaps were generated for the **top 100 opening and closing peaks**.
## Results
🔹 PCA
WT and CRAMP1-KO replicates clustered tightly.
GFP samples showed higher variability, with two replicates clustering separately—suggesting possible technical variability [Figure 1](*/graphs/CRAMP1_PCA.pdf).
🔹 Global Chromatin Accessibility
CRAMP1-KO samples showed slightly reduced global accessibility compared to WT and GFP [Figure 2](*/graphs/CRAMP1_overall_chromatin_accesibility.pdf).
🔹 Differential Peak Analysis
WT vs KO:
9.1% of peaks were significantly more accessible (opening)
6.9% showed reduced accessibility (closing)
KO vs GFP:
~10% opening and ~9.6% closing
These smaller differences suggest a partial rescue in GFP [Figure 3](*/graphs/CRAMP1_LFC.pdf).
🔹 Top Differential Peaks
The top 100 opening and closing peaks clearly distinguished WT from KO samples.
GFP samples, however, showed inconsistent clustering, making it difficult to assess rescue due to technical variability [Figure 4](*/graphs/CRAMP1_heatmap.pdf).
## Scripts
All analysis scripts are included in the `scripts/` folder and are organized in the order of execution:
1. **01_peak_calling.R** – MACS2 peak calling per replicate  
2. **02_merge_peaks_bedtools.R** – Consensus peak generation  
3. **03_diffbind_setup.R** – Create DiffBind object and apply contrasts  
4. **04_deseq2_analysis.R** – Run differential accessibility analysis  
5. **05_visualization.R** – Generate PCA, LFC plots, and heatmaps
