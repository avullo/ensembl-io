use strict;
use warnings;

use Test::More;
use Test::Deep;

use Bio::EnsEMBL::IO::Parser::EMBLParser;

my $test_file = "data.embl";
my $parser = Bio::EnsEMBL::IO::Parser::EMBLParser->open($test_file);

$parser->next;
my $accessions = $parser->getAccessions();
is_deeply($accessions,[qw(X56734 S46826)],'Accessions from first record');

my $seq = 'aaacaaaccaaatatggattttattgtagccatatttgctctgtttgttattagctcattcacaattacttccacaaatgcagttgaagcttctactcttcttgacataggtaacctgagtcggagcagttttcctcgtggcttcatctttggtgctggatcttcagcataccaatttgaaggtgcagtaaacgaaggcggtagaggaccaagtatttgggataccttcacccataaatatccagaaaaaataagggatggaagcaatgcagacatcacggttgaccaatatcaccgctacaaggaagatgttgggattatgaaggatcaaaatatggattcgtatagattctcaatctcttggccaagaatactcccaaagggaaagttgagcggaggcataaatcacgaaggaatcaaatattacaacaaccttatcaacgaactattggctaacggtatacaaccatttgtaactctttttcattgggatcttccccaagtcttagaagatgagtatggtggtttcttaaactccggtgtaataaatgattttcgagactatacggatctttgcttcaaggaatttggagatagagtgaggtattggagtactctaaatgagccatgggtgtttagcaattctggatatgcactaggaacaaatgcaccaggtcgatgttcggcctccaacgtggccaagcctggtgattctggaacaggaccttatatagttacacacaatcaaattcttgctcatgcagaagctgtacatgtgtataagactaaataccaggcatatcaaaagggaaagataggcataacgttggtatctaactggttaatgccacttgatgataatagcataccagatataaaggctgccgagagatcacttgacttccaatttggattgtttatggaacaattaacaacaggagattattctaagagcatgcggcgtatagttaaaaaccgattacctaagttctcaaaattcgaatcaagcctagtgaatggttcatttgattttattggtataaactattactcttctagttatattagcaatgccccttcacatggcaatgccaaacccagttactcaacaaatcctatgaccaatatttcatttgaaaaacatgggatacccttaggtccaagggctgcttcaatttggatatatgtttatccatatatgtttatccaagaggacttcgagatcttttgttacatattaaaaataaatataacaatcctgcaattttcaatcactgaaaatggtatgaatgaattcaacgatgcaacacttccagtagaagaagctcttttgaatacttacagaattgattactattaccgtcacttatactacattcgttctgcaatcagggctggctcaaatgtgaagggtttttacgcatggtcatttttggactgtaatgaatggtttgcaggctttactgttcgttttggattaaactttgtagattagaaagatggattaaaaaggtaccctaagctttctgcccaatggtacaagaactttctcaaaagaaactagctagtattattaaaagaactttgtagtagattacagtacatcgtttgaagttgagttggtgcacctaattaaataaaagaggttactcttaacatatttttaggccattcgttgtgaagttgttaggctgttatttctattatactatgttgtagtaataagtgcattgttgtaccagaagctatgatcataactataggttgatccttcatgtatcagtttgatgttgagaatactttgaattaaaagtctttttttatttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
is($parser->getSequence(),$seq,'Sequence correctly cleaned up');

$parser->next;
$accessions = $parser->getAccessions();
note(join ' ',@$accessions);
cmp_deeply($accessions,[qw(P15056 A4D1T4 B6HY61 B6HY62 B6HY63 B6HY64 B6HY65 B6HY66 Q13878 Q3MIN6 Q9UDP8 Q9Y6T3)],'Accessions from second multiline record');
ok(!$parser->next, 'Check end-of-file behaviour');
$parser->close;

done_testing;