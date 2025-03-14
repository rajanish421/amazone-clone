import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../comman/widgets/custom_button.dart';
import '../../../constants/global_variable.dart';
import '../../../providers/user_provider.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/cart_product.dart';
import '../widgets/cart_subtotal.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddressScreen(int sum) {
    Navigator.pushNamed(context, AddressScreen.routeName,arguments:sum.toString());
  }


  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart.map((e)=>sum+=e['quantity']*e['product']['price'] as int).toList();
    
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    margin: EdgeInsets.only(left: 15),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(7),
                      child: TextFormField(
                        onFieldSubmitted: navigateToSearchScreen,
                        decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.search,
                              size: 23,
                              color: Colors.black,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(top: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1)),
                          hintText: "Search Amazon.in",
                          hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 42,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.mic,
                    size: 25,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: 'Proceed to buy ${user.cart.length} items',
                onTap: ()=>navigateToAddressScreen(sum),
                color: Colors.yellow[500],
                textColor: Colors.black,
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(height: 5,),
            ListView.builder(
              shrinkWrap: true,
              itemCount: user.cart.length,
              itemBuilder: (context, index) {
               return CartProduct(index: index,);
            },)
          ],
        ),
      ),
    );
  }
}
