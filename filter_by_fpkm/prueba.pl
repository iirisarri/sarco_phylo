#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

my $list1 = shift;


my $acc_to_comp1 = acc_to_comp($list1);
#my $acc_to_comp2 = acc_to_comp($list2);

print Dumper \$acc_to_comp1;
# my %acc_to_comp; 

# subroutine to save accession comp pairs in a hash for each acc-comp files

sub acc_to_comp {
    # get infile (acc-to-comp correspondence file) and open
    my $list = shift;
    open (IN2, "<", $list) or die "Cannot open $list: $!\n";
    my %acc_to_comp;
    while(my $line = <IN2>){
        chomp $line;
	my @lines = split (/\s/, $line);
	my $comp = $lines[1];
	my $accession ='';
        if ($lines[0] =~ /.+?(Nfor\d+)/) {
            $accession .= $1;
	    $acc_to_comp{$accession} = $comp;
	} elsif ($lines[0] =~ /.+?(Lpar\d+)/) {
	    $accession .= $1;
	    $acc_to_comp{$accession} = $comp;
	}
    }
    #print Dumper \%acc_to_comp;
    return \%acc_to_comp;                                                                                    
}


__END__

sub acc_to_comp {
    # get infile (acc-to-comp correspondence file) and open                                                   
    my $list = shift;
    open (IN2, "<", $list) or die "Cannot open $list: $!\n";
    my %acc_to_comp;
    while(my $line = <IN2>){
        chomp $line;
        my @lines = split (/\t/, $line);
        # get accession names from fasta header stuff                                                         
        my $comp = $lines[1];
        my $accession;
        if (my $lines[0] =~ /.+?(Nfor\d+)/) {
            $accession = $1;
            $acc_to_comp{$accession} = $comp;
        } elsif (my $lines[0] =~ /.+?(Lpar\d+)/) {
            $acession = $1;
            $acc_to_comp{$accession} = $comp;
        }
    }
    print Dumper \%acc_to_comp;
    return \%acc_to_comp;
}
