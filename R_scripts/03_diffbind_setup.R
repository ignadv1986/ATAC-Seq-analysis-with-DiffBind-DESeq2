#Read .csv containing DiffBind-ready data
samples <- read.csv("samplesheet.csv")
#Create DiffBind object
dbObj <- dba(sampleSheet = samples)
#Keep only peaks present in at least 2 replicates
dbObj <- dba.count(dbObj, peaks = "consensus_peaks.bed", minOverlap = 2)
#Contrast setup
dbObj <- dba.contrast(dbObj, categories=DBA_CONDITION)
#Data preparation for DESeq2
counts <- dba.peakset(dbObj, bRetrieve=TRUE, DataType=DBA_DATA_FRAME)
counts <- as.matrix(round(counts))
#Prepare colData that matches the samples columns and prepare the dataset for DESeq2
conditions <- dbObj$samples$Condition
colData <- data.frame(condition = conditions)
rownames(colData) <- colnames(countMatrix)
