#!/usr/bin/perl -w                                                                                            
use strict;
use Data::Dumper;

# modified from overlapping.pl                                                                                
# It takes two files, each with a list of elements and only prints common elements                            

my $usage = "cross-contamination_blast_to_fpkm.pl parsed_blast rsem.isoforms.results rsem.isoforms.results > out\n";
my $infile1 = $ARGV[0] or die $usage;
my $infile2 = $ARGV[1] or die $usage;
my $infile2 = $ARGV[2] or die $usage;

# create a hash called %count and store genes as keys and value the spp name                                  

# store info query/best hit into a hash

open(IN, "<", $infile1) or die;
while(my $in=<IN>){
	while ( $in =~ /comp.+/g ) {
    chomp $in;
    my @line = split ("\t", $in);
    my $query = $line[0];
#	my $second = $line[1];
 	$line[1]=~/lcl\|(.+)/g;
    my $best_hit = $1;
print $query, "--", $best_hit, "\n";
#    $count1++;
#    $count{$in}=[$one];
}
}
close(IN);

# read-in rsem output file for lepidosiren

# save fpkm values for queries

# read-in rsem output file for neoceratodus

# save fpkm values for best_hits
