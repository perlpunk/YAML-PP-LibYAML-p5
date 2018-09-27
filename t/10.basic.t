#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use YAML::PP;
use YAML::PP::LibYAML;
use YAML::PP::LibYAML::Parser;

my $events = [];
my $yaml = <<'EOM';
foo: &X bar
k: !!int "23"
FOO: *X
flow: { "a":23 }
EOM


my $yp = YAML::PP::LibYAML->new;

my $data = $yp->load_string($yaml);
my $expected = {
    foo => 'bar',
    k => 23,
    FOO => 'bar',
    flow => { a => 23 },
};
is_deeply($data, $expected, "load_string data like expected");

$yaml = <<'EOM';
foo: "bar"
 x: y
EOM
eval {
    $data = $yp->load_string($yaml);
};
my $error = $@;
cmp_ok($error, '=~', qr{did not find expected key}, "Invalid YAML - expected error message");

done_testing;
