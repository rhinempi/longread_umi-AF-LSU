#! /usr/bin/perl
#
use strict;
use warnings;

my $file1=shift;
my $file2=shift;
my $head;
my $seq;
my $number=0;

open IN,$file1;
open OUT,">$file2";

while (<IN>){
	chomp;
	my $line=$_;
	if ($line=~/^\>/){
		if ($number==0){
			$number++;
			$head=$line;
			next;
		}
		my $length=length $seq;
	        my $qual = "H" x $length;
	        $head=~s/^\>//;
        	print OUT"\@$head\n$seq\n+\n$qual\n";
	        $seq="";
        	$number++;
		$head=$line;
	}else{
		$seq.=$line;
		next;
	}

}

my $length=length $seq;
       my $qual = "H" x $length;
        $head=~s/^\>//;
        print OUT"\@$head\n$seq\n+\n$qual\n";
	
if ($number<10){
	`rm $file2`;
}
