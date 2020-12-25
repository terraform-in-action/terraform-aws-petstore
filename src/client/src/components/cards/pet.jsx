import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import { withStyles } from '@material-ui/core/styles';
import {
  Card,
  CardMedia,
  CardHeader,
  CardContent,
  Avatar,
  TableHead,
  TableCell,
  TableRow,
  Table,
  TableBody,
} from '@material-ui/core';
import red from '@material-ui/core/colors/red';
import blue from '@material-ui/core/colors/blue';
import orange from '@material-ui/core/colors/orange';
import green from '@material-ui/core/colors/green';
import yellow from '@material-ui/core/colors/yellow';
import purple from '@material-ui/core/colors/purple';
import withRoot from '../../themes/withRoot';
import { styles } from './pet.js';

class Pet extends Component {
  state = {
  };

  hashCode = (s)=>{
    return s.split("").reduce(function(a,b){a=((a<<5)-a)+b.charCodeAt(0);return a&a},0);              
  }

  random = (seed) => {
    var x = Math.sin(seed++) * 10000;
    return x - Math.floor(x);
  }

  //generate random color based on hash of id
  randomColorStyle = () => {
    let colors = [
      red[500],
      blue[500],
      green[500],
      yellow[500],
      purple[500],
      orange[500]
    ];
    let seed = this.hashCode(this.props.pet.name)
    let randomColor = colors[Math.floor(this.random(seed) * colors.length)];
    let style = { backgroundColor: randomColor }
    return style
  }

  render() {
    const { pet, classes } = this.props
    return (
      <div className={classNames(classes.root)}>
        <Card className={classNames(classes.card)}>
          <CardHeader
            avatar={
              <Avatar aria-label="avatar" style={this.randomColorStyle()} >{pet.name.charAt(0).toUpperCase()}</Avatar>
            }
            title={pet.name}
          />
          <CardMedia
            className={classes.media}
            image={"https://terraform-in-action.s3-us-west-2.amazonaws.com/paw-print.jpg"}
            title="#selfie"
          />
          <CardContent className={classes.content}>
            <Table className={classes.table}>
              <TableHead>
                <TableRow>
                  <TableCell>Species</TableCell>
                  <TableCell>Age</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                <TableRow >
                  <TableCell >{pet.species}</TableCell>
                  <TableCell >{pet.age}</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </div>
    )
  }
}


Pet.propTypes = {
  classes: PropTypes.object.isRequired,
  theme: PropTypes.object.isRequired,
  pet: PropTypes.object.isRequired,
};

export default withRoot(withStyles(styles, { withTheme: true })(Pet));