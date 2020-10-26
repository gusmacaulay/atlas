|%
:: coord is the basic coordinate the underpins all geometries
:: is there a cost to having lat,lon variables rather than unnamed pair?
+$  coord  [lat=@rd lon=@rd]
+$  title     @t
+$  id  @ud

:: point is a geomtry, consists of coord + and id
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
:: any geometry type, and also higher level type?
+$  geometry
  $:  =id
  ==
  :: TODO: figure out how this should work
+$  multigeometry
  $:  geom=(list geometry)
      =id
  ==
:: Geometry collection is a GeoJSON type
:: looks the same as multigeometry so may be uneccesary as a type,
:: perhaps just something that comes out of JSON printing/writing
+$  geometrycollection
  $:  =id
      geom=(list geometry)
  ==
:: GeoJSON Feature
+$  feature
  $:  =id
      :: properties= optional map ::??
      :: =geometry :: Generic geometry
  ==
+$  featurecollection
  $:  =id
      features=(list feature) ::?? check geojson, might be a key value thing
  ==
:: Container for GeoJSON objects
+$  document
  $:  =id
      =title
      owner=@p
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
