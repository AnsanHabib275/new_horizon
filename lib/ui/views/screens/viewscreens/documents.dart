// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_const_constructors, unused_local_variable, avoid_print, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/models/document.dart';
import 'package:new_horizon/core/services/apis/user/retrievedocuments.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/services/app/app_navigator_service.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

var heights = Get.height;
var widths = Get.width;

String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

class _DocumentsState extends State<Documents> {
  List<Document> documents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      var newDocumentsResponse =
          await Retreivedocumentapi.retreivedocApi(context);
      if (mounted) {
        setState(() {
          documents = newDocumentsResponse.userDocs;
          isLoading = false; // Update loading state
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error fetching documents: $e');
    }
  }

  Future<void> refreshDocuments() async {
    await fetchDocuments();
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
              icon: const Icon(Icons.arrow_back_ios_new_outlined,
                  size: 20, color: Colors.black), // Change the color here
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
                                '  User Docs  ',
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
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            AppNavigatorService.navigateToReplacement(
                                Route_paths.adminDocs);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '  Admin Docs  ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Segoe UI',
                                fontSize:
                                    heights <= 690 && widths <= 430 ? 12 : 14,
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Container(
                      height: Get.height * 0.042,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: const LinearGradient(colors: [
                            appcolor.textColor,
                            appcolor.textColor,
                          ])),
                      child: ElevatedButton(
                        onPressed: () async {
                          AppNavigatorService.navigateToReplacement(
                              Route_paths.uploaddoc);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent),
                        child: Row(
                          children: [
                            Icon(
                              Icons.upload,
                              size: heights <= 690 && widths <= 430 ? 14 : 20,
                            ),
                            SizedBox(
                              width: heights <= 690 && widths <= 430 ? 3 : 6,
                            ),
                            const Text(
                              'Upload',
                              style: TextStyle(fontFamily: 'Segoe UI'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshDocuments,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : documents.isNotEmpty
                        ? PdfFileListView(pdfFiles: documents)
                        : buildNoDocumentsView(),
              ),
            ),
          ])),
    );
  }
}

Widget buildNoDocumentsView() {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 1,
      mainAxisSpacing: 14.0,
      childAspectRatio: (10 / 20),
    ),
    itemCount: 1,
    itemBuilder: (context, index) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
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
        ),
      );
    },
  );
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
                height: heights <= 690 && widths <= 430 ? 70 : 90,
                width: heights <= 690 && widths <= 430 ? 70 : 90,
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
                    fontSize: heights <= 690 && widths <= 430 ? 9 : 12,
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
