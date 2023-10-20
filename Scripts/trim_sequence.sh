##Paired-end metagenome sequences were trimmed using Trimmomatic v0.39. The parameters used were SLIDINGWINDOW:4:15, LEADING:3, TRAILING:3,  and MINLEN:36. 
##Instructions on how to install and run Trimmomatic can be found here https://github.com/usadellab/Trimmomatic
#!/bin/bash
mkdir trimmed_sequences
for i in {1..14};
do
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 ${i}_S${i}_R1_001.fastq.gz ${i}_S${i}_R2_001.fastq.gz \
trimmed_sequences/${i}_forward_paired.fastq.gz trimmed_sequences/${i}_forward_unpaired.fastq.gz \
trimmed_sequences/${i}_reverse_paired.fastq.gz trimmed_sequences/${i}_reverse_unpaired.fastq.gz \
ILLUMINACLIP:Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done
