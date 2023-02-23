import React, { useState } from 'react';
import dataModels from '../models/dataModels';
import './list.css';


const Search = () => {
    const [data, setData] = useState([]);
    const [query, setQuery] = useState("");

    async function getDataFromSearch() {
        let firstChar = (query[0]);

        if (isNaN(firstChar)) {
            // console.log(query);
            const getUrl = await dataModels.getUrl(query);

            setData(getUrl);
        } else {
            // console.log(query);
            const getIp = await dataModels.getIp(query);

            setData(getIp);
        }
    }
    return (
        <div>
            <input placeholder="Sök efter ip eller url"
                onChange={event => setQuery(event.target.value)} />
            <button className="searchButton" onClick={getDataFromSearch}>Sök</button>
            {data.length > 0 ?
                <div>
                    <p className="matches">Antal träffar: {data.length}</p>
                </div>
                :
                <p></p>
            }
            <ul>
                {data.map((data, index) => <li value={index} key={index}>
                    <strong>IP: </strong>{data.ip}<strong><br />URL: </strong>{data.url}</li>)}
            </ul>
        </div>
    );
};

export default Search;
