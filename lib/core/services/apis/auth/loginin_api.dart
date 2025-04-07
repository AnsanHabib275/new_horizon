// ignore_for_file: camel_case_types, unused_import, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:new_horizon/core/services/apis/user/registerfcmtokenapi.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/core/services/userpreferences/notification_services.dart';
import 'package:new_horizon/ui/utils/logcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api_Login {
  //   static Future<bool> loginapicall(
  //       email, password, BuildContext context) async {
  //     NotificationServices notificationServices = NotificationServices();
  //     var loginuserdata = {"password": password, "email": email};
  //     PostApiClient apiClient = PostApiClient(Url: Api_Constants.loginurl);
  //     final response =
  //         await apiClient.post(Api_Constants.loginurl, loginuserdata).timeout(const Duration(seconds: 13));
  //     final jsonResponse = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       ansiColorDisabled = false;
  //       debugPrint(success(jsonResponse.toString()));
  //       if (jsonResponse['Response'] == "Login Successful") {
  //         final prefs = await SharedPreferences.getInstance();
  //         prefs.setString('email', jsonResponse['email']);
  //         prefs.setString('name', jsonResponse['full_name']);
  //         prefs.setString('Api_key', jsonResponse['Api_key']);
  //         prefs.setString('uid', jsonResponse['uid']);
  //         prefs.setString('company', jsonResponse['company'] ?? '---');
  //         AppNavigatorService.navigateToAndRemoveAll(Route_paths.home);
  //         context.loaderOverlay.hide();
  //         notificationServices
  //             .getDeviceToken()
  //             .then((value) => RegisterFcmToken.Registerfcmtoken(value));
  //         return true;
  //       }
  //       context.loaderOverlay.hide();
  //       return false;
  //     } else if (response.statusCode == 400 &&
  //         jsonResponse['error_message'] ==
  //             'ACCOUNT_VERIFICATION_IS_PENDING_BY_ADMINISTRATOR') {
  //       context.loaderOverlay.hide();
  //       Get.snackbar(
  //         "Login Failed",
  //         "Account Verification is Pending by Admin",
  //         icon: const Icon(Icons.info_outlined, color: Colors.white),
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red,
  //         borderRadius: 20,
  //         margin: const EdgeInsets.all(15),
  //         colorText: Colors.white,
  //         duration: const Duration(seconds: 3),
  //         isDismissible: true,
  //         forwardAnimationCurve: Curves.easeOutBack,
  //       );
  //       return true;
  //     } else {
  //       context.loaderOverlay.hide();
  //       return false;
  //     }
  //   }

  static Future<bool> loginapicall(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      NotificationServices notificationServices = NotificationServices();
      var loginuserdata = {"password": password, "email": email};

      PostApiClient apiClient = PostApiClient(Url: Api_Constants.loginurl);
      final response = await apiClient
          .post(Api_Constants.loginurl, loginuserdata)
          .timeout(const Duration(seconds: 12));

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        debugPrint(success(jsonResponse.toString()));

        if (jsonResponse['Response'] == "Login Successful") {
          final prefs = await SharedPreferences.getInstance();

          if (jsonResponse['Api_key'] == null || jsonResponse['uid'] == null) {
            context.loaderOverlay.hide();
            Get.snackbar(
              "Login Failed",
              "We are trying to resolve the issue at our end.",
              icon: const Icon(Icons.info_outlined, color: Colors.white),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              borderRadius: 20,
              margin: const EdgeInsets.all(15),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              isDismissible: true,
              forwardAnimationCurve: Curves.easeOutBack,
            );
            return false;
          }

          prefs.setString('email', jsonResponse['email'] ?? '---');
          prefs.setString('name', jsonResponse['full_name'] ?? '---');
          prefs.setString('Api_key', jsonResponse['Api_key']);
          prefs.setString('uid', jsonResponse['uid']);
          prefs.setString('company', jsonResponse['company'] ?? '---');
          AppNavigatorService.navigateToAndRemoveAll(Route_paths.home);
          notificationServices.getDeviceToken().then(
            (value) => RegisterFcmToken.Registerfcmtoken(value),
          );

          return true;
        }
      } else if (response.statusCode == 400 &&
          jsonResponse['error_message'] ==
              'ACCOUNT_VERIFICATION_IS_PENDING_BY_ADMINISTRATOR') {
        context.loaderOverlay.hide();
        Get.snackbar(
          "Login Failed",
          "Account Verification is Pending by Admin",
          icon: const Icon(Icons.info_outlined, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );

        return false;
      }
    } on TimeoutException catch (_) {
      print('We are trying to solve this issue on our end');
      return false;
    } catch (e) {
      print('An error occurred: $e');
      return false;
    } finally {
      context.loaderOverlay.hide();
    }

    return false;
  }
}

class Api_Login_main {
  static Future<bool> loginapicallmain(email, password) async {
    // NotificationServices notificationServices = NotificationServices();
    // var loginuserdata = {"password": password, "email": email};
    // PostApiClient apiClient = PostApiClient(Url: Api_Constants.loginurl);
    // final response =
    //     await apiClient.post(Api_Constants.loginurl, loginuserdata);
    // if (response.statusCode == 200) {
    //   final jsonResponse = json.decode(response.body);
    //   ansiColorDisabled = false;
    //   debugPrint(success(jsonResponse.toString()));
    //   if (jsonResponse['Response'] == "Login Successful") {
    //     final prefs = await SharedPreferences.getInstance();
    //     prefs.setString('email', jsonResponse['email']);
    //     prefs.setString('name', jsonResponse['full_name']);
    //     prefs.setString('Api_key', jsonResponse['Api_key']);
    //     prefs.setString('uid', jsonResponse['uid']);
    //     prefs.setString('company', jsonResponse['company']);
    //     notificationServices
    //         .getDeviceToken()
    //         .then((value) => RegisterFcmToken.Registerfcmtoken(value));
    //     return true;
    //   }
    //   // context.loaderOverlay.hide();
    //   return false;
    // } else {
    //   // context.loaderOverlay.hide();
    //   return false;
    // }
    try {
      NotificationServices notificationServices = NotificationServices();
      var loginuserdata = {"password": password, "email": email};

      PostApiClient apiClient = PostApiClient(Url: Api_Constants.loginurl);
      final response = await apiClient
          .post(Api_Constants.loginurl, loginuserdata)
          .timeout(const Duration(seconds: 12));

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        debugPrint(success(jsonResponse.toString()));

        if (jsonResponse['Response'] == "Login Successful") {
          final prefs = await SharedPreferences.getInstance();

          if (jsonResponse['Api_key'] == null || jsonResponse['uid'] == null) {
            // context.loaderOverlay.hide();
            Get.snackbar(
              "Login Failed",
              "We are trying to resolve the issue at our end.",
              icon: const Icon(Icons.info_outlined, color: Colors.white),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              borderRadius: 20,
              margin: const EdgeInsets.all(15),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              isDismissible: true,
              forwardAnimationCurve: Curves.easeOutBack,
            );
            return false;
          }

          prefs.setString('email', jsonResponse['email'] ?? '---');
          prefs.setString('name', jsonResponse['full_name'] ?? '---');
          prefs.setString('Api_key', jsonResponse['Api_key']);
          prefs.setString('uid', jsonResponse['uid']);
          prefs.setString('company', jsonResponse['company'] ?? '---');
          AppNavigatorService.navigateToAndRemoveAll(Route_paths.home);
          notificationServices.getDeviceToken().then(
            (value) => RegisterFcmToken.Registerfcmtoken(value),
          );

          return true;
        }
      } else if (response.statusCode == 400 &&
          jsonResponse['error_message'] ==
              'ACCOUNT_VERIFICATION_IS_PENDING_BY_ADMINISTRATOR') {
        // context.loaderOverlay.hide();
        Get.snackbar(
          "Login Failed",
          "Account Verification is Pending by Admin",
          icon: const Icon(Icons.info_outlined, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );

        return false;
      }
    } on TimeoutException catch (_) {
      print('We are trying to solve this issue on our end');
      return false;
    } catch (e) {
      print('An error occurred: $e');
      Future.delayed(const Duration(seconds: 7), () {
        AppNavigatorService.navigateToReplacement(Route_paths.splash2);
      });

      return false;
    } finally {}
    return false;
  }
}
