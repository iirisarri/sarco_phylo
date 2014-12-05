#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

# Iker Irisarri, December 2014
# modification of comp_to_expression.pl to deal with tab-delimited input that will contain:
# comp (sp1) \t comp (sp2)
# where sp1 and sp2 are the species involved in the cross-contamination, and their corresponding rsem files should be given in order

# comp_to_expression.pl will get different expression values (default fpkm) for pairs of sequences that come from different species but are putative cross-contaminations, and will print ordered value pairs (smaller to larger) in two columns

# requires: (1) infile with pairs of gene names (tab-delimited comp values) that are putative cros-contaminations
#           (2) output table from rsem for both species


my $usage = "comp_to_expression2.pl species.pairs.comp rsem_output_sp1 rsem_out_sp2 > out\n";
my $infile = $ARGV[0] or die $usage;
my $rsem1 = $ARGV[1] or die $usage;
my $rsem2 = $ARGV[2] or die $usage;


# get expression values from rsem files (throught the subroutine) and returns a reference of a hash

my $expressions_1 = get_expression_values ($rsem1) ; # sp1
my $expressions_2 = get_expression_values ($rsem2) ; # sp2

#print Dumper $expressions_1;

# de-reference

my %expression_values_1 = % { $expressions_1 };
my %expression_values_2 = % { $expressions_2 };

#foreach my $key (keys %expression_values_2){
      #print $key ,"\t", $expression_values_2{$key}[2],"\n";
#     }
# process infile containing gene pairs

open (IN, "<", $infile) or die "Can't open $infile: $!\n";
open (OUT1, ">", "cont_to_express_seq_to_remove_species1.out");
open (OUT2, ">", "cont_to_express_seq_to_remove_species2.out");

# hash inside of hash to store gene pairs and expression values
my %expr_value_pairs;
# count will act as key for the hash
my $count = 0;


while (my $line = <IN>) {
    chomp $line;
    # skip all lines that do not contain actual genes (must start with comp)
    # in principle, this should skip only first comment line (starts with #) and sencond line where species are named (should be Neoce first and Lepi after)
    next if $line =~ /^#.+/ ;
    $count++;
    my ($sp1, $sp2) = split("\t", $line);
    my $sp1_name = "first_" . $sp1;
    my $sp2_name = "second_" . $sp2;
    # initialize structure for hash inside of hash
    # && asign fpkm values using previous hashes that contain expression values
    # CAUTION!! storing it in hashes we will loose the information of which comp belogs to which species
    # no problem since we just want to compare the expression values between gene pairs
    # probably possible to retrieve afterwards with additional code
    # [1] retrieves tpm values
    # [2] retrieves fpkm values
    $expr_value_pairs{$count}{$sp1_name} = $expression_values_1{$sp1}[2];
    $expr_value_pairs{$count}{$sp2_name} = $expression_values_2{$sp2}[2];

#    $expr_value_pairs{$count}{$nfor_name} = $expression_values_1{$nfor}[1];
#    $expr_value_pairs{$count}{$lpar_name} = $expression_values_2{$lpar}[1];

}

#print Dumper \%expr_value_pairs;

my @components;

foreach my $c ( sort keys %expr_value_pairs) {
    # de-reference inner hash
    my %inner_hash = % { $expr_value_pairs{$c} };
    #print Dumper \%inner_hash;
#   foreach my $k ( sort { $inner_hash{$a} <=> $inner_hash{$b} } keys %inner_hash ) {
    # get the key with the lowest value (i.e. likely contaminant)
    my ( $contaminant, $low_fpkm ) = each %inner_hash;
    # compare with the second key-value pair and reasign if smaller than the first one
    while ( my ( $key, $value ) = each %inner_hash ) {
	if ( $value < $low_fpkm ) {
	    $contaminant = $key;
	    $low_fpkm = $value;
	}
    }
    # print sequences that are contaminants into separate files
    if ( $contaminant =~ /^first_(.+)/ ) {
	print OUT1 "$1\n";
    }
    elsif ( $contaminant =~ /^second_(.+)/ ) {
	print OUT2 "$1";
    }
    else {
	print STDERR "Cannot print out contaminants, unexpected sequence name $contaminant :-(\n";
    }
}

print "\nLikely contaminants from species 1 printed to cont_to_express_seq_to_remove_species1.out\n";
print "Likely contaminants from species 2 printed to cont_to_express_seq_to_remove_species2.out\n";
print "\ndone!\n\n";

## subroutines ##

sub get_expression_values {

    #print "Hey, I am inside the soubroutine\n";
    
    my %expressions;

    my $infile2 = shift;

    open (IN2, "<", $infile2) or die "Can't open $infile2: $!\n";

    while (my $linea = <IN2>) {
	chomp $linea;
	# skip header line from rsem output
	next if $linea =~ /^transcript_id.+/ ;
	my @values = split("\t", $linea);
	my $gene = $values[0];
	my $expect_count = $values[4];
	my $tpm = $values[5];
	my $fpkm = $values[6];
	my $isopct = $values[7];
	$expressions{$gene} = [$expect_count, $tpm, $fpkm, $isopct];

    }
    return \%expressions;
#    print Dumper \%expressions;

}    

