// ignore_for_file: avoid_print, deprecated_member_use, unused_import, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/apis/auth/resetpassword.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';

import 'package:otp_text_field/otp_text_field.dart';

class Resetpassword extends StatefulWidget {
  final String email;
  const Resetpassword({super.key, required this.email});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _ResetpasswordState extends State<Resetpassword> {
  @override
  void initState() {
    super.initState();
    log(widget.email);
  }

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              AppNavigatorService.navigateToReplacement(Route_paths.signin);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined,
                size: 20, color: Colors.black),
          ),
          title: const Text(
            'Reset Password',
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Humanist sans',
              fontWeight: FontWeight.normal,
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: Get.height * 0.05, top: 35),
                  child: Center(
                    child: SvgPicture.asset(
                      AssetConstants.forgetpass,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          enableSuggestions: true,
                          maxLength: 6,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Enter valid reset code';
                            }
                            if (_errorMessage != null) {
                              return _errorMessage;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          controller: _codeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: appcolor.textColor),
                            ),
                            hintText: "Reset Code",
                            labelText: "Reset Code",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          enableSuggestions: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password Format Invalid';
                            }
                            if (_errorMessage != null) {
                              return _errorMessage;
                            }
                            return null;
                          },
                          controller: _passController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: appcolor.textColor),
                            ),
                            hintText: "Password",
                            labelText: "Password",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 38),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        context.loaderOverlay.show();
                        resetpassword.resetpass(_codeController.text,
                            widget.email, _passController.text, context);
                      },
                      child: const Text('Reset Password')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
