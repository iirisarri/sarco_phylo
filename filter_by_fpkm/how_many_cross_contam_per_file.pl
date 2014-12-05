#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

my $infile1 = $ARGV[0];
my $infile2 = $ARGV[1];

my $usage = "how_many_cross_contam_per_file.pl cross-contam_seq_to_remove_fpkm0.1.acc lf_cross_contam\?_uniq.txt\n";
open (IN1, "<", $infile1) or die $usage;
open (IN2, "<", $infile2) or die $usage;

# get acc of sequences to remove

my %accessions;
my $acc_count=0;

while (my $l = <IN1>) {
    chomp $l;
    $acc_count++;
    $accessions{$l} = 1;
}

#print Dumper \@acc;

# get pairs of acc from cross-contaminated sequences

my %contam;
my %contam_uniq;
my $cont_count=0;
my $file_name=0;

while (my $line = <IN2> ) {
    chomp $line;
#    $cont_count++;

    if ( $line =~ /^File: (\w+)/ ) {
	$file_name = $1;
	next;
    }

    my @lines = split '@', $line;
    $lines[1] =~ /(Nfor\d+).+/g;
    # save only if sequence is not among seq that would be removed
    # not that this still saves duplicated acc; will be removed latter
    if ( !exists $accessions{$1} ) {
	if ( !exists $contam{$file_name} ) {
	    $contam{$file_name} = [$1];
	}
	else {
	    # if key for that file exists, append acc to the array (its the hash value)
	    push ( @{ $contam{$file_name} }, $1 );
	}
    }

    $lines[2] =~ /(Lpar\d+).+/g;
    if ( !exists $accessions{$1} ) {
        if ( !exists $contam{$file_name} ) {
            # create new key for each file and save first acc
            $contam{$file_name} = [$1];
        }
        else {
            # if key for that file exists, append acc to the array (its the hash value)
            push ( @{ $contam{$file_name} }, $1 );
        }
    }
}



# remove redundancy (created by tree file parser)
foreach my $key ( keys %contam ) {
#    my @contam_uniq = uniq @contam;
    my @array = uniq @{ $contam{$key} };
    $contam_uniq{$key} = [@array];
}

#print Dumper \%contam_uniq;

# intersect
my $both = 0;
my $one = 0;
my $none = 0;
my $num_genes = 0;

foreach my $k ( keys %contam_uniq ) {
    my $cont1 = 0;
    my $cont2 = 0;
    $num_genes++;

    foreach my $elem ( @{ $contam_uniq{$k} } ) {
	if ( $elem =~ /^Nfor.+/ ) {
	    $cont1++;
	}
        if ( $elem =~ /^Lpar.+/) {
            $cont2++;
        }
    }
    # 
    if ( $cont1 > 0 && $cont2 > 0 ) {
	$both++;
    }
    elsif ( $cont1 > 0 || $cont2 > 0 ) {
	$one++;
    }
    elsif ( $cont1 == 0 && $cont2 == 0 ){
	$none++;
    }
}

# to print only numbers
#print "$num_genes\n$both\n$one\n$none\n";
#__END__

# print summary
print "total numbers of genes: $num_genes\n";
print "genes with both species present: $both\n";
print "genes with only one species present: $one\n";
print "genes that lost both sequences: $none\n";

print "\ndone!\n\n";

