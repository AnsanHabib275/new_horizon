// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/models/invoicemodel.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:ticket_widget/ticket_widget.dart';

class InvoiceDetailScreen extends StatelessWidget {
  String truncateinvoiceinfo(String name) {
    if (name.length > 21) {
      return name.substring(0, 21) + '...';
    }
    return name;
  }

  final InvoiceModel invoice;
  const InvoiceDetailScreen({super.key, required this.invoice});

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
              'Invoice Details',
              style: TextStyle(color: Colors.black),
            ),
            actions: const <Widget>[],
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Column(children: [
                SizedBox(height: 20),
                Card(
                  color: Color.fromARGB(203, 255, 255, 255),
                  elevation: 2.0,
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: infoColumn(
                              'Billing Info',
                              truncateProductName2(
                                invoice.billingAddress,
                              ),
                              formatDate(invoice.invoiceDate),
                              truncateProductName2(
                                  capitalizeFirstLetter(invoice.billingCity))),
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
                              'Invoice Info',
                              truncateProductName2(
                                invoice.providerr,
                              ),
                              invoice.dateofservice,
                              capitalizeFirstLetter(
                                  invoice.invoiceStatus.toLowerCase())),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Center(child: ClientCard(invoicemodel: invoice)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TicketWidget(
                  color: Color.fromARGB(215, 235, 235, 235),
                  width: 410,
                  height: 450,
                  isCornerRounded: true,
                  padding: EdgeInsets.all(20),
                  child: TicketData(invoiceModel: invoice),
                ),
              ),
            ]),
          )),
    );
  }
}

class ClientCard extends StatelessWidget {
  final InvoiceModel invoicemodel;
  const ClientCard({Key? key, required this.invoicemodel}) : super(key: key);

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
                        padding:
                            EdgeInsets.only(left: 12.0, bottom: 4, top: 10),
                        child: Text(
                          'Invoice Patient Details',
                          style: TextStyle(
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 14 : 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      size: heights <= 690 && widths <= 430 ? 38 : 45,
                    ), //Image.network(order.image),
                    title: Text(
                      capitalizeFirstLetter(invoicemodel.invoicename),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: heights <= 690 && widths <= 430 ? 13 : 15,
                      ),
                    ),
                    subtitle: Text(
                      invoicemodel.practice,
                      style: TextStyle(
                          fontSize: heights <= 690 && widths <= 430 ? 12 : 14),
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
              fontWeight: FontWeight.bold)),
      SizedBox(height: 12),
      Row(
        children: [
          Text(
            'Address: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 11.5,
                color: Colors.grey),
          ),
          Flexible(
            child: Text(
              capitalizeFirstLetter(number),
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: heights <= 690 && widths <= 430 ? 8.5 : 11.5,
                  color: Color.fromARGB(255, 25, 25, 25)),
            ),
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Aligns children at the start of the cross axis
        children: [
          Text(
            'Invoice Date: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 11.4,
                color: Colors.grey),
          ),
          Flexible(
            child: Text(
              capitalizeFirstLetter(studio),
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 11.4,
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'Billing City: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                color: Colors.grey),
          ),
          // Text(email),
          Flexible(
            child: Text(
              capitalizeFirstLetter(email),
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget infoColumn2(
    String title, String providerr, String date_of_service, String email) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: TextStyle(
              fontSize: heights <= 690 && widths <= 430 ? 14 : 17,
              fontWeight: FontWeight.bold)),
      SizedBox(height: 12),
      Row(
        children: [
          Text(
            'Provider: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                color: Colors.grey),
          ),
          Text(capitalizeFirstLetter(providerr),
              style: TextStyle(
                  fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                  color: Color.fromARGB(255, 25, 25, 25))),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Aligns children at the start of the cross axis
        children: [
          Text(
            'Date of Service: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 11.4,
                color: Colors.grey),
          ),
          Flexible(
            child: Text(
              formatDate(date_of_service),
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 11.4,
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'Invoice Status: ',
            style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
                color: Colors.grey),
          ),
          // Text(email),
          Flexible(
            child: Text(
              capitalizeFirstLetter(email),
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
              ),
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

String truncateProductName2(String name) {
  if (name.length > 18) {
    return name.substring(0, 18) + '..';
  }
  return name;
}

class TicketData extends StatelessWidget {
  final InvoiceModel invoiceModel;

  const TicketData({
    Key? key,
    required this.invoiceModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double subtotal = invoiceModel.totalPrice;

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
                      'Invoice Id',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: appcolor.textColor,
                        fontSize: heights <= 690 && widths <= 430 ? 11 : 14,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '# ' + invoiceModel.invoiceId,
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
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
                'Invoice Details',
                textScaleFactor: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: heights <= 690 && widths <= 430 ? 16 : 20,
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
                          fontSize: heights <= 690 && widths <= 430 ? 9 : 14,
                        ),
                      ),
                      Text(
                        'PRICE',
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: heights <= 690 && widths <= 430 ? 9 : 14,
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(invoiceModel.products.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width:
                                    heights <= 690 && widths <= 430 ? 24 : 30,
                                height:
                                    heights <= 690 && widths <= 430 ? 24 : 30,
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
                                    invoiceModel.products[index].name +
                                        ' x ' +
                                        invoiceModel.products[index].quantity
                                            .toString(),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: heights <= 690 && widths <= 430
                                        ? 10
                                        : 12),
                              ),
                            ],
                          ),
                          Text(
                            '\$' +
                                invoiceModel.products[index].price.toString(),
                            style: TextStyle(
                                color: Colors.black,
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
              ticketDetailsRow('Due Date', formatDate(invoiceModel.dueDate)),
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
            fontSize: heights <= 690 && widths <= 430 ? 11 : 14,
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
            fontSize: heights <= 690 && widths <= 430 ? 11 : 14,
          ),
        ),
      )
    ],
  );
}
