import red from '@material-ui/core/colors/red';
export const styles = theme => ({
    root: {
        margin: "20px",
        display: "inline-block"
    },
    card: {
        padding: "20px",
       // width: 500
    },
    cover: {
        width: 150,
        height: 150,
    },
    content: {
        flex: '1 0 auto',
    },
    avatar: {
        backgroundColor: red[500],
    },
    media: {
       paddingTop: '100%'
      },
});
