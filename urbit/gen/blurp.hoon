/-  *geo
::  A very simple naked generator which takes a coord pair of lat/lon=@rd
::  Returns a point geometry feature, useful test data for store pokes
::  Usage =f +blurp [.~38 .~-140]
|=  c=[@rd @rd]
=/  geom  [%point c]
=/  props  (my ~[[%cheese 'camambert']])
`feature`[geom props]
