// ignore_for_file: non_constant_identifier_names

class BenefitDetail {
  final String? imageUrl;
  final String name;
  final String date;
  final String diagnosisStatus;
  final String bvId;
  final String status;
  final String company;
  final String lname;
  final String date_of_service;
  final String provider;
  final String insurance_carrier;
  final String approved_for;
  final String valid_until;
  final int policyno;
  final String dob;

  BenefitDetail(
      {this.imageUrl,
      required this.name,
      required this.date,
      required this.diagnosisStatus,
      required this.bvId,
      required this.status,
      required this.company,
      required this.lname,
      required this.policyno,
      required this.dob,
      required this.date_of_service,
      required this.insurance_carrier,
      required this.approved_for,
      required this.valid_until,
      required this.provider});
}
