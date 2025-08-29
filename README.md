# longread_umi-AF-LSU

This is a bioinformatics pipeline for LSU long read consensus use cases of Anaerobice fungi.

**Table of contents**
- [Installation](#installation)
- [Quick start](#quick-start)
- [Data](#data)
- [Example analysis](#example-analysis)
- [Usage](#usage)

**Citation**  

Diana, Katrin, etc. (2025 in submission). Structure and phylogenetic resolution of all ribosomal regions of Neocallimastigales.

## Installation

### Manual

1. Requirements/Dependencies  
   OS tested (Linux 3.10.0, Ubuntu 14.04, Ubuntu 16.04)
   See `./longread_umi-AF-LSU/scripts/longread_umi_version_dump.txt`
2. Clone from github in terminal  
   ```
   git clone https://github.com/rhinempi/longread_umi-AF-LSU.git
   ```
   or
   ```
   gh repo clone rhinempi/longread_umi-AF-LSU
   ```
3. Make bash scripts executable  
   ```
   find ./longread_umi-AF-LSU -name "*.sh" -exec chmod +x {} \;
   ```
4. Install dependencies  
   make sure you have the newest Conda installed:
   ```
   source ./longread_umi-AF-LSU/scripts/install_conda.sh
   ```
   To install the pipeline, run the following command
   ```
   ./longread_umi-AF-LSU/scripts/install_dependencies.sh
   ```
5. Change paths to dependencies (optional)
   Modify `./longread_umi-AF-LSU/scripts/dependencies.sh` in a texteditor, if you wish to install dependencies elsewhere.

## Quick start

### Test data
1. Test the nanopore_pipeline in terminal
   ```
   bash ./longread_umi-AF-LSU/sbin/04_longread_umi.sh
   ```
   Expected output
   - `consensus_raconx2_medakax2.fa` containing 2 UMI consensus sequences with different length

2. Reproduce the result:
   If we look into the test script: `cat ./longread_umi-AF-LSU/sbin/04_longread_umi.sh`, we see the following script content:
   ```
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
   ```
   To reproduce the results:
      1. replace `$my_dir/../test_data/adapaters.cut.txt` with correspond sample adapters. You can file all adapters in the file `./longread_umi-AF-LSU/test_data/all.adapaters.cut.txt`
      2. replace `$my_dir/../test_data/ont_r10_sample1.fastq` to each sample's fastq file

## Usage

```

-- longread_umi: pipelines and tools for longread UMI processing.

usage: longread_umi [-h] [ name ...]

where:
    -h   Show this help text.
    name Name of tool or pipeline.
    ...  Commands for tool or pipeline.

Pipelines:

   nanopore_pipeline   Generate UMI consensus sequences from Nanopore data
   pacbio_pipeline     Generates UMI consensus sequences from PacBio CCS data.
   qc_pipeline         UMI consensus data statistics and compare to references

Tools:

   consensus_racon          Generate UMI consensus sequence with racon
   demultiplex              Dual barcode demultiplexing
   demultiplex_3end         3'-end dual barcode demultiplexing
   nanopore_settings_test   Test impact of polishing rounds on UMI consensus.
   polish_medaka            Nanopore UMI consensus polishing with Medaka
   primer_position          Locate adapter and primer positions in read data
   trim_amplicon            Trimming sequences based on primers
   umi_binning              Longread UMI detection and read binning.
   variants                 Phase and call variants from UMI consensus sequences.

For help with a specific tool or pipeline:
longread_umi <name> -h
```

  

```

-- longread_umi consensus_racon: Generate UMI consensus sequence with racon
   Raw read centroid found with usearch and used as seed for
   (r) x times racon polishing.

usage: consensus_racon [-h] (-d dir -o dir -r value -t value -n file) 

where:
    -h  Show this help text.
    -d  Directory containing UMI read bins in the format
        'umi*bins.fastq'. Recursive search.
    -o  Output directory.
    -r  Number of racon polishing rounds.
    -t  Number of threads to use.
    -n  Process n number of bins. If not defined all bins
        are processed.
```

  

```

-- longread_umi demultiplex: Dual barcode demultiplexing

   Script for demultiplexing UMI consensus sequences based on 
   custom barcodes. The script demultiplexes raw read data
   and assigns the consensus sequences to a sample by majority vote
   of the raw read assignments. Post processing demultiplxing optimizes 
   consensus yield. The script expects dual barcodes in a barcode file.
   If the same barcode is used in both ends simply repeat barcode.

usage: demultiplex [-h] (-c file -r file -u file -o dir -b file)
(-p string -n range -t value) 

where:
    -h  Show this help text.
    -c  UMI consensus sequences that need demultiplexing.
    -r  Raw read sequences that were used to generate
        the consensus sequences.
    -u  List of raw read names and UMI bin assignments.
    -o  Output directory.
    -b  File containing barcodes. 
        [Default = longread_umi/scripts/barcodes.tsv].
    -p  Barcode name prefix [Default = 'barcode'].
    -n  Barcode numbers used. [Default  = '1-120'].
    -t  Number of threads used.
```

  

```

-- longread_umi demultiplex_3end: 3'-end dual barcode demultiplexing

    Script for demultiplexing UMI consensus sequences based on 
    custom barcodes. The script demultiplexes raw read data
    and assigns the consensus sequences to a sample by majority vote
    of the raw read assignments. Post processing demultiplxing optimizes 
    consensus yield. The script expects dual barcodes in a barcode file.
    If the same barcode is used in both ends simply repeat barcode. This
    version of the script only looks for barcodes in the 3' end. This demultiplexing
    is for data types which are truncated in the 5' end. Dual barcoding is
    still used.
	
usage: demultiplex_3end [-h] (-c file -r file -u file -o dir -b file -p string)
(-n range -m value -t value) 

where:
    -h  Show this help text.
    -c  UMI consensus sequences that need demultiplexing.
    -r  Raw read sequences that were used to generate
        the consensus sequences.
    -u  List of raw read names and UMI bin assignments.
    -o  Output directory.
    -b  File containing barcodes.
        Default is longread_umi/scripts/barcodes.tsv
    -p  Barcode name prefix. [Default = 'barcode'].
    -n  Barcode numbers used. [Default = '1-120'].
    -m  Minimum number of barcodes found to demultiplex
        sequences. Default 2.
    -t  Number of threads used.
```

  

```

-- longread_umi nanopore_pipeline: Generate UMI consensus sequences from Nanopore data
   
usage: nanopore_pipeline [-h] [-w string] (-d file -v value -o dir -s value) 
(-e value -m value -M value -f string -F string -r string -R string )
( -c value -p value -n value -u dir -t value -T value ) 

where:
    -h  Show this help text.
    -d  Single file containing raw Nanopore data in fastq format.
    -v  Minimum read coverage for using UMI consensus sequences for 
        variant calling.
    -o  Output directory.
    -s  Check start of read up to s bp for UMIs.
    -e  Check end of read up to f bp for UMIs.
    -m  Minimum read length.
    -M  Maximum read length.
    -f  Forward adaptor sequence. 
    -F  Forward primer sequence.
    -r  Reverse adaptor sequence.
    -R  Reverse primer sequence.
    -c  Number of iterative rounds of consensus calling with Racon.
    -p  Number of iterative rounds of consensus calling with Medaka.
    -q  Medaka model used for polishing. r941_min_high, r10_min_high etc.
    -w  Use predefined workflow with settings for s, e, m, M, f, F, r, R.
        rrna_operon [70, 80, 3500, 6000, CAAGCAGAAGACGGCATACGAGAT,
        AGRGTTYGATYMTGGCTCAG, AATGATACGGCGACCACCGAGATC, CGACATCGAGGTGCCAAAC]
        Overwrites other input.
    -n  Process n number of bins. If not defined all bins are processed.
        Pratical for testing large datasets.
    -u  Directory with UMI binned reads.
    -t  Number of threads to use.
    -T  Number of medaka jobs to start. Threads pr. job is threads/jobs.
        [Default = 1].
```

  

```

-- longread_umi nanopore_settings_test: Test impact of polishing rounds on UMI consensus.

usage: nanopore_settings_test [-h] (-d file -n value -c value -o dir -s value -e value) 
(-m value -M value -f string -F string -r string -R string -t value -T value) 
(-x value -y value -q string -p -u dir ) 

where:
    -h  Show this help text.
    -d  Single file containing raw Nanopore data in fastq format.
    -o  Output directory.
    -s  Check start of read up to s bp for UMIs.
    -e  Check end of read up to f bp for UMIs.
    -m  Minimum read length.
    -M  Maximum read length.
    -f  Forward adaptor sequence. 
    -F  Forward primer sequence.
    -r  Reverse adaptor sequence.
    -R  Reverse primer sequence.
    -n  Process n number of bins. If not defined all bins are processed.
        Pratical for testing large datasets.
    -w  Use predefined workflow with settings for s, e, m, M, f, F, r, R.
        rrna_operon [70, 80, 3500, 6000, CAAGCAGAAGACGGCATACGAGAT,
        AGRGTTYGATYMTGGCTCAG, AATGATACGGCGACCACCGAGATC, CGACATCGAGGTGCCAAAC]
    -t  Number of threads to use.
    -T  Number of medaka jobs to start. Threads pr. job is threads/jobs.
        [Default = 1].
    -x  Test Racon consensus rounds from 1 to <value>.
    -y  Test Medaka polishing rounds from 1 to <value>.
    -q  Medaka model used for polishing. r941_min_high, r10_min_high etc.
    -p  Flag to disable Nanopore trimming and filtering.
    -u  Directory with UMI binned reads.

Test run:
longread_umi nanopore_settings_test 
  -d test_reads.fq 
  -o settings_test 
  -w rrna_operon 
  -t 100 
  -T 20 
  -x 4 
  -y 3 
  -n 1000
```

  

```

-- longread_umi pacbio_pipeline: Generates UMI consensus sequences from PacBio CCS data.
   
usage: pacbio_pipeline [-h] (-d file -v value -o dir -s value -e value) 
(-m value -M value -f string -F string -r string -R string -c value -w string)
(-n value -u dir -t value) 

where:
    -h  Show this help text.
    -d  Single file containing PacBio CCS read data in fastq format.
    -v  Minimum read coverage for using UMI consensus sequences for 
        variant calling.
    -o  Output directory.
    -s  Check start of read up to s bp for UMIs.
    -e  Check end of read up to f bp for UMIs.
    -m  Minimum read length.
    -M  Maximum read length.
    -f  Forward adaptor sequence. 
    -F  Forward primer sequence.
    -r  Reverse adaptor sequence.
    -R  Reverse primer sequence.
    -c  Number of iterative rounds of consensus calling with Racon.
    -w  Use predefined workflow with settings for s, e, m, M, f, F, r, R, c.
        rrna_operon [70, 80, 3500, 6000, CAAGCAGAAGACGGCATACGAGAT,
        AGRGTTYGATYMTGGCTCAG, AATGATACGGCGACCACCGAGATC, CGACATCGAGGTGCCAAAC, 2]
    -n  Process n number of bins. If not defined all bins are processed.
        Pratical for testing large datasets.
    -u  Directory with UMI binned reads.
    -t  Number of threads to use.
```

  

```

-- longread_umi polish_medaka: Nanopore UMI consensus polishing with Medaka
   
usage: polish_medaka [-h] [-l value T value] 
(-c file -m string -d dir -o dir -t value -n file -T value)

where:
    -h  Show this help text.
    -c  File containing consensus sequences.
    -m  Medaka model.
    -l  Expected minimum chunk size. [Default = 6000]
    -d  Directory containing UMI read bins in the format
        'umi*bins.fastq'. Recursive search.
    -o  Output directory.
    -t  Number of threads to use.
    -n  Process n number of bins. If not defined all bins
        are processed.
    -t  Number of Medaka jobs to run. [Default = 1].
```

  

```

-- longread_umi primer_position: Locate adapter and primer positions in read data
    Script for checking position of adapters and gene specific primers flanking
    UMI sequences in read terminals. Relevant if using custom UMI adapters/primers,
    sample barcoding or if basecalling/processing truncates reads.
   
usage: primer_position [-h] [-e value -n value ] (-d value -o dir -t value)
(-f string -F string -r string -R string ) 

where:
    -h  Show this help text.
    -d  Raw fastq reads.
    -o  Output directory
    -t  Number of threads to use.
    -f  Forward adaptor sequence. 
    -F  Forward primer sequence.
    -r  Reverse adaptor sequence.
    -R  Reverse primer sequence.
    -e  Length of terminal end to search for primers. [Default = 500]
    -n  Subset reads before search. [Default = 100000]
```

  

```

-- longread_umi qc_pipeline: UMI consensus data statistics and compare to references
   Calculates data statistics (UMI bins size, UMI cluster size, yield, read length etc.).
   Mapping of read data and UMI consensus sequences to reference sequences to allow for 
   error profiling. Detects chimeras using uchime2_ref. Detects contamination by
   comparing mapping results to known references and the SILVA database - only works
   if reference database contains all expected sequences. Alternatively, use variants.fa
   as reference database.
   
usage: qc_pipeline [-h] (-d files -c files -r files -s file -u dir -o dir -t value) 

where:
    -h  Show this help text.
    -d  List of read files seperated by ';'
        i.e. 'reads.fq;trim/reads_tf.fq'
        First read file used for read classification. 'reads_tf.fq' recommended.
    -c  List of consensus files seperated by ';'
        i.e. 'consensus_medaka_medaka.fa;racon/consensus_racon.fa'
        First consensus file used for comparison to alternative refs
        and for chimera checking. Subsequent consensus sequences only mapped to
        first reference.
    -r  List of reference files seperated by ';'.
        First reference is used for all mappings. Subsequent references
        only used for mapping first consensus file.
        'zymo_curated' refers to:
        longread_umi/scripts/zymo-ref-uniq_2019-10-28.fa
        'zymo_vendor' refers to:
        longread_umi/scripts/zymo-ref-uniq_vendor.fa
    -s  SILVA reference database in fasta format used for detecting contamination.
    -u  UMI consensus output folder.
    -o  Output folder. Default 'qc'.
    -t  Number of threads to use.

Example of SILVA database download:
wget https://www.arb-silva.de/fileadmin/silva_databases/
release_132/Exports/SILVA_132_SSURef_Nr99_tax_silva.fasta.gz
gunzip SILVA_132_SSURef_Nr99_tax_silva.fasta.gz
```

  

```

-- longread_umi trim_amplicon: Trimming sequences based on primers
   
usage: trim_amplicon [-h] (-d dir(s) -p string(s) -o dir )
(-F string -R string -m value -M value -t value -l dir) 

where:
    -h  Show this help text.
    -d  Directory to look for sequence files using pattern (-p).
        Mutliple directories can be seperated by ';'.
    -p  File pattern(s) to look for. Multiple patterns
        can be separared by ';' and flanked by '"..."'.
    -o  Output directory.
    -F  Forward primer sequence.
    -R  Reverse primer sequence.
    -m  Minimum read length.
    -M  Maximum read length.
    -t  Number of threads to use.
    -l  Log directory
```

  

```

-- longread_umi umi_binning: Longread UMI detection and read binning.
   Tool requires UMIs in both ends of the read flanked by defined
   adaptor regions.

usage: umi_binning [-h] (-d file -o dir -m value -M value )
(-s value -e value -f string -F string -r string -R string -p )
(-u value -U value -O value -S value -t value) 

where:
    -h  Show this help text.
    -d  Reads in fastq format.
    -o  Output directory.
    -m  Minimum read length.
    -M  Maximum read length.
    -s  Check start of read up to s bp for UMIs.
    -e  Check end of read up to f bp for UMIs.
    -f  Forward adaptor sequence. 
    -F  Forward primer sequence.
    -r  Reverse adaptor sequence.
    -R  Reverse primer sequence.
    -p  Flag to disable Nanopore trimming and filtering.
        Use with PacBio reads.
    -u  Discard bins with a mean UMI match error above u.
    -U  Discard bins with a UMI match error standard
        deviation above U.
    -O  Normalize read orientation fraction to 'O' if < 'O' reads are
        either +/- strand orientation.
    -N  Max number of reads with +/- orientation. [Default = 10000]
    -S  UMI bin size/UMI cluster size cutoff. [Default = 10]
    -t  Number of threads to use.
```

  

```

-- longread_umi variants: Phase and call variants from UMI consensus sequences.
   This is a naive variant caller, which phases UMI consensus sequences
   based on SNPs and calls a variant with >=3x coverage. Reads are initially 
   grouped by read clustering at 99.5% identity and a centroid sequence is picked.
   The centroid sequence is used as a mapping reference for all reads in the cluster
   to detect SNPs for phasing and variant calling. Before read clustering homopolymers
   are masked and then reintroduced before variant calling.
   
usage: variants [-h -b] (-c file -o dir -t value ) 

where:
    -h  Show this help text.
    -c  UMI consensus file.
    -o  Output directory.
    -t  Number of threads to use. [Default = 1]
    -b  Debug flag. Keep temp files. [Default = NO]
```


## License
[GNU General Public License, version 3](LICENSE)
