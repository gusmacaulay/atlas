TODO
====

### Generators

* Basic generators for geometry types
* Run validators on geometries
* GeoJSON pretty print; give geometry get feature
* Store interaction <-> %say generators

### Validators

* Coords in range
* Order of winding (pretty simple https://stackoverflow.com/questions/1165647/how-to-determine-if-a-list-of-polygon-points-are-in-clockwise-order
* Self intersection https://en.wikipedia.org/wiki/Bentley%E2%80%93Ottmann_algorithm - maybe not so simple requires a binary tree etc. various examples out there to copy tho
* Duplicate nodes (poly/line)
* Anything else?? Advanced stuff like overlapping, gaps etc are not required for valida data, could be nice to have down the track

### store

* Need to do some storing
 * CRUD operations

### Hook and View

* Once we have a store.
