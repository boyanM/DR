#!/usr/bin/perl
use POSIX;



$signal=0;
$distance = 0;
$help1=0;
$freq = 2472;

$signal =open my $FD, '-|', 'iw dev wlan1 | awk /signal:/{print $2}';
while (<$FD>) { print $_; }

$signal= abs($signal);

$helper=  27.55 + $signal - 20*log10($freq)  ;

$help1 = $helper/20;
$distance = pow(10,$help1);



print "$signal\n";
print "$distance\n"; 