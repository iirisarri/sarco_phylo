#!/usr/bin/perl

use warnings;
use strict;

# annotate_tree_leaves.pl
# Iker Irisarri. University of Konstanz. Jul 2016
# Script to translate abbreviated to full taxon names in trees

my $infile = shift;

=pod
# nuclear data sets
my %id_to_species = (	"Canis_fami" => "Canis_lupus_familiaris",
						"Anas_platy" => "Anas_platyrhynchos",
						"Anolis_car" => "Anolis_carolinensis",
						"Callorhinc" => "Callorhinchus_milii",
						"Danio_reri" => "Danio_rerio",
						"Dasypus_no" => "Dasypus_novemcinctus",
						"Felis_catu" => "Felis_catus",
						"Gallus_gal" => "Gallus_gallus",
						"Homo_sapie" => "Homo_sapiens",
						"Latimeria_" => "Latimeria_chalumnae",
						"Lepisosteu" => "Lepisosteus_oculatus",
						"Lepisost00" => "Lepisosteus_platyrhinus",
						"Lepisoste1" => "Lepisosteus_platyrhinus",
						"Loxodonta_" => "Loxodonta_africana",
						"Macropus_e" => "Macropus_eugenii",
						"Meleagris_" => "Meleagris_gallopavo",
						"Monodelphi" => "Monodelphis_domestica",
						"Mus_muscul" => "Mus_musculus",
						"Ornithorhy" => "Ornithorhynchus_anatinus",
						"Pelodiscus" => "Pelodiscus_sinensis",
						"Sarcophilu" => "Sarcophilus_harrisii",
						"Taeniopygi" => "Taeniopygia_guttata",
						"Takifugu_r" => "Takifugu_rubripes",
						"Xenopus_tr" => "Silurana_tropicalis",
						"Acipenser_" => "Acipenser_baeri",
						"Alligator_" => "Alligator_mississippiensis",
						"Ambystoma_" => "Ambystoma_mexicanum",
						"Amia_calva" => "Amia_calva",
						"Andrias_da" => "Andrias_davidianus",
						"Atelopus_z" => "Atelopus_zeteki",
						"Basiliscus" => "Basiliscus_plumifrons",
						"Boa_constr" => "Boa_constrictor",
						"Bombina_ma" => "Bombina_maxima",
						"Caiman_cro" => "Caiman_crocodilus",
						"Calotriton" => "Calotriton_asper",
						"Carcharodo" => "Carcharodon_carcharias",
						"Caretta_ca" => "Caretta_caretta",
						"Carlia_rub" => "Carlia_rubrigularis",
						"Chamaeleo_" => "Chamaeleo_chamaeleon",
						"Chelonoidi" => "Chelonoidis_nigra",
						"Chiloscyll" => "Chiloscyllium_griseum",
						"Chinemys_r" => "Chinemys_reevesii",
						"Crocodylus" => "Crocodylus_niloticus",
						"Crotalus_a" => "Crotalus_adamanteus",
						"Cyclorana_" => "Cyclorana_alboguttata",
						"Cynops_pyr" => "Cynops_pyrrhogaster",
						"Discogloss" => "Discoglossus_pictus",
						"Dromaius_n" => "Dromaius_novaehollandiae",
						"Echis_colo" => "Echis_coloratus",
						"Elgaria_mu" => "Elgaria_multicarinata",
						"Emys_orbic" => "Emys_orbicularis",
						"Espadarana" => "Espadarana_prosoblepon",
						"Eublephari" => "Eublepharis_macularius",
						"Geotrypete" => "Geotrypetes_seraphini",
						"Ginglymost" => "Ginglymostoma_cirratum",
						"Hynobius_c" => "Hynobius_chinensis",
						"Hymenochir" => "Hymenochirus_curticeps",
						"Iguana_igu" => "Iguana_iguana",
						"Lamprophol" => "Lampropholis_coggeri",
						"Lepidosire" => "Lepidosiren_paradoxa",
						"Leucoraja_" => "Leucoraja_erinacea",
						"Megophrys_" => "Megophrys_nasuta",
						"Micrurus_f" => "Micrurus_fulvius",
						"Neoceratod" => "Neoceratodus_forsteri",
						"Neotrygon_" => "Neotrygon_kuhlii",
						"Notophthal" => "Notophthalmus_viridescens",
						"Opheodrys_" => "Opheodrys_aestivus",
						"Ophiophagu" => "Ophiophagus_hannah",
						"Pantheroph" => "Pantherophis_guttatus",
						"Pelophylax" => "Pelophylax_nigromaculatus",
						"Pelophyl00" => "Pelophylax_lessonae",
						"Pelophyla1" => "Pelophylax_lessonae",
						"Pelusios_c" => "Pelusios_castaneus",
						"Phrynops_h" => "Phrynops_hilarii",
						"Pipa_pipa_" => "Pipa_pipa",
						"Pleurodele" => "Pleurodeles_waltl",
						"Podarcis_s" => "Podarcis_sp.",
						"Pogona_vit" => "Pogona_vitticeps",
						"Polypterus" => "Polypterus_senegalus",
						"Proteus_an" => "Proteus_anguinus",
						"Protopte00" => "Protopterus_aethiopicus",
						"Protopter1" => "Protopterus_aethiopicus",
						"Protopteru" => "Protopterus_annectens",
						"Python_reg" => "Python_regius",
						"Raja_clava" => "Raja_clavata",
						"Rana_chens" => "Rana_chensinensis",
						"Rhinatrema" => "Rhinatrema_bivittatum",
						"Salamandra" => "Salamandra_salamandra",
						"Saproscinc" => "Saproscincus_basiliscus",
						"Sceloporus" => "Sceloporus_undulatus",
						"Scincella_" => "Scincella_lateralis",
						"Scyliorhin" => "Scyliorhinus_canicula",
						"Siren_lace" => "Siren_lacertina",
						"Sistrurus_" => "Sistrurus_miliarius",
						"Sphenodon_" => "Sphenodon_punctatus",
						"Sternother" => "Sternotherus_odoratus",
						"Struthio_c" => "Struthio_camelus",
						"Tarentola_" => "Tarentola_mauritanica",
						"Thamnophis" => "Thamnophis_elegans",
						"Trachemys_" => "Trachemys_scripta",
						"Tupinambis" => "Tupinambis_teguixin",
						"Typhlone00" => "Typhlonectes_compressicauda",
						"Typhlonec1" => "Typhlonectes_compressicauda",
						"Typhlonect" => "Typhlonectes_natans"
	);
=cut

# mitochondrial genomes
my %id_to_species = (	"Abronia_gr" => "Abronia_graminea",
						"Acipenser_" => "Acipenser_baerii",
						"Alligator_" => "Alligator_sinensis",
						"Ambystoma_" => "Ambystoma_mexicanum",
						"Amia_calva" => "Amia_calva",
						"Amphisbaen" => "Amphisbaena_schmidti",
						"Anas_platy" => "Anas_platyrhynchos",
						"Andrias_da" => "Andrias_davidianus",
						"Anolis_car" => "Anolis_carolinensis",
						"Ascaphus_t" => "Ascaphus_truei",
						"Atympanoph" => "Atympanophrys_shapingensis",
						"Basiliscus" => "Basiliscus_vittatus",
						"Boa_constr" => "Boa_constrictor",
						"Bombina_ma" => "Bombina_maxima",
						"Bufo_japon" => "Bufo_japonicus",
						"Caiman_cro" => "Caiman_crocodilus",
						"Callorhinc" => "Callorhinchus_milii",
						"Calotriton" => "Calotriton_asper",
						"Canis_lupu" => "Canis_lupus_familiaris",
						"Carcharodo" => "Carcharodon_carcharias",
						"Caretta_ca" => "Caretta_caretta",
						"Causus_def" => "Causus_defilippi",
						"Chamaeleo_" => "Chamaeleo_chamaeleon",
						"Chiloscyll" => "Chiloscyllium_griseum",
						"Chinemys_r" => "Chinemys_reevesi",
						"Chrysemys_" => "Chrysemys_picta_bellii",
						"Coleonyx_v" => "Coleonyx_variegatus",
						"Crocodylus" => "Crocodylus_niloticus",
						"Crotalus_h" => "Crotalus_horridus",
						"Cynops_pyr" => "Cynops_pyrrhogaster",
						"Danio_reri" => "Danio_rerio",
						"Dasypus_no" => "Dasypus_novemcinctus",
						"Discogloss" => "Discoglossus_galganoi",
						"Dromaius_n" => "Dromaius_novaehollandiae",
						"Euprepioph" => "Euprepiophis_perlacea",
						"Felis_catu" => "Felis_catus",
						"Gallus_gal" => "Gallus_gallus",
						"Geotrypete" => "Geotrypetes_seraphini",
						"Heleophryn" => "Heleophryne_regis",
						"Hemithecon" => "Hemitheconyx_caudicinctus",
						"Homo_sapie" => "Homo_sapiens",
						"Hyla_japon" => "Hyla_japonica",
						"Hymenochir" => "Hymenochirus_boettgeri",
						"Hynobius_c" => "Hynobius_chinensis",
						"Ichthyaetu" => "Ichthyaetus_relictus",
						"Ichthyophi" => "Ichthyophis_bombayensis",
						"Iguana_igu" => "Iguana_iguana",
						"Latimeria_" => "Latimeria_chalumnae",
						"Leiopelma_" => "Leiopelma_archeyi",
						"Lepidosire" => "Lepidosiren_paradoxa",
						"Lepisost00" => "Lepisosteus_oculatus",
						"Lepisosteu" => "Lepisosteus_osseus",
						"Leptobrach" => "Leptobrachium_boringii",
						"Leucoraja_" => "Leucoraja_erinacea",
						"Loxodonta_" => "Loxodonta_africana",
						"Macropus_r" => "Macropus_robustus",
						"Mauremys_m" => "Mauremys_mutica",
						"Meleagris_" => "Meleagris_gallopavo",
						"Micrurus_f" => "Micrurus_fulvius",
						"Monodelphi" => "Monodelphis_domestica",
						"Mus_muscul" => "Mus_musculus_musculus",
						"Neoceratod" => "Neoceratodus_forsteri",
						"Neotrygon_" => "Neotrygon_kuhlii",
						"Nerodia_si" => "Nerodia_sipedon",
						"Notophthal" => "Notophthalmus_viridescens",
						"Ophiophagu" => "Ophiophagus_hannah",
						"Ornithorhy" => "Ornithorhynchus_anatinus",
						"Pantheroph" => "Pantherophis_slowinskii",
						"Pelobates_" => "Pelobates_cultripes",
						"Pelodiscus" => "Pelodiscus_sinensis",
						"Pelodytes_" => "Pelodytes_cf._Punctatus",
						"Pelomedusa" => "Pelomedusa_subrufa",
						"Pelophylax" => "Pelophylax_nigromaculatus",
						"Phrynops_h" => "Phrynops_hilarii",
						"Pipa_carva" => "Pipa_carvalhoi",
						"Plestiodon" => "Plestiodon_elegans",
						"Pleurodele" => "Pleurodeles_poireti",
						"Podocnemis" => "Podocnemis_unifilis",
						"Pogona_vit" => "Pogona_vitticeps",
						"Polypterus" => "Polypterus_senegalus_senegalus",
						"Proteus_an" => "Proteus_anguinus",
						"Protopte00" => "Protopterus_aethiopicus",
						"Protopteru" => "Protopterus_annectens",
						"Psammobate" => "Psammobates_pardalis",
						"Python_reg" => "Python_regius",
						"Rana_cf__c" => "Rana_cf._Chensinensis",
						"Rhinatrema" => "Rhinatrema_bivittatum",
						"Rhincodon_" => "Rhincodon_typus",
						"Rhinophryn" => "Rhinophrynus_dorsalis",
						"Salamandra" => "Salamandra_salamandra",
						"Sarcophilu" => "Sarcophilus_harrisii",
						"Sceloporus" => "Sceloporus_occidentalis",
						"Scyliorhin" => "Scyliorhinus_canicula",
						"Silurana_t" => "Silurana_tropicalis",
						"Siren_inte" => "Siren_intermedia",
						"Sooglossus" => "Sooglossus_thomasseti",
						"Sphenodon_" => "Sphenodon_punctatus",
						"Sternother" => "Sternotherus_carinatus",
						"Struthio_c" => "Struthio_camelus",
						"Taeniopygi" => "Taeniopygia_guttata",
						"Takifugu_r" => "Takifugu_rubripes",
						"Tarentola_" => "Tarentola_mauritanica",
						"Trachemys_" => "Trachemys_scripta",
						"Tupinambis" => "Tupinambis_teguixin",
						"Typhlonect" => "Typhlonectes_natans",
						"Varanus_ni" => "Varanus_niloticus"
	);
						
open (IN, "<", $infile) or die "Cannot open file $infile\n";

my $tree;
my $line_count = 0;

while ( my $line =<IN> ) {
	chomp $line;
	$line_count++;
	$tree = $line;
	
	
	foreach my $key ( keys %id_to_species ) {
		
		$tree =~ s/$key/$id_to_species{$key}/g;
	 
	 	print STDERR "$key substituted by $id_to_species{$key}\n";
	
	}
	 
}
	 

# print tree

print "$tree\n";	 
	 
	 
	 
print STDERR "\n$line_count trees found and replaced\n";