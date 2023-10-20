###########################################################################################################
This directory contains all the scripts used to process metagenome sequences from biofilm and gravel samples 
collected from a travertine-forming spring in Svalbard in August, 2011. The raw metagenome sequences and the 
associated metagenome assembled genomes (MAGs) can be found obtained from the NCBI SRA archive under Bioproject 
number XXXXXXX. For questions, please contact Ifeoma R. Ugwuanyi at ifeoma.r.ugwuanyi@gmail.com.
###########################################################################################################

Below is a list of all software packages used for metagenome sequence analyses  <br />
* Trimmomatic v0.39 <br />
* Kaiju v1.8.2 <br />


Metagenome sequences were trimmed with Trimmomatic https://github.com/usadellab/Trimmomatic using the trim_sequence.sh script. After trimming, sequences 
were taxonomically profiled with Kaiju https://github.com/bioinformatics-centre/kaiju using assign_taxonomy.sh script.