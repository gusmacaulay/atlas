::  A very simple %say generator which takes a pair of lat=@rd
::  Returns a point geometry
::  Usage :atlas|glurp g 
/-  *geo
:-  %say
::  need to wrap generator input with %say *stuff*,
::  the coords are all I care about
|=  [* [f=feature ~] ~]
~&  f
[%feature f]
