class PatientBillingInfo {
  final String orderId;
  final String patientName;
  final String provider;
  final String dateOfService;
  final String primaryInsurance;
  final String dateBilled;
  // final double amountBilled;
  final String datePaid;
  // final double amountPaid;
  final String company;
  final String claimStatus;
  final List<BillingProduct> billingProducts;
  final List<UserDoc> userDocs;
  final List<AdminDoc> adminDocs;
  final String amountBilled; // As String
  final String amountPaid; // As String

  PatientBillingInfo({
    required this.orderId,
    required this.patientName,
    required this.provider,
    required this.dateOfService,
    required this.primaryInsurance,
    required this.dateBilled,
    required this.amountBilled,
    required this.datePaid,
    required this.amountPaid,
    required this.company,
    required this.claimStatus,
    required this.billingProducts,
    required this.userDocs,
    required this.adminDocs,
  });

  factory PatientBillingInfo.fromJson(Map<String, dynamic> json) {
    return PatientBillingInfo(
      orderId: json['order_id'],
      patientName: json['patient_name'] ?? '---',
      provider: json['provider'] ?? '--',
      dateOfService: json['date_of_service'] ?? '---',
      primaryInsurance: json['primary_insurance'] ?? '---',
      dateBilled: json['date_billed'] ?? '---',
      amountBilled:
          json['amount_billed'] != null && (json['amount_billed'] as num) != 0.0
              ? '${json['amount_billed'] as num}'
              : 'Not Paid',
      datePaid: json['date_paid'] ?? '---',
      amountPaid:
          json['amount_paid'] != null && (json['amount_paid'] as num) != 0.0
              ? '${json['amount_paid'] as num}'
              : 'Not Paid',
      company: json['company'] ?? "---",
      claimStatus: json['claim_status'] ?? "---",
      billingProducts: (json['BillingProducts'] as List)
          .map((e) => BillingProduct.fromJson(e))
          .toList(),
      userDocs:
          (json['userDocs'] as List).map((e) => UserDoc.fromJson(e)).toList(),
      adminDocs:
          (json['adminDocs'] as List).map((e) => AdminDoc.fromJson(e)).toList(),
    );
  }
}

class BillingProduct {
  final String id;
  final String name;
  final String description;
  final String type;
  final List<String> images;
  final double price;
  final int quantity;

  BillingProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.images,
    required this.price,
    required this.quantity,
  });

  factory BillingProduct.fromJson(Map<String, dynamic> json) {
    return BillingProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      images: List<String>.from(json['image']),
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }
}

class UserDoc {
  final String documentId;
  final String url;
  final String uploadDate;

  UserDoc({
    required this.documentId,
    required this.url,
    required this.uploadDate,
  });

  factory UserDoc.fromJson(Map<String, dynamic> json) {
    return UserDoc(
      documentId: json['document_id'],
      url: json['url'],
      uploadDate: json['upload_date'],
    );
  }
}

class AdminDoc {
  final String documentId;
  final String url;
  final String uploadDate;

  AdminDoc({
    required this.documentId,
    required this.url,
    required this.uploadDate,
  });

  factory AdminDoc.fromJson(Map<String, dynamic> json) {
    return AdminDoc(
      documentId: json['document_id'],
      url: json['url'],
      uploadDate: json['upload_date'],
    );
  }
}
