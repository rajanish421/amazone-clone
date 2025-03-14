import 'package:amazon_clone/comman/widgets/custom_button.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import '../../../comman/widgets/custom_textFiel.dart';
import '../../../constants/global_variable.dart';
import '../../../providers/user_provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address";
  final String totalAmount;

  AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final AddressServices addressServices = AddressServices();
  String addressToBeUsed = "";
  List<PaymentItem> paymentItems = [];
  final _addressFormKey = GlobalKey<FormState>();

  PaymentConfiguration? _paymentConfig;

  @override
  void initState() {
    super.initState();
    _loadPaymentConfig();
    paymentItems.add(
      PaymentItem(
          amount: widget.totalAmount,
          label: "Total Amount",
          status: PaymentItemStatus.final_price),
    );
  }

  Future<void> _loadPaymentConfig() async {
    try {
      final config = await PaymentConfiguration.fromAsset('gpay.json');
      setState(() {
        _paymentConfig = config;
      });
    } catch (e) {
      print("Error loading payment config: $e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flatController.dispose();
    areaController.dispose();
    pinCodeController.dispose();
    cityController.dispose();
  }

  void onPaymentResult() {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      print("- hello on payment called");
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";
    bool isForm = flatController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pinCodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;
    print((isForm));
    if (isForm) {
      print(_addressFormKey.currentState!.validate());
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatController.text}, ${areaController.text}, ${cityController.text} - ${pinCodeController.text}';
        onPaymentResult();
      } else {
        throw Exception('Please enter all the values!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'ERROR');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    print("Payment Config: $_paymentConfig");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _addressFormKey,
            child: Column(
              children: [
                if (address.isNotEmpty)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Text(
                            address,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text(
                          'OR',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                CustomTextfield(
                  controller: flatController,
                  hintText: "Flat,House no,Building",
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextfield(
                  controller: areaController,
                  hintText: "Area, Street",
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextfield(
                  controller: pinCodeController,
                  hintText: "PinCode",
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextfield(
                  controller: cityController,
                  hintText: "Town/City",
                ),
                SizedBox(
                  height: 10,
                ),
                _paymentConfig == null
                    ? CircularProgressIndicator()
                    : GooglePayButton(
                        onPressed: () => payPressed(address),
                        paymentConfiguration: _paymentConfig!,
                        paymentItems: paymentItems,
                        onPaymentResult: (res) {
                          print("Google Pay Result Received!");
                          print(res);
                        },
                        height: 50,
                        type: GooglePayButtonType.buy,
                        margin: EdgeInsets.only(top: 15),
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        width: double.infinity,
                      ),
                CustomButton(
                  text: 'Buy ',
                  onTap:()=> payPressed(address),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
