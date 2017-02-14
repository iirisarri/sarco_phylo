#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

##########################################################################################
#
# #################### Iker Irisarri. Feb 2017. Uppsala University ##################### #
#
# Reads in fasta files in current directory (*.fa) and generates a table of gene presence/
# absence for each taxa (hard-coded into the %occupancy hash)
#
##########################################################################################

my @genes;

my %occupancy = (	">Acipenser_baeri" => [""],
					">Alligator_sinensis" => [""],
					">Ambystoma_mexicanum" => [""],
					">Amia_calva" => [""],
					">Anas_platyrhynchos" => [""],
					">Andrias_davidianus" => [""],
					">Anolis_carolinensis" => [""],
					">Atelopus_zeteki" => [""],
					">Basiliscus_plumifrons" => [""],
					">Boa_constrictor" => [""],
					">Bombina_maxima" => [""],
					">Caiman_crocodilus" => [""],
					">Callorhinchus_milii" => [""],
					">Calotriton_asper" => [""],
					">Canis_familiaris" => [""],
					">Carcharodon_carcharias" => [""],
					">Caretta_caretta" => [""],
					">Carlia_rubrigularis" => [""],
					">Chamaeleo_chamaeleon" => [""],
					">Chelonoidis_nigra" => [""],
					">Chiloscyllium_griseum" => [""],
					">Chinemys_reevesii" => [""],
					">Crocodylus_niloticus" => [""],
					">Crotalus_adamanteus" => [""],
					">Cyclorana_alboguttata" => [""],
					">Cynops_pyrrhogaster" => [""],
					">Danio_rerio" => [""],
					">Dasypus_novemcinctus" => [""],
					">Discoglossus_pictus" => [""],
					">Dromaius_novaehollandiae" => [""],
					">Echis_coloratus" => [""],
					">Elgaria_multicarinata" => [""],
					">Emys_orbicularis" => [""],
					">Espadarana_prosoblepon" => [""],
					">Eublepharis_macularius" => [""],
					">Felis_catus" => [""],
					">Gallus_gallus" => [""],
					">Geotrypetes_seraphini" => [""],
					">Ginglymostoma_cirratum" => [""],
					">Homo_sapiens" => [""],
					">Hymenochirus_curticeps" => [""],
					">Hynobius_chinensis" => [""],
					">Iguana_iguana" => [""],
					">Lampropholis_coggeri" => [""],
					">Latimeria_chalumnae" => [""],
					">Lepidosiren_paradoxa" => [""],
					">Lepisosteus_oculatus" => [""],
					">Lepisosteus_platyrhinus" => [""],
					">Leucoraja_erinacea" => [""],
					">Loxodonta_africana" => [""],
					">Macropus_eugenii" => [""],
					">Megophrys_nasuta" => [""],
					">Meleagris_gallopavo" => [""],
					">Micrurus_fulvius" => [""],
					">Monodelphis_domestica" => [""],
					">Mus_musculus" => [""],
					">Neoceratodus_forsteri" => [""],
					">Neotrygon_kuhlii" => [""],
					">Notophthalmus_viridescens" => [""],
					">Opheodrys_aestivus" => [""],
					">Ophiophagus_hannah" => [""],
					">Ornithorhynchus_anatinus" => [""],
					">Pantherophis_guttatus" => [""],
					">Pelodiscus_sinensis" => [""],
					">Pelophylax_lessonae" => [""],
					">Pelophylax_nigromaculatus" => [""],
					">Pelusios_castaneus" => [""],
					">Phrynops_hilarii" => [""],
					">Pipa_pipa" => [""],
					">Pleurodeles_waltl" => [""],
					">Podarcis_sp." => [""],
					">Pogona_vitticeps" => [""],
					">Polypterus_senegalus" => [""],
					">Proteus_anguinus" => [""],
					">Protopterus_aethiopicus" => [""],
					">Protopterus_annectens" => [""],
					">Python_regius" => [""],
					">Raja_clavata" => [""],
					">Rana_chensinensis" => [""],
					">Rhinatrema_bivittatum" => [""],
					">Salamandra_salamandra" => [""],
					">Saproscincus_basiliscus" => [""],
					">Sarcophilus_harrisii" => [""],
					">Sceloporus_undulatus" => [""],
					">Scincella_lateralis" => [""],
					">Scyliorhinus_canicula" => [""],
					">Siren_lacertina" => [""],
					">Sistrurus_miliarius" => [""],
					">Sphenodon_punctatus" => [""],
					">Sternotherus_odoratus" => [""],
					">Struthio_camelus" => [""],
					">Taeniopygia_guttata" => [""],
					">Takifugu_rubripes" => [""],
					">Tarentola_mauritanica" => [""],
					">Thamnophis_elegans" => [""],
					">Trachemys_scripta" => [""],
					">Tupinambis_teguixin" => [""],
					">Typhlonectes_compressicauda" => [""],
					">Typhlonectes_natans" => [""],
					">Xenopus_tropicalis" => [""]
				);

opendir(DIR, ".") or die "cannot open directory";

my @infiles = grep(/\.fa$/,readdir(DIR));

foreach my $infile (@infiles) {

    open (IN, "<", $infile) or die "could not open $infile\n";

    # get gene name
    my @name = split ("_", $infile);
    my $gene = $name[0];
    # store genes in order
    push ( @genes, $gene);

    my %taxa_infile = ();

    while(<IN>){

	# get taxa from current infile

	while ( my $line =<IN>) {

	    chomp $line;

	    if ( $line =~ /^>.+/ ) {

		$taxa_infile{$line} = 1;
	    }

	    else {
		next;
	    }
	}
	# save in general hash %occupancy
	foreach my $k ( keys %occupancy ) {
	    
	    if ( !exists $taxa_infile{$k} ) {

                my @array_no = @{ $occupancy{$k} };

                push ( @array_no , "0");

                $occupancy{$k} = [@array_no];
	    }
	    else {

		my @array_yes = @{ $occupancy{$k} };

		push ( @array_yes , "1");

		$occupancy{$k} = [@array_yes];
	    }
	}
    }
}



#print Dumper \%occupancy;

# print table header
print "\t";
print join "\t", @genes, "\n";

# print table
foreach my $l ( sort keys %occupancy ) {

    print "$l\t";
    print join "\t", @{ $occupancy{$l} }, "\n";
}
