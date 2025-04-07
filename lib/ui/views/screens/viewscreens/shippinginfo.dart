// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation, prefer_const_constructors, deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/cartcontroller.dart';

class ShippingInfo extends StatefulWidget {
  final Map<String, dynamic> responseData;

  const ShippingInfo({Key? key, required this.responseData}) : super(key: key);

  @override
  State<ShippingInfo> createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppNavigatorService.navigateToReplacement(Route_paths.products);
        return false; // Suppress the default back action
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      onPressed: () {
                        log(widget.responseData['order_id']);
                      },
                      icon: const Icon(
                        Icons.shopping_cart_rounded,
                        color: appcolor.textColor,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '  Cart',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Segoe UI',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        ' Personal Information',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Segoe UI',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(' Shipping ',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 14,
                              color: appcolor.textColor,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: Get.height * 0.035),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligning text to the start
                  children: <Widget>[
                    Wrap(
                      // Wrap widget will automatically move its children to the next line if they do not fit
                      children: [
                        Text(
                          'Your Order is Confirmed (Order Id # ${widget.responseData['order_id']})',
                          style: const TextStyle(
                            fontFamily: 'Humanist Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Handle text overflow
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 8), // Provide some spacing between text widgets
                    Wrap(
                      // Use Wrap here too
                      children: [
                        const Text(
                          'We have Accepted Your Order, and We are getting it ready. Come Back to this Page for Updates on your Shipment status.',
                          style: TextStyle(
                            letterSpacing: 0.2,
                            fontFamily: 'Humanist Sans',
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w200,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Handle text overflow
                          maxLines: 3, // Consider setting maxLines if needed
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.03, right: Get.width * 0.03),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color.fromARGB(255, 214, 214, 214),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: Get.width,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Text(
                              'Order Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                fontFamily: 'Humanist Sans',
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            Text(
                              'Contact Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                fontFamily: 'Humanist Sans',
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.responseData['billing_email']}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            Text(
                              'Shipping Address',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                fontFamily: 'Humanist Sans',
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.responseData['first_name']} ',
                              style: const TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.responseData['shipping_address']} , ${widget.responseData['shipping_city']} , ${widget.responseData['country']}',
                              style: const TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.responseData['phone_number']} ',
                              style: const TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            Text(
                              'Shipping Method',
                              style: TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: const [
                            Text(
                              'Free Shipping',
                              style: TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            Text(
                              'Billing Address',
                              style: TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.responseData['billing_address']} , ${widget.responseData['billing_city']} , ${widget.responseData['country']}',
                              style: const TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.responseData['billing_phone_number']} ',
                              style: const TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Text(
                              'Note',
                              style: TextStyle(
                                  letterSpacing: 0.2,
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            widget.responseData['note'] == ''
                                ? Text(
                                    '---',
                                    style: const TextStyle(
                                        letterSpacing: 0.2,
                                        fontFamily: 'Humanist Sans',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  )
                                : Text(
                                    '${widget.responseData['note']} ',
                                    style: const TextStyle(
                                        letterSpacing: 0.2,
                                        fontFamily: 'Humanist Sans',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: EdgeInsets.only(
              //       left: Get.width * 0.03, right: Get.width * 0.03),
              //   child: Card(
              //     shape: const RoundedRectangleBorder(
              //         side: BorderSide(
              //           color: Color.fromARGB(255, 214, 214, 214),
              //         ),
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //     child: Container(
              //       padding: const EdgeInsets.all(15),
              //       width: Get.width,
              //       child: Column(
              //         children: [
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           Row(
              //             children: const [
              //               Text(
              //                 'Payment Method',
              //                 style: TextStyle(
              //                     fontSize: 18, fontWeight: FontWeight.bold),
              //               ),
              //             ],
              //           ),
              //           Row(
              //             children: const [
              //               Text(
              //                 'Cash On Delivery (COD) ',
              //                 style: TextStyle(
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.normal,
              //                     color: Colors.grey),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.015,
                    right: Get.width * 0.05,
                    bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '',
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Humanist Sans',
                          fontSize: 16),
                    ),
                    Container(
                      height: Get.height * 0.045,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: const LinearGradient(colors: [
                            appcolor.textColor,
                            Color.fromARGB(255, 164, 199, 255)
                          ])),
                      child: ElevatedButton(
                        onPressed: () async {
                          final CartController controller1 =
                              Get.put(CartController());
                          controller1.loadCartProducts();
                          AppNavigatorService.navigateToReplacement(
                              Route_paths.home);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent),
                        child: const Text(
                          'Continue Shoping',
                          style: TextStyle(fontFamily: 'Humanist Sans'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
