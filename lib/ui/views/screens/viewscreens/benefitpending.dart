import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';

class BenefitPending extends StatefulWidget {
  const BenefitPending({super.key});

  @override
  State<BenefitPending> createState() => _BenefitPendingState();
}

class _BenefitPendingState extends State<BenefitPending> {
  @override
  void initState() {
    super.initState();
    setState(() {
      context.loaderOverlay.hide();
    });
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: Get.height * 0.05),
              child: Center(
                child: Image.asset(AssetConstants.pendingverification),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Get.width * 0.02),
              child: const Text(
                ' Your Request is \nunder processing',
                style: TextStyle(
                  fontFamily: 'Humanist sans',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
