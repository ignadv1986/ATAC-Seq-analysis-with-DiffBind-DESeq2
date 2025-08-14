# Create DESeq2 dataset
dds <- DESeqDataSetFromMatrix(
  countData = countMatrix,
  colData = colData,
  design = ~ condition
)
# Run the differential analysis
dds <- DESeq(dds)
res <- results(dds)
