// ignore_for_file: sized_box_for_whitespace, unused_label, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors, unnecessary_null_comparison, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/models/orderdetailsbyuid.dart';
import 'package:new_horizon/core/services/apis/user/orderbyuid.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/orderdetailscreen.dart';

class HistoryPendingorders extends StatefulWidget {
  const HistoryPendingorders({super.key});

  @override
  State<HistoryPendingorders> createState() => _HistoryPendingordersState();
}

bool isLoading = true;
String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

var heights = Get.height;
var widths = Get.width;
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

class _HistoryPendingordersState extends State<HistoryPendingorders> {
  final TextEditingController? editTextController = TextEditingController();
  TextEditingController textController = TextEditingController();
  Future<List<Order>>? futureOrders;
  List<Order>? allOrders;
  List<Order>? filteredOrders;
  String? errorMessage;

  void searchOrders() {
    String searchTerm = textController.text;
    if (searchTerm.isEmpty) {
      setState(() {
        filteredOrders = allOrders;
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
          .where((order) => order.orderstatus.toUpperCase() == 'SHIPPED')
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
    resizeToAvoidBottomInset:
    false;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MediaQuery(
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
              actions: <Widget>[],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0),
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
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    ' Shipped Orders ',
                                    style: TextStyle(
                                      color: appcolor.textColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Segoe UI',
                                      fontSize: 14,
                                    ),
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
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: const Text('  Pending Orders',
                                  style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 14,
                                      color: Colors.grey)),
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
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 88, 88, 88),
                      ),
                      width: 220,
                      autoFocus: false,
                      prefixIcon: const Icon(
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (filteredOrders == null) {
                            return const Text("");
                          } else if (filteredOrders!.isEmpty) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AssetConstants.nopendicon),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18),
                                    child: Text(
                                      'No Shipped Orders',
                                      style: TextStyle(
                                          fontFamily: 'Humanist Sans',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: filteredOrders!.length,
                              itemBuilder: (context, index) {
                                print(
                                    "Building card for order: ${filteredOrders![index].orderId}");
                                return OrderCard(order: filteredOrders![index]);
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
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;

  OrderCard({
    super.key,
    required this.order,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  Color? getStatusColor(String status, {bool forText = false}) {
    switch (status.toLowerCase()) {
      case 'pending':
        return forText ? Colors.red : Colors.red[100];
      case 'completed':
        return forText ? Colors.lightBlue : Colors.lightBlue[100];
      case 'cancelled':
        return forText ? Colors.grey : Colors.grey[300];
      case 'shipped':
        return forText
            ? Color.fromRGBO(3, 111, 173, 1)
            : Color.fromRGBO(111, 187, 245, 0.4);

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 12.0, right: 12.0, top: 0, bottom: 10),
      child: GestureDetector(
        onTap: () {
          print(widget.order.orderstatus);
          print(widget.order.city);
          print(widget.order.billing_address);
          print(widget.order.orderEmail);
          print(widget.order.orderId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: widget.order),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2.4,
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
                              color: getStatusColor(widget.order.orderstatus),
                              borderRadius: BorderRadius.circular(3)),
                          child: Center(
                            child: Text(
                              widget.order.orderstatus,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 8 : 10,
                                color: getStatusColor(widget.order.orderstatus,
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
                        'Order  #' + widget.order.orderId,
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
                            child: Image.network(widget.order.image,
                                width:
                                    heights <= 690 && widths <= 430 ? 60 : 85,
                                height:
                                    heights <= 690 && widths <= 430 ? 60 : 85,
                                fit: BoxFit.cover, errorBuilder:
                                    (BuildContext context, Object exception,
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
                                Text(capitalizeFirstLetter(widget.order.name),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Segoe UI',
                                      fontSize: heights <= 690 && widths <= 430
                                          ? 11
                                          : 15,
                                    )),
                                SizedBox(height: Get.height * 0.005),
                                Text(
                                  widget.order.firstName +
                                      ' ' +
                                      widget.order.lastName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Segoe UI',
                                      fontSize: heights <= 690 && widths <= 430
                                          ? 11
                                          : 14,
                                      color:
                                          Color.fromARGB(255, 103, 103, 103)),
                                ),
                                SizedBox(height: Get.height * 0.005),
                                Text(
                                  "Order is confirmed and\nready to be shipped",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Segoe UI',
                                      // fontSize: 13,
                                      fontSize: heights <= 690 && widths <= 430
                                          ? 11
                                          : 13,
                                      color:
                                          Color.fromARGB(255, 164, 164, 164)),
                                ),
                              ],
                            ),
                          ),
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
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.order.country,
                          style: TextStyle(
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 11 : 13,
                              color: Color.fromRGBO(123, 123, 123, 1),
                              fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.order.orderEmail,
                          style: TextStyle(
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 11 : 13,
                              color: Color.fromRGBO(123, 123, 123, 1),
                              fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                formatDate(widget.order.orderDate),
                                style: TextStyle(
                                    color: Color.fromRGBO(123, 123, 123, 1),
                                    fontFamily: 'Segoe UI',
                                    fontSize: heights <= 690 && widths <= 430
                                        ? 11
                                        : 13,
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
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '6AM - 12PM',
                                style: TextStyle(
                                    color: Color.fromRGBO(123, 123, 123, 1),
                                    fontFamily: 'Segoe UI',
                                    fontSize: heights <= 690 && widths <= 430
                                        ? 11
                                        : 13,
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
        ),
      ),
    );
  }
}
