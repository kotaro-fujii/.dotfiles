#!/usr/bin/env perl
use strict;
use warnings;
my $fg = "\x1b[38;5;";
my $bg = "\x1b[48;5;";
my $rs = "\x1b[0m";
my $color = 0;
sub get_color
{
  my ($color) = @_;
  my $number = sprintf '%3d', $color;
  return qq/${bg}${color}m ${number}${rs}${fg}${color}m ${number}${rs} /;
}
for (my $row = 0; $row < 32; ++$row)
{
  for (my $col = 0; $col < 8; ++$col)
  {
      print get_color($color);
      ++$color;
  }
  print "\n";
}
