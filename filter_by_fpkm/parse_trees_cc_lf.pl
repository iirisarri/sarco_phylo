#!/usr/bin/perl -w

use strict;
use Bio::TreeIO;
use Data::Dumper;

# checks if two species are monophyletic, and report if the distance between them is very small (compared to the total tree length)
# it will check if all three lungfish species are present and consider only those trees (cannot decide whether there is contamination otherwise)
# if more than 1 sequence per species is present, the script will print that out (to be able to check that tree more carefully)
# Test of monophyly: be careful because I think it only computes whether the sequences are in the same clade!
# For this reason I apply a filter to consider contaminations when distance between Neoc/Lepi is smaller than Prot/Lepi
# Iker Irisarri. Konstanz, October 2014

my $usage = "parse_trees_cc_lungfish.pl tree > stdout\n";
my $input = $ARGV[0] or die $usage;

# print input name
print "File: ", $input, "\n";

my $treeio = new Bio::TreeIO(-file   => "$input",
                            -format => "newick");
                            
# initialize arrays to store node names and sequence names
my @nodes;
my @Neoc;
my @Lepi;
my @Prot;

while( my $tree = $treeio->next_tree ) {
	# calculate total tree length
	my $total_length = $tree->total_branch_length;
		#print $total_length, "\n";
	# store taxa into a hash where keys are taxa names
	# stolen from add_labels_to_trees.pl (Fede)
	my %leaves = %{&get_all_leaves($tree->get_root_node)};
		#print Dumper \%leaves;
		# save multiple sequences for each species into an array
		# save sequences for each species into array
		foreach my $key (keys %leaves) {
				#print $key; 
			while ($key =~/Neocerat/g) {
				push (@Neoc, $key);
			}
			while ($key =~/Lepidosi/g) {
				push (@Lepi, $key);
			}
			while ($key =~/Protopte/g) {
				push (@Prot, $key);
			}
		}
		#print join ('--', @Neoc);

	# require that all three lf are present
	if ( @Neoc ) {				# @Neoc is not empty
		if ( @Lepi ) {
			if ( @Prot ) {

				# get human id from keys to be the outgroup & re-root tree on human
				foreach my $key (keys %leaves) {
					if ($key =~/Homosapiens.*/g) {
						my $outgroup = $tree->find_node(-id => $key);
						$tree->reroot($outgroup);

						# MONOPHYLY TEST
						# define nodes for monophyly test and store them in an array
						my @pair;
						foreach my $i (@Neoc) {
							foreach my $j (@Lepi) {
								foreach my $k (@Prot) {
								my $N = $tree->find_node(-id => $i);
								my $L = $tree->find_node(-id => $j);
								my $P = $tree->find_node(-id => $k);						
								my @pair = [$N, $L];
									#print $i, "--", $j, "\n";
									#print Dumper \$node1, "--", $node2, "\n";
									# calculate distance between these two nodes
								my $dist_NL = $tree->distance(-nodes => [$N,$L]);
								my $dist_PL = $tree->distance(-nodes => [$P,$L]);
									#print "\tDistance between ", $i, " and ", $j, ": ", $dist_AB, "\n";
									#print "\tTotal tree length: ", $total_length, "\n";
								# filter if distance between N-L is smaller than P-L
								if ( $dist_NL < $dist_PL ) {
									if( $tree->is_monophyletic(	-nodes => \@pair,
																-outgroup => $outgroup) ) {
										print "\tPossible cross-contamination between: ", $i, " and ", $j, " They are sister taxa!\n";
										#print "\tdistance between species: ", $dist_NL, "\n";
									} else {
										print "\tNo cross-contamination between: ", $i, " and ", $j, "\n";
									}
								} else {
									print "\tNo cross-contamination between: ", $i, " and ", $j, "\n";
								}		
								}
							}
						}
					}
				}
			}	
		}
	}
}

## SUBROUTINES ##

sub get_all_leaves {
	#Esta rutina devuelve todas las "hojas" descendientes de un nodo
	my $initial_node = $_[0];
	my %nodes;
	if($initial_node->is_Leaf) {
		$nodes{$initial_node->id} = 1;
		return \%nodes;
	}
	foreach my $node ( $initial_node->get_all_Descendents() ) {
		if( $node->is_Leaf ) { 
			# for example use below
			$nodes{$node->id} = 1;
		}
	}
	return \%nodes;
}


__END__
