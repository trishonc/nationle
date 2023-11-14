import {env} from "$env/dynamic/private"
import {fetchCountryData} from "../scripts/fetch_country.js";

export async function load({fetch}) {
    const headers = {
        'Authorization': env.SECRET_TOKEN
    };
    const BACKEND_URL = env.SECRET_BACKEND_URL
    const country = await fetchCountryData(BACKEND_URL, headers, fetch);
    return {
        country
    }

}








