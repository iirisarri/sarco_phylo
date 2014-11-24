#!/usr/bin/perl                                                                                               

use warnings;
use strict;
use Data::Dumper;

my $usage = "comp_to_expression.pl infile_with_gene_names rsem_output_nfor rsem_out_leppar > out\n";
my $infile = $ARGV[0] or die $usage;

my %expressions;

my $infile2 = $ARGV[1];

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

print Dumper \%expressions;

