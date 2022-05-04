#!/usr/bin/env nextflow

/* A minimal pipeline to illustrate how to use nextflow. */

// Channels store queues of data
// This channel locates .txt files
filenames = Channel.fromPath('hello/*.txt')

// A process is a template for stting up and running a script
process names {
    // Save data from the output: section
    publishDir 'hello-output/'

    // Input is a string that represents the path
    input:
        val(name)

    // Output is what the process would normally print to the terminal
    output:
        path('output_file.txt')

    // This scripts prints the $name of the input
    script:
    """
        echo "Processing the $name file" > output_file.txt
    """
}

// The workflow defines how channels connect to processes
workflow{
    // Plug the animals channel into the names process and view the output
    names(filenames)
}