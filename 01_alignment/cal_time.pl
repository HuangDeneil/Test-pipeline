#!/usr/bin/perl
use strict;
#########################################
# 
# 
# 
# 
# Usage :
# perl cal_time.sh $ARGV[0]
# 
# $ARGV[0] >>> time.txt 
# 
# perl cal_time.sh time.txt 
# 




if (!$ARGV[0])
{
    print "Input Error!!\n";
    print "Usage :\nperl cal_time.sh \$ARGV[0]\n";
    print "e.q. perl cal_time.sh time.txt \n";
    die;
}

my $tmp;
my @tmp;
my $count;
my $time;
my %time;

while(<$ARGV[0]>)
{
    chomp;
    if (/time bwa/)
    {
        $count++;
        if(/ (.+)\.fq\.gz/)
        {}
    }
    if ($count == 1)
    {
        $time=$_;
    }

}








