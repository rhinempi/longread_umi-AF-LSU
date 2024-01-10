#!/usr/bin/env bash

# step 2, map all reads to forward and reverse barcode
# all.fastq represents un-de-multiplexed sequencing data
# -N options gives the number of best matches that should match the number of primers in forward.barcode.fa file

minimap2 forward.barcode.fa all.fastq -t 20  -k7 -A1 -m42 -w1 -N8  >all.forward.sam &
minimap2 reverse.barcode.fa all.fastq -t 20  -k7 -A1 -m42 -w1 -N8  >all.reverse.sam &