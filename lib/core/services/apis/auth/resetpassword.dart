// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import '../api_call_type/post_api_call.dart';

class resetpassword {
  static Future resetpass(code, email, pass, BuildContext context) async {
    var resetpassworddata = {"otp": code, "email": email, "password": pass};

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.resetpass);
    final response =
        await apiClient.post(Api_Constants.resetpass, resetpassworddata);

    if (response.statusCode == 200) {
      context.loaderOverlay.hide();
      AppNavigatorService.navigateToReplacement(Route_paths.signin);
      return true;
    } else if (response.statusCode == 400) {
      AppNavigatorService.navigateToReplacement(Route_paths.forgetpassword);
      Fluttertoast.showToast(
          msg: 'Invalid Code! Try Again',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 13);
      context.loaderOverlay.hide();
      return false;
    } else {
      AppNavigatorService.navigateToReplacement(Route_paths.forgetpassword);
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Try Again',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 13);
      context.loaderOverlay.hide();
      return false;
    }
  }
}
