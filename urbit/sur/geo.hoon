|%
::  coord is the basic coordinate the underpins all geometries
::  lon,lat order! (GeoJSON standard)
::  is there a cost to having lon,lat variables rather than unnamed pair?
::  TODO: what is the precision required by GeoJSON formate
::  TODO: variable precision? ala postgis etc.
+$  coord  [lon=@rd lat=@rd]
::  just for fun, the spatial equivalent of a loobean
+$  drooc  [lat=@rd lon=@rd]
+$  title     @t
+$  id  @ud
::+$  properties
::  point is a geometry, consists of coord
::
+$  point
  $:  =coord
  ==
::  is there an array structure more compact/efficient than list?
+$  linestring
  $:  =(list coord)
  ==

::  A linear ring is the building block of a polygon
::  a ring differs from a linestring, partly for conceptual/syntactic reasons
::  and also because in geojson and some other formats the last coord and first
::  of a ring are the same - although we don't need to store this redundant
::  coordinate only take it into account when rendering/parsing.
::  There are also 'winding' direction considerations (TODO: distinguish winding)
::  See macwright.org for a nice summary
+$  linearring
  $:  =(list coord)
  ==
::
::  A polygon is a list of rings - the first ring is the "outer" ring
::  and the subsequent rings are the "inner rings" (donut holes)
+$  polygon
  $:  =(list linearring)
  ==
::
::  A multipoint is a list of poins
+$  multipoint
  $:  =(list point)
  ==
::
::  A multilinestring is a list of lines
+$  multilinestring
  $:  =(list linestring)
  ==
::
::  A multipolygon is a list of polygons
+$  multipolygon
  $:  =(list polygon)
  ==
::
::  Geometry is a tagged union of all geometry types
+$  geometry
  $%  [%point geom=point]
      [%linestring geom=linestring]
      [%polygon geom=polygon]
      [%multipoint geom=multipoint]
      [%multilinestring geom=multilinestring]
      [%multipolygon geom=multipolygon]
  ==
::
::
::  Geometrycollection for GeoJSON
::  TODO: check if id is needed here
+$  geometrycollection
  $:  =id
      geom=(list geometry)
  ==
::  GeoJSON Feature Type
::  A geometry with properties (key:value pairs)
::  and a title and id
+$  feature
  $:  =geometry :: Generic geometry
      ::properties=(map @tas @tas) ::optional?? allow non text types?
  ==
+$  featurecollection
  $:  =(list feature) ::?? check geojson, might be a key value thing
  ==
::  Container for GeoJSON objects
::  This should map closely a GeoJSON document, which is either a ..
::  geometrycollection or a feature collection
+$  document
  $:  =id
      =title
      owner=@p
      :: bbox, optional
      ::list/map geometrycollection or featurecollection
  ==
::  Portal is a set of GeoJSON documents, probably a whole lot of other stuff too
::  ... TBD in stage 2 project
+$  portal
  $:  =id
      =title
      owner=@p
      documents=(list document)
  ==
::  Actions, for on-poke, ties in with mar/crud.hoon
::  following patter from gall guide poketime example
+$  action
  $%  [%delete ~]
      [%pleasant ~]
  ==
--
