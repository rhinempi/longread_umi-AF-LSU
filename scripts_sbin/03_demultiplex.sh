#!/usr/bin/env bash

# this script parses the matches from Minimap2 and demultiplex fastq file into multiple fastq files for all samples

#perl ../scripts/demultiplex.pl all.sam all.fastq /path_for_output_fastq_per_sample
cat all.forward.sam all.reverse.sam >all.sam
mkdir demultiplex_fastq
perl ../scripts/demultiplex.pl all.sam all.fastq.gz demultiplex_fastq
