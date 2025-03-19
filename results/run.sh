set -x -e
scratch="/sc/arion/scratch/arayan01/projects/chipseq_tut"
sampledir="${scratch}/data/samples"


function samplelist {
	ls ${sampledir} | while IFS="_" read -r sample accession; do
    echo -e "${sample}\t${accession}" >> samplelist.txt
    done
}
function broadpeakcalling {
    rm -rf ${scratch}/data/peak
    mkdir ${scratch}/data/peak
    peak="${scratch}/data/peak"
    control="${sampledir}/GM23338_ENCFF395DAJ.bam"
    treatment="${sampledir}/GM23338_ENCFF956GLJ.bam"

    macs2 callpeak --broad -t ${treatment} -c ${control} -f BAMPE -g 04.9e8 -n ${peak}/neuroGM23338_macs2_rep1
# -t This is the only REQUIRED parameter for MACS. The file can be in any supported format 
#-- see detail in the --format option. If you have more than one alignment file, you can specify them as -t A B C. MACS will pool up all these files together.

#-c/--control
#The control, genomic input or mock IP data file. Please follow the same direction as for -t/--treatment.

#A special mode will be triggered while the format is specified as BAMPE or BEDPE. In this way, MACS2 will process the BAM or BED files as paired-end data. Instead of building 
#a bimodal distribution of plus and minus strand reads to predict fragment size, MACS2 will use actual insert sizes of pairs of reads to build fragment pileup.
#The BAMPE format is just a BAM format containing paired-end alignment information, such as those from BWA or BOWTIE.
#The BEDPE format is a simplified and more flexible BED format, which only contains the first three columns defining the chromosome name, left and right position of the fragment from 
#Paired-end sequencing. Please note, this is NOT the same format used by BEDTOOLS, and the BEDTOOLS version of BEDPE is actually not in a standard BED format.
#You can use MACS2 subcommand randsample to convert a BAM file containing paired-end information to a BEDPE format file:

#-g/--gsize
#PLEASE assign this parameter to fit your needs!
#It's the mappable genome size or effective genome size which is defined as the genome size which can be sequenced. Because of the repetitive features on the chromosomes, the actual mappable genome size will be smaller than the
#original size, about 90% or 70% of the genome size. 
#The default hs -- 2.7e9 is recommended for human genome. Here are all precompiled parameters for effective genome size:
#hs: 2.7e9
#mm: 1.87e9
#ce: 9e7
#dm: 1.2e8
#Users may want to use k-mer tools to simulate mapping of Xbps long reads to target genome, and to find the ideal effective genome size. However, usually by taking away the simple repeats and Ns from the total genome, one can get an approximate number of effective genome size. A slight difference in the number won't cause a big difference of peak calls,
#because this number is used to estimate a genome-wide noise level which is usually the least significant one compared with the local biases modeled by MACS.

#-n/--name
#The name string of the experiment. MACS will use this string NAME to create output files 
#like NAME_peaks.xls, NAME_negative_peaks.xls, NAME_peaks.bed , NAME_summits.bed, NAME_model.r and so on. So please avoid any confliction between these filenames and your existing files.

}
function broaddomainfiltering {
    rm -rf peaks
    mkdir peaks
    cut -f 1-6 neuroGM23338_macs3_rep1_peaks.broadPeak >neuroGM23338_macs2_rep1_peaks.bed
    cut -f 1-6 neuroGM23338_macs3_rep2_peaks.broadPeak >neuroGM23338_macs2_rep2_peaks.bed
    # selects first 7 columns of broadpeak created in the calling step and creates a BED-6 format
    #in order to use with bedtools
    #use wc -l to identify how many peaks counted here compared to previous file 

}

#samplelist
broadpeakcalling
