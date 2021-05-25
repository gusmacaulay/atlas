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
import atlasSubscription from './atlasSubscription';
// import { addPost, createPost, dateToDa, GraphNode, Resource, TextContent } from '@urbit/api';
// Memoize the api without parameters
// so it returns the same authenticated, subscribed instance every time

 const createApi = _.memoize(
   (): UrbitInterface => {
     const urb = new Urbit('http://localhost:8081', 'lidlut-tabwed-pillex-ridrup');
     urb.ship = 'zod';
     urb.onError = message => console.log(message); // Just log errors if we get any
     urb.subscribe(atlasSubscription); // You can call urb.subscribe(...) as many times as you want to different subscriptions
     urb.connect();
     return urb;
   }
 );

class OLMapFragment extends React.Component {
  constructor(props) {
    super(props);

    this.updateDimensions = this.updateDimensions.bind(this);
  }

  handleEvent(diff) {
    console.log('OL handle: ', diff);
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
    // Openlayer Map instance with openstreetmap base and vector edit layer
    // const api = new CreateApi();
    window.api = createApi();
    const source = new VectorSource();
    window.vector = new VectorLayer({
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
    const drawMcdrawFace = new Draw({
      source: source,
      type: 'Point'
    });
    drawMcdrawFace.on('drawstart', function(event) { // eslint-disable-line prefer-arrow-callback
      // console.log('draw state',window.store.state);
      const feature = event.feature;
      // var features = vector.getSource().getFeatures();
      // features = features.concat(feature);
      // features.forEach(function() {
      const format = new GeoJSON();
      const gj = format.writeFeatureObject(feature);
      console.log(gj);
      alert('poking');
      window.api.poke({
        app: 'atlas',
        mark: 'json',
        json: gj
      });
      // refresh subscription?? and re-render
       if (window.features != null) { // eslint-disable-line no-undef
        alert('update map features  ');
        const format = new GeoJSON();
        const urFeatures = format.readFeatures(window.features);
        window.vector.getSource().clear();
        window.vector.getSource().addFeatures(urFeatures);
       } else {
        alert('in draw with window.features null');
       }
    });
     // Custom Control Example
     const RotateNorthControl = (function (Control) { // eslint-disable-line wrap-iife
       function RotateNorthControl(optOptions) {
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
        RotateNorthControl.__proto__ = Control;
       RotateNorthControl.prototype = Object.create( Control && Control.prototype );
       RotateNorthControl.prototype.constructor = RotateNorthControl;

       RotateNorthControl.prototype.deleteFeature = function deleteFeature () {
         // this.getMap().getView().setRotation(0);
         alert('DELETE!');
         window.api.poke({
           app: 'atlas',
           mark: 'delete',
           json: {}
         });
       };

       return RotateNorthControl;
     }(Control));
     // End Custom Control Example
     window.map = new Map({
      //  Display the map in the div with the id of map
      target: 'map',
      layers: [
        new TileLayer({
          source: new XYZSource({
            url: 'https://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            projection: 'EPSG:3857'
          })
        }),
        window.vector
      ],
      // Add in the following map controls
      controls: DefaultControls().extend([
        new ZoomSlider(),
        new MousePosition(),
        new ScaleLine(),
        new OverviewMap(),
        new RotateNorthControl()
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
      // Render the tile layers in a map view with a Mercator projection
      view: new View({
        projection: 'EPSG:3857',
        center: [0, 0],
        zoom: 2
      })
    });
    window.map.once('rendercomplete', function(event) { // eslint-disable-line prefer-arrow-callback
      // alert('render complete event');
    //  if (window.features != null) { // eslint-disable-line no-undef
    //    alert('in rendercomplete and we have features');
    //    const format = new GeoJSON();
    //    window.vector.getSource().clear();
    //    const urFeatures = format.readFeatures(window.features);
    //    window.vector.getSource().addFeatures(urFeatures);
    //  } else {
    //    alert('in rendercomplete but features null');
    //  }
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
    return ( < div id = 'map'
      style = {
        style
      } >
      < /div>
    );
  }
}
export default OLMapFragment;
