#!/usr/bin/env perl
# Original taken from wicked cool perl scripts 2006

use utf8;
use v5.12; # or later to get "unicode_strings" feature

use strict;
use warnings qw(FATAL utf8);    # fatalize encoding glitches
use open qw(:std :utf8);        # undeclared streams in UTF-8

use File::HomeDir qw(home);
use Getopt::Std;
use Term::ANSIColor;
use Encode;

@ARGV = map { decode_utf8($_, 1) } @ARGV;

getopts('islu');

our($opt_i, $opt_s, $opt_l, $opt_u, $opt_B);

sub wrp_{
    my ($str) = @_;
    return color('blue') .
           "[" .
           color('white') .
           $str  .
           color('blue') .
           "]" .
           color('reset');
}

sub colorize {
    my ($str, $color) = @_;
    return color($color) . $str . color('reset') . color('white')
}

sub fancy_delimiters {
    my (@args) = @_;

    my $color = @args[0];
    shift @args;

    my $arg = @args[0];
    shift @args;

    foreach my $p (@args) {
        $arg =~ s|$p|colorize($p, $color)|ge;       
    }

    return $arg
}

sub fancy_string {
    my ($old_name, $new_name) = @_;
    my $home = home();

    foreach my $c ($old_name, $new_name) {
        $c =~ s|^$home|colorize('~', 'green')|e;
        $c = fancy_delimiters('blue', $c, '·', '/');
        $c = fancy_delimiters('cyan', $c, 'x');
        $c =~ s|-\[|colorize('-[', 'blue')|e;
        $c =~ s|\]-|colorize(']-', 'blue')|e;
    }

    return
        wrp_(">>") . " " . color('white') .
        $old_name . color('green') . " -> " .
        color('white') . " $new_name\n" . color('reset');
}

foreach my $file_name (@ARGV) {
    # Compute the new name
    my $new_name = $file_name;
    if ($opt_l) {
        $new_name = encode_utf8(lc(decode_utf8($new_name)));
    } elsif ($opt_u) {
        $new_name = encode_utf8(uc(decode_utf8($new_name)));
    }

    $new_name =~ tr/ \t/··/;
    if(-d $new_name){
        $new_name =~ tr/\./·/;
    }  else {
        substr($new_name, 0, rindex($new_name, ".")) =~ y/\./·/;
    }
    $new_name =~ tr/;/:/;
    if ($opt_s){
        $new_name =~ tr/_/·/;
    } else {
        $new_name =~ tr/_/-/;
    }
    $new_name =~ s/\.-\./-/g;
    $new_name =~ s/·-·/-/g;

    $new_name =~ s/\,[_-]/-/g;

    $new_name =~ s/-\./-/g;
    $new_name =~ s/-·/-/g;

    $new_name =~ s/-+/-/g;

    $new_name =~ s/\.-/-/g;
    $new_name =~ s/·-/-/g;

    $new_name =~ s/\.:/:/g;
    $new_name =~ s/·:/:/g;

    $new_name =~ s/:\./:/g;
    $new_name =~ s/:·/:/g;

    $new_name =~ s/\.\./·/g;
    $new_name =~ s/··/·/g;

    $new_name =~ s/·\././g;

    if ($opt_B){
        $new_name =~ s/[\(\)<>\\]//g;
    } else {
        $new_name =~ s/[<>\\]//g;
        $new_name =~ tr/\(/\[/;
        $new_name =~ tr/\)/\]/;
    }
    $new_name =~ s/[\'\`]/=/g;
    $new_name =~ s/^[--]+//g;
    $new_name =~ s/\&/.and./g;
    $new_name =~ s/\$/.dol./g;
    $new_name =~ s/[,.]{2}/·/g;
    $new_name =~ s/^·//g;
    $new_name =~ s/·$//g;

    # Make sure the names are different
    if ($file_name ne $new_name){
        # If a file already exists by that name
        # compute a new name.
        if (-f $new_name){
            my $ext = 0;

            while (-f $new_name.".".$ext){
                $ext++;
            }
            $new_name = $new_name.".".$ext;
        }
        print fancy_string($file_name, $new_name);
        if ($opt_i){
            rename($file_name, $new_name);
        }
    }
}
