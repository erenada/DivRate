# scoring the annotations

annot_table_pre <- read.csv("./annotations.csv", header = T, stringsAsFactors = F)

annot_table_pre[1:10,]

#get most frequent from the left

annot_table <- data.frame(Alignment_name=annot_table_pre[,1], Locus_type=apply(annot_table_pre[,2:8],1, function (x) colnames(annot_table_pre)[2:8][which.max(x)]))

annot_table$Alignment_name <- paste0(annot_table$Alignment_name, ".fasta")

annot_table[1:10,]

write.table(annot_table, file = "annot_table_all.csv", sep = "\t", quote = FALSE, row.names = F)

CDS_table <- subset(annot_table, Locus_type == "CDS")
lnc_RNA_table <- subset(annot_table, Locus_type == "lnc_RNA")
other_table <- subset(annot_table, Locus_type == "other")
pseudogene_table <- subset(annot_table, Locus_type == "pseudogene")
unannotated_table <- subset(annot_table, Locus_type == "unannotated")
UTR_table <- subset(annot_table, Locus_type == "UTR")
intron_table <- subset(annot_table, Locus_type == "intron")

write.table(CDS_table, file = "CDS_table.csv", sep = "\t", quote = FALSE, row.names = F)

write.table(lnc_RNA_table, file = "lnc_RNA_table.csv", sep = "\t", quote = FALSE, row.names = F)

write.table(other_table, file = "other_table.csv", sep = "\t", quote = FALSE, row.names = F)

write.table(pseudogene_table, file = "pseudogene_table.csv", sep = "\t", quote = FALSE, row.names = F)

write.table(unannotated_table, file = "unannotated_table.csv", sep = "\t", quote = FALSE, row.names = F)

write.table(UTR_table, file = "UTR_table.csv", sep = "\t", quote = FALSE, row.names = F)

write.table(intron_table, file = "intron_table.csv", sep = "\t", quote = FALSE, row.names = F)
