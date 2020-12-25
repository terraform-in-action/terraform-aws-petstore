import {PETS,PETS_LOADING} from '../constants/actions.js'

//pets
export function pets(state=[],action){
    switch(action.type){
        case PETS:
            return action.payload;
        default:
            return state;
    }
}
export function petsLoading(state=false,action){
    switch(action.type){
        case PETS_LOADING:
        return action.payload;
        default:
        return state;
    }
}