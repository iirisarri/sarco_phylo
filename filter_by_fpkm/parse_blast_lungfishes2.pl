#!/usr/bin/perl  -w
 
use strict;
use Data::Dumper;
use Bio::SearchIO;

# blast parser to check cross-contamination between neoc/lepi
# Iker Irisarri. Moulis, Sept 2014
# prints count of matches according to %identity to stdout
# prints query/hit info to output file OUT

my $usage = "parsed_blast_lf.pl blast_report output> stdout\n";
my $blast_report = $ARGV[0] or die $usage;
my $outfile = $ARGV[1] or die $usage;

# read blast report
my $in = new Bio::SearchIO(-format => "blast", 
                           -file   => "<$blast_report");

my %results;
my $nohit=0;

# read through the blast report
while( my $result = $in->next_result ) {
	# count number of queries with no hit
	if ($result->num_hits ==0 ) {
		$nohit++;
		}
	while( my $hit = $result->next_hit ) {
		while( my $hsp = $hit->next_hsp ) {
	    	my $query = $result->query_name;
	    	#$hit->description=~/.*\[(.*)\].*/;
	    	#my $best_hit = $1;
	    	my $best_hit = $hit->accession;
	    	my $identity = $hsp->percent_identity;
	   		my $evalue = $hsp->evalue;
			my $query_length = $result->query_length;
#			my $aln_length = $hsp->length('total');
			my $aln_length = $hsp->hsp_length;
	    	# if the query does not exist, create a hash for it
	   	 	# key = query; values = hit, evalue
	    	if( !exists $results{$query} ) {
			$results{$query}=[$best_hit,$identity,$evalue,$query_length,$aln_length];
			#if the hash is already present, compare with previous hit by identity and replace
	    	} else {
			if( $evalue > $results{$query}[1] ) {
		    	$results{$query}=[$best_hit,$identity,$evalue,$query_length,$aln_length];
			}
	    	}
       }
    }
}

#print Dumper \%results;

open (OUT, ">", $outfile);

my $count_hits=0; # count total number of parsed hits (that fulfill the criteria set)
my $count100=0; # count number of hits with different identities
my $count99=0;
#my $count98=0;
#my $count97=0;
my $count=0; # count remaining hits (below 97% identity)

my $length_ratio;
my $length_ratio_round;
my $identity_round;

print OUT "query\tbest_hit\tpercent_identity\tevalue\t%coverage\n";

foreach my $keys(sort keys %results) {
    # calculate ratio between hsp and query lengths, multiply by 100 & round decimals
# we expect many short sequences so this ratio does not help in this case
# I will use a threshold for the length fo the alingments > 100bp, for example
    $length_ratio =  $results{$keys}[4] /  $results{$keys}[3];
    $length_ratio_round = sprintf("%.2f", $length_ratio * 100);
    # round identity
    $identity_round = sprintf("%.1f", $results{$keys}[1]);
	# filter out results with coverage <50%
#    if ($length_ratio_round > 50)	{
# originally there was a threshold to exclude short sequences
# but like this won't be detected as contaminants even if they are
#    if ( $results{$keys}[4] > 100 ) {
	$count_hits++;
	    if ($results{$keys}[1] == 100)	{
	    #print "Hits with identity 100%:\n";
	    print OUT $keys, "\t", $results{$keys}[0], "\t", $identity_round,"\t", $results{$keys}[2], "\t", $length_ratio_round, "\n";
   	 	$count100++;
    	} elsif ($results{$keys}[1] >99 && $results{$keys}[1] <100)	{
    	#print "Hits with identity 99%:\n";
    	print OUT $keys, "\t", $results{$keys}[0], "\t", $identity_round,"\t", $results{$keys}[2], "\t", $length_ratio_round, "\n";
    	$count99++;
#    	} elsif ($results{$keys}[1] >98 && $results{$keys}[1] <99)	{
    	#print "Hits with identity 98%:\n";
#    	print OUT $keys, "\t", $results{$keys}[0], "\t", $identity_round,"\t", $results{$keys}[2], "\t", $length_ratio_round, "\n";
#    	$count98++;
#    	} elsif ($results{$keys}[1] >97 && $results{$keys}[1] <98)	{
    	#print "Hits with identity 97%:\n";
#    	print OUT $keys, "\t", $results{$keys}[0], "\t", $identity_round,"\t", $results{$keys}[2], "\t", $length_ratio_round, "\n";
#		$count97++;
    	} elsif ($results{$keys}[1] <99) {
#	    print $keys, "\t", $results{$keys}[0], "\t", $identity_round,"\t", $results{$keys}[2], "\t", $length_ratio_round, "\n";
    	$count++;
		}
#	}
}

# print counts
print "\nnumber of hits with identity 100%:\t", $count100, "\n";
print "number of hits with identity 99%:\t", $count99, "\n";
#print "number of hits with identity 98%:\t", $count98, "\n";
#print "number of hits with identity 97%:\t", $count97, "\n";
#print "number of hits with identity below 97%:\t", $count, "\n\n";
# add all counts & compare with total number of hits
#my $sum = $count100 + $count99 + $count98 + $count97 + $count;
my $sum = $count100 + $count99 + $count;
print "number of total hits:\t", $sum, "\t", $count_hits, "\n";

close(OUT);

print "\ndone!\n";

__END__
