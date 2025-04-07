// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously, unused_field, prefer_final_fields, unused_element, curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/apis/auth/signup_api.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

TextEditingController code = TextEditingController();

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController password = TextEditingController();
  String? apiErrorMessage;

  String? _loginErrorMessage;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = FocusNode();
    return WillPopScope(
      onWillPop: () async {
        AppNavigatorService.navigateToReplacement(Route_paths.splash2);
        return false; // Suppress the default back action
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      AssetConstants.signupbackground,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: Get.height * 0.58,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: Get.height * 0.035),
                            Padding(
                              padding: EdgeInsets.only(left: Get.width * 0.050),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: const [
                                        Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 28,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w600,
                                              color: appcolor.textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Get.height * 0.04,
                                        right: Get.width * 0.05),
                                    child: TextFormField(
                                      autocorrect: false,
                                      autofocus: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) => (value!.isEmpty
                                          ? 'Full Name cannot be blank'
                                          : null),
                                      onChanged: (text) {
                                        print('text $text');
                                      },
                                      controller: firstname,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: appcolor.textColor)),
                                        hintText: "Full Name",
                                        labelText: "Full Name",
                                        labelStyle: TextStyle(
                                            color: myFocusNode.hasFocus
                                                ? const Color.fromARGB(
                                                    255, 85, 85, 85)
                                                : Color.fromARGB(
                                                    255, 26, 26, 26)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Get.height * 0.015,
                                        right: Get.width * 0.05),
                                    child: TextFormField(
                                      autocorrect: false,
                                      autofocus: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return 'Enter Valid Email';

                                        if (apiErrorMessage != null) {
                                          return apiErrorMessage;
                                        }

                                        if (!RegExp(
                                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                            .hasMatch(value)) {
                                          return 'Email Not Valid';
                                        }

                                        return null;
                                      },
                                      onChanged: (text) {
                                        setState(() {
                                          apiErrorMessage = null;
                                        });
                                        print('text $text');
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      controller: email,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 125, 125, 125))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: appcolor.textColor)),
                                        hintText: "Email",
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: apiErrorMessage != null
                                                ? Colors.red
                                                : (myFocusNode.hasFocus
                                                    ? const Color.fromARGB(
                                                        255, 85, 85, 85)
                                                    : Color.fromARGB(
                                                        255, 26, 26, 26))),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Get.height * 0.015,
                                        right: Get.width * 0.05),
                                    child: TextFormField(
                                      autocorrect: false,
                                      autofocus: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) => (value!.length <= 2
                                          ? 'Company should exceed 2 characters'
                                          : null),
                                      onChanged: (text) {
                                        setState(() {
                                          apiErrorMessage = null;
                                        });
                                        print('text $text');
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      controller: company,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 125, 125, 125))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: appcolor.textColor)),
                                        hintText: "Company Name",
                                        labelText: "Company Name",
                                        labelStyle: TextStyle(
                                            color: apiErrorMessage != null
                                                ? Colors.red
                                                : (myFocusNode.hasFocus
                                                    ? const Color.fromARGB(
                                                        255, 85, 85, 85)
                                                    : Color.fromARGB(
                                                        255, 26, 26, 26))),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Get.height * 0.015,
                                        right: Get.width * 0.05),
                                    child: TextFormField(
                                      autocorrect: false,
                                      autofocus: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) => (value!.length <= 6
                                          ? 'Password should exceed 6 characters'
                                          : null),
                                      onChanged: (text) {
                                        print('text $text');
                                      },
                                      controller: password,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 126, 126, 126))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: appcolor.textColor)),
                                        hintText: "Password",
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: myFocusNode.hasFocus
                                                ? const Color.fromARGB(
                                                    255, 85, 85, 85)
                                                : Color.fromARGB(
                                                    255, 26, 26, 26)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Get.height * 0.055,
                                        right: Get.width * 0.05),
                                    child: SizedBox(
                                      width: double
                                          .infinity, // to make the button take the full available width
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            return;
                                          }
                                          // Check password length
                                          if (password.text.length < 6) {
                                            setState(() {
                                              _loginErrorMessage =
                                                  "Password should exceed 6 characters";
                                            });
                                            return;
                                          }

                                          context.loaderOverlay.show();

                                          try {
                                            await Api_signup.signupapicall(
                                                firstname.text,
                                                email.text,
                                                password.text,
                                                company.text,
                                                context);
                                            _loginErrorMessage = null;
                                            apiErrorMessage = null;
                                          } catch (error) {
                                            print("API Error: $error");
                                            String errorMessage;
                                            if (error is Exception) {
                                              errorMessage = error
                                                  .toString()
                                                  .split('Exception: ')[1];
                                            } else {
                                              errorMessage = error.toString();
                                            }

                                            if (errorMessage ==
                                                "YOUR_ACCOUNT_ALREADY_EXISTS_AND_IS_VERIFIED_ALREADY_PLEASE_SIGN_IN_TO_CONTINUE") {
                                              apiErrorMessage =
                                                  "Email Already Exists";
                                            } else if (errorMessage ==
                                                "YOUR_ACCOUNT_ALREADY_EXISTS_BUT_IT_IS_NOT_VERIFIED_WE_HAVE_SENT_YOU_ANOTHER_EMAIL_PLEASE_VERIFIY_YOUR_ACCOUNT") {
                                              apiErrorMessage =
                                                  "Email Verification Failed";
                                            } else if (errorMessage ==
                                                "INVALID_EMAIL") {
                                              apiErrorMessage =
                                                  "Enter Valid Email";
                                            } else {
                                              apiErrorMessage = errorMessage;
                                            }
                                          } finally {
                                            context.loaderOverlay.hide();
                                            setState(
                                                () {}); // This will trigger the rebuild
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  appcolor.textColor),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 20)),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                        ),
                                        child: const Text(
                                          'Create Account',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Already Have an Account?'),
                                        TextButton(
                                            onPressed: () {
                                              AppNavigatorService.pushNamed(
                                                  Route_paths.signin);
                                            },
                                            child: const Text(
                                              '/   Login',
                                              style: TextStyle(
                                                  color: appcolor.textColor),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
}
