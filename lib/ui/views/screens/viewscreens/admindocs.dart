// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_const_constructors, unused_local_variable, avoid_print, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/document.dart';
import 'package:new_horizon/core/services/apis/user/retrievedocuments.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/documents.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminDocuments extends StatefulWidget {
  const AdminDocuments({super.key});

  @override
  State<AdminDocuments> createState() => _AdminDocumentsState();
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

class _AdminDocumentsState extends State<AdminDocuments> {
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
                  size: 20, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Documents',
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
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Documents()));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '  User Docs  ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 12 : 14,
                              ),
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {},
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
              child: FutureBuilder<DocumentsResponse>(
                future: Retreivedocumentapi.retreivedocApi(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                              'Something went wong',
                              style: const TextStyle(
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ));
                    } else {
                      if (snapshot.data!.adminDocs.isEmpty) {
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
                                      fontSize: heights <= 690 && widths <= 430
                                          ? 14
                                          : 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ));
                      } else {
                        return PdfFileListView(
                            pdfFiles: snapshot.data!.adminDocs);
                      }
                    }
                  } else {
                    return const Center(child: Text('No PDF files found'));
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
  final List<Document> pdfFiles;

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
                if (kDebugMode) {
                  print(url);
                }
                final Uri uri = Uri.parse(url);
                if (!await launchUrl(uri)) {
                  print('Could not launch $uri');
                }
              },
              child: Container(
                height: 90,
                width: 90,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(233, 233, 233, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Center(child: SvgPicture.asset(AssetConstants.pdficon)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                truncateProductName(fileName),
                style: const TextStyle(
                    fontFamily: 'Humanist Sans',
                    fontSize: 12,
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
