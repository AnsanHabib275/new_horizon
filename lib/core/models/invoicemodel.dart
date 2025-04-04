class InvoiceModel {
  final String invoiceId;
  final String invoiceDate;
  final String dueDate;
  final String invoiceStatus;
  final double totalPrice;
  final String invoicename;
  final String orderEmail;
  final String orderId;
  final String orderDate;
  final String orderStatus;
  final String firstName;
  final String practice;
  final String lastName;
  final String shippingAddress;
  final String billingAddress;
  final String city;
  final String paymentMethod;
  final String postalCode;
  final String phoneNumber;

  final String providerr;
  final String dateofservice;
  final String country;
  final String billingFirstName;
  final String billingLastName;
  final String billingCity;
  final String billingPostalCode;
  final String billingPhoneNumber;
  final List<ProductModel> products;

  InvoiceModel({
    required this.invoiceId,
    required this.invoiceDate,
    required this.dueDate,
    required this.invoiceStatus,
    required this.totalPrice,
    required this.invoicename,
    required this.orderEmail,
    required this.orderId,
    required this.orderDate,
    required this.providerr,
    required this.dateofservice,
    required this.orderStatus,
    required this.firstName,
    required this.practice,
    required this.lastName,
    required this.shippingAddress,
    required this.billingAddress,
    required this.city,
    required this.paymentMethod,
    required this.postalCode,
    required this.phoneNumber,
    required this.country,
    required this.billingFirstName,
    required this.billingLastName,
    required this.billingCity,
    required this.billingPostalCode,
    required this.billingPhoneNumber,
    required this.products,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceId: json['invoice_id'] ?? "---",
      invoiceDate: json['invoice_date'],
      dueDate: json['due_date'],
      invoiceStatus: json['invoice_status'],
      totalPrice: json['total_price'].toDouble(),
      invoicename: json['invoice_name'],
      orderEmail: json['order_email'],
      orderId: json['order_id'],
      orderDate: json['order_date'],
      providerr: json['provider'] ?? "---",
      dateofservice: json['date_of_service'] ?? '---',
      orderStatus: json['order_status'],
      firstName: json['first_name'],
      practice: json['practice'] ?? "---",
      lastName: json['last_name'] ?? "---",
      shippingAddress: json['shipping_address'],
      billingAddress: json['billing_address'],
      city: json['city'],
      paymentMethod: json['payment_method'],
      postalCode: json['postal_code'],
      phoneNumber: json['phone_number'],
      country: json['country'],
      billingFirstName: json['billing_first_name'],
      billingLastName: json['billing_last_name'],
      billingCity: json['billing_city'],
      billingPostalCode: json['billing_postal_code'],
      billingPhoneNumber: json['billing_phone_number'],
      products: (json['Products'] as List)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList(),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final List<String> images;
  final double price;
  final int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.images,
    required this.price,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      images: List<String>.from(json['image']),
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }
}
