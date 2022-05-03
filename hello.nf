#!/usr/bin/env nextflow


lists = Channel.fromFilePairs( "$PWD/samples/*_{1,2}.fastq.gz", flat: true )
output_dir = "$PWD/output/"

process qc_fastq {
    
    input:
        tuple val(name), path(read_1_path), path(read_2_path)

    output:
        tuple val(name), path("output_1.fastq.gz"), path("output_2.fastq.gz")

    script:
    """
        echo "Running a qc_fastq process..."
        echo "    name: $name"
        echo "    read_1_path: $read_1_path"
        echo "    read_2_path: $read_2_path"

        echo "Writing output..."
        touch output_1.fastq.gz
        touch output_2.fastq.gz
    """
}

process fastq_to_fasta {
    input:
        tuple val(name), path(read_1_path), path(read_2_path)

    output:
        tuple val(name), path("assembled.fasta")

    script:
    """
        echo "Running a fastq_to_fasta process..."
        echo "    name: $name"
        echo "    read_1_path: $read_1_path"
        echo "    read_2_path: $read_2_path"

        echo "Writing output..."
        touch assembled.fasta
    """
}

process annotate {
    publishDir "$output_dir/", mode: 'copy', pattern: '*.txt'

    input:
        tuple val(name), path(assembled)

    output:
        path('*_annotated.txt')

    script:
    """
        echo "Running an annotate process..."
        echo "    name: $name"
        echo "    assembled: $assembled"

        echo "Writing output..."
        echo "$name is annotated" > $name"_annotated.txt"
    """
}

workflow {
    qc_fastq(lists)
    fastq_to_fasta(qc_fastq.out)
    annotate(fastq_to_fasta.out)
}