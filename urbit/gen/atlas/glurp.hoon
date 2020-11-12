::  A very simple %say generator which takes a pair of lat=@rd
::  Returns a point geometry
::  Usage +blurp [.~38 .~-140]
/-  *geo
:-  %say
::  need to wrap generator input with %say *stuff*,
::  the coords are all I care about
|=  [* [c=[@rd @rd] ~] ~]
::=/  p  `point`c
=/  g  `geometry`[%point c]
~&  g
[%geometry g]
