::  insert geojson :atlas|geojson-create '{  "type": "Feature",  "geometry": {    "type": "Point",    "coordinates": [124.5, 9.0]  },  "properties": {    "name": "Dinagat Islands"
::  usage as above, takes a @t representation of gjson and adds to atlas store
/-  *geo
:-  %say
|=  [* [gj=@t ~] ~]
::~&  gj
::=/  geojson  (need (de-json:html gj))
::ASM
=/  geojson  (need (de:json:html gj))
[%geojson geojson]
