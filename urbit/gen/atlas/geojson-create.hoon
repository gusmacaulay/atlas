/-  *geo
:-  %say
::  usage;
::  =gjson '{  "type": "Feature",  "geometry": {    "type": "Point",    "coordinates": [125.6, 10.1]  },  "properties": {    "name": "Dinagat Islands"  }}'
::  :atlas|geojson-create gjson
|=  [* [gj=@t ~] ~]
~&  gj
[%geojson gj]
