#!/usr/bin/env nextflow

/* A minimal pipeline to illustrate how to use nextflow.

    The Input to the pipeline is a path to a directory (input_dir) that contains fastq.gz read pairs. 
    The read pairs should be formatted: NAME_1.fastq.gz, NAME_2.fastq.gz

    The Output of the pipeline is stored in the output directory (output_dir) defined below 
*/

input_dir = "$PWD/samples/"
output_dir = "$PWD/output/"

lists = Channel.fromFilePairs( "$input_dir/*_{1,2}.fastq.gz", flat: true )

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