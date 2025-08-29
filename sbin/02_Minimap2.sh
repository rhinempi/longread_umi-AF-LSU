#!/usr/bin/env bash

# step 2, map all reads to forward and reverse barcode
# all.fastq represents un-de-multiplexed sequencing data
# -N options gives the number of best matches that should match the number of primers in forward.barcode.fa file

my_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
minimap2 $my_dir/../test_data/forward.barcode.fa $my_dir/../test_data/all.fastq.gz -t 20  -k7 -A1 -m42 -w1 -N8  >$my_dir/../test_data/all.forward.sam &
minimap2 $my_dir/../test_data/reverse.barcode.fa $my_dir/../test_data/all.fastq.gz -t 20  -k7 -A1 -m42 -w1 -N8  >$my_dir/../test_data/all.reverse.sam &
