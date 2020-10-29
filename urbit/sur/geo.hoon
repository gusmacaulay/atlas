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

:: point is a geometry, consists of coord
::
+$  point
  $:  =coord
  ==
:: is there an array structure more compact/efficient than list?
+$  linestring
  $:  =(list coord)
  ==

:: a linear ring is the building block of a polygon
:: a ring differs from a linestring, partly for conceptual/syntactic reasons
:: and also because in geojson and some other formats the last coord and first
:: of a ring are the same - although we don't need to store this redundant
:: coordinate only take it into account when rendering/parsing.
:: See macwright.org for a nice summary
+$  linearring
  $:  =(list coord)
  ==
::
:: A polygon is a list of rings - the first list is the "outer" ring
:: and the subsequent lists are the "inner rings" (donut holes)
+$  polygon
  $:  =(list linearring)
  ==
::
:: A multipoint is a list of poins
+$  multipoint
  $:  =(list point)
  ==
::
:: A multilinestring is a list of lines
+$  multilinestring
  $:  =(list linestring)
  ==
:: generic geometry type
:: TODO: figure out how this should work in hoon
:: will have implications for
:: TODO: use union type
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
      ::list/map geometrycollection or featurecollection
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
