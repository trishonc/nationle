<script>
    import { gameState } from '../store/store.js';

    function goLeft() {
        gameState.update(state => {
            if (state.currentIndex > 0) {
                state.currentIndex -= 1;
            } else {
                state.currentIndex = $gameState.images.length - 1; 
            }
            return state;
        });    
    }

    function goRight() {
        gameState.update(state => {
            if (state.currentIndex < $gameState.images.length - 1) {
                state.currentIndex += 1;
            } else {
                state.currentIndex = 0; 
            }
            return state;
        });    
    }
</script>


<div class="flex justify-center w-screen h-1/3 space-x-4 mt-3 md:mt-6">
    <img src="{$gameState.images[$gameState.currentIndex]}" alt="" data-cy="image" class="rounded-md border-2 border-white"/>
</div>
<div class="flex justify-center space-x-10 mt-2 md:mt-4">
    <button on:click={goLeft} data-cy="left"
            class="text-white fill-none md:hover:text-primary-200 md:hover:fill-white active:text-primary-200 active:fill-white">
        <span class="flex rotate-180">
            <svg xmlns="http://www.w3.org/2000/svg"  viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="w-8 md:w-9 h-8 md:h-9">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M12.75 15l3-3m0 0l-3-3m3 3h-7.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
        </span>
    </button>
    <button on:click={goRight} data-cy="right"
            class="text-white fill-none md:hover:text-primary-200 md:hover:fill-white active:text-primary-200 active:fill-white">
        <span class="flex">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="w-8 md:w-9 h-8 md:h-9">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M12.75 15l3-3m0 0l-3-3m3 3h-7.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
        </span>
    </button>
</div>