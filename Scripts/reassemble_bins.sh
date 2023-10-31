#!/bin/bash

#######################################################################################################################
#
# Bins were reassembled using the reassemble_bin module in metaWRAP to improve the quality of the bins. The reassemble_bin module uses
# SPAdes for reassembly. The -c 50 -x 10 flags were used to keep only bins with over 50% completness and <10% contamination. 
# Instructions on how to install and run metaWRAP can be found at https://github.com/bxlab/metaWRAP
#
#######################################################################################################################


#merging all forward sequences and all reverse sequences for active samples
cd trimmed_sequences/active_sequences
cat 1_paired_1.fastq 2_paired_1.fastq 3_paired_1.fastq 4_paired_1.fastq 5_paired_1.fastq 6_paired_1.fastq 7_paired_1.fastq > JS_activeAll_1.fastq
cat 1_paired_2.fastq 2_paired_2.fastq 3_paired_2.fastq 4_paired_2.fastq 5_paired_2.fastq 6_paired_2.fastq 7_paired_2.fastq > JS_activeAll_2.fastq

#merging all forward sequences and all reverse sequences for relic samples
cd ~/trimmed_sequences/relic_sequences
cat 8_paired_1.fastq 9_paired_1.fastq 10_paired_1.fastq 11_paired_1.fastq 12_paired_1.fastq 13_paired_1.fastq 14_paired_1.fastq > JS_reliceAll_1.fastq
cat 8_paired_2.fastq 9_paired_2.fastq 10_paired_2.fastq 11_paired_2.fastq 12_paired_2.fastq 13_paired_2.fastq 14_paired_2.fastq > JS_relicAll_2.fastq
cd

source ~/anaconda3/bin/activate metawrap-env

#reassembling bins with metaWRAP
metawrap reassemble_bins -o JS_active_reassembledbins -1 trimmed_sequences/active_sequences/JS_activeAll_1.fastq \
-2 trimmed_sequences/active_sequences/JS_activeAll_2.fastq -t 48 -m 180 -c 50 -x 10 -b JS_active_binRefined/metawrap_50_10_bins
metawrap reassemble_bins -o JS_relic_reassembledbins -1 trimmed_sequences/relic_sequences/JS_relicAll_1.fastq \
-2 trimmed_sequences/relic_sequences/JS_relicAll_2.fastq -t 48 -m 180 -c 50 -x 10 -b JS_relic_binRefined/metawrap_50_10_bins

conda deactivate