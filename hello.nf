#!/usr/bin/env nextflow

/* A minimal pipeline to illustrate how to use nextflow.

    The Input to the pipeline is a path to a directory (input_dir) that contains fastq.gz read pairs. 
    The read pairs should be formatted: NAME_1.fastq.gz, NAME_2.fastq.gz

    The Output of the pipeline is stored in the output directory (output_dir) defined below 

    The pipeline's workflow is structured:
        (input) fastq read pair --> qc_fastq --> fastq_to_fasta --> annotate --> (ouput) txt file
*/

// Edit these lines to change what samples you are providing, and where output is saved to
input_dir = "$PWD/samples/"
output_dir = "$PWD/output/"

// Pairs read files together, so they can passed through the pipeline together
read_pairs = Channel.fromFilePairs( "$input_dir/*_{1,2}.fastq.gz", flat: true )

// Quality control. Produces two fastq files from two fastq files, representing the read pair
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

// Assembly. Produces an assembled fastq file from a fastq read pair
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

// Annotate. Analyse the assembled fasta and produces an output txt file
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

/* The workflow defines how all the steps of the pipeline connect together. 

Notice how the pipeline's workflow is structured:
    read pairs channel --> qc_fastq --> fastq_to_fasta --> annotate
*/
workflow {
    qc_fastq(read_pairs)
    fastq_to_fasta(qc_fastq.out)
    annotate(fastq_to_fasta.out)
}