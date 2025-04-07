// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, prefer_interpolation_to_compose_strings, avoid_print, unnecessary_string_interpolations, sized_box_for_whitespace, sort_child_properties_last, no_leading_underscores_for_local_identifiers, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/favmodel.dart';
import 'package:new_horizon/core/services/apis/user/addtocart.dart';
import 'package:new_horizon/core/services/apis/user/favoriteapi.dart';
import 'package:new_horizon/core/services/apis/user/removefavoriteapi.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/productdetails2.dart';
import 'package:new_horizon/ui/widgets/datasubmissionform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

String? username;

class _FavoriteState extends State<Favorite> {
  Future<void> getusername() async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedName = prefs.getString('name');
    setState(() {
      username = fetchedName;
    });
  }

  String truncateProductname(String name) {
    if (name.length > 30) {
      return name.substring(0, 30) + '...';
    }
    return name;
  }

  String truncateProductdesc(String name) {
    if (name.length > 40) {
      return name.substring(0, 40) + '...';
    }
    return name;
  }

  @override
  void initState() {
    super.initState();
    getusername();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined,
                size: 20, color: Colors.black), // Change the color here
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(Get.height * 0.011),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          username.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          ' Org Admin',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.normal,
                              fontSize: 8.75),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.015,
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black,
                    child: GestureDetector(
                        onTap: () {}, child: Icon(Icons.person_2_outlined)),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Column(children: [
          SizedBox(
            height: Get.height * 0.02,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.04),
                child: const Text(
                  'Favorites',
                  style: TextStyle(
                      fontFamily: 'Humanist sans',
                      fontSize: 20,
                      color: appcolor.textColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<List<FavModel>>(
              future: GetFavProdApi.getfavProdapi(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 9.0, right: 9.0, top: 0, bottom: 7),
                        child: Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.grey[300],
                                      width: 85,
                                      height: 85,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 70,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.005),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: <Widget>[
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(19),
                                        ),
                                        height: 18,
                                        width: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 32.0),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  // If there's an error, show an error message
                  return Center(child: Text('Failed to load data'));
                } else {
                  final products = snapshot.data;

                  if (products!.isEmpty) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 140.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AssetConstants.nofavicon),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'No Favourites Found',
                              style: TextStyle(
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ));
                  }
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 0, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails2(
                                    imageUrl: product.imageUrl[0],
                                    description: products[index].description,
                                    price: product.price.toDouble(),
                                    name: product.productName,
                                    productId: product.productId,
                                    isFavorite: false),
                              ),
                            );
                          },
                          child: Card(
                            // color: Color.fromARGB(255, 229, 229, 229),
                            margin: EdgeInsets.zero,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.network(
                                              product.imageUrl[
                                                  0], // Assuming imageUrl is a List<String>
                                              width: 85,
                                              height: 85,
                                              fit: BoxFit.cover, errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                            return Container(
                                              color: Color.fromARGB(
                                                  255, 240, 250, 255),
                                              width: 85,
                                              height: 90,
                                              child: Center(
                                                  child: Text(
                                                'Not Found',
                                                style: TextStyle(
                                                    fontFamily: 'Humanist Sans',
                                                    fontSize: 12),
                                              )),
                                            );
                                          }),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 14),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  capitalizeFirst(
                                                      truncateProductname(
                                                    product.productName,
                                                  )),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Segoe UI',
                                                      fontSize: 15),
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.006),
                                                Text(
                                                  "Price: " +
                                                      "\$${product.price}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Segoe UI',
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          255, 132, 132, 132)),
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.008),
                                                Text(
                                                  capitalizeFirst(
                                                      truncateProductdesc(
                                                          product.description)),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Segoe UI',
                                                      fontSize: 13,
                                                      color: Color.fromARGB(
                                                          255, 138, 138, 138)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      223, 250, 250, 250),
                                                  border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 166, 166, 166),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          19) //
                                                  ),
                                              height: 18,
                                              width: 18,
                                              child: IconButton(
                                                  padding: EdgeInsets.all(
                                                      0), // Remove padding from IconButton
                                                  icon: SizedBox(
                                                    width: 8,
                                                    height: 8,
                                                    child: SvgPicture.asset(
                                                      AssetConstants.cross,
                                                      color: Color.fromARGB(
                                                          255, 166, 166, 166),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    context.loaderOverlay
                                                        .show();
                                                    Removefavorite
                                                            .Removefavoriteapi(
                                                                product
                                                                    .productId,
                                                                context)
                                                        .then((value) =>
                                                            setState(() {
                                                              GetFavProdApi
                                                                  .getfavProdapi(
                                                                      context);
                                                            }));
                                                  }),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 32.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          224, 138, 138, 138),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  height: 32,
                                                  width: 32,
                                                  child: IconButton(
                                                      icon: SvgPicture.asset(
                                                        AssetConstants.cartico,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              int _counter =
                                                                  1; // Initializing the counter for the quantity

                                                              return StatefulBuilder(
                                                                  // Using StatefulBuilder to rebuild the widget when state changes
                                                                  builder: (BuildContext
                                                                          context,
                                                                      setState) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0)),
                                                                  child:
                                                                      Container(
                                                                    height: 290,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          12.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 10.0),
                                                                            child: Center(
                                                                                child: Container(
                                                                              height: Get.height * 0.1,
                                                                              width: Get.width * 0.2,
                                                                              child: Image.network('${product.imageUrl[0]}', errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                return Container(
                                                                                  color: Color.fromARGB(255, 240, 250, 255),
                                                                                  width: 85,
                                                                                  height: 90,
                                                                                  child: Center(
                                                                                      child: Text(
                                                                                    'Not Found',
                                                                                    style: TextStyle(fontFamily: 'Humanist Sans', fontSize: 12),
                                                                                  )),
                                                                                );
                                                                              }),
                                                                            )),
                                                                          ),
                                                                          const Padding(
                                                                              padding: EdgeInsets.only(top: 20)),
                                                                          const Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Text(
                                                                              "Choose Quantity to add in Cart",
                                                                              textScaleFactor: 1.0,
                                                                              style: TextStyle(fontFamily: "Poppins"),
                                                                            ),
                                                                          ),

                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              IconButton(
                                                                                icon: Icon(Icons.remove),
                                                                                onPressed: () {
                                                                                  if (_counter > 1) {
                                                                                    setState(() {
                                                                                      _counter--;
                                                                                    });
                                                                                  }
                                                                                  print(_counter);
                                                                                },
                                                                              ),
                                                                              Text('$_counter', textScaleFactor: 1.0),
                                                                              IconButton(
                                                                                icon: Icon(Icons.add),
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    _counter++;
                                                                                  });
                                                                                  print(_counter);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          // Existing buttons for Yes and No
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 00, bottom: 10.0),
                                                                                child: Align(
                                                                                    alignment: Alignment.bottomCenter,
                                                                                    child: ElevatedButton(
                                                                                        child: Text("Add to Cart".toUpperCase(), textScaleFactor: 1.0, style: const TextStyle(fontSize: 14)),
                                                                                        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white), backgroundColor: MaterialStateProperty.all<Color>(appcolor.textColor), shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: appcolor.textColor)))),
                                                                                        onPressed: () {
                                                                                          context.loaderOverlay.show();
                                                                                          AddtoCart.AddinCart(product.productId, _counter, context);

                                                                                          // print('${products[index].product_id}');
                                                                                        })),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                            });
                                                      })),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
