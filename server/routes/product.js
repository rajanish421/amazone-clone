const express = require('express');
const productRouter = express.Router();
const auth = require('../middlewares/auth');
const { Product } = require('../models/product');

productRouter.get('/api/products',auth,async(req,res)=>{
    try{
        console.log(req.query.category);
        const product = await Product.find({category:req.query.category});
        res.json(product);
    }catch(err){
        res.status(500).json({error:err.message});
    }
});

module.exports = productRouter;