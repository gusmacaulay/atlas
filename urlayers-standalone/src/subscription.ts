/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable camelcase */
import { unstable_batchedUpdates } from 'react-dom';

import { GraphNode, Resource } from '@urbit/api';
import { SubscriptionRequestInterface } from '@urbit/http-api';

import useStore from './store';

export const handleEvent = (message: any): void => {
  // This event handler is for graph-store/updates,
  // so we can assume `graph-update` in the message.
  // We only care when nodes are added.
  alert('default subscription event');
  if (!('add-nodes' in message['graph-update'])) {
    return;
  }

  const newNodes: Record<string, GraphNode> = message['graph-update']['add-nodes']['nodes'];

  // This is the path it came in on
  const resource: Resource = message['graph-update']['add-nodes']['resource'];

  // We have to use this wrapper because these come in from outside React.
  // This passes them back into the hook lifecycle.
  unstable_batchedUpdates(() => {
    useStore.getState().set((state) => {
      Object.keys(newNodes).forEach((key) => {
        const node = newNodes[key];
        // Skip all non-TextContent nodes, for the sake of this example
        if (!node.post.contents[0] || !('text' in node.post.contents[0])) {
          return;
        }
        // We put the resource into the path so we can reply to the message
        state.nodes[`${resource.ship}/${resource.name}${key}`] = node;
      });
    });
  });
};

// Just stubs for now
const err = (error: Error): void => console.log(error);
const quit = (): null => null;

const subscription: SubscriptionRequestInterface = {
  app: 'graph-store', // You can build your own app, this one is built in
  path: '/updates',
  event: handleEvent, err, quit
};

export default subscription;
