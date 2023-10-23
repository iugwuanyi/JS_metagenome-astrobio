###########################################################################################################
This directory contains all the scripts used to process metagenome sequences from biofilm and gravel samples 
collected from a travertine-forming spring in Svalbard in August 2011. The raw metagenome sequences and the 
associated metagenome assembled genomes (MAGs) can be found obtained from the NCBI SRA archive under Bioproject 
number XXXXXXX. For questions, please contact Ifeoma R. Ugwuanyi at ifeoma.r.ugwuanyi@gmail.com.
###########################################################################################################

Below is a list of all software packages used to process metagenome sequence: <br />
* Trimmomatic v0.39 <br />
* Kaiju v1.8.2 <br />
* MEGAHIT v1.2.9 <br />
* metaWrap v1.3 <br />
	* CONCOCT v1.1.0 <br />
	* metaBAT2 v2.12.1 <br />
	* checkM v1.0.12 <br />

## Below is a description of the sequence processing pipeline
Metagenome sequences were trimmed with [Trimmomatic](https://github.com/usadellab/Trimmomatic) using the trim_sequence.sh script. 
After trimming, sequences were taxonomically profiled with [Kaiju](https://github.com/bioinformatics-centre/kaiju) using 
assign_taxonomy.sh script. In order to generate draft genomes (bins), metagenome sequences were assembled into contigs with 
[MEGAHIT](https://github.com/voutcn/megahit) using the assemble_metagenomes.sh script. Samples from individual springs (active and relic springs) 
were co-assembled to maximize the recovery of genomes. Contigs were then clustered into metagenomic bins with [metaWRAP](https://github.com/bxlab/metaWRAP)
using the bin_contigs.sh script. The resulting bins were consolidated and bins with over 50% completeness and less than 10% contamination were 
selected with metaWRAP refinement module using the consolidate_bins.sh script. 
