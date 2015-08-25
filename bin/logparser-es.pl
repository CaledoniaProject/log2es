#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use feature 'say';
use lib '/secure/Common/src/cpan';

use Getopt::Long;
use Data::Dumper;
use LWP::UserAgent;
use JSON::XS;
use IO::Handle;

binmode(STDOUT, ':encoding(utf8)');

my $fh   = \*STDIN;
my $ua   = LWP::UserAgent->new (agent => 'LogParser-ES/0.0.1');
my %opts = (
    'regex' => undef,
    'stdin' => undef,
    'es'    => undef
);

GetOptions (\%opts, 'es|e=s', 'regex|r=s', 'help|h', 'stdin|s');
&help unless defined $opts{regex} and defined $opts{es};
&help if $opts{help};

for my $file (@ARGV)
{
    say '[-] Processing ', $file;
    open my $fh, '<', $file or do {
        say "[!] Could not read $file: $!";
        next;
    };

    my $i = 0;
    while (<$fh>)
    {
        parse_line ($_);
        say "[-] Processed $i lines" if ++ $i % 100 == 0;
    }

    say "[+] Finished $file ($i lines)";
}

#####

sub parse_line
{
    my ($line) = @_;
    if ($line =~ /$opts{regex}/)
    {
#        say Dumper (\%+);
        my $resp = $ua->post ($opts{es}, Content => encode_json (\%+));
        my $data = $resp->decoded_content;
        eval 
        {
            my $json = decode_json ($data);
            if (! $json->{created})
            {  
                say STDERR '[!] Failed to insert data ', $data; 
            }
        }; 
        if ($@) 
        {
            say STDERR '[!] ERROR json decode failed ', $data;
        }

        return 1;
    }

    return 0;
}

###



sub help
{
print<<EOF
Advanced Log Parser - ES \$VER 0.20

Example:
    $0 --regex '^(?<name>[^:]+):(?<password>[^:]+)' --es 'http://127.0.0.1:9200/forensics/logs/' /etc/passwd

Usage:
     $0  [options]

     --regex  | -r     regular expression to use (require named backreference!)
     --es     | -e     url of ElasticSearch
     --stdin           read file content from standard input

     --help   | -h     You're reading this!

EOF
;

exit (0);
}
