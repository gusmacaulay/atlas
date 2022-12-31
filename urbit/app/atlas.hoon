/-  *geo, geo-zero
/+  *server, default-agent, dbug
=,  dejs:format
::
|%
+$  card  card:agent:gall

+$  versioned-state
  $%  state-zero
      state-one
  ==
::+$  state-zero  [%0 data=(list feature)]
:: TODO; need to preserve state across restarts/upgrades
:: state-one includes a list of "pals" in each document  fridge[id, (map id document)] -> document[id, content, pals] -> pals[(list ship)] 
+$  state-zero  [%0 store=fridge:geo-zero =dogalog:geo-zero]
+$  state-one   [%1 store=fridge =dogalog]
--
%-  agent:dbug
:: =|  state-zero
=|  state-one
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
  :: Set the nextid to 0
  `this(store [0 documents.store])
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
  |=  pax=path
  ^-  (quip card _this)
  ~&  "In on-watch with path {<pax>} and src.bol {<src.bol>}"
  ?+    pax  (on-watch:def pax)
      [%fridge *]
    =/  path-id  +.pax
    =/  fridge-id  `@ud`(slav %ud (crip +.pax))
    =/  doc  (~(got by documents.store) fridge-id)

    ::  This is the bulk of the permissioning process
    ::  We scry for a list of groups that the ship is a member of
    ::  and use that along with the recipients.document.store to
    ::  determine if a ship has access to a given card.

    ::  Scry for groups that user is a member of (equivalent to http://localhost:8081/~/scry/groups/groups.json)
    =/  jsn  .^(json %gx /(scot %p our.bol)/groups/(scot %da now.bol)/groups/json)

    ?>  ?=([%o *] jsn)

    ::  Decode json to get a map of groups, each group containing a fleet (map of ships)
    =/  groups  `(map @t (map @t @da))`((om (ot ~[fleet+(om (ot ~[joined+di]))])) jsn)

    :: map to list
    =/  groups-list  ~(tap by groups)
    :: convert keys
    =/  groups-list-rec  `(list [recipient (map @t @da)])`(turn groups-list |=([key=@t val=(map @t @da)] =/(idx (need (find "/" (trip key))) [`recipient`[%group `@p`(slav %p (crip (scag idx (trip key)))) `tape`(slag idx (trip key))] val])))

    :: filter by skimming recipients list for the poastcard
    =/  recipient-list-gr  `(list recipient)`~(tap in recipients.doc)
    =/  recipient-groups  `(list recipient)`(skim recipient-list-gr |=(a=recipient =(-.a %group)))
    =/  filtered-groups  (skim groups-list-rec |=([g=recipient v=(map @t @da)] ?~((find [g]~ recipient-groups) %.n %.y)))

    :: list to map
    =/  groups-rec  `(map recipient (map @t @da))`(malt filtered-groups)

    ::  Accumulate all fleets into one set (all valid recipients from all valid groups).
    =/  fleet-acc-t  `(set @t)`(~(rep by groups-rec) |=([[key=recipient val=(map @t @da)] acc=(set @t)] `(set @t)`(~(uni in ~(key by val)) acc)))
    =/  fleet-acc  `(set recipient)`(~(run in fleet-acc-t) |=(shp=@t [%ship `@p`(slav %p shp)]))

    ::  Combine set of valid ships in groups, with set of valid direct recipients (sets provide deduplication)
    ::  Convert recipients set to list to skim off ships only
    =/  recipient-list  ~(tap in recipients.doc)
    =/  skimmed-recipients  `(list recipient)`(skim recipient-list |=(a=recipient =(-.a %ship)))

    ::  Convert ships only list back to a set to union with fleet
    =/  recipients-ships  `(set recipient)`(silt skimmed-recipients)
    =/  fleet-all  (~(uni in fleet-acc) recipients-ships)

    ?.  (~(has in fleet-all) [%ship src.bol]) :: check that ship requesting card is a valid recipient.
      ~&  "[on-watch]: Request from {<src.bol>} denied, not a valid recipient."
      !!  :: crash - request denied, not a valid recipient
    :_  this
    [%give %fact ~ %json !>((fetch-document pax))]~
      [%dogalog *]
    :_  this
    [%give %fact ~ %json !>((fetch-dogalog pax))]~
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
::  ~&  "on-agent: incoming on wire... {<wire>}"
    ?+    wire  (on-agent:def wire sign)
        [%fridge *]
::      ~&  "%fridge wire, with sign {<-.sign>}"
      ?+  -.sign  (on-agent:def wire sign)
          %poke-ack
            ?~  p.sign
              %-  (slog '%poke-ack: all fine.' ~)
              `this
            %-  (slog '%poke-ack: everything is bad' ~)
            `this
          %kick
            :: attempt to resubscribe when kicked
            %-  (slog 'on-agent: Got %kick, resubscribing...' ~)
            :_  this
            :~  [%pass wire %agent [src.bol %atlas] %watch wire]
            ==
          %fact
::        ~&  "Inside on-agent %fact"
        ?+  p.cage.sign  (on-agent:def wire sign)
            %update
            :: receive an update
              =/  the-update  `update`!<(update q.cage.sign)
              ?-  -.the-update
                  %change
                    %-  (slog 'on-agent -> %update -> %change.' ~)
                    =^  cards  state
                      (subscriber-update:cc [!<(update q.cage.sign) wire])
                    [cards this]
                  %delete
                    %-  (slog 'on-agent -> %update -> %delete.' ~)
                    =^  cards  state
                      (subscriber-delete:cc +.the-update)
                    [cards this]
                    ::`this
                  ==
            %json
            :: receive the card
              %-  (slog 'on-agent: %json' ~)
              =^  cards  state
                (receive-poastcard:cc [!<(json q.cage.sign) src.bol wire])
              [cards this]
         ==
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
  =^  cards  state
    ?+    mark  (on-poke:def mark vase)
      ::  %feature
      :: (poke-feature:cc !<(feature vase))
        %pleasant
      (poke-pleasant:cc !<(~ vase))
        %geojson
      (poke-geojson-create:cc !<(json vase))
        %json
      (poke-json:cc !<(json vase))
        %update
      (poke-geojson-update:cc !<(json vase))
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
++  on-save
  ^-  vase
  !>(state)
::++  on-load  on-load:def
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
    ?-  -.old
      %1  `this(state old)
      %0  `this(state 1+[[nextid.store.old (~(urn by documents.store.old) |=([key=@ud value=document.geo-zero] [id.value content.value ~]))] dogalog.old])
    ==
++  on-leave  on-leave:def
++  on-peek  ::on-peek:def
  |=  pax=path
  ^-  (unit (unit cage))
  ?~  (find "fridge" (trip (snag 1 pax)))  :: Check if it's a fridge peek.
    ``json+!>((fetch-dogalog pax))
    ``json+!>((fetch-document `path`(slag 1 pax)))  :: pax is `path`~['x' 'fridge' '0'], use the /fridge/0 portion of the address
::
++  on-fail   on-fail:def
--
::
::
::
|_  bol=bowl:gall
::
::
:: Grab the geojson document specified by id in path eg. /fridge/0
++  fetch-document
  |=  =path
  ^-  json
  :: TODO: is there a way to template these paths, below seems hacky
  ::=/  id  0
  =/  idpath  (snag 1 path)
  =/  id  (slav %ud idpath)
  ?:  ?=(~(has by documents.store) id)
    (fetch-actual id)
  !!
++  fetch-actual
  |=  =id
  ^-  json
  =/  doc  (need (~(get by documents.store) id))
  ::~&  doc
::  =/  jd  (geojson-document content.doc)
  =/  jd-new  (geojson-document-new doc) ::need to send whole doc so we can extract user list
::    jd
    jd-new
:: Returns the dogalog, as json
++  fetch-dogalog
  |=  =path
  ^-  json
  =/  pupper  ~(tap by entries.dogalog)
  =/  doggo  (turn pupper json-entry)
  ::~&  (crip (en-json:html (pairs:enjs doggo)))
  (pairs:enjs doggo)
::
++  json-entry
  |=  [=path =entry]
  ^-  [@t json]
  =/  sender  [%sender (ship:enjs sender.entry)]
  =/  remote  [%remote-id (numb:enjs remote-id.entry)]
  =/  idjs  (biff fridge-id.entry numb:enjs)
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
::  A pleasant printer is like a etty printer but calm
::  TODO: move this code in to the generator, which should fetch json from atlas
::  probably should be a scry
++  poke-pleasant
  |=  *
  ^-  (quip card _state)
  ~&  "================================================================"
  ::=/  doc  (need (~(get by documents.store) 0))
  ::=/  jd  (geojson-document content.doc)
  ::[(print-doc (need (~(get by documents.store) 0))) state]
  =/  printed  (~(run by documents.store) print-doc)
  ::=/  keys  ~(key by documents.store)
  ::~&  keys
  ~&  (fetch-dogalog ~)
  ~&  "nextid is: {<nextid.store>}"
  ~&  "================================================================"
  [~ state]
::
++  print-doc
  |=  =document
  =/  jd  (geojson-document content.document)
  ::  TODO: everything *but* the image
  ?>  ?=([%o *] jd)
  ::~&  (crip (en-json:html jd))
  =/  properties  (~(got by p.jd) 'properties')
  ?>  ?=([%o *] properties)
  =/  jt  (~(got by p.properties) 'title')
  ~&  jt
  document
::
++  send-poast
  |=  =json
::  ~&  "[send-poast]: sending poast"
  ?>  ?=([%o *] json)

  =/  recipient-list  (dejs-recipients json)

  ::  Skim the recipient-list and remove any ship/group recipients, as we can't send to groups yet.
  ::  Then extract only the ship names (this will also extract ship names from ship/group)
  =/  skimmed-recipients  `(list recipient)`(skim recipient-list |=(a=recipient =(-.a %ship)))
  =/  ships-only  `(list @p)`(turn skimmed-recipients |=(a=recipient ?-(-.a %ship +.a, %group +<.a)))

::  ~&  "[send-poast]: sending cards to: {<ships-only>}"

  :: JSON parse the fridge-id that's recieved from the front-end as a json *string*
  =/  this-id  (slav %ud (so (~(got by p.json) 'fridge-id')))

  :: Jab the *list* of new recipients into the recipient *set* of the current document
  :: and create and send out a poke for every ship recipient (group recipients do not get poked)

  :_  [-.state [nextid.store (~(jab by documents.store) this-id |=(e=document [-.e +<.e (~(gas in recipients.e) recipient-list)]))] dogalog]
  (turn ships-only |=(s=@p [%pass /poke-wire %agent [s %atlas] %poke %json !>(json)]))
::
::  When a poastcard is received, should store a reference in the dogalog
::  Then if accepted, subscribe to it
++  receive-poastcard
  |=  [gj=json sender=@p =wire]
::  ~&  "Poastcard received, wire is: {<wire>}"
  =/  idpath  (snag 1 wire)
  =/  remote-id  (slav %ud idpath)
  ?>  ?=([%o *] gj)
  =/  feature  (feature (dejs-feature gj))
  =/  content  (content [%feature feature])
  =/  document  (document nextid.store content ~)    ::  list of recipients is not sent with the card.
  =/  fridge-id  `(unit)`(some nextid.store)
::  ~&  "[receive-poastcard]: fridge-id: {<(need fridge-id)>}"
  =/  entry  (entry sender remote-id fridge-id)
  ::~&  "[receive-poastcard]: entry: {<entry>}"
  (fridge-create-entry [document entry])
::
++  unsubscribe-poastcard
  |=  =json
  ^-  (quip card _state)
  ?>  ?=([%o *] json)
  =/  remote-id  (so (~(got by p.json) 'remote-id'))
  ::~&  remote-id
  =/  sender-unit  `(unit @p)`(slaw %p (so (~(got by p.json) 'sender')))
  =/  sender  (need sender-unit)
  =/  pax  `path`['fridge' remote-id ~]
::  ~&  "unsubscribing from: {<pax>}"
  :_  state
  ~[[%pass pax %agent [sender %atlas] %leave ~]]
::
:: Update the dogalog and pass %watch to the sender, which in turn sends a %fact
:: which is handled in the recievers on-agent
++  subscribe-poastcard
  |=  =json
  ^-  (quip card _state)
  ?>  ?=([%o *] json)
  =/  remote-id  (so (~(got by p.json) 'remote-id'))
  ::~&  "remote-id {<remote-id>}"
  :: FIXME: using the remote-id twice is not right
  =/  pax  `path`['fridge' remote-id ~]
  =/  sender-unit  `(unit @p)`(slaw %p (so (~(got by p.json) 'sender')))
  =/  sender  (need sender-unit)
  ~&  "Subscribing to {<pax>} at ship {<sender>}"
  :_  state
  ~[[%pass pax %agent [sender %atlas] %watch pax]]
::
++  poke-geojson-create
  |=  gjo=json::gj=@t
  ^-  (quip card _state)
  ::~&  'In geojson poke'
  ::  de-json:html returns a unit, so use 'need' to get json
  ::=/  gjo  (need (de-json:html gj))
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
  ::~&  "poke json"
  ?>  ?=([%o *] json)
  ?:  (~(has by p.json) %fridge-id)
    =/  remote-id  (slav %ud (so (~(got by p.json) 'fridge-id')))
    =/  entry  (entry src.bol remote-id ~)
    =/  pupper  (dogalog-upsert entry)

    ::Check if poastcard is already in the dogalog (compare unique paths)
    ::If it is, then simply ignore it and return unchanged state.
    =/  remote-id-t  `tape`(sa (~(got by p.json) 'fridge-id'))
    =/  path-compare  `tape`(zing ["/" `tape`(scow %p src.bol) "/atlas/fridge/" remote-id-t ~])
    =/  path-compare-p  `path`(stab (crip path-compare))

::    ~&  "[poke-json]: giving document contents"
    
    :: Don't think this should be sending off facts!  Where are they going?  What are they doing?  Why would they be needed??
    :: No %facts to %give, just update state ([%give %fact ...] is sending update on a wire that's never watched)
    :: is this meant to be the front-end subscription???
    ?:  (~(has by entries.dogalog) path-compare-p)
        :-  [%give %fact ~[/fridge] %document !>(store)]~
        state
      :-  [%give %fact ~[/fridge] %document !>(store)]~
      %=  state
        dogalog  pupper
      ==
  ~
::
++  dejs-dogalog-entry
%-  ot
  :~  [%remote-id ne]
==
::  Geojson update, only works with feature for now
++  poke-geojson-update
  |=  =json
  ~&  "[poke-geojson-update]"
  =/  update  (change (dejs-update json))

  =/  feature  (feature (dejs-feature geojson.update))
  =/  content  (content [%feature feature])
::  =/  recipients  `(set recipient)`(silt (dejs-recipients properties.feature))
::  ~&  "Recipients set is: {<recipients>}"
  =/  document  (document id.update content ~)
::  =/  document  (document id.update content recipients)
  (fridge-update document)
::
::  Updating subscriber card when update received from card creator
++  subscriber-update
  |=  [=update =wire]
  =/  upd  (change +.update)
::  ~&  "[subscriber-update]: update is: {<upd>}"
  ~&  "[subscriber-update]: wire is: {<wire>}"
  :: use wire to find recipient fridge-id for card to update
  =/  path-t  `tape`(zing ["/" `tape`(scow %p src.bol) "/atlas" (trip (spat wire)) ~])
  =/  path-p  `path`(stab (crip path-t))
  =/  entry  (~(got by entries.dogalog) path-p)
  =/  fridge-id  (need fridge-id.entry)
  =/  feature  (feature (dejs-feature geojson.upd))
  =/  content  (content [%feature feature])

  =/  orig-doc  (~(got by documents.store) fridge-id)
  =/  document  (document fridge-id content recipients.orig-doc)
  (fridge-update document)
::
::  Delete from subscription (remote)
++  subscriber-delete
  |=  pax=path  :: dogalog entries path
  ^-  (quip card _state)
  =/  wire-pax  `path`+>.pax      ::  E.g. get "/fridge/0" from "~sut/atlas/fridge/0"
  =/  sender  `@p`(slav %p -.pax) ::  E.g. get "~sut" from "~sut/atlas/fridge/0"
  =/  entry  (~(got by entries.dogalog) pax)
  =/  new-fridge  ?~(fridge-id.entry store (fridge-delete (need fridge-id.entry)))
  =/  pupper  (dogalog-delete pax)
  :-  [[%pass wire-pax %agent [sender %atlas] %leave ~]]~
  %=  state
    store  new-fridge
    dogalog  pupper
  ==
::  Delete operation, removes document from the store
++  poke-delete
  |=  =json
  ^-  (quip card _state)
  ::  this should be a path now?
  ?>  ?=([%o *] json)
  =/  remote-id  (so (~(got by p.json) 'remote-id'))
  =/  sender-unit  `(unit @p)`(slaw %p (so (~(got by p.json) 'sender')))
  =/  sender  (need sender-unit)
  =/  pax  `path`[`@t`(scot %p sender) 'atlas' 'fridge' remote-id ~]

  ::  get the fridge-id, fridge needs to be updated with this rather
  ::  than the remote-id
  =/  entry  (~(got by entries.dogalog) pax)
  =/  new-fridge  ?~(fridge-id.entry store (fridge-delete (need fridge-id.entry)))  
  =/  pupper  (dogalog-delete pax)
  =/  wire-path  `path`['fridge' remote-id ~]
::  ~&  "[poke-delete] {<wire-path>}, giving new fridge"
  ?:  =(sender our.bol)
    :: Delete our own card, then send delete update to ships with that card 
    :: so they delete also, and leave the subscription.
    :-  [[%give %fact ~[wire-path] %update !>(`update`[%delete pax])]]~
    %=  state
      store  new-fridge
      dogalog  pupper
    ==
    :-  [[%pass wire-path %agent [sender %atlas] %leave ~]]~
    %=  state
      store  new-fridge
      dogalog  pupper
    ==
::
++  geojson-document
  |=  =content
  ^-  json
  =/  geocontent  +3.content
  =/  ctype  +2.content
  ::~&  ctype
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
++  geojson-document-new
  |=  =document
  ^-  json
  =/  geocontent  +3.content.document
  =/  ctype  +2.content.document

  :: if it's a feature, *add* recipients.document to properties.geocontent (feature)
  :: so that we can return it to the front-end.

  =/  the-feature  (feature geocontent)
  =/  recipients-list  ~(tap in recipients.document)

  :: Decode document content properties so that we can add in recipients
  =/  decoded-properties  ((om sa) properties.the-feature)

:: Reduce recipients down to a simple tape, of both ships & groups
  =/  recipient-tape  `(list tape)`(turn recipients-list |=(a=recipient ?-(-.a %ship (scow %p +.a), %group (weld (scow %p +<.a) +>.a))))
  :: comma separated list as a tape
  =/  insert-list  `tape`(reel recipient-tape |=([b=tape c=tape] ?:(=(c "") (weld b c) (weld b (weld "," c))))) 

  :: Insert the list of recipients into the document content properties
  =/  new-properties  (~(put by decoded-properties) 'recipients' insert-list)
  =/  raw-props-list  ~(tap by new-properties)
  =/  json-props-list  `(list [@t json])`(turn raw-props-list |=(a=[@t tape] [-.a s+(crip +.a)])) ::assumes all properties are tapes/strings
  =/  encoded-pairs  (pairs:enjs:format json-props-list)

  :: Updated content (for features only)
  =/  new-geocontent  the-feature(properties encoded-pairs)

  ?+    ctype  !!
    %featurecollection
  (geojson-featurecollection (featurecollection geocontent))
    %feature
  (geojson-feature new-geocontent)
::  (geojson-feature (feature geocontent))
    %geometry
  (geojson-geometry (geometry geocontent))
    %geometrycollection
  (geojson-geometrycollection (geometrycollection geocontent))
  ==
:::
:::
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
::  :~  [%id ne]
  :~  [%id ni]
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
  ::~&  uncast
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
  ::~&  "[feature-create]: id: {<nextid.store>}"
  =/  document  (document nextid.store content ~) :: ~[~])
  (fridge-create document)
::
++  fridge-delete
  |=  =id
  ^-  fridge
  =/  deleted  (~(del by documents.store) id)
::  ~&  "new fridge contains: {<~(key by deleted)>}"
  =/  contents  (fridge nextid.store deleted)
contents
::
:: update is just delete + create with specified id
++  fridge-update
  |=  =document
::  ~&  "[fridge-update]:"
  =/  old-document  (~(got by documents.store) id.document)
  =/  new-document  [id.document content.document recipients.old-document]  :: use existing recipients list & id
  =/  deleted  (~(del by documents.store) id.document)
  =/  updated  (~(put by deleted) id.document new-document)
  =/  contents  (fridge nextid.store updated)
  =/  path  `path`(stab (crip (weld "/fridge/" (scow %ud id.document))))
  :: create json from new document to send to subscribers
  =/  jd-new  (geojson-document-new new-document)
  
  :: Send out an update to subscribers if it's a local update from the front-end
  :: Otherwise we've received an update from another ship, and are updating only 
  :: the current ship.
  ?:  =(src.bol our.bol)
      :-  [%give %fact ~[path] %update !>(`update`[%change id.document jd-new])]~
      %=  state
        store  contents
      ==
    :-  [*card]~ 
    %=  state
      store  contents
    ==
::
:: create, TODO: this should not be mixed up in the geojson building stuff
++  fridge-create-entry
  |=  [=document =entry]
::  ~&  "[fridge-create-entry]: next-id becomes: {<(add 1 nextid.store)>}"
  =/  docs  (~(put by documents.store) nextid.store document)
  =/  contents  (fridge (add 1 nextid.store) docs)
  =/  pupper  (dogalog-upsert entry)
  :: TODO: whats actually going on here, what does %document do/effect?
  :-  [%give %fact ~[/fridge] %document !>(contents)]~
  %=  state
    store  contents
    dogalog  pupper
  ==
::
++  fridge-create
  |=  =document
  =/  docs  (~(put by documents.store) nextid.store document)
  :: FIXME: need to create an entry with *remote* id!!!!  
  :: ^^ This seems to be working anyway?  dogalog-upsert fixes it??
  =/  entry  (entry our.bol nextid.store (some nextid.store))
::  ~&  "[fridge-create]: entry: {<entry>}"
::  ~&  "[fridge-create]: updating fridge/store, nextid becomes: {<(add 1 nextid.store)>}"
  =/  contents  (fridge (add 1 nextid.store) docs)
  =/  pupper  (dogalog-upsert entry)
  :: TODO: whats actually going on here, what does %document do/effect?  Can we just return an empty card list?
::  :-  ~[~]  ::this doesn't work.  how do we return just a state change without any %facts to give?
  :-  [%give %fact ~[/fridge] %document !>(contents)]~
  %=  state
    store  contents
    dogalog  pupper
  ==
::
++  dogalog-delete
  |=  =path
::  ~&  'dogalog delete'
  (~(del by entries.dogalog) path)
::
++  dogalog-upsert
  |=  =entry
::  ~&  "[Dogalog-upsert]: entry to be inserted: {<entry>}"
  =/  ref  (path [`@t`(scot %p sender.entry) 'atlas' 'fridge' `@t`(scot %ud remote-id.entry) ~])
::  ~&  "[Dogalog-upsert]: ref: {<ref>}"
  (~(put by entries.dogalog) ref entry)
::
++  dejs-recipients
  |=  =json
  ?>  ?=([%o *] json)
  =/  recipients-js  (need (~(get by p.json) 'recipients'))
  ?>  ?=([%a *] recipients-js)
  =/  recipients  ((list recipient) (turn p.recipients-js dejs-recipient))
::  =/  recipients  (silt ((list recipient) (turn p.recipients-js dejs-recipient)))
  recipients
::
++  dejs-recipient
  |=  =json
  =/  recipient-tpe  (sa json)
  =/  idx  (find "/" recipient-tpe)
  ?~  idx
    [%ship `@p`(slav %p (crip recipient-tpe))]                   ::  [%ship ~sampel-palnet]
    =/  recipient-ship  (scag (need idx) recipient-tpe)
    =/  recipient-group  (slag (need idx) recipient-tpe)
    [%group `@p`(slav %p (crip recipient-ship)) recipient-group] ::  [%group ~sampel-palnet "/agroup"]
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
