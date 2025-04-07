// ignore_for_file: must_call_super, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/datasubmission2.dart';

class BenefitVerifcationDetails extends StatefulWidget {
  final String data;
  final String date;
  final String fname;
  final String lname;
  final String provider;
  final String insurance_carrier;
  final int policy_number;
  final String diagnosis;
  final String date_of_service;
  final String aprroved_for;
  final String valid_until;
  final String dob;
  final String status;
  final String company;

  const BenefitVerifcationDetails(
      {super.key,
      required this.data,
      required this.date,
      required this.fname,
      required this.lname,
      required this.provider,
      required this.insurance_carrier,
      required this.policy_number,
      required this.dob,
      required this.date_of_service,
      required this.company,
      required this.aprroved_for,
      required this.valid_until,
      required this.status,
      required this.diagnosis});

  @override
  State<BenefitVerifcationDetails> createState() =>
      _BenefitVerifcationDetailsState();
}

class _BenefitVerifcationDetailsState extends State<BenefitVerifcationDetails> {
  @override
  void initState() {
    setState(() {
      context.loaderOverlay.hide();
    });
    context.loaderOverlay.hide();
    log(widget.data);
  }

  String formatDate(String inputDate) {
    return inputDate.split('T').first;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          body: SingleChildScrollView(
              child: Column(children: [
        SizedBox(
          height: Get.height * 0.08,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: Get.width * 0.04),
              child: const Text(
                'Details',
                style: TextStyle(
                    fontFamily: 'Humanist sans',
                    fontSize: 20,
                    color: appcolor.textColor),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(right: Get.width * 0.02, top: 50),
              child: const Text(
                '',
                style: TextStyle(
                    fontFamily: 'Humanist sans',
                    fontSize: 19,
                    color: appcolor.textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                height: Get.height * 0.045,
                width: 102,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: const LinearGradient(colors: [
                      appcolor.textColor,
                      appcolor.textColor,
                    ])),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DataSubmisiion2(data: widget.data),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(fontFamily: 'Segoe UI'),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.edit_outlined,
                        color: appcolor.textWhite,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: Get.width * 0.039,
                  right: Get.width * 0.03,
                  top: Get.width * 0.02),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Entry Date'),
                          Text(formatDate(widget.date)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Date of Service'),
                          Text(formatDate(widget.date_of_service))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Patient First Name'),
                          Text(widget.fname)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.025,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Patient Last Name'),
                          Text(widget.lname)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('DOB'),
                          Text(formatDate(widget.dob))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.025,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Provider'),
                          Text(widget.provider)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Insurance Carrier'),
                          Text(widget.insurance_carrier),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.025,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Valid Until'),
                          Text(formatDate(widget.valid_until))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Approved For'),
                          Text(widget.aprroved_for),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.025,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Policy Number'),
                          Text(widget.policy_number.toString())
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Diagnosis'),
                            Text(widget.diagnosis)
                          ]),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.025,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text('Status'), Text(widget.status)],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Company'),
                            Text(widget.company)
                          ]),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Secondary Policy Number'),
                          Image.asset(AssetConstants.pdfsuccess)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.025,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Attach an ID'),
                          Image.asset(AssetConstants.pdfsuccess)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.02,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Insurance  Card'),
                          Image.asset(AssetConstants.pdfsuccess)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.039,
                right: Get.width * 0.025,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 234, 255)),
                    height: 41,
                    width: Get.width / 1.084,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Referral And Office Note '),
                          Image.asset(AssetConstants.pdfsuccess)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.055,
                  right: Get.width * 0.05,
                  left: Get.width * 0.042),
              child: SizedBox(
                width: double
                    .infinity, // to make the button take the full available width
                child: ElevatedButton(
                  onPressed: () {
                    AppNavigatorService.navigateToReplacement(Route_paths.home);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(appcolor.textColor),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        )
      ]))),
    );
  }
}
