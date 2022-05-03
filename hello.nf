#!/usr/bin/env nextflow


lists = Channel.fromFilePairs( "$PWD/samples/*_{1,2}.fastq.gz", flat: true )

process qc_fastq {
    
    input:
        tuple val(name), path(read_1_path), path(read_2_path)

    output:
        tuple val(name), path("output_1.fastq.gz"), path("output_2.fastq.gz")

    script:
    """
        echo "Processing files..."
        echo "    name: $name"
        echo "    read_1_path: $read_1_path"
        echo "    read_2_path: $read_2_path"

        echo "Writing output..."
        touch output_1.fastq.gz
        touch output_2.fastq.gz
    """
}

workflow {
    qc_fastq(lists)
}