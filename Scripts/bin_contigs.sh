#!/bin/bash
##Contigs >1000 bp were binned using the binning module in metaWRAP v1.3. The two binning algorithms used were CONCOCT v1.1.0 and  
##metaBAT2 v2.12.1. Instructions on how to install and run metaWRAP can be found at https://github.com/bxlab/metaWRAP
source ~/anaconda3/bin/activate metawrap-env
metaWRAP binning -o JS_active_Binning -t 48 -a JS_active_MegahitAssemb/final.contigs.fa --concoct --metabat2 \
trimmed_sequences/1_paired_1.fastq trimmed_sequences/1_paired_2.fastq trimmed_sequences/2_paired_1.fastq trimmed_sequences/2_paired_2.fastq \
trimmed_sequences/3_paired_1.fastq trimmed_sequences/3_paired_2.fastq trimmed_sequences/4_paired_1.fastq trimmed_sequences/4_paired_2.fastq \
trimmed_sequences/5_paired_1.fastq trimmed_sequences/5_paired_2.fastq trimmed_sequences/6_paired_1.fastq trimmed_sequences/6_paired_2.fastq \
trimmed_sequences/7_paired_1.fastq trimmed_sequences/7_paired_2.fastq 
metaWRAP binning -o JS_relic_Binning -t 48 -a JS_relic_MegahitAssemb/final.contigs.fa --concoct --metabat2 \
trimmed_sequences/8_paired_1.fastq trimmed_sequences/8_paired_2.fastq trimmed_sequences/9_paired_1.fastq trimmed_sequences/9_paired_2.fastq \
trimmed_sequences/10_paired_1.fastq trimmed_sequences/10_paired_2.fastq trimmed_sequences/11_paired_1.fastq trimmed_sequences/11_paired_2.fastq \
trimmed_sequences/12_paired_1.fastq trimmed_sequences/12_paired_2.fastq trimmed_sequences/13_paired_1.fastq trimmed_sequences/13_paired_2.fastq \
trimmed_sequences/14_paired_1.fastq trimmed_sequences/14_paired_2.fastq
conda deactivate
