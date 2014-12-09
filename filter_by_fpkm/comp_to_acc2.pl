#!/usr/bin/perl

use strict;
use warnings;
use List::MoreUtils qw(uniq);
use Data::Dumper;

# modified version of comp_to_acc.pl to read-in file from a single species (not two)

# Iker Irisarri, Uni Konstanz, December 2014

my $usage = "comp_to_acc2.pl my_species_remove.comp acc_comp_correspondence/Typhlonectes_natans.ACC.acc_comp > out\n";
my $infile = $ARGV[0] or die $usage;
my $list = $ARGV[1] or die $usage;


# read-in (chomp) putatively contaminated genes from file 1 and store compXXX + fpkm in hash with keys = i (1...n) where n=number of lines

open (IN1, "<", $infile);

my @comps;


while(my $line = <IN1>){
    chomp $line;
    my @comps = push (@comps, $line);
}

# get acc-comp pairs from acc_comp files
# stored in a hash, returned as reference

my $comp_to_acc1 = comp_to_acc($list);


# de-reference output from subroutine to a hash
my %comp_to_acc1 = %{ $comp_to_acc1 };


# first remove duplicates if present

my @comps_uniq = uniq @comps;


# print accession numbers corresponding to the components in the arrays

foreach my $component (@comps_uniq) {
    print "$comp_to_acc1{$component}\n";
}







# subroutine to save accession comp pairs in a hash for each acc-comp files

sub comp_to_acc {
    # get infile (acc-to-comp correspondence file) and open
    my $list = shift;
    open (IN2, "<", $list) or die "Cannot open $list: $!\n";
    my %comp_to_acc;
    while(my $line2 = <IN2>){
	chomp $line2;
# for original lf files acc comp separated with whitespace
        my @lines2 = split (/\s/, $line2);
# other files use tab
#	my @lines2 = split (/\t/, $line2);
	# get accession names from fasta header stuff
	my $comp = $lines2[1];
	$lines2[0] =~ />gnl\|est\|(\S+)/;
	my $accession = $1;
	$comp_to_acc{$comp} = $accession;
    }
    #print Dumper \%acc_to_comp;
    return \%comp_to_acc;
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

