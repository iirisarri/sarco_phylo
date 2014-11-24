#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# modified from overlapping.pl
# It takes two files, each with a list of elements and only prints common elements

my $usage = "overlapping_common.pl infile1 infile2\n";
my $infile1 = $ARGV[0] or die $usage;
my $infile2 = $ARGV[1] or die $usage;

# create a hash called %count and store genes as keys and value the spp name

my %count;
my $one="present in one file";
my $two="present in both files";
my $count1=0;

open(IN, "<", $infile1) or die;
while(my $in=<IN>){
	chop $in;
	$count1++;
	$count{$in}=[$one];
}
close(IN);

open(IN, "<", $infile2) or die;

# store the new keys in the same hash
# print hash to check for different species
# If I want to use for three files, copy this last while loop and use it again with the other file

my $count2=0;

while(my $in=<IN>){
        chop $in;
		$count2++;
        if (exists $count{$in}){
            $count{$in}=[$two];
        }
        else{
             $count{$in}=[$one];
	}
}

close(IN);

# print Dumper \%count;

my $total=0;
print "\n";

foreach my $key (keys %count){
	if ( $count{$key}[0] eq 'present in both files' ) {
		$total++;
		print $key,"\n";
	}
}

my $percent1= ($total/$count1)*100;
my $percent2= ($total/$count2)*100;

print "\nnumber of common elements in both lists: ", $total, " out of ", $count1, " elements in ", $infile1, ": ", $percent1, "%\n";
print "\nnumber of common elements in both lists: ", $total, " out of ", $count2, " elements in ", $infile2, ": ", $percent2, "%\n";
print "\ndone!\n\n";
