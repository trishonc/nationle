import { writable } from 'svelte/store';

export const gameState = writable({
    win: false,
    loss: false,
    currentIndex: 0,
    images: [],
});
