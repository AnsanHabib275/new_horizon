// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

String? username;

class _PaymentsScreenState extends State<PaymentsScreen> {
  Future<void> getusername() async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedName = prefs.getString('name');
    setState(() {
      username = fetchedName;
    });
  }

  @override
  void initState() {
    super.initState();
    getusername();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: appcolor.textWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined,
                size: 20, color: Colors.black), // Change the color here
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(Get.height * 0.01),
              child: Row(
                children: [
                  Text(
                    '$username',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Humanist sans',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: Get.width * 0.02,
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person_2_outlined),
                  ),
                ],
              ),
            )
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '  Payments  ',
                            style: TextStyle(
                              color: appcolor.textColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            // Padding(

            Padding(
              padding: EdgeInsets.only(
                  left: Get.width * 0.03,
                  top: Get.height * 0.02,
                  right: Get.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('United States Dollar (USD)'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            appcolor.colorPrimaryLightDark),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 14))),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: appcolor
                          .colorPrimaryLightDark, // Change this color to your desired color
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: const Icon(
                      Icons
                          .account_balance, // Replace this with your desired icon
                      color: Color.fromARGB(255, 194, 190,
                          190), // Change this color to your desired color
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Get.width * 0.03,
                  right: Get.width * 0.03,
                  top: Get.height * 0.02),
              child: Container(
                height: Get.height * 0.6,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 220, 220, 220), // your grey color
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: Get.width * 0.02, top: Get.height * 0.01),
                            child: const Text(
                              'From USA Bank Account',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Humanist sans'),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Get.width * 0.02, top: Get.height * 0.01),
                        child: Wrap(
                          // Use Wrap here too
                          children: [
                            const Text(
                              'Lorem ipsum dolor sit amet, consectetur eo eiusmod tempor incididunt ut labore',
                              style: TextStyle(
                                letterSpacing: 0.2,
                                fontFamily: 'Humanist Sans',
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w200,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Handle text overflow
                              maxLines:
                                  3, // Consider setting maxLines if needed
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02,
                            vertical: Get.height * 0.0),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Reference',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02,
                            vertical: Get.height * 0.01),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Routing Number',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02,
                            vertical: Get.height * 0.0),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Account Number',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02,
                            vertical: Get.height * 0.01),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Account Type',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02,
                            vertical: Get.height * 0.0),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Send Bank Transfer Slip to',
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: Get.width * 0.02, top: Get.height * 0.04),
                            child: SizedBox(
                              child: ElevatedButton(
                                onPressed: () async {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appcolor.textColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  minimumSize:
                                      Size(Get.width * 0.4, Get.height * 0.060),
                                ),
                                child: const Text(
                                  'Print',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        )),
      ),
    );
  }
}
