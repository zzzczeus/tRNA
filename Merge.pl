#! /usr/bin/perl
use strict;
my $dir = "./";
my @file = `ls $dir`;
chomp @file;
foreach my $in (@file){
	my $out = $in;
	#BLCA-Tumor-Vs-Normal-Paired-Result.txt
	$out =~ s/.txt/.aaExp/;
	if ($in =~ /Tumor-Vs-Normal-Paired-Result.txt/){
		open (IN,"$in");
		open (OUT,">$out");
		##HASH;
		my %hash;
		$hash{"GCA"}="ala";
		$hash{"GCC"}="ala";
		$hash{"GCG"}="ala";
		$hash{"GCT"}="ala";
		$hash{"AGA"}="arg";
		$hash{"AGG"}="arg";
		$hash{"CGA"}="arg";
		$hash{"CGC"}="arg";
		$hash{"CGG"}="arg";
		$hash{"CGT"}="arg";
		$hash{"AAC"}="asn";
		$hash{"AAT"}="asn";
		$hash{"GAC"}="asp";
		$hash{"GAT"}="asp";
		$hash{"TGC"}="cys";
		$hash{"TGT"}="cys";
		$hash{"CAA"}="gln";
		$hash{"CAG"}="gln";
		$hash{"GAA"}="glu";
		$hash{"GAG"}="glu";
		$hash{"GGA"}="gly";
		$hash{"GGC"}="gly";
		$hash{"GGG"}="gly";
		$hash{"GGT"}="gly";
		$hash{"CAC"}="his";
		$hash{"CAT"}="his";
		$hash{"ATA"}="ile";
		$hash{"ATC"}="ile";
		$hash{"ATT"}="ile";
		$hash{"CTA"}="leu";
		$hash{"CTC"}="leu";
		$hash{"CTG"}="leu";
		$hash{"CTT"}="leu";
		$hash{"TTA"}="leu";
		$hash{"TTG"}="leu";
		$hash{"AAA"}="lys";
		$hash{"AAG"}="lys";
		$hash{"TTC"}="phe";
		$hash{"TTT"}="phe";
		$hash{"CCA"}="pro";
		$hash{"CCC"}="pro";
		$hash{"CCG"}="pro";
		$hash{"CCT"}="pro";
		$hash{"AGC"}="ser";
		$hash{"AGT"}="ser";
		$hash{"TCA"}="ser";
		$hash{"TCC"}="ser";
		$hash{"TCG"}="ser";
		$hash{"TCT"}="ser";
		$hash{"ACA"}="thr";
		$hash{"ACC"}="thr";
		$hash{"ACG"}="thr";
		$hash{"ACT"}="thr";
		$hash{"TAC"}="tyr";
		$hash{"TAT"}="tyr";
		$hash{"GTA"}="val";
		$hash{"GTC"}="val";
		$hash{"GTG"}="val";
		$hash{"GTT"}="val";
		$hash{"ATG"}="met";
		$hash{"TGG"}="trp";
		my %aa;
		foreach my $key (sort keys %hash){
			$aa{$hash{$key}}=0 if !exists $aa{$hash{$key}}
		}
		my %tumor;
		my %normal;
		while (<IN>){
			chomp;
			my @str = split /\t/,$_;
			if (exists $hash{$str[0]}){
				$tumor{$hash{$str[0]}}+=2**$str[6];
				$normal{$hash{$str[0]}}+=2**$str[7];
			}
		}
		foreach my $key (sort keys %tumor){
			my $x1=log($tumor{$key})/log(2);
			my $x2=log($normal{$key})/log(2);
			my $x3=$x1/$x2;
			my $x4;
			my $y=$in;
			if ($x1>$x2){
				$x4=$tumor{$key}/$normal{$key};
			}
			else {
				$x4=-1/($tumor{$key}/$normal{$key});
			}
			$y =~ s/-.*//g;
			print OUT "$key\t$tumor{$key}\t$normal{$key}\n";
			print "$y\t$key\t$tumor{$key}\t$normal{$key}\t$x4\n";
		}
	}
}
