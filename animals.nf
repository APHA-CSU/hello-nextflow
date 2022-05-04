#!/usr/bin/env nextflow

/* A minimal pipeline to illustrate how to use nextflow.

    The Input to the pipeline is a path to a directory (input_dir) that contains fastq.gz read pairs. 
    The read pairs should be formatted: NAME_1.fastq.gz, NAME_2.fastq.gz

    The Output of the pipeline is stored in the output directory (output_dir) defined below 

    The pipeline's workflow is structured:
        (input) fastq read pair --> qc_fastq --> fastq_to_fasta --> annotate --> (ouput) txt file
*/

// Pairs read files together, so they can passed through the pipeline together
animals = Channel.fromPath('animals/*.txt').view()

process names {
    input:
        val(name)

    output:
        stdout

    script:
    """
        echo Name: $name
    """
}

workflow{
    names(animals)
}