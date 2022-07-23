::  Delete operation for spatial store.
::  :atlas|delete '{ "remote-id" : "1", "sender" : "~zod" }'
::  note, if the item is local then then the remote-id is th same as the local id
/-  *geo
:-  %say
|=  [* [oj=@t ~] ~]
=/  target  (need (de-json:html oj))
[%delete target]
