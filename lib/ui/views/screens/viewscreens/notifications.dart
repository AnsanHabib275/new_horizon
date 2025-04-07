// ignore_for_file: deprecated_member_use

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/notificationsmodel.dart';
// import 'package:new_horizon/core/services/apis/user/historycompletedorders.dart';
import 'package:new_horizon/core/services/apis/user/notifications.dart';
import 'package:new_horizon/core/services/apis/user/updatenotification.dart';

import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/utils/logcolors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/allpatients.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/chatscreenui.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/invoices.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/orders.dart';
import 'package:new_horizon/ui/widgets/datasubmissionform.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  String formatDateTime(String datetimeStr) {
    DateTime dateTime = DateTime.parse(datetimeStr);
    DateTime now = DateTime.now();

    // Calculate the difference in days
    int daysDifference = now.difference(dateTime).inDays;

    // If the notification is older than 1 day, show days instead of time
    if (daysDifference >= 1) {
      // Show the number of days since the notification
      String daysDisplay = '${daysDifference}d';
      return daysDisplay;
    } else {
      // Format hours and minutes, converting to 12-hour format
      int hour = dateTime.hour % 12;
      hour =
          hour == 0
              ? 12
              : hour; // Convert 0 hour to 12 for 12-hour clock format
      String formattedTime =
          "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

      // Add AM or PM
      String amPm = dateTime.hour >= 12 ? "PM" : "AM";
      formattedTime += " $amPm";

      return formattedTime;
    }
  }

  String truncateProductname(String name) {
    if (name.length > 30) {
      return '${name.substring(0, 30)}...';
    }
    return name;
  }

  String truncateProductdesc(String name) {
    if (name.length > 40) {
      return '${name.substring(0, 40)}...';
    }
    return name;
  }

  Future<void> refreshnotifications() async {
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
          actions: const <Widget>[],
        ),
        body: Column(
          children: [
            SizedBox(height: Get.height * 0.02),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.045),
                  child: const Text(
                    'Notifications',
                    style: TextStyle(
                      fontFamily: 'Humanist sans',
                      fontSize: 24,
                      color: appcolor.textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshnotifications,
                child: FutureBuilder<List<Notificationmodel>>(
                  future: GetNotifications.getusernotifications(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 9.0,
                              right: 9.0,
                              top: 0,
                              bottom: 7,
                            ),
                            child: Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 10, height: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: 70,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topRight: Radius.circular(
                                                        30,
                                                      ),
                                                      bottomRight:
                                                          Radius.circular(30),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: Get.height * 0.005),
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: double.infinity,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topRight: Radius.circular(
                                                        30,
                                                      ),
                                                      bottomRight:
                                                          Radius.circular(30),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Column(
                                      children: <Widget>[
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            height: 10,
                                            width: 28,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12.0,
                                          ),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 12,
                                              width: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      // If there's an error, show an error message
                      return const Center(
                        child: Text(
                          'Something went Wrong !',
                          style: TextStyle(
                            fontFamily: 'Humanist Sans',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    } else {
                      final products = snapshot.data;

                      if (products!.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 140.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AssetConstants.nofavicon),
                                const Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    'No Notifications Found',
                                    style: TextStyle(
                                      fontFamily: 'Humanist Sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              top: 0,
                              bottom: 10,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                ansiColorDisabled = false;
                                debugPrint(
                                  warning(product.notificationHeading),
                                );

                                if (product.notificationHeading.contains(
                                  'Order',
                                )) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Orders(),
                                    ),
                                  ).then((value) {
                                    UpdateNotifications.Updateusernotification(
                                      product.notificationId,
                                      context,
                                    );
                                  });
                                } else if (product.notificationHeading.contains(
                                  'Benefits',
                                )) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AllPatients(),
                                    ),
                                  ).then((value) {
                                    UpdateNotifications.Updateusernotification(
                                      product.notificationId,
                                      context,
                                    );
                                  });
                                } else if (product.notificationHeading.contains(
                                  'Invoice',
                                )) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Invoices(),
                                    ),
                                  ).then((value) {
                                    UpdateNotifications.Updateusernotification(
                                      product.notificationId,
                                      context,
                                    );
                                  });
                                } else if (product.notificationHeading.contains(
                                  'NHHM Support',
                                )) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ChatScreen(),
                                    ),
                                  ).then((value) {
                                    UpdateNotifications.Updateusernotification(
                                      product.notificationId,
                                      context,
                                    );
                                  });
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Card(
                                    color:
                                        product.isViewed
                                            ? Colors.white
                                            : const Color.fromRGBO(
                                              240,
                                              249,
                                              253,
                                              1,
                                            ),
                                    margin: EdgeInsets.zero,
                                    elevation: 2.0,
                                    child: ListTile(
                                      title: Text(
                                        capitalizeFirst(
                                          truncateProductname(
                                            product.notificationHeading,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Segoe UI',
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Text(
                                        product.notificationDetails,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Segoe UI',
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                            255,
                                            132,
                                            132,
                                            132,
                                          ),
                                        ),
                                      ),
                                      trailing: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              child: Text(
                                                formatDateTime(
                                                  product.createdAt,
                                                ),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Segoe UI',
                                                  fontSize: 11,
                                                  color: Color.fromARGB(
                                                    255,
                                                    132,
                                                    132,
                                                    132,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    product.isViewed
                                                        ? Colors.white
                                                        : const Color.fromRGBO(
                                                          87,
                                                          173,
                                                          0,
                                                          1,
                                                        ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 12,
                                              width: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
