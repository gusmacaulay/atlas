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
  ::(on-watch:def path)
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
      ::  %json
      ::(poke-create:cc !<(json vase))
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
  ::  DEBUG
  ::  =/  jason  (en-json:html jd)
  ::  ~&  'JSON rendered'
  ::  ~&  jason
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
  ::  %geometry
  ::(geojson-feature (geometry geocontent))
  ==
::
::
++  geojson-featurecollection
  |=  fc=featurecollection
  ^-  json
  :: =/  count  (lent fc)
  :: ~&  'There are'  ~&  count  ~&  'features in the store'
  =/  fcj  [%a ?~(fc ~ (turn `(list feature)`fc geojson-feature))]
  ::~&  fcj
  =/  gjtype  (tape:enjs "FeatureCollection")
  ::[(frond:enjs ['type' gjtype]) (frond:enjs ['features' fcj]) ~])
  ::(pairs:enjs `(list [@t json])`[["type" gjtype] ["features" fcj] ~])
  ::`(list [@t json])` ([["type" gjtype] ["features" fcj] ~])
  =/  gjobj  (pairs:enjs ~[[%type gjtype] [%features fcj]])
  ::~&  gjobj
  gjobj
::
++  geojson-feature
  |=  f=feature
  ^-  json
  :: ~&  geometry.f
  =/  jg  (geojson-geom geometry.f)
  =/  gjtype  (tape:enjs "Feature")
  ::=/  fid  (numb:enjs fid.f)
  ::=/  fid  `unit`[~ fid.f]
  =/  fid  fid.f
  ~&  fid
  ?~  fid
    (pairs:enjs ~[[%type gjtype] [%geometry jg] [%properties properties.f]])
  =/  fidjs  (need fid)
  ::frond:enjs ['type' 'point']]
  ::(frond:enjs ['geometry' jg])
  =/  jf  (pairs:enjs ~[[%type gjtype] [%geometry jg] [%properties properties.f] [%id fidjs]])
  jf
::
++  geojson-geom
  |=  g=geometry
  ^-  json
  =/  anygeom  +3.g
  =/  gtype  +2.g
  ~&  gtype
  ?+    gtype  !!
    %point
   (geojson-point (point geom.anygeom))
    %polygon
   (geojson-polygon ((list linearring) geom.anygeom))
  ==
  ::(geojson-polygon ((list linearring) geom.particular))
 :: =/  gjtype  (tape:enjs "Polygon")
::  =/  llc  ((list linearring) geom.+3.g)
::  =/  jc  (geojson-polygon llc)
  :: =/  c  (coord ?~(coords ~ i.coords))
  :: =/  gjtype  (tape:enjs "Point")
  :: =/  c  (coord geom.+3.g)
  ::=/  jc  (geojson-point c)
::  =/  gj  (pairs:enjs ~[[%coordinates jc] [%type gjtype]])
::  gj
::
++  geojson-polygon
  |=  lr=(list linearring)
  ^-  json
  =/  gjrings  (turn lr geojson-linearring)
  =/  gjpoly  [%a gjrings]
  gjpoly
::
++  geojson-linearring
 |=  l=linearring
 ^-  json
 =/  coords  ((list coord) ?~(l ~ l))
 =/  jring  (turn coords geojson-point)
 [%a jring]
::
++  geojson-point
  |=  p=point
  ^-  json
  ::    ~&  ~[(anynumb lon.p) (anynumb lat.p)]
  ::=/  c  (coord geom.+3.g)
  =/  c  ~[lon.coord.p lat.coord.p]
  =/  ca  (turn c anynumb)
  ::  ~&  ca
  =/  gjc  [%a ca]
  =/  type  (tape:enjs "Point")
  =/  gj  (pairs:enjs ~[[%coordinates gjc] [%type type]])
  gj
::
:: How does any of this work?! what does it mean!!
++  anynumb
  |=  a=@rd
  ^-  json
  :-  %n
  %-  crip
  |-  ^-  ^tape
  (slag 2 (scow %rd a))
::
++  poke-create
  |=  gj=json
  ::  ~&  'poke json create'
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
  ~&  'geojson create next gen'
  ::  de-json:html returns a unit, so use 'need' to get past ~
  =/  jsonobject  (need (de-json:html gj))
  ::?+  typ  ~|([%unknown-geometry typ] !!)
  =/  uncastfeature  (dejs-feature jsonobject)
  ::=/  empty  ~
  ::=/  dumbobj  (json 'blah')
  ::=/  featuremap  (my [uncastfeature ~])
  ::=/  fidfeaturemap  (~(put by featuremap) "fid" [%id dumbobj])
  ~&  'uncast'
  ~&  uncastfeature
  =/  feature  (feature uncastfeature)
  ~&  'cast'
  ~&  feature
  ::=/  features  (weld data ~[feature])
  =/  content  (content [%feature feature])
  :-  [%give %fact ~[/atlas] %featurecollect !>(content)]~
  %=  state
    data  content
  ==
::
::++  dejs-gom
::  [%feature om]
::
++  dejs-feature
  |=  =json
  ~&  +2.json
  ?>  ?=([%o *] json)
  =/  fidob  (~(get by p.json) 'id')
  ?~  fidob
    (dejs-feature-fidless json)
  (dejs-feature-fid json)
::
++  dejs-feature-fidless
  |=  =json
  ::%-  ot
  ::(weld (dejs-feature-core json) ~[[%o ~]])
  ?>  ?=([%o *] json)
  =/  geomob  (dejs-geometry (need (~(get by p.json) 'geometry')))
  =/  propsob  (need (~(get by p.json) 'properties'))
  =/  fidob  ~
  =/  core  ~[geomob propsob fidob]
  core
  ::==
++  dejs-feature-core
  :~  [%geometry dejs-geometry]
      [%properties json]
  ==
::
++  dejs-feature-fid
  ::^-  feature
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
++  dejs-geometry
  =,  dejs:format
  |=  =json
  ^-  geometry
  ?>  ?=([%o *] json)
  :: ~&  '====='
  :: ~&  json
  :: ~&  '====='
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
::++  poke-feature
::  |=  f=feature
::  ^-  (quip card _state)
::  :: =/  features  (weld data ~[f])
::  :-  [%give %fact ~[/atlas] %featurecollect !>(f)]~
::  %=  state
::    data  f
::  ==
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
