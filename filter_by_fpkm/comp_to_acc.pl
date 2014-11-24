#!/usr/bin/perl

use strict;
use warnings;
use List::MoreUtils qw(uniq);
use Data::Dumper;

# reads in output2 from comp_to_expression.pl (comps with expression values ==0), comp (trinity) to  acc number (HP)

# november 2014:

my $usage = "comp_to_acc.pl cross-contam_seq_to_remove.tab list/list-AC-neofor  list/list-AC-leppar > out\n";
my $infile = $ARGV[0] or die $usage;
my $list1 = $ARGV[1] or die $usage;
my $list2 = $ARGV[2] or die $usage;

# read-in (chomp) putatively contaminated genes from file 1 and store compXXX + fpkm in hash with keys = i (1...n) where n=number of lines

open (IN1, "<", $infile);

my @nfor_comps;
my @lpar_comps;;


while(my $line1 = <IN1>){
    chomp $line1;
    if ( $line1 =~ /nfor_(comp.+)/ ) {
	my @nfor_comps = push (@nfor_comps, $1);
    }
    elsif ( $line1 =~ /lpar_(comp.+)/ ) {
        my @lpar_comps = push (@lpar_comps, $1);
    }
    else {
	print STDERR "warning! Unkown species for $line1!\n";
    }
}

#print join ("--", @nfor_comps), "\n";
#print join ("--", @lpar_comps);

# get acc-comp pairs from both Lepi and Neoc list files
# stored in a hash, returned as reference

my $comp_to_acc1 = comp_to_acc($list1);
my $comp_to_acc2 = comp_to_acc($list2);

# de-reference output from subroutine to a hash
my %comp_to_acc1 = %{ $comp_to_acc1 };
my %comp_to_acc2 = %{ $comp_to_acc2 };

# print accession numbers corresponding to the components in the arrays
# first remove duplicates (some sequences appear more than once in cross-contam_seq_to_remove.tab)

my @nfor_comps_uniq = uniq @nfor_comps;
my @lpar_comps_uniq = uniq @lpar_comps;


foreach my $component (@nfor_comps_uniq) {
    print "$comp_to_acc1{$component}\n";
}

foreach my $component (@lpar_comps_uniq) {
    print "$comp_to_acc2{$component}\n";
}





# subroutine to save accession comp pairs in a hash for each acc-comp files

sub comp_to_acc {
    # get infile (acc-to-comp correspondence file) and open
    my $list = shift;
    open (IN2, "<", $list) or die "Cannot open $list: $!\n";
    my %comp_to_acc;
    while(my $line2 = <IN2>){
	chomp $line2;
	my @lines2 = split (/\s/, $line2);
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

