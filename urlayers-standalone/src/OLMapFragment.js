// Credit to blog here ...https://dominoc925.blogspot.com/2019/10/simple-example-of-reactjs-and.html
import React from 'react';

// Start Openlayers imports
import { Map, View } from 'ol';
import { GeoJSON } from 'ol/format';
import { Tile as TileLayer, Vector as VectorLayer } from 'ol/layer';
import { Vector as VectorSource, XYZ as XYZSource } from 'ol/source';
// import { Select as SelectInteraction, defaults as DefaultInteractions } from 'ol/interaction';
import { ScaleLine, ZoomSlider, MousePosition, OverviewMap, defaults as DefaultControls, Control } from 'ol/control';
import { defaults as defaultInteractions, DragRotateAndZoom } from 'ol/interaction';
import { Style, Fill, Stroke as Stroke, Circle as CircleStyle } from 'ol/style';

// import { Projection, get as getProjection } from 'ol/proj';
// import Polygon from 'ol/geom/Polygon';
// import Draw, {createRegularPolygon, createBox} from 'ol/interaction/Draw'
import { Draw, Modify, Snap } from 'ol/interaction';
// import 'ol/ol.css'
// End Openlayers imports

import _ from 'lodash';
import Urbit, { UrbitInterface } from '@urbit/http-api';
// import atlasSubscription from './atlasSubscription';
import { SubscriptionRequestInterface } from '@urbit/http-api';
// import { addPost, createPost, dateToDa, GraphNode, Resource, TextContent } from '@urbit/api';

const source = new VectorSource();
const format = new GeoJSON();
const vector = new VectorLayer({
  projection: 'EPSG:4326',
  source: source,
  style: new Style({
    fill: new Fill({
      color: 'rgba(255, 255, 255, 0.2)'
    }),
    stroke: new Stroke({
      color: '#ffcc33',
      width: 2
    }),
    image: new CircleStyle({
      radius: 7,
      fill: new Fill({
        color: '#ffcc33'
      })
    })
  })
});
const err = (error: Error): void => console.log(error);
const quit = (): null => null;
const handleEvent = (message: any): void => {
      // refresh map
      // presently, getting the whole geojson document and reloading
      // I *think* openlayers is clever about how it re-renders
      // but neverthless, in the long run should ideally only be sync diffs
      const format = new GeoJSON();
      const featuresFormatted = format.readFeatures(message);
      // nothing up my sleeve
      vector.getSource().clear();
      vector.getSource().addFeatures(featuresFormatted);
    // console.log(vector.getDataExtent());
      //
};

// Openlayer Map instance with openstreetmap base and vector edit layer
// const api = new CreateApi();
const subscription: SubscriptionRequestInterface = {
  app: 'atlas', // atlas store gall app
  path: '/fridge/0',
  event: handleEvent, err, quit
};

// Memoize the api without parameters
// so it returns the same authenticated, subscribed instance every time
const CreateApi = _.memoize(
  (): UrbitInterface => {
    // TODO: Prompt for connection details
    const urb = new Urbit('http://localhost:8081', 'lidlut-tabwed-pillex-ridrup');
    urb.ship = 'zod';
    urb.onError = message => console.log(message); // Just log errors if we get any
    urb.subscribe(subscription); // You can call urb.subscribe(...) as many times as you want to different subscriptions
    urb.connect();
    return urb;
  }
);

class OLMapFragment extends React.Component {
  constructor(props) {
    super(props);
    this.updateDimensions = this.updateDimensions.bind(this);
  }

  updateDimensions() {
    const h = window.innerWidth >= 992 ? (window.innerHeight - 250) : 400;
    this.setState({
      height: h
    });
  }
  componentWillMount() {
    window.addEventListener('resize', this.updateDimensions);
    this.updateDimensions();
  }
  componentDidMount() {
    const api = new CreateApi();
    const drawMcdrawFace = new Draw({
      source: source,
      type: 'Polygon'
    });
    drawMcdrawFace.on('drawend', function(event) { // eslint-disable-line prefer-arrow-callback
          // api.subscribe(subscription);
          const feature = event.feature;

          const gj = format.writeFeatureObject(feature);
          api.poke({
            app: 'atlas',
            // mark: 'update',
            mark: 'json',
            json: { id : 0, geojson : gj }
          }).then(api.subscribe(subscription));
        });
     // Custom Control
     const DeleteControl = (function (Control) { // eslint-disable-line wrap-iife
       function DeleteControl(optOptions) {
         const options = optOptions || {};
         const button = document.createElement('button');
         button.innerHTML = 'D';
         const element = document.createElement('div');
         element.className = 'rotate-north ol-unselectable ol-control';
         element.appendChild(button);
         Control.call(this, {
           element: element,
           target: options.target
         });
         button.addEventListener('click', this.deleteFeature.bind(this), false);
       }
       if ( Control )
        DeleteControl.__proto__ = Control;
       DeleteControl.prototype = Object.create( Control && Control.prototype );
       DeleteControl.prototype.constructor = DeleteControl;
       DeleteControl.prototype.deleteFeature = function deleteFeature () {
         // alert('DELETE!');
         // vector.getSource().clear();
         api.poke({
           app: 'atlas',
           mark: 'delete',
           json: {}
         }).then(
           api.subscribe(subscription)
          );
       };
       return DeleteControl;
     }(Control));
     // End Custom Control Example
     //
     const map = new Map({ // eslint-disable-line @typescript-eslint/no-unused-vars
      //  Display the map in the div with the id of map
      target: 'map',
      layers: [
        new TileLayer({
          source: new XYZSource({
            url: 'https://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            projection: 'EPSG:3857'
          })
        }),
        vector
      ],
      // Add in the following map controls
      controls: DefaultControls().extend([
        new ZoomSlider(),
        new MousePosition(),
        new ScaleLine(),
        new OverviewMap(),
        new DeleteControl()
      ]),
      interactions: defaultInteractions().extend([
        new DragRotateAndZoom(),
        drawMcdrawFace,
        new Modify({
          source: source
        }),
        new Snap({
          source: source
        })
      ]),
      // Render the tile layers in a map view with a WGS84 based Projection
      // Strict geojson is wgs84 only
      view: new View({
        projection: 'EPSG:4326',
        center: [0, 0],
        zoom: 2
      })
    });
    // because I'm reactarded? ... or is it gall problem?
    // quick and dirty map refresh technique (turn based?)
    map.on('moveend', function(event) { // eslint-disable-line prefer-arrow-callback
        api.subscribe(subscription);
     });
  }
  componentWillUnmount() {
    window.removeEventListener('resize', this.updateDimensions);
  }
  render() {
    const style = {
      width: '100%',
      height: this.state.height,
      backgroundColor: '#cccccc'
    };
    return ( <div id = 'map'
      style = { style }>
      </div>
    );
  }
}
export default OLMapFragment;
