// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/apis/auth/verifyemail_api.dart';
import '../../../../core/services/app/app_navigator_service.dart';

class Otpscreen extends StatefulWidget {
  const Otpscreen({super.key});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  var heights = Get.height;
  var widths = Get.width;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppNavigatorService.navigateToReplacement(Route_paths.signup);
        return false; // Suppress the default back action
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'OTP Verification',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_outlined,
                      size: 20, color: Colors.black), // Change the color here
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: const <Widget>[],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: heights <= 690 && widths <= 430 ? 20 : 120,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Get.height * 0.05),
                      child: Center(
                          child: Image.asset(
                        AssetConstants.otpscreen,
                        height: 150,
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.02),
                      child: Text(
                        ' Verfication',
                        style: TextStyle(
                            fontFamily: 'Segoe UI',
                            // fontSize: 26,
                            fontSize: heights <= 690 && widths <= 430 ? 20 : 26,
                            letterSpacing: 1,
                            color: appcolor.textColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.02),
                      child: Text(
                        ' Enter your OTP code number',
                        style: TextStyle(
                            fontFamily: 'Segoe UI',
                            // fontSize: 16,
                            fontSize: heights <= 690 && widths <= 430 ? 14 : 16,
                            letterSpacing: 0,
                            color: Color.fromARGB(255, 106, 106, 106),
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    OtpTextField(
                        mainAxisAlignment: MainAxisAlignment.center,
                        numberOfFields: 6,
                        fillColor: Colors.black.withOpacity(0.1),
                        filled: true,
                        keyboardType: TextInputType.number,
                        onSubmit: (code) async {
                          context.loaderOverlay.show(); // Show load
                          await Api_Verifymail.verifymail(
                              code.toString(), context);
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'I didnt received OTP ?',
                            style: TextStyle(
                              fontSize:
                                  heights <= 690 && widths <= 430 ? 11 : 13,
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                String? uid = prefs.getString('uid');

                                if (uid == null) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Something went Wrong! Cant Create Order',
                                      webPosition: 'right',
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor:
                                          const Color.fromARGB(255, 0, 49, 77),
                                      fontSize: 14);
                                  throw Exception(
                                      'Email Key not found in SharedPreferences');
                                }
                                var headers = {
                                  'Content-Type': 'application/json'
                                };
                                var request = http.Request(
                                    'POST',
                                    Uri.parse(
                                        'https://api.newhorizonhm.com/api/resendverificationemail'));
                                request.body = json.encode({"uid": uid});
                                request.headers.addAll(headers);

                                http.StreamedResponse response =
                                    await request.send();

                                if (response.statusCode == 200) {
                                  print(await response.stream.bytesToString());
                                } else {
                                  print(response.reasonPhrase);
                                }
                              },
                              child: Text(
                                '/   Resend',
                                style: TextStyle(
                                  color: appcolor.textColor,
                                  fontSize:
                                      heights <= 690 && widths <= 430 ? 11 : 13,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
