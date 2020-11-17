# Minimum viable analysis 
Methods closely follow Dufresnes et al. 2019

## Data aquision and processing

Note: the two restriction enzymes used were SbfI and MseI (Brelsford et al. 2016)

1. I will download the data from NCBI. Unfortunately, my attemps at downloading the 192 raw individual reads all at once and directly onto the cluster have been unsuccessful. 
I downlaoded one read to use as an example for my minimum viable analysis plan. The reads are in fasta.gz format, which can be decompressed using the command *gzip -d*

2. After downloading all the 192 individual reads onto the cluster, I will add them to a new directory **raw_reads**. I will use STACKS (command line) to first demultiplex using *process_radtags* 

process_radtags -P -p ./raw  -b ./barcodes/barcodes -o ./output/ \
                  -c -q -r --inline_index --renz_1 nlaIII --renz_2 mluCI
                 
Where ./raw_reads is the directory containing the fasta.gz reads
      ./output the directory where the output files will be writtern
      ./barcodes/barcodes is a file that contains the barcodes used in the sequencing
      renz_1 and renz_2 are the two restriction enzymes
      
3. Next, I will stack and cataloge the homologous loci using **ustacks**, **cstacks** and **sstacks**. I will use default ‐m ‐n, and ‐M values
4. I will call the SNPs using minor allele frequency of 0.05 and maximum observed heterozygosity of 0.75
  

## Phylogenetic analysis

1. I will use **BEAST** to perform this analsis. I will use a lognormal relaxed molecular clock, with a normally distributed prior and a birth–death tree model. I will use the GTR + G substitution model.
I will run the chains for 100 million iterations, and sample one tree every 50,000

2. I will use the beast module TreeAnnotator to build maximum‐clade credibility trees (will discard the first 20% of trees as burnin)

3. As a measure of divergence between the main clades, I will compute pairwise nucleotide distances


## Extra – Population tructure

1. If time allows, I would like to visualize the genetic structure of spadefoot toads. To do this, I will perform PCA using the packages **ade4** and **adegenet** on R
