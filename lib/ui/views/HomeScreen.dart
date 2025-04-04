// // ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, prefer_if_null_operators, unused_field, prefer_const_constructors_in_immutables, deprecated_member_use, prefer_const_literals_to_create_immutables, non_constant_identifier_names, file_names, avoid_print

// import 'package:ansicolor/ansicolor.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:new_horizon/core/constants/asset_constants.dart';
// import 'package:new_horizon/core/services/userpreferences/notification_services.dart';

// import 'package:new_horizon/ui/utils/colors.dart';
// import 'package:new_horizon/ui/utils/logcolors.dart';
// import 'package:new_horizon/ui/views/screens/bottomnavigationscreens/menuscreen.dart';
// import 'package:new_horizon/ui/views/screens/viewscreens/cartscreen.dart';
// import 'screens/bottomnavigationscreens/homescreen.dart';

// class HomeScreen extends StatefulWidget {
//   final int initialIndex;
//   const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   NotificationServices notificationServices = NotificationServices();

//   @override
//   void initState() {
//     super.initState();
//     notificationServices.setupInteractMessage(context);
//     notificationServices.requestNotificationPermission();
//     notificationServices.forgroundMessage();
//     notificationServices.firebaseInit(context);
//     notificationServices.isTokenRefresh();
//     notificationServices.requestNotificationPermission();
//     notificationServices
//         .getDeviceToken()
//         .then((value) => print(value.toString()));
//     index = widget.initialIndex;

//     Future.delayed(Duration(seconds: 4), () {
//       // log('working');
//       ansiColorDisabled = false;
//       debugPrint(success('✅ Success'));
//     });
//   }

//   final items = [
//     SvgPicture.asset(
//       AssetConstants.homeicon,
//       width: 22,
//       height: 22,
//     ),
//     SvgPicture.asset(
//       AssetConstants.shoppingcart,
//       width: 22,
//       height: 22,
//     ),
//     SvgPicture.asset(
//       AssetConstants.menu,
//       width: 20,
//       height: 20,
//     ),
//   ];

//   int index = 0;

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (index != 0) {
//           setState(() {
//             index = 0; // set index to 0
//           });
//           return false; // prevent the screen from being popped
//         }
//         return true; // allow the default pop action
//       },
//       child: Scaffold(
//         bottomNavigationBar: CurvedNavigationBar(
//           color: appcolor.textColor,
//           buttonBackgroundColor: appcolor.textColor,
//           items: items,
//           index: index,
//           onTap: (selctedIndex) {
//             setState(() {
//               index = selctedIndex;
//             });
//           },
//           height: 66.5,
//           backgroundColor: Colors.white,
//           animationDuration: const Duration(milliseconds: 300),
//           // animationCurve: ,
//         ),
//         body: Container(
//             color: appcolor.textWhite,
//             width: double.infinity,
//             height: double.infinity,
//             alignment: Alignment.center,
//             child: _onTap(index)),
//       ),
//     );
//   }

//   Widget _onTap(int Index) {
//     Widget widget;
//     switch (Index) {
//       case 0:
//         widget = BottomHomeScreen();
//         break;
//       case 1:
//         widget = CartScreen();
//         break;
//       case 2:
//         widget = const MenuScreen();
//         break;
//       default:
//         widget = BottomHomeScreen();
//         break;
//     }
//     return widget;
//   }
// }

// class ImageIconAsset extends StatelessWidget {
//   final String assetName;
//   final Color? color;
//   final double size;
//   ImageIconAsset(this.assetName, {super.key, this.color, this.size = 24.0});
//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(
//       assetName,
//       color: color,
//       width: size,
//       height: size,
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, prefer_if_null_operators, unused_field, prefer_const_constructors_in_immutables, deprecated_member_use, prefer_const_literals_to_create_immutables, non_constant_identifier_names, file_names, avoid_print, unused_element

import 'package:ansicolor/ansicolor.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/services/userpreferences/notification_services.dart';

import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/utils/logcolors.dart';
import 'package:new_horizon/ui/views/screens/bottomnavigationscreens/menuscreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/cartcontroller.dart';
import 'package:new_horizon/ui/views/screens/bottomnavigationscreens/cartscreen.dart';
import 'screens/bottomnavigationscreens/homescreen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.setupInteractMessage(context);
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.isTokenRefresh();
    notificationServices.requestNotificationPermission();
    notificationServices
        .getDeviceToken()
        .then((value) => print(value.toString()));
    index = widget.initialIndex;

    Future.delayed(Duration(seconds: 4), () {
      // log('working');
      ansiColorDisabled = false;
      debugPrint(success('✅ Success'));
    });

    final CartController controller1 = Get.put(CartController());
    controller1.loadCartProducts();
  }

  final items = [
    SvgPicture.asset(
      AssetConstants.homeicon,
      width: 22,
      height: 22,
    ),
    SvgPicture.asset(
      AssetConstants.shoppingcart,
      width: 22,
      height: 22,
    ),
    SvgPicture.asset(
      AssetConstants.menu,
      width: 20,
      height: 20,
    ),
  ];

  int index = 0;

  // List of screens for each tab
  final List<Widget> screens = [
    BottomHomeScreen(),
    CartScreen(),
    MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (index != 0) {
          setState(() {
            index = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          color: appcolor.textColor,
          buttonBackgroundColor: appcolor.textColor,
          items: items,
          index: index,
          onTap: (selctedIndex) {
            setState(() {
              index = selctedIndex;
            });
          },
          height: 66.5,
          backgroundColor: Colors.white,
          animationDuration: const Duration(milliseconds: 300),
        ),
        body: Container(
            color: appcolor.textWhite,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: IndexedStack(
              index: index,
              children: screens,
            )),
      ),
    );
  }

  Widget _onTap(int Index) {
    Widget widget;
    switch (Index) {
      case 0:
        widget = BottomHomeScreen();
        break;
      case 1:
        widget = CartScreen();
        break;
      case 2:
        widget = const MenuScreen();
        break;
      default:
        widget = BottomHomeScreen();
        break;
    }
    return widget;
  }
}

class ImageIconAsset extends StatelessWidget {
  final String assetName;
  final Color? color;
  final double size;
  ImageIconAsset(this.assetName, {super.key, this.color, this.size = 24.0});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetName,
      color: color,
      width: size,
      height: size,
    );
  }
}
