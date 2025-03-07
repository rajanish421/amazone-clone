// import packages
const express = require("express");
const mongoose = require("mongoose");
 
// imprort from other files
const authRoute = require('./routes/auth');  
const adminRouter = require("./routes/admin");
const admin = require("./middlewares/admin");
const productRoute = require("./routes/product");
const productRouter = require("./routes/product");

// Initialization
const app = express();
const PORT = 3000;


// middleware
app.use(express.json());
app.use(authRoute);
app.use(adminRouter);
app.use(productRouter);

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

