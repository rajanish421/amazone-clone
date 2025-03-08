const express = require('express');
const productRouter = express.Router();
const auth = require('../middlewares/auth');
const { Product } = require('../models/product');

// category products
productRouter.get('/api/products',auth,async(req,res)=>{
    try{
        console.log(req.query.category);
        const product = await Product.find({category:req.query.category});
        res.json(product);
    }catch(err){
        res.status(500).json({error:err.message});
    }
});


// search products

productRouter.get('/api/products/search/:name' ,auth,async(req,res)=>{
    try{
        // here we have to use regex concept like email auth.
        const products = await Product.find({
            name:{$regex:req.params.name,$options:"i"},
        }); 
        res.json(products);       
    }catch(e){
        console.log("error");
        res.status(500).json({error:e.message});
    }
});

module.exports = productRouter;