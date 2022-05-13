#STAR  --genomeDir /Users/Shared/reference/STAR_mm9_Custom  --quantMode GeneCounts --readFilesCommand gunzip -c --readFilesIn Sample_TMPRSS2-EYFP292_IGO_05957_C_1/TMPRSS2-EYFP292_IGO_05957_C_1_S5_L001_R1_001.fastq.gz --outFileNamePrefix C1_mm9_Ai3map_ --runThreadN 14 --outBAMsortingThreadN 4 --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonicalUnannotated --outSAMattributes All --outSAMtype BAM SortedByCoordinate 
#samtools index C1_mm9_Ai3map_Aligned.sortedByCoord.out.bam 

STAR   --runMode genomeGenerate   --runThreadN 16   --genomeDir ./ \
--genomeFastaFiles \
/home/lid/Custom/Fas/EYFP_normalized.fasta /home/lid/Custom/Fas/ETV4_EGFP3UTR_normalized.fasta \
/home/lid/Custom/Fas/EGFP_normalized.fasta /home/lid/Custom/Fas/T2nlsEGFP_normalized.fasta \
/home/lid/Custom/Fas/hETV4-AAA_normalized.fasta \
/home/lid/Custom/Fas/CreERT2_normalized.fasta /home/lid/Custom/Fas/FlpE_normalized.fasta \
/home/lid/Custom/Fas/Neo_normalized.fasta /home/lid/Custom/Mus_musculus.NCBIM37.66.dna.toplevel.fa \
--sjdbGTFfile /home/lid/Custom/mm9_Custom_Combined.gtf --sjdbOverhang 99

java -jar /home/lid/software/picard/build/libs/picard.jar NormalizeFasta I=/home/lid/Custom/Fas/ETV4_EGFP3UTR.fasta O=/home/lid/Custom/Fas/ETV4_EGFP3UTR_normalized.fasta LINE_LENGTH=60
java -jar /home/lid/software/picard/build/libs/picard.jar NormalizeFasta I=/home/lid/Custom/Fas/EGFP.fasta O=/home/lid/Custom/Fas/EGFP_normalized.fasta LINE_LENGTH=60
java -jar /home/lid/software/picard/build/libs/picard.jar NormalizeFasta I=/home/lid/Custom/Fas/T2nlsEGFP.fasta O=/home/lid/Custom/Fas/T2nlsEGFP_normalized.fasta LINE_LENGTH=60

cat /home/lid/Custom/Fas/EYFP_normalized.fasta /home/lid/Custom/Fas/ETV4_EGFP3UTR_normalized.fasta /home/lid/Custom/Fas/EGFP_normalized.fasta /home/lid/Custom/Fas/T2nlsEGFP_normalized.fasta /home/lid/Custom/Fas/hETV4-AAA_normalized.fasta /home/lid/Custom/Fas/CreERT2_normalized.fasta /home/lid/Custom/Fas/FlpE_normalized.fasta /home/lid/Custom/Fas/Neo_normalized.fasta >> custom.fasta


parallel -j 1 echo {1}{2} ::: TA TAC TEA TEAC TY TYC TYA TYAC ::: 1 2 3 > ids

IDX=/home/lid/Custom/Mus_musculus.NCBIM37.66.dna.toplevel.fa
cat ids | parallel "hisat2 -x $IDX -1 ETV4/{}_R1_001.fastq.gz -2 ETV4/{}_R2_001.fastq.gz | samtools sort > bam/{}.bam"
cat ids | parallel  "samtools index BAM/{}.bam"

bedtools genomecov -ibam  BAM/TA1Aligned.sortedByCoord.out.bam -split -bg  > BAM/TA1.bg
bedGraphToBigWig BAM/TA1.bg  /home/lid/Custom/Mus_musculus.NCBIM37.66.dna.toplevel_custom.fa BAM/TA1.bw
bedtools genomecov -ibam  BAM/TY1Aligned.sortedByCoord.out.bam -split -bg  > BAM/TY1.bg

# Turn each BAM file into bedGraph coverage. The files will have the .bg extension.
cat ids | parallel "bedtools genomecov -ibam  BAM/{}Aligned.sortedByCoord.out.bam -split -bg  > BAM/{}.bg"
# Convert each bedGraph coverage into bigWig coverage. The files will have the .bw extension.
cat ids | parallel "bedGraphToBigWig BAM/{}.bg  /home/lid/Custom/Mus_musculus.NCBIM37.66.dna.toplevel.fa.fai BAM/{}.bw"
featureCounts -p -a /home/lid/Custom/mm9_Custom_Combined.gtf -o counts/TA1counts.txt BAM/TA1Aligned.sortedByCoord.out.bam





# build index file
kallisto index -i mm9.idx Mus_musculus.NCBIM37.66.dna.toplevel.fa
# Make a directory for the results
mkdir -p output
# The name of the index.
IDX=refs/transcript.idx
# Run Kallisto to classify the reads.
cat ids | parallel kallisto quant -i $IDX -o output/{} reads/{}_R1.fq reads/{}_R2.fq


ls ./BAM/*ReadsPerGene.out.tab
ls ./BAM/*ReadsPerGene.out.tab > tabs
tail -n +5 ./BAM/TA1ReadsPerGene.out.tab | cut -f1,2 > ./BAM/TA1ReadsPerGene.out.tab.count
cat tabs | parallel "tail -n +5 {} | cut -f1,2 > {}.count"
ls ./BAM/*count

#ETV4298_G


#STAR  --genomeDir /Users/Shared/reference/STAR_mm9_Custom  --quantMode GeneCounts --readFilesCommand gunzip -c \
	--readFilesIn \
Sample_TMPRSS2-ETV4298_IGO_05957_G_4/TMPRSS2-ETV4298_IGO_05957_G_4_S13_L001_R1_001.fastq.gz,Sample_TMPRSS2-ETV4298_IGO_05957_G_4/TMPRSS2-ETV4298_IGO_05957_G_4_S13_L002_R1_001.fastq.gz \
Sample_TMPRSS2-ETV4298_IGO_05957_G_4/TMPRSS2-ETV4298_IGO_05957_G_4_S13_L001_R2_001.fastq.gz,Sample_TMPRSS2-ETV4298_IGO_05957_G_4/TMPRSS2-ETV4298_IGO_05957_G_4_S13_L002_R2_001.fastq.gz \
	--outFileNamePrefix BAM/AAA4298_v2_mm9_ --runThreadN 14 --outBAMsortingThreadN 4 --outSAMstrandField intronMotif \
	--outFilterIntronMotifs RemoveNoncanonicalUnannotated --outSAMattributes All --outSAMtype BAM SortedByCoordinate 
samtools index BAM/AAA4298_v2_mm9_Aligned.sortedByCoord.out.bam &

#ETV4299_G

#STAR  --genomeDir /Users/Shared/reference/STAR_mm9_Custom  --quantMode GeneCounts --readFilesCommand gunzip -c \
	--readFilesIn \
Sample_TMPRSS2-ETV4299_IGO_05957_G_5/TMPRSS2-ETV4299_IGO_05957_G_5_S14_L001_R1_001.fastq.gz,Sample_TMPRSS2-ETV4299_IGO_05957_G_5/TMPRSS2-ETV4299_IGO_05957_G_5_S14_L002_R1_001.fastq.gz \
Sample_TMPRSS2-ETV4299_IGO_05957_G_5/TMPRSS2-ETV4299_IGO_05957_G_5_S14_L001_R2_001.fastq.gz,Sample_TMPRSS2-ETV4299_IGO_05957_G_5/TMPRSS2-ETV4299_IGO_05957_G_5_S14_L002_R2_001.fastq.gz \
	--outFileNamePrefix BAM/AAA4299_v2_mm9_ --runThreadN 14 --outBAMsortingThreadN 4 --outSAMstrandField intronMotif \
	--outFilterIntronMotifs RemoveNoncanonicalUnannotated --outSAMattributes All --outSAMtype BAM SortedByCoordinate 
samtools index BAM/AAA4299_v2_mm9_Aligned.sortedByCoord.out.bam &

#EYFP292G

#STAR  --genomeDir /Users/Shared/reference/STAR_mm9_Custom  --quantMode GeneCounts --readFilesCommand gunzip -c \
	--readFilesIn \
Sample_TMPRSS2-EYFP292_IGO_05957_G_1/TMPRSS2-EYFP292_IGO_05957_G_1_S10_L001_R1_001.fastq.gz,Sample_TMPRSS2-EYFP292_IGO_05957_G_1/TMPRSS2-EYFP292_IGO_05957_G_1_S10_L002_R1_001.fastq.gz \
Sample_TMPRSS2-EYFP292_IGO_05957_G_1/TMPRSS2-EYFP292_IGO_05957_G_1_S10_L001_R2_001.fastq.gz,Sample_TMPRSS2-EYFP292_IGO_05957_G_1/TMPRSS2-EYFP292_IGO_05957_G_1_S10_L002_R2_001.fastq.gz \
	--outFileNamePrefix BAM/EYFP292_v2_mm9_ --runThreadN 14 --outBAMsortingThreadN 4 --outSAMstrandField intronMotif \
	--outFilterIntronMotifs RemoveNoncanonicalUnannotated --outSAMattributes All --outSAMtype BAM SortedByCoordinate 
samtools index BAM/EYFP292_v2_mm9_Aligned.sortedByCoord.out.bam &

#EYFP293G

#STAR  --genomeDir /Users/Shared/reference/STAR_mm9_Custom  --quantMode GeneCounts --readFilesCommand gunzip -c \
	--readFilesIn \
Sample_TMPRSS2-EYFP293_IGO_05957_G_2/TMPRSS2-EYFP293_IGO_05957_G_2_S11_L001_R1_001.fastq.gz,Sample_TMPRSS2-EYFP293_IGO_05957_G_2/TMPRSS2-EYFP293_IGO_05957_G_2_S11_L002_R1_001.fastq.gz \
Sample_TMPRSS2-EYFP293_IGO_05957_G_2/TMPRSS2-EYFP293_IGO_05957_G_2_S11_L001_R2_001.fastq.gz,Sample_TMPRSS2-EYFP293_IGO_05957_G_2/TMPRSS2-EYFP293_IGO_05957_G_2_S11_L002_R2_001.fastq.gz \
	--outFileNamePrefix BAM/EYFP293_v2_mm9_ --runThreadN 14 --outBAMsortingThreadN 4 --outSAMstrandField intronMotif \
	--outFilterIntronMotifs RemoveNoncanonicalUnannotated --outSAMattributes All --outSAMtype BAM SortedByCoordinate 
samtools index BAM/EYFP293_v2_mm9_Aligned.sortedByCoord.out.bam &


#EYFP294G

#STAR  --genomeDir /Users/Shared/reference/STAR_mm9_Custom  --quantMode GeneCounts --readFilesCommand gunzip -c \
	--readFilesIn \
Sample_TMPRSS2-EYFP294_IGO_05957_G_3/TMPRSS2-EYFP294_IGO_05957_G_3_S12_L001_R1_001.fastq.gz,Sample_TMPRSS2-EYFP294_IGO_05957_G_3/TMPRSS2-EYFP294_IGO_05957_G_3_S12_L002_R1_001.fastq.gz \
Sample_TMPRSS2-EYFP294_IGO_05957_G_3/TMPRSS2-EYFP294_IGO_05957_G_3_S12_L001_R2_001.fastq.gz,Sample_TMPRSS2-EYFP294_IGO_05957_G_3/TMPRSS2-EYFP294_IGO_05957_G_3_S12_L002_R2_001.fastq.gz \
	--outFileNamePrefix BAM/EYFP294_v2_mm9_ --runThreadN 14 --outBAMsortingThreadN 4 --outSAMstrandField intronMotif \
	--outFilterIntronMotifs RemoveNoncanonicalUnannotated --outSAMattributes All --outSAMtype BAM SortedByCoordinate 
samtools index BAM/EYFP294_v2_mm9_Aligned.sortedByCoord.out.bam