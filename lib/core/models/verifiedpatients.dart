// ignore_for_file: non_constant_identifier_names

class VerifiedPatient {
  final String bvId;
  final String name;
  final int policyNumber;
  final String date_of_service;

  VerifiedPatient(
      {required this.bvId,
      required this.name,
      required this.policyNumber,
      required this.date_of_service});

  factory VerifiedPatient.fromJson(Map<String, dynamic> json) {
    return VerifiedPatient(
      bvId: json['bv_id'] as String,
      name: json['name'] as String,
      date_of_service: json['date_of_service'] ?? "---",
      policyNumber: json['policy_number'] as int,
    );
  }
}
