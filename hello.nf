#!/usr/bin/env nextflow

/* A minimal pipeline to illustrate how to use nextflow.

    The Input to the pipeline is a path to a directory (input_dir) that contains fastq.gz read pairs. 
    The read pairs should be formatted: NAME_1.fastq.gz, NAME_2.fastq.gz

    The Output of the pipeline is stored in the output directory (output_dir) defined below 

    The pipeline's workflow is structured:
        (input) fastq read pair --> qc_fastq --> fastq_to_fasta --> annotate --> (ouput) txt file
*/

// Channels store queues of data
// This channel locates .txt files
filenames = Channel.fromPath('hello/*.txt')

// A process is a template for stting up and running a script
process names {
    // Input is a string that represents the path
    input:
        val(name)

    // Output is what the process would normally print to the terminal
    output:
        stdout

    // This scripts prints the $name of the input
    script:
    """
        echo Name: $name
    """
}

// The workflow defines how channels connect to processes
workflow{
    // Plug the animals channel into the names process and view the output
    names(filenames) | view
}