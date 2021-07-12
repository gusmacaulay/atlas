Geojson Test Cases
==================

These are derived from geosjonlint.com, use ```:atlas|pleasant``` to render the examples and then paste back into geojsonlint.com to verify end to end parse/render.

### Feature

```:atlas|geojson-create '{ "type": "Feature", "geometry": { "type": "Polygon", "coordinates": [ [ [ -80.724878, 35.265454 ], [ -80.722646, 35.260338 ], [ -80.720329, 35.260618 ], [ -80.718698, 35.260267 ], [ -80.715093, 35.260548 ], [ -80.71681, 35.255361 ], [ -80.710887, 35.255361 ], [ -80.703248, 35.265033 ], [ -80.704793, 35.268397 ], [ -80.70857, 35.268257 ], [ -80.712518, 35.270359 ], [ -80.715179, 35.267696 ], [ -80.721359, 35.267276 ], [ -80.724878, 35.265454 ] ] ] }, "properties": { "name": "Plaza Road Park" } }'
```

### Feature with ID

```:atlas|geojson-create '{ "type": "Feature", "geometry": { "type": "Polygon", "coordinates": [ [ [ -80.724878, 35.265454 ], [ -80.722646, 35.260338 ], [ -80.720329, 35.260618 ], [ -80.718698, 35.260267 ], [ -80.715093, 35.260548 ], [ -80.71681, 35.255361 ], [ -80.710887, 35.255361 ], [ -80.703248, 35.265033 ], [ -80.704793, 35.268397 ], [ -80.70857, 35.268257 ], [ -80.712518, 35.270359 ], [ -80.715179, 35.267696 ], [ -80.721359, 35.267276 ], [ -80.724878, 35.265454 ] ] ] }, "properties": { "name": "Plaza Road Park" }, "id":123}'
```