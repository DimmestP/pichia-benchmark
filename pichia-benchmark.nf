#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// All of the default parameters are being set in `nextflow.config`

// Import modules
include { flye } from './modules/flye'

// Function which prints help message text
def helpMessage() {
    log.info"""
Usage:

nextflow run pichia-benchmark.nf --offline <ARGUMENTS>

Required Arguments:

  Input Data:
  --illumina_fastq_folder                   Folder containing reads with file name *.fastq.gz
  --ONT_fastq_folder                   Folder containing reads with file name *.fastq.gz 

  Output Location:
  --results_dir                 Folder for output files"""

}

params.all = true
params.flye = false
params.help = false

// Main workflow
workflow {

    // Show help message if the user specifies the --help flag at runtime
    // or if any required params are not provided
    if ( params.help || params.results_dir == false || params.ONT_fastq_folder == false ){
        // Invoke the function above which prints the help message
        helpMessage()
        // Exit out and do not run anything else
        exit 1
    }

//    if ( params.illumina_fastq_folder ){

        // Make a channel with the input FASTQ read pairs from the --fastq_folder
        // After calling `fromFilePairs`, the structure must be changed from
        // [specimen, [R1, R2]]
        // to
        // [specimen, R1, R2]
        // with the map{} expression

        // Define the pattern which will be used to find the FASTQ files
//        fastq_pattern = "${params.illumina_fastq_folder}/*_R{1,2}.fastq.gz"

        // Set up a channel from the pairs of files found with that pattern
//        illumina_fastq_ch = Channel
//            .fromFilePairs(fastq_pattern)
//            .ifEmpty { error "No files found matching the pattern ${fastq_pattern}" }
//            .map{
//                [it[0], it[1][0], it[1][1]]
//            }

//    }

    if (params.ONT_fastq_folder){
        ONT_fastq_ch = Channel.fromPath("${params.ONT_fastq_folder}/*.fastq.gz")
    }

   if(params.all || params.flye){
        flye(
           ONT_fastq_ch
        )
    // output:
    //     path(groot_report_<sample_name>.tsv)
    //     path(groot_<sample_name>.tsv)
    }

}
