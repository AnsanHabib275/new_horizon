// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/models/verifiedpatients.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/HomeScreen.dart';
import 'package:new_horizon/ui/widgets/peronalinfoform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformation extends StatefulWidget {
  final double totalprice;
  final List<VerifiedPatient> verifiedPatients;
  const PersonalInformation(
      {Key? key, required this.totalprice, required this.verifiedPatients})
      : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

String? username;
String? doctorcompany;

class _PersonalInformationState extends State<PersonalInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController shipaddress = TextEditingController();
  TextEditingController billaddress = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController postal = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController billfrstname = TextEditingController();
  TextEditingController billlstname = TextEditingController();
  TextEditingController billcty = TextEditingController();
  TextEditingController billpstcode = TextEditingController();
  TextEditingController billphnmber = TextEditingController();
  TextEditingController patientname = TextEditingController();
  TextEditingController usernote = TextEditingController();

  Future<void> getusername() async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedName = prefs.getString('name');

    String? company = prefs.getString('company');
    setState(() {
      username = fetchedName;
      doctorcompany = company;
    });
  }

  num? val;
  @override
  void initState() {
    super.initState();
    getusername();

    setState(() {
      val = widget.totalprice;
      log(val.toString());
    });
    for (VerifiedPatient patient in widget.verifiedPatients) {
      log('Name: ${patient.name}, Policy Number: ${patient.policyNumber}');
    }
  }

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: appcolor.textWhite,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined,
                    size: 20, color: Colors.black), // Change the color here
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(initialIndex: 1)));
                },
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(Get.height * 0.01),
                  child: Row(
                    children: [
                      Text(
                        "$username",
                        style: const TextStyle(
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '  Cart  ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Segoe UI',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.blue, width: 2.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '  Personal Information  ',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: appcolor.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('  Shipping',
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 14,
                                  color: Colors.grey)),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left: Get.width * 0.04),
                        child: PersonalInforForm(
                          formKey: _formKey,
                          emailController: email,
                          countryController: country,
                          firstnameController: firstname,
                          lastnameController: lastname,
                          shippingController: shipaddress,
                          billingController: billaddress,
                          cityController: city,
                          postalController: postal,
                          phoneController: number,
                          totalprice: val!,
                          notecontroller: usernote,
                          billingfnmController: billfrstname,
                          billinglnmController: billlstname,
                          billingcityController: billcty,
                          billingpostalcodeController: billpstcode,
                          billingbphnnumController: billphnmber,
                          verifiedPatients: widget.verifiedPatients,
                          pateintname: patientname,
                          company: doctorcompany!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
