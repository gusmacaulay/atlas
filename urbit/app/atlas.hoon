/-  *geo
/+  *server, default-agent, dbug
=,  dejs:format
::
|%
+$  card  card:agent:gall

+$  versioned-state
  $%  state-zero
  ==
::+$  state-zero  [%0 data=(list feature)]
+$  state-zero  [%0 data=content]
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
  ~&  'any on-watch '
  ?+    path  (on-watch:def path)
      [%portal ~]
    :_  this
    [%give %fact ~ %json !>((fetch-document path))]~
  ==
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
  ~&  'poke received'
  =^  cards  state
    ~&  mark
    ?+    mark  (on-poke:def mark vase)
      ::  %feature
      :: (poke-feature:cc !<(feature vase))
        %pleasant
      (poke-pleasant:cc !<(~ vase))
        %geojson
      (poke-geojson-create:cc !<(@t vase))
        %json
      (poke-geojson-create-js:cc !<(json vase))
        %delete
      (poke-delete:cc !<(json vase))
      ::  %update
      ::(poke-update:cc !<(json vase))
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
::
++  fetch-document
  |=  =path
  ^-  json
  ~&  'fetch (all) geojson from store'
  =/  jd  (geojson-document data)
  ~&  jd
  ::  DEBUG
  =/  jason  (en-json:html jd)
  ~&  'JSON rendered'
  ~&  jason
  ::jason
  jd

::  Diagnostic poke, ultimately should be a 'pleasant printer' for GeoJSON
::  A pleasant printer is like a pretty printer but calm
++  poke-pleasant
  |=  *
  ^-  (quip card _state)
  =/  jd  (geojson-document data)
  ::=/  jason  (en-json:html jd)
  ~&  (crip (en-json:html jd))
  [~ state]
::
::  Delete operation, removes feature from the store
++  poke-delete
  |=  *
  ^-  (quip card _state)
  ::=/  features  (oust [0 1] data)
  ~&  'deleted document'
  =/  content  [%empty ~]
  :-  [%give %fact ~[/atlas] %featurecollect !>(content)]~
  %=  state
    data  content
  ==
::
::  Update Operation, deletes and replaces document with input GeoJSON
++  poke-update
  |=  gj=json
  ~&  'poke update'
  ~&  gj
  =/  feature  (feature (dejs-feature gj))
  ~&  feature
  =/  features  ~[feature]
  :-  [%give %fact ~[/atlas] %featurecollect !>(features)]~
  %=  state
    data  features
  ==
::
++  geojson-document
  |=  =content
  ^-  json
  =/  geocontent  +3.content
  =/  ctype  +2.content
  ~&  ctype
  ?+    ctype  !!
    %featurecollection
  (geojson-featurecollection (featurecollection geocontent))
    %feature
  (geojson-feature (feature geocontent))
    %geometry
  (geojson-geometry (geometry geocontent))
    %geometrycollection
  (geojson-geometrycollection (geometrycollection geocontent))
  ==
::
++  geojson-featurecollection
  |=  fc=featurecollection
  ^-  json
  =/  fcj  [%a ?~(fc ~ (turn `(list feature)`fc geojson-feature))]
  =/  gjtype  (tape:enjs "FeatureCollection")
  =/  gjobj  (pairs:enjs ~[[%type gjtype] [%features fcj]])
  gjobj
::
++  geojson-feature
  |=  f=feature
  ^-  json
  =/  jg  (geojson-geometry geometry.f)
  =/  gjtype  (tape:enjs "Feature")
  =/  fid  fid.f
  ?~  (need fid)
    (pairs:enjs ~[[%type gjtype] [%geometry jg] [%properties properties.f]])
  =/  fidjs  (need fid)
  =/  jf  (pairs:enjs ~[[%type gjtype] [%geometry jg] [%properties properties.f] [%id fidjs]])
  jf
::
++  geojson-geometrycollection
  |=  gc=geometrycollection
  ^-  json
  =/  gcj  [%a ?~(gc ~ (turn geometries.gc geojson-geometry))]
  (pairs:enjs ~[[%type (tape:enjs "GeometryCollection")] [%geometries gcj]])
::
++  geojson-geometry
  |=  g=geometry
  ^-  json
  =/  anygeom  +3.g
  =/  gtype  +2.g
  ?+    gtype  !!
    %point
   (geojson-point (point geom.anygeom))
    %polygon
   (geojson-polygon ((list linearring) geom.anygeom))
    %linestring
   (geojson-linestring (linestring geom.anygeom))
    %multipoint
   (geojson-multipoint (multipoint geom.anygeom))
    %multilinestring
   (geojson-multilinestring (multilinestring geom.anygeom))
    %multipolygon
   (geojson-multipolygon (multipolygon geom.anygeom))
  ==
::
++  geojson-polygon
  |=  lr=(list linearring)
  ^-  json
  =/  gjring  (turn lr geojson-linearring)
  =/  gjrings  [%a gjring]
  =/  type  (tape:enjs "Polygon")
  =/  gj  (pairs:enjs ~[[%coordinates gjrings] [%type type]])
  gj
::
++  geojson-multipolygon
  |=  mp=(list (list linearring))
  ^-  json
  =/  gjpolygons  (turn mp polygon-partial)
  =/  gjpolygonsob  [%a gjpolygons]
  =/  type  (tape:enjs "MultiPolygon")
  =/  gj  (pairs:enjs ~[[%coordinates gjpolygonsob] [%type type]])
  gj
::
++  polygon-partial
  |=  lr=(list linearring)
  [%a (turn lr geojson-linearring)]
::
++  geojson-multilinestring
  |=  ml=multilinestring
  ^-  json
  =/  gjlines  (turn ((list linearring) ml) geojson-linearring)
  =/  gjlinesob  [%a gjlines]
  =/  type  (tape:enjs "MultiLineString")
  =/  gj  (pairs:enjs ~[[%coordinates gjlinesob] [%type type]])
  gj
::
++  geojson-linestring
  |=  l=linestring
  ^-  json
  =/  type  (tape:enjs "LineString")
  :: A linearring and a linestring are the same* thing
  (pairs:enjs ~[[%coordinates (geojson-linearring l)] [%type type]])
::
:: This should probably be called a coordlist or something
:: since it's working as linestring and multipoint as well
:: ... *a linearring actually has matching start and end coords
:: but that isn't validated here
++  geojson-linearring
  |=  l=linearring
  ^-  json
  =/  coords  ((list coord) ?~(l ~ l))
  =/  jring  (turn coords geojson-coord)
  =/  gjr  [%a jring]
  gjr
::
++  geojson-multipoint
  |=  mp=multipoint
  ^-  json
  =/  type  (tape:enjs "MultiPoint")
  (pairs:enjs ~[[%coordinates (geojson-linearring mp)] [%type type]])
::
++  geojson-point
  |=  p=point
  ^-  json
  =/  c  ~[lon.coord.p lat.coord.p]
  =/  ca  (turn c reald)
  =/  gjc  [%a ca]
  =/  type  (tape:enjs "Point")
  =/  gj  (pairs:enjs ~[[%coordinates gjc] [%type type]])
  gj
::
++  geojson-coord
  |=  =coord
  =/  c  ~[lon.coord lat.coord]
  =/  ca  (turn c reald)
  [%a ca]
:: How does any of this work?! what does it mean!!
++  reald
  |=  a=@rd
  ^-  json
  :-  %n
  %-  crip
  |-  ^-  ^tape
  (slag 2 (scow %rd a))
::
++  poke-geojson-create-js
  |=  gj=json
  ~&  'poke json format create'
  ::  ~&  gj
  =/  feature  (feature (dejs-feature gj))
  ::  ~&  feature
  ::=/  features  (weld data ~[feature])
  =/  content  (content [%feature feature])
  :-  [%give %fact ~[/atlas] %featurecollect !>(content)]~
  %=  state
    data  content
  ==
::
++  poke-geojson-create
  |=  gj=@t
  ^-  (quip card _state)
  ~&  'GEOJSON POKE'
  ::  de-json:html returns a unit, so use 'need' to get json
  =/  gjo  (need (de-json:html gj))
  ::  Check if is of json object form, otherwise can't pull apart
  ?>  ?=([%o *] gjo)
  :: Extract the type field and parse as needed
  =/  typ=@t  (so (~(got by p.gjo) 'type'))
  :: TODO: case insensitivity? check geojson spec.
  ?+  typ  ~|([%unknown-geojson-type typ] !!)
    %'Feature'  (feature-create gjo)
    %'FeatureCollection'  (feature-collection-create gjo)
    %'LineString'  (geometry-create gjo)
    %'MultiLineString'  (geometry-create gjo)
    %'Polygon'  (geometry-create gjo)
    %'Point'  (geometry-create gjo)
    %'MultiPoint'  (geometry-create gjo)
    %'MultiPolygon'  (geometry-create gjo)
    %'GeometryCollection'  (geometry-collection-create gjo)
  ==
::
++  geometry-collection-create
  |=  =json
  =/  geometrycollection  (dejs-geometrycollection json)
  =/  content  (content [%geometrycollection geometrycollection])
  :-  [%give %fact ~[/atlas] %content !>(content)]~
  %=  state
    data  content
  ==
::
++  geometry-create
  |=  =json
  =/  geometry  (dejs-geometry json)
  =/  content  (content [%geometry geometry])
  :-  [%give %fact ~[/atlas] %content !>(content)]~
  %=  state
    data  content
  ==
::
++  feature-collection-create
  |=  =json
  =/  uncast  (dejs-featurecollection json)
  ~&  uncast
  =/  featurecollection  (featurecollection uncast)
  =/  content  (content [%featurecollection featurecollection])
  :-  [%give %fact ~[/atlas] %featurecollect !>(content)]~
  %=  state
    data  content
  ==
::
++  feature-create
  |=  jsonobject=json
  =/  uncastfeature  (dejs-feature jsonobject)
  =/  feature  (feature uncastfeature)
  =/  content  (content [%feature feature])
  :-  [%give %fact ~[/atlas] %featurecollect !>(content)]~
  %=  state
    data  content
  ==
::
++  dejs-featurecollection
  |=  =json
  ?>  ?=([%o *] json)
  =/  features-js  (need (~(get by p.json) 'features'))
  ?>  ?=([%a *] features-js)
  =/  features  ((list feature) (turn p.features-js dejs-feature))
  ~&  features
  features
::
++  dejs-feature
  |=  =json
  ?>  ?=([%o *] json)
  =/  fidob  (~(get by p.json) 'id')
  ?~  fidob
    (dejs-feature-fidless json)
  (dejs-feature-fid json)
::
++  dejs-feature-fidless
  |=  =json
  ?>  ?=([%o *] json)
  =/  geomob  (dejs-geometry (need (~(get by p.json) 'geometry')))
  =/  propsob  (need (~(get by p.json) 'properties'))
  =/  fidob  ~
  =/  core  ~[geomob propsob fidob]
  core
::
++  dejs-feature-fid
  %-  ot
    :~  [%geometry dejs-geometry]
        [%properties json]
        [%id dejs-fid]
  ==
::
++  dejs-fid
  |=  =json
  (fid (some json))
::
++  dejs-geometrycollection
  |=  =json
  ^-  geometrycollection
  ?>  ?=([%o *] json)
  =/  collection-js  (need (~(get by p.json) 'geometries'))
  ?>  ?=([%a *] collection-js)
  =/  geometries  (geometrycollection (turn p.collection-js dejs-geometry))
  geometries
::
++  dejs-geometry
  |=  =json
  ^-  geometry
  ?>  ?=([%o *] json)
  =/  typ=@t  (so (~(got by p.json) 'type'))
  ?+  typ  ~|([%unknown-geometry typ] !!)
      %'Polygon'  (dejs-polygon json)
      %'Point'  (dejs-point json)
      %'LineString'  (dejs-linestring json)
      %'MultiLineString'  (dejs-multilinestring json)
      %'MultiPoint'  (dejs-multipoint json)
      %'MultiPolygon'  (dejs-multipolygon json)
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
::
++  dejs-multilinestring
  |=  =json
  ^-  geometry
  :-  %multilinestring
  ?>  ?=([%o *] json)
  %-  (ar (ar dejs-coord))
  (~(got by p.json) 'coordinates')
::
++  dejs-point
  |=  =json
  ^-  geometry
  :-  %point
  ?>  ?=([%o *] json)
  %-  dejs-coord
  (~(got by p.json) 'coordinates')
::
++  dejs-multipoint
  |=  =json
  ^-  geometry
  ?>  ?=([%o *] json)
  :-  %multipoint
  %-  (ar dejs-coord)
  (~(got by p.json) 'coordinates')
::
++  dejs-polygon
  |=  =json
  ^-  geometry
  :-  %polygon
  ?>  ?=([%o *] json)
  %-  (ar (ar dejs-coord))
  (~(got by p.json) 'coordinates')
::
++  dejs-multipolygon
  |=  =json
  ^-  geometry
  :-  %multipolygon
  ?>  ?=([%o *] json)
  %-  (ar (ar (ar dejs-coord)))
  (~(got by p.json) 'coordinates')
::
:: Hello neighbour, did you really read all my code? or did you skip to the end?
:: Please join my urbit GIS and cartography group if you want to know more
:: ~lomped-firser/areography
--
