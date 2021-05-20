import create, { State } from 'zustand';
import produce from 'immer';

import { GraphNode } from '@urbit/api';

interface GraphStore extends State {
  nodes: Record<string, GraphNode>;
  set: (fn: (state: GraphStore) => void) => void;
}

const useStore = create<GraphStore>((set, get) => ({
  nodes: {},
  set: fn => set(produce(fn))
}));

export default useStore;
