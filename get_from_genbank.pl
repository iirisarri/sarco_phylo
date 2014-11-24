#!/usr/bin/perl -w
use strict;

use Bio::DB::GenBank;
use Bio::SeqIO;

my $seq;
my $gb = new Bio::DB::GenBank;
my $query = Bio::DB::Query::GenBank->new
#(-query   =>'txid41705[Organism:exp] AND mitochondri*',   #Protacanthopterygii 
#(-query   =>'txid32443[Organism:exp] AND mitochondri*',   #Teleostei 
#(-query   =>'txid9263[Organism:exp] AND mitochondri*',    #Marsupiales 
    (-query   =>$qry_string .' AND mitochondrial[title] AND genome[ti] NOT plasmid[title] NOT chromosome NOT chloroplast) OR ('.$qry_string.' AND mitochondrion[title] AND genome[ti] NOT plasmid[title] NOT chromosome NOT chloroplast)',    
     -db      => 'nucleotide');
