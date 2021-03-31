/-  *geo
/+  *server, default-agent, dbug
=,  dejs:format
::
|%
+$  card  card:agent:gall

+$  versioned-state
  $%  state-zero
  ==
+$  state-zero  [%0 data=(list feature)]
--
=|  state-zero
=*  state  -
%-  agent:dbug
^-  agent:gall
=<
|_  bol=bowl:gall
+*  this      .
    def   ~(. (default-agent this %|) bol)
    cc    ~(. +> bol)
::++  on-init  on-init:def
++  on-init
  ^-  (quip card _this)
  =/  launcha  [%launch-action !>([%add %atlas [[%basic 'atlas' '/~atlas/img/tile.png' '/~atlas'] %.y]])]
  =/  filea  [%file-server-action !>([%serve-dir /'~atlas' /app/atlas %.n %.n])]
  :_  this
  :~  [%pass /srv %agent [our.bol %file-server] %poke filea]
      [%pass /atlas %agent [our.bol %launch] %poke launcha]
      ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ~&  'an on-watch '
::  ?:  ?=([%http-response *] path)
::    `this
::  ?.  =(/ path)
  =/  jd  (geojson-featurecollection data)
  =/  jason  (en-json:html jd)
  ~&  'JSON unrendered'
  ~&  jd
  ~&  'JSON rendered??'
  ~&  jason
  :_  this
  [%give %fact ~ %json !>(jd)]~
::
++  on-agent  on-agent:def
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=(%bound +<.sign-arvo)
    (on-arvo:def wire sign-arvo)
  [~ this]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  =^  cards  state
    ?+    mark  (on-poke:def mark vase)
        %feature
      (poke-feature:cc !<(feature vase))
        %pleasant
      (poke-pleasant:cc !<(~ vase))
        %geojson
      (poke-geojson-create:cc !<(@t vase))
        %json
      (poke-json-create:cc !<(json vase))
        %delete
      (poke-delete:cc !<(~ vase))
    ==
  [cards this]
++  on-save  on-save:def
++  on-load  on-load:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--
::
::|_  bol=bowl:gall

::
|_  bol=bowl:gall
::
::

::  Diagnostic poke, ultimately should be a 'pleasant printer' for GeoJSON
::  A pleasant printer is like a pretty printer but calm
++  poke-pleasant
  |=  *
  ^-  (quip card _state)
  =/  jd  (geojson-featurecollection data)
  ::(crip (en-json:html (pairs:enjs:format ['key' s+'pre-shared'] ['hash' s+(scot %uv eny)] ~)))
  =/  jason  (en-json:html jd)
    ~&  jason
  [~ state]
::
::  Delete operation, removes feature from the store
++  poke-delete
  |=  *
  ^-  (quip card _state)
  =/  features  (oust [0 1] data)
  :-  [%give %fact ~[/atlas] %featurecollect !>(features)]~
  %=  state
    data  features
  ==
::
++  geojson-featurecollection
  |=  fc=(list feature)
  ^-  json
  =/  count  (lent fc)
  ::~&  'There are'  ~&  count  ~&  'features in the store'
  =/  fcj  [%a ?~(fc ~ (turn fc geojson-feature))]
  ::~&  fcj
  =/  gjtype  (tape:enjs "FeatureCollection")
  ::[(frond:enjs ['type' gjtype]) (frond:enjs ['features' fcj]) ~])
  ::(pairs:enjs `(list [@t json])`[["type" gjtype] ["features" fcj] ~])
  ::`(list [@t json])` ([["type" gjtype] ["features" fcj] ~])
  =/  gjobj  (pairs:enjs ~[[%type gjtype] [%features fcj]])
  ~&  gjobj
  gjobj
::
++  geojson-feature
  |=  f=feature
  ^-  json
  ~&  geometry.f
  =/  jg  (geojson-geom geometry.f)
  =/  gjtype  (tape:enjs "Feature")
 ::frond:enjs ['type' 'point']]
  ::(frond:enjs ['geometry' jg])
  =/  jf  (pairs:enjs ~[[%type gjtype] [%geometry jg]])
  jf
::
++  geojson-geom
  |=  g=geometry
  ^-  json
::  ?=([%polygon *] g)
    ::geojson-polygon g
  ::?=([%point *] g)
  ::    (geojson-point point.g)
  ::?=([%linestring *] g)
  ::    (geojson-linestring g)
  ::==
  =/  gjtype  (tape:enjs "Point")
  =/  c  (coord geom.+3.g)
  =/  jc  (geojson-point c)
  ::=/  jp  (frond:enjs ['coordinates' jc]
  =/  gj  (pairs:enjs ~[[%coordinates jc] [%type gjtype]])
  gj
::
++  geojson-point
  |=  p=coord
  ^-  json
  ~&  ~[(anynumb lon.p) (anynumb lat.p)]
  =/  c  ~[lon.p lat.p]
  =/  ca  (turn c anynumb)
  ~&  ca
  =/  jc  [%a ca]
  jc
::
:: How does any of this work?! what does it mean!!
++  anynumb
  |=  a/@rd
  ^-  json
  :-  %n
  %-  crip
  |-  ^-  ^tape
  (slag 2 (scow %rd a))

::
++  poke-json-create
  |=  gj=json
  ~&  'poke json create'
  ~&  gj
  =/  feature  (feature (degjs gj))
  ~&  feature
  =/  features  (weld data ~[feature])
  :-  [%give %fact ~[/atlas] %featurecollect !>(features)]~
  %=  state
    data  features
  ==
::
++  poke-geojson-create
  |=  gj=@t
  ^-  (quip card _state)
  ~&  'geojson create next gen'
  ::  de-json:html returns a unit, so use 'need' to get past ~
  =/  feature  (feature (degjs (need (de-json:html gj))))
  ~&  feature
  =/  features  (weld data ~[feature])
  :-  [%give %fact ~[/atlas] %featurecollect !>(features)]~
  %=  state
    data  features
  ==
::
++  degjs
%-  ot
  :~  [%geometry dejs-geometry]
      ::[%properties (om so)] :: need to make properties optional/null
  ==
::
++  dejs-geometry
  =,  dejs:format
  |=  =json
  ^-  geometry
  ?>  ?=([%o *] json)
  ~&  '====='
  ~&  json
  ::~&  (~(got by p.json) 'coordinates')
  ::~&  (dejs-linestring json)
  ~&  '====='
  =/  typ=@t  (so (~(got by p.json) 'type'))
  ?+  typ  ~|([%unknown-geometry typ] !!)
      %'Polygon'  (dejs-polygon json)
      %'Point'  (dejs-point json)
      %'LineString'  (dejs-linestring json)
  ==
::
++  dejs-coord
  (at ~[ne ne])
::
++  dejs-linestring
  |=  =json
  ^-  geometry
  :-  %linestring
  ?>  ?=([%o *] json)
  %-  (ar dejs-coord)
  (~(got by p.json) 'coordinates')
  ::(turn p.(~(got by p.json) 'coordinates') dejs-coord)
::
++  dejs-point
  |=  =json
  ^-  geometry
  :-  %point
  ?>  ?=([%o *] json)
  %-  dejs-coord
  (~(got by p.json) 'coordinates')
::
++  dejs-polygon
  |=  =json
  ^-  geometry
  :-  %polygon
  ?>  ?=([%o *] json)
  ::~&  p.json
  %-  (ar (ar dejs-coord))
  (~(got by p.json) 'coordinates')
::
++  dejs-geometry-alt
  |=  =json
  ^-  geometry
  ~&  'point json'
  ~&  json
  =/  jsmap  +3:json
  =/  p  p.jsmap
  ~&  p
  ::~&  (~(got by json) 'coordinates')
  (geometry (point json))
  ::
  ::(geometry (point ~(got by json) 'coordinates'))
::
::  Poke feature, adds a feature to our featurecollection (the store, for now)
++  poke-feature
  |=  f=feature
  ^-  (quip card _state)
  =/  features  (weld data ~[f])
  :-  [%give %fact ~[/atlas] %featurecollect !>(features)]~
  %=  state
    data  features
  ==
--
::
::  Poke geom deprecated
::++  poke-geom
::  |=  g=geometry
::  ^-  (quip card _state)
::  ~&  'in poke-geom (geom)'
::  ~&  data
::  :-  [%give %fact ~[/atlas] %geometry !>(g)]~
::  %=  state
::    data  g
::  ==
::--
::
::++  poke-json
::  |=  jon=json
::  ^-  (quip card _state)
::  ~&  'in poke-json'
::  ~&  jon
::  :-  [%give %fact ~[/atlas] %json !>(jon)]~
::  %=  state
::    data  jon
::  ==
::--
