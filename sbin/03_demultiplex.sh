#!/usr/bin/env bash

# this script parses the matches from Minimap2 and demultiplex fastq file into multiple fastq files for all samples

#perl ../scripts/demultiplex.pl all.sam all.fastq /path_for_output_fastq_per_sample

my_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cat $my_dir/../test_data/all.forward.sam $my_dir/../test_data/all.reverse.sam >$my_dir/../test_data/all.sam
mkdir $my_dir/../test_data/demultiplex_fastq
perl $my_dir/../scripts/demultiplex.pl $my_dir/../test_data/all.sam $my_dir/../test_data/all.fastq.gz $my_dir/../test_data/demultiplex_fastq
