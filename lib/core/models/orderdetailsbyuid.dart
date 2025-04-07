// ignore_for_file: non_constant_identifier_names

class Product {
  final String id;
  final String name;
  final String description;
  final String type;
  final String image;
  final int price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      image: json['image'][0],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

class Order {
  final String orderEmail;
  final String orderId;
  final String orderDate;
  final String firstName;
  final String lastName;
  final String invoiceid;
  final String orderstatus;
  final String image;
  final String name;
  final String quantity;
  final String shipping_address;
  final String billing_address;
  final String phonenumber;
  final String price;
  final String city;
  final String country;
  final String postalcode;
  final String practice;
  final String providerr;
  final String dateofservice;
  final String trackingno;
  final int totalprice;
  final String note;

  final List<Product> products;

  Order({
    required this.orderEmail,
    required this.orderId,
    required this.providerr,
    required this.dateofservice,
    required this.orderDate,
    required this.firstName,
    required this.lastName,
    required this.invoiceid,
    required this.orderstatus,
    required this.image,
    required this.name,
    required this.note,
    required this.quantity,
    required this.shipping_address,
    required this.billing_address,
    required this.phonenumber,
    required this.price,
    required this.products,
    required this.city,
    required this.country,
    required this.trackingno,
    required this.postalcode,
    required this.practice,
    required this.totalprice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    String defaultImageUrl =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png';
    String imageUrl = defaultImageUrl;
    String defaultName = '---';
    String defaultQuantity = '0';
    String defaultPrice = '0';

    if (json['Products'] != null && json['Products'].isNotEmpty) {
      var firstProduct = json['Products'][0];
      defaultName = firstProduct['name'] ?? '---';
      defaultQuantity = firstProduct['quantity'].toString();
      defaultPrice = firstProduct['price'].toString();
    }

    if (json['Products'] != null &&
        json['Products'].isNotEmpty &&
        json['Products'][0]['image'] != null &&
        json['Products'][0]['image'].isNotEmpty) {
      imageUrl = json['Products'][0]['image'][0];
    }
    return Order(
      providerr: json['provider'] ?? '---',
      dateofservice: json['date_of_service'] ?? '---',
      orderEmail: json['order_email'] ?? '---',
      orderId: json['order_id'] ?? '---',
      totalprice: json['total_price'] ?? '---',
      orderDate: json['order_date'] ?? '---',
      postalcode: json['postal_code'] ?? '---',
      firstName: json['first_name'] ?? '---',
      lastName: json['last_name'] ?? '---',
      trackingno: json['tracking_no'] ?? '---',
      note: json['note'] ?? '---',
      country: json['state'] ?? '---',
      invoiceid: json['invoice_id'] ?? '---',
      shipping_address: json['shipping_address'] ?? '---',
      billing_address: json['billing_address'] ?? '---',
      phonenumber: json['phone_number'] ?? '---',
      orderstatus: json['order_status'] ?? '---',
      city: json['city'] ?? '---',
      image: imageUrl,
      practice: json['practice'] ?? '---',
      // name: json['Products'][0]['name'] ?? '---',
      name: defaultName,

      // quantity: json['Products'][0]['quantity'].toString(),
      quantity: defaultQuantity,

      // price: json['Products'][0]['price'].toString(),
      price: defaultPrice,

      products: (json['Products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
    );
  }
}
