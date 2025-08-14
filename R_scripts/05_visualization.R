#Plot PCA
vsd <- vst(dds, blind=FALSE) 
plotPCA(vsd, intgroup="condition")
# Sum counts across all peaks for each sample
total_accessibility <- colSums(countMatrix) 
# Create a simple data frame with sample and condition info
summary_df <- data.frame(
  sample = colnames(countMatrix),
  condition = colData$condition,
  total_accessibility = total_accessibility
) 
# Plot overall chromatin accesibility
library(ggplot2)
ggplot(summary_df, aes(x = condition, y = total_accessibility)) +
  geom_boxplot() +
  geom_jitter(width = 0.1) +
  labs(title = "Overall Chromatin Accessibility by Condition",
       y = "Total Read Counts (Accessibility)")
# Filter significant peaks and arrange by log2FoldChange
sig_WT_KO <- res_WT_KO %>% 
  as.data.frame() %>% 
  filter(padj < 0.05 & !is.na(padj))

top_opening <- sig_WT_KO %>% filter(log2FoldChange > 0) %>% 
  arrange(desc(log2FoldChange)) %>% 
  slice_head(n = 100)

top_closing <- sig_WT_KO %>% filter(log2FoldChange < 0) %>% 
  arrange(log2FoldChange) %>%   # ascending because negatives
  slice_head(n = 100)

# Combine
top_peaks <- rbind(top_opening, top_closing)
# Use variance stabilized or rlog transformed counts for heatmap
vsd <- vst(dds, blind = FALSE)  # variance stabilizing transform

norm_counts <- assay(vsd)[rownames(vsd) %in% rownames(top_peaks), ]
library(pheatmap)

# Scale rows (peaks) for better visualization
scaled_counts <- t(scale(t(norm_counts)))

# Annotation for samples based on condition
annotation_col <- data.frame(
  condition = colData(dds)$condition
)
rownames(annotation_col) <- colnames(norm_counts)

pheatmap(
  scaled_counts,
  annotation_col = annotation_col,
  show_rownames = FALSE,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  main = "Top 100 Opening and Closing Peaks (WT vs KO)"
)
# View differences between samples
# Obtain LFC summary
res_WT_KO <- results(dds, contrast = c("condition", "KO", "WT"))
summary(res_WT_KO)
# Number of peaks changed between conditions
sig_WT_KO <- res_WT_KO[which(res_WT_KO$padj < 0.05), ]
open_WT_KO <- sig_WT_KO[sig_WT_KO$log2FoldChange > 0, ]
closed_WT_KO <- sig_WT_KO[sig_WT_KO$log2FoldChange < 0, ]
cat("WT vs KO:\n")
# LFC
df1 <- as.data.frame(res_WT_KO)
df1$comparison <- "WT_vs_KO"
df2 <- as.data.frame(res_KO_GFP)
df2$comparison <- "KO_vs_GFP"
combined <- rbind(df1, df2)

ggplot(combined, aes(x = log2FoldChange, fill = comparison)) +
  geom_histogram(position = "identity", alpha = 0.5, bins = 50) +
  facet_wrap(~comparison, ncol = 1) +
  labs(title = "Fold Change Distributions per Contrast",
       x = "log2 Fold Change",
       y = "Number of Peaks") +
  theme_minimal()
