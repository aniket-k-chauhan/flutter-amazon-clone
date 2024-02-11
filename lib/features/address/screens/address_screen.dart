import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widgets/custom_textfield.dart';
import 'package:flutter_amazon_clone/common/widgets/loader.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/features/address/services/address_services.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address-screen";
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressFormKey = GlobalKey<FormState>();

  final TextEditingController _flatBuildingController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final Future<PaymentConfiguration> _applePayConfigFuture =
      PaymentConfiguration.fromAsset("applepay.json");
  final Future<PaymentConfiguration> _googlePayConfigFuture =
      PaymentConfiguration.fromAsset("gpay.json");

  final AddressSevices addressSevices = AddressSevices();

  String addressToBeUsed = "";
  List<PaymentItem> paymentItems = [];

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: "Total Amount",
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _flatBuildingController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
  }

  void onApplePayResult(res) {
    if (context.read<UserProvider>().user.address.isEmpty) {
      addressSevices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressSevices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalAmount: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (context.read<UserProvider>().user.address.isEmpty) {
      addressSevices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressSevices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalAmount: double.parse(widget.totalAmount),
    );

    Navigator.pop(context);
  }

  void payPressed(String addressFormProvider) {
    addressToBeUsed = "";

    bool isForm = _flatBuildingController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _pincodeController.text.isNotEmpty ||
        _cityController.text.isNotEmpty;
    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            "${_flatBuildingController.text}, ${_areaController.text}, ${_cityController.text} - ${_pincodeController.text}";
      } else {
        throw Exception("Please enter all the values!");
      }
    } else if (addressFormProvider.isNotEmpty) {
      addressToBeUsed = addressFormProvider;
    } else {
      showSnackBar(context: context, text: "Please provide an address");
      throw Exception("Empty address!");
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Existing Address
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Text(
                        address,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "OR",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              // New Address Form
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _flatBuildingController,
                      hintText: 'Flat, House no. Building',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextfield(
                      controller: _areaController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextfield(
                      controller: _pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextfield(
                      controller: _cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              // Apple Pay Button
              FutureBuilder<PaymentConfiguration>(
                future: _applePayConfigFuture,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ApplePayButton(
                          onPressed: () => payPressed(address),
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.only(top: 15),
                          type: ApplePayButtonType.buy,
                          style: ApplePayButtonStyle.whiteOutline,
                          loadingIndicator: const Loader(),
                          paymentConfiguration: snapshot.data,
                          onPaymentResult: onApplePayResult,
                          paymentItems: paymentItems,
                        )
                      : const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 10),
              // GPay Button
              FutureBuilder<PaymentConfiguration>(
                future: _googlePayConfigFuture,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? GooglePayButton(
                          onPressed: () => payPressed(address),
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.only(top: 15),
                          type: GooglePayButtonType.buy,
                          loadingIndicator: const Loader(),
                          paymentConfiguration: snapshot.data,
                          onPaymentResult: onGooglePayResult,
                          paymentItems: paymentItems,
                        )
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
