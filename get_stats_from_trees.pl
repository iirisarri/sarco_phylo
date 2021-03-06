#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Bio::TreeIO;
use Statistics::Descriptive;

# Iker Irisarri, University of Konstanz. Feb 2016

# get_stats_from_trees.pl
# modif of get_stats_from_trees_sametopo.pl to allow topological variation among input trees
# Sarco phylogenomics project
# Get mean, variance and SD of branch lengths
# For the collection of trees found in the infile: branch length and support value (for internal nodes)
# are printed out as mean, sd, min and max
# In addition, overall values for branch lengths and support values are also printed out
# Note that all bipartitions present in the collection will be printed out
# The correspondence with the nodes in the reference tree can be found by running the script on a single reference tree

my $usage = "perl get_stats_from_trees.pl infile.trees outgroup > STDOUT\n";
my $infile = $ARGV[0] or die $usage;
my $outgroup = $ARGV[1];

if ( !defined $outgroup ) {
	$outgroup = "Callorhinc";
}

# read-in trees
my $treeio = new Bio::TreeIO(	-file   => "$infile",
						     	-format => "newick",
								-internal_node_id => 'bootstrap'); # To specify that  internal nodes id encode bootstrap values instead of IDs

my %tree_data;
my $tree_counter = 0;
my $node_counter = 0;

while( my $tree = $treeio->next_tree ) {

	$tree_counter++;

	# re-root the tree
    my $root = $tree->find_node( -id => $outgroup );
    $tree->reroot( $root );
		
	for my $node ( $tree->get_nodes ) {

		$node_counter++;	# same node in different trees do not get the same number!
		my $node_type;
		my $id;
		my $branch_length;
		my $bootstrap;
		my @branch_lengths;
		my @bootstraps;
		my @descendents;
		my @descendents_sorted;
		my $desc_sorted_string;
		
		# skip root node (it has no branch lengths)
		#next if ( $node_counter ==1 );
		
		# parse leaves
		if ( $node->is_Leaf ) {
			$node_type = "terminal";
			$id = $node->id;
			$bootstrap = "NA";
			$branch_length = $node->branch_length;
			$desc_sorted_string = $id;
		}
		# parse internal nodes
		else {
			$node_type = "internal";
			$id = "NA";
			$bootstrap = $node->bootstrap;
			$branch_length = $node->branch_length;
			# root node does not have branch length. Assign "NA" to avoid error messages
			if ( !defined $branch_length ) {
				$branch_length = "NA";
			}
			if ( !defined $bootstrap ) {
				$bootstrap = "NA";
			}
			for my $desc ( $node->get_all_Descendents ) {
				if  ( $desc->is_Leaf ) {
					push (@descendents, $desc->id);
				}
				@descendents_sorted = sort @descendents;
				$desc_sorted_string = join ("--", @descendents_sorted);
			}
		}
		# skip root node (it has no information for $id, $branch_length, $bootstrap
		next if ( $branch_length eq "NA" && $bootstrap eq "NA");
		
		#print "0: $node_counter\n";
		#print "1: $id\n";
		#print "2: $branch_length\n";
		#print "3: $bootstrap\n";
		#print "4: $desc_sorted_string\n\n";
		
		# check that info is not overwritten
		# Problems are generated by the root node (includes all descendents)
		# and sometimes one leaf, related to how rooting is done
		# In these cases, the warning is not worrying
		if ( !exists $tree_data{$desc_sorted_string} ) {
		
			$tree_data{$desc_sorted_string}{'TYPE'} = [$node_type];
			$tree_data{$desc_sorted_string}{'BL'} = [$branch_length];
			$tree_data{$desc_sorted_string}{'BS'} = [$bootstrap];
		}
		else {
			
			# add data to arrays
			push ( @{ $tree_data{$desc_sorted_string}{'BL'} }, $branch_length );
			push ( @{ $tree_data{$desc_sorted_string}{'BS'} }, $bootstrap );			
		}
	}
}

# print Dumper \%tree_data;

# CALCULATE STATS FOR "HOMOLOGOUS" LINEAGES && SAVE IN HASH

my %stats_results;
my $overall_bl_stat = Statistics::Descriptive::Full->new();
my $overall_bs_stat = Statistics::Descriptive::Full->new();

# $k corresponds to $desc_sorted_string's
foreach my $k ( keys %tree_data ) {

	# $l corresponds to TYPE, BL or BS
	foreach my $l ( keys %{ $tree_data{$k} } ) {

		# store key TYPE in %stats_results && skip for calculations
		if ( $l eq "TYPE") {
			$stats_results{$k}{$l} = $tree_data{$k}{$l}[0];
			next;
		}
		my @inner = @{ ${ $tree_data{$k} }{$l} };

		# skip BS for terminal branches
		next if ( $l eq "BS" && $tree_data{$k}{'TYPE'}[0] eq "terminal" );
		
		# $m corresponds to array indexes
		my $stat = Statistics::Descriptive::Full->new();
		
		foreach my $m ( @inner ) {

			# skip "NA"s and undefined values
			next if ( $m eq "NA" || $m eq "" );

			# print "$k\t$l\t$m\n";

			my $data = $inner[$m];
			# skip if data is empty
			next if ( !defined $data );
			$stat->add_data($data);
			
			# store data for overall stats
			if ( $l eq "BL" ) { 
				
				$overall_bl_stat->add_data($data);
			}
			elsif ( $l eq "BS" ) {
				
				$overall_bs_stat->add_data($data);
			}
		}
		# calculate and store info for BL and BS
		my $mean = $stat->mean();
		my $variance = $stat->variance();
		my $sd = $stat->standard_deviation();
		my $min = $stat->min();
		my $max = $stat->max();

		# print "$k\t$l\t$mean\n";

		$stats_results{$k}{$l} = [$mean, $variance, $sd, $min, $max];
	}
}

#print Dumper \%stats_results;

# PRINT OUT INFORMATION FOR HOMOLOGOUS BRANCHES
print "NODE\tMEAN_BL\tSD_BL\tMIN_BL\tMAX_BL\tMEAN_SUP\tSD_SUP\tMIN_SUP\tMAX_SUP\n";

# $n corresponds to $desc_sorted_string
foreach my $n ( sort keys %tree_data ) {

	print "$n\t";

	print "$stats_results{$n}{'BL'}[0]\t";
	print "$stats_results{$n}{'BL'}[2]\t";
	print "$stats_results{$n}{'BL'}[3]\t";
	print "$stats_results{$n}{'BL'}[4]\t";
			
	# for internal nodes, print support values
	if ( $tree_data{$n}{"TYPE"}[0] eq "internal" ) {
	
		print "$stats_results{$n}{'BS'}[0]\t";
		print "$stats_results{$n}{'BS'}[2]\t";
		print "$stats_results{$n}{'BS'}[3]\t";
		print "$stats_results{$n}{'BS'}[4]";
	}
print "\n";
}

# CALCULATE AND PRINT OUT GENERAL STATS
my $overall_bl_mean = $overall_bl_stat->mean();
my $overall_bl_sd = $overall_bl_stat->standard_deviation();
my $overall_bl_min = $overall_bl_stat->min();
my $overall_bl_max = $overall_bl_stat->max();
my $overall_bs_mean = $overall_bs_stat->mean();
my $overall_bs_sd = $overall_bs_stat->standard_deviation();
my $overall_bs_min = $overall_bs_stat->min();
my $overall_bs_max = $overall_bs_stat->max();

print "\nGENERAL STATS FOR $tree_counter TREES\n";
print "MEASURE:	MEAN	SD	MIN	MAX\n";
print "BRANCH LENGTHS:	$overall_bl_mean	$overall_bl_sd	$overall_bl_min	$overall_bl_max\n";
print "SUPPORT VALUES:	$overall_bs_mean	$overall_bs_sd	$overall_bs_min	$overall_bs_max\n\n";

print STDERR "\nDone!\n\n";