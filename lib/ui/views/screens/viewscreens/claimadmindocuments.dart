// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_const_constructors, unused_local_variable, avoid_print, prefer_interpolation_to_compose_strings, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/userclaimdocument.dart';
import 'package:new_horizon/core/services/apis/user/retrieveclaimuserdocuments.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/claimuserdoc.dart';
import 'package:url_launcher/url_launcher.dart';

class ClaimAdminDocs extends StatefulWidget {
  String order_id;
  ClaimAdminDocs({super.key, required this.order_id});

  @override
  State<ClaimAdminDocs> createState() => _ClaimAdminDocsState();
}

var heights = Get.height;
var widths = Get.width;
bool isLoading = true;
String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

class _ClaimAdminDocsState extends State<ClaimAdminDocs> {
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
              icon: const Icon(Icons.arrow_back_ios_new_outlined,
                  size: 20, color: Colors.black), // Change the color here
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Claim Documents',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[],
          ),
          body: Column(children: [
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Claimuserdoc(
                                          order_id: widget.order_id.toString(),
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              ' User Docs  ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 12 : 14,
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            // AppNavigatorService.navigateToReplacement(
                            //     Route_paths.adminDocs);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '  Admin Docs  ',
                                style: TextStyle(
                                  color: appcolor.textColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Segoe UI',
                                  fontSize:
                                      heights <= 690 && widths <= 430 ? 12 : 14,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            // Inside your main widget
            Expanded(
              child: FutureBuilder<DocumentsUserResponse>(
                future: RetreiveClaimdocumentapi.retreivedocApi(
                    context, widget.order_id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AssetConstants.nopendicon),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'No Documents Found',
                              style: TextStyle(
                                  fontFamily: 'Humanist Sans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ));
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.adminDocs.isEmpty) {
                      // Show a message if the adminDocs list is empty
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AssetConstants.nopendicon),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'No Documents Found',
                                style: const TextStyle(
                                    fontFamily: 'Humanist Sans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ));
                    } else {
                      // If the list is not empty, display it in PdfFileListView
                      return PdfFileListView(
                          pdfFiles: snapshot.data!.adminDocs);
                    }
                  } else {
                    return Center(child: Text('No PDF files found'));
                  }
                },
              ),
            )
          ])),
    );
  }
}

String truncateProductName(String name) {
  if (name.length > 17) {
    return name.substring(0, 17) + '.';
  }
  return name;
}

class PdfFileListView extends StatelessWidget {
  final List<UserDocument> pdfFiles;

  const PdfFileListView({Key? key, required this.pdfFiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the width of each item based on the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 4 * 17.0) / 3;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14.0,
        childAspectRatio: (itemWidth / 110),
      ),
      itemCount: pdfFiles.length,
      itemBuilder: (context, index) {
        var pdfFile = pdfFiles[index];
        var url = pdfFile.url;
        // Extract the file name from the URL
        var fileName =
            url.substring(url.lastIndexOf('/') + 1, url.lastIndexOf('.pdf'));

        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                print(url);
                final Uri uri = Uri.parse(url);
                if (!await launchUrl(uri)) {
                  print('Could not launch $uri');
                }
              },
              child: Container(
                height: heights <= 690 && widths <= 430 ? 80 : 90,
                width: heights <= 690 && widths <= 430 ? 80 : 90,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(233, 233, 233, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Center(child: SvgPicture.asset(AssetConstants.pdficon)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                truncateProductName(fileName),
                style: TextStyle(
                    fontFamily: 'Humanist Sans',
                    fontSize: heights <= 690 && widths <= 430 ? 10 : 12,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        );
      },
    );
  }
}
