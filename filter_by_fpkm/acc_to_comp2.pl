#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# modification of acc_to_comp.pl to read in tab-delimited files extracted from Herve's output files
# reads in tab-delimited sequence pairs (putative contaminants) and translates acc number (HP) to comp (trinity)

# november 2014:
# caution!! parse_trees_cc_lf.pl creates redundant lines in the output (due to multiple human seqs)
# this needs to be fixed. In the meantime, get unique lines in lungfish_cross_contam?.txt using bash
# grep Poss lf_cross_contam\?.txt | cut -d'@' -f1,2,3 | uniq 
# this will produce 5216 unique combinations of Nfor and Lpar, compared to the original file with duplicated lines >19000


my $usage = "acc_to_comp2.pl my_species.pairs list/list-AC-neofor list/list-AC-leppar > out\n";
my $infile = $ARGV[0] or die $usage;
my $list1 = $ARGV[1] or die $usage;
my $list2 = $ARGV[2] or die $usage;

# read-in (chomp) putatively contaminated genes from file 1 and store compXXX + fpkm in hash with keys = i (1...n) where n=number of lines

open (IN1, "<", $infile);

my %acc;
my $count=0;

# read infile containing info of possible contaminants
while(my $line1 = <IN1>){
    chomp $line1;
#    if ($line1 =~ /Possible.+/g ) {
    $count++;
#    my ( $sp1, $sp2 ) = split $line1;
    my @lines1 = split ( "\t", $line1 );
    my $sp1 = $lines1[0];
    my $sp2 = $lines1[1];
#    $lines1[1] =~ /(Lpar\d+)/g;
#    my $sp1 = $1;
#    $lines1[2] =~ /(Nfor\d+)/g;
#    my $sp2 = $1;
     $acc{$count}=[ $sp1, $sp2 ];
}

#print Dumper \%acc, "\n";

# get ALL acc-comp pairs from both Lepi and Neoc list files
# stored in a hash, returned as reference

my $acc_to_comp1 = acc_to_comp($list1);
my $acc_to_comp2 = acc_to_comp($list2);

# de-reference output from subroutine to a hash
my %acc_to_comp1 = %{ $acc_to_comp1 };
my %acc_to_comp2 = %{ $acc_to_comp2 };

#print Dumper \$acc_to_comp1;
#print Dumper \$acc_to_comp2;

# intersect %acc (pairs of putatively crosss-contminated sequences) with %$acc_to_compX (correspondence between acc and comp) and store everything in %comp

my %comp;

# structure of %comp

#'num' => [0  1  2  3] corresponding to (1) Neoc acc (2) comp (3) Lepid acc (4) comp

foreach my $num (sort keys %acc) {
    # get values (comp) for both species
    # first, filter out those that are not present in %acc_to_comp
     if (exists $acc_to_comp1{$acc{$num}[0]} && $acc_to_comp2{$acc{$num}[1]}) {
	# this will print acc-comp pairs for Neoc sequences involved in cross-contam
	#print $acc{$num}[0], "\t", $acc_to_comp1{$acc{$num}[0]}, "\n";
	# populate %comp with acc and comp for Neoc
        $comp{$num}[0] = $acc{$num}[0];
	$comp{$num}[1] = $acc_to_comp1{$acc{$num}[0]};
        $comp{$num}[2] = $acc{$num}[1];
	$comp{$num}[3] = $acc_to_comp2{$acc{$num}[1]};
    }
}

#print Dumper \%comp;

# print pairs of contaminants (only comps!)

print "#putatively cross-contaminated sequences (trinity ids)\n", 
      "#species 1\tspecies 2\n";

foreach my $key (keys %comp) {
    # print comp for Neoc (elem 2) and Lepid (elem 4)
    print $comp{$key}[1], "\t", $comp{$key}[3], "\n";
}

# subroutine to save accession comp pairs in a hash for each acc-comp files

sub acc_to_comp {
    # get infile (acc-to-comp correspondence file) and open
    my $list = shift;
    open (IN2, "<", $list) or die "Cannot open $list: $!\n";
    my %acc_to_comp;
    while(my $line2 = <IN2>){
	chomp $line2;
	my @lines2 = split (/\s/, $line2);
	# get accession names from fasta header stuff
	my $comp = $lines2[2];
	$lines2[0] =~ />gnl\|est\|(\S+)/;
	my $accession = $1;
	$acc_to_comp{$accession} = $comp;
    }
    #print Dumper \%acc_to_comp;
    return \%acc_to_comp;
}


__END__
#print "\n####### ARRAY ######\n";

#print Dumper \%acc, "\n";


foreach my $key (sort {$a <=> $b} keys %acc) {
	# comps will be printed in this order, 
	# very important to get the fpkm value from correct file in cross-contam_trees_to_fpkm.pl
	# comp(Neoc)	comp(Lepi)
	print "$acc{$key}[0]\t$acc{$key}[1]\n";
}

__END__

# structure of @line array

$VAR1 = [
          '	Possible cross-contamination between: Neoc',
          'Nfor135711.E.lc and Lepi',
          'Lpar138688.E.lc They are sister taxa!'
        ];
