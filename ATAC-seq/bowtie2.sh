printf "\n\n\n$1 $2 $3 \n\n\n"


if [ "$#" -ne 3 ]; then
	echo "needs 3 arguments of 1. directory of FASTQ, 2. fastq 3. sample name"
	exit 1
fi

if ! [ -d "trim_galore" ];then
	mkdir trim_galore
fi

if ! [ -d "qualimap" ];then
	mkdir qualimap
fi

if ! [ -d "bam" ];then
	mkdir bam
fi

if ! [ -d "bigwig" ];then
	mkdir bigwig
fi


R1_FILE="${2%%.*}"
ECHO $R1_FILE

printf "trim_galore  --cores 4 --illumina --fastqc -o trim_galore $1/$2  \n \n"
#trim_galore --cores 4 --illumina  --fastqc -o trim_galore $1/$2

printf "bowtie2 -p 5 --local --very-sensitive-local -p 10 --no-mixed --no-discordant \
	-x /Users/Shared/reference/Bowtie2_index/mm9 \
	-U trim_galore/$R1_FILE"_trimmed.fq.gz" \
	| samtools sort -m 5G -@ 4 -o bam/$3"_mm9.bam" - \n\n"

#bowtie2 -p 5 --local --very-sensitive-local --no-mixed --no-discordant \
#	-x /Users/Shared/reference/Bowtie2_index/mm9 \
#	-U trim_galore/$R1_FILE"_trimmed.fq.gz" \
#	| samtools sort -m 5G -@ 4 -o bam/$3"_mm9.bam" -
	

printf "sambamba index -p -t 6 bam/$3"_mm9.bam" \n \n"
sambamba index -p -t 6 bam/$3"_mm9.bam"

printf "bamCoverage -p 5 --normalizeUsing RPGC --effectiveGenomeSize 2451960000 -bs=10 -e -b bam/$3"_mm9.bam" -o bigwig/$3"_mm9.bw" \n\n"
	
bamCoverage -p 5 --normalizeUsing RPGC --effectiveGenomeSize 2451960000 -bs=10 -e 200 -b bam/$3"_mm9.bam" -o bigwig/$3"_mm9.bw"

printf "qualimap bamqc --java-mem-size=4G -outdir qualimap/$3/ -bam bam/$3"_mm9.bam" \n \n"

qualimap bamqc --java-mem-size=4G -outdir qualimap/$3/ -bam bam/$3"_mm9.bam"

