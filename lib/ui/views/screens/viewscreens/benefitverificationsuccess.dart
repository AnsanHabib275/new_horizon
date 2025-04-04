// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';

class Successcreen extends StatefulWidget {
  const Successcreen({super.key});

  @override
  State<Successcreen> createState() => _SuccesscreenState();
}

class _SuccesscreenState extends State<Successcreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  var heights = Get.height;
  var widths = Get.width;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/success.json',
                  repeat: false,
                  controller: controller,
                  height: 300, onLoaded: (composition) {
                controller!.forward();
              }),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Your Details have been Submitted",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      // fontSize: 20,
                      fontSize: heights <= 690 && widths <= 430 ? 16 : 20,
                      fontWeight: FontWeight.bold),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.09,
                    right: Get.width * 0.05,
                    left: Get.width * 0.042),
                child: SizedBox(
                  width: double
                      .infinity, // to make the button take the full available width
                  child: ElevatedButton(
                    onPressed: () {
                      AppNavigatorService.navigateToReplacement(
                          Route_paths.home);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(appcolor.textColor),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // Text(
              //     "       Your account has been created \n           You Can Now Login")
            ],
          ),
        )),
      ),
    );
  }
}
