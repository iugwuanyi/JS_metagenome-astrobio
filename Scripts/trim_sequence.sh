#Metagenome sequences were trimmed using Trimmomatics
#!/bin/bash
for i in {1..14};
do
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 ${i}_S${i}_R1_001.fastq.gz ${i}_S${i}_R2_001.fastq.gz \
${i}_forward_paired.fastq.gz ${i}_forward_unpaired.fastq.gz ${i}_reverse_paired.fastq.gz ${i}_reverse_unpaired.fastq.gz \
ILLUMINACLIP:Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done