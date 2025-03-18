set -x -e
scratch="/sc/arion/scratch/arayan01/projects/chipseq_tut"
sampledir="${scratch}/data/samples"


function samplelist {
	ls ${sampledir} | while IFS="_" read -r sample accession; do
    echo -e "${sample}\t${accession}" >> samplelist.txt
    done
}

samplelist