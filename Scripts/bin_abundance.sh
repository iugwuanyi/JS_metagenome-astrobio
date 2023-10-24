##The distribution and abundance of bins across samples was estimated using the quant_bin module in metaWRAP. The quant_bin module 
##uses Salmon to estimate abundance. Instructions on how to install and run metaWRAP can be found at https://github.com/bxlab/metaWRAP
#!/bin/bash
mkdir All_MAGs
cd JS_active_binRefined/metawrap_50_10_bins
for bin in *.fa;
do
cp ${bin} ~/All_MAGs/Ac.${bin};
done
cd ~/JS_relic_binRefined/metawrap_50_10_bins
for bin in *.fa;
do
cp ${bin} ~/All_MAGs/Re.${bin};
done
cd ~/trimmed_sequences
mkdir active_sequences
mkdir relic_sequences
for i in {1..7};
do
mv ${i}_paired_* active_sequences;
done
for i in {8..14};
do
mv ${i}_paired_* relic_sequences;
done
cd
conda activate metawrap-env
metawrap quant_bins -b All_MAGs -o JS_active_binAbundance -a JS_active_MegahitAssemb/final.contigs.fa \
trimmed_sequences/active_sequences/*.fastq -t 48
metawrap quant_bins -b All_MAGs -o JS_relic_binAbundance -a JS_relic_MegahitAssemb/final.contigs.fa \
trimmed_sequences/relic_sequences/*.fastq -t 48
conda deactivate