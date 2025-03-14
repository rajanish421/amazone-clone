
const express = require("express");
const authRoute = express.Router();
const bcryptjs = require("bcryptjs");
const User = require('../models/user');
const jwt = require('jsonwebtoken');
const auth = require("../middlewares/auth");


// SIGN UP ROUTE
   authRoute.post("/api/signup",async(req,res)=>{
      try{
      // get data from the client
      console.log("post methods called");
          const {name , email , password} = req.body;
  
      // check user exist or not
         const existingUser = await User.findOne({email});
  
      // when user exist
         if(existingUser){
          console.log("User exist");
              return res.status(400).json({msg:"User with same email already exist!"});
         }
           
      // when user not exist then create a new user
         const hashPassword = await bcryptjs.hash(password,8);  // password hashing
       console.log("user not exist");

       // new user instance
         let user = new User({
          name,
          email,
          password:hashPassword
         });

         // save new user
         user = await user.save();

         // send user data to client
         res.json(user);

         // any error
      }catch(e){
         console.log("error from auth js");
         res.status(500).json({ error : e.message } );
      }
  });

// SIGN IN ROUTE 
   authRoute.post("/api/signin",async(req,res)=>{
      try{
         // get user data
         const {email , password} = req.body;

        const user = await  User.findOne({email});
        if(!user){
         return res.status(400).json({msg:"User does not exist with this email"});
        }

        const isMatch = await bcryptjs.compare(password,user.password);
        if(!isMatch){
         return res.status(400).json({msg:'Incorrect password'});
        }
         const token = jwt.sign({id:user._id},"passwordKey");
         res.json({token,...user._doc});
         

      }catch(e){
         res.status(500).json({error:e.message});
      }
   });   


// Check validiti of the token   
   authRoute.post('/tokenIsValid',async(req,res)=>{
      try{
           const token = req.header('x-auth-token');
           if(!token) return res.json(false);
           const verified =  jwt.verify(token,'passwordKey');
           if(!verified) return res.json(false);
            const user =await  User.findById(verified.id);
            if(!user) return res.json(false);
            res.json(true);
      }catch(err){
         res.status(500).json({error:err.message});
      }
   });


// get user data if user authorized   
   authRoute.get('/',auth ,async(req,res)=>{
      const user = await User.findById(req.user);
      res.json({...user._doc,token:req.token});
   });

// export authRoute so that used by others
module.exports = authRoute;


