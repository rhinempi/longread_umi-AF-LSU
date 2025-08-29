#! /usr/bin/perl
#
use strict;
use warnings;

my $file1=shift;
my $file2=shift;
my %hash;

open IN,$file1;
open OUT,">$file2";

while (<IN>){
	chomp;
	my $head=$_;
	my $seq=<IN>;
	chomp($seq);
	#	my $plus=<IN>;
	#my $qual=<IN>;

	my $length = length $seq;
	$hash{$length}++;
}

for (my $i=1500; $i<10000; $i++){
	if ($hash{$i}){
		print OUT"$i\t$hash{$i}\n";
	}else{
		print OUT"$i\t0\n";
	}
}


#foreach my $key (sort {$a<=>$b} keys %hash){
#	print OUT"$key\t$hash{$key}\n";
#}
