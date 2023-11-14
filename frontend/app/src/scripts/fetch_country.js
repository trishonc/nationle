import {gameState} from '../store/store.js';

export async function fetchCountryData(BACKEND_URL, headers, fetch) {
    try {
        let response = await fetch(`${BACKEND_URL}/current_country`, {headers: headers});
        
        if (!response.ok) {
            throw new Error("Error fetching current country.");
        }

        let data = await response.json();
        const id = data.code;
        response = await fetch(`${BACKEND_URL}/country/${id}`, {headers: headers});
        
        if (!response.ok) {
            throw new Error("Error fetching country by ID.");
        }

        data = await response.json();

        return {
            name: data.name,
            image_urls: data.images.map(image => image.url),
            flag_url: data.flag.url
        };

    } catch (error) {
        console.error("Error fetching country data:", error);
        return {
            name: "France",
            image_urls: [],
            flag_url: ""
        };
    }
}

    



function preloadImage(url) {
    return new Promise((resolve, reject) => {
        const img = new Image();
        img.src = url;
        img.onload = () => resolve(img);
        img.onerror = reject;
    });
}

export async function preloadCountryImages(country) {
    await preloadImage(country.image_urls[0]);
    gameState.update(state => {
        state.images = [country.image_urls[0]];
        return state;
    });
    const remainingImages = country.image_urls.slice(1);
    await Promise.all(remainingImages.map(url => preloadImage(url)));
    await preloadImage(country.flag_url);
}




