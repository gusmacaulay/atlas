/-  *geo
/+  *server, default-agent, dbug
=,  dejs:format
::
|%
+$  card  card:agent:gall
::  the lack of proper state management means each update resets the store
::  this results in default geometry which is apparently a multipolygon!?
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
  :_  this
  [%give %fact ~ %point !>(data)]~
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
++  geojson-featurecollection
  |=  fc=(list feature)
  ^-  json
  =/  fcj  [%a ?~(fc ~ (turn fc geojson-feature))]
  ~&  fcj
  (frond:enjs ['featurecollection' fcj])
::
++  geojson-feature
  |=  f=feature
  ^-  json
  ~&  f
  =/  c  ~[.~39 .~-140]
  =/  jc  [%a (turn c anynumb)]
  =/  jg  (frond:enjs ['point' jc])
  ::=/  jf  (frond:enjs ['feature' jg])
  (frond:enjs ['feature' jg])
::
++  anynumb
  |=  a/@r
  ^-  json
  :-  %n
  ?:  =(0 a)  '0'
  %-  crip
  %-  flop
  |-  ^-  ^tape
  ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
::
++  poke-geojson-create
  |=  gj=@t
  ^-  (quip card _state)
  ~&  'geojson create'
  ::  de-json:html returns a unit, so use 'need' to get past ~
  =/  intermediate  (degjs (need (de-json:html gj)))
  ~&  intermediate
  =/  geometry  (geometry %point (coord +3:intermediate))
  ~&  geometry
  =/  properties  +2:intermediate
  ~&  properties
  =/  feature  (feature geometry properties)
  ~&  feature
  =/  features  (weld data ~[feature])
  :-  [%give %fact ~[/atlas] %featurecollect !>(features)]~
  %=  state
    data  features
  ==
  ::?:  =(%o +2:unwrap)
  ::  ~&  'json object'
  ::  =/  jason  (degjs unwrap)
  ::    ~&  jason
  ::[~ state]
::
++  degjs
  %-  ot
::  :~  [%properties (om so)]
::      [%type so]
::      [%geometry (ot ([%type so]))]
  :~  'properties'^(om so)
      'geometry'^(ot 'coordinates'^(at ~[ne ne]) ~)
      ::'geometry'^(ot 'type'^so 'coordinates'^(at ne))
      ::'geometry'^(ot 'type'^so 'coordinates'^(at ~[ne ne]) ~)
  ==
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
