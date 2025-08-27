#!/usr/bin/env bash

# this script reads forward and reverse barcodes and cut out a list of input sequences for the longread_umi pipeline
# to identify beginning and ending of the amplicon sequences.


# forward.barcode.fa  is a list of forward barcodes ~ 48nt
# reverse.barcode.fa  is a list of reverse barcodes ~ 51nt
# f1 is the starting position fo the umi on the forward barcode
# f2 is the ending position of the umi on the forward barcode
# r1 is the starting position of the umi on the reverse barcode
# r2 is the ending position of the umi on the reverse barcode

# adapters.cut.txt will be used in step 04 for the longread_umi pipeline

#perl ../scripts/cut_18ntUmi.pl forward.barcode.fa reverse.barcode.fa "f1 f2 r1 r2" adapaters.cut.txt
perl ../scripts/cut_18ntUmi.pl forward.barcode.fa reverse.barcode.fa "13 31 19 37" adapaters.cut.txt
