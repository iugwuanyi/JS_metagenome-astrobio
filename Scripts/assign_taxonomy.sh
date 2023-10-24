#!/bin/bash
##Taxonomy was assigned to sequences using Kaiju v1.82 against the NCBI nr+euk database. The parameters used to assign taxonomy
##are run mode: greedy, minimum match length: 11, minimum match score: 75, allowed mismatches: 5. Instructions on how to install 
##and run Kaiju can be found here https://github.com/bioinformatics-centre/kaiju
#Unzipping and renaming trimmed sequences
cd trimmed_sequences
gunzip *.gz
for i in {1..14};
do
mv ${i}_forward_paired.fastq ${i}_paired_1.fastq
mv ${i}_reverse_paired.fastq ${i}_paired_2.fastq
done
cd
#Creating Kaiju index
cd kaiju
mkdir kaijudb
cd kaijudb
kaiju-makedb -s nr_euk
cd
#Running Kaiju
mkdir kaiju_output
kaiju-multi -z 48 -t kaiju/bin/kaijudb/nodes.dmp kaiju/bin/kaijudb/kaiju_db_nr_euk.fmi -v -e 5 -s 75\
-i trimmed_sequences/1_paired_1.fastq,trimmed_sequences/2_paired_1.fastq,trimmed_sequences/3_paired_1.fastq,\
trimmed_sequences/4_paired_1.fastq,trimmed_sequences/5_paired_1.fastq,trimmed_sequences/6_paired_1.fastq,\
trimmed_sequences/7_paired_1.fastq,trimmed_sequences/8_paired_1.fastq,trimmed_sequences/9_paired_1.fastq,\
trimmed_sequences/10_paired_1.fastq,trimmed_sequences/11_paired_1.fastq,trimmed_sequences/12_paired_1.fastq,\
trimmed_sequences/13_paired_1.fastq,trimmed_sequences/14_paired_1.fastq, -j trimmed_sequences/1_paired_2.fastq,\
trimmed_sequences/2_paired_2.fastq,trimmed_sequences/3_paired_2.fastq,trimmed_sequences/4_paired_2.fastq,\
trimmed_sequences/5_paired_2.fastq,trimmed_sequences/6_paired_2.fastq,trimmed_sequences/7_paired_2.fastq,\
trimmed_sequences/8_paired_2.fastq,trimmed_sequences/9_paired_2.fastq,trimmed_sequences/10_paired_2.fastq,\
trimmed_sequences/11_paired_2.fastq,trimmed_sequences/12_paired_2.fastq,trimmed_sequences/13_paired_2.fastq,\
trimmed_sequences/14_paired_2.fastq > kaiju_output/1_taxonomyKaiju.out,kaiju_output/2_taxonomyKaiju.out,\
kaiju_output/3_taxonomyKaiju.out,kaiju_output/4_taxonomyKaiju.out,kaiju_output/5_taxonomyKaiju.out,kaiju_output/6_taxonomyKaiju.out,\
kaiju_output/7_taxonomyKaiju.out,kaiju_output/8_taxonomyKaiju.out,kaiju_output/9_taxonomyKaiju.out,kaiju_output/10_taxonomyKaiju.out,\
kaiju_output/11_taxonomyKaiju.out,kaiju_output/12_taxonomyKaiju.out,kaiju_output/13_taxonomyKaiju.out,kaiju_output/14_taxonomyKaiju.out
#Generating summary taxonomy table from the output above. Unclassified reads were excluded from the total number of reads when calculating percentages.
cd kaiju_output
kaiju2table -t ~/kaiju/bin/kaijudb/nodes.dmp -n ~/kaiju/bin/kaijudb/names.dmp -r species -l superkingdom,phylum,class,order,family,\
genus,species -e -u -o JS_taxonomytable.tsv 1_taxonomyKaiju.out 2_taxonomyKaiju.out 3_taxonomyKaiju.out 4_taxonomyKaiju.out \
5_taxonomyKaiju.out 6_taxonomyKaiju.out 7_taxonomyKaiju.out 8_taxonomyKaiju.out 9_taxonomyKaiju.out 10_taxonomyKaiju.out \
11_taxonomyKaiju.out 12_taxonomyKaiju.out 13_taxonomyKaiju.out 14_taxonomyKaiju.out
