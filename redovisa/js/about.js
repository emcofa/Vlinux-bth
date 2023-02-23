function about() {
    let index = document.getElementById("about-me");

    let container = document.getElementById("headline-container");

    index.addEventListener("click", information);

    function information() {
        index.classList.remove("about-me");
        index.classList.remove("accent");
        index.classList.remove("button");
        index.innerHTML = `
        <div class="about-container">
        <p class="about-text">
        Jag är en 25-årig tjej från Västervik som skrev min allra första kod någonsin 
        när jag började
        distansprogrammet i Webbprogrammering på BTH hösten 2021. 
        Min stora passion ligger främst inom front end och User Experience 
        men ju mer jag lär mig inom programmering desto mer siktar jag på att bli en 
        god full stack-utvecklare.
        Utöver programmering har jag en stort intresse inom mat och träning.
        </p>
        <span class="about-text">Ha det så gott!</span>
        </div>`;
        container.innerHTML = `<h2 class="about-text">Hej, jag heter Emmie.</h2>`;
    }
}

about();
