// ignore_for_file: implementation_imports, sort_child_properties_last, prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/core/services/app/route_generator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:new_horizon/ui/utils/colors.dart';

import 'core/localization/languages.dart';

class App extends StatelessWidget {
  final String initialRoute;

  const App({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: ((context, orientation, screenType) {
        return GlobalLoaderOverlay(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: const Locale('en', 'US'),
            fallbackLocale: const Locale('en', 'US'),
            navigatorKey: AppNavigatorService.navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: initialRoute,
            theme: ThemeData(
              useMaterial3: false,
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: appcolor.textColor,
                  ),
            ),
          ),
          useDefaultLoading: false,
          overlayWidgetBuilder: (_) {
            return Center(
              child: SpinKitFoldingCube(
                color: appcolor.textColor,
                size: 80.0,
              ),
            );
          },
          overlayColor: const Color.fromARGB(156, 0, 0, 0),
          duration: const Duration(seconds: 1),
        );
      }),
      maxTabletWidth: 900,
      maxMobileWidth: 1200,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
