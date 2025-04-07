// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/services/apis/auth/forgetpassword.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _ForgetpasswordState extends State<Forgetpassword> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;
  void resetForm() {
    _errorMessage = null;
    formKey.currentState!.reset();
  }

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
              AppNavigatorService.pop();
            },
            child: Icon(Icons.arrow_back_ios_new_outlined,
                size: 20, color: Colors.black),
          ),
          title: const Text(
            'Forget Password',
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Humanist sans',
              fontWeight: FontWeight.normal,
            ),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.05, top: 45),
                child: Center(
                  child: SvgPicture.asset(
                    AssetConstants.forgetpass,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    autocorrect: false,
                    autofocus: false,
                    enableSuggestions: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      if (_errorMessage != null) {
                        return _errorMessage;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: appcolor.textColor),
                      ),
                      hintText: "Email",
                      labelText: "Email",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 38),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(appcolor.textColor),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 15)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _errorMessage = null;
                    });

                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    context.loaderOverlay.show();
                    String email = _emailController.text;
                    print(email);
                    bool isSuccess =
                        await forgetpassword.forgetpass(email, context);

                    if (!isSuccess) {
                      setState(() {
                        _errorMessage = "Email Account Not Found";
                        formKey.currentState!.validate();
                      });
                    }
                  },
                  child: Text('Send OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
