#!/usr/bin/perl

use warnings;
use strict;

# Iker Irisarri, University of Konstanz. Oct 2015
# Script to extract sequences from fasta file and replace headers
# Originally to extract mt sequences from taxa present in the nuc tree

my $usage = "extract_translate_commont_tax.pl input.fa > stdout\n";
my $infile = shift;


=pod
my %mt_to_nc = ("Acipenser_" => "Acipenser_baerii_NC_017603",
				"Alligator_" => "Alligator_sinensis_NC_004448",
				"Ambystoma_" => "Ambystoma_mexicanum_NC_005797",
				"Amia_calva" => "Amia_calva_NC_004742",
				"Anas_platy" => "Anas_platyrhynchos_NC_009684",
				"Andrias_da" => "Andrias_davidianus_NC_004926",
				"Anolis_car" => "Anolis_carolinensis_NC_010972",
				"Basiliscus" => "Basiliscus_vittatus_NC_012829",
				"Boa_constr" => "Boa_constrictor_NC_007398",
				"Bombina_ma" => "Bombina_maxima_NC_011049",
				"Caiman_cro" => "Caiman_crocodilus_NC_002744",
				"Callorhinc" => "Callorhinchus_milii_NC_014285",
				"Calotriton" => "Calotriton_asper_EU880307",
				"Canis_fami" => "Canis_lupus_familiaris_NC_002008",
				"Carcharodo" => "Carcharodon_carcharias_NC_022415",
				"Caretta_ca" => "Caretta_caretta_NC_016923",
				"Chamaeleo_" => "Chamaeleo_chamaeleon_NC_012427",
				"Chiloscyll" => "Chiloscyllium_griseum_NC_017882",
				"Chinemys_r" => "Chinemys_reevesi_NC_006082",
				"Crocodylus" => "Crocodylus_niloticus_NC_008142",
				"Crotalus_a" => "Crotalus_horridus_NC_014400",
				"Cynops_pyr" => "Cynops_pyrrhogaster_EU880313",
				"Danio_reri" => "Danio_rerio_NC_002333",
				"Dasypus_no" => "Dasypus_novemcinctus_NC_001821",
				"Discogloss" => "Discoglossus_galganoi_NC_006690",
				"Dromaius_n" => "Dromaius_novaehollandiae_NC_002784",
				"Felis_catu" => "Felis_catus_NC_001700",
				"Gallus_gal" => "Gallus_gallus_NC_001323",
				"Geotrypete" => "Geotrypetes_seraphini_GQ244469",
				"Homo_sapie" => "Homo_sapiens_AF346972",
				"Hymenochir" => "Hymenochirus_boettgeri_NC_015615",
				"Hynobius_c" => "Hynobius_chinensis_NC_008088",
				"Iguana_igu" => "Iguana_iguana_NC_002793",
				"Latimeria_" => "Latimeria_chalumnae_AB257297",
				"Lepidosire" => "Lepidosiren_paradoxa_NC_003342",
				"Lepisost00" => "Lepisosteus_oculatus_NC_004744",
				"Lepisosteu" => "Lepisosteus_osseus_NC_008104",
				"Leucoraja_" => "Leucoraja_erinacea_NC_016429",
				"Loxodonta_" => "Loxodonta_africana_NC_000934",
				"Macropus_e" => "Macropus_robustus_NC_001794",
				"Meleagris_" => "Meleagris_gallopavo_NC_010195",
				"Micrurus_f" => "Micrurus_fulvius_NC_013481",
				"Monodelphi" => "Monodelphis_domestica_NC_006299",
				"Mus_muscul" => "Mus_musculus_musculus_NC_010339",
				"Neoceratod" => "Neoceratodus_forsteri_AJ584642",
				"Neotrygon_" => "Neotrygon_kuhlii_NC_021767",
				"Notophthal" => "Notophthalmus_viridescens_EU880323",
				"Ophiophagu" => "Ophiophagus_hannah_NC_011394",
				"Ornithorhy" => "Ornithorhynchus_anatinus_NC_000891",
				"Pantheroph" => "Pantherophis_slowinskii_NC_009769",
				"Pelodiscus" => "Pelodiscus_sinensis_NC_006132",
				"Pelophylax" => "Pelophylax_nigromaculatus_NC_002805",
				"Phrynops_h" => "Phrynops_hilarii_JN999705",
				"Pipa_pipa" => "Pipa_carvalhoi_NC_015617",
				"Pleurodele" => "Pleurodeles_poireti_EU880329",
				"Pogona_vit" => "Pogona_vitticeps_NC_006922",
				"Polypterus" => "Polypterus_senegalus_senegalus_NC_004418",
				"Proteus_an" => "Proteus_anguinus_NC_023342",
				"Protopte00" => "Protopterus_aethiopicus_NC_014764",
				"Protopteru" => "Protopterus_annectens_NC_018822",
				"Rana_chens" => "Rana_cf_chensinensis_QYCRCCH_C_NC_023529",
				"Rhinatrema" => "Rhinatrema_bivittatum_NC_006303",
				"Salamandra" => "Salamandra_salamandra_EU880331",
				"Sarcophilu" => "Sarcophilus_harrisii_NC_018788",
				"Sceloporus" => "Sceloporus_occidentalis_NC_005960",
				"Scyliorhin" => "Scyliorhinus_canicula_NC_001950",
				"Siren_lace" => "Siren_intermedia_GQ368661",
				"Sphenodon_" => "Sphenodon_punctatus_NC_004815",
				"Sternother" => "Sternotherus_carinatus_NC_017607",
				"Struthio_c" => "Struthio_camelus_NC_002785",
				"Taeniopygi" => "Taeniopygia_guttata_NC_007897",
				"Takifugu_r" => "Takifugu_rubripes_NC_004299",
				"Tarentola_" => "Tarentola_mauritanica_NC_012366",
				"Trachemys_" => "Trachemys_scripta_NC_011573",
				"Tupinambis" => "Tupinambis_teguixin_Tteg271",
				"Typhlonect" => "Typhlonectes_natans_NC_002471",
				"Xenopus_tr" => "Silurana_tropicalis_NC_006839");

=cut

my %mt_to_nc = ("Acipenser_baerii_NC_017603" => "Acipenser_",
				"Alligator_sinensis_NC_004448" => "Alligator_",
				"Ambystoma_mexicanum_NC_005797" => "Ambystoma_",
				"Amia_calva_NC_004742" => "Amia_calva",
				"Anas_platyrhynchos_NC_009684" => "Anas_platy",
				"Andrias_davidianus_NC_004926" => "Andrias_da",
				"Anolis_carolinensis_NC_010972" => "Anolis_car",
				"Basiliscus_vittatus_NC_012829" => "Basiliscus",
				"Boa_constrictor_NC_007398" => "Boa_constr",
				"Bombina_maxima_NC_011049" => "Bombina_ma",
				"Caiman_crocodilus_NC_002744" => "Caiman_cro",
				"Callorhinchus_milii_NC_014285" => "Callorhinc",
				"Calotriton_asper_EU880307" => "Calotriton",
				"Canis_lupus_familiaris_NC_002008" => "Canis_fami",
				"Carcharodon_carcharias_NC_022415" => "Carcharodo",
				"Caretta_caretta_NC_016923" => "Caretta_ca",
				"Chamaeleo_chamaeleon_NC_012427" => "Chamaeleo_",
				"Chiloscyllium_griseum_NC_017882" => "Chiloscyll",
				"Chinemys_reevesi_NC_006082" => "Chinemys_r",
				"Crocodylus_niloticus_NC_008142" => "Crocodylus",
				"Crotalus_horridus_NC_014400" => "Crotalus_a",
				"Cynops_pyrrhogaster_EU880313" => "Cynops_pyr",
				"Danio_rerio_NC_002333" => "Danio_reri",
				"Dasypus_novemcinctus_NC_001821" => "Dasypus_no",
				"Discoglossus_galganoi_NC_006690" => "Discogloss",
				"Dromaius_novaehollandiae_NC_002784" => "Dromaius_n",
				"Felis_catus_NC_001700" => "Felis_catu",
				"Gallus_gallus_NC_001323" => "Gallus_gal",
				"Geotrypetes_seraphini_GQ244469" => "Geotrypete",
				"Homo_sapiens_AF346972" => "Homo_sapie",
				"Hymenochirus_boettgeri_NC_015615" => "Hymenochir",
				"Hynobius_chinensis_NC_008088" => "Hynobius_c",
				"Iguana_iguana_NC_002793" => "Iguana_igu",
				"Latimeria_chalumnae_AB257297" => "Latimeria_",
				"Lepidosiren_paradoxa_NC_003342" => "Lepidosire",
				"Lepisosteus_oculatus_NC_004744" => "Lepisost00",
				"Lepisosteus_osseus_NC_008104" => "Lepisosteu",
				"Leucoraja_erinacea_NC_016429" => "Leucoraja_",
				"Loxodonta_africana_NC_000934" => "Loxodonta_",
				"Macropus_robustus_NC_001794" => "Macropus_e",
				"Meleagris_gallopavo_NC_010195" => "Meleagris_",
				"Micrurus_fulvius_NC_013481" => "Micrurus_f",
				"Monodelphis_domestica_NC_006299" => "Monodelphi",
				"Mus_musculus_musculus_NC_010339" => "Mus_muscul",
				"Neoceratodus_forsteri_AJ584642" => "Neoceratod",
				"Neotrygon_kuhlii_NC_021767" => "Neotrygon_",
				"Notophthalmus_viridescens_EU880323" => "Notophthal",
				"Ophiophagus_hannah_NC_011394" => "Ophiophagu",
				"Ornithorhynchus_anatinus_NC_000891" => "Ornithorhy",
				"Pantherophis_slowinskii_NC_009769" => "Pantheroph",
				"Pelodiscus_sinensis_NC_006132" => "Pelodiscus",
				"Pelophylax_nigromaculatus_NC_002805" => "Pelophylax",
				"Phrynops_hilarii_JN999705" => "Phrynops_h",
				"Pipa_carvalhoi_NC_015617" => "Pipa_pipa"	,
				"Pleurodeles_poireti_EU880329" => "Pleurodele",
				"Pogona_vitticeps_NC_006922" => "Pogona_vit",
				"Polypterus_senegalus_senegalus_NC_004418" => "Polypterus",
				"Proteus_anguinus_NC_023342" => "Proteus_an",
				"Protopterus_aethiopicus_NC_014764" => "Protopte00",
				"Protopterus_annectens_NC_018822" => "Protopteru",
				"Rana_cf_chensinensis_QYCRCCH_C_NC_023529" => "Rana_chens",
				"Rhinatrema_bivittatum_NC_006303" => "Rhinatrema",
				"Salamandra_salamandra_EU880331" => "Salamandra",
				"Sarcophilus_harrisii_NC_018788" => "Sarcophilu",
				"Sceloporus_occidentalis_NC_005960" => "Sceloporus",
				"Scyliorhinus_canicula_NC_001950" => "Scyliorhin",
				"Siren_intermedia_GQ368661" => "Siren_lace",
				"Sphenodon_punctatus_NC_004815" => "Sphenodon_",
				"Sternotherus_carinatus_NC_017607" => "Sternother",
				"Struthio_camelus_NC_002785" => "Struthio_c",
				"Taeniopygia_guttata_NC_007897" => "Taeniopygi",
				"Takifugu_rubripes_NC_004299" => "Takifugu_r",
				"Tarentola_mauritanica_NC_012366" => "Tarentola_",
				"Trachemys_scripta_NC_011573" => "Trachemys_",
				"Tupinambis_teguixin_Tteg271" => "Tupinambis",
				"Typhlonectes_natans_NC_002471" => "Typhlonect",
				"Silurana_tropicalis_NC_006839" => "Xenopus_tr");

open (IN, "<", $infile) or die "Can't open $infile\n";

my %in_seq;
my %out_seq;

my $header;
my $sequence;

# read sequence file
while ( my $line =<IN> ) {
	chomp $line;
	if ( $line =~ /^>(.+)/ ) {
		$header = $1;
		next;
	}
	else {
		$sequence = $line;
	}
	$in_seq{$header} = $sequence;
}

# translate taxa that are present in %mt_to_nc and remove the rest
# $k keys are full names (e.g. Silurana_tropicalis_NC_006839)
foreach my $k ( keys %in_seq ) {

	if ( exists $mt_to_nc{ $k } ) {
	
		# create new matrix with new taxon names 
		# and corresponding sequences for that species

		my $header_new = $mt_to_nc{$k};
		
		$out_seq{$header_new} = $in_seq{$k};

		print STDERR "$k replaced by $header_new\n";

	}
}

foreach my $key ( sort keys %out_seq ) {

	print ">$key\n";
	print "$out_seq{$key}\n";
}

my $num_seqs_before = scalar keys %in_seq;
my $num_seqs_after = scalar keys %out_seq; 

print STDERR "\nNum of sequences in input file:  $num_seqs_before\n";
print STDERR "\nNum of sequences in output file:  $num_seqs_after\n";
