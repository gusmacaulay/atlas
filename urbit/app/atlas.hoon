/-  *geo
/+  *server, default-agent, dbug
::
|%
+$  card  card:agent:gall
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero  [%0 data=geometry]
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
  ~&  'on poke!!'
  ::~&  data
  =^  cards  state
    ?+    mark  (on-poke:def mark vase)
        %geometry
      ~&  'point says'
      (poke-point:cc !<(geometry vase))
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
++  poke-point
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
