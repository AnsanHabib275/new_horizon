// ignore_for_file: prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, unused_element, prefer_const_constructors_in_immutables, sized_box_for_whitespace, unnecessary_string_interpolations, sort_child_properties_last, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/models/cartproduct.dart';
import 'package:new_horizon/core/models/itemmodel.dart';
import 'package:new_horizon/core/services/apis/user/addfavoriteapi.dart';
import 'package:new_horizon/core/services/apis/user/addtocart.dart';
import 'package:new_horizon/core/services/apis/user/getcompletecart.dart';
import 'package:new_horizon/core/services/apis/user/productapi.dart';
import 'package:new_horizon/core/services/apis/user/removefavoriteapi.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/HomeScreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/countercartcontroller.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/productdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/models/productmodel.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

String? selectedCategory;

final List<MyItem> items = [
  MyItem('Recommended', AssetConstants.recommended),
  MyItem('Grafts', AssetConstants.grafts),
  MyItem('Injectables', AssetConstants.injection),
  MyItem('DME', AssetConstants.dmes),
  MyItem('Service fee', AssetConstants.servicefee),
  MyItem('Other', AssetConstants.others),
];

int? selectedIdx = 0;

bool isLoading = true;
String? username;

var heights = Get.height;
var widths = Get.width;
String truncateProductName(String name) {
  if (name.length > 14) {
    return name.substring(0, 14) + ' ..';
  }
  return name;
}

getusername() async {
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('name');
}

final CounterController controller = Get.put(CounterController());

class _ProductsState extends State<Products> {
  Future<List<CartProduct>>? futureProducts;
  List<CartProduct> products = [];
  int? itemsadded = 0;

  @override
  void initState() {
    super.initState();

    controller.loadCartProducts();
    log(heights.toString());
    log(widths.toString());
  }

  void updateCartItemCount() async {
    products = await GetUserCart.getcart();
    setState(() {
      itemsadded = products.length;
      context.loaderOverlay.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined,
                  size: 20, color: Colors.black), // Change the color here
              onPressed: () => AppNavigatorService.pop()
              //  Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => HomeScreen(initialIndex: 0)),
              //     )
              ),
          actions: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(initialIndex: 1)),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color.fromRGBO(65, 65, 65, 1),
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 8,
                  child: Container(
                    height: 16,
                    width: 18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: appcolor.textColor,
                    ),
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
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: Get.height * 0.01),
              child: SizedBox(
                height: 115,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedIdx = index;
                          });
                        },
                        child: Column(
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
                                // You may need to call setState or another method to refresh the FutureBuilder
                              },
                              child: Container(
                                width: 66.0,
                                height: 66.0,
                                decoration: BoxDecoration(
                                  color: selectedIdx == index
                                      ? Color.fromARGB(120, 214, 243, 253)
                                      : appcolor.colorcheck,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Center(
                                  // Wrap with Center
                                  child: Align(
                                    // Use Align for better positioning control
                                    alignment: Alignment.center,
                                    widthFactor: 0.32,
                                    heightFactor: 0.32,
                                    child: SvgPicture.asset(
                                      items[index].imagePath,
                                      width: 44,
                                      height: 40,
                                      color: selectedIdx == index
                                          ? Color.fromARGB(255, 39, 104, 164)
                                          : Color.fromARGB(255, 103, 152, 189),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              items[index].name,
                              style: TextStyle(fontSize: 11.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductGrid(onCartUpdated: updateCartItemCount),
            ))
          ],
        ),
      ),
    );
  }
}

class ListItem {
  final IconData? icon;
  final String? assetPath;
  final String text;
  final void Function(BuildContext)? onTapCallback;

  ListItem.icon(this.icon, this.text, this.onTapCallback) : assetPath = null;
  ListItem.asset(this.assetPath, this.text, this.onTapCallback) : icon = null;
}

class ProductGrid extends StatefulWidget {
  final Function onCartUpdated;
  ProductGrid({Key? key, required this.onCartUpdated}) : super(key: key);

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  Future<List<Product>> _fetchProducts() async {
    List<Product> products =
        await GetProductApi.getProducts(context, selectedCategory);
    return products;
  }

  Future<void> refreshDocuments() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshDocuments,
      child: FutureBuilder<List<Product>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GridView.builder(
                padding: EdgeInsets.all(1.0),
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.45),
                ),
                itemBuilder: (BuildContext context, int index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 20,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 20,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(Get.height * 0.0),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.45),
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          imageUrl: products[index].imageUrl,
                          description: products[index].description,
                          price: products[index].price,
                          name: products[index].name,
                          productId: products[index].product_id,
                          isFavorite: products[index].isFavorite,
                        ),
                      ),
                    );
                    print({products[index].product_id});
                  },
                  child: heights <= 684 && widths <= 412
                      ? Container(
                          height: 250,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(6.0)),
                                        child: AspectRatio(
                                          aspectRatio:
                                              heights <= 690 && widths <= 430
                                                  ? 0.8
                                                  : 1,
                                          child: Image.network(
                                              products[index].imageUrl,
                                              fit: BoxFit.fitWidth,
                                              errorBuilder:
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
                                      ),
                                      Positioned(
                                        bottom: 130,
                                        right: 10,
                                        child: Container(
                                          height: 36,
                                          width: 36,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  224, 138, 138, 138),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height:
                                              heights <= 690 && widths <= 430
                                                  ? 30
                                                  : 36,
                                          width: heights <= 690 && widths <= 430
                                              ? 30
                                              : 36,
                                          child: IconButton(
                                            icon: SvgPicture.asset(
                                              AssetConstants.cartico,
                                            ),
                                            // color: Colors.white,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
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
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                        child: Container(
                                                          height: 290,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              10.0),
                                                                  child: Center(
                                                                      child:
                                                                          Container(
                                                                    height:
                                                                        Get.height *
                                                                            0.1,
                                                                    width:
                                                                        Get.width *
                                                                            0.2,
                                                                    child: Image
                                                                        .network(
                                                                            '${products[index].imageUrl}'),
                                                                  )),
                                                                ),
                                                                const Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                20)),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Choose Quantity to add in Cart",
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontSize: heights <= 690 && widths <= 430
                                                                            ? 11
                                                                            : 13,
                                                                        fontFamily:
                                                                            "Poppins"),
                                                                  ),
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .remove),
                                                                      onPressed:
                                                                          () {
                                                                        if (_counter >
                                                                            1) {
                                                                          setState(
                                                                              () {
                                                                            _counter--;
                                                                          });
                                                                        }
                                                                        print(
                                                                            _counter);
                                                                      },
                                                                    ),
                                                                    Text(
                                                                        '$_counter',
                                                                        textScaleFactor:
                                                                            1.0),
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .add),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _counter++;
                                                                        });
                                                                        print(
                                                                            _counter);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                // Existing buttons for Yes and No
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              00,
                                                                          bottom:
                                                                              10.0),
                                                                      child: Align(
                                                                          alignment: Alignment.bottomCenter,
                                                                          child: ElevatedButton(
                                                                              child: Text("Add to Cart".toUpperCase(), textScaleFactor: 1.0, style: TextStyle(fontSize: heights <= 690 && widths <= 321 ? 9 : 14)),
                                                                              style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white), backgroundColor: MaterialStateProperty.all<Color>(appcolor.textColor), shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: appcolor.textColor)))),
                                                                              onPressed: () {
                                                                                context.loaderOverlay.show();
                                                                                AddtoCart.AddinCart(products[index].product_id, _counter, context);

                                                                                print('${products[index].product_id}');
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
                                Expanded(
                                  flex: 0,
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: Get.width * 0.02),
                                          child: Text(
                                            truncateProductName(
                                                products[index].name),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.6,
                                                fontFamily: 'Segoe UI',
                                                fontSize: heights <= 690 &&
                                                        widths <= 430
                                                    ? 12.0
                                                    : 16),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Get.width * 0.02),
                                      child: Row(
                                        children: [
                                          Text(
                                            '\$${products[index].price.toStringAsFixed(1)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: heights <= 690 &&
                                                        widths <= 430
                                                    ? 11
                                                    : 14,
                                                fontFamily: 'Segoe UI'),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.005,
                                          ),
                                          Text(
                                            ' \$70',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: heights <= 690 &&
                                                        widths <= 430
                                                    ? 10
                                                    : 11,
                                                color: Colors.grey,
                                                fontFamily: 'Segoe UI'),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.01,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Card(
                          elevation: 0.4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(6.0)),
                                      child: AspectRatio(
                                        aspectRatio: 0.845,
                                        child: Image.network(
                                            products[index].imageUrl,
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
                                    ),
                                    Align(
                                      alignment: Alignment(0.9,
                                          -0.85), // This will keep your icon in top-right
                                      child: Container(
                                        height: 36,
                                        width: 36,
                                        child: IconButton(
                                            icon: products[index].isFavorite ==
                                                    false
                                                ? SvgPicture.asset(
                                                    AssetConstants.favicon)
                                                : Icon(
                                                    Icons.favorite,
                                                    color: appcolor.textColor,
                                                  ),
                                            onPressed: () {
                                              if (products[index].isFavorite ==
                                                  false) {
                                                context.loaderOverlay.show();
                                                AddFavouriteapi.AddFavourite(
                                                        products[index]
                                                            .product_id,
                                                        context)
                                                    .then((value) =>
                                                        {setState(() {})});
                                              } else {
                                                context.loaderOverlay.show();
                                                Removefavorite
                                                        .Removefavoriteapi(
                                                            products[index]
                                                                .product_id,
                                                            context)
                                                    .then((value) {
                                                  setState(() {});
                                                });
                                              }
                                            }),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(0.9, 0.8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              224, 138, 138, 138),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        height: 36,
                                        width: 36,
                                        child: IconButton(
                                          icon: SvgPicture.asset(
                                              AssetConstants.cartico),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  int _counter =
                                                      1; // Initializing the counter for the quantity

                                                  return StatefulBuilder(
                                                      // Using StatefulBuilder to rebuild the widget when state changes
                                                      builder:
                                                          (BuildContext context,
                                                              setState) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      child: Container(
                                                        height: 290,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10.0),
                                                                child: Center(
                                                                    child:
                                                                        Container(
                                                                  height:
                                                                      Get.height *
                                                                          0.1,
                                                                  width:
                                                                      Get.width *
                                                                          0.2,
                                                                  child: Image
                                                                      .network(
                                                                          '${products[index].imageUrl}'),
                                                                )),
                                                              ),
                                                              const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 20)),
                                                              const Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "Choose Quantity to add in Cart",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Poppins"),
                                                                ),
                                                              ),

                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconButton(
                                                                    icon: Icon(Icons
                                                                        .remove),
                                                                    onPressed:
                                                                        () {
                                                                      if (_counter >
                                                                          1) {
                                                                        setState(
                                                                            () {
                                                                          _counter--;
                                                                        });
                                                                      }
                                                                      print(
                                                                          _counter);
                                                                    },
                                                                  ),
                                                                  Text(
                                                                      '$_counter',
                                                                      textScaleFactor:
                                                                          1.0),
                                                                  IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        _counter++;
                                                                      });
                                                                      print(
                                                                          _counter);
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              // Existing buttons for Yes and No
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 00,
                                                                        bottom:
                                                                            10.0),
                                                                    child: Align(
                                                                        alignment: Alignment.bottomCenter,
                                                                        child: ElevatedButton(
                                                                            child: Text("Add to Cart".toUpperCase(), textScaleFactor: 1.0, style: const TextStyle(fontSize: 14)),
                                                                            style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white), backgroundColor: MaterialStateProperty.all<Color>(appcolor.textColor), shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: appcolor.textColor)))),
                                                                            onPressed: () {
                                                                              context.loaderOverlay.show();
                                                                              AddtoCart.AddinCart(products[index].product_id, _counter, context);

                                                                              print('${products[index].product_id}');
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
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: Get.width * 0.02),
                                    child: Text(
                                      truncateProductName(products[index].name),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: Get.width * 0.02),
                                    child: Row(
                                      children: [
                                        Text(
                                          '\$${products[index].price.toStringAsFixed(1)}',
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
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 11,
                                              color: Colors.grey,
                                              fontFamily: 'Segoe UI'),
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.01,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7.0),
                            ],
                          ),
                        ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

showAlertDialog(BuildContext context, title) {
  AlertDialog alert = AlertDialog(
    elevation: 3,
    backgroundColor: Color.fromARGB(255, 173, 173, 173),
    content: Row(
      children: [
        const CircularProgressIndicator(
          backgroundColor: Colors.transparent,
        ),
        Container(
            margin: const EdgeInsets.only(left: 15),
            child: Text(
              title,
              textScaleFactor: 1.0,
              style: TextStyle(
                  fontFamily: "Segoe UI",
                  color: appcolor.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
