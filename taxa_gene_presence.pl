#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my %taxa_infiles;

opendir(DIR, ".") or die "cannot open directory";

my @infiles = grep(/\.fa$/,readdir(DIR));

foreach my $infile (@infiles) {

    open (IN, "<", $infile) or die "could not open $infile\n";

    # get gene name
    #my @name = split ("_", $infile);
    #my $gene = $name[0];
    # store genes in order
    #push ( @genes, $gene);

    while ( my $line =<IN>) {

	chomp $line;

	next if ( $line !~ /^>.+/ );
	    
	if ( !exists $taxa_infiles{$line} ) {

	    $taxa_infiles{$line} = [$infile];
	}
        else {

	    my @array = @{ $taxa_infiles{$line} };

            push ( @array , $infile);

            $taxa_infiles{$line} = [@array];
      	}
    }
}


# print Dumper \%taxa_infiles;

foreach my $l ( sort keys %taxa_infiles ) {

    $l =~ />(.+)/;
    my $outfile = $1 . ".genes.txt";
    open (OUT, ">", $outfile);
    print STDERR "Printing $outfile\n";

    print OUT join "\n", @{ $taxa_infiles{$l} }, "\n";

    close(OUT)
}

print STDERR "\ndone!\n\n";
