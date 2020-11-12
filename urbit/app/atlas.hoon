/-  *geo
/+  *server, default-agent, dbug
::
|%
+$  card  card:agent:gall
::  the lack of proper state management means each update resets the store
::  this results in default geometry which is apparently a multipolygon!?
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero  [%0 data=featurecollection]
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
  ~&  'on poke!!!'
  ::~&  data
  =^  cards  state
    ?+    mark  (on-poke:def mark vase)
        %geometry
      ~&  'point says'
      (poke-geom:cc !<(geometry vase))
        %pleasant
      ~&  'pleasant printer!'
      (poke-pleasant:cc !<(~ vase))
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
++  poke-pleasant
  |=  *
  ~&  'more pleasant'
  ~&  data
  ~
::  |=  g=geometry
::  ^-  (quip card _state)
::  ~&  'pleasant to the max!'
::  :-  [%give %fact ~[/atlas] %geometry !>(g)]~
::  %=  state
::    data  geometry
::  ==
::
++  poke-geom
  |=  pon=geometry
  ^-  (quip card _state)
  ~&  'in poke-point (geom)'
  ~&  data
  :-  [%give %fact ~[/atlas] %geometry !>(pon)]~
  %=  state
    data  pon
  ==
--
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
