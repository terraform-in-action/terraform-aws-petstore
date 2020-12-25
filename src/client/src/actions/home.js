import {
    PETS,
    PETS_LOADING,
    API_URL,
} from '../constants/actions.js';

//pipelines
export function refreshPets() {
    return (dispatch) => {
        dispatch(petsLoading(true));
        dispatch(listPets());
    }
}

function listPets() {
    return (dispatch) => {
        const endpoint = `${API_URL}/api/pets`;
        dispatch(petsLoading(true));
        fetch(endpoint, { method: 'GET', mode: "cors", })
            .then(res => {
                res.json().then((json) => {
                    dispatch(pets(json.items));
                }).catch(e => { console.log(e) })
            })
            .catch(e => { console.log(e)})
            .finally(()=>{dispatch(petsLoading(false))})
    }
}


export function petsLoading(bool) {
    return {
        type: PETS_LOADING,
        payload: bool
    }
}


export function pets(petsList) {
    return {
        type: PETS,
        payload: petsList
    }
}