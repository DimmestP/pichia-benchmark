#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Align a genome with ariba
process flye {
    publishDir "${params.results_dir}/flye", mode: 'copy'


    input:
    path(ONT_fastq)


    output:
    path "flye_assembly_*"
    path "flye_graph_*"
    path "flye_info_*"

    shell:
    '''
    source activate flye
    sample_name=$(basename !{ONT_fastq} .fastq.gz)
    flye --nano-hq  !{ONT_fastq} -g 15m -o ./results -t !{params.NCPUS} -i 3
    mv results/assembly.fasta flye_assembly_${sample_name}.fasta
    mv results/assembly_graph.gfa flye_graph_${sample_name}.gfa
    mv results/assembly_info.txt  flye_info_${sample_name}.txt

    '''
}
