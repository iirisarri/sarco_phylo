#!/usr/bin/perl -w

use strict;
use Bio::SearchIO;
use Data::Dumper;

# blast parser vertebrate phylogenomic project
# detect contaminants from gene alignments
# prints out species name of query and best hits and evalue
# blastp against nr using seed files (fasta queries) provided by Hervé
# IMPORTANT! If query_name or query_description are repeated in the blastp output, some of them will be lost as they are rewritten in the hash
# in this case I had separate files for blastp output and worked by using a for loop:
#  for f in Dxaa/*.blastp; do perl parse_blast_best_hit_taxonomy.pl $f > $f.acc.parsed; done &
# modified to work on multiple blast output files, using query_description

my $usage = "perl parse_blast_best_hit_taxonomy_simple.pl suspicious_vs_refmtgm.blastn suspicious_vs_refmtgm.nohit suspicious_vs_refmtgm.id98.len100 suspicious_vs_refmtgm.id95-98.len100 suspicious_vs_refmtgm.id90-95.len100\n";
my $blast_report = $ARGV[0] or die $usage;
my $out = $ARGV[1] or die $usage;
my $out1 = $ARGV[2] or die $usage;
my $out2 = $ARGV[3] or die $usage;
my $out3 = $ARGV[4] or die $usage;

# read blast report
my $in = new Bio::SearchIO(-format => "blast", 
                           -file   => "<$blast_report");
open (OUT, ">", $out);
open (OUT1, ">", $out1);
open (OUT2, ">", $out2);
open (OUT3, ">", $out3);

my %results;
# initialize $count for creating the keys as consecutive numbers
my $count=0;

# read through the blast report
while( my $result = $in->next_result ) {
    if( $result->num_hits == 0 ) {
    	# save results with no hit to OUT2
		print OUT $result->query_name, "\n"; 
	} while( my $hit = $result->next_hit ) {
		while( my $hsp = $hit->next_hsp ) {
		    # declare variable $query outside if loops (won't work otherwise)
			$count++;
		    my $query = $result->query_description;
			my $best_hit = $hit->description;
			my $aln_length = $hsp->length('total');
			my $identity = $hsp->percent_identity;
			my $evalue = $hsp->evalue;
				# if the query does not exist, create a hash for it
				# key = query; values = hit, evalue
				if( !exists $results{$count} ) {
					$results{$count}=[$query,$best_hit,$aln_length,$identity,$evalue];
					# if the hash is already present, compare with previous hit by evalue and replace
					} elsif( $evalue < $results{$count}[1]) {
							$results{$count}=[$query,$best_hit,$aln_length,$identity,$evalue];
					}
				}
		}
	}

#print Dumper \%results;


# print heading to out1 file
print OUT1 "parsed results >98 identity && aln_length > 100\n";
print OUT1 "query\tbest_hit\taln_length\tidentity\tevalue\n";
print OUT2 "parsed results >98 identity && aln_length > 100\n";
print OUT2 "query\tbest_hit\taln_length\tidentity\tevalue\n";
print OUT3 "parsed results >98 identity && aln_length > 100\n";
print OUT3 "query\tbest_hit\taln_length\tidentity\tevalue\n";


# for each best hit, print the selected values in tab-delimited form
foreach my $keys(sort keys %results) {
#	print Dumper \%results, "\n";
	#   filter by identity and query_length 
	if ($results{$keys}[3] >98 && $results{$keys}[2] > 100) {
        #print Query, Hit, evalue
		print OUT1 $results{$keys}[0], "\t", $results{$keys}[1], "\t", $results{$keys}[2], "\t", $results{$keys}[3], "\t", $results{$keys}[4], "\n";
	} elsif ($results{$keys}[3] >95 && $results{$keys}[3] <98 && $results{$keys}[2] > 100) {
        #print Query, Hit, evalue
		print OUT2 $results{$keys}[0], "\t", $results{$keys}[1], "\t", $results{$keys}[2], "\t", $results{$keys}[3], "\t", $results{$keys}[4], "\n";
    }	elsif ($results{$keys}[3] >90 && $results{$keys}[3] <95 && $results{$keys}[2] > 100) {
        #print Query, Hit, evalue
		print OUT3 $results{$keys}[0], "\t", $results{$keys}[1], "\t", $results{$keys}[2], "\t", $results{$keys}[3], "\t", $results{$keys}[4], "\n";
    }
}

close(OUT);
close(OUT1);
close(OUT2);
close(OUT3);