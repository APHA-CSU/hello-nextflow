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
threads = 4

// Pairs read files together, so they can passed through the pipeline together
read_pairs = Channel.fromFilePairs( "$input_dir/*_{1,2}.fq.gz", flat: true )

// Quality control. Produces two fastq files from two fastq files, representing the read pair
process qc {
    
    input:
        tuple val(name), path(read_1_path), path(read_2_path)

    output:
        tuple val(name), path("output_1.fastq.gz"), path("output_2.fastq.gz")

    script:
    """
        mkdir fastqc/
        mkdir multiqc/

        # Execute FastQC
        fastqc --outdir fastqc/ --threads ${threads} $read_1_path $read_2_path

        # Execute MultiQC
        multiqc fastqc/ --outdir multiqc/
    """
}

// Fastp
process preprocess {
    
    input:
        tuple val(name), path(read_1), path(read_2)

    output:
        tuple val(name), path("preprocessed_read_1.fastq.gz"), path("preprocessed_read_2.fastq.gz")

    script:
    """
        # Execute fastp
        fastp -i $read_1 \
            -I $read_2 -o preprocessed_read_1.fastq.gz \
            -O preprocessed_read_2.fastq.gz \
            -j fastp.json \
            -h fastp.html \
            -q 30 \
            --trim_poly_g \
            --length_required 80 \
            --thread ${threads}
    """
}



/* The workflow defines how all the steps of the pipeline connect together. 

Notice how the pipeline's workflow is structured:
    read pairs channel --> qc_fastq --> fastq_to_fasta --> annotate
*/
workflow {
    preprocess(read_pairs)
}