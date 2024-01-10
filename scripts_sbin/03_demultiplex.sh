#!/usr/bin/env bash

# this script parses the matches from Minimap2 and demultiplex fastq file into multiple fastq files for all samples

perl ../scripts/demultiplex.pl all.sam all.fastq /path_for_output_fastq_per_sample