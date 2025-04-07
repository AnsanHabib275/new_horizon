// ignore_for_file: non_constant_identifier_names
class CartProduct {
  final String imageUrl;
  final String name;
  final double price;
  final String product_Id;
  int quantity;

  CartProduct({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.product_Id,
    required this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      imageUrl: (json['image_url'] is List && json['image_url'].isNotEmpty)
          ? json['image_url'][0]
          : "",
      product_Id: (json['product_id'] ?? ""),
      name: (json['product_name'] ?? "").trim(),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }
}
