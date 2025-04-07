// ignore_for_file: camel_case_types, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/ui/views/screens/authscreens/reset_password.dart';
import '../api_call_type/post_api_call.dart';

class forgetpassword {
  static Future forgetpass(email, BuildContext context) async {
    var forgetpassworddata = {
      "email": email,
    };

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.forgetpass);
    final response =
        await apiClient.post(Api_Constants.forgetpass, forgetpassworddata);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Resetpassword(email: email),
        ),
      );
      context.loaderOverlay.hide();
      return true;
    } else {
      context.loaderOverlay.hide();
      return false;
    }
  }
}
