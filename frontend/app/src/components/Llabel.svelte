<script>
    export let name;
    export let flag_url;
</script>

<div data-cy="loss" class="flex justify-center items-center">
    <div class="fixed flex flex-col w-3/4 h-2/5 md:w-1/3 md:h-2/5 bg-red-700 border-white border-4 p-2 font-bold text-white text-xl md:text-2xl rounded-xl justify-center items-center text-center z-50">
        <span>Unlucky! {name} was the correct answer!</span>
        <img class="h-1/6 w-1/6 m-2 rounded-lg" src="{flag_url}" alt="Flag">
        <span>Thank you for playing and make sure the to try again tomorrow!</span>
    </div>
</div>