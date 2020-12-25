import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import { withStyles } from '@material-ui/core/styles';
import {
    IconButton,
    Typography,
    Toolbar,
    CircularProgress
} from '@material-ui/core';
import {
    Refresh as RefreshIcon,
} from '@material-ui/icons';
import withRoot from '../../themes/withRoot';
import { styles } from './home.js';
import Pet from '../cards/pet.jsx';
import { isNullOrUndefined } from '../../utility/utility.js'

class Home extends Component {
    state = {};
    componentWillMount = () => {
        this.props.refreshPets();
    }

    renderPets = (pets) => {
        if (isNullOrUndefined(pets)) {
            return null
        }
        return pets.map((pet, index) => {
            return (
                <Pet
                    key={index}
                    index={index}
                    pet={pet}
                />
            )
        })
    }

    renderContent = (petsList,petsLoading) => {
        if(petsLoading){
            return   <CircularProgress/>
        }
        return petsList.length>0?petsList:<Typography variant="h5">No pets in database</Typography>
        
    }

    render() {
        const { pets, petsLoading,classes } = this.props;
        const petsList = this.renderPets(pets)
        const content = this.renderContent(petsList,petsLoading)
        return (
            <div className={classNames(classes.root)}>
                <Toolbar>
                     <Typography variant="h3" internalDeprecatedVariant>Petstore Pets</Typography>
                     <IconButton onClick={() => { this.props.refreshPets()}} >
                        <RefreshIcon />
                    </IconButton>
                </Toolbar>
               {content}
            </div>
        )
    }
}

Home.propTypes = {
    classes: PropTypes.object.isRequired,
    theme: PropTypes.object.isRequired,
    refreshPets: PropTypes.func.isRequired,
    pets: PropTypes.array.isRequired,
    petsLoading:PropTypes.bool.isRequired,
};


export default withRoot(withStyles(styles, { withTheme: true })(Home));