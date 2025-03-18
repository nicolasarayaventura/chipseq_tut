set -x -e
scratch="/sc/arion/scratch/arayan01/projects/chipseq_tut"
function raw_data1 {
    sampledir="${scratch}/data/samples"
        cat url_links.txt | while read sample accession url
        do
        wget -c -O "${sampledir}/${sample}_${accession}" "${url}"
        done < url_links.txt
}

raw_data1