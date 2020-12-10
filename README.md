# Phylogeography of the Eurasian Spadefoot Toads (*Pelobates spp.*)

## Introduction and Goals

The wood frog *Rana sylvatica* is largely distributed all over North America, with northern limits in Alaska, and southern limits in Georgia and Alabama, and is the only frog species to have populations beyond the arctic circle (Martof & Humphries 1959). Wood frogs have an interesting post-glacial recolonization history: previous work using two mitochondrial genes determined that wood frogs comprise two distinct lineages: an eastern and western clade, and a maritime eastern subclade (Lee-Yaw et al. 2008). These two clades of wood frogs expanded their range northward and occupied colder environments. 

For one of my dissertation chapters, I want to reconstruct the evolutionary history of wood frogs using ddRADSeq data and a phylogeographic approach. I will be collecting DNA from museum specimens and from new samples during collecting trips. I aim to explore how the two lineages of wood frogs diverged, how genetically isolated they are now, identify possible contact zones, and investigate whether the two lineages adapted to colder environment in similar (parallel) ways. My project builds open previous findings by Lee-Yaw et al, 2008 and aims to fill several gaps in our understanding of the full recolonization history. Mainly, many populations and sites were not represented in the 2008 study, and we still lack knowledge of possible contact zones between wood frog populations. For example, a particular area of interest is the northern boundary between the eastern and western clades, which was not resolved in the study. 

Because I do not yet have ddRADseq data for wood frogs, I will be modeling my project on a published study that investigated the phylogeography of a cryptic speciation continuum using the Eurasian spadefoot toads (*Pelobates spp.*). In the study, the authors generated a ddRADseq data that is publicly available on NCBI. (Dufresnes et al. 2019). I will replicate a part of the analyses that the authors performed, which involve processing the raw sequence data, and then performing phylogenetic analyses and constructing trees using a a Bayesian approach. **The goal of my project is to investigate the phylogenetic relationship between several species within the *Pelobates* genus.** Compared to the work in Dufresnes et al. 2019, my approach differs in that I will use ipyrad instead of STACKS for data processing, and I will perform maximum likelihood analyses using IQ-TREE in addition to the Bayesian analyses the authors performed–I am curious to see how the results compare between these two phylogentic analyses methods. 

This project will enable me to develop an analysis pipeline to use for the future ddRADseq data that I will be generating from wood frog samples.


## Methods

### 1.	Data acquisition and cleaning
The sequence data is publicly available on NCBI as raw individual ddRAD sequences under BioProject PRJNA542138 with accessions SAMN11612144–SAMN11612336. There was a total of 193 samples encompassing six *Pelobates* species and/or subspecies: *Pelobates balcanicus*,  *Pelobates cultripes*, *Pelobates fuscus*, *Pelobates fuscus vespertinus*, *Pelobates syriacus*, *Pelobates varaldii*. The 193 samples also contained two outgroups: *Scaphiopus couchii*, and *Spea bombifrons*.

Resources online recommended the use of the SRA toolkit to download a large dataset in fasta or fastq.gz format directly onto a cluster. However I had difficulty installing the SRA toolkit so I opted for manually downloading each read as a .fastq.gz file first onto my computer and then upload them to the cluster. Because each file took a long time to manually download and upload, and took up a large amount of space (~500MB) on my computer, I decided to only use a subset of the data. I initially selected 66 samples [(Supplementary table 1)](https://github.com/YaraAlshw/finalproject/blob/master/Supplementary_table1.txt), but due to computation time limits, I had to further decrease the number of samples and ended up using only 13 samples that included 2 samples from each species and/or subspecies of *Pelobates*, and 1 outgroup sample (Table 1). See “ddRAD data processing” section for an in-depth explanation of why I further reduced the dataset.

Table 1. List of the 13 samples used in this project.
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


### 2.	ddRAD data processing
Instead of using STACKS as proposed in my [minimum viable analysis](https://github.com/YaraAlshw/finalproject/blob/master/Minimum%20viable%20analysis.md), I instead used ipyrad v0.9.62 (Eaton and Overcast, 2020) to process and assemble the raw, demultiplexed ddRAD sequences. I closely followed the online workshop material from [RADcamp](https://radcamp.github.io). Using the default parameters file, I msde the following modifications:
* **assembly method** to “de novo”
* **datatype** to "ddrad"
* **restriction_overhang** to "TGCAGG," corresponding to the Sbfl enzyme cut site (Brelsford et al. 2016). Althrouhg these are ddRAD sequences that were cut with two restriction enzymes, they are single-end reads and it is likley one does not see the second cutter overhang, which was the case for these sequences. As such the second restriction overhang was left blank (Eaton & Overcast, 2020).
* **filter_adapters** to “1”
* **trim_reads** to “0, 90, 0, 0”
* **output_formats**  to “*”

All other parameters were kept at default settings. The parameters file is available [here](https://github.com/YaraAlshw/finalproject/blob/master/ipyrad/params-toaddata.txt). I performed an additional data cleaning step and removed all empty lines from the .fastq files using the command `<grep -v '^[[:space:]]*$' file_input.fastq  > file_output.fastq>`. This step was necessary to ensure ipyrad reads the input files correctly.

Step 3 of ipyrad is computationally intensive, and for initial runs using 66 fasta files, the batch job failed because it ran out of time, despite using 16 CPUs. Because the class partition on Grace only allows for a maximum of 24 hrs per batch job, I decided to move my analyses to my personal account on the Farnam cluster and to significantly decrease the number of samples. I redownloaded and reuploaded the 13 samples I described previously, and managed to have step 3 and the remaining steps of ipyrad run smoothly by increasing the number of CPUs and allocating more time to the job.

### 3. Phylogenetic analysis: IQ-TREE
I used IQ-TREE v1.6.12 (Nguyen et al. 2015) to generate maximum likelihood trees and perform model selection (Kalyaanamoorthy et al. 2017). Using the toadata.phy output from ipyrad which contains the multiple sequence alignment, I ran 1000 bootstraps (Hoang et al. 2018), and explored the toaddata.phy.iqtree output file in Atom v1.50.0. Because IQ-TREE produces unrooted trees, I exported the toaddata.phy.tree output to FigTree v1.4.4 and selected the outgroup branch corresponding to *Scaphiopus couchii* to reroot the tree.


### 4.	Phylogenetic analysis: BEAST
I used BEUTi v2.6.3 and the module starBEAST (Bouckaert et al. 2019) to convert the NEXUS output file from ipyrad into a BEAST XML input file. There were errors when I initially tried opening the NEXUS file in BEAUTi – upon inspection of the file in Atom, I tried removing the character blocks at the bottom of the file, which resolved the issue. I manually added the species name under “Taxon sets”, and selected the GTR substitution model and the option “empirical” for frequencies. I used a log-normal relaxed molecular clock with a normal prior, birth-death tree model. I set the chain length to 10 million, and sampled every 5,000 trees. All other parameters were kept at default settings. I used the XML file in BEAST v2.6.3, and finally used Tracer v1.7.1 to inspect the output of BEAST (Rambaut et al. 2018).

To explore the plausible trees that BEAST produced and build a maximum-clade credibility tree (i.e., the one that best represents the posterior distribution), I used the program TreeAnnotator v2.6.3 using default parameters, and discarded the first 20% of trees as burnin.


## Results

IQ-TREE selected the TVM+F+G4 as the best-fit model, with a log likelihood of -8422347.559685886. There was 100% bootstrap support for all edges except for the edge representing the split into the *P. fuscus*, *P.f. vespertinus*, *P. syriacus*, and *P. balcanicus* lineage (bootstrap support = 81%) (Figure 1). The results of the BEAST analysis indicated high posterior probabilities (0.9938-1) for all nodes (Figure 2).

Both the maximum likelihood tree geenrated using IQ-TREE (Figure 1), and the maximum-clade credibilty tree generated using TreeAnnotator (Figure 2) showed the six species of toads grouped as sister taxa as follows: *P. fuscus* & *P.f. vespertinus*, *P. syriacus* & *P. balcanicus*, and *P. cultripes* & *P. varaldii*. Note that in figure 2, *Pelobates cultripes* was duplicated because of an error in labeling the taxa using starBEAST – these two nodes can be collapsed into one. 

The two trees also supported a split between the lineage of the two sister taxa, *P. cultripes* & *P. varaldii*, and the two other groups of sister taxa: *P. fuscus*, *P.f. vespertinus*, *P. syriacus*, and *P. balcanicus*

<p align="center">
  <img src="https://github.com/YaraAlshw/finalproject/blob/master/IQ_TREE/iqtree_figtree_withspp_names.png">
</p>
Figure 1. Maximum likelihood tree generated using IQ-TREE and visualized using FigTree. Bootstrap values for each edge are on the child node of the edge.



<p align="center">
  <img src="https://github.com/YaraAlshw/finalproject/blob/master/BEAST/BEAST_species.tree_FigTree4.png>
</p>
Figure 2. Maximum-clade credibility tree generated using TreeAnnotator and visualized using FigTree. Bayesian posterior probabilities are shown on the edges. Note that *Pelobates cultripes* is duplicated because of an error in labeling the taxa using starBEAST – these two nodes can be collapsed into one.


## Discussion 

Overall, the results indicate the presense of 3 sets of sister species in the *Pelobates* genus, and a split into two lineages.

Although the analyses in Dufresnes et al 2019 relied on the complete dataset, and the authors further differntatied several species into more subspecies and/or groups (i.e., *P. balcanicus* into *P. balcanicus* South, *P. balcanicus* East, *P. balcanicus* West, and *P. balcanicus chloeae*, my results using only 13 samples were very similar to what they observed, which gives me more confidence in the analyses I performed. Namely, the split between the lineage of the two sister taxa, *P. cultripes* & *P. varaldii*, and the two other groups of sister taxa was also observed by the authors. Additionally, Dufresnes et al 2019 found support for the grouping of the sister species using PCAs.

It is also interesting that using such a small dataset compared to the full dataset (~7% of the full dataset), yielded results that were in agreement with the results using the complete dataset, at least in terms of trees and general groupings. This is an important consideration when analyzing pilot datasets where only a small sample size may be feasible. Lastly, the results between IQ-TREE and BEAST were quite similar. While Dufresnes et al 2019 only used BEAST for their analyses, it would be interesting to examine how the results from IQ-TREE will differ, if any, when using the complete dataset.

The biggest difficulty in implementing these analyses was data acquisition and processing. 

If I did these analyses again, I would use the full dataset of 193 sequences. I would also explore different parameters in BEAST, such as increasing the number of iterations.

## References

Bouckaert R., Vaughan T.G., Barido-Sottani J., Duchêne S., Fourment M., Gavryushkina A., et al. 2019. BEAST 2.5: An advanced software platform for Bayesian evolutionary analysis. PLoS computational biology, 15(4). https://doi.org/10.1371/journal.pcbi.1006650

Diep Thi Hoang, Olga Chernomor, Arndt von Haeseler, Bui Quang Minh, and Le Sy Vinh. 2018. UFBoot2: Improving the ultrafast bootstrap
approximation. Mol Biol Evol, 35:518–522, https://doi.org/10.1093/molbev/msx281

Dufresnes C, Strachinis I, Suriadna N, Mykytynets G, Cogălniceanu D, et al. 2019. Phylogeography of a cryptic speciation continuum in Eurasian spadefoot toads ( Pelobates ). Mol Ecol. 28(13):3257–70. https://onlinelibrary.wiley.com/doi/abs/10.1111/mec.15133

Eaton DAR, Overcast I. ipyrad: Interactive assembly and analysis of RADseq datasets. Bioinformatics. 2020. 36(8):2592-2594. https://doi.org/10.1093/bioinformatics/btz966

Lam-Tung Nguyen, Heiko A. Schmidt, Arndt von Haeseler, and Bui Quang Minh. 2015. IQ-TREE: A fast and effective stochastic algorithm for estimating maximum likelihood phylogenies. Mol Biol Evol, 32:268-274. https://doi.org/10.1093/molbev/msu300

Lee-Yaw JA, Irwin JT, Green DM. 2008. Postglacial range expansion from northern refugia by the wood frog, Rana sylvatica. Mol. Ecol. 17(3):867–84. https://pubmed.ncbi.nlm.nih.gov/18179428/

Martof BS, Humphries RL. 1959. Geographic Variation in the Wood Frog Rana sylvatica. American Midland Naturalist. 61(2):350. https://www.jstor.org/stable/pdf/2422506.pdf

Rambaut A, Drummond AJ, Xie D, Baele G and Suchard MA. 2018. Posterior summarisation in Bayesian phylogenetics using Tracer 1.7. Systematic Biology. syy032. https://doi.org/10.1093/sysbio/syy032

S. Kalyaanamoorthy, B.Q. Minh, T.K.F. Wong, A. von Haeseler, and L.S. Jermiin. 2017. ModelFinder: fast model selection for accurate phylogenetic estimates. Nat. Methods, 14:587–589. https://doi.org/10.1038/nmeth.4285


