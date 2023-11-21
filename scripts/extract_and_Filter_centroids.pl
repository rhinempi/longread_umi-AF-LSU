#! /usr/bin/perl
#
use strict;
use warnings;

my $file1=shift;
my $file2=shift;
my $mark=0;
my $number=-1;

open IN,$file1;

while (<IN>){
	chomp;
	my $line=$_;
	if ($line=~/^\>/){
		$line=~/size=(\d+)/;
		my $size=$1;
		if ($size>10){
			$mark=1;
		}else{
			$mark=0;
		}

		if ($mark==1){
			$number++;
			open OUT,">$file2/$number\_centroid.fa";
			print OUT"$line\n";
		}
	}else{
		if ($mark==1){
			print OUT"$line\n";
		}
	}
}
