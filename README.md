# Phylogeography and Evolutionary History of the Wood Frog (*Rana sylvatica*)

## Introduction and Goals

The wood frog *Rana sylvatica* is largely distributed all over North America, with northern limits in Alaska, and southern limits in Georgia and Alabama, and is the only frog species to have populations beyond the arctic circle (Martof & Humphries 1959). Wood frogs have an interesting post-glacial recolonization history: previous work using two mitochondrial genes determined that wood frogs comprise two distinct lineages: an eastern and western clade, and a maritime eastern subclade (Lee-Yaw et al. 2008). These two clades of wood frogs expanded their range northward and occupied colder environments. 

The goal of my project is reconstruct the evolutionary history of wood frogs through analyzing ddRADSeq data and using a phylogeographic approach. I will be collecting DNA from museum specimens and from new samples during collecting trips. I aim to explore how the two lineages of wood frogs diverged, how genetically isolated they are now, identify possible contact zones, and investigate whether the two lineages adapted to colder environment in similar (parallel) ways.

My project builds open previous findings by Lee-Yaw et al, 2008 and aims to fill several gaps in our understanding of the full recolonization history. Mainly, many populations and sites were not represented in the 2008 study, and we still lack knowledge of possible contact zones between wood frog populations. For example, a particular area of interest is the northern boundary between the eastern and western clades, which was not resolved in the study. 

Because I do not yet have ddRADseq data for wood frogs, I will be basing my project on a  published study that investigated the phylogeography of a cryptic speciation continuum using the Eurasian spadefoot toads (*Pelobates spp.*). In the study, the authors generated a ddRADseq data that is publicly available on NCBI. (Dufresnes et al. 2019). I will replicate a part of the analyses that the authors performed, which involve processing the raw sequence data, and then performing phylogenetic analyses and constructing trees. The goal of my project is to investigate the phylogenetic relationship between several species within the *Pelobates* genus

Compared to the work in Dufresnes et al. 2019, my approach differs in that I will be ipyrad instead of STACKS for data processing, and I will perform maximum likelihood analyses using IQ-TREE in addition to the Bayesian analyses–I am curious to see how the results compare between these two phylogentic analysis methods. 

This project will enable me to develop an analysis pipeline to use for the future ddRADseq data that I will be generating from wood frog samples.


## Methods

### 1.	Data acquisition and cleaning
The sequence data is publicly available on NCBI as raw individual ddRAD sequences under BioProject PRJNA542138 with accessions SAMN11612144–SAMN11612336. There was a total of 193 samples encompassing six Pelobates species and/or subspecies: Pelobates balcanicus,  Pelobates cultripes, Pelobates fuscus, Pelobates fuscus vespertinus, Pelobates syriacus, Pelobates varaldii. The 193 samples also contained two outgroups: Scaphiopus couchii, and Spea bombifrons.

Resources online recommended the use of the SRA toolkit to download a large dataset in FASTA or FASTQ.gz format directly onto a cluster. However I had difficulty installing the SRA toolkit so I opted for manually downloading each read as a .fastq.gz file first onto my computer, then upload them to the cluster. Because each file took a long time to manually download and upload, and took up a large amount of space (~500MB) on my computer, I decided to only use a subset of the data. I initially selected 66 samples (Supplementary table 1), but due to computation time limits, I had to further decrease the number of samples and ended up using 13 samples only (including 1 outgroup sample) (Table 2.). See methods section for in-depth explanation of why I further reduced the dataset.

Run	| BioSample	| Organism
----|-----------|---------
SRR9036277| SAMN11612210|	*Pelobates cultripes*
SRR9036288|	SAMN11612224|	*Pelobates varaldii*
SRR9036297| SAMN11612222|	*Pelobates varaldii*
SRR9036138|	SAMN11612272|	*Pelobates fuscus vespertinus*
SRR9036233|	SAMN11612334|	*Scaphiopus couchii*
SRR9036111|	SAMN11612194|	*Pelobates balcanicus*
SRR9036276|	SAMN11612211|	*Pelobates cultripes*
SRR9036112|	SAMN11612240|	*Pelobates fuscus*
SRR9036114|	SAMN11612189|	*Pelobates balcanicus*
SRR9036113|	SAMN11612238|	*Pelobates fuscus*
SRR9036139|	SAMN11612269|	*Pelobates fuscus vespertinus*
SRR9036128|	SAMN11612159|	*Pelobates syriacus*
SRR9036127|	SAMN11612158|	*Pelobates syriacus*

Table 2. List of the 13 samples used in this project.

### 2.	ddRAD data processing
I used ipyrad v0.9.62 (Eaton and Overcast, 2020) to process and assemble the raw ddRAD sequences. I closely followed the online workshop material from [RADcamp](https://radcamp.github.io). Using the default parameters file, I msde the following modifications:
* **assembly method** to “de novo”
* **datatype** to "ddrad"
* **restriction_overhang** to "TGCAGG," corresponding to the Sbfl enzyme cut site (Brelsford et al. 2016). Althrouhg these are ddRAD sequences that were cut with two restriction enzymes, they are single-end reads and it is likley one does not see the second cutter overhang, which was the case for these sequences. As such the second restriction overhang was left blank (Eaton & Overcast, 2020).
* **filter_adapters** to “1”
* **trim_reads** to “0, 90, 0, 0”
* **output_formats**  to “*”

All other parameters were kept at default settings. The parameters file is available [here](https://github.com/YaraAlshw/finalproject/blob/master/params-toaddata.txt). I performed an additional data cleaning step and removed all empty lines from the .fastq files using the command `<grep -v '^[[:space:]]*$' file_input.fastq  > file_output.fastq>`. This step was necessary to ensure ipyrad reads the input files correctly.

Step 3 of ipyrad is computationally intensive, and for initial runs using 66 fasta files, the batch job failed because it ran out of time, despite using 16 CPUs. Because the class partition on Grace only allows for a maximum of 24 hrs per batch job, I decided to move my analyses to my personal account on the Farnam cluster and significantly decrease the number of samples. I redownloaded and reuploaded the 13 samples I described previously, and managed to have step 3 and the remaining steps of ipyrad run smoothly by increasing the number of CPUs and allocating more time.

### 3.	Phylogenetic analysis: IQ-TREE
I used IQ-TREE v1.6.12

### 4.	Phylogenetic analysis: BEAST


## Results

The tree in Figure 1...

## Discussion

These results indicate...

The biggest difficulty in implementing these analyses was...

If I did these analyses again, I would...

## References

Dufresnes C, Strachinis I, Suriadna N, Mykytynets G, Cogălniceanu D, et al. 2019. Phylogeography of a cryptic speciation continuum in Eurasian spadefoot toads ( Pelobates ). Mol Ecol. 28(13):3257–70. https://onlinelibrary.wiley.com/doi/abs/10.1111/mec.15133

Lee-Yaw JA, Irwin JT, Green DM. 2008. Postglacial range expansion from northern refugia by the wood frog, Rana sylvatica. Mol. Ecol. 17(3):867–84. https://pubmed.ncbi.nlm.nih.gov/18179428/

Martof BS, Humphries RL. 1959. Geographic Variation in the Wood Frog Rana sylvatica. American Midland Naturalist. 61(2):350. https://www.jstor.org/stable/pdf/2422506.pdf
