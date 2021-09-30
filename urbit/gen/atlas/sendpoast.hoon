::  create geojson on another ship, dodgy
/-  *geo
:-  %say
|=  [* [gj=@t ~] ~]
::~&  gj
=/  gjo  (need (de-json:html gj))
::~&  gjo
::~&  'Object above'
::  Check if is of json object form, otherwise can't pull apart
::?>  ?=([%o *] gjo)
[%share gjo]
