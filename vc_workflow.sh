HOME=/home/jiajia

rawDIR=$HOME/variant-calling/raw-fastq
genomeDIR=$HOME/variant-calling/ref-genome
trimmedDIR=$HOME/variant-calling/trimmed-fastq
resultsDIR=$HOME/variant-calling/results

mkdir -p $rawDIR $genomeDIR $trimmedDIR $resultsDIR

curl -o $rawDIR/SRR2589044_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_1.fastq.gz
curl -o $rawDIR/SRR2589044_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_2.fastq.gz
curl -o $rawDIR/SRR2584863_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/003/SRR2584863/SRR2584863_1.fastq.gz
curl -o $rawDIR/SRR2584863_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/003/SRR2584863/SRR2584863_2.fastq.gz
curl -o $rawDIR/SRR2584866_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2584866/SRR2584866_1.fastq.gz
curl -o $rawDIR/SRR2584866_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2584866/SRR2584866_2.fastq.gz

curl -o $HOME/variant-calling/NexteraPE-PE.fa https://raw.githubusercontent.com/timflutre/trimmomatic/refs/heads/master/adapters/NexteraPE-PE.fa 
curl -o $genomeDIR/ecoli_ref.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz 

gunzip $genomeDIR/ecoli_ref.fna.gz
mv $genomeDIR/ecoli_ref.fna $genomeDIR/ecoli_ref.fa
bwa index $genomeDIR/ecoli_ref.fa 

for i in $rawDIR/*_1.fastq.gz
do
base=$(basename $i _1.fastq.gz)

fastq1=$rawDIR/${base}_1.fastq.gz
fastq2=$rawDIR/${base}_2.fastq.gz 
trim1=$trimmedDIR/${base}_1.trim.fastq.gz
trim2=$trimmedDIR/${base}_2.trim.fastq.gz
untrim1=$trimmedDIR/${base}_1un.trim.fastq.gz
untrim2=$trimmedDIR/${base}_2un.trim.fastq.gz
adapter=$HOME/variant-calling/NexteraPE-PE.fa 

trimmomatic PE $fastq1 $fastq2 \
               $trim1 $untrim1 \
               $trim2 $untrim2 \
               SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:$adapter:2:40:15


genome=$genomeDIR/ecoli_ref.fa
aligned_bam=$resultsDIR/${base}.aligned.bam
sorted_bam=$resultsDIR/${base}.aligned.sorted.bam
raw_variants=$resultsDIR/${base}_raw.vcf
variants=$resultsDIR/${base}_variants.vcf
final_variants=$resultsDIR/${base}_final_variants.vcf

bwa mem $genome $trim1 $trim2 | samtools view -b > ${aligned_bam} 
samtools sort -o ${sorted_bam} ${aligned_bam}
bcftools mpileup -O v -o ${raw_variants} -f $genome ${sorted_bam}
bcftools call --ploidy 1 -m -v -o $variants ${raw_variants}
vcfutils.pl varFilter $variants > ${final_variants}

done 
