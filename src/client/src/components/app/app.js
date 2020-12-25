import React from 'react';
import { Route, Switch } from "react-router-dom";

import Home from '../../containers/home.js';
const App = () => (
    <div>
    <Switch>
        <Route  path ='/' component={Home} />
    </Switch>
    </div>
);

export default App;