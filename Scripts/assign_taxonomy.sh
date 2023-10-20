##Taxonomy was assigned to sequences using Kaiju v1.82 against the NCBI nr+euk database. The parameters used to assign taxonomy
##are run mode: greedy, minimum match length: 11, minimum match score: 75, allowed mismatches: 5. Instructions on how to install 
##and run Kaiju can be found here https://github.com/bioinformatics-centre/kaiju
#!/bin/bash
#Creating Kaiju index
mkdir kaijudb
cd kaijudb
kaiju-makedb -s nr_euk
cd ..
#Running Kaiju
kaiju-multi -z 48 -t kaiju/bin/kaijudb/nodes.dmp kaiju/bin/kaijudb/kaiju_db_nr_euk.fmi -v -e 5 -s 75\
-i 1_paired_1.fastq,2_paired_1.fastq,3_paired_1.fastq,4_paired_1.fastq,5_paired_1.fastq,6_paired_1.fastq,7_paired_1.fastq,\
8_paired_1.fastq,9_paired_1.fastq,10_paired_1.fastq,11_paired_1.fastq,11_paired_1.fastq,13_paired_1.fastq,14_paired_1.fastq,\
-j 1_paired_2.fastq,2_paired_2.fastq,3_paired_2.fastq,4_paired_2.fastq,5_paired_2.fastq,6_paired_2.fastq,7_paired_2.fastq,\
8_paired_2.fastq,9_paired_2.fastq,10_paired_2.fastq,11_paired_2.fastq,12_paired_2.fastq,13_paired_2.fastq,14_paired_2.fastq\
> 1_taxonomyKaiju.out,2_taxonomyKaiju.out,3_taxonomyKaiju.out,4_taxonomyKaiju.out,5_taxonomyKaiju.out,6_taxonomyKaiju.out,\
7_taxonomyKaiju.out,8_taxonomyKaiju.out,9_taxonomyKaiju.out,10_taxonomyKaiju.out,11_taxonomyKaiju.out,12_taxonomyKaiju.out,\
13_taxonomyKaiju.out,14_taxonomyKaiju.out
#Generating summary taxonomy table from the output above. Unclassified reads were excluded from the total number of reads when calculating percentages.
kaiju2table -t kaiju/bin/kaijudb/nodes.dmp -n kaiju/bin/kaijudb/names.dmp -r species -l superkingdom,phylum,class,order,family,\
genus,species -e -u -o JS_taxonomytable.tsv 1_taxonomyKaiju.out 2_taxonomyKaiju.out 3_taxonomyKaiju.out 4_taxonomyKaiju.out \
5_taxonomyKaiju.out 6_taxonomyKaiju.out 7_taxonomyKaiju.out 8_taxonomyKaiju.out 9_taxonomyKaiju.out 10_taxonomyKaiju.out \
11_taxonomyKaiju.out 12_taxonomyKaiju.out 13_taxonomyKaiju.out 14_taxonomyKaiju.out
