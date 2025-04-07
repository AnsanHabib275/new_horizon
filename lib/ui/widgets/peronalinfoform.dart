// ignore_for_file: avoid_print, unnecessary_new, must_be_immutable, prefer_const_constructors, unused_local_variable, use_build_context_synchronously, unrelated_type_equality_checks, non_constant_identifier_names, avoid_unnecessary_containers, deprecated_member_use

import 'dart:developer';

// import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/models/verifiedpatients.dart';
import 'package:new_horizon/core/services/apis/user/createorderapi.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/HomeScreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/shippinginfo.dart';

class PersonalInforForm extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final TextEditingController email;
  final TextEditingController country;
  final TextEditingController firstname;
  final TextEditingController lastname;
  final TextEditingController shippingaddress;
  final TextEditingController billingaddress;
  final TextEditingController citypicker;
  final TextEditingController postalcode;
  final TextEditingController phonenumber;
  final TextEditingController billingfname;
  final TextEditingController billinglname;
  final TextEditingController billingcity;
  final TextEditingController billingpostalcode;
  final TextEditingController billing_phone_number;
  final TextEditingController note;
  final TextEditingController pateintname;
  final List<VerifiedPatient> verifiedPatients;
  final num totalprice;
  final String company;

  const PersonalInforForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController countryController,
    required TextEditingController firstnameController,
    required TextEditingController lastnameController,
    required TextEditingController shippingController,
    required TextEditingController cityController,
    required TextEditingController postalController,
    required TextEditingController phoneController,
    required TextEditingController billingController,
    required TextEditingController billingfnmController,
    required TextEditingController billinglnmController,
    required TextEditingController billingbphnnumController,
    required TextEditingController billingpostalcodeController,
    required TextEditingController notecontroller,
    required this.verifiedPatients,
    required TextEditingController billingcityController,
    required this.totalprice,
    required this.company,
    bool checkBoxValue = false,
    required this.pateintname,
  }) : _formKey = formKey,
       email = emailController,
       country = countryController,
       firstname = firstnameController,
       lastname = lastnameController,
       shippingaddress = shippingController,
       billingaddress = billingController,
       citypicker = cityController,
       postalcode = postalController,
       phonenumber = phoneController,
       billingfname = billingfnmController,
       billinglname = billinglnmController,
       billingcity = billingcityController,
       note = notecontroller,
       billing_phone_number = billingbphnnumController,
       billingpostalcode = billingpostalcodeController;

  @override
  State<PersonalInforForm> createState() => _PersonalInforFormState();
}

bool _checkBoxValue = false;
// bool checkBoxValue2 = false;
bool checkBoxValue3 = false;
num? val;
String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

enum SingingCharacter { standard, schedule, urgent }

class _PersonalInforFormState extends State<PersonalInforForm> {
  TextEditingController patientnam = TextEditingController();

  void _showVerifiedPatientsBottomSheet(
    BuildContext context,
    List<VerifiedPatient> verifiedPatients,
  ) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 2,
      context: context,
      builder: (BuildContext bc) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: Container(
            child: ListView.builder(
              itemCount: verifiedPatients.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Patient Name: ${verifiedPatients[index].name}',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: heights <= 690 && widths <= 430 ? 12 : 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 3),
                            Text(
                              'Policy Number: ${verifiedPatients[index].policyNumber}',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 12 : 16,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Date of Service: ${formatDate(verifiedPatients[index].date_of_service)}',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 12 : 16,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          widget.pateintname.text =
                              verifiedPatients[index].bvId;
                          patientnam.text = verifiedPatients[index].name;
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Divider(thickness: 3),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  var heights = Get.height;
  var widths = Get.width;
  String billingcountryValue = "";
  String billingstateValue = "";
  String billingcityValue = "";

  SingingCharacter? _character = SingingCharacter.standard;
  TextEditingController sche = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      val = widget.totalprice;
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = new FocusNode();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(initialIndex: 1)),
        );
        return true;
      },
      child: Form(
        key: widget._formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.04,
                right: Get.width * 0.05,
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    controller: patientnam,
                    onTap: () {
                      _showVerifiedPatientsBottomSheet(
                        context,
                        widget.verifiedPatients,
                      );
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: appcolor.textColor),
                      ),
                      hintText: "Verified Patients",
                      labelText: "Verified Patients",
                      labelStyle: TextStyle(
                        color:
                            myFocusNode.hasFocus
                                ? const Color.fromARGB(255, 85, 85, 85)
                                : appcolor.textblack,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () {
                      // _showVerifiedPatientsBottomSheet(
                      //     context, widget.verifiedPatients);
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.05,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty ||
                                !RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)
                            ? 'Email not Valid'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                keyboardType: TextInputType.emailAddress,
                controller: widget.email,
                autofocus: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textblack),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 30, 31, 31),
                    ),
                  ),
                  hintText: "Email",
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color:
                        myFocusNode.hasFocus
                            ? const Color.fromARGB(255, 85, 85, 85)
                            : appcolor.textblack,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: Transform.scale(
                    scale: 1.05,
                    child: Checkbox(
                      value: _checkBoxValue,
                      onChanged: (bool? value) {
                        setState(() {
                          _checkBoxValue = value!;
                        });
                      },
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                    ),
                  ),
                ),
                Text('Email me with News and Offers'),
              ],
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Company Details ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.05,
              ),
              child: TextFormField(
                // readOnly: true,
                // enabled: false,
                initialValue: widget.company.toString(),
                maxLines: 1,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textblack),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 30, 31, 31),
                    ),
                  ),
                  labelStyle: TextStyle(
                    color:
                        myFocusNode.hasFocus
                            ? Color.fromARGB(255, 0, 0, 0)
                            : appcolor.textblack,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 18.0, bottom: 2),
                  child: Text(
                    'Shipping Details ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            // Padding(
            //   padding: EdgeInsets.only(
            //       top: Get.height * 0.015, right: Get.width * 0.05),
            //   child: Stack(
            //     alignment: Alignment.centerRight,
            //     children: [
            //       TextFormField(
            //         onTap: () {
            //           showCountryPicker(
            //             context: context,
            //             exclude: <String>['KN', 'MF'],
            //             favorite: <String>['SE'],
            //             showPhoneCode: true,
            //             onSelect: (Country country) {
            //               print(
            //                   'Select country: ${country.displayNameNoCountryCode}');
            //               widget.country.text =
            //                   country.displayNameNoCountryCode;
            //             },
            //             countryListTheme: CountryListThemeData(
            //               borderRadius: BorderRadius.only(
            //                 topLeft: Radius.circular(40.0),
            //                 topRight: Radius.circular(40.0),
            //               ),
            //               inputDecoration: InputDecoration(
            //                 labelText: 'Search',
            //                 hintText: 'Type to search',
            //                 prefixIcon: const Icon(Icons.search),
            //                 border: OutlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Color.fromARGB(255, 146, 155, 167)
            //                         .withOpacity(0.2),
            //                   ),
            //                 ),
            //               ),
            //               searchTextStyle: TextStyle(
            //                 color: Colors.blue,
            //                 fontSize: 18,
            //               ),
            //             ),
            //           );
            //         },
            //         readOnly: true,
            //         // controller: countryController,
            //         autovalidateMode: AutovalidateMode.onUserInteraction,
            //         validator: (value) => (value!.isEmpty
            //             ? 'Country Region cannot be blank'
            //             : null),
            //         onChanged: (text) {
            //           print('text $text');
            //         },
            //         controller: widget.country,
            //         decoration: InputDecoration(
            //           border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(8),
            //               borderSide: const BorderSide(color: Colors.black)),
            //           focusedBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(8),
            //               borderSide:
            //                   const BorderSide(color: appcolor.textColor)),
            //           hintText: "Country / Region",
            //           labelText: "Country / Region ",
            //           labelStyle: TextStyle(
            //               color: myFocusNode.hasFocus
            //                   ? const Color.fromARGB(255, 85, 85, 85)
            //                   : appcolor.textblack),
            //           contentPadding: const EdgeInsets.symmetric(
            //               horizontal: 20, vertical: 20),
            //         ),
            //       ),
            //       IconButton(
            //         icon: Icon(Icons.keyboard_arrow_down),
            //         onPressed: () {
            //           showCountryPicker(
            //             context: context,
            //             exclude: <String>['KN', 'MF'],
            //             favorite: <String>['SE'],
            //             showPhoneCode: true,
            //             onSelect: (Country country) {
            //               print(
            //                   'Select country: ${country.displayNameNoCountryCode}');
            //               widget.country.text =
            //                   country.displayNameNoCountryCode;
            //             },
            //             countryListTheme: CountryListThemeData(
            //               borderRadius: BorderRadius.only(
            //                 topLeft: Radius.circular(40.0),
            //                 topRight: Radius.circular(40.0),
            //               ),
            //               inputDecoration: InputDecoration(
            //                 labelText: 'Search',
            //                 hintText: 'Type to search',
            //                 prefixIcon: const Icon(Icons.search),
            //                 border: OutlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Color.fromARGB(255, 146, 155, 167)
            //                         .withOpacity(0.2),
            //                   ),
            //                 ),
            //               ),
            //               searchTextStyle: TextStyle(
            //                 color: Colors.blue,
            //                 fontSize: 18,
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.05,
              ),
              child: TextFormField(
                autocorrect: false,
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty ? 'First Name cannot be blank' : null),
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
                  hintText: "First Name",
                  labelText: "First Name",
                  labelStyle: TextStyle(
                    color:
                        myFocusNode.hasFocus
                            ? const Color.fromARGB(255, 85, 85, 85)
                            : appcolor.textblack,
                  ),
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
                right: Get.width * 0.05,
              ),
              child: TextFormField(
                autocorrect: false,
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty ? 'Last Name cannot be blank' : null),
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
                  hintText: "Last Name",
                  labelText: "Last Name",
                  labelStyle: TextStyle(
                    color:
                        myFocusNode.hasFocus
                            ? const Color.fromARGB(255, 85, 85, 85)
                            : appcolor.textblack,
                  ),
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
                right: Get.width * 0.05,
              ),
              child: TextFormField(
                autocorrect: false,
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty
                            ? 'Shipping Address cannot be blank'
                            : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.shippingaddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Shipping Address",
                  labelText: "Shipping Address",
                  labelStyle: TextStyle(
                    color:
                        myFocusNode.hasFocus
                            ? const Color.fromARGB(255, 85, 85, 85)
                            : appcolor.textblack,
                  ),
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
                right: Get.width * 0.05,
              ),
              child: TextFormField(
                autocorrect: false,
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value!.isEmpty ? 'Postal Code cannot be blank' : null),
                onChanged: (text) {
                  print('text $text');
                },
                keyboardType: TextInputType.number,
                controller: widget.postalcode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Postal Code",
                  labelText: "Postal Code",
                  labelStyle: TextStyle(
                    color:
                        myFocusNode.hasFocus
                            ? const Color.fromARGB(255, 85, 85, 85)
                            : appcolor.textblack,
                  ),
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
                right: Get.width * 0.05,
              ),
              child: TextFormField(
                autocorrect: false,
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: (value) => (value!.length <= 11
                //     ? 'Phone Number exceeds 11 characters'
                //     : null),
                onChanged: (text) {
                  print('text $text');
                },
                controller: widget.phonenumber,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: appcolor.textColor),
                  ),
                  hintText: "Phone Number",
                  labelText: "Phone Number",
                  labelStyle: TextStyle(
                    color:
                        myFocusNode.hasFocus
                            ? const Color.fromARGB(255, 85, 85, 85)
                            : appcolor.textblack,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //       top: Get.height * 0.015, right: Get.width * 0.05),
            //   child: CSCPicker(
            //     showStates: true,
            //
            //     showCities: true,
            //
            //     flagState: CountryFlag.DISABLE,
            //
            //     dropdownDecoration: BoxDecoration(
            //         borderRadius: const BorderRadius.all(Radius.circular(10)),
            //         color: Colors.white,
            //         border: Border.all(color: Colors.grey.shade300, width: 1)),
            //
            //     disabledDropdownDecoration: BoxDecoration(
            //         borderRadius: const BorderRadius.all(Radius.circular(10)),
            //         color: Colors.grey.shade300,
            //         border: Border.all(color: Colors.grey.shade300, width: 1)),
            //
            //     countrySearchPlaceholder: "Country",
            //     stateSearchPlaceholder: "State",
            //     citySearchPlaceholder: "City",
            //
            //     countryDropdownLabel: "Country",
            //     stateDropdownLabel: "State",
            //     cityDropdownLabel: "City",
            //
            //     ///Default Country
            //     // defaultCountry: CscCountry.United_States,
            //
            //     ///Country Filter [OPTIONAL PARAMETER]
            //     countryFilter: const [
            //       // CscCountry.India,
            //       CscCountry.United_States,
            //       // CscCountry.Canada,
            //       // CscCountry.American_Samoa
            //     ],
            //
            //     ///Disable country dropdown (Note: use it with default country)
            //     // disableCountry: true,
            //
            //     ///selected item style [OPTIONAL PARAMETER]
            //     selectedItemStyle: const TextStyle(
            //       color: Colors.black,
            //       fontSize: 14,
            //     ),
            //
            //     ///DropdownDialog Heading style [OPTIONAL PARAMETER]
            //     dropdownHeadingStyle: const TextStyle(
            //         color: Colors.black,
            //         fontSize: 17,
            //         fontWeight: FontWeight.bold),
            //
            //     ///DropdownDialog Item style [OPTIONAL PARAMETER]
            //     dropdownItemStyle: const TextStyle(
            //       color: Colors.black,
            //       fontSize: 14,
            //     ),
            //
            //     ///Dialog box radius [OPTIONAL PARAMETER]
            //     dropdownDialogRadius: 10.0,
            //
            //     ///Search bar radius [OPTIONAL PARAMETER]
            //     searchBarRadius: 10.0,
            //
            //     onCountryChanged: (value) {
            //       setState(() {
            //         countryValue = value;
            //       });
            //     },
            //
            //     onStateChanged: (value) {
            //       setState(() {
            //         stateValue = value ?? "";
            //       });
            //     },
            //     onCityChanged: (value) {
            //       setState(() {
            //         cityValue = value ?? "";
            //       });
            //     },
            //   ),
            // ),

            //  -- BILLLING INFO STARTS HERE --
            Column(
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.05,
                      child: Checkbox(
                        value: checkBoxValue3,
                        onChanged: (bool? value) {
                          setState(() {
                            checkBoxValue3 = value!;
                            log(checkBoxValue3.toString());
                          });
                        },
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                      ),
                    ),
                    Text('Use Same Billing Address'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Delivery Type: ',
                      style: TextStyle(
                        fontSize: heights <= 690 && widths <= 430 ? 11 : 13,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        selectedColor: Color.fromARGB(255, 143, 143, 143),
                        label: Text(
                          'Standard',
                          style: TextStyle(
                            fontSize: heights <= 690 && widths <= 430 ? 10 : 13,
                          ),
                        ),
                        selected: _character == SingingCharacter.standard,
                        onSelected: (bool selected) {
                          setState(() {
                            _character = SingingCharacter.standard;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        selectedColor: Color.fromARGB(255, 143, 143, 143),
                        label: Text(
                          'Schedule',
                          style: TextStyle(
                            fontSize: heights <= 690 && widths <= 430 ? 10 : 13,
                          ),
                        ),
                        selected: _character == SingingCharacter.schedule,
                        onSelected: (bool selected) {
                          setState(() {
                            _character = SingingCharacter.schedule;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        selectedColor: Color.fromARGB(255, 143, 143, 143),
                        label: Text(
                          'Urgent',
                          style: TextStyle(
                            fontSize: heights <= 690 && widths <= 430 ? 10 : 13,
                          ),
                        ),
                        selected: _character == SingingCharacter.urgent,
                        onSelected: (bool selected) {
                          setState(() {
                            _character = SingingCharacter.urgent;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_character == SingingCharacter.schedule)
                  Padding(
                    padding: EdgeInsets.only(
                      top: Get.height * 0.005,
                      right: Get.width * 0.05,
                    ),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          onTap: () async {
                            final DateTime? selectedDate = await showDatePicker(
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
                                sche.text = formattedDate;
                              });
                            }
                          },
                          readOnly: true,
                          controller: sche,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator:
                              (value) =>
                                  (value!.isEmpty
                                      ? 'Schedule Date cannot be blank'
                                      : null),
                          onChanged: (text) {
                            print('text $text');
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: appcolor.textColor,
                              ),
                            ),
                            hintText: "Scheduled Date",
                            labelText: "Scheduled Date",
                            labelStyle: TextStyle(
                              color:
                                  myFocusNode.hasFocus
                                      ? const Color.fromARGB(255, 85, 85, 85)
                                      : appcolor.textblack,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                if (!checkBoxValue3)
                  Column(
                    children: [
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Billing Details ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Get.height * 0.015,
                          right: Get.width * 0.05,
                        ),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator:
                              (value) =>
                                  (value!.isEmpty
                                      ? 'First Name cannot be blank'
                                      : null),
                          onChanged: (text) {
                            print('text $text');
                          },
                          controller: widget.billingfname,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: appcolor.textColor,
                              ),
                            ),
                            hintText: "First Name",
                            labelText: "First Name",
                            labelStyle: TextStyle(
                              color:
                                  myFocusNode.hasFocus
                                      ? const Color.fromARGB(255, 85, 85, 85)
                                      : appcolor.textblack,
                            ),
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
                          right: Get.width * 0.05,
                        ),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator:
                              (value) =>
                                  (value!.isEmpty
                                      ? 'Last Name cannot be blank'
                                      : null),
                          onChanged: (text) {
                            print('text $text');
                          },
                          controller: widget.billinglname,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: appcolor.textColor,
                              ),
                            ),
                            hintText: "Last Name",
                            labelText: "Last Name",
                            labelStyle: TextStyle(
                              color:
                                  myFocusNode.hasFocus
                                      ? const Color.fromARGB(255, 85, 85, 85)
                                      : appcolor.textblack,
                            ),
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
                          right: Get.width * 0.05,
                        ),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator:
                              (value) =>
                                  (value!.isEmpty
                                      ? 'Billing Address cannot be blank'
                                      : null),
                          onChanged: (text) {
                            print('text $text');
                          },
                          controller: widget.billingaddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: appcolor.textColor,
                              ),
                            ),
                            hintText: "Billing Address",
                            labelText: "Billing Address",
                            labelStyle: TextStyle(
                              color:
                                  myFocusNode.hasFocus
                                      ? const Color.fromARGB(255, 85, 85, 85)
                                      : appcolor.textblack,
                            ),
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
                          right: Get.width * 0.05,
                        ),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator:
                              (value) =>
                                  (value!.isEmpty
                                      ? 'Postal Code cannot be blank'
                                      : null),
                          onChanged: (text) {
                            print('text $text');
                          },
                          keyboardType: TextInputType.number,
                          controller: widget.billingpostalcode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: appcolor.textColor,
                              ),
                            ),
                            hintText: "Postal Code",
                            labelText: "Postal Code",
                            labelStyle: TextStyle(
                              color:
                                  myFocusNode.hasFocus
                                      ? const Color.fromARGB(255, 85, 85, 85)
                                      : appcolor.textblack,
                            ),
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
                          right: Get.width * 0.05,
                        ),
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (text) {
                            print('text $text');
                          },
                          controller: widget.billing_phone_number,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: appcolor.textColor,
                              ),
                            ),
                            hintText: "Phone Number",
                            labelText: "Phone Number",
                            labelStyle: TextStyle(
                              color:
                                  myFocusNode.hasFocus
                                      ? const Color.fromARGB(255, 85, 85, 85)
                                      : appcolor.textblack,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       top: Get.height * 0.015, right: Get.width * 0.05),
                      //   child: CSCPicker(
                      //     showStates: true,
                      //
                      //     showCities: true,
                      //
                      //     flagState: CountryFlag.DISABLE,
                      //
                      //     dropdownDecoration: BoxDecoration(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(10)),
                      //         color: Colors.white,
                      //         border: Border.all(
                      //             color: Colors.grey.shade300, width: 1)),
                      //
                      //     disabledDropdownDecoration: BoxDecoration(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(10)),
                      //         color: Colors.grey.shade300,
                      //         border: Border.all(
                      //             color: Colors.grey.shade300, width: 1)),
                      //
                      //     countrySearchPlaceholder: "Country",
                      //     stateSearchPlaceholder: "State",
                      //     citySearchPlaceholder: "City",
                      //
                      //     countryDropdownLabel: "Country",
                      //     stateDropdownLabel: "State",
                      //     cityDropdownLabel: "City",
                      //
                      //     ///Default Country
                      //     // defaultCountry: CscCountry.United_States,
                      //
                      //     ///Country Filter [OPTIONAL PARAMETER]
                      //     countryFilter: const [
                      //       // CscCountry.India,
                      //       CscCountry.United_States,
                      //       // CscCountry.Canada,
                      //       // CscCountry.American_Samoa
                      //     ],
                      //
                      //     ///Disable country dropdown (Note: use it with default country)
                      //     // disableCountry: true,
                      //
                      //     ///selected item style [OPTIONAL PARAMETER]
                      //     selectedItemStyle: const TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 14,
                      //     ),
                      //
                      //     ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      //     dropdownHeadingStyle: const TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.bold),
                      //
                      //     ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      //     dropdownItemStyle: const TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 14,
                      //     ),
                      //
                      //     ///Dialog box radius [OPTIONAL PARAMETER]
                      //     dropdownDialogRadius: 10.0,
                      //
                      //     ///Search bar radius [OPTIONAL PARAMETER]
                      //     searchBarRadius: 10.0,
                      //
                      //     onCountryChanged: (value) {
                      //       setState(() {
                      //         billingcountryValue = value;
                      //       });
                      //     },
                      //
                      //     onStateChanged: (value) {
                      //       setState(() {
                      //         billingstateValue = value ?? "";
                      //       });
                      //     },
                      //     onCityChanged: (value) {
                      //       setState(() {
                      //         billingcityValue = value ?? "";
                      //       });
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, right: 18),
                  child: TextFormField(
                    maxLines: 3,
                    maxLength: 50,

                    onChanged: (text) {
                      print('text $text');
                    },
                    // keyboardType: TextInputType.multiline,
                    controller: widget.note,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      hintText: "Note ",
                      // labelText: "Email",
                      labelText: "Note",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.019),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(initialIndex: 1),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.keyboard_arrow_left),
                      Text(
                        'Return to Cart',
                        style: TextStyle(
                          fontFamily: 'Humanist Sans',
                          color: Color.fromARGB(255, 69, 69, 69),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                    left: Get.width * 0.015,
                    right: Get.width * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Humanist Sans',
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$val',
                        style: TextStyle(
                          color: Color.fromARGB(255, 52, 52, 52),
                          fontFamily: 'Humanist Sans',
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: Get.width * 0.05),
                  child: Divider(color: Color.fromARGB(255, 104, 104, 104)),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(
                    left: Get.width * 0.015,
                    right: Get.width * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Humanist Sans',
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: Get.height * 0.045,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: const [
                              appcolor.textColor,
                              Color.fromARGB(255, 164, 199, 255),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!widget._formKey.currentState!.validate()) {
                              return;
                            }

                            context.loaderOverlay.show();

                            if (checkBoxValue3 == true) {
                              Map<String, dynamic>? responseData =
                                  await CreateOrder.Createneworder(
                                    widget.email.text,
                                    widget.pateintname.text,
                                    stateValue,
                                    // widget.country.text,
                                    widget.firstname.text,
                                    widget.lastname.text,
                                    widget.shippingaddress.text,
                                    widget.shippingaddress.text,
                                    // widget.citypicker.text,
                                    cityValue,
                                    widget.postalcode.text,
                                    widget.phonenumber.text,
                                    val!.toStringAsFixed(0),
                                    true,
                                    widget.firstname.text,
                                    widget.lastname.text,
                                    // widget.citypicker.text,
                                    cityValue,
                                    widget.postalcode.text,
                                    widget.phonenumber.text,
                                    widget.note.text,
                                    context,
                                  );
                              if (responseData != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ShippingInfo(
                                          responseData: responseData,
                                        ),
                                  ),
                                );
                              }
                            } else {
                              Map<String, dynamic>? responseData =
                                  await CreateOrder.Createneworder(
                                    widget.email.text,
                                    widget.pateintname.text,
                                    stateValue,
                                    widget.firstname.text,
                                    widget.lastname.text,
                                    widget.shippingaddress.text,
                                    widget.billingaddress.text,
                                    // widget.citypicker.text,
                                    cityValue,
                                    widget.postalcode.text,
                                    widget.phonenumber.text,
                                    val!.toStringAsFixed(0),
                                    true,
                                    widget.billingfname.text,
                                    widget.billinglname.text,

                                    // widget.billingcity.text,
                                    billingcityValue,
                                    widget.billing_phone_number.text,
                                    widget.billingpostalcode.text,
                                    widget.note.text,
                                    context,
                                  );
                              if (responseData != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ShippingInfo(
                                          responseData: responseData,
                                        ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(fontFamily: 'Humanist Sans'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // A helper method to create a radio button with a label
}
