const express = require("express");
const app = express();

const bodyParser = require('body-parser');
const morgan = require('morgan');
const cors = require('cors');

let port = "";

if (process.env.$DBWEBB_PORT !== undefined) {
    port = process.env.$DBWEBB_PORT;
} else {
    port = 1337;
}

app.use(cors());
app.use(express.json());

app.options('*', cors());

app.disable('x-powered-by');

// app.use((req, res, next) => {
//     res.header("Access-Control-Allow-Origin", "*")
// })


if (process.env.NODE_ENV !== 'test') {
    app.use(morgan('combined')); // 'combined' outputs the Apache style LOGs
}

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => {
    let data = {

        $route1: {
            name: "/",
            description: "Information about all routes"
        },
        $route2: {
            name: "/data/",
            description: "Show all lines in log.json"
        },
        $route3: {
            name: "/data/ip/<ip>",
            description: "Show lines containing '<ip>'"
        },
        $route4: {
            name: "/data/url/<url>",
            description: "Show lines containing '<url>'"
        }
    };

    res.json(data);
});

app.get("/data", (req, res) => {
    const items = require("./data/log.json");

    res.json(items);
});

app.get("/data/ip/:ip", (req, res) => {
    const items = require("./data/log.json");

    let ip = req.params['ip'];

    const result = items.filter(item => item.ip.includes(ip));

    res.json(result);
});

app.get("/data/url/:url", (req, res) => {
    const items = require("./data/log.json");

    let url = req.params['url'];

    const result = items.filter(item => item.url.includes(url));

    res.json(result);
});


app.listen(port, () => console.log(`Example app listening on port ${port}!`));
