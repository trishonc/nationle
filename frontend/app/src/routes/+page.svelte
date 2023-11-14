<script>
    import "../app.css";
    import Header from "../components/Header.svelte";
    import ImageViewer from "../components/ImageViewer.svelte";
    import GuessBox from "../components/GuessBox.svelte";
    import Llabel from "../components/Llabel.svelte";
    import Wlabel from "../components/Wlabel.svelte";
    import { preloadCountryImages } from '../scripts/fetch_country.js';
    import { gameState } from '../store/store.js';
    import { onMount} from "svelte";

    export let data;
    let country = data.country

    onMount(async () => {
        await preloadCountryImages(country);
    })
</script>
<main class="fixed top-0 bg-primary-200 h-screen font-primary overflow-y-auto overflow-x-hidden">
    <slot />
    <Header/>
    {#if country}
        <ImageViewer />
        {#if $gameState.win}
            <Wlabel name={country.name} flag_url={country.flag_url} />
        {/if}
        {#if $gameState.loss}
            <Llabel name={country.name} flag_url={country.flag_url} />
        {/if}

        <GuessBox name={country.name} urls={country.image_urls} /> 
    {/if}
</main>

