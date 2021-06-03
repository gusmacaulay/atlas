import create from 'zustand';
import produce from 'immer';

const atlasStore = create((set, get) => {
  features: [],
  set: fn => set(produce(fn)),
});

export default atlasStore;
