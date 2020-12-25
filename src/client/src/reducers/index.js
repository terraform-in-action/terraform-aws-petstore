import {combineReducers} from 'redux';
import {pets,petsLoading} from './home.js';
const rootReducer=combineReducers({
   pets:combineReducers({pets,petsLoading}),
})
export default rootReducer;