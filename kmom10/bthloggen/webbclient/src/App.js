import './App.css';
// eslint-disable-next-line no-unused-vars
import React from 'react';

// eslint-disable-next-line no-unused-vars
import Footer from './components/Footer';
// eslint-disable-next-line no-unused-vars
import Header from './components/Header';
// eslint-disable-next-line no-unused-vars
import Search from './components/Search';

function App() {
    return (
        <div className="container">
            <Header />
            <h1>
                Sök i BTH-loggen
            </h1>
            <div className="search">
                <Search />
            </div>
            <Footer />
        </div>
    );
}

export default App;
