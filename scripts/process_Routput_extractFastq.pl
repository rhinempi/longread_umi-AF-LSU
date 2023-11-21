#! /usr/bin/perl
#
use strict;
use warnings;

my $file1=shift;
my $file2=shift;
my $file3=shift;
my $cluster=0;
my %hash;
my %hash2;

open IN,$file1;

while (<IN>){
	chomp;
	my $line=$_;
	my @array =split /\s+/,$line;
	next unless $array[1]=~/^\d+/;

	my $small= $array[1]-$array[3];
	if ($small<=0){
		$small=0;
	}
	my $big = $array[1]+$array[3];

	$hash2{$cluster}=1;
	for (my $i=int($small); $i<=int($big); $i++){
		$hash{$i}=$cluster;
	}
	$cluster++;
}

foreach my $clusterN (sort keys %hash2){
	open OUT,">$file3\_$clusterN.fq";
	open IN2,$file2;
	my $number=0;
	while (<IN2>){
		chomp;
		my $line=$_;
		my $seq=<IN2>;
		chomp($seq);
		my $plus=<IN2>;
		chomp($plus);
		my $qual=<IN2>;
		chomp($qual);

		my $length = length ($seq);

		if (exists $hash{$length}){
			if ($hash{$length} == $clusterN){
				$number++;
				print OUT"$line\n$seq\n$plus\n$qual\n";
			}
		}

	}
	close IN2;
	if ($number<10){
		`rm $file3\_$clusterN.fq`;
	}
	close OUT;
}
