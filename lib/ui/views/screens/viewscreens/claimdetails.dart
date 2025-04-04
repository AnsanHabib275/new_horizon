// ignore_for_file: unnecessary_null_comparison, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, deprecated_member_use, sort_child_properties_last, curly_braces_in_flow_control_structures, unused_field, prefer_final_fields, unrelated_type_equality_checks, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/models/claims.dart';
import 'package:new_horizon/core/models/orderdetailsbyuid.dart';
import 'package:new_horizon/core/services/apis/user/updateclaimsinfo.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/claimuserdoc.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../../../../core/services/app/app_navigator_service.dart';

class ClaimDetails extends StatefulWidget {
  final PatientBillingInfo patientBillingInfo;
  final Function onClaimsUpdated;
  const ClaimDetails(
      {super.key,
      required this.patientBillingInfo,
      required this.onClaimsUpdated});

  @override
  State<ClaimDetails> createState() => _ClaimDetailsState();
}

class _ClaimDetailsState extends State<ClaimDetails> {
  String _submittedDate = '';
  String _paidDate = '';
  String _billedAmount = '';
  String _paidAmount = '';
  String checkupdatedvalueflag = '0';
  TextEditingController submitteddateC = TextEditingController();
  TextEditingController paiddateC = TextEditingController();
  TextEditingController billedamountC = TextEditingController();
  TextEditingController paidamountC = TextEditingController();

  @override
  void initState() {
    super.initState();
    submitteddateC.text = formatDate(widget.patientBillingInfo.dateBilled);
    paiddateC.text = formatDate(widget.patientBillingInfo.datePaid);
    billedamountC.text = widget.patientBillingInfo.amountBilled.toString();
    paidamountC.text = widget.patientBillingInfo.amountPaid.toString();
  }

  @override
  void dispose() {
    submitteddateC.dispose();
    paiddateC.dispose();
    billedamountC.dispose();
    paidamountC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BillingProduct firstProduct =
        widget.patientBillingInfo.billingProducts.first;
    String productName = firstProduct.name;
    double productPrice = firstProduct.price;
    return WillPopScope(
      onWillPop: () async {
        AppNavigatorService.navigateToReplacement(Route_paths.billing);
        return false; // Suppress the default back action
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined,
                    size: 20, color: Colors.black), // Change the color here
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Claim Details',
                style: TextStyle(color: Colors.black),
              ),
              actions: const <Widget>[],
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                Column(children: [
                  const SizedBox(height: 20),
                  Container(
                    child: Card(
                      color: const Color.fromARGB(203, 255, 255, 255),
                      elevation: 2.0,
                      margin: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: infoColumn(
                                'Claim Patient Info',
                                widget.patientBillingInfo.patientName,
                                formatDate(
                                    widget.patientBillingInfo.dateOfService),
                                capitalizeFirstLetter(
                                    widget.patientBillingInfo.primaryInsurance),
                                capitalizeFirstLetter(
                                    widget.patientBillingInfo.provider),
                                widget.patientBillingInfo.orderId,
                                context,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      color: const Color.fromARGB(203, 255, 255, 255),
                      elevation: 2.0,
                      margin: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Claims Details Info',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)), //this right here
                                                child: Container(
                                                  height: 460,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: Get.width * 0.02,
                                                        right: Get.width * 0.02,
                                                        top: Get.width * 0.02,
                                                        bottom:
                                                            Get.width * 0.02),
                                                    child: Container(
                                                      height: Get.height * 0.6,
                                                      width: Get.width,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255,
                                                            220,
                                                            220,
                                                            220), // your grey color
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: Get
                                                                              .width *
                                                                          0.02,
                                                                      top: Get.height *
                                                                          0.01),
                                                                  child: Text(
                                                                    'Edit Your Claim Details',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        fontSize: heights <= 690 && widths <= 430
                                                                            ? 10
                                                                            : 17,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            'Humanist sans'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  left:
                                                                      Get.width *
                                                                          0.02,
                                                                  top:
                                                                      Get.height *
                                                                          0.01),
                                                              child: Wrap(
                                                                // Use Wrap here too
                                                                children: [
                                                                  Text(
                                                                    'Edit and Save your details, to view your new details you may view it again from here.',
                                                                    style:
                                                                        TextStyle(
                                                                      letterSpacing:
                                                                          0.2,
                                                                      fontFamily:
                                                                          'Humanist Sans',
                                                                      fontSize: heights <= 690 &&
                                                                              widths <= 430
                                                                          ? 6
                                                                          : 15,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Handle text overflow
                                                                    maxLines: 3,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.02,
                                                                  vertical:
                                                                      Get.height *
                                                                          0.0),
                                                              child:
                                                                  TextFormField(
                                                                onTap:
                                                                    () async {
                                                                  final DateTime?
                                                                      selectedDate =
                                                                      await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                            2021,
                                                                            1,
                                                                            1),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2028,
                                                                            12,
                                                                            31),
                                                                  );

                                                                  if (selectedDate !=
                                                                      null) {
                                                                    // Format the date as MM/dd/yyyy
                                                                    String
                                                                        formattedDate =
                                                                        "${selectedDate.month.toString().padLeft(2, '0')}/"
                                                                        "${selectedDate.day.toString().padLeft(2, '0')}/"
                                                                        "${selectedDate.year.toString()}";

                                                                    setState(
                                                                        () {
                                                                      submitteddateC
                                                                              .text =
                                                                          formattedDate;
                                                                    });
                                                                  }
                                                                },
                                                                controller:
                                                                    submitteddateC,
                                                                autocorrect:
                                                                    false,
                                                                autofocus:
                                                                    false,
                                                                // initialValue: submitteddate,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  enabledBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Claim Submitted Date',
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.02,
                                                                  vertical:
                                                                      Get.height *
                                                                          0.01),
                                                              child:
                                                                  TextFormField(
                                                                onTap:
                                                                    () async {
                                                                  final DateTime?
                                                                      selectedDate =
                                                                      await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                            2021,
                                                                            1,
                                                                            1),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2029,
                                                                            12,
                                                                            31),
                                                                  );

                                                                  if (selectedDate !=
                                                                      null) {
                                                                    // Format the date as MM/dd/yyyy
                                                                    String
                                                                        formattedDate =
                                                                        "${selectedDate.month.toString().padLeft(2, '0')}/"
                                                                        "${selectedDate.day.toString().padLeft(2, '0')}/"
                                                                        "${selectedDate.year.toString()}";

                                                                    setState(
                                                                        () {
                                                                      paiddateC
                                                                              .text =
                                                                          formattedDate;
                                                                    });
                                                                  }
                                                                },
                                                                autocorrect:
                                                                    false,
                                                                controller:
                                                                    paiddateC,
                                                                autofocus:
                                                                    false,
                                                                // initialValue: paiddate,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  enabledBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Claim Paid Date',
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.02,
                                                                  vertical:
                                                                      Get.height *
                                                                          0.0),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                autocorrect:
                                                                    false,
                                                                controller:
                                                                    billedamountC,
                                                                autofocus:
                                                                    false,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  enabledBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Claim Billed Amount',
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.02,
                                                                  vertical:
                                                                      Get.height *
                                                                          0.01),
                                                              child:
                                                                  TextFormField(
                                                                autocorrect:
                                                                    false,
                                                                autofocus:
                                                                    false,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    paidamountC,
                                                                // initialValue: paidamount,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  enabledBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Claim Paid Amount',
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  left:
                                                                      Get.width *
                                                                          0.015,
                                                                  top: Get.height *
                                                                      0.015),
                                                              child: SizedBox(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    context
                                                                        .loaderOverlay
                                                                        .show();

                                                                    UpdateClaimsinfo.Updateclaiminf(
                                                                            widget.patientBillingInfo.orderId
                                                                                .toString(),
                                                                            submitteddateC.text
                                                                                .toString(),
                                                                            paiddateC.text
                                                                                .toString(),
                                                                            billedamountC.text
                                                                                .toString(),
                                                                            paidamountC.text
                                                                                .toString(),
                                                                            context)
                                                                        .then(
                                                                            (value) {
                                                                      _billedAmount = billedamountC
                                                                          .text
                                                                          .toString();
                                                                      _paidAmount = paidamountC
                                                                          .text
                                                                          .toString();
                                                                      _submittedDate = submitteddateC
                                                                          .text
                                                                          .toString();
                                                                      _paidDate = paiddateC
                                                                          .text
                                                                          .toString();
                                                                      checkupdatedvalueflag =
                                                                          '1';
                                                                      setState(
                                                                          () {
                                                                        widget
                                                                            .onClaimsUpdated();
                                                                        print(checkupdatedvalueflag.toString() +
                                                                            'and' +
                                                                            _billedAmount.toString());
                                                                      });
                                                                    });
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        appcolor
                                                                            .textColor,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                    minimumSize: Size(
                                                                        Get.width *
                                                                            0.4,
                                                                        Get.height *
                                                                            0.060),
                                                                  ),
                                                                  child: Text(
                                                                    'Save',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      fontSize: heights <= 690 &&
                                                                              widths <= 430
                                                                          ? 12
                                                                          : 19,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        size: 18,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'Claim submitted Date: ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontFamily: 'Segoe UI'),
                                    ),
                                    Text(
                                      checkupdatedvalueflag == '1'
                                          ? _submittedDate.toString()
                                          : formatDate(widget
                                              .patientBillingInfo.dateBilled),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontFamily: 'Segoe UI'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Claim Paid Date: ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontFamily: 'Segoe UI'),
                                    ),
                                    Text(
                                      checkupdatedvalueflag == '1'
                                          ? _paidDate.toString()
                                          : formatDate(widget
                                              .patientBillingInfo.datePaid),
                                      style: TextStyle(
                                          fontSize: 13.5,
                                          fontFamily: 'Segoe UI'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Claim Billed Amount: \$',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontFamily: 'Segoe UI'),
                                    ),
                                    Text(
                                      checkupdatedvalueflag == '1'
                                          ? _billedAmount.toString()
                                          : widget
                                              .patientBillingInfo.amountBilled,
                                      style: TextStyle(
                                          fontSize: 13.5,
                                          fontFamily: 'Segoe UI'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Claim Paid Amount: \$',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontFamily: 'Segoe UI'),
                                    ),
                                    Text(
                                      checkupdatedvalueflag == '1'
                                          ? _paidAmount.toString()
                                          : widget.patientBillingInfo.amountPaid
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 13.5,
                                          fontFamily: 'Segoe UI'),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TicketWidget(
                    color: Color.fromARGB(215, 235, 235, 235),
                    width: 410,
                    height: 450,
                    isCornerRounded: true,
                    padding: EdgeInsets.all(20),
                    child: TicketData(
                      patientBillingInfo: widget.patientBillingInfo,
                    ),
                  ),
                ),
              ]),
            )),
      ),
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
            color: const Color.fromARGB(198, 239, 239, 239),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 12.0, bottom: 4, top: 10),
                        child: Text(
                          'Product Details',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Image.network(order.image, errorBuilder:
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
                              fontFamily: 'Humanist Sans', fontSize: 12),
                        )),
                      );
                    }),
                    title: Text(
                      capitalizeFirstLetter(
                        order.firstName + ' ' + order.lastName,
                      ),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    subtitle: Text(order.orderEmail),
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

Widget infoColumn(String title, String number, String studio, String email,
    String provider, String order_id, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              // AppNavigatorService.pushNamed(Route_paths);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Claimuserdoc(order_id: order_id)));
            },
            child: Icon(
              Icons.link,
              color: Color.fromARGB(255, 37, 37, 37),
              size: 18,
            ),
          )
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Text(
            'Name: ',
            style: TextStyle(
                color: Colors.grey, fontSize: 13, fontFamily: 'Segoe UI'),
          ),
          Text(
            capitalizeFirstLetter(
              number,
            ),
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'Segoe UI'),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'Date of Service: ',
            style: TextStyle(
                color: Colors.grey, fontSize: 13, fontFamily: 'Segoe UI'),
          ),
          Text(
            capitalizeFirstLetter(studio),
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'Segoe UI'),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'Primary Ins: ',
            style: TextStyle(
                color: Colors.grey, fontSize: 13, fontFamily: 'Segoe UI'),
          ),
          Text(
            email,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'Segoe UI'),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'Provider: ',
            style: TextStyle(
                color: Colors.grey, fontSize: 13, fontFamily: 'Segoe UI'),
          ),
          Text(
            capitalizeFirstLetter(provider),
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'Segoe UI'),
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

class TicketData extends StatelessWidget {
  final PatientBillingInfo patientBillingInfo;

  const TicketData({
    Key? key,
    required this.patientBillingInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String patientName = patientBillingInfo.patientName;

    BillingProduct firstProduct = patientBillingInfo.billingProducts.first;

    String subtotal = patientBillingInfo.amountBilled;

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
                      'Order Type',
                      textScaleFactor: 1,
                      style: TextStyle(color: appcolor.textColor),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '# ' + firstProduct.type,
                      textScaleFactor: 1,
                      style: const TextStyle(
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
                'Claim Products Details',
                textScaleFactor: 1,
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
                    children: const [
                      Text(
                        'ITEMS',
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'UNITS',
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  ...List.generate(patientBillingInfo.billingProducts.length,
                      (index) {
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
                              const SizedBox(width: 10.0),
                              Text(
                                capitalizeFirstLetter(truncateProductName(
                                  patientBillingInfo
                                      .billingProducts[index].name,
                                )),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: heights <= 690 && widths <= 430
                                      ? 9
                                      : 12.5,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            patientBillingInfo.billingProducts[index].quantity
                                    .toString() +
                                '    ',
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
          bottom: heights <= 684 && widths <= 412
              ? 0
              : MediaQuery.of(context).size.height * 0.01,
          left: 0,
          right: 0,
          child: Column(
            children: [
              SizedBox(
                height: heights <= 684 && widths <= 412 ? 8 : 10,
              ),
              const Divider(
                color: Color.fromARGB(255, 208, 208, 208),
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 10),
              ticketDetailsRow(
                  'Total', subtotal != 'Not Paid' ? '\$' + subtotal : '---'),
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
          style: const TextStyle(color: Colors.grey),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          textScaleFactor: 1,
          desc,
          style: const TextStyle(color: Colors.black),
        ),
      )
    ],
  );
}
