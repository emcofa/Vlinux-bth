const express = require("express");
const app = express();
let port = "";

if (process.env.$DBWEBB_PORT !== undefined) {
    port = process.env.$DBWEBB_PORT;
} else {
    port = 1337;
}

app.get("/", (req, res) => {
    let data = {

        $route1: {
            name: "/",
            description: "Information about all routes"
        },
        $route2: {
            name: "/all",
            description: "View content of the package.json file"
        },
        $route3: {
            name: "/names",
            description: "Show the names of the chili plants"
        },
        $route4: {
            name: "/color/<color>",
            description: "Show all the plants which have the color '<color>'"
        },
    };

    res.json(data);
});

app.get("/all", (req, res) => {
    const items = require("./data/items.json");

    res.json(items);
});

app.get("/names", (req, res) => {
    const items = require("./data/items.json");

    const result = items.items.map(item => item.name);

    res.json(result);
});

app.get("/color/:color", (req, res) => {
    const items = require("./data/items.json");

    let color = req.params['color'];

    let upperCaseColor = color.charAt(0).toUpperCase() + color.slice(1);

    const result = items.items.filter(item => item.color.includes(upperCaseColor));

    res.json(result);
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
