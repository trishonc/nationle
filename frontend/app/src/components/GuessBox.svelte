<script>
    import { gameState } from '../store/store.js';
    const countries = [
        'Albania',
        'Andorra',
        'Armenia',
        'Austria',
        'Azerbaijan',
        'Belarus',
        'Belgium',
        'Bosnia and Herzegovina',
        'Bulgaria',
        'Croatia',
        'Cyprus',
        'Czechia',
        'Denmark',
        'Estonia',
        'Finland',
        'France',
        'Georgia',
        'Germany',
        'Greece',
        'Hungary',
        'Iceland',
        'Ireland',
        'Italy',
        'Kazakhstan',
        'Kosovo',
        'Latvia',
        'Liechtenstein',
        'Lithuania',
        'Luxembourg',
        'Malta',
        'Moldova',
        'Monaco',
        'Montenegro',
        'Netherlands',
        'North Macedonia',
        'Norway',
        'Poland',
        'Portugal',
        'Romania',
        'Russia',
        'San Marino',
        'Serbia',
        'Slovakia',
        'Slovenia',
        'Spain',
        'Sweden',
        'Switzerland',
        'Turkey',
        'Ukraine',
        'United Kingdom',
        'Vatican City',
    ];
    let userguess;
    export let urls = [];
    export let name = "Bulgaria";
    let showError = false;
    let guessnumber = 0;
    let isDisabled = false;

    function Guess() {
        gameState.update(state => {
            guessnumber++;
            let box = document.getElementById(`guess${guessnumber - 1}`);
            if (name === userguess) {
                box.classList.remove('bg-secondary-100');
                box.classList.add('bg-green-700');
                box.textContent = userguess
                state.win = true
                isDisabled = true

            } else {
                if (guessnumber === 6) {
                    state.loss = true
                    isDisabled = true
                }
                box.classList.remove('bg-secondary-100');
                box.classList.add('bg-red-700');
                box.textContent = userguess
                if (guessnumber < 6) {
                    state.images = [...state.images, urls[guessnumber]];
                    state.currentIndex = guessnumber
                }
            }
            userguess = ""
            return state;
        });
    }

    function handleSubmit() {
        if(!countries.includes(userguess)) {
            showError = true;
        } else {
            showError = false;
            Guess()
        }
    }

</script>



<div class="flex flex-col justify-start items-center space-y-2 mt-2 md:mt-4 w-screen h-1/2">
    {#each Array(6) as _, index (index)}
        <span class="flex flex-col justify-center h-6 md:h-7 rounded-lg bg-secondary-100 max-w-xl w-10/12 p-2 text-center text-lg md:text-xl text-white font-bold " data-cy="box{index}" id="guess{index}"></span>
    {/each}
    <form on:submit|preventDefault={handleSubmit} class="flex flex-col space-y-2 items-center w-screen">
        <input list="countries" class="h-6 md:h-7 rounded-lg mb-1 md:mb-2 bg-white max-w-xl w-10/12 p-2 text-lg md:text-xl" type="text" autocomplete="off" bind:value={userguess} 
            placeholder="Country"
            id="input"
            data-cy="input"
            disabled={isDisabled}>
        {#if showError}
            <span data-cy="invalid_country" class="text-white text-center text-xl md:text-2xl">Please enter a valid country.</span>
        {/if}
        <datalist id="countries">
            {#each countries as country (country)}
                <option value={country}>{country}</option>
            {/each}
        </datalist>

        <div class="relative group">
            <button data-cy="guess" disabled={isDisabled} class="relative px-4 pt-2 pb-2 rounded-xl text-white font-bold bg-primary-200 flex divide-x divide-white border-2 border-white active:bg-white active:text-primary-200 md:hover:bg-white md:hover:text-primary-200">
                <span class="pr-2">Guess</span>
                <span class="pl-2">{guessnumber}/6</span>
            </button>
        </div>
    </form>
</div>