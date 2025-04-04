// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/invoicemodel.dart';
import 'package:new_horizon/core/services/apis/user/invoicedetail.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/invoicedetailscreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/invoices.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/invoicesinvoiced.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/invoicespaid.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/invoicesunpaid.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:shimmer/shimmer.dart';

class InvoiceCompleted extends StatefulWidget {
  const InvoiceCompleted({super.key});

  @override
  State<InvoiceCompleted> createState() => _InvoiceCompletedState();
}

var heights = Get.height;
var widths = Get.width;
bool isLoading = true;
String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

class _InvoiceCompletedState extends State<InvoiceCompleted> {
  TextEditingController textController = TextEditingController();

  List<InvoiceModel>? OrdersList;
  List<InvoiceModel>? filteredordersList;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadorders();
  }

  Future<void> refreshOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await loadorders();
  }

  Future<void> loadorders() async {
    try {
      var fetchedOrders = await GetInoiceByUid.InvoiceByUid();
      var pendingOrders = fetchedOrders
          .where((patient) => patient.invoiceStatus == 'COMPLETED')
          .toList();
      setState(() {
        OrdersList = pendingOrders;
        filteredordersList = pendingOrders;
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
      filteredordersList = OrdersList?.where((patient) {
        return patient.firstName.toLowerCase().contains(query.toLowerCase()) ||
            patient.lastName.toLowerCase().contains(query.toLowerCase());
        // Add any other conditions for filtering based on the search query
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
              'Invoices',
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
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Invoices()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '  All Invoices  ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 11 : 14,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: heights <= 690 && widths <= 430 ? 4 : 6,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InvoicePaid()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            ' Paid ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 11 : 14,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: heights <= 690 && widths <= 430 ? 4 : 6,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const InvoicesUnpaid()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            ' Unpaid ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 11 : 14,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: heights <= 690 && widths <= 430 ? 4 : 6,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const InvoiceInvoiced()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            ' Invoiced ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 11 : 14,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: heights <= 690 && widths <= 430 ? 4 : 6,
                    ),
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
                              ' Completed ',
                              style: TextStyle(
                                color: appcolor.textColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 11 : 14,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
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
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 14.0,
          childAspectRatio: (10 / 20),
        ),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AssetConstants.nofavicon),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'No Invoices',
                    style: TextStyle(
                        fontFamily: 'Humanist Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ));
        },
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        print("Building card for order: ${currentList[index].invoiceId}");
        return MyCard(invoiceModel: currentList[index]);
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
                  const SizedBox(width: 10),
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
                              borderRadius: const BorderRadius.only(
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
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
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
  final InvoiceModel invoiceModel;

  const MyCard({Key? key, required this.invoiceModel}) : super(key: key);

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  Color? getStatusColor(String status, {bool forText = false}) {
    switch (status.toLowerCase()) {
      case 'unpaid':
        return forText ? Colors.red : Colors.red[100];
      case 'paid':
        return forText
            ? Color.fromRGBO(87, 173, 0, 1)
            : Color.fromRGBO(87, 173, 0, 0.2);
      case 'invoiced':
        return forText
            ? Color.fromRGBO(3, 111, 173, 1)
            : Color.fromRGBO(3, 111, 173, 0.2);
      case 'completed':
        return forText
            ? const Color.fromARGB(255, 138, 138, 139)
            : Colors.blue[100];
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InvoiceDetailScreen(invoice: widget.invoiceModel),
            ),
          );
        },
        child: Card(
          elevation: 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
                    color: Color.fromRGBO(233, 244, 250, 1),
                    width: 85,
                    height: 85,
                    child: Center(
                        child: Text(
                      "# " + widget.invoiceModel.invoiceId,
                      style: TextStyle(
                          color: Color.fromRGBO(3, 111, 173, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    )),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        capitalizeFirstLetter(widget.invoiceModel.invoicename),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      SizedBox(height: Get.height * 0.008),
                      Text(
                        formatDate(widget.invoiceModel.invoiceDate),
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
                        '\$' + widget.invoiceModel.totalPrice.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Segoe UI',
                            fontSize: 16,
                            color: Color.fromARGB(255, 58, 58, 58)),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color:
                            getStatusColor(widget.invoiceModel.invoiceStatus),
                      ),
                      height: 20,
                      width: 48,
                      child: Center(
                        child: Text(
                          capitalizeFirstLetter(
                            widget.invoiceModel.invoiceStatus,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Segoe UI',
                            fontSize: 8,
                            color: getStatusColor(
                                widget.invoiceModel.invoiceStatus,
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
