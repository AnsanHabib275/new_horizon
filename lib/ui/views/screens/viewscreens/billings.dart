// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unused_label

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/claims.dart';
import 'package:new_horizon/core/services/apis/user/getclaimdetailsbyuid.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/claimdetails.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/services/app/app_navigator_service.dart';

class Claims extends StatefulWidget {
  const Claims({super.key});

  @override
  State<Claims> createState() => _ClaimsState();
}

String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

class _ClaimsState extends State<Claims> {
  final TextEditingController? editTextController = TextEditingController();
  TextEditingController textController = TextEditingController();
  List<PatientBillingInfo>? claimsList;
  bool isLoading = true;

  Future<void> refreshClaimsData() async {
    isLoading = true;
    setState(() {});
    await loadClaims();
    setState(() {});
  }

  refreshClaimsDat() async {
    setState(() {});
    await loadClaims();
    setState(() {});
  }

  List<PatientBillingInfo>? filteredClaimsList;
  String? errorMessage;

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredClaimsList = claimsList;
    } else {
      filteredClaimsList = claimsList?.where((claim) {
        return claim.patientName.toLowerCase().contains(query.toLowerCase()) ||
            claim.company.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  Future<List<PatientBillingInfo>> funct() async {
    return await GetClaimDetails.getClaimDetails();
  }

  Future<void> loadClaims() async {
    try {
      var fetchedClaims = await GetClaimDetails.getClaimDetails();
      setState(() {
        claimsList = fetchedClaims;
        filteredClaimsList = fetchedClaims;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            'Hang Tight! We are trying to resolve the issue at our end.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    filteredClaimsList = claimsList;
    loadClaims();
  }

  @override
  Widget build(BuildContext context) {
    resizeToAvoidBottomInset:
    false;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () => AppNavigatorService.pop(),
            ),
            actions: <Widget>[
              SizedBox(
                width: Get.width * 0.015,
              ),
              SearchBarAnimation(
                textEditingController: textController,
                isOriginalAnimation: false,
                searchBoxWidth: Get.width - 110,
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
                      'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
                },
                trailingWidget: GestureDetector(
                  child: const Icon(
                    // Icons.close,
                    // size: 20,
                    // color: Colors.black,
                    Icons.search,
                    size: 20,
                    color: Colors.black,
                  ),
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
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: Get.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.04),
                    child: const Text(
                      ' All Claims',
                      style: TextStyle(
                          fontFamily: 'Humanist sans',
                          fontSize: 20,
                          color: appcolor.textColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refreshClaimsData,
                  child: buildClaimsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClaimsList() {
    if (errorMessage != null) {
      // return Center(child: Text(errorMessage!));
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
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ));
    }
    var currentList = isLoading ? [] : filteredClaimsList ?? claimsList;

    if (isLoading) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 9.0, right: 9.0, top: 0, bottom: 7),
            child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.grey[300],
                          width: 85,
                          height: 85,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 70,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
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
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            height: 18,
                            width: 28,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 22,
                              width: 62,
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
      ); // Function to build loading list
    } else if (currentList == null || currentList.isEmpty) {
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
                'No Claims Found',
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
      return ListView.builder(
        itemCount: currentList.length,
        itemBuilder: (context, index) {
          var claim = currentList[index];
          return ClaimCard(
            claimorderid: claim.orderId,
            patientName: claim.patientName,
            company: claim.company,
            billedAmount: claim.amountBilled.toString(),
            status: claim.claimStatus,
            patientBillingInfo: claim,
            onClaimsUpdated: refreshClaimsDat,
          );
        },
      );
    }
  }
}

class ClaimCard extends StatefulWidget {
  final String claimorderid;
  final String patientName;
  final String company;

  final String billedAmount;
  final String status;

  final PatientBillingInfo patientBillingInfo;
  final Function onClaimsUpdated;

  const ClaimCard(
      {Key? key,
      required this.claimorderid,
      required this.patientName,
      required this.company,
      required this.billedAmount,
      this.status = 'Complete',
      required this.patientBillingInfo,
      required this.onClaimsUpdated})
      : super(key: key);

  @override
  State<ClaimCard> createState() => _ClaimCardState();
}

class _ClaimCardState extends State<ClaimCard> {
  // void refreshClaimsData() async {

  //   setState(() {

  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ClaimDetails(
                patientBillingInfo: widget.patientBillingInfo,
                onClaimsUpdated: widget.onClaimsUpdated,
              ),
            ),
          );
        },
        child: Card(
          elevation: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
                    color: Color.fromRGBO(233, 244, 250, 1),
                    width: 85,
                    height: 85,
                    child: Center(
                      child: Text(
                        widget.claimorderid,
                        style: TextStyle(
                          color: Color.fromRGBO(3, 111, 173, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.patientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.015),
                      Text(
                        widget.company,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Segoe UI',
                          fontSize: 13,
                          color: Color.fromARGB(255, 164, 164, 164),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 14),
                    child: Text(
                      widget.billedAmount != 'Not Paid'
                          ? '\$${widget.billedAmount}'
                          : widget.billedAmount,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: Color.fromARGB(255, 42, 42, 42),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 18),
                    child: Container(
                      height: 22,
                      width: 82,
                      color: Color.fromRGBO(111, 187, 245, 0.4),
                      child: Center(
                        child: Text(
                            capitalizeFirstLetter(widget.status.toLowerCase()),
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Segoe UI',
                              fontSize: 11,
                              color: Color.fromRGBO(3, 111, 173, 1),
                            )),
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
  }
}
