const express = require("express");
const adminRouter = express.Router();
const admin = require('../middlewares/admin');
const { Product } = require("../models/product");
const Order = require("../models/order");
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


  // fetch all order api

  adminRouter.get('/admin/get-orders',admin,async(req,res)=>{
    try{
      const orders = await Order.find();
      res.json(orders);

    }catch(e){
      res.status(500).json({error:e.message});
    }
  });

  // api for change the order status

  adminRouter.post('/admin/change-order-status',admin,async(req,res)=>{
    try{
      const {id , status }= req.body;
      let order = await Order.findById(id);
      order.status = status;
      order = await order.save();
      res.json(order);
    }catch(e){
      res.status(500).json({error:e.message});
    }
  });

// get data for analytics

adminRouter.get('/admin/analytics',admin , async(req,res)=>{
  try{
    const orders = await Order.find({});
    let totalEarnings = 0;

    for(let i=0;i<orders.length;i++){
        for(let j=0;j<orders[i].products.length;j++){
            totalEarnings += orders[i].products[j].quantity * orders[i].products[j].product.price ;
        }
    }

// Categories wise ordering

  let mobileEarnings =  await fetchCategoryWiseProduct("Mobiles");
  let essentialsEarnings =  await fetchCategoryWiseProduct("Essentials");
  let appliancesEarnings =  await fetchCategoryWiseProduct("Appliances");
  let booksEarnings =  await fetchCategoryWiseProduct("Books");
  let fashionEarnings =  await fetchCategoryWiseProduct("Fashion");

  let earnings = {
    totalEarnings,
    mobileEarnings,
    essentialsEarnings,
    appliancesEarnings,
    booksEarnings,
    fashionEarnings
  }
  res.json(earnings);

  }catch(e){
    res.status(500).json({error:e.message});
  }
});


//get product categories wise 

async function fetchCategoryWiseProduct(category){
  let earnings = 0;
  let categoryOrder = await Order.find({
    'products.product.category':category
  });

  for(let i=0;i<categoryOrder.length;i++){
    for(let j=0;j<categoryOrder[i].products.length;j++){
      earnings += categoryOrder[i].products[j].quantity * categoryOrder[i].products[j].product.price ;
    }
}
return earnings;
}


  module.exports = adminRouter;