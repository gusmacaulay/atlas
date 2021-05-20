import React, { ReactElement } from 'react';
// import _ from 'lodash';

// import Urbit, { UrbitInterface } from '@urbit/http-api';
// import { addPost, createPost, dateToDa, GraphNode, Resource, TextContent } from '@urbit/api';
// import { addPost, createPost, dateToDa, GraphNode, Resource, TextContent } from '@urbit/api';
import './App.css';
// import useStore from './store';
// import subscription, { handleEvent } from './subscription';
// import atlasSubscription from './atlasSubscription';
import logo from './logo.svg';
import OLMapFragment from './OLMapFragment.js';

const App = (): ReactElement => {
  return (
    <div className='App'>
      <img src={logo} className="App-logo" alt="logo" />
      <div className="cf w-100 flex flex-column pa4 ba-m ba-l ba-xl b--gray2 br1 h-100 h-100-minus-40-s h-100-minus-40-m h-100-minus-40-l h-100-minus-40-xl f9 white-d overflow-x-hidden">
        <h1 className="mt0 f8 fw4">urlayers</h1>
        <p className="lh-copy measure pt3">Welcome urlayers.  Click the map to draw a polygon.  Hold shift to freehand draw</p>

<OLMapFragment />
        </div>
    </div>
  );
};

export default App;
