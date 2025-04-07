// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';

class Splash2 extends StatefulWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  AssetConstants.splash2bg,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Get.height * 0.405,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.035),
                          child: const Text(
                            "  Your Personal Medical\nAssistant Welcomes You!",
                            textScaleFactor: 1,
                            style: TextStyle(
                              color: appcolor.textColor,
                              fontSize: 20,
                              wordSpacing: 2,
                              letterSpacing: 1,
                              fontFamily: 'Humanist sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Get.width * 0.08,
                            right: Get.width * 0.08,
                            top: Get.height * 0.015),
                        child: const Text(
                          "Lorem ipsum dolor sit amet consectetur. Morbi errwf e lorem inter er,  errwf fermentum nunc naon vitae lorem inter er, rheoncus. Faucibus egestas amet blandit vopat!",
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: Color.fromARGB(255, 80, 80, 80),
                            fontSize: 14,
                            wordSpacing: 1.5,
                            fontFamily: 'Humanist sanss',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.045),
                        child: GestureDetector(
                          onTap: () {
                            AppNavigatorService.navigateToReplacement(
                                Route_paths.signup);
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color.fromARGB(255, 2, 104, 163),
                                    Color(0xFF6FBBF5)
                                  ]),
                                  borderRadius: BorderRadius.circular(7.0)),
                              child: TextButton(
                                onPressed: () {
                                  AppNavigatorService.navigateToReplacement(
                                      Route_paths.signup);
                                },
                                child: const Text(
                                  'Try It Now',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'Humanist Sans  '),
                                ),
                              )),
                        ),
                      ),
                      // const Spacer(),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already Have an Account?',
                                textScaleFactor: 1,
                              ),
                              TextButton(
                                  onPressed: () {
                                    AppNavigatorService.pushNamed(
                                        Route_paths.signin);
                                  },
                                  child: const Text(
                                    '/   Login',
                                    textScaleFactor: 1,
                                    style: TextStyle(color: appcolor.textColor),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
