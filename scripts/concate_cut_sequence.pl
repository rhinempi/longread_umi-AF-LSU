#! /usr/bin/perl

# this script is used to concatenate cut sequences from both end of the amplicon

use strict;
use warnings;

my $file1=shift;
my $file2=shift;
my $file3=shift;
my %seq_h;
my %qual_h;

open IN,$file1;
open IN2,$file2;
open OUT,">$file3";

while (<IN>){
	chomp;
	my $head=$_;
	my $seq=<IN>;
	chomp($seq);
	my $plus=<IN>;
	chomp($plus);
	my $qual=<IN>;
	chomp($qual);

	my @array =split /\s+/,$head;
	$seq_h{$array[0]}=$seq;
	$qual_h{$array[0]}=$qual;
}

while (<IN2>){
	chomp;
	my $head =$_;
	my $seq =<IN2>;
	chomp($seq);
	my $plus=<IN2>;
	chomp($plus);
	my $qual=<IN2>;
	chomp($qual);

	my @array =split /\s+/,$head;
	if ($seq_h{$array[0]}){
		my $combine=$seq.$seq_h{$array[0]};
		my $combine_qual=$qual.$qual_h{$array[0]};
		if (length $combine >=5000){
			print STDERR"$head \t Too long\n";
		}else{
			print OUT"$head\n$combine\n$plus\n$combine_qual\n";
		}
	}else{
		print STDERR"$head \t no pairs\n";
	}
}