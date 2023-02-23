const dataModels = {
    baseUrl: "http://localhost:1337",
    getAllData: async function getAllData() {
        const response = await fetch(`http://localhost:1337/data`, {
            headers: {
                "Access-Control-Allow-Origin": "*",
            }
        });

        const data = await response.json();

        return data;
    },
    getIp: async function getIp(ip) {
        console.log("ip", ip);
        const response = await fetch(`http://localhost:1337/data/ip/${ip}`, {
            headers: {
                "Access-Control-Allow-Origin": "*",
            }
        });

        const data = await response.json();

        return data;
    },
    getUrl: async function getUrl(url) {
        const response = await fetch(`http://localhost:1337/data/url/${url}`, {
            headers: {
                "Access-Control-Allow-Origin": "*",
            }
        });

        const data = await response.json();

        return data;
    }
};

export default dataModels;
