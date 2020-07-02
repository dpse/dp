#!/usr/bin/perl
use warnings;
use strict;

die("Invalid argument count. Usage: extract-lang file lang [lang [lang]]...") if ($#ARGV < 1);

my $file = $ARGV[0];

my $text = do {
    local $/ = undef;
    open my $fh, "<", $file
        or die $!;
    <$fh>;
};

my @langs = ('en', 'es', 'de', 'kr', 'tr', 'jp', 'pt', 'se');
my @keeplangs = @ARGV[1..$#ARGV];

for my $lang (@langs) {
	next if ($lang ~~ @keeplangs);
	$text =~ s/\s*%?\s* \\$lang ( \{ (?: [^{}]* | (?1) )* \} )//mxg;
}

for my $lang (@keeplangs) {
	$text =~ s/\\$lang ( \{ ( (?: [^{}]* | (?1) )* ) \} )/${2}/mxg;
}

open my $fh, ">", "extracted\_$file"
    or die $!;
print $fh $text;
