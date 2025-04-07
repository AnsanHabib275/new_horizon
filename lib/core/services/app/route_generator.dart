// ignore_for_file: unused_element, no_duplicate_case_values, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/apis/user/history.dart';
import 'package:new_horizon/core/services/apis/user/historycompletedorders.dart';
import 'package:new_horizon/core/services/apis/user/historypendingorders.dart';
import 'package:new_horizon/ui/views/HomeScreen.dart';
import 'package:new_horizon/ui/views/screens/authscreens/authlesssplash.dart';
import 'package:new_horizon/ui/views/screens/authscreens/forgetpassword.dart';
import 'package:new_horizon/ui/views/screens/authscreens/reset_password.dart';
import 'package:new_horizon/ui/views/screens/authscreens/signin.dart';
import 'package:new_horizon/ui/views/screens/authscreens/signup.dart';
import 'package:new_horizon/ui/views/screens/authscreens/splash2.dart';
import 'package:new_horizon/ui/views/screens/authscreens/splashscreen.dart';
import 'package:new_horizon/ui/views/screens/bottomnavigationscreens/homescreen.dart';
import 'package:new_horizon/ui/views/screens/bottomnavigationscreens/menuscreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/admindocs.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/benefitpending.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/benefitverification.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/benefitverificationsuccess.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/billings.dart';
import 'package:new_horizon/ui/views/screens/bottomnavigationscreens/cartscreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/claimuserdoc.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/datasubmission.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/favorite.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/fileuploaddoc.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/notifications.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/orders.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/otpscreen.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/patientspending.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/patientsrejected.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/payments.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/personalinformation.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/products.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/uploadclaimfile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Route_paths.splash:
        return MaterialPageRoute<Splashscreen>(
            builder: (_) => const Splashscreen());

      case Route_paths.splash2:
        return MaterialPageRoute<Splash2>(builder: (_) => const Splash2());
      case Route_paths.signup:
        return MaterialPageRoute<SignUpScreen>(
            builder: (_) => const SignUpScreen());

      case Route_paths.home:
        return MaterialPageRoute<SignIn>(builder: (_) => const HomeScreen());

      case Route_paths.bottomhome:
        return MaterialPageRoute<SignIn>(builder: (_) => BottomHomeScreen());

      case Route_paths.signin:
        return MaterialPageRoute<SignIn>(builder: (_) => const SignIn());

      case Route_paths.personalinformation:
        if (settings.arguments is double) {
          return MaterialPageRoute<PersonalInformation>(
              builder: (_) => PersonalInformation(
                    totalprice: settings.arguments as double,
                    verifiedPatients: [],
                  ));
        }
        // Handle the case where no argument is provided or the argument is of a different type.
        throw ArgumentError(
            'The PersonalInformation route requires a totalprice argument of type double.');

      case Route_paths.payments:
        return MaterialPageRoute<PaymentsScreen>(
            builder: (_) => const PaymentsScreen());

      case Route_paths.forgetpassword:
        return MaterialPageRoute<Forgetpassword>(
            builder: (_) => const Forgetpassword());

      case Route_paths.resetpassword:
        return MaterialPageRoute<Resetpassword>(
            builder: (_) => const Resetpassword(
                  email: '',
                ));

      case Route_paths.products:
        return MaterialPageRoute<Products>(builder: (_) => const Products());

      case Route_paths.addtocart:
        return MaterialPageRoute<CartScreen>(builder: (_) => CartScreen());

      case Route_paths.datasubmission:
        return MaterialPageRoute<DataSubmisiion>(
            builder: (_) => const DataSubmisiion());

      case Route_paths.menuscreen:
        return MaterialPageRoute<MenuScreen>(
            builder: (_) => const MenuScreen());

      case Route_paths.pendingverification:
        return MaterialPageRoute<BenefitPending>(
            builder: (_) => const BenefitPending());

      case Route_paths.orders:
        return MaterialPageRoute<Orders>(builder: (_) => const Orders());

      case Route_paths.authlesssplash:
        return MaterialPageRoute<authlesssplash>(
            builder: (_) => const authlesssplash());

      // case Route_paths.benefitsverficationsuccess:
      //   return MaterialPageRoute<BenefitVerifcationDetails>(
      //       builder: (_) => const BenefitVerifcationDetails());

      case Route_paths.history:
        return MaterialPageRoute<History>(builder: (_) => const History());
      case Route_paths.historypending:
        return MaterialPageRoute<HistoryPendingorders>(
            builder: (_) => const HistoryPendingorders());
      case Route_paths.historycompleted:
        return MaterialPageRoute<Historycompletedorders>(
            builder: (_) => const Historycompletedorders());

      case Route_paths.billing:
        return MaterialPageRoute<Claims>(builder: (_) => const Claims());

      case Route_paths.otpscreen:
        return MaterialPageRoute<Otpscreen>(builder: (_) => const Otpscreen());

      case Route_paths.favorite:
        return MaterialPageRoute<Favorite>(builder: (_) => const Favorite());

      case Route_paths.benefitverification:
        return MaterialPageRoute<benefitsverification>(
            builder: (_) => const benefitsverification(
                  benefitsData: [],
                ));
      case Route_paths.uploaddoc:
        return MaterialPageRoute<FileUploadDoc>(
            builder: (_) => FileUploadDoc());

      case Route_paths.patientspending:
        return MaterialPageRoute<PatientsPending>(
            builder: (_) => PatientsPending());

      case Route_paths.patientsrejected:
        return MaterialPageRoute<PatientsRejected>(
            builder: (_) => PatientsRejected());

      case Route_paths.adminDocs:
        return MaterialPageRoute<AdminDocuments>(
            builder: (_) => AdminDocuments());

      case Route_paths.claimuserDocs:
        return MaterialPageRoute<Claimuserdoc>(
            builder: (_) => Claimuserdoc(
                  order_id: '',
                ));

      case Route_paths.claimuploadDoc:
        return MaterialPageRoute<ClaimFileUpload>(
            builder: (_) => ClaimFileUpload(
                  order_id: '',
                ));

      case Route_paths.notifications:
        return MaterialPageRoute<NotificationScreen>(
            builder: (_) => NotificationScreen());

      case Route_paths.bvsuccessscreen:
        return MaterialPageRoute<Successcreen>(builder: (_) => Successcreen());
    }

    return MaterialPageRoute(builder: (_) => const Splash2());
  }
}
