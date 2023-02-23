function myFunction() {
    let x = document.getElementById("nav");

    x.addEventListener("click", hbBars);
    function hbBars() {
        if (x.className === "navbar") {
            x.className += " responsive";
        } else {
            x.className = "navbar";
        }
    }
}

myFunction();
