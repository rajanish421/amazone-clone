const express = require("express");
const adminRouter = express.Router();
const admin = require('../middlewares/admin');
const { Product } = require("../models/product");
// add - product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
    try {
      const { name, description,quantity,images,category ,price } = req.body;
      let product = new Product({
        name,
        description,
        quantity,
        images,
        category,
        price,
      });
      product = await product.save();
      res.json(product);
    } catch (e) {
        console.log("hellooo");
      res.status(500).json({ error: e.message });
    }
  });

  // Get Products

  adminRouter.get('/admin/get-products',admin, async(req,res)=>{
    try{
      const products = await Product.find({});
      res.json(products);
    }catch(err){
      res.status(500).json({error:err.message});
    }
  });


  // delete Products

  adminRouter.post('/admin/delete-product',admin ,async (req,res)=>{
    try{
      const { id } = req.body;
      const product = await Product.findByIdAndDelete(id);
      res.json(product);
    }catch(e){
      console.log("error");
      res.status(500).json({error:e.message});
    }
  });

  module.exports = adminRouter;