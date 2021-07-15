Geojson Test Cases
==================

These are derived from geosjonlint.com, use ```:atlas|pleasant``` to render the examples at the dojo and then paste back into geojsonlint.com to verify end to end parse/render.

### Point

```
:atlas|geojson-create '{
    "type": "Point",
    "coordinates": [
        -105.01621,
        39.57422
    ]
}'
```
### MultiPoint
```
:atlas|geojson-create '{
    "type": "MultiPoint",
    "coordinates": [
        [
            -105.01621,
            39.57422
        ],
        [
            -80.666513,
            35.053994
        ]
    ]
}'
```
### Linestring

```
:atlas|geojson-create '{ "type": "LineString", "coordinates": [ [ -101.744384, 39.32155 ], [ -101.552124, 39.330048 ], [ -101.403808, 39.330048 ], [ -101.332397, 39.364032 ], [ -101.041259, 39.368279 ], [ -100.975341, 39.304549 ], [ -100.914916, 39.245016 ], [ -100.843505, 39.164141 ], [ -100.805053, 39.104488 ], [ -100.491943, 39.100226 ], [ -100.437011, 39.095962 ], [ -100.338134, 39.095962 ], [ -100.195312, 39.027718 ], [ -100.008544, 39.010647 ], [ -99.865722, 39.00211 ], [ -99.684448, 38.972221 ], [ -99.51416, 38.929502 ], [ -99.382324, 38.920955 ], [ -99.321899, 38.895308 ], [ -99.113159, 38.869651 ], [ -99.0802, 38.85682 ], [ -98.822021, 38.85682 ], [ -98.448486, 38.848264 ], [ -98.206787, 38.848264 ], [ -98.020019, 38.878204 ], [ -97.635498, 38.873928 ] ] }'
```
### Polygon
```
:atlas|geojson-create '{ "type": "Polygon", "coordinates": [ [ [ 100, 0 ], [ 101, 0 ], [ 101, 1 ], [ 100, 1 ], [ 100, 0 ] ] ] }'
```
### Feature

```:atlas|geojson-create '{ "type": "Feature", "geometry": { "type": "Polygon", "coordinates": [ [ [ -80.724878, 35.265454 ], [ -80.722646, 35.260338 ], [ -80.720329, 35.260618 ], [ -80.718698, 35.260267 ], [ -80.715093, 35.260548 ], [ -80.71681, 35.255361 ], [ -80.710887, 35.255361 ], [ -80.703248, 35.265033 ], [ -80.704793, 35.268397 ], [ -80.70857, 35.268257 ], [ -80.712518, 35.270359 ], [ -80.715179, 35.267696 ], [ -80.721359, 35.267276 ], [ -80.724878, 35.265454 ] ] ] }, "properties": { "name": "Plaza Road Park" } }'
```

### Feature with ID

```:atlas|geojson-create '{ "type": "Feature", "geometry": { "type": "Polygon", "coordinates": [ [ [ -80.724878, 35.265454 ], [ -80.722646, 35.260338 ], [ -80.720329, 35.260618 ], [ -80.718698, 35.260267 ], [ -80.715093, 35.260548 ], [ -80.71681, 35.255361 ], [ -80.710887, 35.255361 ], [ -80.703248, 35.265033 ], [ -80.704793, 35.268397 ], [ -80.70857, 35.268257 ], [ -80.712518, 35.270359 ], [ -80.715179, 35.267696 ], [ -80.721359, 35.267276 ], [ -80.724878, 35.265454 ] ] ] }, "properties": { "name": "Plaza Road Park" }, "id":123}'
```

### FeatureCollection (mixed geometry types)

```:atlas|geojson-create '{ "type": "FeatureCollection", "features": [ { "type": "Feature", "geometry": { "type": "Point", "coordinates": [ -80.870885, 35.215151 ] }, "properties": { "name": "ABBOTT NEIGHBORHOOD PARK", "address": "1300 SPRUCE ST" } }, { "type": "Feature", "geometry": { "type": "Point", "coordinates": [ -80.837753, 35.249801 ] }, "properties": { "name": "DOUBLE OAKS CENTER", "address": "1326 WOODWARD AV" } }, { "type": "Feature", "geometry": { "type": "Point", "coordinates": [ -80.83827, 35.256747 ] }, "properties": { "name": "DOUBLE OAKS NEIGHBORHOOD PARK", "address": "2605 DOUBLE OAKS RD" } }, { "type": "Feature", "geometry": { "type": "Point", "coordinates": [ -80.836977, 35.257517 ] }, "properties": { "name": "DOUBLE OAKS POOL", "address": "1200 NEWLAND RD" } }, { "type": "Feature", "geometry": { "type": "Point", "coordinates": [ -80.816476, 35.401487 ] }, "properties": { "name": "DAVID B. WAYMER FLYING REGIONAL PARK", "address": "15401 HOLBROOKS RD" } }, { "type": "Feature", "geometry": { "type": "Point", "coordinates": [ -80.835564, 35.399172 ] }, "properties": { "name": "DAVID B. WAYMER COMMUNITY PARK", "address": "302 HOLBROOKS RD" } }, { "type": "Feature", "geometry": { "type": "Polygon", "coordinates": [ [ [ -80.724878, 35.265454 ], [ -80.722646, 35.260338 ], [ -80.720329, 35.260618 ], [ -80.718698, 35.260267 ], [ -80.715093, 35.260548 ], [ -80.71681, 35.255361 ], [ -80.710887, 35.255361 ], [ -80.703248, 35.265033 ], [ -80.704793, 35.268397 ], [ -80.70857, 35.268257 ], [ -80.712518, 35.270359 ], [ -80.715179, 35.267696 ], [ -80.721359, 35.267276 ], [ -80.724878, 35.265454 ] ] ] }, "properties": { "name": "Plaza Road Park" } } ] }'```
