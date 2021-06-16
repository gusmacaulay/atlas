TODO
====

* [Done] merge this todo file with the the one in top level of atlas repo

* fixme: urlayers-standalone requires both npm install and yarn install for linting to work

* [Done] fixme: using old version of openlayers (for reasons pertaining to create-landscape-app

* [Done] fixme: unreliable subscription behaviour, loading features not working on chrome, sometimes doesn't work on firefox.  Seems like atlas has to catchup or something?

* [Done] fixme: |start doesn't work because of dojo subscription

*  fixme: convert openlayers operations to perform 'update' action (create/delete for portal/document only)

+ Phase 1

* Complete GeoJSON rendering (90% done)
 * for all geometry types
 * with/without properties
 * Bounding box options etc.?? (can probably get away without this - nothing to really test it against)
 * Get all examples from geojsonlint working
 
* Fix GEOJson properties issues
 * currently disabled in sur file as I need to make optional when reading in

* [Done] Complete sub-minimal CRUD with Delete operation in UI 
 * Just add a button

* Complete minimal CRUD with;
 * Document IDs
 * Delete by ID --> actually just do this as update whole document for now
 [Done] * Update Operation
 * Add doc id path to on-watch

* Add Geometry type selector to UI
 * To Demo full range of geometry types

* Do some very basic geometry validation (order of winding perhaps)??

* Basic tidyup of hoon code, split out geojson stuff into a library (currently in atlas.hoon)

+ Phase 2

* All the things I promised for phase 2
* Use Graph-store
* More sophisticated on-watch to support incremental subscription updates
* Demo using with advanced geojson web libs such as turf.js, or routing, or anything from awesome geojson github ??

### Generators

* Basic generators for geometry types
* Run validators on geometries
* [Done] GeoJSON pretty print; give geometry get feature
* [Done] Store interaction <-> %say generators

### Validators

* Coords in range
* Order of winding (pretty simple https://stackoverflow.com/questions/1165647/how-to-determine-if-a-list-of-polygon-points-are-in-clockwise-order
* Self intersection https://en.wikipedia.org/wiki/Bentley%E2%80%93Ottmann_algorithm - maybe not so simple requires a binary tree etc. various examples out there to copy tho
* Duplicate nodes (poly/line)
* Anything else?? Advanced stuff like overlapping, gaps etc are not required for valida data, could be nice to have down the track

### store

[Done] * Need to do some storing
[Done] * CRUD operations

### Hook and View

* Once we have a store.
