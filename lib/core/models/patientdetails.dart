class BenefitDetails {
  final String entryDate;
  final String dateOfService;
  final String dateOfBirth;
  final String firstName;
  final String lastName;
  final String provider;
  final String insuranceCarrier;
  final String status;
  final int policyNumber;
  final String diagnosis;
  final String requestedTreatment;
  final String? secondaryInsuranceUrl;
  final String? secondaryPolicyNumberUrl;
  final String? idUrl;
  final String? insuranceCardUrl;
  final String? referralAndOfficeNoteUrl;
  final String bvId;
  final String company;
  final String approvedFor;
  final String validTill;

  BenefitDetails({
    required this.entryDate,
    required this.dateOfService,
    required this.dateOfBirth,
    required this.firstName,
    required this.lastName,
    required this.provider,
    required this.insuranceCarrier,
    required this.status,
    required this.policyNumber,
    required this.diagnosis,
    required this.requestedTreatment,
    this.secondaryInsuranceUrl,
    this.secondaryPolicyNumberUrl,
    this.idUrl,
    this.insuranceCardUrl,
    this.referralAndOfficeNoteUrl,
    required this.bvId,
    required this.company,
    required this.approvedFor,
    required this.validTill,
  });

  factory BenefitDetails.fromJson(Map<String, dynamic> json) {
    return BenefitDetails(
      entryDate: json['entry_date'] ?? '---',
      dateOfService: json['date_of_service'] ?? '---',
      dateOfBirth: json['date_of_birth'] ?? '---',
      firstName: json['first_name'] ?? '---',
      lastName: json['last_name'] ?? '---',
      provider: json['provider'] ?? '---',
      insuranceCarrier: json['insurance_carrier'] ?? '---',
      status: json['Status'] ?? '---',
      policyNumber: json['policy_number'] ?? '---',
      diagnosis: json['diagnosis'] ?? '---',
      requestedTreatment: json['requested_treatment'] ?? '---',
      secondaryInsuranceUrl: json['secondary_insurance_url'] ?? '---',
      secondaryPolicyNumberUrl: json['secondary_policy_number_url'] ?? '---',
      idUrl: json['id_url'] ?? '---',
      insuranceCardUrl: json['insurance_card_url'] ?? '---',
      referralAndOfficeNoteUrl: json['referral_and_office_note_url'] ?? '---',
      bvId: json['bv_id'] ?? '---',
      company: json['company'] ?? '---',
      approvedFor: json['aprroved_for'] ?? '---',
      validTill: json['valid_till'] ?? '---',
    );
  }
}
