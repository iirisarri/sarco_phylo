#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

my $infile1 = $ARGV[0];
my $infile2 = $ARGV[1];

my $usage = "how_many_cross_contam.pl cross-contam_seq_to_remove_fpkm0.1.acc lf_cross_contam\?_uniq.txt\n";
open (IN1, "<", $infile1) or die $usage;
open (IN2, "<", $infile2) or die $usage;

# get acc of sequences to remove

my @accessions;
my $acc_count=0;

while (my $l = <IN1>) {
    chomp $l;
    $acc_count++;
    push (@accessions, $l);
}

#print Dumper \@acc;

# get pairs of acc from cross-contaminated sequences

my @contam;
my $cont_count=0;

while (my $line = <IN2> ) {
    chomp $line;
    $cont_count++;
    my @lines = split '@', $line;
    $lines[1] =~ /(Nfor\d+).+/g;
    push (@contam, $1);
    $lines[2] =~ /(Lpar\d+).+/g;
    push (@contam, $1);
}

# remove redundancy
my @contam_uniq = uniq @contam;

# intersect

my $common=0;
my $unique=0;

foreach my $acc (@accessions) {
    foreach my $cont (@contam_uniq) {
	if ($acc eq $cont) {
	    $common++;
	}
    }
}

#print join ("\n", sort @contam_uniq); 

my $only1 =  $acc_count - $common ;
my $only2 =  $cont_count - $common ;

my $perc_of_contam = ($only2 / $cont_count) * 100;

print "common: $common\n";
print "unique seq to remove: $only1\n";
print "unique contaminated: $only2\t$perc_of_contam\n";

print "total seq to remove: $acc_count\n";
print "total contaminated: $cont_count\n";
