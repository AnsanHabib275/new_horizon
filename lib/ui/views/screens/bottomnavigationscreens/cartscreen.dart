// ignore_for_file: unused_import, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, use_build_context_synchronously, unused_catch_clause, deprecated_member_use, nullable_type_in_catch_clause
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/models/cartproduct.dart';
import 'package:new_horizon/core/models/verifiedpatients.dart';
import 'package:new_horizon/core/services/apis/user/getcompletecart.dart';
import 'package:new_horizon/core/services/apis/user/getverifiedpatients.dart';
import 'package:new_horizon/core/services/apis/user/productapi.dart';
import 'package:new_horizon/core/services/apis/user/removecart.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_horizon/ui/views/HomeScreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/cartcontroller.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/countercartcontroller.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/personalinformation.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

var heights = Get.height;
var widths = Get.width;
final CounterController controller = Get.put(CounterController());
final CartController controller1 = Get.put(CartController());

class _CartScreenState extends State<CartScreen> {
  List<VerifiedPatient> verifiedPatients = [];

  @override
  void initState() {
    super.initState();
    controller1.loadCartProducts();
    patient();
  }

  patient() async {
    verifiedPatients = await GetVerifiedPatients.getVerifiedPatients(context);
  }

  // patient2ndcheck() async {
  //   context.loaderOverlay.show();
  //   verifiedPatients = await GetVerifiedPatients.getVerifiedPatients(context);

  //   // Check if the verifiedPatients list is empty
  //   if (verifiedPatients.isEmpty) {
  //     context.loaderOverlay.hide();
  //     MotionToast(
  //       primaryColor: const Color.fromARGB(255, 252, 94, 83),
  //       icon: Icons.zoom_out,
  //       title: const Text("No Verified Patients."),
  //       description: const Text("Verify to Procced for Checkout"),
  //       position: MotionToastPosition.top,
  //       animationType: AnimationType.slideInFromLeft,
  //     ).show(context);
  //   } else {
  //     context.loaderOverlay.hide();
  //   }
  // }

  patient2ndcheck() async {
    context.loaderOverlay.show();
    try {
      verifiedPatients = await GetVerifiedPatients.getVerifiedPatients(context);
      if (verifiedPatients.isNotEmpty) {
        var price = controller1.totaprice.value;
        print('checkthis $price');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => PersonalInformation(
                  totalprice: price,
                  verifiedPatients: verifiedPatients,
                ),
          ),
        );
      }
    } on VerifiedPatientException catch (e) {
      if (verifiedPatients.isEmpty) {
        MotionToast(
          primaryColor: Color.fromARGB(255, 248, 77, 65),
          icon: Icons.zoom_out,
          title: const Text("No Verified Patients."),
          description: const Text("Verify to Proceed for Checkout"),
          position: MotionToastPosition.top,
          animationType: AnimationType.slideInFromLeft,
        ).show(context);
      }
    } catch (e) {
      // Handle any other exceptions
      MotionToast(
        primaryColor: Color.fromARGB(255, 248, 77, 65),
        icon: Icons.zoom_out,
        title: const Text("No Verified Patients."),
        description: const Text("Verify to Proceed for Checkout"),
        position: MotionToastPosition.top,
        animationType: AnimationType.slideInFromLeft,
      ).show(context);
    } finally {
      context.loaderOverlay.hide();
    }
  }

  Future<void> refresh() async {
    try {
      setState(() {
        context.loaderOverlay.show();
        controller1.loadCartProducts();
        patient();
      });
    } catch (e) {
      print(e);
    } finally {
      context.loaderOverlay.hide();

      setState(() {});

      try {} catch (e) {
        print('Error fetching verified patients: $e');
      }
    }
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return WillPopScope(
      onWillPop: () async {
        if (index != 0) {
          setState(() {
            index = 0;
          });
          return false;
        }
        return true;
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                        onPressed: () {},
                        icon: const Icon(
                          // Icons.shopping_cart_rounded,
                          Icons.shopping_cart_outlined,
                          color: Color.fromRGBO(65, 65, 65, 1),
                          size: 28,
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
                          // color: Color.fromARGB(255, 243, 103, 103),
                          color: appcolor.textColor,
                        ),
                        child: Center(
                          child: Obx(() {
                            controller
                                .trigger
                                .value; // This forces a rebuild whenever trigger changes
                            return Text(
                              controller.itemsadded.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '  Cart  ',
                            style: TextStyle(
                              color: appcolor.textColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '  Personal Information ',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '  Shipping',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refresh, //controller1.loadCartProducts,
                    child: Obx(
                      () =>
                          controller1.isLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : (controller1.products.isEmpty
                                  ? buildNocartView()
                                  : ListView.builder(
                                    itemCount: controller1.products.length,
                                    itemBuilder: (context, index) {
                                      return MyCard(
                                        product: controller1.products[index],
                                        onRemove: (product) {
                                          controller1.removeProduct(product);
                                        },
                                        onUpdateTotal: (difference) {
                                          controller1.totaprice.value +=
                                              difference;
                                        },
                                      );
                                    },
                                  )),
                    ),
                  ),
                ),
                Obx(() {
                  if (!controller1.isLoading.value &&
                      controller1.products.isNotEmpty) {
                    // Replace with your actual UI

                    return Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: Get.width * 0.05,
                              right: Get.width * 0.05,
                              bottom: Get.height * 0.02,
                            ),
                            child: Column(
                              children: [
                                Divider(color: Colors.grey),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 12, 12, 12),
                                        fontFamily: 'Segoe UI',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Obx(() {
                                      controller1
                                          .trigger
                                          .value; // This forces a rebuild whenever trigger changes
                                      return Text(
                                        '\$ ${controller1.totaprice}',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            128,
                                            128,
                                            128,
                                          ),
                                          fontFamily: 'Segoe UI',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Tax',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 12, 12, 12),
                                        fontFamily: 'Segoe UI',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      '0',
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          128,
                                          128,
                                          128,
                                        ),
                                        fontFamily: 'Segoe UI',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Shipping',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 12, 12, 12),
                                        fontFamily: 'Segoe UI',
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'Free',
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          128,
                                          128,
                                          128,
                                        ),
                                        fontFamily: 'Segoe UI',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.010),
                                Divider(color: Colors.grey),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Obx(() {
                                          controller.trigger.value;
                                          return Text(
                                            'Items ${controller.itemsadded}',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                255,
                                                128,
                                                128,
                                                128,
                                              ),
                                              fontFamily: 'Segoe UI',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          );
                                        }),
                                        Obx(() {
                                          controller1.trigger.value;
                                          return Text(
                                            '\$ ${controller1.totaprice}',
                                            style: TextStyle(
                                              color: appcolor.textColor,
                                              fontFamily: 'Segoe UI',
                                              fontSize:
                                                  heights <= 690 &&
                                                          widths <= 430
                                                      ? 14
                                                      : 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Container(
                                        height: Get.height * 0.04,
                                        width: Get.width * 0.28,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              appcolor.textColor,
                                              Color.fromARGB(
                                                255,
                                                164,
                                                199,
                                                255,
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (verifiedPatients.isEmpty) {
                                              patient2ndcheck();
                                              return;
                                            }

                                            var price =
                                                controller1.totaprice.value;
                                            print('checkthis $price');
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        PersonalInformation(
                                                          totalprice: price,
                                                          verifiedPatients:
                                                              verifiedPatients,
                                                        ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                          ),
                                          child: Text(
                                            'Check out',
                                            style: TextStyle(
                                              fontFamily: 'Humanist Sans',
                                              fontSize:
                                                  heights <= 690 &&
                                                          widths <= 430
                                                      ? 9.5
                                                      : 12.7,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 45),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink(); // Or some placeholder
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildNocartView() {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 1,
      mainAxisSpacing: 14.0,
      childAspectRatio: (15 / 20),
    ),
    itemCount: 1,
    itemBuilder: (context, index) {
      return Center(
        child: Text(
          "Your Cart Is Empty!",
          style: TextStyle(
            fontSize: 18,
            color: appcolor.textColor,
            fontFamily: 'Segoe UI',
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    },
  );
}

class MyCard extends StatefulWidget {
  final CartProduct product;
  final void Function(CartProduct) onRemove;
  final Function(double) onUpdateTotal;

  const MyCard({
    Key? key,
    required this.product,
    required this.onRemove,
    required this.onUpdateTotal,
  }) : super(key: key);

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  double totalprice = 0.0;
  String truncateProductName(String name) {
    if (name.length > 25) {
      return '${name.substring(0, 25)}..';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.product.imageUrl,
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (
                    BuildContext context,
                    Object exception,
                    StackTrace? stackTrace,
                  ) {
                    return Container(
                      color: Color.fromARGB(255, 240, 250, 255),
                      width: 85,
                      height: 90,
                      child: Center(
                        child: Text(
                          'Not Found',
                          style: TextStyle(
                            fontFamily: 'Humanist Sans',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        truncateProductName(widget.product.name),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Humanist sans',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.005),
                    Text(
                      "\$${widget.product.price.toString()} x ${widget.product.quantity} = \$${(widget.product.price * widget.product.quantity).toStringAsFixed(1)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Humanist sans',
                        fontSize: 12,
                        color: Color.fromARGB(255, 164, 164, 164),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close_sharp,
                      color: Colors.grey,
                      size: 15,
                    ),
                    onPressed: () async {
                      context.loaderOverlay.show();
                      await RemovefromCart.removeCart(
                        widget.product.product_Id.toString(),
                        widget.product.quantity,
                        context,
                      );
                      controller1.removeProduct(widget.product);
                      widget.onRemove(widget.product);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
