TODO
====

* merge this todo file with the the one in top level of atlas repo

* fixme: urlayers-standalone requires both npm install and yarn install for linting to work

* fixme: using old version of openlayers (for reasons pertaining to create-landscape-app

* fixme: unreliable subscription behaviour, loading features not working on chrome, sometimes doesn't work on firefox.  Seems like atlas has to catchup or something?

+ Phase 1

* Complete GeoJSON rendering (90% done)
 * for all geometry types
 * with/without properties
 * Bounding box options etc.?? (can probably get away without this)

* Fix GEOJson properties issues
 * currently disabled in sur file as I need to make optional when reading in

* Complete sub-minimal CRUD with Delete operation in UI
 * Just add a button

* Complete minimal CRUD with;
 * Document IDs
 * Delete by ID
 * Update Operation
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
