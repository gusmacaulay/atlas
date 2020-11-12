::  A very simple naked generator which takes a pair of lat=@rd
::  Returns a point geometry
::  Usage +blurp [.~38 .~-140]
/-  *geo
|=  c=[@rd @rd]
::=/  p  `point`c
=/  g  [%point c]
=/  m  (my ~[[%cheese 'camambert']])
`feature`[g m]
