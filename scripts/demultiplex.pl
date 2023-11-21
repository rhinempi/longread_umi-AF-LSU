#! /usr/bin/perl
#
use strict;
use warnings;

my $file1=shift;  # alignment sam
my $file2=shift;  # all fastq
my $file3=shift;  # output directory
my %strand;
my %left;
my %right;
my %loci;
my %identity;

if (!$file1){
        help();
}

open IN,$file1;

# reads mapping file and assign the best matched read to barcodes
while (<IN>){
	chomp;
	my $line=$_;
	my @array =split /\t/,$line;
	next if ($array[1]<1000);
	if ($strand{$array[5]}{$array[0]}){
		if ($strand{$array[5]}{$array[0]} eq $array[4]){
			if ($loci{$array[5]}{$array[0]}==$array[2] || $loci{$array[5]}{$array[0]} == $array[3]){
				next;
			}

			my $identity_score;
			if ($identity{$array[0]}){
				$identity_score=$array[9]/$array[6];
				if (abs($identity_score - $identity{$array[0]})<0.05){
						delete $identity{$array[0]};
						next;
				}
				next if $identity_score <=$identity{$array[0]};
			}

			if ($array[2]<=800){
				$left{$array[5]}{$array[0]}=$array[2];
				$right{$array[5]}{$array[0]}=$loci{$array[5]}{$array[0]};
				$identity_score=$array[9]/$array[6];
				$identity{$array[0]}=$identity_score;
			}else {
				$right{$array[5]}{$array[0]}=$array[3];
				$left{$array[5]}{$array[0]}=$loci{$array[5]}{$array[0]};
				$identity_score=$array[9]/$array[6];
                                $identity{$array[0]}=$identity_score;
			}
		}
	}else{
		$strand{$array[5]}{$array[0]}=$array[4];
		if ($array[2]<800){
			$loci{$array[5]}{$array[0]}=$array[2];
		}else{
			$loci{$array[5]}{$array[0]}=$array[3];
		}
	}
}

# reads all sequencing data and send the reads to each sample
foreach my $sample(sort keys %left){
	open OUT,">$file3/$sample.fastq";
	if ($file2=~/gz$/){
                open IN2,"gunzip -dc $file2|";
        }else{
                open IN2,$file2;
        }
	#	open IN2,$file2;
	while (<IN2>){
		chomp;
		my $header=$_;
		my $seq=<IN2>;
		chomp($seq);
		my $plus=<IN2>;
		chomp($plus);
		my $qual=<IN2>;
		chomp($qual);
		my @array=split /\s+/,$header;
		$array[0]=~s/^\@//;
		next unless ($identity{$array[0]});
		if ($left{$sample}{$array[0]}){
			my $left_start=$left{$sample}{$array[0]};
			my $sub_len=$right{$sample}{$array[0]}-$left{$sample}{$array[0]}+1;
			$seq = substr ($seq,$left_start-1,$sub_len);
			$qual = substr ($qual,$left_start-1,$sub_len);
			print OUT"$header\n$seq\n$plus\n$qual\n";
		}
	}
	close OUT;
	close IN2;
}

sub help{
        my @list = @_;
        if (@list ==0){
                die("\nperl demultiplex.pl combined.sam all.fastq output\n\tThen you will get a list of fastq files in the output directory\n");
        }
}
