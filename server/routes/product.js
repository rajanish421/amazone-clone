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


// rating api

productRouter.post('/api/rate-product',auth,async(req,res)=>{
    try{
        const {id , rating} = req.body;
        let product = await Product.findById(id);

        // user already rated
        for(let i=0;i<product.ratings.length;i++){
            if(product.ratings[i].userId == req.user){
                product.ratings.splice(i,1);
                break;
            }
        }

        const ratingSchema = {
            userId : req.user,
            rating,
        }

        product.ratings.push(ratingSchema);
       product = await product.save();
       res.json(product);

    }catch(e){
        res.status(500).json({error:e.message});
    }
});

// api for deal of the date

    productRouter.get('/api/deal-of-the-day',auth ,async(req,res)=>{
        try{

            let products = await Product.find({});

            products =  products.sort((a,b)=>{

                let aSum = 0;
                let bSum = 0;

                for(let i=0;i<a.ratings.length;i++){
                    aSum += a.ratings[i].rating;
                }

                for(let i=0;i<b.ratings.length;i++){
                    bSum += b.ratings[i].rating;
                }

                return aSum<bSum ? 1:-1;
            });

            res.json(products[0]);
        }catch(e){
            console.log('error from here');
            res.status(500).json({error:e.message});
        }
    });

module.exports = productRouter;