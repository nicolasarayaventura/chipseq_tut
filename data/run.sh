set -x -e
scratch="/sc/arion/scratch/arayan01/projects/chipseq_tut"
function raw_data {
    sampledir="${scratch}/data/samples"
        cat url_links.txt | while read sample url
        do
        wget -c -O "${sampledir}/${sample}.fastq.gz" "${url}"
        done < url_links.txt
}

raw_data