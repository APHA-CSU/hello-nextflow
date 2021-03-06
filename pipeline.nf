#!/usr/bin/env nextflow

/* A WGS pipeline that illustrates how to use nextflow.

    The Input to the pipeline is a path to a directory (input_dir) that contains fq.gz read pairs. 
    The read pairs should be formatted: NAME_1.fq.gz, NAME_2.fq.gz

    The Output of the pipeline is stored in the output directory (output_dir) defined below 

    The pipeline's workflow is structured:
        (input) fastq read pair --> fastq_to_fasta --> annotate --> output txt file
                               \--> qc_fastq --> output html report
*/


/* User Config 
    The lines of codes a human would typically edit to setup their run
    Edit these lines to change what samples you are providing, and where output is saved to
*/

input_dir = "$PWD/samples/"  // Directory that contains samples
output_dir = "$PWD/output/"  // Output samples
threads = 4                  // Use to setup certain jobs

/* Setup
    Preparation before starting the pipeline
*/

// Pairs read files together, so they can passed through the pipeline together
read_pairs = Channel.fromFilePairs("$input_dir/*_{1,2}.fq.gz", flat: true)


/* Process Definitions */

// Quality control. Produces a qc report from two fastq files
process qc {
    publishDir "$output_dir/$name/"
    tag "$name"

    input:
        tuple val(name), path(read_1), path(read_2)

    output:
        path('*')

    script:
    """
        mkdir fastqc/
        mkdir multiqc/

        # Execute FastQC
        fastqc --outdir fastqc/ --threads ${threads} $read_1 $read_2

        # Execute MultiQC
        multiqc fastqc/ --outdir multiqc/
    """
}

// Clean Reads
process clean {
    publishDir "$output_dir/$name/"
    tag "$name"
    
    input:
        tuple val(name), path(read_1), path(read_2)

    output:
        tuple val(name), path("preprocessed_1.fastq.gz"), path("preprocessed_2.fastq.gz")

    script:
    """
        # Execute fastp
        fastp -i $read_1 \
            -I $read_2 -o preprocessed_1.fastq.gz \
            -O preprocessed_2.fastq.gz \
            -j fastp.json \
            -h fastp.html \
            -q 30 \
            --trim_poly_g \
            --length_required 80 \
            --thread ${threads}
    """
}

// Assemble
process assemble {    
    publishDir "$output_dir/$name/"
    tag "$name"

    input:
        tuple val(name), path(read_1), path(read_2)

    output:
        tuple val(name), path("assembly.fasta")

    script:
    """
        # Execute Unicycler
        unicycler -1 ${read_1} -2 ${read_2} -o ./ --threads ${threads}
    """
}

// Annotate
process annotate {
    publishDir "$output_dir/$name/prokka/"
    tag "$name"

    input:
        tuple val(name), path('genome.fasta')

    output:
        path('*')

    script:
    """
        # Execute Prokka
        mkdir results/
        prokka --force genome.fasta
    """
}

/* Workflow

Defines how all the steps of the pipeline connect together. 

Notice how the pipeline's workflow is structured:
    read pairs channel --> qc_fastq --> fastq_to_fasta --> annotate
*/
workflow {
    qc(read_pairs)
    clean(read_pairs)
    assemble(clean.out)
    annotate(assemble.out)
}
