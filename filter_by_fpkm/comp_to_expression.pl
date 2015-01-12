#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

# Iker Irisarri, november 2014

# comp_to_expression.pl will get different expression values (default fpkm) for pairs of sequences that come from different species but are putative cross-contaminations, and will print ordered value pairs (smaller to larger) in two columns

# requires: (1) infile with pairs of gene names (tab-delimited comp values) that are putative cros-contaminations
#           (2) output table from rsem for both species


my $usage = "comp_to_expression.pl cross-contam_lf_comps.txt rsem_output_nfor rsem_out_leppar > out\n";
my $infile = $ARGV[0] or die $usage;
my $rsem1 = $ARGV[1] or die $usage;
my $rsem2 = $ARGV[2] or die $usage;


# get expression values from rsem files (throught the subroutine) and returns a reference of a hash

my $expressions_1 = get_expression_values ($rsem1) ; # neoc
my $expressions_2 = get_expression_values ($rsem2) ; # lepi

#print Dumper $expressions_1;

# de-reference

my %expression_values_1 = % { $expressions_1 };
my %expression_values_2 = % { $expressions_2 };

#foreach my $key (keys %expression_values_2){
      #print $key ,"\t", $expression_values_2{$key}[2],"\n";
#     }
# process infile containing gene pairs

open (IN, "<", $infile) or die "Can't open $infile: $!\n";
open (OUT1, ">", "cross-contam_expressions.tab");
open (OUT2, ">", "cross-contam_seq_to_remove.tab");

# hash inside of hash to store gene pairs and expression values
my %expr_value_pairs;
# count will act as key for the hash
my $count = 0;


while (my $line = <IN>) {
    chomp $line;
    # skip all lines that do not contain actual genes (must start with comp)
    # in principle, this should skip only first comment line (starts with #) and sencond line where species are named (should be Neoce first and Lepi after)
    next if $line !~ /^comp.+/ ;
    $count++;
    my ($nfor, $lpar) = split("\t", $line);
    # create gene names that retain which species they belong to
    my $nfor_name = "nfor_".$nfor;
    my $lpar_name = "lpar_".$lpar;
    #print "$nfor--$lpar\n";
    # initialize structure for hash inside of hash
    # && asign fpkm values using previous hashes that contain expression values
    # CAUTION!! storing it in hashes we will loose the information of which comp belogs to which species
    # no problem since we just want to compare the expression values between gene pairs
    # probably possible to retrieve afterwards with additional code
    # [2] retrieves fpkm values
    $expr_value_pairs{$count}{$nfor_name} = $expression_values_1{$nfor}[2];
    $expr_value_pairs{$count}{$lpar_name} = $expression_values_2{$lpar}[2];
    # [1] retrieves tpm values
#    $expr_value_pairs{$count}{$nfor_name} = $expression_values_1{$nfor}[1];
#    $expr_value_pairs{$count}{$lpar_name} = $expression_values_2{$lpar}[1];
}

#print Dumper \%expr_value_pairs;

my @components;

foreach my $c ( sort keys %expr_value_pairs) {
    # de-reference inner hash
    my %inner_hash = % { $expr_value_pairs{$c} };
    #print Dumper \%inner_hash;
   foreach my $k ( sort { $inner_hash{$a} <=> $inner_hash{$b} } keys %inner_hash ) {
       # print pairs of fpkm values per line 
	print OUT1 $inner_hash{$k}, "\t";
	}
    print OUT1 "\n";

    # store comp names for each species with pfkm values below a certain threshold
    
    foreach my $sp ( keys %inner_hash ) {
	# will print components with expression values == 0
#	if ( $inner_hash{$sp} == 0 ) {
	# will print components with expression values lower than threshold
	if ( $inner_hash{$sp} < 0.4 ) {
	    push (@components, $sp);
	}
    }
}


# print components after sorting (will separate different species because this info was contained in the keys)

foreach my $comp (sort @components) {
    print OUT2 "$comp\n";
}





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

