// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/apis/auth/loginin_api.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/core/services/userpreferences/userpreference.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1, microseconds: 30),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 0), () {
      checkpagetoload();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkpagetoload() async {
    String? savedEmail = await UserPreferences().getEmail();
    String? savedPassword = await UserPreferences().getPassword();
    bool rememberMe = await UserPreferences().getRememberMe();
    bool isLoginTimedOut = false; // New variable to track login timeout

    // Start a 3-second timer
    // Future.delayed(const Duration(seconds: 12), () {
    //   if (!isLoginTimedOut) {
    //     isLoginTimedOut = true;
    //     AppNavigatorService.navigateToReplacement(Route_paths.splash2);
    //     Get.snackbar(
    //       "Login Failed",
    //       "Please Check Your Internet Connection!",
    //       icon: const Icon(Icons.info_outlined, color: Colors.white),
    //       snackPosition: SnackPosition.TOP,
    //       backgroundColor: Colors.red,
    //       borderRadius: 20,
    //       margin: const EdgeInsets.all(15),
    //       colorText: Colors.white,
    //       duration: const Duration(seconds: 3),
    //       isDismissible: true,
    //       forwardAnimationCurve: Curves.easeOutBack,
    //     );
    //   }
    // });

    if (rememberMe && savedEmail != null && savedPassword != null) {
      bool loginSuccess = await Api_Login_main.loginapicallmain(
        savedEmail,
        savedPassword,
      );

      if (loginSuccess && !isLoginTimedOut) {
        isLoginTimedOut = true;
        AppNavigatorService.navigateToReplacement(Route_paths.home);
      }
    } else if (!isLoginTimedOut) {
      Future.delayed(const Duration(seconds: 3), () {
        AppNavigatorService.navigateToReplacement(Route_paths.splash2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AssetConstants.splashbackground),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.25),
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _animation,
                    child: Container(
                      height: Get.height * 0.20,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AssetConstants.new_horizonlogo),
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
    );
  }
}
