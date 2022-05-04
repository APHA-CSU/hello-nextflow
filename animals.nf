#!/usr/bin/env nextflow

/* An animal pipeline to illustrate how to use nextflow.
*/

// Pairs read files together, so they can passed through the pipeline together
animals = Channel.fromPath('animals/*.txt').map {file -> tuple(file.baseName, file)}

process noise {
    input:
        val(name), path("animal.txt")

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