#!/usr/bin/perl -w                                                                                            
use strict;
use Data::Dumper;

# cross-contam_trees_to_fpkm.pl reads output from acc_to_comp.pl, which are pairs of sequences (Nfor, Lpar) that are potentially contaminants, as inferred from analysis of gene trees
# It reads rsem output files to save fpkm values for both species, and then prints fpkm values for each pair
# calculate some stats?

my $usage = "cross-contam_trees_to_fpkm.pl pairs_of_seqs rsem.isoforms.results rsem.isoforms.results > out\n";
my $infile = $ARGV[0] or die $usage;
my $rsem1 = $ARGV[1] or die $usage;
my $rsem2 = $ARGV[2] or die $usage;

# read-in (chomp) rsem files and store compXXX (keys) and fpkm (value)

my %rsem1;
my %rsem2;

open (IN1, "<", $infile);
open (IN2, "<", $rsem1);
open (IN3, "<", $rsem2);

while(my $line = <IN2>){
    chomp $line;
    my @line = split ("\t", $line);
    my $comp = $line[0];
    my $fpkm = $line[6];
	$rsem1{$comp}=$fpkm;
}

#print Dumper \%rsem;

while(my $line = <IN2>){
    chomp $line;
    my @line = split ("\t", $line);
    my $comp = $line[0];
    my $fpkm = $line[6];
	$rsem2{$comp}=$fpkm;
}

print "\#Neoc\tLepi\tfpkm(N)\tfpkm(L)\n";

my @comps;

while(my $line = <IN3>){
    chomp $line;
    my @comps = split ("\t", $line);
	# ORDER OF SEQUENCES IS IMP!! @comps[0] (=Nfor), @comps[1] (=Lpar)	
	foreach my $comp (@comps) {
		# loop through rsem hashes to look for a comp that matches $comps[2] and $comps[1] & print
		foreach my $key1 (keys %rsem1) {
			foreach my $key2 (keys %rsem2) {
				if ( $comps[0] == $rsem1{$key1} ) {
					if ( $comps[1] == $rsem2{$key2} ) {
						## something does not work
						## order by fpkm!!
						print "$comps[0]\t$comps[1]\t$rsem1{$key1}\trsem{$key2}\n";
					}
				}
			}
		}
	}
}

close(IN1);
close(IN2);
close(IN3);

__END__



# print elements of hash by sorting fpkm values (elements 1 and 3) as well as the corresponding compXXX (elements 0 and 2)

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

__END__

type of input file, containing pairs of Nfor and Lpar sequence names (from trinity)
order (column 1 vs 2) is not important in this case, as we'll order by fpkm values

comp121608_c0_seq1	comp56143_c0_seq3
comp43032_c0_seq1	comp77061_c0_seq2
comp49491_c0_seq1	comp86587_c0_seq1
comp120198_c0_seq1	comp85451_c0_seq1




