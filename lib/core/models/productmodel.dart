// ignore_for_file: non_constant_identifier_names

class Product {
  final String name;
  final String type;
  final String description;
  final double price;
  final String imageUrl;
  final String product_id;
  final bool isFavorite;

  Product({
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.product_id,
    required this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['product_name'].trim(),
        type: json['Product_type'],
        description: json['Product_description'],
        price: (json['price'] as num).toDouble(),
        imageUrl: json['Image_Url'][0], // Take the first image URL
        product_id: json['product_id'],
        isFavorite: json[('isFavorite')]);
  }
}
