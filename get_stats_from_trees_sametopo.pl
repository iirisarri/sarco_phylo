#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Statistics::Descriptive;

# Iker Irisarri, University of Konstanz. Feb 2016

# get_stats_from_trees_sametopo.pl
# Sarco phylogenomics project
# Get mean and SD of branch lengths
# E.g., divergence times) from timetrees
# REQUIRES trees with the same topology (branch lengths and supports are substituted in order)
# For trees with different topologies, Bioperl is required to get homologous branches

my $usage = "perl get_stats_from_trees_sametopo.pl infile.tre > infile.mean.tre infile.sd.tre\n";
my $infile = $ARGV[0] or die $usage;

my $outfile1 = $infile . ".mean.tre";
my $outfile2 = $infile . ".sd.tre";
my $outfile3 = $infile . ".var.tre";

open (IN, "<", $infile);

my %tree_info;
my $tree_counter = 0;
my $tree_struct_masked;

while ( my $line =<IN> ) {
	chomp $line;
	$tree_counter++;
	my @lines = split /[:,)]/, $line;
#	print join ("__", @lines);

	# remove array elements that are not numbers
	my @numbers;
	foreach my $e ( @lines ) {
		if ( $e =~ /^\d.*/ ) {
			push ( @numbers, $e );
		}
	}
	$tree_info{$tree_counter} = [@numbers];
}
close(IN);

# get tree structure and substitute numbers
my $first_tree = `head -n1 $infile`;
# substitute branch lengths by "NUM"
$first_tree =~ s/:\d[\.\d+]*/:NUM/g;
# substitute support values by "NUM"
$first_tree =~ s/\)\d[\.\d+]*/)NUM/g;
#print $first_tree;

# CALCULATE BASIC STATISTICS && SAVE IN HASH
my %stats_results;
my $array_length = scalar @{ $tree_info{1} };

# loop through every array index for all trees
for ( my $i=0; $i< $array_length; $i++ ) {

	# initialize $stat object for every index in $tree_info{1}
	my $stat = Statistics::Descriptive::Full->new();
	
	foreach my $key ( keys %tree_info ) {

		my $data = $tree_info{$key}[$i];
		$stat->add_data($data);
		#print "$data\t";
	}
		# calculate stats for homologous branch lengths or support values (those with same index in arrays)
	my $mean = $stat->mean();
	# print "$mean\n";
	my $variance = $stat->variance();
	my $sd = $stat->standard_deviation();
	my $min = $stat->min();
	my $max = $stat->max();
	
	# create new hash where keys correspond to array indexes in @{ $tree_info{$key} }
	$stats_results{$i} = [$mean, $variance, $sd, $min, $max]

}

#print Dumper \%stats_results;
=pod
# check that numbers are stored in the right order!
# Yes, they are :-)
foreach my $l ( keys %tree_info ) {
	#print out data for NUM with index 2
	print "$tree_info{$l}[2]\n";
}
=cut

# print out trees with means and standard deviations as branch lengths
my $tree_mean_bl = $first_tree;
my $tree_sd_bl = $first_tree;
my $tree_var_bl = $first_tree;
my $substitutions;

# IMPORTANT! use of "sort {$a <=> $b}" for human-readable sort
# so that array indexes correspond to the fields to be substituted
foreach my $k ( sort {$a <=> $b} keys %stats_results ) {
	
	my $mean_value = $stats_results{$k}[0];
	my $var_value = $stats_results{$k}[1];
	my $sd_value = $stats_results{$k}[2];

	$tree_mean_bl =~ s/NUM/$mean_value/;
	$tree_var_bl =~ s/NUM/$var_value/;
	$tree_sd_bl =~ s/NUM/$sd_value/;
	$substitutions++;
	
}

# check if all required substitutions have been made correctly
if ( $array_length != $substitutions ) {

	print STDERR 	"WARN: error in pattern substitution:\n",
					"Values to substitute: $array_length\n",
					"Values substituted: $substitutions\n";
}

open (OUT1, ">", $outfile1) or die "Can't create $outfile1!\n";
open (OUT2, ">", $outfile2) or die "Can't create $outfile2!\n";
open (OUT2, ">", $outfile3) or die "Can't create $outfile3!\n";
print OUT1 "$tree_mean_bl\n";
print OUT2 "$tree_sd_bl\n";
print OUT3 "$tree_var_bl\n";


print STDERR "\nDone!\n\n";



