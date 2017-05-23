=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

package Bio::EnsEMBL::IO::Object::RDF;

use strict;
use warnings;
use Carp;

use Bio::EnsEMBL::Utils::RDF;

sub new {
  my ($class) = @_;
  
  my $self = {};
  bless $self, $class;
  
  return $self;
}

=head2 namespaces

=cut

sub namespaces {
  my $class = shift;
  my %prefix = shift;

  %prefix ||= %Bio::EnsEMBL::Utils::RDF::prefix;
    
  return bless { type => 'namespaces', prefix => \%prefix }, $class;
}

=head2 species

=cut

sub species {
    my $class = shift;
    my %args = @_;
    exists $args{taxon_id} or croak "Undefined species taxon_id";
    exists $args{scientific_name} or croak "Undefined species scientific name";
    exists $args{common_name} or croak "Undefined species common name";
    
    return bless { type => 'species', %args }, $class;
  }

sub create_record {
  my $self = shift;

  my $line;

  if($self->{type} eq 'namespaces') {
    return unless scalar keys %{$self->{prefix}};
    
    $line = join("\n", map { sprintf "\@prefix %s: %s .", $_, u($self->{prefix}{$_}) } keys %{$self->{prefix}});
  } elsif($self->{type} eq 'species') {
    my $taxon_id = $self->{taxon_id};
    my $scientific_name = $self->{scientific_name};
    my $common_name = $self->{common_name};

    # return global triples about the organism  
    $line = sprintf "%s\n%s\n%s\n%s",
      triple('taxon:'.$taxon_id, 'rdfs:subClassOf', 'obo:OBI_0100026'),
      triple('taxon:'.$taxon_id, 'rdfs:label', qq("$scientific_name")),
      triple('taxon:'.$taxon_id, 'skos:altLabel', qq("$common_name")),
      triple('taxon:'.$taxon_id, 'dc:identifier', qq("$taxon_id"));
  } else {
    croak "Unrecognised RDF object type";
  }

  return $line;
}
