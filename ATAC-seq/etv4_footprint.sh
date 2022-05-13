if false; then
#sambamba sort -m 10GB -n -p -t 10 bam/Chr3162_ETV4WT-1_AT_A12_TGGATCTG_IGO_08155_1_S32_R1_001_val.mm9.sorted.RmDup.bam -o bam/ETV4_WT-1_mm9.name_sorted.bam

#sambamba sort -m 10GB -n -p -t 10 bam/Chr3163_ETV4WT-2_AT_A12_CCGTTTGT_IGO_08155_2_S33_R1_001_val.mm9.sorted.RmDup.bam -o bam/ETV4_WT-2_mm9.name_sorted.bam

#sambamba sort -m 10GB -n -p -t 10 bam/Chr3164_EYFP-1_AT_A12_TGCTGGGT_IGO_08155_3_S34_R1_001_val.mm9.sorted.RmDup.bam -o bam/ETV4_EYFP-1_mm9.name_sorted.bam

#sambamba sort -m 10GB -n -p -t 10 bam/Chr3165_EYFP-2_AT_A12_GAGGGGTT_IGO_08155_4_S35_R1_001_val.mm9.sorted.RmDup.bam -o bam/ETV4_EYFP-2_mm9.name_sorted.bam

#sambamba sort -m 10GB -n -p -t 10 bam/Chr3192_ETV4_AAA-1_AT_A12_GTCGTGAT_IGO_08155_5_S36_R1_001_val.mm9.sorted.RmDup.bam -o bam/ETV4_AAA-1_mm9.name_sorted.bam

#sambamba sort -m 10GB -n -p -t 10 bam/Chr3193_ETV4_AAA-2_AT_A12_ACCACTGT_IGO_08155_6_S37_R1_001_val.mm9.sorted.RmDup.bam -o bam/ETV4_AAA-2_mm9.name_sorted.bam

#genrich -j  -r  -e chrM  -v -t bam/ETV4_EYFP-1_mm9.name_sorted.bam,bam/ETV4_EYFP-2_mm9.name_sorted.bam -o genrich_out/ETV4_EYFP_genrich.narrowPeak 2> genrich_out/ETV4_EYFP_genrich.log &

#genrich -j  -r  -e chrM  -v -t bam/ETV4_WT-1_mm9.name_sorted.bam,bam/ETV4_WT-2_mm9.name_sorted.bam -o genrich_out/ETV4_WT_genrich.narrowPeak 2> genrich_out/ETV4_WT_genrich.log &

#genrich -j  -r  -e chrM  -v -t bam/ETV4_AAA-1_mm9.name_sorted.bam,bam/ETV4_AAA-2_mm9.name_sorted.bam -o genrich_out/ETV4_AAA_genrich.narrowPeak 2> genrich_out/ETV4_AAA_genrich.log

#mergepeaks -d given -code -matrix genrich_out/Merge -venn genrich_out/Venn genrich_out/ETV4_EYFP_genrich.narrowPeak genrich_out/ETV4_WT_genrich.narrowPeak genrich_out/ETV4_AAA_genrich.narrowPeak > genrich_out/Homer_Merged.txt

samtools merge -@ 12 bam/EYFP-1_merged.mm9.sorted.RmDup.bam \
	bam/Chr3164_EYFP-1_AT_A12_TGCTGGGT_IGO_08155_3_S34_R1_001_val.mm9.sorted.RmDup.bam \
	bam/Chr3165_EYFP-2_AT_A12_GAGGGGTT_IGO_08155_4_S35_R1_001_val.mm9.sorted.RmDup.bam

samtools merge -@ 12 bam/ETV4-WT_merged.mm9.sorted.RmDup.bam \
	bam/Chr3162_ETV4WT-1_AT_A12_TGGATCTG_IGO_08155_1_S32_R1_001_val.mm9.sorted.RmDup.bam \
	bam/Chr3163_ETV4WT-2_AT_A12_CCGTTTGT_IGO_08155_2_S33_R1_001_val.mm9.sorted.RmDup.bam

samtools merge -@ 12 bam/ETV4-AAA_merged.mm9.sorted.RmDup.bam \
	bam/Chr3192_ETV4_AAA-1_AT_A12_GTCGTGAT_IGO_08155_5_S36_R1_001_val.mm9.sorted.RmDup.bam \
	bam/Chr3193_ETV4_AAA-2_AT_A12_ACCACTGT_IGO_08155_6_S37_R1_001_val.mm9.sorted.RmDup.bam


tobias ATACorrect --blacklist /Users/Shared/reference/bed/ENCODE_Blacklist/mm9-blacklist.bed \
	-b bam/EYFP-1_merged.mm9.sorted.RmDup.bam -g /Users/Shared/reference/FASTA/mm9/mm9_ncbi.fa \
	-p Genrich_out/Homer_Merged.bed --outdir Tobias_out --cores 12 >Tobias_out/EYFP_ATACorrect.log


tobias ATACorrect --blacklist /Users/Shared/reference/bed/ENCODE_Blacklist/mm9-blacklist.bed \
	-b bam/ETV4-WT_merged.mm9.sorted.RmDup.bam -g /Users/Shared/reference/FASTA/mm9/mm9_ncbi.fa \
	-p Genrich_out/Homer_Merged.bed --outdir Tobias_out --cores 12 >Tobias_out/ETV4-WT_ATACorrect.log

tobias ATACorrect --blacklist /Users/Shared/reference/bed/ENCODE_Blacklist/mm9-blacklist.bed \
	-b bam/ETV4-AAA_merged.mm9.sorted.RmDup.bam -g /Users/Shared/reference/FASTA/mm9/mm9_ncbi.fa \
	-p Genrich_out/Homer_Merged.bed --outdir Tobias_out --cores 12 >Tobias_out/ETV4-AAA_ATACorrect.log


tobias FootprintScores  --signal Tobias_out/EYFP-1_merged.mm9.sorted.RmDup_corrected.bw \
	--regions Genrich_out/Homer_Merged.bed --output Tobias_out/EYFP_merged.mm9.footprints.bw \
	--cores 12 >Tobias_out/EYFP_FootprintScores.log
	
tobias FootprintScores  --signal Tobias_out/ETV4-WT_merged.mm9.sorted.RmDup_corrected.bw \
	--regions Genrich_out/Homer_Merged.bed --output Tobias_out/ETV4-WT_merged.mm9.footprints.bw \
	--cores 12 >Tobias_out/ETV4-WT_FootprintScores.log

tobias FootprintScores  --signal Tobias_out/ETV4-AAA_merged.mm9.sorted.RmDup_corrected.bw \
	--regions Genrich_out/Homer_Merged.bed --output Tobias_out/ETV4-AAA_merged.mm9.footprints.bw \
	--cores 12 >Tobias_out/ETV4-AAA_FootprintScores.log
	

tobias BINDetect --motifs /Users/Shared/reference/motifs/JASPAR2020_CORE_vertebrates_non-redundant_pfms_jaspar.txt \
	--signals Tobias_out/EYFP_merged.mm9.footprints.bw Tobias_out/ETV4-WT_merged.mm9.footprints.bw  Tobias_out/ETV4-AAA_merged.mm9.footprints.bw \
	--genome /Users/Shared/reference/FASTA/mm9/mm9_ncbi.fa \
	--peaks Genrich_out/Homer_Merged.bed \
	--cond_names EYFP ETV4-WT ETV4-AAA
	--outdir BINDetect_output 
	
	# 
	#

TOBIAS BINDetect --motifs /data/chen/dan/motifs/JASPAR2020_CORE_vertebrates_non-redundant_pfms_jaspar.txt \
--signals /data/chen/dan/ETV4-Footprint/Tobias_out/EYFP_merged.mm9.footprints.bw /data/chen/dan/ETV4-Footprint/Tobias_out/ETV4-WT_merged.mm9.footprints.bw  /data/chen/dan/ETV4-Footprint/Tobias_out/ETV4-AAA_merged.mm9.footprints.bw \
--genome /data/chen/dan/mm9/mm9_ncbi.fa \
--peaks /data/chen/dan/ETV4-Footprint/Genrich_out/Homer_Merged.bed \
--cond_names EYFP ETV4-WT ETV4-AAA \
--outdir /data/chen/dan/ETV4-Footprint/BINDetect_output2



tobias PlotAggregate --TFBS BINDetect_output/ETV4_MA0764.2/beds/ETV4_MA0764.2_EYFP_bound.bed \
	BINDetect_output/ETV4_MA0764.2/beds/ETV4_MA0764.2_ETV4AAA_bound.bed \
	--signals Tobias_out/EYFP-1_merged.mm9.sorted.RmDup_corrected.bw \
	Tobias_out/ETV4-WT_merged.mm9.sorted.RmDup_corrected.bw  Tobias_out/ETV4-AAA_merged.mm9.sorted.RmDup_corrected.bw \
	--output ETV4_footprint_comparison_all.pdf --share_y both --plot_boundaries --signal-on-x



tobias PlotAggregate --TFBS BINDetect_output/Ar_MA0007.3/beds/Ar_MA0007.3_EYFP_bound.bed \
	BINDetect_output/Ar_MA0007.3/beds/Ar_MA0007.3_ETV4AAA_bound.bed \
	--signals Tobias_out/EYFP-1_merged.mm9.sorted.RmDup_corrected.bw \
	Tobias_out/ETV4-WT_merged.mm9.sorted.RmDup_corrected.bw  Tobias_out/ETV4-AAA_merged.mm9.sorted.RmDup_corrected.bw \
	--output AR_footprint_comparison_all.pdf --share_y both --plot_boundaries --signal-on-x

tobias PlotHeatmap --TFBS BINDetect_output/Ar_MA0007.3/beds/Ar_MA0007.3_all.bed BINDetect_output/ETV1_MA0761.2/beds/ETV1_MA0761.2_all.bed \
	--signals Tobias_out/EYFP-1_merged.mm9.sorted.RmDup_corrected.bw Tobias_out/ETV4-WT_merged.mm9.sorted.RmDup_corrected.bw  Tobias_out/ETV4-AAA_merged.mm9.sorted.RmDup_corrected.bw \
	--output AR_ETV1_heatmap_all.pdf --share_colorbar

fi

findMotifsGenome.pl Motif_Custom/AR_bound_AAA_only.bed mm9 Motif_Custom/AR_bound_AAA_only -size 100 

findMotifsGenome.pl Motif_Custom/AR_bound_EYFP_only.bed mm9 Motif_Custom/AR_bound_EYFP_only -size 100 &

findMotifsGenome.pl Motif_Custom/AR_bound_both.bed mm9 Motif_Custom/AR_bound_both -size 100 &

findMotifsGenome.pl Motif_Custom/AR_bound_neither.bed mm9 Motif_Custom/AR_bound_neither -size 100