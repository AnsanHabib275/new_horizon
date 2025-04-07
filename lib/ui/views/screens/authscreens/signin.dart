// ignore_for_file: avoid_print, use_build_context_synchronously, unused_field, prefer_final_fields, unnecessary_new, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/apis/auth/loginin_api.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/core/services/userpreferences/userpreference.dart';
import 'package:new_horizon/ui/utils/colors.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isEmailValid = true;
  bool _isPasswordValid = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isHidden = true;
  bool _isChecked = false;
  String? _loginErrorMessage;

  bool _isLoaderVisible = false;
  bool? _isLoginSuccessful;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  FocusNode myFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide the keyboard
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(AssetConstants.loginbackground),
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
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: Get.height * 0.05),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Get.width * 0.045,
                            right: Get.width * 0.045,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: const [
                                    Text(
                                      'Login',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 28,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: appcolor.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AutofillGroup(
                                child: Column(
                                  children: [
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: Get.height * 0.04,
                                            ),
                                            child: TextFormField(
                                              autocorrect: false,
                                              autofocus: false,
                                              enableSuggestions: true,
                                              autovalidateMode:
                                                  AutovalidateMode
                                                      .onUserInteraction,
                                              validator: (value) {
                                                if (_loginErrorMessage !=
                                                    null) {
                                                  return _loginErrorMessage;
                                                }
                                                return (value!.isEmpty ||
                                                        !RegExp(
                                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                                        ).hasMatch(value)
                                                    ? 'Email not Valid'
                                                    : null);
                                              },
                                              onChanged: (text) {
                                                setState(() {
                                                  _loginErrorMessage = null;
                                                });
                                                print('text $text');
                                              },
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              autofillHints: const [
                                                AutofillHints.email,
                                              ],
                                              controller: email,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      borderSide:
                                                          const BorderSide(
                                                            color:
                                                                appcolor
                                                                    .textColor,
                                                          ),
                                                    ),
                                                hintText: "Email",
                                                labelText: "Email",
                                                labelStyle: TextStyle(
                                                  color:
                                                      _loginErrorMessage != null
                                                          ? Colors.red
                                                          : (myFocusNode
                                                                  .hasFocus
                                                              ? const Color.fromARGB(
                                                                255,
                                                                85,
                                                                85,
                                                                85,
                                                              )
                                                              : Color.fromARGB(
                                                                255,
                                                                26,
                                                                26,
                                                                26,
                                                              )),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: Get.height * 0.015,
                                            ),
                                            child: TextFormField(
                                              autocorrect: false,
                                              autofocus: false,
                                              enableSuggestions: true,
                                              autovalidateMode:
                                                  AutovalidateMode
                                                      .onUserInteraction,
                                              validator: (value) {
                                                if (_loginErrorMessage !=
                                                    null) {
                                                  return _loginErrorMessage;
                                                }
                                                return (value!.length <= 6
                                                    ? 'Password format Invalid'
                                                    : null);
                                              },
                                              onChanged: (text) {
                                                setState(() {
                                                  _loginErrorMessage = null;
                                                });
                                                print('text $text');
                                              },
                                              controller: password,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              autofillHints: const [
                                                AutofillHints.newPassword,
                                              ],
                                              onEditingComplete:
                                                  () =>
                                                      TextInput.finishAutofillContext(),
                                              obscureText: _isHidden,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      borderSide:
                                                          const BorderSide(
                                                            color:
                                                                appcolor
                                                                    .textColor,
                                                          ),
                                                    ),
                                                hintText: "Password",
                                                labelText: "Password",
                                                labelStyle: TextStyle(
                                                  color:
                                                      _loginErrorMessage != null
                                                          ? Colors.red
                                                          : (myFocusNode
                                                                  .hasFocus
                                                              ? const Color.fromARGB(
                                                                255,
                                                                85,
                                                                85,
                                                                85,
                                                              )
                                                              : Color.fromARGB(
                                                                255,
                                                                26,
                                                                26,
                                                                26,
                                                              )),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20,
                                                    ),
                                                suffixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        0,
                                                        0,
                                                        4,
                                                        0,
                                                      ),
                                                  child: GestureDetector(
                                                    onTap: _togglePasswordView,
                                                    child: Icon(
                                                      _isHidden
                                                          ? Icons
                                                              .visibility_rounded
                                                          : Icons
                                                              .visibility_off_rounded,
                                                      size: 24,
                                                      color: appcolor.textColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _isChecked,
                                        onChanged: (value) async {
                                          setState(() {
                                            _isChecked = value!;
                                            print(value);
                                          });
                                        },
                                      ),
                                      const Text(
                                        "Remember me",
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                          color: appcolor.textColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AppNavigatorService.navigateToReplacement(
                                        Route_paths.forgetpassword,
                                      );
                                      print("Forgot Password?");
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        color: appcolor.textColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: Get.height * 0.075,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }
                                      context.loaderOverlay.show();
                                      _isLoginSuccessful =
                                          await Api_Login.loginapicall(
                                            email.text,
                                            password.text,
                                            context,
                                          );

                                      if (!_isLoginSuccessful!) {
                                        _loginErrorMessage =
                                            'invalid_credentials'.tr;
                                      } else {
                                        _loginErrorMessage = null;

                                        if (_isChecked) {
                                          // Validate email format using RegExp
                                          RegExp emailRegex = RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                          );
                                          if (emailRegex.hasMatch(email.text)) {
                                            await UserPreferences()
                                                .saveCredentials(
                                                  email.text,
                                                  password.text,
                                                  true,
                                                );
                                          } else {
                                            MotionToast(
                                              primaryColor: Color.fromARGB(
                                                255,
                                                252,
                                                94,
                                                83,
                                              ),
                                              icon: Icons.zoom_out,
                                              title: Text("Missing Info."),
                                              description: Text(
                                                "You need to Enter Valid Mail First",
                                              ),
                                              position: MotionToastPosition.top,
                                              animationType:
                                                  AnimationType.slideInFromLeft,
                                            ).show(context);
                                            setState(() {
                                              _isChecked =
                                                  false; // Uncheck the checkbox due to invalid format
                                            });
                                          }
                                        }
                                      }

                                      setState(() {});
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                            appcolor.textColor,
                                          ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 20,
                                        ),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Login',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Create a new Account?',
                                    textScaleFactor: 1,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      AppNavigatorService.pushNamed(
                                        Route_paths.signup,
                                      );
                                    },
                                    child: const Text(
                                      '/   Register',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        color: appcolor.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
