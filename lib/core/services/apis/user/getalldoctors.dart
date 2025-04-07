// ignore_for_file: avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/Alldoctors.dart';
import '../api_call_type/get_api_call.dart';

class GetAllDoctorsException implements Exception {
  final String message;
  final int? code;

  GetAllDoctorsException({required this.message, this.code});
}

class GetAllDoctors {
  static Future<List<AllDoctors>> GetDoctors(BuildContext context) async {
    GetApiClient apiClient = GetApiClient(Url: Api_Constants.getalldoctors);
    final response = await apiClient.get(Api_Constants.getalldoctors);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Decode the JSON response into a Map
      final Map<String, dynamic> responseJson = json.decode(response.body);

      List<AllDoctors> doctors = [];
      // Iterate over each key-value pair in the map
      // responseJson.forEach((state, clinics) {
      //   // Make sure the value is a list before trying to parse it
      //   if (clinics is List) {
      //     // Add all doctors from this state to the list, including the state name in each item
      //     doctors.addAll(clinics
      //         .map((json) => AllDoctors.fromJson(json..['state'] = state))
      //         .toList());
      //   }
      responseJson.forEach((state, clinics) {
        if (clinics is List) {
          doctors.addAll(
            clinics
                .map(
                  (clinicJson) =>
                      AllDoctors.fromJson({...clinicJson, 'state': state}),
                )
                .toList(),
          );
        }
      });

      // });
      return doctors;
    } else if (response.statusCode == 400) {
      context.loaderOverlay.hide();
      MotionToast(
        primaryColor: const Color.fromARGB(255, 248, 77, 65),
        icon: Icons.zoom_out,
        title: const Text("No Doctors."),
        description: const Text("Add Doctors to Proceed"),
        position: MotionToastPosition.top,
        animationType: AnimationType.slideInFromLeft,
      ).show(context);
      throw GetAllDoctorsException(
        message: 'Doctors required before proceeding',
        code: response.statusCode,
      );
    } else {
      context.loaderOverlay.hide();
      MotionToast(
        primaryColor: const Color.fromARGB(255, 248, 77, 65),
        icon: Icons.zoom_out,
        title: const Text("No Doctors."),
        description: const Text("Add Doctors to Proceed"),
        position: MotionToastPosition.top,
        animationType: AnimationType.slideInFromLeft,
      ).show(context);
      throw GetAllDoctorsException(
        message: 'Failed to load Doctors Data',
        code: response.statusCode,
      );
    }
  }
}
