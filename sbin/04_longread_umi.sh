#!/usr/bin/env bash

# once you have a list of adaptors for all samples, you can run the longread_umi pipeline for each sample
# using the following loops

# adapaters.cut.txt is the file for a list of cut adapters for all samples

my_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cat $my_dir/../test_data/adapaters.cut.txt | \
while read line ;
do var1=$(echo $line | cut -f1 -d' ');
var2=$(echo $line | cut -f2 -d' ') ;
var3=$(echo $line | cut -f3 -d' ');
var4=$(echo $line | cut -f4 -d' ');
var5=$(echo $line | cut -f5 -d' ');
longread_umi nanopore_pipeline \
  -d $my_dir/../test_data/ont_r10_sample1.fastq \
  -o $my_dir/../test_data/ont_r10_sample1.out \
  -v 5 \
  -q r10_min_high_g340 \
  -m 1500 \
  -M 18000 \
  -s 90 \
  -e 90 \
  -f $var2 \
  -F $var3 \
  -r $var4 \
  -R $var5 \
  -c 2 \
  -p 2 \
  -t 1 ;
done &
