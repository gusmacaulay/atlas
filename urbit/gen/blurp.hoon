::  A very simple naked generator which takes a pair of lat=@rd
::  Returns a point geometry feature, useful test data for store pokes
::  Usage +blurp [.~38 .~-140]
/-  *geo
|=  c=[@rd @rd]
=/  geom  [%point c]
=/  props  (my ~[[%cheese 'camambert']])
`feature`[geom props]
