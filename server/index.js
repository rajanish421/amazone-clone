// import packages
const express = require("express");
const mongoose = require("mongoose");
 
// imprort from other files
const authRoute = require('./routes/auth');  

// Initialization
const app = express();
const PORT = 3000;


// middleware
app.use(express.json());
app.use(authRoute);

// Connections
mongoose.connect('mongodb://0.0.0.0/').then(()=>{
    console.log("Connection Successfully");
}).catch((e)=>{
    console.log(e);
});


// listen at port
app.listen(PORT,()=>{
    console.log(`Listen at port ${PORT}`);
});