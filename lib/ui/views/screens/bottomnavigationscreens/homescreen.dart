// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, deprecated_member_use, use_build_context_synchronously, prefer_const_constructors_in_immutables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, sort_child_properties_last

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/models/homeprodmodel.dart';
import 'package:new_horizon/core/models/itemmodel.dart';
import 'package:new_horizon/core/services/apis/user/addtocart.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/HomeScreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/favouritteitemcontroller.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/allpatients.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/countercartcontroller.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/productdetails3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class BottomHomeScreen extends StatefulWidget {
  @override
  _BottomHomeScreenState createState() => _BottomHomeScreenState();
}

String? username;
var heights = Get.height;
var widths = Get.width;

class _BottomHomeScreenState extends State<BottomHomeScreen> {
  Future<void> getusername() async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedName = prefs.getString('name');
    setState(() {
      username = fetchedName;
    });
  }

  final List<MyItem> items = [
    MyItem('Recommended', AssetConstants.recommended),
    MyItem('Grafts', AssetConstants.grafts),
    MyItem('Injectables', AssetConstants.injection),
    MyItem('DME', AssetConstants.dmes),
    MyItem('Service fee', AssetConstants.servicefee),
    MyItem('Other', AssetConstants.others),
  ];

  @override
  void initState() {
    super.initState();
    getusername();
    controller.loadCartProducts();
    favcontroller.loadFavProducts(context);
    log(heights.toString());
    log(widths.toString());
  }

  int? favorites = 0;
  String? selectedCategory;

  int? selectedIdx = 0;
  void _exitApp() {
    if (Platform.isAndroid) {
      exit(0);
    } else if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Exit App'),
                content: Text('Do you want to Exit?'),
                actions: [
                  Container(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No')),
                  ),
                  Container(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          _exitApp();
                        },
                        child: Text('Exit')),
                  )
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: .0, right: 0),
              child: Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      AppNavigatorService.pushNamed(Route_paths.notifications);
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Color.fromRGBO(65, 65, 65, 1),
                      size: 28,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 0,
                    left: 5,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 3, 173, 37),
                      ),
                      child: Center(
                          child: Text(
                        "",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 0),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        AppNavigatorService.pushNamed(Route_paths.favorite);
                      },
                      icon: const Icon(
                        Icons.favorite_outline_outlined,
                        color: Color.fromRGBO(65, 65, 65, 1),
                        size: 27,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        height: 16,
                        width: 18,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: appcolor.textColor,
                        ),
                        child: Center(child: Obx(() {
                          controller.trigger.value;
                          return Text(favcontroller.itemsadded.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ));
                        })),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen(initialIndex: 1)));
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color.fromRGBO(65, 65, 65, 1),
                        size: 28,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 8,
                      child: Container(
                        height: 16,
                        width: 18,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: appcolor.textColor),
                        child: Center(child: Obx(() {
                          controller.trigger
                              .value; // This forces a rebuild whenever trigger changes
                          return Text(controller.itemsadded.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ));
                        })),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  height: heights <= 693 && widths <= 430
                      ? Get.height * 0.367
                      : Get.height * 0.323,
                  width: Get.width,
                  child: Column(
                    children: [
                      _buildRow(
                        [
                          _buildButton(
                            title: [
                              TextSpan(
                                text: 'Benefit ',
                                style: TextStyle(
                                  letterSpacing: 1.4,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Segoe UI',
                                  fontSize: heights <= 690 && widths <= 430
                                      ? 15
                                      : 16.3,
                                ),
                              ),
                              TextSpan(
                                text: 'Verification',
                                style: TextStyle(
                                  letterSpacing: 1.4,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Segoe UI',
                                  fontSize: heights <= 690 && widths <= 430
                                      ? 15
                                      : 15.7,
                                ),
                              ),
                            ],
                            color: Color.fromRGBO(3, 111, 173, 1),
                            asset: AssetConstants.datasubmission,
                            onTap: () async {
                              AppNavigatorService.pushNamed(
                                  Route_paths.datasubmission);
                            },
                          ),
                          SizedBox(width: Get.width * 0.02),
                          _buildButton(
                            title: [
                              TextSpan(
                                text: 'Products',
                                style: TextStyle(
                                  letterSpacing: 1.4,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Segoe UI',
                                  fontSize:
                                      heights <= 690 && widths <= 430 ? 15 : 18,
                                ),
                              ),
                            ],
                            color: Color.fromRGBO(111, 187, 245, 1),
                            asset: AssetConstants.product,
                            onTap: () {
                              AppNavigatorService.pushNamed(
                                  Route_paths.products);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      _buildRow(
                        [
                          _buildButton(
                            title: [
                              TextSpan(
                                text: 'Claims',
                                style: TextStyle(
                                  letterSpacing: 1.4,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Segoe UI',
                                  fontSize:
                                      heights <= 690 && widths <= 430 ? 15 : 18,
                                ),
                              ),
                            ],
                            color: Color.fromRGBO(1, 175, 193, 1),
                            asset: AssetConstants.billing,
                            onTap: () {
                              AppNavigatorService.pushNamed(
                                  Route_paths.billing);
                            },
                          ),
                          SizedBox(width: Get.width * 0.02),
                          _buildButton(
                            title: [
                              TextSpan(
                                text: 'Patients',
                                style: TextStyle(
                                  letterSpacing: 1.4,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Segoe UI',
                                  fontSize:
                                      heights <= 690 && widths <= 430 ? 15 : 18,
                                ),
                              ),
                            ],
                            color: Color.fromRGBO(0, 90, 99, 1),
                            asset: AssetConstants.patientsscreen,
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllPatients()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Get.height * 0.007),
                  child: SizedBox(
                    height: heights <= 690 && widths <= 430
                        ? Get.height * 0.15
                        : Get.height *
                            0.135, // heights <= 690 && widths <= 430 ? 15 : 17,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            double containerSide = constraints.maxHeight * 0.6;
                            double imageSize = containerSide * 0.5;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIdx = index;
                                  });
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIdx = index;
                                          selectedCategory =
                                              items[index].name == 'Recommended'
                                                  ? null
                                                  : items[index].name;
                                        });
                                        fetchProducts(
                                            context, selectedCategory);
                                      },
                                      child: Container(
                                        width: containerSide,
                                        height: containerSide,
                                        decoration: BoxDecoration(
                                          color: selectedIdx == index
                                              ? Color.fromARGB(
                                                  120, 214, 243, 253)
                                              : appcolor.colorcheck,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            items[index].imagePath,
                                            width: imageSize,
                                            height: imageSize,
                                            color: selectedIdx == index
                                                ? Color.fromARGB(
                                                    255, 39, 104, 164)
                                                : Color.fromARGB(
                                                    255, 103, 152, 189),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: constraints.maxHeight * 0.02),
                                    Text(
                                      items[index].name,
                                      style: TextStyle(
                                        fontSize: constraints.maxHeight * 0.1,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Segoe UI',
                                        color: selectedIdx == index
                                            ? Color.fromARGB(255, 39, 104, 164)
                                            : Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Get.height * 0.009),
                  child: SizedBox(
                      height: heights <= 690 && widths <= 430
                          ? Get.height * 0.15
                          : Get.height * 0.22,
                      child: FutureBuilder<List<Product>>(
                        future: fetchProducts(context, selectedCategory),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(1.0),
                                  itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Container(
                                    width: 140,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ));
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final products = snapshot.data!;

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                if (index == 4) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: heights <= 690 && widths <= 430
                                            ? 12
                                            : 48,
                                        right: 20,
                                        left: 10),
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(10),
                                          ),
                                          onPressed: () {
                                            AppNavigatorService.pushNamed(
                                                Route_paths.products);
                                          },
                                          child: Icon(Icons.arrow_forward,
                                              size: heights <= 690 &&
                                                      widths <= 430
                                                  ? 18
                                                  : 30,
                                              color: Color.fromARGB(255, 255,
                                                  255, 255)), // Arrow icon
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'View more',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Humanist Sans',
                                            fontSize:
                                                heights <= 690 && widths <= 430
                                                    ? 10
                                                    : 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (index < products.length) {
                                  return ProductCard(
                                    products: products,
                                    index: index,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                          }
                        },
                      )),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildRow(List<Widget> buttons) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.030, vertical: 1),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons,
    ),
  );
}

Widget _buildButton({
  required List<TextSpan> title,
  required Color color,
  required String asset,
  required VoidCallback onTap,
}) {
  return Flexible(
    child: GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            height: heights <= 690 && widths <= 430
                ? Get.height * 0.167
                : Get.height * 0.145, //Get.height * 0.146,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(children: title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(asset),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Image.asset(AssetConstants.arrow),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

final CounterController controller = Get.put(CounterController());
final Favcartcounter favcontroller = Get.put(Favcartcounter());

class ProductCard extends StatefulWidget {
  final int index;
  final List<Product> products;

  ProductCard({required this.index, required this.products});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String truncateProductName(String name) {
    if (name.length > 15) {
      return name.substring(0, 15) + '...';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails3(
                        imageUrl: widget.products[widget.index].imageUrl,
                        description: widget.products[widget.index].description,
                        price: widget.products[widget.index].price,
                        name: widget.products[widget.index].name,
                        productId: widget.products[widget.index].product_id,
                      )));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(6.0)),
                      child: Container(
                        width: 145, // specify the width
                        height: 130, // specify the height
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                widget.products[widget.index].imageUrl),
                            fit: BoxFit
                                .cover, // This will cover the container area without changing the aspect ratio of the image
                          ),
                        ),
                        child: Image.network(
                          widget.products[widget.index].imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Container(
                              color: Color.fromARGB(255, 240, 250, 255),
                              width: 85,
                              height: 90,
                              child: Center(
                                child: Text(
                                  'Not Found',
                                  style: TextStyle(
                                      fontFamily: 'Humanist Sans',
                                      fontSize: 12),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(224, 138, 138, 138),
                            borderRadius: BorderRadius.circular(5)),
                        height: heights <= 690 && widths <= 430 ? 20 : 30,
                        width: heights <= 690 && widths <= 430 ? 20 : 30,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            AssetConstants.cartico,
                          ),
                          // color: Colors.white,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  int counter = 1;

                                  return StatefulBuilder(builder:
                                      (BuildContext context, setState) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Container(
                                        height: 290,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Center(
                                                    child: Container(
                                                  height: Get.height * 0.1,
                                                  width: Get.width * 0.2,
                                                  child: Image.network(
                                                      widget
                                                          .products[
                                                              widget.index]
                                                          .imageUrl,
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                    return Container(
                                                      color: Color.fromARGB(
                                                          255, 240, 250, 255),
                                                      width: 85,
                                                      height: 90,
                                                      child: Center(
                                                          child: Text(
                                                        'Not Found',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Humanist Sans',
                                                            fontSize: 12),
                                                      )),
                                                    );
                                                  }),
                                                )),
                                              ),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20)),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Choose Quantity to add in Cart",
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontSize:
                                                          heights <= 690 &&
                                                                  widths <= 430
                                                              ? 11
                                                              : 13,
                                                      fontFamily: "Poppins"),
                                                ),
                                              ),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.remove),
                                                    onPressed: () {
                                                      if (counter > 1) {
                                                        setState(() {
                                                          counter--;
                                                        });
                                                      }
                                                      print(counter);
                                                    },
                                                  ),
                                                  Text('$counter',
                                                      textScaleFactor: 1.0),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      setState(() {
                                                        counter++;
                                                      });
                                                      print(counter);
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 00,
                                                            bottom: 10.0),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: ElevatedButton(
                                                            child: Text(
                                                                "Add to Cart"
                                                                    .toUpperCase(),
                                                                textScaleFactor:
                                                                    1.0,
                                                                style: TextStyle(
                                                                    fontSize: heights <= 690 &&
                                                                            widths <=
                                                                                321
                                                                        ? 9
                                                                        : 14)),
                                                            style: ButtonStyle(
                                                                foregroundColor:
                                                                    MaterialStateProperty.all<Color>(Colors
                                                                        .white),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<Color>(
                                                                        appcolor.textColor),
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: appcolor.textColor)))),
                                                            onPressed: () {
                                                              context
                                                                  .loaderOverlay
                                                                  .show();
                                                              AddtoCart.AddinCart(
                                                                  widget
                                                                      .products[
                                                                          widget
                                                                              .index]
                                                                      .product_id,
                                                                  counter,
                                                                  context);

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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.008,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.02),
                    child: Text(
                      truncateProductName(widget.products[widget.index].name),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.6,
                          fontFamily: 'Segoe UI',
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.02),
                    child: Row(
                      children: [
                        Text(
                          '\$' + widget.products[widget.index].price.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontFamily: 'Segoe UI'),
                        ),
                        SizedBox(
                          width: Get.width * 0.005,
                        ),
                        Text(
                          ' \$70',
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: 'Segoe UI'),
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.008,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
