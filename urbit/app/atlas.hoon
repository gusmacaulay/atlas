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
:: TODO; need to preserve state across restarts/upgrades
+$  state-zero  [%0 store=fridge =dogalog]
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
++  on-init  on-init:def
::++  on-init
::  ^-  (quip card _this)
::  =/  launcha  [%launch-action !>([%add %atlas [[%basic 'atlas' '/~atlas/img/tile.png' '/~atlas'] %.y]])]
::  =/  filea  [%file-server-action !>([%serve-dir /'~atlas' /app/atlas %.n %.n])]
::  :_  this
::  :~  [%pass /srv %agent [our.bol %file-server] %poke filea]
::      [%pass /atlas %agent [our.bol %launch] %poke launcha]
::      ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ~&  'any on-watch '
  ::=/  base  `path`(snag 0 path)
  ::=/  id  (snag 1 path)
  ::=/  id
  ?+    path  (on-watch:def path)
      [%fridge *]
    :_  this
    [%give %fact ~ %json !>((fetch-document path))]~
      [%dogalog *]
    :_  this
    [%give %fact ~ %json !>((fetch-dogalog path))]~
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ~&  wire
  ~&  sign
  ::~&  `this
  ~&  'on agent!'
    ?+    wire  (on-agent:def wire sign)
        [%fridge *]
        ~&  'fridge wire!'
      ?+  -.sign  (on-agent:def wire sign)
          %fact
        ::=/  json  !<(json q.cage.sign)
        ::~&  (crip (en-json:html json))
        ~&  'woo'
        =^  cards  state
          (receive-poastcard:cc [!<(json q.cage.sign) src.bol])
        [cards this]
        ==
    ==
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
      (poke-json:cc !<(json vase))
      ::(poke-geojson-update:cc !<(json vase))
        %delete
      (poke-delete:cc !<(json vase))
        %share
      (send-poast:cc !<(json vase))
        %accept
      (subscribe-poastcard:cc !<(json vase))
        %unsubscribe
      (unsubscribe-poastcard !<(json vase))
      ::(receive-poastcard:cc !<(json vase))
      ::  %update
      ::(poke-update:cc !<(json vase))
    ==
  [cards this]
++  on-save  on-save:def
++  on-load  on-load:def
++  on-leave  on-leave:def
++  on-peek  on-peek:def
::  |=  pax=path
::  ~&  'ON PEEK!!'
::  (on-peek:def pax)
::
++  on-fail   on-fail:def
--
::
::|_  bol=bowl:gall

::
|_  bol=bowl:gall
::
::
:: Grab the geojson document specified by id in path eg. /fridge/0
++  fetch-document
  |=  =path
  ^-  json
  ~&  'FETCHNIG DOC'
  ~&  path
  :: TODO: is there a way to template these paths, below seems hacky
  =/  id  0
  ::=/  id  (slav %ud (snag 1 path))
  ~&  'NOT DED'
  ~&  id
  ?:  ?=(~(has by documents.store) id)
    (fetch-actual id)
  ~
++  fetch-actual
  |=  =id
  =/  doc  (need (~(get by documents.store) id))
  ~&  doc
  =/  jd  (geojson-document content.doc)
  ::=/  jason  (en-json:html jd)
  jd
:: Returns the dogalog, as json
++  fetch-dogalog
  |=  =path
  ^-  json
  ~&  '...fetching the dogalog'
  =/  pupper  ~(tap by entries.dogalog)
  =/  doggo  (turn pupper json-entry)
  ~&  (crip (en-json:html (pairs:enjs doggo)))
  (pairs:enjs doggo)
  ::json-keys
::
++  json-entry
  |=  [=path =entry]
  ^-  [@t json]
  ::=/  fridge-id  (need fridge-id.entry)
  =/  sender  [%sender (ship:enjs sender.entry)]
  =/  remote  [%remote-id (numb:enjs remote-id.entry)]
  ::=/  fridge-id  ~
  ::(need fridge-id.entry)
  ::~&  'Need fridge-id;'
  ::~&  (need fridge-id)
  =/  idjs  (biff fridge-id.entry numb:enjs)
  ::?~  (numb:enjs (need fridge-id))
  ::  [(spat path) (pairs:enjs ~[sender remote])]
  [(spat path) (pairs:enjs ~[sender remote [%fridge-id idjs]])]
  ::=/  entry-j  (pairs:enjs ~[sender remote])
  ::~&  (crip (en-json:html entry-j))
::
++  render-doc
  |=  =document
  =/  jd  (geojson-document content.document)
  jd
::
::  Diagnostic poke, ultimately should be a 'pleasant printer' for GeoJSON
::  A pleasant printer is like a pretty printer but calm
::  TODO: move this code in to the generator, which should fetch json from atlas
::  probably should be a scry
++  poke-pleasant
  |=  *
  ^-  (quip card _state)
  ::=/  doc  (need (~(get by documents.store) 0))
  ::=/  jd  (geojson-document content.doc)
  ::[(print-doc (need (~(get by documents.store) 0))) state]
  ::=/  printed  (~(run by documents.store) print-doc)
  ::=/  keys  ~(key by documents.store)
  ::~&  keys
  ~&  (fetch-dogalog ~)
  [~ state]
::
++  print-doc
  |=  =document
  =/  jd  (geojson-document content.document)
  ~&  (crip (en-json:html jd))
  document
::
++  send-poast
  |=  =json
  :: placeholder
  :: extract recipient
  ?>  ?=([%o *] json)
  ::=/  recp-ta
  =/  recp-unit  `(unit @p)`(slaw %p (so (~(got by p.json) 'recipients')))
  =/  recipient  (need recp-unit)
  ~&  recipient
  :_  state
  ~[[%pass /poke-wire %agent [recipient %atlas] %poke %json !>(json)]]
  ::(fridge-delete 0)
::
::  When a poastcard is received, should store a reference in the dogalog
::  Then if accepted, subscribe to it
++  receive-poastcard
  |=  [gj=json sender=@p]
  ~&  'poastcard recieved!!'
  ::=/  update  (update (dejs-update json))
  ::~&  id.update
  :: extract geojson
  ?>  ?=([%o *] gj)
  ~&  gj
  ::=/  gj  (~(got by p.json) 'geojson')
  =/  feature  (feature (dejs-feature gj))
  =/  content  (content [%feature feature])
  =/  document  (document (next-id nextid.store) content)
  ~&  'NEXT ID'
  ~&  nextid.store
  =/  fridge-id  `(unit)`(some nextid.store)
  =/  entry  (entry sender (next-id nextid.store) fridge-id)
  ~&  'ENTRY'
  ~&  entry
  ~&  'bout to do a thing'
  (fridge-create-entry [document entry])
  ::(fridge-create document)
::
++  unsubscribe-poastcard
  |=  =json
  ^-  (quip card _state)
  ?>  ?=([%o *] json)
  =/  remote-id  (so (~(got by p.json) 'remote-id'))
  ~&  remote-id
  =/  sender-unit  `(unit @p)`(slaw %p (so (~(got by p.json) 'sender')))
  =/  sender  (need sender-unit)
  :_  state
  ~[[%pass /fridge/(scot %ta remote-id) %agent [sender %atlas] %leave ~]]
::
:: Update the dogalog and pass %watch to the sender, which in turn sends a %fact
:: which is handled in the recievers on-agent
++  subscribe-poastcard
  |=  =json
  ^-  (quip card _state)
  ?>  ?=([%o *] json)
  ::=/  path  (~(got by p.json) 'path')
  =/  remote-id  (so (~(got by p.json) 'remote-id'))
  ::=/  path  (need path-unit)
  ~&  remote-id
  =/  sender-unit  `(unit @p)`(slaw %p (so (~(got by p.json) 'sender')))
  =/  sender  (need sender-unit)
  ~&  sender
  :_  state
  ::~[[%pass /fridge/(scot %ta remote-id) %agent [sender %atlas] %leave ~]]
  ~[[%pass /fridge/(scot %ta remote-id) %agent [sender %atlas] %watch /fridge/(scot %ta remote-id)]]
  ::~[[%pass /fridge %agent [sender %atlas] %poke %json !>(json)]]
  :::_  state
  ::~[[%pass path %agent [sender %atlas] %watch %json !>(json)]]
  ::~[[%pass /poke-wire %agent [sender %atlas] %watch %json !>(json)]]
  :::-  [%give %fact ~[/atlas] %document !>(contents)]~
  ::%=  state
  ::  store  contents
  ::  dogalog  pupper
  ::==

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
++  poke-json
  |=  =json
  ?>  ?=([%o *] json)
  ?:  (~(has by p.json) %ship)
    (receive-poastcard [json our.bol])
  ?:  (~(has by p.json) %id)
    (poke-geojson-update json)
  (feature-create (dejs-create json))
::  Geojson update, only works with feature for now
++  poke-geojson-update
  |=  =json
  ~&  'geojson update'
  =/  update  (update (dejs-update json))
  ~&  id.update
  =/  feature  (feature (dejs-feature geojson.update))
  =/  content  (content [%feature feature])
  =/  document  (document id.update content)
  ~&  document
  (fridge-update document)
::  Delete operation, removes document from the store
++  poke-delete
  |=  =json
  ^-  (quip card _state)
  =/  id  (id (dejs-id json))
  ~&  id
  (fridge-delete id)
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
::
++  dejs-create
%-  ot
  :~  [%geojson json]
==
::
++  dejs-update
%-  ot
  :~  [%id ne]
      [%geojson json]
==
::
++  dejs-id
%-  ot
  :~  [%id ne]
==
::
++  geometry-collection-create
  |=  =json
  =/  geometrycollection  (dejs-geometrycollection json)
  =/  content  (content [%geometrycollection geometrycollection])
  =/  document  (document nextid.store content)
  (fridge-create document)
::
++  geometry-create
  |=  =json
  =/  geometry  (dejs-geometry json)
  =/  content  (content [%geometry geometry])
  ::=/  contents  (weld ~[content] data)
  =/  document  (document nextid.store content)
  (fridge-create document)
::
++  feature-collection-create
  |=  =json
  =/  uncast  (dejs-featurecollection json)
  ~&  uncast
  =/  featurecollection  (featurecollection uncast)
  =/  content  (content [%featurecollection featurecollection])
  =/  document  (document nextid.store content)
  (fridge-create document)
::
++  feature-create
  |=  jsonobject=json
  =/  uncastfeature  (dejs-feature jsonobject)
  =/  feature  (feature uncastfeature)
  =/  content  (content [%feature feature])
  =/  id  (next-id nextid.store)
  =/  document  (document id content) :: ~[~])
  (fridge-create document)
::
++  fridge-delete
  |=  =id
  =/  deleted  (~(del by documents.store) id)
  =/  contents  (fridge nextid.store deleted)
  :-  [%give %fact ~[/fridge] %document !>(contents)]~
  %=  state
    store  contents
  ==
:: update is just delete + create with specified id
++  fridge-update
  |=  =document
  =/  deleted  (~(del by documents.store) id.document)
  =/  updated  (~(put by deleted) id.document document)
  =/  contents  (fridge nextid.store updated)
  :: TODO: whats actually going on here, what does %document do/effect?
  :-  [%give %fact ~[/fridge] %document !>(contents)]~
  %=  state
    store  contents
  ==
:: create, TODO: this should not be mixed up in the geojson building stuff
++  fridge-create-entry
  |=  [=document =entry]
  ~&  'Im in ur fridge creating entries'
  =/  id  (next-id nextid.store)
  =/  docs  (~(put by documents.store) id document)
  =/  contents  (fridge (add 1 id) docs)
  =/  pupper  (dogalog-upsert entry)
  :: TODO: whats actually going on here, what does %document do/effect?
  ~&  contents
  :-  [%give %fact ~[/fridge] %document !>(contents)]~
  %=  state
    store  contents
    dogalog  pupper
  ==
++  fridge-create
  |=  =document
  =/  id  (next-id nextid.store)
  ~&  'Calculated ID;'
  ~&  id
  =/  docs  (~(put by documents.store) id document)
  =/  entry  (entry our.bol id (some id))
  =/  contents  (fridge (add 1 id) docs)
  ::=/  contents  [(fridge (add 1 id) docs) (dogalog-upsert entry)]
  =/  pupper  (dogalog-upsert entry)
  :: TODO: whats actually going on here, what does %document do/effect?
  :-  [%give %fact ~[/fridge] %document !>(contents)]~
  %=  state
    store  contents
    dogalog  pupper
  ==
::
++  dogalog-upsert
  |=  =entry
  =/  ref  (path [`@t`(scot %p sender.entry) 'atlas' 'fridge' `@t`(scot %ud remote-id.entry) fridge-id.entry])
  ~&  'ENTRY TO BE INSERTED'
  ~&  entry
  ~&  'How to get the fridge id if it exists?'
  (~(put by entries.dogalog) ref entry)
::
++  next-id
  |=  next=id
  ~&  'THE CURRENT ID'
  ~&  next
  ^-  id
  =/  s  ~(val by documents.store)
  =/  l  (lent s)
  ?:  =(l 0)
    0
  next
  ::nextid.store
::
++  dejs-featurecollection
  |=  =json
  ?>  ?=([%o *] json)
  =/  features-js  (need (~(get by p.json) 'features'))
  ?>  ?=([%a *] features-js)
  =/  features  ((list feature) (turn p.features-js dejs-feature))
  ::  ~&  features
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
:: or dm me direct ~lomped-firser (Lumphead)
--
