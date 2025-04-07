// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, unused_label, prefer_const_constructors_in_immutables, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, use_build_context_synchronously, deprecated_member_use

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/models/orderdetailsbyuid.dart';
import 'package:new_horizon/core/services/apis/user/cancelorderapi.dart';
import 'package:new_horizon/core/services/apis/user/orderbyuid.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/invoicespaid.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

bool isLoading = true;
String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String formatDate(String rawDate) {
  List<String> parts = rawDate.split('T');
  String datePart = parts[0];

  List<String> timeParts = parts[1].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  String amPm = hour >= 12 ? 'PM' : 'AM';

  if (hour > 12) {
    hour -= 12;
  } else if (hour == 0) {
    hour = 12;
  }

  return '$datePart  $hour:${minute.toString().padLeft(2, '0')} $amPm';
}

class _HistoryState extends State<History> {
  TextEditingController textController = TextEditingController();
  Future<List<Order>>? futureOrders;
  List<Order>? allOrders;
  List<Order>? filteredOrders;
  String? errorMessage;

  void searchOrders() {
    String searchTerm = textController.text;
    if (searchTerm.isEmpty) {
      setState(() {
        filteredOrders = allOrders; // If search is empty, show all orders
      });
    } else {
      setState(() {
        filteredOrders = allOrders!
            .where((order) => order.orderId.contains(searchTerm))
            .toList();
      });
    }
  }

  loadallOrders() async {
    context.loaderOverlay.show();
    try {
      var orders = await GetOrderByUid.OrderIdByUid();
      var pendingOrders = orders
          .where((order) => order.orderstatus.toUpperCase() == 'PENDING')
          .toList();

      setState(() {
        allOrders = pendingOrders;
        filteredOrders = pendingOrders;
      });
    } catch (e) {
      print("Error fetching orders: " + e.toString());
    } finally {
      context.loaderOverlay.hide();
    }
  }

  void cancelOrder(Order order) async {
    // Call your API to cancel the order
    await CancelOrder.CancelOrderapi(order.orderId, context);

    // Update the state to remove the order
    setState(() {
      allOrders?.remove(order);
      filteredOrders?.remove(order);
    });
  }

  @override
  void initState() {
    super.initState();
    loadallOrders();
    textController.addListener(searchOrders);
  }

  @override
  void dispose() {
    textController.removeListener(searchOrders);
    super.dispose();
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
            title: Text(
              'History',
              style: TextStyle(color: Colors.black),
            ),
            actions: const <Widget>[],
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  child: SizedBox(
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              AppNavigatorService.navigateToReplacement(
                                  Route_paths.historypending);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                ' Shipped Orders ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Segoe UI',
                                  fontSize: 14,
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppNavigatorService.navigateToReplacement(
                                Route_paths.history);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: const Text(' Pending Orders ',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: appcolor.textColor,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppNavigatorService.navigateToReplacement(
                                Route_paths.historycompleted);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: const Text('  Completed Orders',
                                style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 14,
                                    color: Colors.grey)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 0),
                  child: AnimSearchBar(
                    onSubmitted: (p0) {},
                    searchIconColor: Colors.grey,
                    rtl: true,
                    suffixIcon: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 88, 88, 88),
                    ),
                    width: 390,
                    autoFocus: false,
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Color.fromARGB(255, 88, 88, 88),
                    ),
                    textController: textController,
                    onSuffixTap: () {
                      setState(() {
                        textController.clear();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Order>>(
                    future: futureOrders,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (filteredOrders == null) {
                          return const Text("");
                        } else if (filteredOrders!.isEmpty) {
                          return const Text(
                            "No record found",
                            style: TextStyle(color: Colors.grey),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: filteredOrders!.length,
                            itemBuilder: (context, index) {
                              print(
                                  "Building card for order: ${filteredOrders![index].orderId}");
                              return OrderCard(
                                order: filteredOrders![index],
                                onCancel: () =>
                                    cancelOrder(filteredOrders![index]),
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}

String truncateProductName(String name) {
  if (name.length > 20) {
    return name.substring(0, 20) + '...';
  }
  return name;
}

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onCancel;

  OrderCard({
    Key? key,
    required this.order,
    required this.onCancel,
  }) : super(key: key);
  Color? getStatusColor(String status, {bool forText = false}) {
    switch (status.toLowerCase()) {
      case 'pending':
        return forText ? Colors.red : Colors.red[100];
      case 'completed':
        return forText ? Colors.lightBlue : Colors.lightBlue[100];
      case 'cancelled':
        return forText ? Colors.grey : Colors.grey[300];
      case 'shipped':
        return forText ? Color.fromARGB(255, 138, 138, 139) : Colors.blue[100];
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 12.0, right: 12.0, top: 0, bottom: 10),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(' '),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 4),
                    child: Container(
                      height: 20,
                      width: 55,
                      decoration: BoxDecoration(
                          color: getStatusColor(order.orderstatus),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Text(
                          order.orderstatus,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Segoe UI',
                            fontSize: 11,
                            color: getStatusColor(order.orderstatus,
                                forText: true),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    'Order  #' + order.orderId,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Segoe UI',
                      fontWeight: FontWeight.w600,
                      fontSize: heights <= 690 && widths <= 430 ? 13 : 16,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8.0),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(order.image,
                            width: 85, height: 85, fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                          return Container(
                            color: Color.fromARGB(255, 240, 250, 255),
                            width: 85,
                            height: 90,
                            child: Center(
                                child: Text(
                              'Not Found',
                              style: TextStyle(
                                  fontFamily: 'Humanist Sans', fontSize: 12),
                            )),
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              truncateProductName(order.name),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Segoe UI',
                                  fontSize: 14),
                            ),
                            SizedBox(height: Get.height * 0.005),
                            Text(
                              order.firstName + ' ' + order.lastName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Segoe UI',
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 103, 103, 103)),
                            ),
                            SizedBox(height: Get.height * 0.005),
                            Text(
                              "Order is confirmed and\nready to be shipped",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Segoe UI',
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 164, 164, 164)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0, top: 14),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 209, 209, 209),
                                  padding: EdgeInsets.zero),
                              onPressed: () {
                                context.loaderOverlay.show();
                                print(order.orderId);
                                // CancelOrder.CancelOrderapi(
                                //     order.orderId, context);
                                onCancel();
                              },
                              child: Text(
                                '   Cancel Order   ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Segoe UI',
                                    fontSize: 11),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    color: Colors.green,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      order.country,
                      style: TextStyle(
                          fontSize: heights <= 690 && widths <= 430 ? 11 : 13,
                          color: Color.fromRGBO(123, 123, 123, 1),
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    color: Colors.red,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      order.orderEmail,
                      style: TextStyle(
                          fontSize: heights <= 690 && widths <= 430 ? 11 : 13,
                          color: Color.fromRGBO(123, 123, 123, 1),
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      child: Image.asset(AssetConstants.timehistory),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        formatDate(order.orderDate),
                        style: TextStyle(
                            fontSize: heights <= 690 && widths <= 430 ? 11 : 13,
                            color: Color.fromRGBO(123, 123, 123, 1),
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      child: Image.asset(AssetConstants.container),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        '6AM - 12PM',
                        style: TextStyle(
                            fontSize: heights <= 690 && widths <= 430 ? 11 : 13,
                            color: Color.fromRGBO(123, 123, 123, 1),
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
