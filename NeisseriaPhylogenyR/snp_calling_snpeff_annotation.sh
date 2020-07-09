#!/usr/bin/env bash

## input
genome="/media/daria_der/linuxdata1/all_assemblies_NIIDI/contig_correction/219_S1_FG.fasta"
reads_f="/media/daria_der/Seagate_daria_der1/1_Project/Neisseria/trimmed_reads/reads/212_S14_1.fq.gz"
reads_r="/media/daria_der/Seagate_daria_der1/1_Project/Neisseria/trimmed_reads/reads/212_S14_2.fq.gz"
prefix="219g212r"
out_path="/media/daria_der/linuxdata1/neisseria_antibiotic_resistance/within_NII_comparison/219g212r"
gff_path="/media/daria_der/linuxdata1/all_assemblies_NIIDI/annotation_219_S1_FG.fasta/PROKKA_02082020.gff"
tsv_path="/media/daria_der/linuxdata1/all_assemblies_NIIDI/annotation_219_S1_FG.fasta/PROKKA_02082020.tsv"


## alignment

bwa index $genome
bwa mem -t 8 $genome $reads_f $reads_r > "$out_path"/"$prefix".sam

## variant-calling

for i in "$out_path"/"$prefix".sam; do echo $i; samtools view -bS $i -o "$i".bam -@ 7; done
for i in "$out_path"/"$prefix".sam.bam; do echo $i; samtools sort $i  -o "$i".sorted.bam -@ 7; done
for i in "$out_path"/"$prefix".sam.bam.sorted.bam; do echo $i; samtools index "$i"; done

## duplicate marking

java -Xmx8g -jar /home/daria_der/Downloads/Soft/picard-tools-1.119/picard-1.119.jar MarkDuplicates MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 REMOVE_DUPLICATES=true INPUT="$prefix".sam.bam.sorted.bam OUTPUT="$prefix".dedup.bam METRICS_FILE="$prefix".dedup_metrics ASSUME_SORTED=true

samtools index "$prefix".dedup.bam
#Index our de-duplicated bam files

samtools index "$prefix".dedup.bam

#Find intervals to analyze
java -Xmx8g -jar ~/bin/GenomeAnalysisTK.jar -T RealignerTargetCreator -R "$genome" -I "$prefix".dedup.bam -o "$prefix".realignment.intervals

#Realign in these loci
java -Xmx8g -jar ~/bin/GenomeAnalysisTK.jar -T IndelRealigner -R ~/WORKSHOP_RESOURCES/Section_3/reference/reference.fasta -I "$i".dedup.bam  -targetIntervals "$i".realignment.intervals -o "$i".dedup.realigned.bam



samtools mpileup -d 250 -m 1 -E --BCF --output-tags DP,AD,ADF,ADR,SP -f $genome -o "$out_path"/"$prefix".bcf "$out_path"/"$prefix".sam.bam.sorted.bam
bcftools index "$out_path"/"$prefix".bcf
bcftools call --multiallelic-caller --variants-only --ploidy 1 -O v "$out_path"/"$prefix".bcf -o ""$out_path"/"$prefix".vcf"

## gff to gtf

#grep -v "#" $gff_path | grep "ID=" | cut -f1 -d ';' | sed 's/ID=//g' | cut -f1,4,5,7,9 |  awk -v OFS='\t' '{print $1,"PROKKA","CDS",$2,$3,".",$4,".","gene_id " $5}' > $prefix.gtf
## config creation and snpeff db build
echo ""$prefix".genome :    n.meningitis" >> /home/daria_der/Downloads/Soft/snpEff_latest_core/snpEff/test.config
curdir=$(pwd)
cd /home/daria_der/Downloads/Soft/snpEff_latest_core/snpEff/
mkdir ./data/"$prefix"/
cp $gff_path ./data/"$prefix"/genes.gff
java -jar snpEff.jar build -gff3 -v $prefix -c test.config
java -Xmx8g -jar snpEff.jar -v "$prefix" ""$out_path"/"$prefix".vcf" -c test.config -stats "$out_path"/"$prefix"_summary.html
head -1
join -j 1 <(sort -k1 "$out_path"/"$prefix"_summary.genes.txt) <(sort -k1 "$tsv_path")> "$out_path"/"$prefix"_snp_annotation.tsv
cd $curdir




