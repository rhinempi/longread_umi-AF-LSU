#! /usr/bin/perl
#
use strict;
use warnings;

my $file1=shift;
my $file2=shift;
my $file3=shift;
my $file4=shift;
my %forward;
my %reverseC;

if (!$file1){
        help();
}

open IN,$file1;
open IN2,$file2;
open OUT,">$file4";

my @array=split /\s+/,$file3;
my $forwardS= $array[0];
my $forwardE= $array[1];
my $reverseCS = $array[2];
my $reverseCE = $array[3];
print STDOUT"$forwardS\n$forwardE\n$reverseCS\n$reverseCE\n";

while (<IN>){
	chomp;
	my $line=$_;
	my $seq=<IN>;
	chomp($seq);
	$line=~s/^\>//;
	$forward{$line}=$seq;
}

while (<IN2>){
        chomp;
        my $line=$_;
        my $seq=<IN2>;
        chomp($seq);
        $line=~s/^\>//;
	# reverse complement
	$seq=~tr/ATCG/TAGC/;
	$seq=reverse($seq);

        $reverseC{$line}=$seq;
}

foreach my $sample(sort keys %forward){
	if ($reverseC{$sample}){
		my $forwardSize = length $forward{$sample};
		my $reverseCSize = length $reverseC{$sample};
		my $ForwardLeft = substr ($forward{$sample},0,$forwardS);
		my $ForwardRight = substr ($forward{$sample},$forwardE);
		my $ReverseCLeft = substr ($reverseC{$sample},0,$reverseCSize-$reverseCE);
		my $ReverseCRight = substr ($reverseC{$sample},$reverseCSize-$reverseCS);
		print OUT"$sample\t$ForwardLeft\t$ForwardRight\t$ReverseCLeft\t$ReverseCRight\n";
	}else{
		die("for sample $sample, the reverse barcode not found at $file2");
	}
}

sub help{
        my @list = @_;
        if (@list ==0){
		print STDOUT"
forward ---------------------------------
		f1----UMI-----f2
reverse ---------------------------------
		r1----UMI-----r2
		";
                die("perl $0 forward.barcode.fa reverse.barcode.fa \"f1 f2 r1 r2\" outfile\n");
        }
}
