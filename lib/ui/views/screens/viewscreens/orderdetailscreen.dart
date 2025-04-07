// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/models/orderdetailsbyuid.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:ticket_widget/ticket_widget.dart';

// This screen displays the details of an order.
class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

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
              'Order Details',
              style: TextStyle(color: Colors.black),
            ),
            actions: const <Widget>[],
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Column(children: [
                SizedBox(height: 20),
                Container(
                  child: Card(
                    color: Color.fromARGB(203, 255, 255, 255),
                    elevation: 2.0,
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: infoColumn(
                                'Order Info',
                                formatDate(order.orderDate),
                                truncateorderinfo(
                                  order.country,
                                ),
                                truncateorderinfo(
                                    capitalizeFirstLetter(order.city) +
                                        ' ' +
                                        '')),
                          ),
                          Container(
                            height: 80,
                            child: VerticalDivider(color: Colors.black),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: infoColumn2(
                                'Order Info',
                                truncateorderinfo(
                                  order.trackingno,
                                ),
                                truncateorderinfo(capitalizeFirstLetter(
                                  order.providerr,
                                )),
                                capitalizeFirstLetter(order.dateofservice) +
                                    ''),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              Center(child: ClientCard(order: order)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TicketWidget(
                  color: Color.fromARGB(215, 235, 235, 235),
                  width: 410,
                  height: 450,
                  isCornerRounded: true,
                  padding: EdgeInsets.all(20),
                  child: TicketData(order: order),
                ),
              ),
            ]),
          )),
    );
  }
}

class ClientCard extends StatelessWidget {
  final Order order;
  const ClientCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        elevation: 3.0,
        child: Center(
          child: Container(
            color: Color.fromARGB(198, 239, 239, 239),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12.0, top: 10),
                        child: Text(
                          'Buyer Details',
                          style: TextStyle(
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 14 : 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Segoe UI'),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      size: heights <= 690 && widths <= 430 ? 38 : 40,
                    ),
                    title: Text(
                      capitalizeFirstLetter(
                        order.firstName + ' ' + order.lastName,
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: heights <= 690 && widths <= 430 ? 12 : 14,
                          fontFamily: 'Segoe UI'),
                    ),
                    subtitle: Text(
                      order.practice,
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: heights <= 690 && widths <= 430 ? 11 : 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget infoColumn(String title, String number, String studio, String email) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: TextStyle(
              fontSize: heights <= 690 && widths <= 430 ? 14 : 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Segoe UI')),
      SizedBox(height: 12),
      Row(
        children: [
          Text(
            'Order Date: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                color: Colors.grey,
                fontFamily: 'Segoe UI'),
          ),
          Text(capitalizeFirstLetter(number),
              style: TextStyle(
                  fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                  color: Color.fromARGB(255, 25, 25, 25),
                  fontFamily: 'Segoe UI')),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Aligns children at the start of the cross axis
        children: [
          Text(
            'State: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                color: Colors.grey,
                fontFamily: 'Segoe UI'),
          ),
          Flexible(
            child: Text(
              capitalizeFirstLetter(studio),
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                  fontFamily: 'Segoe UI'),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'City: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                color: Colors.grey),
          ),
          Text(email,
              style: TextStyle(
                  fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                  color: Colors.black,
                  fontFamily: 'Segoe UI')),
        ],
      ),
    ],
  );
}

Widget infoColumn2(
    String title, String number, String provider, String dateofservice) {
  String formatDate(String rawDate) {
    return rawDate.split('T')[0];
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: TextStyle(
              fontSize: heights <= 690 && widths <= 430 ? 14 : 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Segoe UI')),
      SizedBox(height: 12),
      Row(
        children: [
          Text(
            'Tracking No: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                color: Colors.grey,
                fontFamily: 'Segoe UI'),
          ),
          Text(capitalizeFirstLetter(number),
              style: TextStyle(
                  fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                  color: Color.fromARGB(255, 25, 25, 25),
                  fontFamily: 'Segoe UI')),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Aligns children at the start of the cross axis
        children: [
          Text(
            'Provider: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                color: Colors.grey,
                fontFamily: 'Segoe UI'),
          ),
          Flexible(
            child: Text(
              provider,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                  fontFamily: 'Segoe UI'),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'Date of Service: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 11.4,
                color: Colors.grey,
                fontFamily: 'Segoe UI'),
          ),
          Flexible(
            child: Text(
              formatDate(dateofservice),
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: heights <= 690 && widths <= 430 ? 9 : 11.3,
                  fontFamily: 'Segoe UI'),
            ),
          ),
        ],
      ),
    ],
  );
}

var heights = Get.height;
var widths = Get.width;
String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

String truncateProductName(String name) {
  if (name.length > 31) {
    return name.substring(0, 31) + '..';
  }
  return name;
}

String truncateorderinfo(String name) {
  if (name.length > 20) {
    return name.substring(0, 20) + '..';
  }
  return name;
}

class TicketData extends StatelessWidget {
  final Order order;

  const TicketData({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int subtotal = order.totalprice;

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
                  child: Center(
                    child: Text(
                      'Order Id',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: appcolor.textColor,
                        fontFamily: 'Segoe UI',
                        fontSize: heights <= 690 && widths <= 430 ? 12 : 14,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '# ' + order.orderId,
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: heights <= 690 && widths <= 430 ? 10 : 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI'),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Order Details',
                textScaleFactor: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: heights <= 690 && widths <= 430 ? 14 : 19,
                    fontFamily: 'Segoe UI',
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
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Segoe UI',
                          fontSize: heights <= 690 && widths <= 430 ? 10 : 13,
                        ),
                      ),
                      Text(
                        'PRICE',
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Segoe UI',
                            fontSize:
                                heights <= 690 && widths <= 430 ? 10 : 13),
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
                                width:
                                    heights <= 690 && widths <= 430 ? 22 : 28.0,
                                height:
                                    heights <= 690 && widths <= 430 ? 22 : 28.0,
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
                                  truncateProductName(
                                    order.products[index].name +
                                        ' x ' +
                                        order.products[index].quantity
                                            .toString(),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Segoe UI',
                                    fontSize: heights <= 690 && widths <= 430
                                        ? 10
                                        : 12),
                              ),
                            ],
                          ),
                          Text(
                            '\$' + order.products[index].price.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 10 : 12),
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
          bottom: heights <= 684 && widths <= 412 ? 60 : 105, // Use MediaQuery
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
              ticketDetailsRow('Subtotal', '\$' + subtotal.toStringAsFixed(1)),
              SizedBox(
                height: heights <= 684 && widths <= 412 ? 8 : 10,
              ),
              Divider(
                color: Color.fromARGB(255, 208, 208, 208),
                height: 1,
                thickness: 1,
              ),
              SizedBox(height: 10),
              ticketDetailsRow('Total', '\$' + subtotal.toStringAsFixed(1)),
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
          textScaleFactor: 1,
          title,
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Segoe UI',
            fontSize: heights <= 690 && widths <= 430 ? 12 : 14.0,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          textScaleFactor: 1,
          desc,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Segoe UI',
            fontSize: heights <= 690 && widths <= 430 ? 12 : 14.0,
          ),
        ),
      )
    ],
  );
}
