// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, sort_child_properties_last, use_build_context_synchronously, must_call_super, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, curly_braces_in_flow_control_structures, unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:dashed_rect/dashed_rect.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motion_toast/motion_toast.dart';

class DataSubmisiion2 extends StatefulWidget {
  final String data;
  const DataSubmisiion2({super.key, required this.data});

  @override
  State<DataSubmisiion2> createState() => _DataSubmisiion2State();
}

class _DataSubmisiion2State extends State<DataSubmisiion2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController provider = TextEditingController();
  TextEditingController insuranceCarrier = TextEditingController();
  TextEditingController policynumbercontrollerr = TextEditingController();
  TextEditingController dia_gnosis = TextEditingController();
  TextEditingController reqtreatment = TextEditingController();
  TextEditingController entry_date = TextEditingController();
  TextEditingController date_ofservice = TextEditingController();
  bool isSubmitPressed = false;

  var paths = {
    'insurance': '',
    'policy': '',
    'id': '',
    'icard': '',
    'referral': '',
  };

  var texts = {
    'insurance': 'Secondary Insurance',
    'policy': 'Secondary Policy No.',
    'id': 'Attach an Id',
    'icard': 'Insurance Card',
    'referral': 'Referral & Office Note',
  };

  Map<String, String> selectedFileNames = {
    'insurance': '',
    'policy': '',
    'id': '',
    'icard': '',
    'referral': '',
  };

  var isValidated = {
    'insurance': true,
    'policy': true,
    'id': true,
    'icard': true,
    'referral': true,
  };
  var textsshort = {
    'insurance': 'Backup Ins.',
    'policy': ' Backup Policy No.',
    'id': 'Attach an Id',
    'icard': ' Insurance Card',
    'referral': ' Referral Note',
  };

  String capitalizeFirst(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  var heights = Get.height;
  var widths = Get.width;

  imagepicker(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No Image Selected")));
      setState(() {
        isValidated[type] = false;
      });
      return;
    }

    var path = pickedFile.path;

    String? extension = path.split('.').last;
    if (extension != "jpeg" &&
        extension != "png" &&
        extension != "jpg" &&
        extension != "heic") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Select jpg & jpeg & png images format only"),
        ),
      );
      return;
    }

    paths[type] = path;
    String desiredPortion = path.substring(
      path.length - extension.length - 8,
      path.length - extension.length - 1,
    );
    String newFileName = "IMG_" + desiredPortion;
    selectedFileNames[type] = newFileName;
    setState(() {
      texts[type] = 'Selected for ' + capitalizeFirst(type);
      isValidated[type] = true; // Image is valid since it's selected
    });

    print(paths[type]);
  }

  bool isInsuranceImageSelected() {
    return paths.containsKey('insurance') &&
        paths['insurance'] != null &&
        paths['insurance']!.isNotEmpty;
  }

  bool ispOLICYImageSelected() {
    return paths.containsKey('policy') &&
        paths['policy'] != null &&
        paths['policy']!.isNotEmpty;
  }

  bool isIDImageSelected() {
    return paths.containsKey('id') &&
        paths['id'] != null &&
        paths['id']!.isNotEmpty;
  }

  bool isicardImageSelected() {
    return paths.containsKey('icard') &&
        paths['icard'] != null &&
        paths['icard']!.isNotEmpty;
  }

  bool isreferralImageSelected() {
    return paths.containsKey('referral') &&
        paths['referral'] != null &&
        paths['referral']!.isNotEmpty;
  }

  @override
  void initState() {
    setState(() {
      context.loaderOverlay.hide();
    });
    context.loaderOverlay.hide();
    log(heights.toString());
    log(widths.toString());
  }

  @override
  Widget build(BuildContext context) {
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
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Benefit Verification',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
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
                            readOnly: true,
                            onTap: () async {
                              final DateTime? selectedDate =
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2021, 1, 1),
                                    lastDate: DateTime(2023, 12, 31),
                                  );

                              if (selectedDate != null) {
                                // Format the date as MM/dd/yyyy
                                String formattedDate =
                                    "${selectedDate.month.toString().padLeft(2, '0')}/"
                                    "${selectedDate.day.toString().padLeft(2, '0')}/"
                                    "${selectedDate.year.toString()}";

                                setState(() {
                                  entry_date.text = formattedDate;
                                });
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entry Date cannot be blank';
                              }

                              RegExp regex = RegExp(
                                r'^(0[1-9]|1[0-2])/(0[1-9]|1[0-9]|2[0-9]|3[0-1])/\d{4}$',
                              );

                              if (!regex.hasMatch(value)) {
                                return 'Enter date in MM/dd/yyyy format';
                              }

                              return null;
                            },
                            controller: entry_date,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
                              ),
                              hintText: "Entry Date",
                              labelText: "Entry Date",
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                ), // Calendar icon
                                onPressed: () async {
                                  final DateTime? selectedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2021, 1, 1),
                                        lastDate: DateTime(2023, 12, 31),
                                      );

                                  if (selectedDate != null) {
                                    // Format the date as MM/dd/yyyy
                                    String formattedDate =
                                        "${selectedDate.month.toString().padLeft(2, '0')}/"
                                        "${selectedDate.day.toString().padLeft(2, '0')}/"
                                        "${selectedDate.year.toString()}";

                                    setState(() {
                                      entry_date.text = formattedDate;
                                    });
                                  }
                                },
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: (value) => (value!.isEmpty || value.length <= 2
                            //     ? 'Enter valid First Name'
                            //     : null),
                            validator: (value) {
                              if (value!.isEmpty) {
                                if (isSubmitPressed)
                                  return 'Required to submit';
                                return null; // This ensures the error doesn't show until user interacts or submits
                              }
                              if (value.length <= 2)
                                return 'Enter a valid First Name';
                              return null;
                            },
                            onChanged: (text) {
                              print('text $text');
                            },
                            controller: firstname,
                            autocorrect: false,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    (value!.isEmpty || value.length <= 2
                                        ? 'Enter Valid Last Name'
                                        : null),
                            onChanged: (text) {
                              print('text $text');
                            },
                            controller: lastname,
                            autocorrect: false,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
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
                            onTap: () async {
                              final DateTime? selectedDate =
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1970, 1, 1),
                                    lastDate: DateTime(2023, 12, 31),
                                  );

                              if (selectedDate != null) {
                                // Format the date as MM/dd/yyyy
                                String formattedDate =
                                    "${selectedDate.month.toString().padLeft(2, '0')}/"
                                    "${selectedDate.day.toString().padLeft(2, '0')}/"
                                    "${selectedDate.year.toString()}";

                                setState(() {
                                  dob.text = formattedDate;
                                });
                              }
                            },
                            readOnly: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Date cannot be blank';
                              }

                              RegExp regex = RegExp(
                                r'^(0[1-9]|1[0-2])/(0[1-9]|1[0-9]|2[0-9]|3[0-1])/\d{4}$',
                              );

                              if (!regex.hasMatch(value)) {
                                return 'Enter date in MM/dd/yyyy format';
                              }

                              return null;
                            },
                            onChanged: (text) {
                              print('text $text');
                            },
                            controller: dob,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
                              ),
                              hintText: "Date of Birth",
                              labelText: "Date of Birth",
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                ), // Calendar icon
                                onPressed: () async {
                                  final DateTime? selectedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1970, 1, 1),
                                        lastDate: DateTime(2023, 12, 31),
                                      );

                                  if (selectedDate != null) {
                                    // Format the date as MM/dd/yyyy
                                    String formattedDate =
                                        "${selectedDate.month.toString().padLeft(2, '0')}/"
                                        "${selectedDate.day.toString().padLeft(2, '0')}/"
                                        "${selectedDate.year.toString()}";

                                    setState(() {
                                      dob.text = formattedDate;
                                    });
                                  }
                                },
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
                            autocorrect: false,
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    (value!.isEmpty || value.length <= 2
                                        ? 'Enter Valid Insurance Primary'
                                        : null),
                            onChanged: (text) {
                              print('text $text');
                            },
                            controller: insuranceCarrier,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
                              ),
                              hintText: "Insurance Primary",
                              labelText: "Insurance Primary",
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
                            autocorrect: false,
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    (value!.isEmpty || value.length <= 3
                                        ? 'Enter Valid Insurance Policy Number'
                                        : null),
                            onChanged: (text) {
                              print('text $text');
                            },
                            keyboardType: TextInputType.number,
                            controller: policynumbercontrollerr,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
                              ),
                              hintText: "Insurance Policy Number",
                              labelText: "Insurance Policy Number",
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
                            autocorrect: false,
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    (value!.isEmpty || value.length <= 2
                                        ? 'Enter Valid Diagnosed Disease'
                                        : null),
                            onChanged: (text) {
                              print('text $text');
                            },
                            controller: dia_gnosis,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
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
                            autocorrect: false,
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    (value!.isEmpty
                                        ? 'Enter Valid Provider'
                                        : null),
                            onChanged: (text) {
                              print('text $text');
                            },
                            controller: provider,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
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
                            autocorrect: false,
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    (value!.isEmpty || value.length <= 2
                                        ? 'Enter Valid Treatment Requested'
                                        : null),
                            onChanged: (text) {
                              print('text $text');
                            },
                            controller: reqtreatment,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
                              ),
                              hintText: "Treatment Requested",
                              labelText: "Treatment Requested",
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
                            onTap: () async {
                              final DateTime? selectedDate =
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2021, 1, 1),
                                    lastDate: DateTime(2023, 12, 31),
                                  );

                              if (selectedDate != null) {
                                // Format the date as MM/dd/yyyy
                                String formattedDate =
                                    "${selectedDate.month.toString().padLeft(2, '0')}/"
                                    "${selectedDate.day.toString().padLeft(2, '0')}/"
                                    "${selectedDate.year.toString()}";

                                setState(() {
                                  date_ofservice.text = formattedDate;
                                });
                              }
                            },
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Date of Service cannot be blank';
                            //   }

                            //   RegExp regex = RegExp(
                            //       r'^(0[1-9]|1[0-2])/(0[1-9]|1[0-9]|2[0-9]|3[0-1])/\d{4}$');

                            //   if (!regex.hasMatch(value)) {
                            //     return 'Enter date in MM/dd/yyyy format';
                            //   }

                            //   return null;
                            // },
                            onChanged: (text) {
                              print('text $text');
                            },
                            controller: date_ofservice,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: appcolor.textColor,
                                ),
                              ),
                              hintText: "Date of Service",
                              labelText: "Date of Service",
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                ), // Calendar icon
                                onPressed: () async {
                                  final DateTime? selectedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2021, 1, 1),
                                        lastDate: DateTime(2023, 12, 31),
                                      );

                                  if (selectedDate != null) {
                                    // Format the date as MM/dd/yyyy
                                    String formattedDate =
                                        "${selectedDate.month.toString().padLeft(2, '0')}/"
                                        "${selectedDate.day.toString().padLeft(2, '0')}/"
                                        "${selectedDate.year.toString()}";

                                    setState(() {
                                      date_ofservice.text = formattedDate;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.photo,
                                color: appcolor.textColor,
                                size: 35,
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Select the documents from Gallery',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 0, 70, 111),
                                    ),
                                  ),
                                  Text(
                                    'PNG,JPEG,JPG or HEIC',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Color.fromARGB(255, 133, 133, 133),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        heights <= 685 && widths <= 415
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Get.height * 0.015,
                                    right: Get.width * 0.02,
                                    left: Get.width * 0.04,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('insurance');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              isInsuranceImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 25.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              isInsuranceImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['insurance'] ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 5),
                                              Text(
                                                texts['insurance']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('policy');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              ispOLICYImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 25.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              ispOLICYImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['policy'] ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 5),
                                              Text(
                                                texts['policy']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Get.height * 0.015,
                                    right: Get.width * 0.02,
                                    left: Get.width * 0.04,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('insurance');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              isInsuranceImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 40,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              isInsuranceImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['insurance'] ??
                                                            "",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 10),
                                              Text(
                                                texts['insurance']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('policy');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              ispOLICYImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 40.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              ispOLICYImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['policy'] ??
                                                            "",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 5),
                                              Text(
                                                texts['policy']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                        heights <= 685 && widths <= 415
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Get.height * 0.015,
                                    right: Get.width * 0.02,
                                    left: Get.width * 0.04,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('id');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              isIDImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 25.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              isIDImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['id'] ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 5),
                                              Text(
                                                texts['id']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('icard');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              isicardImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 25.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              isicardImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['icard'] ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 5),
                                              Text(
                                                texts['icard']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Get.height * 0.015,
                                    right: Get.width * 0.02,
                                    left: Get.width * 0.04,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('id');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              isIDImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 40.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              isIDImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['id'] ??
                                                            "",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 10),
                                              Text(
                                                texts['id']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('icard');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              isicardImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 40.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              isicardImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['icard'] ??
                                                            "",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 10),
                                              Text(
                                                texts['icard']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                        heights <= 685 && widths <= 415
                            ? Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Get.height * 0.02,
                                    right: Get.width * 0.04,
                                    left: Get.width * 0.04,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('referral');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              isreferralImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 25.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              isreferralImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['referral'] ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 5),
                                              Text(
                                                texts['referral']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                            )
                            : Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Get.height * 0.02,
                                    right: Get.width * 0.04,
                                    left: Get.width * 0.04,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                    ),
                                    height: Get.height * 0.15,
                                    width: Get.width / 2.32,
                                    child: GestureDetector(
                                      onTap: () {
                                        imagepicker('referral');
                                      },
                                      child: DashedRect(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10),
                                              isreferralImageSelected()
                                                  ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 40.0,
                                                  )
                                                  : Image.asset(
                                                    AssetConstants.uploadimage,
                                                  ),
                                              SizedBox(height: 10),
                                              isreferralImageSelected()
                                                  ? Column(
                                                    children: [
                                                      Text(
                                                        'File Selected',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        selectedFileNames['referral'] ??
                                                            "",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                    'Attach Here',
                                                    style: TextStyle(
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                              SizedBox(height: 10),
                                              Text(
                                                texts['referral']!,
                                                style: TextStyle(fontSize: 12),
                                              ),
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
                                setState(() {
                                  isSubmitPressed =
                                      true; // The submit button was pressed
                                });
                                bool allImagesValid = true;
                                for (var key in isValidated.keys) {
                                  if (!isValidated[key]!) {
                                    allImagesValid = false;
                                    break;
                                  }
                                }

                                if (!allImagesValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("All images are required"),
                                    ),
                                  );
                                  return;
                                }

                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                context.loaderOverlay.show();
                                submitData();
                              },
                              // },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appcolor.textColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(
                                  Get.width * 0.8,
                                  Get.height * 0.060,
                                ),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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

    log(widget.data + " mycheck");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://api.newhorizonhm.com/api/benefitsverification?bv_id=${widget.data}',
      ),
    );

    request.fields.addAll({
      'entry_date': entry_date.text,
      'date_of_service': date_ofservice.text,
      'date_of_birth': dob.text,
      'first_name': firstname.text,
      'last_name': lastname.text,
      'provider': provider.text,
      'insurance_carrier': insuranceCarrier.text,
      'policy_number': policynumbercontrollerr.text,
      'diagnosis': dia_gnosis.text,
      'uid': uid,
      'requested_treatment': reqtreatment.text,
    });

    // List of types
    try {
      request.files.add(
        await http.MultipartFile.fromPath('sinsurance', paths['insurance']!),
      );
      request.files.add(
        await http.MultipartFile.fromPath('spolicynumber', paths['policy']!),
      );
      request.files.add(await http.MultipartFile.fromPath('id', paths['id']!));
      request.files.add(
        await http.MultipartFile.fromPath('icard', paths['icard']!),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'referralandnote',
          paths['referral']!,
        ),
      );
    } catch (e) {
      // if (e is IOException) {
      //   // Catching IO exception which includes file not found error
      //   context.loaderOverlay.hide();
      //   MotionToast(
      //     primaryColor: Color.fromARGB(255, 248, 77, 65),
      //     icon: Icons.zoom_out,
      //     title: Text("Error!"),
      //     description: Text("Images Path Not Found.."),
      //     position: MotionToastPosition.top,
      //     animationType: AnimationType.slideInFromLeft,
      //   ).show(context);
      //   return;
      // }
    }
    // if (paths.values.any((path) => path.isEmpty)) {
    //   Fluttertoast.showToast(
    //       msg: "All images must be selected before submission.");
    //   return;
    // }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      log("Success Response (200): $responseBody");
      Fluttertoast.showToast(msg: "Submitted Successfully");
      context.loaderOverlay.hide();
      AppNavigatorService.navigateToReplacement(Route_paths.home);
    } else if (response.statusCode == 400) {
      context.loaderOverlay.hide();
      String responseBody = await response.stream.bytesToString();
      log("Bad Request Response (400): $responseBody");
      Fluttertoast.showToast(msg: "Details Submission Failed");
      var jsonBody = json.decode(responseBody);
      if (jsonBody.containsKey('error_message')) {
        print(jsonBody['error_message']);
      }
    } else {
      String responseBody = await response.stream.bytesToString();
      log("Other Response (${response.statusCode}): $responseBody");
      context.loaderOverlay.hide();
      MotionToast(
        primaryColor: Color.fromARGB(255, 248, 77, 65),
        icon: Icons.zoom_out,
        title: Text("Something went Wrong!"),
        description: Text("Try Again Later.."),
        position: MotionToastPosition.top,
        animationType: AnimationType.slideInFromLeft,
      ).show(context);
      log(response.reasonPhrase!);
    }
  }

  jsonDecode(param0) {}
}
