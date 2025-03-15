// import packages
const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');
 
// imprort from other files
const authRoute = require('./routes/auth');  
const adminRouter = require("./routes/admin");
const admin = require("./middlewares/admin");
const productRoute = require("./routes/product");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

// Initialization
const app = express();
const PORT = process.env.PORT || 3000;
const DB = "mongodb+srv://rajanishsingh729:Rajanish@1234@cluster0.l2i5z.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
 

// middleware
app.use(express.json());
app.use(authRoute);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.use(cors());

// Connections
mongoose.connect(DB).then(()=>{
    console.log("Connection Successfully");
}).catch((e)=>{
    console.log(e);
});


// listen at port
app.listen(PORT,()=>{
    console.log(`Listen at port ${PORT}`);
});

