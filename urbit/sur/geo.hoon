|%
:: coord is the basic coordinate the underpins all geometries
:: lon,lat order! (GeoJSON standard)
:: is there a cost to having lon,lat variables rather than unnamed pair?
:: TODO: what is the precision required by GeoJSON formate
:: TODO: variable precision? ala postgis etc.
+$  coord  [lon=@rd lat=@rd]
::  just for fun, the spatial equivalent of a loobean
+$  drooc  [lat=@rd lon=@rd]
+$  title     @t
+$  id  @ud

:: point is a geometry, consists of coord + and id
+$  point
  $:  geom=coord
      =id
  ==
:: is there an array structure more compact/efficient than list?
+$  linestring
  $:  geom=(list coord)
      =id
  ==
:: hmm without validation etc. a polygon is actually the same thing as a line?
+$  polygon
  $:  geom=(list coord)
      =id
  ==
+$  multipoint
  $:  geom=(list point)
      =id
  ==
+$  multilinestring
  $:  geom=(list linestring)
      =id
  ==
:: generic geometry type
:: TODO: figure out how this should work in hoon
:: will have implications for
+$  geometry
  $:  =id
  :: TODO: figure out how this should work
  ==
::
+$  geometrycollection
  $:  =id
      geom=(list geometry)
  ==
:: GeoJSON Feature Type
:: A geometry with properties (key:value pairs)
:: and a title and id
+$  feature
  $:  =id
      =title
      :: properties= optional map ::??
      :: =geometry :: Generic geometry
  ==
+$  featurecollection
  $:  =id
      features=(list feature) ::?? check geojson, might be a key value thing
  ==
:: Container for GeoJSON objects
:: This should map closely a GeoJSON document, which is either a ..
:: geometrycollection or a feature collection
+$  document
  $:  =id
      =title
      owner=@p
      :: bbox, optional
      ::list geometrycollection or featurecollection
  ==
:: Portal is a set of GeoJSON documents, probably a whole lot of other stuff too
:: ... TBD in stage 2 project
+$  portal
  $:  =id
      =title
      owner=@p
      documents=(list document)
  ==
--
