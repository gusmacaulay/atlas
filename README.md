Atlas/Poast
===========

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

### Install Poast
