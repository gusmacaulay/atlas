Atlas
=====

*A spatial document store for urbit*

### Installing Atlas

Atlas is a gall agent.  Install by copying files to your ship (or fake zod), commit and start
You will need home desk mounted in the usual way.
```
$>cp -r  ./urbit/* $FAKEZOD/home/
dojo>|commit %home
dojo>|start %atlas
```

### Using/Testing Atlas

Atlas comes with some simple generators for ingesting geojson and printing.  Grab some examples from geojson lint and use like this
```
>:atlas|geojson-create '{
    "type": "Point",
    "coordinates": [
        -105.01621,
        39.57422
    ]
}'
>:atlas|pleasant
```
Full set of examples in tests.md, with ready to go cut and paste examples.

### Install urlayers

urlayers is a standalone web app built from TBCS create-urbit-app (link).  
Use yarn to build and start.  Currently hardcoded to attach to a fakezod.

```
$cd urlayers-standalone
$yarn start
open localhost:3000 in browser
```

### Using urlayers

draw on map. press 'D' button to delete. reload page to verify persistence. wow.

### Caveats/Bugs/TODO

* Needs a big refactor/tidy up
 * All the geojson stuff is in atlas.hoon, should be in a library
 * The CRUD stuff is complete but muddled, updates only work with features, the geojson parsing is intertwined with the create
 * Some other TODO in the code.
* urlayers is hardcoded to document 0, you can change it in the code to a different document id and it works - but only if you open a new private tab or clear cache etc. (subscription memoisation causing this maybe?)
* urlayers refreshes the subscription whenever there is an openlayers event such as zoom or pan, should be the subscription refreshing openlayers but never go to the bottom of this
* urlayers is hardcoded to attach to fakezod
* should add a few things to urlayers, such as zoom to extent of features on load, specify a document id in the UI, allow feature edit
* CRUD operations should be all under one gall json poke
