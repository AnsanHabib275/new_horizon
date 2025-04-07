// ignore_for_file: camel_case_types, sized_box_for_whitespace, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, unused_local_variable, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/models/benefitdetail.dart';
import 'package:new_horizon/ui/utils/colors.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/datasubmission2.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/details.dart';

import '../../../../core/services/app/app_navigator_service.dart';

class benefitsverification extends StatefulWidget {
  final List<dynamic> benefitsData;
  const benefitsverification({super.key, required this.benefitsData});

  @override
  State<benefitsverification> createState() => _benefitsverificationState();
}

class _benefitsverificationState extends State<benefitsverification> {
  TextEditingController textController = TextEditingController();
  Future<List<BenefitDetail>>? futureBenefits;
  List<BenefitDetail>? allBenefits;
  List<BenefitDetail>? filteredBenefits;

  var heights = Get.height;
  var widths = Get.width;
  void searchBenefits() {
    String searchTerm = textController.text;
    if (searchTerm.isEmpty) {
      setState(() {
        filteredBenefits = allBenefits; // If search is empty, show all benefits
      });
    } else {
      setState(() {
        filteredBenefits = allBenefits!
            .where((benefit) => benefit.name.contains(searchTerm))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize allBenefits with the data from widget.benefitsData
    allBenefits = widget.benefitsData
        .map((data) => BenefitDetail(
            imageUrl: data['id_url'] as String?,
            name: data['first_name'],
            date: data['entry_date'],
            lname: data['last_name'],
            company: data['company'],
            approved_for: data['aprroved_for'] ?? "---",
            valid_until: data['valid_till'] ?? "---",
            diagnosisStatus: data['diagnosis'],
            bvId: data['bv_id'],
            date_of_service: data['date_of_service'],
            insurance_carrier: data['insurance_carrier'],
            provider: data['provider'],
            status: data['Status'],
            dob: data['date_of_birth'],
            policyno: data['policy_number']))
        .toList();

    // Filter the benefits for only those with the status "PENDING" or "VERIFIED"
    filteredBenefits =
        allBenefits!.where((benefit) => benefit.status == "PENDING").toList();

    textController.addListener(searchBenefits);
  }

  @override
  void dispose() {
    textController.removeListener(searchBenefits);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined,
                    size: 20, color: Colors.black), // Change the color here
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Benefit Verification',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Column(
              children: [
                heights <= 685 && widths <= 415
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: Get.width * 0.024, top: 6),
                            child: const Text(
                              '',
                              style: TextStyle(
                                  fontFamily: 'Humanist sans',
                                  fontSize: 18,
                                  color: appcolor.textColor),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 6.0),
                          //   child: Container(
                          //     height: 45,
                          //     child: AnimSearchBar(
                          //       onSubmitted: (p0) {},
                          //       searchIconColor: Colors.grey,
                          //       rtl: true,
                          //       suffixIcon: const Icon(
                          //         Icons.search,
                          //         color: Color.fromARGB(255, 88, 88, 88),
                          //       ),
                          //       width: 180,
                          //       prefixIcon: const Icon(
                          //         Icons.search_outlined,
                          //         color: Color.fromARGB(255, 88, 88, 88),
                          //       ),
                          //       textController: textController,
                          //       onSuffixTap: () {
                          //         setState(() {
                          //           textController.clear();
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: Get.width * 0.028, top: 0),
                            child: const Text(
                              '',
                              style: TextStyle(
                                  fontFamily: 'Humanist sans',
                                  fontSize: 19,
                                  color: appcolor.textColor),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 8.0),
                          //   child: Container(
                          //     height: 50,
                          //     child: AnimSearchBar(
                          //       onSubmitted: (p0) {},
                          //       searchIconColor: Colors.grey,
                          //       rtl: true,
                          //       suffixIcon: const Icon(
                          //         Icons.search,
                          //         color: Color.fromARGB(255, 88, 88, 88),
                          //       ),
                          //       width: 220,
                          //       autoFocus: false,
                          //       prefixIcon: const Icon(
                          //         Icons.search_outlined,
                          //         color: Color.fromARGB(255, 88, 88, 88),
                          //       ),
                          //       textController: textController,
                          //       onSuffixTap: () {
                          //         setState(() {
                          //           textController.clear();
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(right: Get.width * 0.02, top: 30),
                      child: const Text(
                        '',
                        style: TextStyle(
                            fontFamily: 'Humanist sans',
                            fontSize: 19,
                            color: appcolor.textColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        height: Get.height * 0.045,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(colors: [
                              appcolor.textColor,
                              appcolor.textColor,
                            ])),
                        child: ElevatedButton(
                          onPressed: () async {
                            AppNavigatorService.pushNamed(
                                Route_paths.datasubmission);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent),
                          child: const Text(
                            'Add New',
                            style: TextStyle(fontFamily: 'Segoe UI'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (filteredBenefits == null) {
                        return const Text("");
                      } else if (filteredBenefits!.isEmpty) {
                        return const Text(
                          "No record found",
                          style: TextStyle(color: Colors.grey),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: filteredBenefits!.length,
                          itemBuilder: (context, index) {
                            return BenefitsCard(
                              imageUrl:
                                  'https://images.unsplash.com/photo-1494253109108-2e30c049369b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHJhbmRvbXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80',
                              name: filteredBenefits![index].name,
                              date: filteredBenefits![index].date,
                              diagnosisStatus:
                                  filteredBenefits![index].diagnosisStatus,
                              bvId: filteredBenefits![index]
                                  .bvId, // <-- Pass the bvId
                              status: filteredBenefits![index].status,
                              policy_number: filteredBenefits![index].policyno,
                              lname: filteredBenefits![index].lname,
                              dob: filteredBenefits![index].dob,
                              company: filteredBenefits![index].company,
                              date_of_service:
                                  filteredBenefits![index].date_of_service,
                              approved_for:
                                  filteredBenefits![index].approved_for,
                              valid_till: filteredBenefits![index].valid_until,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

Color? getStatusColor(String status, {bool forText = false}) {
  switch (status.toLowerCase()) {
    case 'pending':
      return forText ? Colors.red : Colors.red[100];
    case 'verified':
      return forText
          ? Color.fromRGBO(87, 173, 0, 1)
          : Color.fromRGBO(87, 173, 0, 0.2);
    case 'rejected':
      return forText ? Colors.grey : Colors.grey[300];
    case 'shipped':
      return forText
          ? const Color.fromARGB(255, 138, 138, 139)
          : Colors.blue[100];
    default:
      return null;
  }
}

class BenefitsCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lname;
  final String date;
  final String diagnosisStatus;
  final String dob;
  final String bvId;
  final String company;
  final String status;
  final String date_of_service;
  final String approved_for;
  final String valid_till;
  final int policy_number;

  const BenefitsCard({
    required this.imageUrl,
    required this.name,
    required this.lname,
    required this.date,
    required this.diagnosisStatus,
    required this.bvId,
    required this.status,
    required this.date_of_service,
    required this.dob,
    required this.company,
    required this.policy_number,
    required this.approved_for,
    required this.valid_till,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (status == 'VERIFIED') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BenefitVerifcationDetails(
                        data: bvId,
                        date: date,
                        fname: name,
                        lname: lname,
                        provider: '',
                        insurance_carrier: '',
                        policy_number: policy_number,
                        diagnosis: diagnosisStatus,
                        dob: dob,
                        status: status,
                        date_of_service: date_of_service,
                        aprroved_for: approved_for,
                        valid_until: valid_till,
                        company: company,
                      ),
                    ),
                  );
                } else if (status == 'REJECTED') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataSubmisiion2(data: bvId),
                    ),
                  );
                }
              },
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 1.21,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Padding(
                    //   padding: const EdgeInsets.all(0),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(0),
                    //     child: Container(
                    //       color: Color.fromRGBO(233, 244, 250, 1),
                    //       width: 85,
                    //       height: 82,
                    //       child: Center(
                    //           child: Text(
                    //         "# " + policy_number.toString(),
                    //         style: TextStyle(
                    //             color: Color.fromRGBO(3, 111, 173, 1),
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 13),
                    //       )),
                    //     ),
                    //   ),
                    // ),
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
                            "#  98934",
                            style: TextStyle(
                                color: Color.fromRGBO(3, 111, 173, 1),
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: Get.height * 0.01),
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Segoe UI',
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text(
                              formatDate(date),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: Color.fromARGB(255, 103, 103, 103),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: Get.height * 0.01),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              diagnosisStatus,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.016),
                          Padding(
                            padding: const EdgeInsets.only(right: 0.0, top: 2),
                            child: Container(
                              height: 20,
                              width: 55,
                              color: getStatusColor(status),
                              child: Center(
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Segoe UI',
                                    fontSize: 11,
                                    color:
                                        getStatusColor(status, forText: true),
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
