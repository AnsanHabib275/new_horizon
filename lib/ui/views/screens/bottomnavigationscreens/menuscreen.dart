// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print, sort_child_properties_last, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/apis/auth/deleteaccount.dart';
import 'package:new_horizon/core/services/userpreferences/userpreference.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/allpatients.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/chatscreenui.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/documents.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/invoices.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/locator.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/app/app_navigator_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

String? username;
String? email;
var heights = Get.height;
var widths = Get.width;

class _MenuScreenState extends State<MenuScreen> {
  Future<void> getusername() async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedName = prefs.getString('name');
    final fetchedemail = prefs.getString('email');
    setState(() {
      username = fetchedName;
      email = fetchedemail;
    });
  }

  @override
  void initState() {
    super.initState();
    getusername();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: Get.height * 0.07,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Get.height * 0.03, top: Get.height * 0.034),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.black,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.person_2_outlined),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.03,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min, // Set this property
                        children: [
                          Text(
                            '$username',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Segoe UI',
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min, // Set this property
                        children: [
                          Text(
                            '$email',
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: 'Segoe UI',
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const Divider(),
            SizedBox(
              height: 45,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print(items[index].text); // Print the name of the item
                      if (items[index].onTapCallback != null) {
                        items[index].onTapCallback!(context);
                      }
                    },
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: Get.width * 0.03,
                            right: Get.width * 0.03,
                            bottom: Get.width * 0.01),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(233, 244, 250, 1),
                          ),
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                items[index].icon != null
                                    ? Icon(items[index].icon,
                                        color: Colors.blue)
                                    : items[index].svg!,
                                SizedBox(width: 12),
                                Text(items[index].text,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 0, 109, 172),
                                        fontFamily: 'Segoe UI',
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        )),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}

class ListItem {
  final IconData? icon;
  final SvgPicture? svg;
  final String text;
  final void Function(BuildContext)? onTapCallback;

  ListItem.icon(this.icon, this.text, this.onTapCallback) : svg = null;
  ListItem.svg(this.svg, this.text, this.onTapCallback) : icon = null;
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController emails = TextEditingController();
void validateAndSave(BuildContext context) async {
  final FormState? form = _formKey.currentState;
  if (form != null && form.validate()) {
    Deleteaccount_Api.deleteaccountapi(context, emails.text);
    showAlertDialog(context, "Deleting All Details...");
    print("ok");
  } else {
    Fluttertoast.showToast(
      msg: 'Invalid Email',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print('Email is invalid');
  }
}

final List<ListItem> items = [
  ListItem.svg(SvgPicture.asset(AssetConstants.dashboard), 'Dashboard',
      (context) {
    AppNavigatorService.pushNamed(Route_paths.home);
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.benefitsverification),
      'Benefit Verification', (context) async {
    AppNavigatorService.pushNamed(Route_paths.datasubmission);
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.favicon), 'Favorites',
      (context) {
    AppNavigatorService.pushNamed(Route_paths.favorite);
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.prod), 'Products', (context) {
    AppNavigatorService.pushNamed(Route_paths.products);
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.patients), 'Patients',
      (context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AllPatients()));
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.historry), 'History',
      (context) async {
    context.loaderOverlay.show();
    AppNavigatorService.pushNamed(Route_paths.historypending);
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.orderr), 'Orders', (context) {
    AppNavigatorService.pushNamed(Route_paths.orders);
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.invoices), 'Invoices',
      (context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Invoices()));
  }),
  ListItem.svg(
      SvgPicture.asset(AssetConstants.documents), 'Submitted Documents',
      (context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Documents()));
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.chatadmin), 'Chat with Admin',
      (context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChatScreen()));
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.locatorsvg), 'Locator',
      (context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Locator()));
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.pay), 'Payments', (context) {
    AppNavigatorService.pushNamed(Route_paths.payments);
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.deleteaccount), 'Delete Account',
      (context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 305,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                            child: SvgPicture.asset(
                          AssetConstants.deleteaccount,
                          height: 35,
                          width: 35,
                        )),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Form(
                          // key: _formKey,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0),
                                child: TextFormField(
                                  autocorrect: false,
                                  autofocus: false,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) => (value!.isEmpty ||
                                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                              .hasMatch(value)
                                      ? 'Email not Valid'
                                      : null),
                                  onChanged: (text) {
                                    // print('text $text');
                                    // print(email.text);
                                  },
                                  controller: emails,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: appcolor.textColor)),
                                    hintText: "Email",
                                    labelText: "Email",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                  ),
                                ),
                              )),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Are you sure you want to  Delete? ",
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: heights <= 690 && widths <= 430 ? 12 : 14,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 10.0, right: 10),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: TextButton(
                                  child: Text("  Delete  ".toUpperCase(),
                                      textScaleFactor: 1,
                                      style: const TextStyle(fontSize: 12)),
                                  style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.all(11)),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              appcolor.textColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              side: BorderSide(color: appcolor.textColor)))),
                                  onPressed: () {}),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20, bottom: 10.0, right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Humanist Sans',
                                      fontSize: 16),
                                ),
                                Container(
                                    height: 35.5,
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 0, 16.0, 0),
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          Color.fromARGB(255, 2, 104, 163),
                                          Color(0xFF6FBBF5)
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: TextButton(
                                      onPressed: () {
                                        AppNavigatorService.pop();
                                      },
                                      child: const Text(
                                        'Cancel',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Humanist Sans'),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }),
  ListItem.svg(SvgPicture.asset(AssetConstants.logout), 'Logout',
      (context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                          child: SvgPicture.asset(
                        AssetConstants.logout,
                        height: 35,
                        width: 35,
                      )),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Do you really wish to Logout?",
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: heights <= 690 && widths <= 430 ? 12 : 14,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 10.0, right: 10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: TextButton(
                                child: Text("  Logout  ".toUpperCase(),
                                    textScaleFactor: 1,
                                    style: const TextStyle(fontSize: 12)),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(11)),
                                    foregroundColor: MaterialStateProperty.all<Color>(
                                        appcolor.textColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            side: BorderSide(
                                                color: appcolor.textColor)))),
                                onPressed: () {
                                  showAlertDialog(context, "Loging Out");

                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    await UserPreferences().clearCredentials();
                                  });
                                }),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, bottom: 10.0, right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Humanist Sans',
                                    fontSize: 16),
                              ),
                              Container(
                                  height: 35.5,
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 0, 16.0, 0),
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color.fromARGB(255, 2, 104, 163),
                                        Color(0xFF6FBBF5)
                                      ]),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: TextButton(
                                    onPressed: () {
                                      AppNavigatorService.pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Humanist Sans'),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }),
];
