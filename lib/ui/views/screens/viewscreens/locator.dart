// ignore_for_file: deprecated_member_use, avoid_print, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unused_local_variable, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/Alldoctors.dart';
import 'package:new_horizon/core/services/apis/user/getalldoctors.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/bottomnavigationscreens/menuscreen.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

void _showMapOptions(BuildContext context, lat, long) {
  showCupertinoModalPopup(
    barrierColor: const Color.fromARGB(115, 0, 0, 0),
    barrierDismissible: true,
    semanticsDismissible: false,
    context: context,
    builder:
        (BuildContext context) => CupertinoTheme(
          data: const CupertinoThemeData(
            applyThemeToAll: true,
            brightness: Brightness.dark,
            barBackgroundColor: Color.fromARGB(255, 0, 0, 0),
          ),
          child: CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('Open in Maps'),
                onPressed: () {
                  Navigator.pop(context);
                  _launchMap('apple', lat, long);
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Open in Google Maps'),
                onPressed: () {
                  Navigator.pop(context);
                  _launchMap('google', lat, long);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ),
        ),
  );
}

void _launchMap(String mapType, lat, long) async {
  String url = '';
  if (mapType == 'google') {
    url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  } else if (mapType == 'apple') {
    url = 'https://maps.apple.com/?q=$lat,$long';
  }
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

List<Widget> buildStars() {
  List<Widget> stars = [];
  for (int i = 0; i < 5; i++) {
    stars.add(const Icon(Icons.star, color: Colors.yellow));
  }
  return stars;
}

_callNumber(String mobile) async {
  // await FlutterPhoneDirectCaller.callNumber(mobile);
}

class Locator extends StatefulWidget {
  const Locator({super.key});

  @override
  State<Locator> createState() => _LocatorState();
}

class _LocatorState extends State<Locator> {
  TextEditingController textController = TextEditingController();
  List<AllDoctors>? doctorsList;
  List<AllDoctors>? filteredPatientsList;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> refreshPatients() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      var fetchedPatients = await GetAllDoctors.GetDoctors(context);
      setState(() {
        doctorsList = fetchedPatients;
        isLoading = false;
      });
    } catch (e) {
      print(e.toString()); // Add this to see the error
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
        // 'Hang Tight! We are trying to resolve the issue at our end.';
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredPatientsList = doctorsList;
    } else {
      filteredPatientsList =
          doctorsList?.where((doctors) {
            return doctors.clinic_name.toLowerCase().contains(
              query.toLowerCase(),
            );
          }).toList();
    }
    setState(() {});
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
            'Locator',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          actions: const <Widget>[],
        ),
        body: Column(
          children: [
            SearchBarAnimation(
              textEditingController: textController,
              isOriginalAnimation: false,
              searchBoxWidth: Get.width - 17,
              isSearchBoxOnRightSide: true,
              searchBoxBorderColour: Colors.transparent,
              buttonBorderColour: Colors.transparent,
              enableButtonShadow: false,
              onChanged: (val) {
                filterSearchResults(val);
              },
              enableKeyboardFocus: true,
              onExpansionComplete: () {},
              onCollapseComplete: () {
                textController.clear();
                filterSearchResults('');
              },
              onPressButton: (isSearchBarOpens) {
                debugPrint(
                  'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation',
                );
              },
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshPatients,
                child: buildDoctorsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDoctorsList() {
    var currentList = isLoading ? [] : filteredPatientsList ?? doctorsList;

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AssetConstants.nofavicon),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    fontFamily: 'Humanist Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isLoading) {
      return buildLoadingList();
    }

    if (currentList == null || currentList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AssetConstants.nofavicon),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'No Clinics Found',
                  style: TextStyle(
                    fontFamily: 'Humanist Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Map<String, dynamic>> items =
        doctorsList!.map((doctor) => doctor.toJson()).toList();
    items.forEach((item) {
      assert(item['state'] != null, 'State is null for an item');
    });

    return GroupedListView<Map<String, dynamic>, String>(
      elements: items,
      groupBy: (element) => element['state'] ?? 'unknown',
      groupSeparatorBuilder:
          (String groupByValue) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  groupByValue,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: appcolor.textColor,
                  ),
                ),
              ),
            ),
          ),
      itemBuilder: (context, Map<String, dynamic> element) {
        return DoctorsCard(
          clinic_name: element['clinic_name'],
          contact: element['contact'],
          imageUrls: element['image_url'],
          latitude: element['latitude'],
          longitude: element['longitude'],
        );
      },
      itemComparator:
          (item1, item2) =>
              item1['clinic_name'].compareTo(item2['clinic_name']),
      order: GroupedListOrder.ASC,
    );
  }
}

Widget buildLoadingList() {
  return const DoctorsCardShimmer();
}

class DoctorsCard extends StatelessWidget {
  final String clinic_name;
  final String contact;
  final String imageUrls;
  final double latitude;
  final double longitude;

  const DoctorsCard({
    super.key,
    required this.clinic_name,
    required this.contact,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
  });

  String formatTime(String time24hr) {
    int hour = int.parse(time24hr.split(":")[0]);
    int minute = int.parse(time24hr.split(":")[1]);
    String amPm = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    hour = hour != 0 ? hour : 12; // Convert 00 to 12 for 12 AM

    String minuteStr = minute.toString().padLeft(2, '0'); // Ensure two digits
    return "$hour:$minuteStr $amPm";
  }

  String truncateProductName(String name) {
    if (name.length > 45) {
      return '${name.substring(0, 44)}..';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    // String imageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            imageUrls.toString(),
                            width: heights <= 690 && widths <= 430 ? 60 : 75,
                            height: heights <= 690 && widths <= 430 ? 60 : 75,
                            fit: BoxFit.cover,
                            errorBuilder: (
                              BuildContext context,
                              Object exception,
                              StackTrace? stackTrace,
                            ) {
                              return Container(
                                color: const Color.fromARGB(255, 240, 250, 255),
                                width:
                                    heights <= 690 && widths <= 430 ? 60 : 85,
                                height:
                                    heights <= 690 && widths <= 430 ? 60 : 90,
                                child: const Center(
                                  child: Text(
                                    'Not Found',
                                    style: TextStyle(
                                      fontFamily: 'Humanist Sans',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Container(
                            height:
                                heights <= 690 && widths <= 430
                                    ? Get.height * 0.04
                                    : Get.height * 0.045,
                            // width: Get.width * 0.24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              gradient: const LinearGradient(
                                colors: [
                                  appcolor.textColor,
                                  appcolor.textColor,
                                ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (Platform.isIOS) {
                                  _showMapOptions(context, latitude, longitude);
                                } else {
                                  MapsLauncher.launchCoordinates(
                                    latitude,
                                    longitude,
                                    'USA'.toString().trim(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions_outlined,
                                    size:
                                        heights <= 690 && widths <= 430
                                            ? 15
                                            : 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Directions',
                                    style: TextStyle(
                                      fontFamily: 'Humanist Sans',
                                      fontSize:
                                          heights <= 690 && widths <= 430
                                              ? 7.5
                                              : 12.7,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: heights <= 690 && widths <= 430 ? 6 : 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Container(
                            height:
                                heights <= 690 && widths <= 430
                                    ? Get.height * 0.04
                                    : Get.height * 0.045,
                            // width: Get.width * 0.24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              gradient: const LinearGradient(
                                colors: [
                                  appcolor.textColor,
                                  appcolor.textColor,
                                ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                _callNumber(
                                  'tel:+1${contact.toString().trim()}',
                                );
                                print('object');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.call,
                                    size:
                                        heights <= 690 && widths <= 430
                                            ? 15
                                            : 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Contact Us',
                                    style: TextStyle(
                                      fontFamily: 'Humanist Sans',
                                      fontSize:
                                          heights <= 690 && widths <= 430
                                              ? 7.5
                                              : 12.7,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Text(
                        truncateProductName(clinic_name.toString().trim()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: heights <= 690 && widths <= 430 ? 10 : 17,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Text(
                        '4.9',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 115, 115, 115),
                          fontSize: heights <= 690 && widths <= 430 ? 10 : 16,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      for (int i = 0; i < 5; i++)
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: heights <= 690 && widths <= 430 ? 10 : 13,
                        ),
                      const SizedBox(width: 4),
                      Text(
                        '(5.6k)',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 155, 155, 155),
                          fontSize: heights <= 690 && widths <= 430 ? 9 : 14,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Text(
                        'Open ',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 115, 115, 115),
                          fontSize: heights <= 690 && widths <= 430 ? 9 : 16,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Closes ',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 115, 115, 115),
                          fontSize: heights <= 690 && widths <= 430 ? 9 : 16,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '+1${contact.toString().trim()}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 155, 155, 155),
                          fontSize: heights <= 690 && widths <= 430 ? 9 : 15,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_2_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        // Wrap your Text widget with Flexible
                        child: Text(
                          clinic_name.toString().trim(),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 115, 115, 115),
                            fontSize: heights <= 690 && widths <= 430 ? 10 : 15,
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorsCardShimmer extends StatelessWidget {
  const DoctorsCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    double imageWidth = width <= 690 && height <= 430 ? 60 : 75;
    double imageHeight = width <= 690 && height <= 430 ? 60 : 75;
    double buttonHeight =
        width <= 690 && height <= 430 ? height * 0.04 : height * 0.045;
    double textSize = width <= 690 && height <= 430 ? 10 : 15;

    return ListView.builder(
      itemCount: 4,
      scrollDirection: Axis.vertical,
      itemBuilder:
          (BuildContext context, int index) => Container(
            width: 140,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: imageWidth,
                              height: imageHeight,
                            ),
                          ),
                          Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: buttonHeight,
                                  width: 100,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: buttonHeight,
                                  width: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(height: 12),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: textSize,
                              width: Get.width - 150,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const SizedBox(height: 12),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: textSize,
                              width: Get.width - 70,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const SizedBox(height: 12),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: textSize,
                              width: Get.width - 70,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
