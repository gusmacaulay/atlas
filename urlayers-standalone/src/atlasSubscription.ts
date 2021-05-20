/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable camelcase */
// import { unstable_batchedUpdates } from 'react-dom';

// import { GraphNode, Resource } from '@urbit/api';
import { SubscriptionRequestInterface } from '@urbit/http-api';
// import useStore from './store';
// import atlasStore from './atlasStore';
// import OLMapFragment from './OLMapFragment.js';

export const handleEvent = (message: any): void => {
    alert('in subscription handleEvent  ');
    alert(message);
    alert('message?');
    // A highly sophisticated storage solution ...
    window.features = message;
    // refresh map?
    alert('refreshing map');
    if (window.features != null) { // eslint-disable-line no-undef
      alert('in handleEvent and we have features');
      const format = new GeoJSON();
      const urFeatures = format.readFeatures(window.features);
      window.vector.getSource().addFeatures(urFeatures);
    } else {
      alert('in handleEvent but features null');
    }
    console.log('subscripton features');
    console.log('window.features', window.features);
};

// Just stubs for now
const err = (error: Error): void => console.log(error);
const quit = (): null => null;

const subscription: SubscriptionRequestInterface = {
  app: 'atlas', // atlas store gall app
  path: '/',
  event: handleEvent, err, quit
};

export default subscription;
