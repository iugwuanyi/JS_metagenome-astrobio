#!/bin/bash

#######################################################################################################################
# Metagenome sequences were co-assembled into contigs using MEGAHIT v1.2.9. Contigs < 1000 bp were removed using the 
# --min-contig-len flag. Instructions on how to install and run MEGAHIT can be found at https://github.com/voutcn/megahit
#######################################################################################################################

cd MEGAHIT-1.2.9-Linux-x86_64-static/bin

#assembling active metagenomes
./megahit -1 ~/trimmed_sequences/1_paired_1.fastq,~/trimmed_sequences/2_paired_1.fastq,~/trimmed_sequences/3_paired_1.fastq,\
~/trimmed_sequences/4_paired_1.fastq,~/trimmed_sequences/5_paired_1.fastq,~/trimmed_sequences/6_paired_1.fastq,\
~/trimmed_sequences/7_paired_1.fastq -2 ~/trimmed_sequences/1_paired_2.fastq,~/trimmed_sequences/2_paired_2.fastq,\
~/trimmed_sequences/3_paired_2.fastq,~/trimmed_sequences/4_paired_2.fastq,~/trimmed_sequences/5_paired_2.fastq,\
~/trimmed_sequences/6_paired_2.fastq,~/trimmed_sequences/7_paired_2.fastq --min-contig-len 1000 -o ~/JS_active_MegahitAssemb

#assembling relic metagenomes
./megahit -1 ~/trimmed_sequences/8_paired_1.fastq,~/trimmed_sequences/9_paired_1.fastq,~/trimmed_sequences/10_paired_1.fastq,\
~/trimmed_sequences/11_paired_1.fastq,~/trimmed_sequences/12_paired_1.fastq,~/trimmed_sequences/13_paired_1.fastq,\
~/trimmed_sequences/14_paired_1.fastq -2 ~/trimmed_sequences/8_paired_2.fastq,~/trimmed_sequences/9_paired_2.fastq,\
~/trimmed_sequences/10_paired_2.fastq,~/trimmed_sequences/11_paired_2.fastq,~/trimmed_sequences/12_paired_2.fastq,\
~/trimmed_sequences/13_paired_2.fastq,~/trimmed_sequences/14_paired_2.fastq --min-contig-len 1000 -o ~/JS_relic_MegahitAssemb