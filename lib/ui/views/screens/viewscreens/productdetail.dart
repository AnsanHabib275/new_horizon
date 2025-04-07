// ignore_for_file: unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, prefer_const_constructors, unnecessary_null_comparison, prefer_adjacent_string_concatenation, avoid_print, deprecated_member_use

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/services/apis/user/addfavoriteapi.dart';
import 'package:new_horizon/core/services/apis/user/addtocart.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/widgets/productcards.dart';

class ProductDetail extends StatefulWidget {
  final String imageUrl;
  final String description;
  final double price;
  final String name;
  final String productId;
  final bool isFavorite;

  const ProductDetail({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.name,
    required this.isFavorite,
    required this.productId,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String truncateProductName(String name) {
  if (name.length > 28) {
    return name.substring(0, 28) + '..';
  }
  return name;
}

class _ProductDetailState extends State<ProductDetail> {
  String productName = "Lorem Ipsum Dolor";
  String productprice = '750';
  String rating = '1';
  int productQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
              color: Colors.black,
            ), // Change the color here
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.475,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.imageUrl,
                      ), // Path to your image
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0752, 0.4812],
                      colors: [
                        const Color.fromARGB(208, 185, 185, 185),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // Use Expanded here to allow the text to take up remaining space
                          child: Padding(
                            padding: EdgeInsets.only(left: Get.width * 0.03),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  capitalizeFirstLetter(widget.name),
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Get.width * 0.02,
                            top: Get.width * 0.01,
                            right: Get.width * 0.03,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    height: 35,
                                    width: 35,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.remove, size: 16),
                                      onPressed: () {
                                        setState(() {
                                          if (productQuantity > 1) {
                                            productQuantity--;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: Get.width * 0.013,
                                      right: Get.width * 0.013,
                                    ),
                                    child: Text(
                                      " " + "$productQuantity" + " ",
                                      style: const TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    height: 35,
                                    width: 35,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.add, size: 16),
                                      onPressed: () {
                                        setState(() {
                                          productQuantity++;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.only(left: Get.width * 0.03),
                    //       child: Wrap(
                    //         direction: Axis
                    //             .horizontal, // This ensures the text wraps horizontally
                    //         children: [
                    //           Text(
                    //             capitalizeFirstLetter(widget.name),
                    //             style: TextStyle(
                    //               fontSize: 19,
                    //               fontFamily: 'Segoe UI',
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //             // Removed the overflow and maxLines properties to allow wrapping
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.only(
                    //           left: Get.width * 0.02,
                    //           top: Get.width * 0.01,
                    //           right: Get.width * 0.03),
                    //       child: Row(
                    //         children: <Widget>[
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               color: Color.fromARGB(255, 211, 211, 211),
                    //               borderRadius: BorderRadius.circular(6),
                    //             ),
                    //             height: 35,
                    //             width: 35,
                    //             child: IconButton(
                    //               padding: EdgeInsets.zero,
                    //               icon: const Icon(
                    //                 Icons.remove,
                    //                 size: 16,
                    //               ),
                    //               onPressed: () {
                    //                 setState(() {
                    //                   if (productQuantity > 1) {
                    //                     productQuantity--;
                    //                   }
                    //                 });
                    //               },
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.only(
                    //                 left: Get.width * 0.013,
                    //                 right: Get.width * 0.013),
                    //             child: Text(
                    //               " " + "$productQuantity" + " ",
                    //               style: const TextStyle(
                    //                 fontFamily: 'Segoe UI',
                    //                 fontSize: 16.0,
                    //               ),
                    //             ),
                    //           ),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               color: Color.fromARGB(255, 211, 211, 211),
                    //               borderRadius: BorderRadius.circular(8),
                    //             ),
                    //             height: 35,
                    //             width: 35,
                    //             child: IconButton(
                    //               padding: EdgeInsets.zero,
                    //               icon: const Icon(
                    //                 Icons.add,
                    //                 size: 16,
                    //               ),
                    //               onPressed: () {
                    //                 setState(() {
                    //                   productQuantity++;
                    //                 });
                    //               },
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: Get.width * 0.03,
                        top: Get.height * 0.0015,
                      ),
                      child: Row(
                        children: [
                          Text(
                            ('\$') + widget.price.toString(),
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: Get.width * 0.035,
                        top: Get.height * 0.015,
                        right: Get.width * 0.035,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              capitalizeFirstLetter(widget.description),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Segoe UI',
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                        left: Get.width * 0.003,
                        right: Get.width * 0.003,
                      ),
                      child: ExpandableTheme(
                        data: const ExpandableThemeData(
                          iconColor: appcolor.textColor,
                          useInkWell: true,
                        ),
                        child: Column(
                          children: <Widget>[
                            Card2(),
                            SizedBox(
                              width: Get.width * 0.95,
                              child: Divider(thickness: 2.0),
                            ),
                            Card3(),
                            SizedBox(
                              width: Get.width * 0.95,
                              child: Divider(thickness: 2.0),
                            ),
                            Card2(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: Get.width * 0.003,
                        right: Get.width * 0.003,
                      ),
                      child: ExpandableTheme(
                        data: const ExpandableThemeData(
                          iconColor: appcolor.textColor,
                          useInkWell: true,
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: Get.width * 0.03,
                                top: Get.height * 0.015,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 208, 208, 208),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: Get.height * 0.050,
                                    width: Get.width * 0.10,
                                    child: IconButton(
                                      icon:
                                          widget.isFavorite == false
                                              ? Icon(
                                                Icons.favorite_outline_sharp,
                                                color: Color.fromARGB(
                                                  255,
                                                  76,
                                                  76,
                                                  76,
                                                ),
                                              )
                                              : Icon(
                                                Icons.favorite_rounded,
                                                color: Color.fromARGB(
                                                  255,
                                                  215,
                                                  17,
                                                  17,
                                                ),
                                              ),
                                      onPressed: () {
                                        AddFavouriteapi.AddFavourite(
                                          widget.productId,
                                          context,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        context.loaderOverlay.show();
                                        AddtoCart.AddinCart(
                                          widget.productId,
                                          productQuantity,
                                          context,
                                        );
                                        print(widget.productId.toString());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: appcolor.textColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        minimumSize: Size(
                                          Get.width * 0.8,
                                          Get.height * 0.050,
                                        ),
                                      ),
                                      child: const Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
