#! /bin/bash

# this step is only necessary if you have a amplicon that needs to connect the end to the front (for our case, it is the FUN region)

left=$1;  # left side primer sequence
right=$2; # right side primer sequence
input=$3; # input sequencing data to be cut
output=$4; # output cut target region sequence

cutadapt -j 20 -e 0.2 --rc --discard-untrimmed -g $left --action retain -o $output.left $input
cutadapt -j 20 -e 0.2 --rc --discard-untrimmed -a $right --action retain -o $output.right $input

my_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
perl $my_dir/../scripts/concate_cut_sequence.pl $output.right $output.left $output  # concate_cut_sequence.pl is the script to combine cut sequences from two sides
