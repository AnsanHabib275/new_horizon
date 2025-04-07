// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member, unnecessary_new, unused_field, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_print, must_call_super, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, prefer_adjacent_string_concatenation, deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/orderdetailsbyuid.dart';
import 'package:new_horizon/core/services/apis/user/orderbyuid.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/orderdetailscreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/orderscompleted.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/ordersdenied.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/orderspending.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/ordersshipped.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ticket_widget/ticket_widget.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

var heights = Get.height;
var widths = Get.width;

class _OrdersState extends State<Orders> {
  Future<void> refreshorders() async {
    setState(() {});
  }

  TextEditingController textController = TextEditingController();

  List<Order>? OrdersList;
  List<Order>? filteredordersList;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> refreshOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      var fetchedPatients = await GetOrderByUid.OrderIdByUid();
      setState(() {
        OrdersList = fetchedPatients;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            'Hang Tight! We are trying to resolve the issue at our end.';
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredordersList = OrdersList;
    } else {
      filteredordersList = OrdersList?.where((orders) {
        String username = orders.firstName + ' ' + orders.lastName;
        return username.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {});
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
              'Orders',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[],
          ),
          body: Column(children: [
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
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.blue, width: 2.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              ' All Orders ',
                              style: TextStyle(
                                color: appcolor.textColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 10 : 14,
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Orderspending(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            ' Pending ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 10 : 14,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 7,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Ordersshipped(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            ' Shipped ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 10 : 14,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 7,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Orderscompleted(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            ' Completed ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 10 : 14,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 7,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersDenied(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            ' Denied ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 10 : 14,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            SearchBarAnimation(
              textEditingController: textController,
              isOriginalAnimation: false,
              searchBoxWidth: Get.width - 17,
              isSearchBoxOnRightSide: true,
              searchBoxBorderColour: Colors.transparent,
              buttonBorderColour: Colors.transparent,
              enableButtonShadow: false,
              onChanged: (val) {
                filterSearchResults(val);
              },
              enableKeyboardFocus: true,
              onExpansionComplete: () {},
              onCollapseComplete: () {
                textController.clear();
                filterSearchResults('');
              },
              onPressButton: (isSearchBarOpens) {
                debugPrint(
                    'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
              },
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshOrders,
                child: buildOrdersList(),
              ),
            )
          ])),
    );
  }

  Widget buildOrdersList() {
    var currentList = isLoading ? [] : filteredordersList ?? OrdersList;

    if (errorMessage != null) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AssetConstants.nofavicon),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                errorMessage!,
                style: const TextStyle(
                    fontFamily: 'Humanist Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ));
    }

    if (isLoading) {
      return buildLoadingList();
    }

    if (currentList == null || currentList.isEmpty) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AssetConstants.nopendicon),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'No Orders Found',
                      style: TextStyle(
                          fontFamily: 'Humanist Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )));
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        return MyCard(order: currentList[index]);
      },
    );
  }

  Widget buildLoadingList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 9.0, right: 9.0, top: 0, bottom: 7),
          child: Card(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: <Widget>[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey[300],
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 140,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.008),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 140,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
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
                            borderRadius: BorderRadius.circular(19),
                          ),
                          height: 15,
                          width: 55,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            height: 22,
                            width: 60,
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
  }
}

class MyCard extends StatefulWidget {
  final Order order;

  const MyCard({Key? key, required this.order}) : super(key: key);

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
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

  String truncateProductName(String name) {
    if (name.length > 21) {
      return name.substring(0, 21) + '..';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: widget.order),
            ),
          );
        },
        child: Card(
          elevation: 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.order.image,
                    height: 85,
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
                              fontFamily: 'Humanist Sans', fontSize: 12),
                        )),
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
                      Text(
                        capitalizeFirstLetter(widget.order.firstName +
                            " " +
                            widget.order.lastName),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Segoe UI',
                            fontSize: 15),
                      ),
                      SizedBox(height: Get.height * 0.005),
                      Text(
                        truncateProductName(widget.order.name),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Segoe UI',
                            fontSize: 14,
                            color: Color.fromARGB(255, 103, 103, 103)),
                      ),
                      SizedBox(height: Get.height * 0.005),
                      Text(
                        "Price = \$" + widget.order.totalprice.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
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
                      child: Text(
                        formatDate(
                          widget.order.orderDate,
                        ),
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: Color.fromARGB(255, 101, 101, 101)),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 18),
                    child: Container(
                      height: 21,
                      width: 65,
                      // color: getStatusColor(widget.order.orderstatus),

                      decoration: BoxDecoration(
                          color: getStatusColor(widget.order.orderstatus),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Text(
                          capitalizeFirstLetter(
                            widget.order.orderstatus,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Segoe UI',
                            fontSize: 10,
                            color: getStatusColor(widget.order.orderstatus,
                                forText: true),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showTicketPopup(BuildContext context, Order order) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
          padding: EdgeInsets.only(left: 50, right: 50, top: 130, bottom: 130),
          child: TicketWidget(
            width: 100,
            height: 100,
            isCornerRounded: true,
            padding: EdgeInsets.all(20),
            child: TicketData(order: order),
          ));
    },
  );
}

class TicketData extends StatelessWidget {
  final Order order;

  const TicketData({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subtotal = order.price;

    // s discount = subtotal * (2 / 100);
    // double total = subtotal - discount;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(width: 1.0, color: appcolor.textColor),
                  ),
                  child: const Center(
                    child: Text(
                      'Order Id',
                      style: TextStyle(color: appcolor.textColor),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      order.orderId,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI'),
                    ),
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Order Details',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ITEMS',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'PRICE',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  ...List.generate(order.products.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text('${index + 1}'),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                capitalizeFirstLetter(
                                  order.products[index].name,
                                ),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            '\$' + order.products[index].price.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: heights <= 684 && widths <= 412 ? 85 : 130, // Use MediaQuery
          left: 0,
          right: 0,
          child: Divider(
            color: Color.fromARGB(255, 208, 208, 208),
            height: 1,
            thickness: 1,
          ),
        ),
        Positioned(
          bottom: heights <= 684 && widths <= 412
              ? 0
              : MediaQuery.of(context).size.height * 0.04,
          left: 0,
          right: 0,
          child: Column(
            children: [
              SizedBox(
                height: heights <= 684 && widths <= 412 ? 0 : 10,
              ),
              ticketDetailsRow('Subtotal', '\$' + subtotal),
              // SizedBox(
              //   height: heights <= 684 && widths <= 412 ? 5 : 10,
              // ),
              // ticketDetailsRow('Discount ' + '-10' + '%',
              //     '-\$' + discount.toStringAsFixed(1)),
              SizedBox(
                height: heights <= 684 && widths <= 412 ? 8 : 10,
              ),
              Divider(
                color: Color.fromARGB(255, 208, 208, 208),
                height: 1,
                thickness: 1,
              ),
              SizedBox(height: 10),
              ticketDetailsRow('Total', '\$' + subtotal),
            ],
          ),
        ),
      ],
    );
  }
}

Widget ticketDetailsRow(String title, String desc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          desc,
          style: const TextStyle(color: Colors.black),
        ),
      )
    ],
  );
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
