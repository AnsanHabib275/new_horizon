// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print, deprecated_member_use, non_constant_identifier_names, must_be_immutable

import 'package:dashed_rect/dashed_rect.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/claimuserdoc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimFileUpload extends StatefulWidget {
  String order_id;
  ClaimFileUpload({super.key, required this.order_id});

  @override
  State<ClaimFileUpload> createState() => _ClaimFileUploadState();
}

class _ClaimFileUploadState extends State<ClaimFileUpload> {
  String? selectedFileName;
  bool isFilePicked = false;
  String? filepath = '';
  Future<void> pickAndUploadPDF(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        filepath = file.path;
      });
      print(filepath.toString());

      String fileName = file.name;
      String displayFileName =
          fileName.length <= 10
              ? fileName
              : fileName.substring(fileName.length - 10);

      setState(() {
        selectedFileName = 'DOC_$displayFileName';
        isFilePicked = true;
      });
    } else {
      setState(() {
        selectedFileName = '';
        filepath = '';
        isFilePicked = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No File Selected'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Claim File Upload',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.015,
                right: Get.width * 0.04,
                left: Get.width * 0.04,
              ),
              child: Container(
                decoration: const BoxDecoration(shape: BoxShape.rectangle),
                height: Get.height * 0.3,
                width: Get.width,
                child: GestureDetector(
                  onTap: () {
                    pickAndUploadPDF(context);
                  },
                  child:
                      isFilePicked
                          ? DashedRect(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 50.0,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    selectedFileName ?? 'No file selected',
                                    style: TextStyle(
                                      color: appcolor.textColor,
                                      fontFamily: 'Humanist Sans',
                                      fontSize: 19,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          )
                          : DashedRect(
                            color: Colors.grey,
                            strokeWidth: 2.0,
                            gap: 3.0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload,
                                    size: 50,
                                    color: appcolor.textColor,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Attach File Here',
                                    style: TextStyle(
                                      color: appcolor.textColor,
                                      fontFamily: 'Humanist Sans',
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.04,
                right: Get.width * 0.04,
                top: Get.height * 0.22,
              ),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () async {
                    if (filepath == '') {
                      MotionToast(
                        primaryColor: Color.fromARGB(255, 248, 77, 65),
                        icon: Icons.zoom_out,
                        title: Text("File Not Found!"),
                        description: Text("Please Select File.."),
                        position: MotionToastPosition.top,
                        animationType: AnimationType.slideInFromLeft,
                      ).show(context);
                      return;
                    }
                    context.loaderOverlay.show();
                    submitdata(filepath.toString(), widget.order_id, context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(Get.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Upload Document',
                    textScaleFactor: 1,
                    style: TextStyle(fontFamily: "Segoe UI", fontSize: 18),
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

Future<void> submitdata(
  String filepath,
  String order_id,
  BuildContext context,
) async {
  final prefs = await SharedPreferences.getInstance();
  String? apiKey = prefs.getString('Api_key');
  String? uid = prefs.getString('uid');

  if (apiKey == null) {
    Fluttertoast.showToast(
      msg: 'API Key not found! Cannot submit data.',
      webPosition: 'right',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color.fromARGB(255, 0, 49, 77),
      fontSize: 14,
    );
    return;
  }

  if (uid == null) {
    Fluttertoast.showToast(
      msg: 'User ID not found! Cannot submit data.',
      webPosition: 'right',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color.fromARGB(255, 0, 49, 77),
      fontSize: 14,
    );
    return;
  }

  var headers = {'api-key': apiKey};
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(
      'https://api.newhorizonhm.com/api/UploadClaimsDocuments/{uid}/{OrderID}?uid=$uid&OrderID=$order_id',
    ),
  );

  request.files.add(await http.MultipartFile.fromPath('document', filepath));
  request.headers.addAll(headers);

  try {
    http.StreamedResponse response = await request.send();

    final responseString = await response.stream.bytesToString();
    print('Status Code: ${response.statusCode}');
    print('Response: $responseString');

    if (response.statusCode == 200) {
      context.loaderOverlay.hide();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Claimuserdoc(order_id: order_id),
        ),
      );
      Fluttertoast.showToast(
        msg: 'Document uploaded successfully!',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
    } else if (response.statusCode == 400) {
      // Handle bad request
      context.loaderOverlay.hide();
      AppNavigatorService.pop();
      Fluttertoast.showToast(
        msg: 'Bad request, cannot upload document!',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Something Went Wrong! Please try later',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      context.loaderOverlay.hide();
      AppNavigatorService.pop();
    }
  } catch (e) {
    print('Error: $e');
    Fluttertoast.showToast(
      msg: 'Something went wrong! Cannot submit data.',
      webPosition: 'right',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color.fromARGB(255, 0, 49, 77),
      fontSize: 14,
    );
    context.loaderOverlay.hide();
    AppNavigatorService.pop();
  }
}
