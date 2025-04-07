// ignore_for_file: avoid_print, sized_box_for_whitespace, sort_child_properties_last, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_const_constructors, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_local_variable, must_call_super

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dashed_rect/dashed_rect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataSubmisionForm extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final TextEditingController firstname;
  final TextEditingController lastname;
  final TextEditingController dob;
  final TextEditingController provider;
  final TextEditingController insuranceCarrier;
  final TextEditingController policyno;
  final TextEditingController diagnosis;
  final TextEditingController entrydate;
  final TextEditingController dateofservice;

  const DataSubmisionForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController firstnameController,
    required TextEditingController lastnameController,
    required TextEditingController dateofbirthController,
    required TextEditingController providerController,
    required TextEditingController insuranceCarrierController,
    required TextEditingController policynumberController,
    required TextEditingController diagnosiss,
    required TextEditingController entry_date,
    required TextEditingController date_ofservice,
  }) : _formKey = formKey,
       firstname = firstnameController,
       lastname = lastnameController,
       dob = dateofbirthController,
       provider = providerController,
       insuranceCarrier = insuranceCarrierController,
       policyno = policynumberController,
       diagnosis = diagnosiss,
       entrydate = entry_date,
       dateofservice = date_ofservice,
       super(key: key);

  @override
  State<DataSubmisionForm> createState() => _DataSubmisionFormState();
}

var paths = {
  'insurance': '',
  'policy': '',
  'id': '',
  'icard': '',
  'referral': '',
};
var texts = {
  'insurance': 'Secondary Insurance',
  'policy': ' Secondary Policy Number',
  'id': 'Attach an Id',
  'icard': ' Insurance Card',
  'referral': ' Referral & Office Note',
};

String capitalizeFirst(String text) {
  return text[0].toUpperCase() + text.substring(1);
}

class _DataSubmisionFormState extends State<DataSubmisionForm> {
  imagepicker(String type) async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'HEIC', 'jpeg'],
    );
    if (results == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No File Selected")));
      return null;
    }
    var path = results.files.single.path!;
    paths[type] = path;

    setState(() {
      texts[type] = 'Selected for ' + capitalizeFirst(type);
    });

    print(paths[type]);
  }

  @override
  void initState() {
    setState(() {
      context.loaderOverlay.hide();
    });
    context.loaderOverlay.hide();
  }

  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Expanded(
        flex: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.04,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator:
                    (value) =>
                        (value!.isEmpty || value.length <= 2
                            ? 'Enter valid First Name'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.firstname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Patient's First Name",
                  labelText: "Patient's First Name",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator:
                    (value) =>
                        (value!.isEmpty || value.length <= 2
                            ? 'Last Name cannot be blank'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.lastname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Patient's Last Name",
                  labelText: "Patient's Last Name",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty || value.length <= 2
                            ? 'DoB  cannot be blank'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.dob,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Date of Birth",
                  labelText: "Date of Birth",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty ? 'Provider cannot be blank' : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.provider,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Provider",
                  labelText: "Provider",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty
                            ? 'Insurance Carrier cannot be blank'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.insuranceCarrier,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Insurance Carrier",
                  labelText: "Insurance Carrier",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty
                            ? 'Policy Number cannot be blank'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                keyboardType: TextInputType.number,
                controller: widget.policyno,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Policy Number",
                  labelText: "Policy Number",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty
                            ? 'Diagnosis Field cannot be blank'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.diagnosis,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Diagnosis",
                  labelText: "Diagnosis",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty ? 'Entry Date cannot be blank' : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.entrydate,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Entry Date",
                  labelText: "Entry Date",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty
                            ? 'Date of Service cannot be blank'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.dateofservice,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Date of Service",
                  labelText: "Date of Service",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.height * 0.015,
                    right: Get.width * 0.02,
                    left: Get.width * 0.04,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    height: Get.height * 0.15,
                    width: Get.width / 2.32,
                    child: GestureDetector(
                      onTap: () {
                        imagepicker('insurance');
                      },
                      child: DashedRect(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Image.asset(AssetConstants.uploadimage),
                              SizedBox(height: 10),
                              Text(
                                'Attach Here',
                                style: TextStyle(color: appcolor.textColor),
                              ),
                              SizedBox(height: 10),
                              Text(texts['insurance']!),
                            ],
                          ),
                        ),
                        color: Color.fromARGB(255, 94, 94, 94),
                        gap: 0.1,
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.height * 0.015,
                    right: Get.width * 0.04,
                    left: Get.width * 0.02,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    height: Get.height * 0.15,
                    width: Get.width / 2.32,
                    child: GestureDetector(
                      onTap: () {
                        imagepicker('policy');
                      },
                      child: DashedRect(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Image.asset(AssetConstants.uploadimage),
                              SizedBox(height: 10),
                              Text(
                                'Attach Here',
                                style: TextStyle(color: appcolor.textColor),
                              ),
                              SizedBox(height: 10),
                              Text(texts['policy']!),
                            ],
                          ),
                        ),
                        color: Color.fromARGB(255, 94, 94, 94),
                        gap: 0.1,
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.height * 0.015,
                    right: Get.width * 0.02,
                    left: Get.width * 0.04,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    height: Get.height * 0.15,
                    width: Get.width / 2.32,
                    child: GestureDetector(
                      onTap: () {
                        imagepicker('id');
                      },
                      child: DashedRect(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Image.asset(AssetConstants.uploadimage),
                              SizedBox(height: 10),
                              Text(
                                'Attach Here',
                                style: TextStyle(color: appcolor.textColor),
                              ),
                              SizedBox(height: 10),
                              Text(texts['id']!),
                            ],
                          ),
                        ),
                        color: Color.fromARGB(255, 94, 94, 94),
                        gap: 0.1,
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.height * 0.015,
                    right: Get.width * 0.04,
                    left: Get.width * 0.02,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    height: Get.height * 0.15,
                    width: Get.width / 2.32,
                    child: GestureDetector(
                      onTap: () {
                        imagepicker('icard');
                      },
                      child: DashedRect(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Image.asset(AssetConstants.uploadimage),
                              SizedBox(height: 10),
                              Text(
                                'Attach Here',
                                style: TextStyle(color: appcolor.textColor),
                              ),
                              SizedBox(height: 10),
                              Text(texts['icard']!),
                            ],
                          ),
                        ),
                        color: Color.fromARGB(255, 94, 94, 94),
                        gap: 0.1,
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.height * 0.02,
                    right: Get.width * 0.04,
                    left: Get.width * 0.04,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    height: Get.height * 0.15,
                    width: Get.width / 2.32,
                    child: GestureDetector(
                      onTap: () {
                        imagepicker('referral');
                      },
                      child: DashedRect(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Image.asset(AssetConstants.uploadimage),
                              SizedBox(height: 10),
                              Text(
                                'Attach Here',
                                style: TextStyle(color: appcolor.textColor),
                              ),
                              SizedBox(height: 10),
                              Text(texts['referral']!),
                            ],
                          ),
                        ),
                        color: Color.fromARGB(255, 94, 94, 94),
                        gap: 0.1,
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.025,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () async {
                    context.loaderOverlay.show();

                    submitData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appcolor.textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(Get.width * 0.8, Get.height * 0.060),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> submitData() async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');
    if (apiKey == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load Products',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load Products',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('Email Key not found in SharedPreferences');
    }
    var headers = {'Api-key': apiKey};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.newhorizonhm.com/api/benefitsverification'),
    );

    request.fields.addAll({
      'entry_date': widget.entrydate.text,
      'date_of_service': widget.dateofservice.text,
      'date_of_birth': widget.dob.text,
      'first_name': widget.firstname.text,
      'last_name': widget.lastname.text,
      'provider': widget.provider.text,
      'insurance_carrier': widget.insuranceCarrier.text,
      'policy_number': widget.policyno.text,
      'diagnosis': widget.diagnosis.text,
      'uid': uid,
    });

    // List of types
    List<String> types = [
      'sinsurance',
      'spolicynumber',
      'id',
      'icard',
      'referral',
    ];

    // for (String type in types) {
    //   if (paths.containsKey(type)) {
    //     String path = paths[type]!;
    //     String fileName =
    //         path.split('/').last; // Extract the filename from the path
    //     request.files.add(await http.MultipartFile.fromPath(
    //       type,
    //       path,
    //       filename: fileName,
    //     ));
    //   }
    // }
    for (String type in types) {
      if (paths.containsKey(type)) {
        String path = paths[type]!;
        File file = File(path);
        if (file.existsSync()) {
          // Check if the file exists
          String fileName = path.split('/').last;
          request.files.add(
            await http.MultipartFile.fromPath(type, path, filename: fileName),
          );
        } else {
          // If the file doesn't exist, you can log an error, show a message or just continue
          print('File does not exist: $path');
          Fluttertoast.showToast(msg: 'choose files first');
          context.loaderOverlay.hide();
          return; // exit the function if you want
        }
      }
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Fluttertoast.showToast(msg: "Submitted Successfully");
      context.loaderOverlay.hide();
      AppNavigatorService.navigateToReplacement(Route_paths.home);
    } else if (response.statusCode == 400) {
      var responseBody = jsonDecode(await response.stream.bytesToString());
      context.loaderOverlay.hide();
      Fluttertoast.showToast(msg: "Details Submission Failed");
      // AppNavigatorService.navigateToReplacement(Route_paths.home);
      print(responseBody['error_message']);
    } else {
      context.loaderOverlay.hide();
      log(response.reasonPhrase!);
    }
  }
}
